Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2681531D1FA
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhBPVTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:19:13 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:2376 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230388AbhBPVTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:19:07 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GL6a1T010454;
        Tue, 16 Feb 2021 16:18:18 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2057.outbound.protection.outlook.com [104.47.61.57])
        by mx0c-0054df01.pphosted.com with ESMTP id 36pcj9gyqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 16:18:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVOddVzgmND+Fy6uF8QrNMusTityRsmfeTrzLUW7LVb5O1d+gj7OhrSeMUxw0CUrulCanFJwciqe9x6azvLnpxbC2GDcYM7y64DhFxD88q3mZMatq/m4AdZCJnnFFwqfVXtRVSethadfixYqm7/IEJImzRqqZEEzxsZRHKq+9tRQjWdyrkMGWDFH+uJjA5N+C7pnp4g6k7u4WGlrSpo73dpX26PebOcvekEjRa+9XxE/x0jyu/kkf270l57kIM2WrPCZMrq/gDPm/NjPCu9lrUep8+z9kRBnNCVXJnPeKwpb0w5ky4mwSiOoOIMzjZ0wISKZAubbdXvome5zGUsGUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRE2w+tyqjdyKuxeLZwmm2YsB/ZFGer0b1ibIJ2mExM=;
 b=B6qgssvPQSIKBpwcgAItXn/RP+6l3vYCGSScCjSS4AcTLPIBdTTyIjR8AxdiWLCakyTb0xChFHDJ5NCQJkej8EXxJI1uk9WaBmz3cHe5ofxS6uN3UgnOchl6BBHPpQ9BFn50GK+y9gGrjrrk6g5SIeE78UgBu1UCZGqgrGGgPKKrL72BlgiWEjiYl35PFHiNhxcw0mcBAqYbpXqIfikkyrs2YF61D203fW+QnoxiJ4mOM/BfuBMdXuq9LuUVkdNoHFdxw9SMfeMtRoTbIxu3/Odg9jz3V+g5dLkYy/9rYWx7leqyO8lxwASaOnDVcEA8UKYEmVXUBkm1lSpfbtzl1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRE2w+tyqjdyKuxeLZwmm2YsB/ZFGer0b1ibIJ2mExM=;
 b=iR2Ipnv93KYyUizlq+pKcoQEn8pCL4UZqZL4KQWc41Eyg0p2SDmH3II0Ii7WRTvpxl4qUOmGxDdJrVhPWOJbFMZ0o/bMcvvg4pR9pHOXNDfocQ8EJSsdRXswcWoJt+HbPHsAusiSNzj+XWAQDRRLds7wUQ/HvYRdKNf/6aUpnDs=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB0879.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.39; Tue, 16 Feb
 2021 21:18:06 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 21:18:06 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 2/3] net: phy: Add is_on_sfp_module flag and phy_on_sfp helper
