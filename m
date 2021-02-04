Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3D330F885
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238103AbhBDQvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:51:42 -0500
Received: from mail-eopbgr60078.outbound.protection.outlook.com ([40.107.6.78]:15142
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237114AbhBDQu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:50:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIR0G9C98XjuGiG0RShGyY3Uy/MBqmzxku60sS5lZScG6C9HILjkEUyC0s6mV+YAbgEkMFYarJS2TXHrYyF5nhfFqM8+Pjcy0H1B6+tUiZt6uKO3MvfO/V5ON+VTmv61WrAjUjMidP3lHCU3GDuc9yThqU1FYAROTen4LnYftIP+8Z0cTcfnUoTKLvuokhl8X5hrKEG/eJjaK+43X8ajqPs6KM+0tLcX9xlsP/oP+0AzhqSIIh+bYbE+bIQseO0okR0ashm7jzZyJEqY0Aox5T91JVNHNSDW4Dddbqc/4iRF5IFkjJXzQuhbIXwrt+1twqv3st+dFuA7RrsNe5GjbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmHNZQyxkSOIhhq0FbansZ98Mh6qSvu1ebr+zRW6z94=;
 b=WexcQ5ONV2yr5gZuWGztBsRLGT03cK0LEmeMVzuh5ljtnjPppirk6vfmQ1R8Cey4Ic7eSWRq7tKYXwAGgufGP7Bx4NF8XvM4jy4lXDQW8LGv541/TZ+x5XyPLnhi+QRXXhv//rlC/fmlpcXqJDUF2gQbliIh2n2URz/mBpKE3Gez8m/vSdukl3FMuSw6gRT7zS01mp2F3dguzC+AUy5r1Og498k/2jIToyjf6iqyiXyVkpcQ03Z78H3A5rT++gKfIKAputNJBTFun04ywJiH7m1R4R6eiCu4DT/hZzaLETgHEekH694Ofk0YibmJSNsEePb0ts8j1+pjaSXWjQpX5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmHNZQyxkSOIhhq0FbansZ98Mh6qSvu1ebr+zRW6z94=;
 b=ZjnHdG3a08pKSzn3QLvZl0sHFZuBZ7xr6iXOK6W8pg5NOhvJ7EhIjpiYBqzM/GoJhXkzthlEiKoItqIK4PXf8d6bg7aZJg4DW7UUF8Zcvju+KaJi3nZV/GVd0nVo8iBcK0UxOyRU0sNYE8C2tsGoJvEb9H6dB/HdzBMkferCfm4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0402MB3454.eurprd04.prod.outlook.com (2603:10a6:803:a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.22; Thu, 4 Feb
 2021 16:50:10 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4%7]) with mapi id 15.20.3805.027; Thu, 4 Feb 2021
 16:50:10 +0000
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, davem@davemloft.net, maciej.fijalkowski@intel.com
Cc:     madalin.bucur@oss.nxp.com, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net v2 0/3] dpaa_eth: A050385 erratum workaround fixes under XDP
Date:   Thu,  4 Feb 2021 18:49:25 +0200
Message-Id: <cover.1612456902.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: FR2P281CA0026.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::13) To VI1PR04MB5807.eurprd04.prod.outlook.com
 (2603:10a6:803:ec::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15136.swis.ro-buh01.nxp.com (83.217.231.2) by FR2P281CA0026.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.10 via Frontend Transport; Thu, 4 Feb 2021 16:50:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 25bc3832-0734-4de8-0e00-08d8c92ceed8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3454FB86DFCF729C3E91DA40F2B39@VI1PR0402MB3454.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+XS3fomfZd1lQZwV5b+yv3m8rd4DbTU5zczeLSdD0KADw44DdyVOTMXALw6aYyv3KbzqGvFEN4SEZ2LISNPgPlnfgGn0aiR7hOSSBP0Zm4NSA9Hx8EbfRXFB4lh0jZttsZ7fHXp0/wWNuKFXrlfkKg3Bep1KxIr/BAOTN3/fzTVRyrz/Y4qHNFGJv82Bl7XUtJ4ztVqJDsaVW0K6tjMgrlkhGLvPtXMQe4Pzmwqz3/CcO/5AtAp3Y8/ci1USdcj2BgworYwndFDAaYB0XRyO5xEWwVWFL/3JKaV2pUZo1cNAHriQ556unEIUrQVyL938iVDQ8/FoJu0VaZFnuqQlLITGT2/qurukkcUui7/gbt6hG3WQJaUxTJZ1HXup2FodRa3qK0FlNjLOebgPFBVL0OUPPy3OJ3kJUkm8kiOOItEsmXHSRaM8nRbUjrj2PPoAyoIvhRYxIcMJIeTbYclpmHxnMmefTLgsAI3u5fFTTBzo3MpXSk7Wb6/wf/xYc8Q60y5soRl8HrU3wLnVpl5ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(66476007)(956004)(4326008)(66556008)(6666004)(2616005)(6486002)(2906002)(52116002)(66946007)(44832011)(5660300002)(478600001)(36756003)(26005)(16526019)(186003)(8936002)(8676002)(316002)(7696005)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?izSsQZa55AqhRDJBQGTTnRwltON86e6a6ql5jKKZ7j0ojkSRfv/ChnMFWryO?=
 =?us-ascii?Q?OMyuwYAtW0vBkmyx6uOrB42jrLlMm5eg/Bucqy3roM5Ncwwrpb72WhUoFQ05?=
 =?us-ascii?Q?sQgfKtJhbEsn9aVSD+j8P6sl2XEPD4vR16C9a+ICNWxow57x6DBNrUZxI55N?=
 =?us-ascii?Q?PeZbOVq0R41JwQoieZRkf5sSnjQV2nrVqLecO1KVrNC5hxyU36Cumyv+Fhli?=
 =?us-ascii?Q?QlZGFtVXMwuy84qSyrA79IZQ+wsm5pKv7VSNqT3UaBabIPpuieYw3hbpTMLs?=
 =?us-ascii?Q?6m/MxEmCKQt57ei7TZkaQVeuZwtfy7ArZMU3noAxYRkTEiMGHsSqnZzJUg9V?=
 =?us-ascii?Q?KnjH84kdWeRhKXf5byQNe4I2lY91iyPGf5o6NhGzQGcvhjfrqX2mW5g5wJA7?=
 =?us-ascii?Q?gA9q/VNeaZ8E3BZGrDHat4eXX5OL3GQK8jUwcJwiXOgoXgqEtCp85YHZITx8?=
 =?us-ascii?Q?/LJBaeR8nWeeVNutWNm/Du9HzbpMFV+mUO5HSACSM3lX5r7zWNxVX1W6Dvi+?=
 =?us-ascii?Q?BSou6N9EByzvR19iTIZ2+T5oQqi+JC5Tegz8lB/c1bxUsvErnXrBcXa2Btn7?=
 =?us-ascii?Q?xhJ1Vt8DI8ucbV6sAKUcW9T59BOfd5e8UZqlJ+qjGgqSqVfo0jGLAjIYieiD?=
 =?us-ascii?Q?aAcLkjBJpx2J/eMDP7KVKJnmJ/Cu3kRDktfOFu2HhriCAyGSaJriMRwihWsy?=
 =?us-ascii?Q?27zYBjjlbowSCReZo8pS2Ilv3GVwW7RkYUbBKgtn8cq98bINQXnDmWhJKx1w?=
 =?us-ascii?Q?OSbpLnRFkezTV86JYfWjZ2QiwxJ1C668PsSoaWO2YYCj0xgK4WFSXB6u/71m?=
 =?us-ascii?Q?q5XgtyxLFK3Qoq2ZXhYtgcf6UKSMH70aUJqfpqMKI/OtwANSUIXcgWma+AsG?=
 =?us-ascii?Q?xKJsmitilX54XF2KPgFXy2ZeO7Vc1XOP+XGkrOBBCGFWGlv9yxFJQMj3FxCW?=
 =?us-ascii?Q?hisTR4pciGVzzRAfhImBBMo4ULN1pbLyvYhZTOE40QEY/C7Qv9SGGY3jeEsd?=
 =?us-ascii?Q?AKuiGpDF6PT8sNWFLH/YlopqXmqPoq733bx8L2sOZT/NT+FLLNxxufPXHsTE?=
 =?us-ascii?Q?BSGpG64VusJ1giXLjTjC0YrOdauXji5EAQNk7Wm9Wg/6aK6AAchMSRp/FME1?=
 =?us-ascii?Q?tMMV/wOv4UnPQOwQsv4Pv9v0fit690BSmtAU2EXAJdlX/8uCJFCkTWpHqRA+?=
 =?us-ascii?Q?s5GKdaAvFlahrf5thBOGZZgjABW1nudl4sOzERL2VrfeK4R5YSrcIdnfFBHV?=
 =?us-ascii?Q?Wb3EsZqLscHcHEl+zOsvga6/OTmcUzpQIqm+t5sKR5APQqMSRKTH++VvtDdi?=
 =?us-ascii?Q?E9/EYFZLwutDUnDeiIQYTWLV?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25bc3832-0734-4de8-0e00-08d8c92ceed8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 16:50:09.9693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1D9tz2tQ/klx0HZcGkpuKummWSdeYS37CK7sgAJZPTWoEM+3ldVAs8rCvhjqloF79IsI+gAhipD8+P7L6YcciA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3454
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series addresses issue with the current workaround for the A050385
erratum in XDP scenarios.

The first patch makes sure the xdp_frame structure stored at the start of
new buffers isn't overwritten.

The second patch decreases the required data alignment value, thus
preventing unnecessary realignments.

The third patch moves the data in place to align it, instead of allocating
a new buffer for each frame that breaks the alignment rules, thus bringing
an up to 40% performance increase. With this change, the impact of the
erratum workaround is reduced in many cases to a single digit decrease, and
to lower double digits in single flow scenarios.

Changes in v2:
- guarantee enough tailroom is available for the shared_info in 1/3

Camelia Groza (3):
  dpaa_eth: reserve space for the xdp_frame under the A050385 erratum
  dpaa_eth: reduce data alignment requirements for the A050385 erratum
  dpaa_eth: try to move the data in place for the A050385 erratum

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 42 +++++++++++++++++--
 1 file changed, 38 insertions(+), 4 deletions(-)

--
2.17.1

