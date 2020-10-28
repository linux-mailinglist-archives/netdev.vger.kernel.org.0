Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F2029CD32
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgJ1Bil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:41 -0400
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:51896 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1833080AbgJ1AJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 20:09:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175]) by mx5.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 28 Oct 2020 00:08:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kG9nZQgq279J/l2LAI+WdQ3p0yVCc51MY2yinS/bG4iRk6qBQQweCf0DnIsidhfkr97lQ/nH3S0VHK9UTOGt6YpgJk/VenLQ4RWWa4rW2RX8qa/cLcSgtH2LGpvgkLQhwK5v+mFY9vaL9FLv4aaYV3LVF8i6LgsaLNURNX9WK0xKf6bNlzHxQ0pOQA8U+BwN9Ux/fxRv5xAJzgLz/uJrZnHjT2CdvdSI0JrvOSoooEgXJLFEB6z9bs7gNr60eMROz3JcnK7cC7lWOYSJDi0f2XDwsUZRy8TmNWx1XS9ZXVluRYaSR+Ol6QTLIQ1YmMdsYWQNWBx2hzc+V2CI3YmrbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SS6JeNiz4Ffc2kkGBfBJMzLlhOhujnvTLRvEzo/13x0=;
 b=CP41eZvDr2mtoOD+q3I6M+LW1cyQTe+4aKAavE1JeDQO76WGZSNO3w6V2m6qfNQchnAv6dhTGA9uWwJp5risj9HQTsqITq8wU79Wmn8GORa72YrIOqm6y37i36HWqb9yzaDuzY0QjJxD1OHnE6rYLuyj4pZoIfxiNbbOUem6eqOg3A+GttxoKMW8IK923pl3kIeLnBqxBodv+5ECi/3f3EO5NJrU3OT2+Z+b155c2HJKIHlZBdl/TM+61rsWhE6ZqRKdTYQBBpxTRg23bAbLVlofe524b1vNelpqyVYseV6ULdZu30TEaqSiMK2JS/X54JzsLVt4rb4XIYTUM38Gmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SS6JeNiz4Ffc2kkGBfBJMzLlhOhujnvTLRvEzo/13x0=;
 b=bASUJLhq7vMRYQvgh7HbzEdRujsnToYS436F1kTDwjOd/6y9vp9+swkiwgJeLX5MfP5snJiNj/C8UOumVXcApYyemWxl02Nudsr5Dn2cBIzZ2dUna9j5N1Bbf2lzGAJLI0ZchIjNCfxnDrwfON5MjHwOuALIS+weSU8LlTAGYRk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by BL0PR10MB2819.namprd10.prod.outlook.com (2603:10b6:208:74::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 28 Oct
 2020 00:08:51 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 00:08:51 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     f.fainelli@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, gregkh@linuxfoundation.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com
Subject: [PATCH v5 1/3] net: phy: Add 5GBASER interface mode
Date:   Wed, 28 Oct 2020 10:08:27 +1000
Message-Id: <a64c292dad43a28ca77145d7d82cb9db3b775cb0.1603837679.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1603837678.git.pavana.sharma@digi.com>
References: <cover.1603837678.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [58.84.104.89]
X-ClientProxiedBy: SYBPR01CA0215.ausprd01.prod.outlook.com
 (2603:10c6:10:16::35) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.84.104.89) by SYBPR01CA0215.ausprd01.prod.outlook.com (2603:10c6:10:16::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Wed, 28 Oct 2020 00:08:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b98edac9-7aca-451e-7555-08d87ad5a67d
X-MS-TrafficTypeDiagnostic: BL0PR10MB2819:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB2819B5E69BE48B2E4C02A95A95170@BL0PR10MB2819.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QCNj2sFuqs4DahNwbS7z0koZJwlYHsjOFbZs1FpzWj3T4KePgbunE72BJ3yrsRCgUm7pE4SojjCVASZd2nRepE+lxDDuWExN/S+aQGx9wvwl0tBGiTqkTQzKbCIO9PsIBMl7DDFh6EZefX2UQFtIEDH1JzySYdWp7/yrne03b+JT9KE0wPHwlroQ1x6MqIMal3du1Fpj6CZzH0TEKapHBIvt027W+AeJpeoLQqsOKOlSfI8EAkHRe8fKus2uY16zz84se9yabFS9Rz8QiV4ti6U/jUuho8aEFKixv3k31KdAmCcsP+u9XYPSRUZeT8u6Li1RxiZs+qXBRaz7xcw65rA+yVmEyAjTUHXpjpEZPWWxuq+YDIUICbIlI09fxhVm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(376002)(346002)(366004)(52116002)(4326008)(6512007)(6666004)(6486002)(2906002)(478600001)(44832011)(956004)(316002)(86362001)(36756003)(6916009)(66556008)(8676002)(66476007)(66946007)(8936002)(69590400008)(2616005)(5660300002)(4744005)(26005)(16526019)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9Fq4YnLJVia2OKhxyFdvR1SestkLu3r7KTwp1yjP97N6ANlgX5fBUlrbeGjw4NkdhiIZkl5frJls5t5zQkBuf0mw0RiaEjsFFrdg23RIfoYmdbz+qv+aR7zABOdoj0RVuPfGU7MxpQGw8f+D+g3gfx2Rw5F7aRC/6W+hZ/VphC6AMGxJBxqYZ3dd+K02EVnn8/WP5TNEXACC2uNxFsc6XuP11b0EVsD7HDQ9Cmj3l2+f25qI6cSo+R0DNpbcXPx62RwX2GI9shhqMdtAnUV5Mhunq3kg+yE6MF+4p7j0XfQ6to1hjwGO/7Ys0rIJbtJqHacKtRbiAhoyiXB4YhG7zahk94ffcOkUuyWcPfaBnDUTz46DiEVgkPfZHVm+0UeB8Ngm9rg1xjOgh1n7qS9uoeirPp8/kUOQ/cJBfKF2sc1cQY+KQYGxFzEPTSgY51xOehPhQE9U8AkhyQ9UKQV2jX/qN7khscu3DM5HsFd8ZncxdS9vUYO03MlW5v7lr9vt2h4rwV28PSnuLnBL/ehqGPt4MP3hEZChPRLiKPz7GX9z4Z3DgePIpQopDa69q0UDLC9YYji2A4bI+7D7HtYohdfReSfBMSa9UePf85IpqqjSzHA4otnD9kDTFI86bmXP/SptaCo8y/JTzos85psTUA==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b98edac9-7aca-451e-7555-08d87ad5a67d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 00:08:51.7108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xomB6qD6XHZcgacrVJ4xcgWHqFMcC+ZalFjc/hjUzy1ZHKOuxXzOZA62UP54cTPpnUu6Ge8E94OZ6P4ODV37Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2819
X-BESS-ID: 1603843733-893008-31472-113447-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.56.175
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227828 [from 
        cloudscan19-66.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new mode supported by MV88E6393 family.

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 include/linux/phy.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3a09d2bf69ea..9de7c57cfd38 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -107,6 +107,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_2500BASEX,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
+	PHY_INTERFACE_MODE_5GBASER,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
 	PHY_INTERFACE_MODE_10GBASER,
 	PHY_INTERFACE_MODE_USXGMII,
@@ -187,6 +188,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
 		return "xaui";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_10GBASER:
 		return "10gbase-r";
 	case PHY_INTERFACE_MODE_USXGMII:
-- 
2.17.1