Date:   Tue, 16 Feb 2021 15:17:20 -0600
Message-Id: <20210216211721.2884984-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216211721.2884984-1-robert.hancock@calian.com>
References: <20210216211721.2884984-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM3PR14CA0128.namprd14.prod.outlook.com
 (2603:10b6:0:53::12) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM3PR14CA0128.namprd14.prod.outlook.com (2603:10b6:0:53::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Tue, 16 Feb 2021 21:18:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92760bfd-ddd8-4ff3-57cb-08d8d2c05a14
X-MS-TrafficTypeDiagnostic: YTXPR0101MB0879:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTXPR0101MB08796CF26EEE9CF431D7EF57EC879@YTXPR0101MB0879.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PgTQ3/ioRyL/DzM6P0nDBKEDz7K/CZ/F0lFqNRb2fmtQpkJ5CIGf3bDc5a/cd1RiNsMLSBdA0O/FMCf7BifOS/HJXwL1XhBZ+3oWVN5yothGw2zFaV61Y255h2aQwWcxPRhqs56AHYYs0iO/JJ3dU/4QoJpnTMFjYIzMMSK+CZIjg1YexRLjoHiVl+Cm5XQp5SXDqz8h63ua7kWVZ+kXjwaqojgaIE28cgKxCKS8iWViiJd1EpaoZHGq062EaBXYLEsjMpgMn7KGnBSrxG8Qdwu4/wYFWcBd4ErQrS4ZB5j9Xakj6vhKEmpKPOMlSirABh6tnwjQsUl4mX4y0qaEx4bcyuqIoj08lQkt0N2aArfrdFwOHjURJvGPmeFt0kndoKwOWw9YONMzKMHksjGi1rz7P4OtZjXReKFM+ICqLGKawCYV0vzTx465Gfk2t+EC6Si9mfnqL0zagDaeXJnv5RPdowpUPORhq8HBChyJOU1UQuwqTGZ8fDUxUXNoWYZ78PzZ3fik/RnCXQUpYgwdcsQ6OYm8EJf/zdfViEXbLoWS2NVF6hzVzVk0lGO6rrE9X+NXH72S0bM6Cb34tJJxvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39850400004)(366004)(346002)(8936002)(8676002)(956004)(6486002)(66476007)(1076003)(66946007)(316002)(186003)(4326008)(6666004)(2616005)(6506007)(16526019)(36756003)(478600001)(5660300002)(69590400012)(52116002)(107886003)(83380400001)(66556008)(26005)(2906002)(44832011)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SwlRol5+F/1OHThj2SsjhYaHba710DSNCkjOKzM8aOpy+aq1eqce39PIIm2c?=
 =?us-ascii?Q?yOQGsd8GhF4uyhFfbj59zpASSdJvM7W8cNhh50uHkGTbo+4ZKJCs/N1ZS3hh?=
 =?us-ascii?Q?fTMV+h6b3lJrZgtMAGrlWP1xgMqYM6QcEiSlPnOqlAwULj4+V2W/4c8Io7rz?=
 =?us-ascii?Q?YBxOsv0F2PWCOWNasg9KgF4ss3aTbsNJ/vdpecIK7i4bMf3488Ov/gHc02Ts?=
 =?us-ascii?Q?sEZuRLCoMt56/T72e8TjR6HwJnGao5VMTkE+yLSgodvdIpYvYw1OiCPs/sB6?=
 =?us-ascii?Q?E03zBv25GjrXThno0HgfeNC9yms0BW84DyjbPFT3OkfgE7zde70KVs+7koQq?=
 =?us-ascii?Q?qp1IjBXHUevwNDRh2d6zl77/PeRitnQ9f/PYvS0hDqC7E2RkXe++u1Wfaf5t?=
 =?us-ascii?Q?b+RI5yqfU5I/bfd8YnTJXGYti7uErY8WUvE7VQ2E2l2jMJH7IjxbMENLxvdx?=
 =?us-ascii?Q?pEDUPgSWFeItINmeSvbR/HB6jM5TqmH2bwtH00MpJQfV76RbHzFKdM8d7L4W?=
 =?us-ascii?Q?vDu0Ah7FssOxEeLVuHmeCVUTuiip9FpX8GTCVHYSbGNLF3IRunD1BDxDoKWs?=
 =?us-ascii?Q?BLr74MBujXD7lDkcOhGqtLLOq5sQxAVOmOAEAnW74t/lmNEFNIArzIXelDkq?=
 =?us-ascii?Q?67Gcr+DxGU5SU7sMgDtewquhOMPdNAaFTyKJNLvc7c8+U29DLqvt0rNkJ2IG?=
 =?us-ascii?Q?xGUbJCCZoYxZZ/oKVyF478ugbn4pFa0MVOkorRfLlD0tn9tJ3+2lauoe+tWI?=
 =?us-ascii?Q?DmSvh7YHj50bQbZ7syzr5ea/2I3klXfjHXgStKzsfgIzfpyo/8k/RjySf14D?=
 =?us-ascii?Q?dBY/7wgp2YKvL6Im3n3a8ZI79wuUSJuwoHD4wYHKm4nVXrnA1QPySz3yGCSt?=
 =?us-ascii?Q?w1SiA935zwmDc5C9vcHkMb+B73pl3S3ZxaYiHdtQNCXjuMEBb7C/nBZfoyBf?=
 =?us-ascii?Q?sf74QXQSRUh/qR6oemCLZXKyyY269gc3IpYh+cRCMXEDWrlA5xQWn5b9GzYR?=
 =?us-ascii?Q?1GVJwjiAoga1U0k7diJ8p81teTp1i++vdrojR+tOV94w7+z8TI2HF+VnNa2o?=
 =?us-ascii?Q?rjOGl+45uZ/l49oV1uTjoen5zJVz7OwUMkM5l0SUUY3oAqsuu0j0JvxlAYa7?=
 =?us-ascii?Q?F/kr4aL/5fufqgwSvKwFmCg6H8Veejwxpc/lXFQp6PNlXIRvNnppVwFsovsI?=
 =?us-ascii?Q?EilSwavLYBTOkAdTFeJLT/6+RsQjE2tsE7MWKA+Hq4pyN6gg+LJdECryev8n?=
 =?us-ascii?Q?VhAgSCVkfOhzFtLbnSQosR/HBpnJMAzxgMRWCMQtOLvfd5cHru7Rtg423FY0?=
 =?us-ascii?Q?+Ob2UgbCmyGnGbBQ0z9Xwbbp?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92760bfd-ddd8-4ff3-57cb-08d8d2c05a14
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 21:18:06.1300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gu7c3waMOZK6YfpAzvQ6UApcm5d6OQNKQMw6tR1T6svUirvp9qcJcqQB8kXey1jlkR8UAnZ1qJRWH0s9VMeo5QevfvQoJm5AbQ8weP2ppQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB0879
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_12:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=769 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160172
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a flag and helper function to indicate that a PHY device is part of
an SFP module, which is set on attach. This can be used by PHY drivers
to handle SFP-specific quirks or behavior.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/phy_device.c |  2 ++
 include/linux/phy.h          | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 05261698bf74..d6ac3ed38197 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1377,6 +1377,8 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 		if (phydev->sfp_bus_attached)
 			dev->sfp_bus = phydev->sfp_bus;
