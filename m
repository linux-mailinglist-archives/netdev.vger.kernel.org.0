Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB1E2D75FC
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405954AbgLKMsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:48:16 -0500
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:34662 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405907AbgLKMrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:47:53 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108]) by mx10.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 11 Dec 2020 12:46:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhaVYZv5MIGpW+qB31sk62PqTjki4UKl36mqwXjUlQMPZ/XLvsT5ZGr3f+A++V8RZYo6x0qWH5uCjq68cDSQYe0aln0rK7hcsEJ8/WIk3n3/ljxviRtOCqfU6RORxAKccCaq6zWqSU1wBpu6G0nVvFgYI6Za9DrvnCjybL4GoC3RBu70m+J7wKbHrJSKxSo/KWm1R9EcyPN1kC8oy1YgIo2HD1BpnFvC2LXWE/9mKSXRiFyoqJUKIdGImvBKNYbzVXgTxmOgSILM8ijshh2hQbbWltyBY89o3joIuVZwZ2gZdnrlnUzSO7jSjBQXx50U5PFnZoE9yzpZQxuQFtLHUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfymOkPGRYsFGCG70nfzmuM7Ce9OU1eYh9HBsebD430=;
 b=hNLa2KTNGzq1fO7ucVOMLYGGLyMD74yTTUrcgG186giGsSRNIIOaGreCH8Gu65/iTfdKo8BvVMInfxQhpVcKLcEjDIMYIc5Y8ESATeP0x91e4j52NirAz6u7KbPOIbjZBmJzrsSt6YrT9pIUAQniUuoX8kBop7WSQlh4RS8pJIb1fY1VmJPkges8Mm8SSzEbT3S3kXMGPap7vwgRQVnpnsE2coTUzWrSjY9tqav3izWNII6xpA8Zez2ZKyvOt0qCrN1JMsYqZWBjB3ATnPey+Nij4oSDq/JyTNnVEY5d8pMUhZFd9j+EGhejWIe+MDLhimx+w+DXSgSpn8YJTDAx9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfymOkPGRYsFGCG70nfzmuM7Ce9OU1eYh9HBsebD430=;
 b=nEpisFveb9jJ0dpnzt7gGFKNdr/XI5fd0YIcAlH5HKHf0KiKaPDRyPJag+8YPo2OooZebyM2QTdFjzz/wL7qI384wI7192nBKcA+kdgmJ+Hk6lI79kso0Lo1YVzzCKjJfra90vC7bRcnkXKjow4t4LByur11R80SajDnRNCiblk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4176.namprd10.prod.outlook.com (2603:10b6:208:1da::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Fri, 11 Dec
 2020 12:46:35 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::c8b6:2021:35a0:2365]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::c8b6:2021:35a0:2365%9]) with mapi id 15.20.3654.019; Fri, 11 Dec 2020
 12:46:35 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        devicetree@vger.kernel.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, lkp@intel.com, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: [net-next PATCH v12 1/4] dt-bindings: net: Add 5GBASER phy interface mode
