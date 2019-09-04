Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88F4A87FC
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbfIDOAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:00:49 -0400
Received: from mail-eopbgr680079.outbound.protection.outlook.com ([40.107.68.79]:33775
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730478AbfIDOAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 10:00:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYX0kJj8UCBItYOTlWAMkyhsmYFz2QLOSHGcz/PwKBNyHgjsfv0bIwLH1k1nl4BGQd7y/Cq2PlZ7vSMLWOj94f3YCSwOYWeu3PXOVzfmircc8jZzRupnn2z/fwKxWLeQ0J2nm1auC/aH+QB+jSQCrokVWMw/fhgjwZPsIEA13E24COdJSxKWU0zRHX+ZFjKu7OlJHbZjy2cZxOk5hiGTpwWFN+M3omSq+iC19j31pgVM/nHLwOTr1Ll83ORUsnaphU/7DcgACABB0pzSVCW9kfTGCgLl43ySzE+/FEWrxi69jS6cRJoAdFNLkHax5ig/YJ7GbU7XDcD27/8scBhKNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4CzKaz7v320L1sRgNOus3VzK70Yv4oPTk4sSorUjBY=;
 b=OOaDpdRM5c+2DfogELbJw4g3xSaoi9WBid1Fo/Jf/Vm2k4L3lG6FDMrabTgD7yrji5Ce+NqzhjeW9fQiMe8ZsgeSjnX8pKzFAgpZGMfayY2HZ2S8RK+M62+4akfr08olPLb/NRVP+0OA0PH6kqG3J9CjzBr9NJjap7jmaZDPXICnD0TLFDo6NtZm/65ymQnxu9bmzfQ2v5+sbV4Q00CLJbL6xYCJCfXCeQTvZgKs12FYwbcqjhX0nrTwFQFpOujjg4El4WM9aHOJHLYENJFmha98aSv3K7Mv60i5VjJRuL1GvzQHFfv6lYfY47drlqLeF49G0KGSSxKdiFatoiEDow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=lunn.ch smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4CzKaz7v320L1sRgNOus3VzK70Yv4oPTk4sSorUjBY=;
 b=Vt5CVGnSyMKqMdxh8axuPIxIStlkblQ7BBCMQ8t9YMU3eFXZPlwfA//oz69eukCHTyH0fBeRALthbVFHjfYbnBd47meZrarHff5o0uPHOHCwcymgOZctCuNVj0yZntUQQynJkrjaEIDmbPIvDpF8OvkP7cbPdJLqrItFrjMtBV0=
Received: from MWHPR02CA0033.namprd02.prod.outlook.com (2603:10b6:301:60::22)
 by DM6PR02MB5259.namprd02.prod.outlook.com (2603:10b6:5:48::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.21; Wed, 4 Sep
 2019 14:00:45 +0000
Received: from BL2NAM02FT040.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::204) by MWHPR02CA0033.outlook.office365.com
 (2603:10b6:301:60::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2241.14 via Frontend
 Transport; Wed, 4 Sep 2019 14:00:44 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 BL2NAM02FT040.mail.protection.outlook.com (10.152.77.193) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Wed, 4 Sep 2019 14:00:43 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:54069 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1i5Vpy-0000wz-EQ; Wed, 04 Sep 2019 07:00:42 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1i5Vpt-0002TG-A8; Wed, 04 Sep 2019 07:00:37 -0700
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1i5Vpk-0002Ac-CK; Wed, 04 Sep 2019 07:00:28 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net
Cc:     michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        harinikatakamlinux@gmail.com, harini.katakam@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Subject: [PATCH v2 1/2] include: mdio: Add driver data helpers
Date:   Wed,  4 Sep 2019 19:30:20 +0530
Message-Id: <1567605621-6818-2-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567605621-6818-1-git-send-email-harini.katakam@xilinx.com>
References: <1567605621-6818-1-git-send-email-harini.katakam@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(2980300002)(189003)(199004)(9786002)(186003)(305945005)(4326008)(50226002)(8936002)(2906002)(126002)(107886003)(50466002)(47776003)(8676002)(51416003)(7696005)(106002)(81166006)(81156014)(11346002)(36756003)(316002)(16586007)(426003)(36386004)(48376002)(2616005)(476003)(44832011)(4744005)(70206006)(70586007)(6666004)(336012)(356004)(478600001)(5660300002)(76176011)(486006)(26005)(446003)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB5259;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 510d24c2-c257-4bb7-b32b-08d7314046ce
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:DM6PR02MB5259;
X-MS-TrafficTypeDiagnostic: DM6PR02MB5259:
X-Microsoft-Antispam-PRVS: <DM6PR02MB52590D10EBD951BBD1BD7734C9B80@DM6PR02MB5259.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 0150F3F97D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: LZv+9in3bCEqp7hyFvJn208Vypoka3ch0Wi+pwoiFn6ErYfA0Bw0ysis0Wm/X/COuZQYymNlv5CDz9Pp7T++lZY6QZZNfb5jzRfc0RZjzzxxjKqkZnhV3zDIMKIlp26AcuMI46TX4hvAZwtCg+cP3g6Pd0KUj4xGtfV3WiGCwQ5PqDaYYimv/rPp4+ZqUDSM20LYWoubzF0hpzZIr9AEIkr6CCVPoZ4S102Z+zlZhNVqhk42hYyvojYrCvoCHLOXhPL0v/1CGyHnXKUuSUjVPH8v6KZOmHnRmuiC6JtuMbffKhta7Y9zt+tXRq6x74zVnF2s9XGh8THHWP5YOds7HLl9Xt3UcPcIeiPsSNDC6bGYQVH84lKsX9vICvxYF2jutoDEyeVvvDjHdxXIDZ6wX+yMLXm9+m6P9QaXqbu8fNc=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2019 14:00:43.0092
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 510d24c2-c257-4bb7-b32b-08d7314046ce
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add set/get drv_data helpers for mdio device.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
v2:
Added this patch driver data helpers in mdio instead of priv field.

 include/linux/mdio.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index e8242ad8..a760424 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -68,6 +68,17 @@ struct mdio_driver {
 #define to_mdio_driver(d)						\
 	container_of(to_mdio_common_driver(d), struct mdio_driver, mdiodrv)
 
+/* device driver data */
+static inline void mdiodev_set_drvdata(struct mdio_device *mdio, void *data)
+{
+	dev_set_drvdata(&mdio->dev, data);
+}
+
+static inline void *mdiodev_get_drvdata(struct mdio_device *mdio)
+{
+	return dev_get_drvdata(&mdio->dev);
+}
+
 void mdio_device_free(struct mdio_device *mdiodev);
 struct mdio_device *mdio_device_create(struct mii_bus *bus, int addr);
 int mdio_device_register(struct mdio_device *mdiodev);
-- 
2.7.4