+		else if (dev->sfp_bus)
+			phydev->is_on_sfp_module = true;
 	}
 
 	/* Some Ethernet drivers try to connect to a PHY device before
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5d7c4084ade9..eb48c686c423 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -488,6 +488,7 @@ struct macsec_ops;
  * @sysfs_links: Internal boolean tracking sysfs symbolic links setup/removal.
  * @loopback_enabled: Set true if this PHY has been loopbacked successfully.
  * @downshifted_rate: Set true if link speed has been downshifted.
+ * @on_sfp_module: Set true if PHY is located on an SFP module.
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
  * @irq: IRQ number of the PHY's interrupt (-1 if none)
@@ -561,6 +562,7 @@ struct phy_device {
 	unsigned sysfs_links:1;
 	unsigned loopback_enabled:1;
 	unsigned downshifted_rate:1;
+	unsigned is_on_sfp_module:1;
 
 	unsigned autoneg:1;
 	/* The most recently read link state */
@@ -1292,6 +1294,15 @@ static inline bool phy_is_internal(struct phy_device *phydev)
 	return phydev->is_internal;
 }
 
+/**
+ * phy_on_sfp - Convenience function for testing if a PHY is on an SFP module
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_on_sfp(struct phy_device *phydev)
+{
+	return phydev->is_on_sfp_module;
+}
+
 /**
  * phy_interface_mode_is_rgmii - Convenience function for testing if a
  * PHY interface mode is RGMII (all variants)
-- 
2.27.0