Date:   Fri, 11 Dec 2020 22:46:04 +1000
Message-Id: <dbad3456b9c80a7f53d64b608ab69e4d4e0b2151.1607685097.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607685096.git.pavana.sharma@digi.com>
References: <cover.1607685096.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [220.244.12.163]
X-ClientProxiedBy: SYBPR01CA0162.ausprd01.prod.outlook.com
 (2603:10c6:10:d::30) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (220.244.12.163) by SYBPR01CA0162.ausprd01.prod.outlook.com (2603:10c6:10:d::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 11 Dec 2020 12:46:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fd4bf31-45f3-4e2a-c1eb-08d89dd2cba5
X-MS-TrafficTypeDiagnostic: MN2PR10MB4176:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB41762ED2AB2E95632BD9A5BA95CA0@MN2PR10MB4176.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CX2mhwV9gok+idFH4dUcizI1OElESsip1p166MnrD+zu+Asha4fAZJeg49EUqXlBGJplf1xGbz4CGCOCtJ3+TpI1Ys/riRr37/i1eMFRslTty9ZmtCVe9TQtFN46N1Hq0Nf4X7EPU0m/kFF09t6gqNqfPq+mGtatoOyC5tXM/OUciS96c8uNCunXg1mV4JMrhH3TmTtFb5/iu1WAqHk/aHz5RqTktdNkRy1FIKhl1ROM3QRnnAqalq0sqZHaUYkr23wVdSLIO9i7Lh1u6v0TVOTJYNca2LXc+8UNoFw4fuFzfWCQdxzxJZqtvPvpVK1pc/fhbOvqF6xN7bECG842pxo/zHjfPtsvqeXDVdlcmnAy3Pc9St03+AMSPclQRSHaUq1aWn0BH6kuEG5n00skz0l+Vt++VD1ukN8VD3IycNg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(6506007)(36756003)(8676002)(4326008)(5660300002)(4744005)(6916009)(52116002)(66556008)(7416002)(66946007)(66476007)(6486002)(34490700003)(86362001)(69590400008)(16526019)(26005)(2906002)(6666004)(956004)(186003)(508600001)(8936002)(6512007)(44832011)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6bS3UexjrRJW2afTEkxH3mXJ1UaaogP1ib4u6t75ZqWKFnm4vk3sc0TUalsb?=
 =?us-ascii?Q?zJrsHKATC63wVYFv+tsF10gkWqeckUA9sIDhuKvoZwumP9XYXNTTSOONeBAM?=
 =?us-ascii?Q?UVEJ4c021pfwZEFfnTuN9XBdJz0X4PTZMSRBWPr7Wp/ESCc5hM0hZPvcZ8IE?=
 =?us-ascii?Q?FYlJaJ+FMkqcytD9YXk+49CZDByjGVStHfoJLOepKi3ALK+NcS5x2mg62ZZj?=
 =?us-ascii?Q?yvwsKcLDXvSqa3RcdbuR5x/pJzUzeD7crNLiwiEY1wgAT+VAi5zsAi3A4UOO?=
 =?us-ascii?Q?2vqzH93d8148mVR0yvO+bTnKTYgswc7xQ4F1LVBVvS2nv817jeMwt2PRsGaA?=
 =?us-ascii?Q?32T0iE81Bo3x5WUY0UOouvS2wT4BPSONMfTd79XdW+PLkK9SMbV9NsjnODA8?=
 =?us-ascii?Q?Rg/AYJnhaaoNyOW/pJRy0eCeqkHahtOpaphQZqw7Gg6PEu9oqpuEurzAnrWd?=
 =?us-ascii?Q?Bl/X/jnvHaODzI2XaFW8w0Ys1RP7xhmZ9afgWGVACDxleDwL2ZzRuVoihoGq?=
 =?us-ascii?Q?FPWEEHSUECbr5JtRCsmEsVNiROjSmcX9PBoSUegetfDctlpk23m1vfRlSqPo?=
 =?us-ascii?Q?3W4IDBkMkd/IsrvKd8KzvxVDmv+SvtYjBRclwDJkSpMBjp3tk7MLIKd65Y0z?=
 =?us-ascii?Q?LsUFsNw6N+LAOiFSBzawjdF+Qu3ul2/gvGSTt0k9PXqbGc2EwE3YNJA1y091?=
 =?us-ascii?Q?APcwFk50d5DtLFms01H+dH0XDJn0TV89IjagupTbZanzQ9gLLwRx+waOxbko?=
 =?us-ascii?Q?OZmN5cKR8XTQ5MyDGE5UlAWDE8/oDlVF+a4hysxHImBOBTRexfCa7jqR8S5G?=
 =?us-ascii?Q?hLXHJQAR+2Zutoiw6vEgvqimSYvDjR8h0GDa21ey715kR29josRyIPjT+ymK?=
 =?us-ascii?Q?jnXJ74oHCerACNCfe3SBykeqpugOJOibSuqIn7A0ztkhSEeypSNP8ExRL1sa?=
 =?us-ascii?Q?Hgl8bjN9g2XbHyWcqrIDQOGGQCyLNi7QZA9aNYC3hPnwNnUP21s3GcYXcXUa?=
 =?us-ascii?Q?lGnI?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 12:46:35.6872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd4bf31-45f3-4e2a-c1eb-08d89dd2cba5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ve4CWuYAdLbgp+qhL5G9uC6Ufh60NWjux6g2apK8BX+TMsPZeA7d1ok4+q9iuMQjsz0lHsHCehZzy5xKrWxD6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4176
X-BESS-ID: 1607690797-893018-7524-2766-1
X-BESS-VER: 2019.1_20201210.2155
X-BESS-Apparent-Source-IP: 104.47.70.108
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228760 [from 
        cloudscan9-109.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, MSGID_FROM_MTA_HEADER
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 5gbase-r PHY interface mode.

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index fdf709817218..34036902f577 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -89,6 +89,7 @@ properties:
       - trgmii
       - 1000base-x
       - 2500base-x
+      - 5gbase-r
       - rxaui
       - xaui
 
-- 
2.17.1

