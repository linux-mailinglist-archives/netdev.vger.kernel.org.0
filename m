Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F36A2D3A12
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 06:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgLIFFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 00:05:50 -0500
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:59768 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725765AbgLIFFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 00:05:50 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173]) by mx3.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 09 Dec 2020 05:04:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sgj6qqnUOBNw0LwrxUdt6EOMrtNKHz+Q9fOndJvEtQHTwMQPlR3FOAt9Gayq38ROOtbYHyBdMGfk5RquMtx3z5TqbXMwyUbaHfouG0/4eesWXvGGwk7n5LwN1tDh6dfczp3lXBrsJ6HDHbdYt4CL8Ds9GR9faIsBJRygJms4qUcc5LZWfhv9VFbDAuBwZ8BhaNXureIyWRCOXBwKoW7BBCtyx/hBhMbXZxUxpna6T4yhFS4bW8ccUgCPx2xdGyoh52btNY3XewbwCSKqov5dS6Y8JrIzgHgW5peo+xcSLbP1XeKd4GcICn8nI+fq/8kFMWO7c5iMm5FMN6A5GqYPtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZyIIcbULkqFuqRRVCOgfB002r4JFCtYt2FmxhjIbMk=;
 b=nLFbBI+d2LEg4pHhUMJxWxzQFnF6ReNL8SiM4Mb6MgfbjVxVqxW5FU7CiaRPmI0b2klqGEehRCWxxPYpAQxcxAdlmQ62drXvpNNsWxj78EdDtteupSZFN2uWb7Mfi/F16Gd5s3EhB/yNWp4yrKtfBOuTs86RPnmO7tbvPZsushdtrFFsKCGtItKjrI3UOBiBVKGRfFhhYEGTwesq0G/osnt7NZPZmzIGljaa3UXvnG3d+/t4l3SpdllDQB9mZHW7ha/PdAr8kbk4WWt3gk6ed8vzltuMYDXTjQsZ+D1g42LiOWEABWdVATlBj9AVn5RQKgZRz8qHmIk8Na+5zbv4Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZyIIcbULkqFuqRRVCOgfB002r4JFCtYt2FmxhjIbMk=;
 b=FKeHieG6/plRejRM1GV6kXXfdbiwWRCChkoT4eiBku2NM8Yj+r8idcSb9ilz7zAG8VHjjYCimyu4tORA7wyxEqI0M4Ja2ySf8GN5X65M8P/kJxwSlg51hRuQ/Va3mYRImH52KWOrtukAF64ozWezFCymhWHKtuz6Cjh5NHeGXMw=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4336.namprd10.prod.outlook.com (2603:10b6:208:15f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 9 Dec
 2020 05:04:10 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::c8b6:2021:35a0:2365]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::c8b6:2021:35a0:2365%9]) with mapi id 15.20.3654.013; Wed, 9 Dec 2020
 05:04:10 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     ashkan.boldaji@digi.com, clang-built-linux@googlegroups.com,
        davem@davemloft.net, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: [PATCH v11 1/4] dt-bindings: net: Add 5GBASER phy interface mode
