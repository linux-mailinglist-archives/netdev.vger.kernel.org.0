Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5105F2FBE2A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389631AbhASRqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:46:12 -0500
Received: from mail-eopbgr80121.outbound.protection.outlook.com ([40.107.8.121]:58206
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731743AbhASPJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:09:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLeKan18oKQb8nciKF4V1m3IyDUEBv3dL06A73zAWytA4rpygijcZtdHwCiFzc3HqFgsx3P45eA7BDN05kfYm851L19fe6m91EiL7KcUqlSFuImZAvVKJTQ2gkwCB0oc8SVuajQbSnSaONoAXBNhWmDAK/b1/RPD1g8ucsogeWzZD34QQDS921VWQD6dcwXcHTGCxM/m2jj15rkdFJg8YXruRxwJYHGTlD36EfdQWtXyICZqWEbhZV/YDtwZOJCuA+BmhoAgEOsxV4NLCSnlPgI/LBULfkv+4ROc777TaqmhxXSLLwcGTMx3BT50sxGQDSb0oI/a6PUD9bOisqndEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOxMP4ELDr2V/bVNpERFu26fPHMSeyFchlhj3vE2sFw=;
 b=MZ40xfoDz+lLbK5Im48g7Jz1e2pRyhwNgCiWzWgNBaj9JNk6ZLVaYcveM1cY8erR8VSW93gVHKOoR/y8FQCPPgzt7wHvQuEW9t1ASSsRmdzp5s95qonLxParW03Dlxj/2ckcy0dj1oBSja0CdJDcKO9jWQ2zyzjAqdTXuwHEKmyAIZiRR+zFwhvXgKQM9JB3emuQRNZT4IAlMRmh/6n1ad26FX1EK2r3A/BEQjkQlc17Jf/0NJMBFzhJHj8gesyKVuDxbP2eQwdrvRYAvOxADQMm8MyRUtVMcGZOXhTlFt6uWkV3omXinMR85alKV8NEf3vCatS2/1Qak6SRT++Zlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOxMP4ELDr2V/bVNpERFu26fPHMSeyFchlhj3vE2sFw=;
 b=hLbs2JLAF+VhNk2NtI86c1UM13pxlUtZlKe8JsyGijC8Hf13q2VkUB9G0FI8IHsafeoHQewvKdl3iDugoSL+n7WsFYVhkvKyju/GHIjNOzO+2fwkpNTryZsiyKgcyB9DT+Ls0hGBPkt1UAR0LsoYoCnCMvqJlwJm+m4yYNtsFY8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 15:09:01 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:00 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 00/17] ucc_geth improvements
