Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2ADA2B9F43
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgKTA0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:26:12 -0500
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:49020 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726192AbgKTA0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:26:11 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175]) by mx3.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 20 Nov 2020 00:25:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSxLZIGue7Rr5TbMB+iLa/0Fou/9a1VyKw4ZutmMzJmGn/5LULd/XK3cocHeuO/nYsNNspfwhRzkyfByawTddgOnbLj21hslY3avdU1ec+a944DUnljwZQAumEHDVwztXdQn0/Sm2khCdr0zOlVbOZHJFZAt3SqC7OE7ntX234yfP3cr/o90CEi5q0QtNtFZ1I0q8Hh+ltJ79DfQNz2GX3uheyVuYhFUWxbGTRUSM0hKZ8sBOvZ/LDBwRd8xmT+NMf23HL3YpgkaRfR8iA0KshnyNQsnCbDmZGbKNZZ5LtHz3O7D5Rz2+Ve882XWCuRXvIUtjNvRWceTtoR/x8h9kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzhu3HKrBF9WL7Cqr05yTjxR+KiotXQXs5GjHw4rN/g=;
 b=m9xmCQEyuzMUZUddDN+GpV3Wt/ApfCnMOe2syL6zGYeO7UCzrfmRiS/cDnDmW+zJl9zwLXacklyXFSQa5onljEm0eDJXOTHxKRLFf7yhorw5LkUiRl5s0Fb0DpHhowjYS0MHZ2YnqHHXnIv63+kIHLd7sRY8UmURMHIfxk2TobiiK71Ju1I/NWr7znvLnZVoIWpdZoEAGHNA83CoybFY2InR31jsLYUwAGDL5bRy3Q4X3gdr1Uom+e6MMvY48kTOokNzzP78zY7Ap7vXeNrP0CaBRbXXP3+vZd3aXhbzHrW3P92cXKTZCdfcxOVeXBH6OPQkQ43SLLqLjfrNL5Wbbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzhu3HKrBF9WL7Cqr05yTjxR+KiotXQXs5GjHw4rN/g=;
 b=EtsNcpxESCQnNIUP/YRBxBoOPzfiUWjM5fhqf3fx6ZtKeisOpyYPT7xSdLWxUixQm/71/ve6BR+rDfqsI/O5ddfAE3dkldG1uZfEX3S7IB/A1rZCYsbhc4Zr1y1YJTqrYZuWENu+qcZJUgtMNubdjTXh28ml9ITv5x2CK7QMXyg=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB3870.namprd10.prod.outlook.com (2603:10b6:208:182::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Fri, 20 Nov
 2020 00:25:55 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%9]) with mapi id 15.20.3564.028; Fri, 20 Nov 2020
 00:25:55 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     lkp@intel.com
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com
Subject: [PATCH v10 2/4] net: phy: Add 5GBASER interface mode
Date:   Fri, 20 Nov 2020 10:25:33 +1000
Message-Id: <ce2bdff4ef9a98e47d93b3e183327f16acf05768.1605830552.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605830552.git.pavana.sharma@digi.com>
References: <cover.1605830552.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [14.200.39.236]
X-ClientProxiedBy: SYAPR01CA0045.ausprd01.prod.outlook.com (2603:10c6:1:1::33)
 To MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (14.200.39.236) by SYAPR01CA0045.ausprd01.prod.outlook.com (2603:10c6:1:1::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 00:25:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b228b80a-f0ae-4e41-3025-08d88cead838
X-MS-TrafficTypeDiagnostic: MN2PR10MB3870:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB387054F736C51A0EA4D76EDE95FF0@MN2PR10MB3870.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KxLEG/N8hAOwKb/Acqg2AZ7DzL2GmVrecoqao1ybR5YNdP+wSJphP3tvmNdP4xzO29u0Cizq1zfmapIcsvledSpHBGxYmjLOIROvMEPeIXXt6+hE08BqWGICbK0x8/k0i9K2wq5DbfXQq+/Q03+OuIutXz3SNT7KUt2eUXP3mUTpPSbG4mzFS7DCxAQiDwFVTekXIEa2ep3QG8bK36Whv+inVtxj+sdE4Xq0MAIfKiaA2EntR2ZA/mY30hI2U7NZSO7C5OidMlQF+QV7bzOZ5e5JMvSCKEiNbJKePdTaeWbp8kKVGFfI4HPTTQGSin8xsOHE6hOuwpRYRDP3i4/7/FfQu30ZZNsq1Cbe/FRJlcBJ+tk8KzxKKAHXr/WSRhr6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(396003)(366004)(376002)(136003)(8936002)(956004)(478600001)(316002)(86362001)(2616005)(7416002)(36756003)(6666004)(4326008)(6486002)(44832011)(2906002)(6512007)(69590400008)(6506007)(186003)(6916009)(5660300002)(26005)(8676002)(66556008)(66476007)(52116002)(16526019)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: dqZII2DeE+/p7vECi7XxJG2+r1umzZUSz4XHw2DTVHYHtmRpblyxHqgzW8j1pObV09TJBeC92NaIQmXATIHcyd3fy1DWXftRdlbOvNj+GRKordMEuBz/byn7cZryxHfx4C+Gcd0i6R8XVntFMEEBrZ7rufOVvnUg3V3fFKM+ue8WNp9p5lkGGLChWxdPA3XPkj5B7MtHq1pFHdj4x3sHRhlNReAMCzbcAjn6Z2+3GltMIhDddD7XqphB2uTQpMg2OmaCgvIcQ8rauNmWM4YM3CkZb5JSV/YuJW/cKQ2CQEG4PPA/TjaWRSVbHAgZjQ2216nC4QK2XJbhTGLFSuOqDxgmOqGfJR19rZ7HrOhL6anbBflwS3D5GtRGh1YHRPv3bPdfFQgZA1O/MAe9P00aaErpGA+GSa6dzxZCQzcAeUy/MZZWKO3gPzoHjQVxwPnfd6jv6Ikv/HKjx+0gUpnCpYDOIIx/LbcdcQazJm2eLC8jSncTyETutXumG81TPIH590g8bhnM0jQ6095Hl8riPxCI4fVtBr0UJkFH5ZLiHMxUsl7G7cgcbFSBdYRndSHpgWTuAEBSf/phwyLb5tcxf8j6bEcEQ+ZqQ6kD4p4HVPaRO1nqsMdo59PylOhekLwofALrRgGNfoV5vvgU8CneVn3+kNoMJ51fHPWV6BI7U6pk/EDDkJsbonh/PBaC1hFoS147GJ+NltPzl6mgwzJYbYGQiH+fcRa8Xtjr6FUB+lxrKQN6Xxd3Yl3XFSOwZUBGSsvGOAkFj4QfFmyvdr2toT0I9+Sbukbd7uHpEIY6gRr5jgVIRXUhEGwGQx2DmembA6EqjNlrG8ewvh1AwK5tt3mPSE+lzjEPUNf/kXzLeIGTcpFSc+A+LglHlFMQsLARzrj3LqBDEp0hBCkj76YwqA==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b228b80a-f0ae-4e41-3025-08d88cead838
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 00:25:55.4883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pRvV+1YHpDqjlE7rXapkkFv3/7MKXNhzBpyHHY5dm29DoQU9TJBxIuwIb8Q3MQYEDiPEBHRnDw6SpBaPM/MINQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3870
X-BESS-ID: 1605831956-893005-20217-703-1
X-BESS-VER: 2019.1_20201120.0004
X-BESS-Apparent-Source-IP: 104.47.55.175
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228307 [from 
        cloudscan20-115.us-east-2b.ess.aws.cudaops.com]
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

Add 5GBASE-R phy interface mode

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 include/linux/phy.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index eb3cb1a98b45..71e280059ec5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -106,6 +106,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_TRGMII: Turbo RGMII
  * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
  * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
+ * @PHY_INTERFACE_MODE_5GBASER: 5G BaseR
  * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
  * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
  * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
@@ -137,6 +138,8 @@ typedef enum {
 	PHY_INTERFACE_MODE_TRGMII,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
+	/* 5GBASE-R mode */
+	PHY_INTERFACE_MODE_5GBASER,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
@@ -215,6 +218,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "1000base-x";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_RXAUI:
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
-- 
2.17.1