Date:   Wed,  9 Dec 2020 15:03:47 +1000
Message-Id: <0537d23a6178c8507f3fda2ab8e0140b6117ef74.1607488953.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607488953.git.pavana.sharma@digi.com>
References: <cover.1607488953.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [203.111.5.166]
X-ClientProxiedBy: SYAPR01CA0003.ausprd01.prod.outlook.com (2603:10c6:1::15)
 To MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (203.111.5.166) by SYAPR01CA0003.ausprd01.prod.outlook.com (2603:10c6:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 9 Dec 2020 05:04:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27e1fb9f-2f34-4a90-0fba-08d89bffdd3c
X-MS-TrafficTypeDiagnostic: MN2PR10MB4336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB433626C56F75D758EB50858C95CC0@MN2PR10MB4336.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gn8L3UwsviItd8wY83NP39FacYSWTA7x2x/Fqmip6eoRJ0X5vG8Tixw1vUQ5eiOXOE3PfSZYlkHo5fwuR63OzXIeDZURz439m918o+4HLG3p2ceIdQUqw3yUo9i1NAoNJJRsVR03hANE6vXM+LqhROJUZwWl3ESG8w9zD5xJJZ3ENDDq6BU3RYf7tWqClZuULumGiCu2geqsiGn/WUvodDMd6TRAxvjJtpKf5Hxj/+1i22S4p//bItp8dwdRvVh1Bs1NMjH51eGODtmqt96z/cTmaa3bWCctBqwFXYDL2ROWYMZZhhTmFRUuVI/gkH1yixB55nVnI0imPt0/5OzG/ZKv2wmFRB0bGPPxicseQYCFsDvBth6w3PCuzg3yWT3jK22gof4ygvqcHU5S3iXBB3KHPzxh6pVGGolk4Y85LnU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(4744005)(2906002)(34490700003)(66556008)(66946007)(8936002)(8676002)(6666004)(66476007)(5660300002)(508600001)(86362001)(186003)(52116002)(4326008)(36756003)(69590400008)(2616005)(6506007)(26005)(956004)(7416002)(44832011)(16526019)(6916009)(6486002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iGhS71eBHj6qltYCBskAF09ds9fHCUaR9OF/r55z11ZVv4qiqAijWIQfshhj?=
 =?us-ascii?Q?UOlAMOER5jVbxKj4RS+X0IFzB1rABA5qJeXviVR39BPiH6mhDNe5QNMk+mDi?=
 =?us-ascii?Q?nD1VkVfAkzJJwEofUPdE+zi0Q8QWc/vWdfIT5Kk0cjYiYuGKV7Aa0miyUQ0h?=
 =?us-ascii?Q?jU5iX2YYjAvjOgFOhbn2BA3g7Rn230YI9WWnWPF8Ez9q0Q6W479/UstSfuc3?=
 =?us-ascii?Q?SgyECnSCGsjA4ptOJ9P6Z5dlFi0FpXMqXlDiW6RIBSAVwlgfnC/8HaZnpsoN?=
 =?us-ascii?Q?Rre6ckPc6nEoaep30rZREcCnms2e3vHT0zD/CCgVHrsQ6LVqG2MAmMuApAjF?=
 =?us-ascii?Q?DYtiUmg9n3U3cHZ2ave8V4XR4or+9B5x4TO2HdwA03vHcgmj9ZFHP/mjfirC?=
 =?us-ascii?Q?Pyl8huir1bOQUr0KEg/esxU3Rh26xi7AkfcgPGWLXIALlREIK9BV5kw8SLNo?=
 =?us-ascii?Q?kihC6ed/2OEkS9n49FESC4RcKoIES72ogZ4y+f78/24+I9H71/zX/lAYg0aZ?=
 =?us-ascii?Q?YL5RcU17DE2KXL2H/tYGd/UcABM9xDG02UAVAolJ/LJifQH1aYCcjgocZz3O?=
 =?us-ascii?Q?in9NohX5eSXSF3OmvbonvId/JcDAqZF3lL828x40vr41isH/3/Tpke81WU03?=
 =?us-ascii?Q?/sNYXgrwtJdkvjZsmBmJZMBy40TiCxFIdTzIvoABYX05HTccyfCx3oP3Bzub?=
 =?us-ascii?Q?mmdEgL+Lt7xvs0jR2W8wmaKM3Wi1QhWKA6X6jZQN2AE5R4ITdBOOuUGkzDz5?=
 =?us-ascii?Q?Rkk/eyEp2mBZNEPO0yUk+MS1axwfG9z3f6hgR6S5/TdTLYs3NYQjJZF7IqK1?=
 =?us-ascii?Q?3NNZjbgkF8jwaX/Lv5GWZCQvztTUQnkE8E3SVdT6NoiEKNF7HJtmXrkWMM6D?=
 =?us-ascii?Q?KgPJPFXfgFuDlIPvFnBhNeCP+7kPzS2NaATpKw83MeQoNRjUMorL8fraAg3X?=
 =?us-ascii?Q?xjM4k6bkJsnC4kLaZeUngjLZ2Aof6HsitRNO84o9mmlMTfBdyT0i5w8LcGLH?=
 =?us-ascii?Q?ZMIA?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 05:04:10.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e1fb9f-2f34-4a90-0fba-08d89bffdd3c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMi4swPIg6PGW9zKhVntEg/mZCGeUeIB+dFOlWH6lVGJ2CWuJIkKXjp6ORVl02VqenvZJThtPz2jAug5ZLqblQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4336
X-BESS-ID: 1607490285-893005-3817-28891-1
X-BESS-VER: 2019.1_20201208.2330
X-BESS-Apparent-Source-IP: 104.47.55.173
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228709 [from 
        cloudscan12-219.us-east-2a.ess.aws.cudaops.com]
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
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index fdf709817218..aa6ae7851de9 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -89,6 +89,8 @@ properties:
       - trgmii
       - 1000base-x
       - 2500base-x
+      # 5GBASE-R
+      - 5gbase-r
       - rxaui
       - xaui
 
-- 
2.17.1