Date:   Tue, 19 Jan 2021 16:07:45 +0100
Message-Id: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24d6913f-5b9a-4f57-35fc-08d8bc8c26cf
X-MS-TrafficTypeDiagnostic: AM0PR10MB1922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB19224F13B6641F891FDBC94C93A30@AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MOewmtUxjBGBzcrJFWCtOhP+NswTY/twSiSC169TEagge31EXhdIkmmQvcPG9yDGJujzBOH9qbMCHkCjIiVVc5cp/59X9TatSdjfLxDEByt1bpgXWgPRWbmm+R1k56UsKBjRmgMrvPbDLjyH9Ig0ZysiPOA371xb9U1ttvsj7YyWlNlM/lDg5HGNF2EBwSPvQFttM54bJz7mPulsvzUopj0gLr5N/AunSXh/Z6G+2Nf37md5eJVquHMFj/sULAoA53p/a5hBg2XyCNJU2haSVx//sGLkPmxZs0LeCQdNvviOG1yJfKNYGq43gOCtZFHEfTWMIZJ6ewjlES3KmiaKOrD6xotooGjjCPOUoSejX9pKW2iFkCTT7yHFarCvXrdqY+GkR2wBBW+8rvnbEFexKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(186003)(956004)(2906002)(6512007)(44832011)(86362001)(16526019)(6666004)(2616005)(83380400001)(6916009)(107886003)(8676002)(26005)(36756003)(52116002)(66556008)(66946007)(6506007)(54906003)(4326008)(6486002)(5660300002)(478600001)(316002)(8976002)(66476007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7d9Z5PY3hGnH0qoWIZ5g405MRuSEvQplAUeU/QFR/eT8O/2xxy6D8mGFla5h?=
 =?us-ascii?Q?Fkgy1HIG6c+odNTopyRXPKmfnbqghD6Eq38Bf+WvctCUlwDNXMEqQ3XzyQw5?=
 =?us-ascii?Q?suCn66NwVkaCoQBmdDBBffEheGY1UPOMjvwRK+eU43NVxx9Q/FXVi7m2hBX4?=
 =?us-ascii?Q?vgRXt8Q8LkYU6aHZpNsaL5KBOd7q/6lRKCEQfBp/Fzmbqprl9BbRKDb2g8Ji?=
 =?us-ascii?Q?7YOcGaAYVVxbMV7mOUjapsOgThr2gCnVwxeUzjNPVs1pzuA19Jpoih8+QI3J?=
 =?us-ascii?Q?mBpXSLI4Y2W9ORX7cp0I5S2hEQnUnZE8UbLC5w+04QAiGXZ/YeXPKw+owfXn?=
 =?us-ascii?Q?+PahvGqVsXRdi5HnvyxVitjFyrlmXG9GbfTikCyKLhdSr8wAtBmRKSmMIZmY?=
 =?us-ascii?Q?0SD3zdeSjHsF5KfpknkmCLGv/8OQvG3vmFw7LX5riac0bQ5rNhUbY9AFwRIw?=
 =?us-ascii?Q?seZ0RS/oPtftsb8dER7r/TJqBwlJETj3jpBjkIO0LnfyMvG2X55CbvhXgB/t?=
 =?us-ascii?Q?ljUKo3vin/z3DtIFc6Kss2zBrDMi0C9KzEDXrwR+1Z0jkLaymgY43/4/y+2B?=
 =?us-ascii?Q?CR3KBrLzFD98jJ1BOzhUu4insMOl6VYgVI5xDPYr43uqLIbwzNV29Z/b7240?=
 =?us-ascii?Q?mDQiiC3f0g4+yeCJZDC9Rh15m3GH4ji8wRU8c9YFwlf7utG5jDmqx4TGBr7A?=
 =?us-ascii?Q?hUcfSos0zgMngAPp1hvkTZbpQq3CUPm0kLZXMexbiAf8bzHt6kJIFzRzpacV?=
 =?us-ascii?Q?AyGxELm1zNB46cwtyatjXnZU8vCF0O7kKUTvp7afuLiaAIZaLLsgCOPdOOUs?=
 =?us-ascii?Q?nnafEvjqMTxT4VVd3smXUiJtoiEKthPKlorHgdJhHE3d9nKGLj9IDcx7IkjK?=
 =?us-ascii?Q?4cY1ZGc12LEQlCd7CvfwwJ4nVegW9yu4mQ3unYn3i8E7lnvXNhcumTeJ2m5/?=
 =?us-ascii?Q?nLC/nlqJM/MWQ61HA+J5Ax4YZAw+Bq30jUwq26AYYpi14Tq1AtTTnDmPJWNO?=
 =?us-ascii?Q?qJkf?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d6913f-5b9a-4f57-35fc-08d8bc8c26cf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:00.7601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OfLvAk19RwZlsfHu53Y25FntH8JXzVylk48YZ2x5wg+Y57x0DZQhQlZoHfMTP7wMYtbEugka4Pceqv65ufayeR7LrwSTeSUfUUuNOlMWLC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a resend of some improvements to the ucc_geth driver that was
previously sent together with bug fixes, which have by now been
applied.

Li Yang, if you don't speak up, I'm going to assume you're fine with
2,3,4 being taken through the net tree?

v2: rebase to net/master; address minor style issues; don't introduce
a use-after-free in patch "don't statically allocate eight
ucc_geth_info".

Rasmus Villemoes (17):
  ethernet: ucc_geth: remove unused read of temoder field
  soc: fsl: qe: make cpm_muram_offset take a const void* argument
  soc: fsl: qe: store muram_vbase as a void pointer instead of u8
  soc: fsl: qe: add cpm_muram_free_addr() helper
  ethernet: ucc_geth: use qe_muram_free_addr()
  ethernet: ucc_geth: remove unnecessary memset_io() calls
  ethernet: ucc_geth: replace kmalloc+memset by kzalloc
  ethernet: ucc_geth: remove {rx,tx}_glbl_pram_offset from struct
    ucc_geth_private
  ethernet: ucc_geth: factor out parsing of {rx,tx}-clock{,-name}
    properties
  ethernet: ucc_geth: constify ugeth_primary_info
  ethernet: ucc_geth: don't statically allocate eight ucc_geth_info
  ethernet: ucc_geth: use UCC_GETH_{RX,TX}_BD_RING_ALIGNMENT macros
    directly
  ethernet: ucc_geth: remove bd_mem_part and all associated code
  ethernet: ucc_geth: replace kmalloc_array()+for loop by kcalloc()
  ethernet: ucc_geth: add helper to replace repeated switch statements
  ethernet: ucc_geth: inform the compiler that numQueues is always 1
  ethernet: ucc_geth: simplify rx/tx allocations

 drivers/net/ethernet/freescale/ucc_geth.c | 549 ++++++++--------------
 drivers/net/ethernet/freescale/ucc_geth.h |   6 -
 drivers/soc/fsl/qe/qe_common.c            |  20 +-
 include/soc/fsl/qe/qe.h                   |  15 +-
 include/soc/fsl/qe/ucc_fast.h             |   1 -
 5 files changed, 209 insertions(+), 382 deletions(-)

-- 
2.23.0

