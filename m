Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5431831D2DD
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhBPW4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:56:11 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:6342 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230457AbhBPW4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 17:56:09 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GMqtj1028251;
        Tue, 16 Feb 2021 17:55:15 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2051.outbound.protection.outlook.com [104.47.60.51])
        by mx0c-0054df01.pphosted.com with ESMTP id 36pcj9h0yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 17:55:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+R+IfnyXVn1csYBI6n7BTXfNblbJXs7TTwAar7BUjM2tNZ18q2f8w1IhNI2bG3dOFdRlrcvP7HI79fT/hX1w505NhZ/wce759LXbKBWVlMtIH+IGdj4SKp2g7oU1unrY3EovStRy85Ri8DSMqQ++2c+oIxP9nMcusNBadxzPGSUJfuAwlSA5m1Ti1zW3MS0iZhRJR7s/2f1ojn4kDkqLkSogJJMWTFecrPb80CvZPtHm0Tok82OtmCfk1IUvEli9Kfdo99/jSFLF8Q7npzapHbGmd1921XY8ydAvu0aw3CN7ApjSEQ/WPX4OqcjQnoM2b0wihFFZUDhn491vlba4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=poV+CTvCuIZa1xM46dnZJ5wrJV9W8Bqnd7X51keyTWM=;
 b=GUfgWy+yHOCsZuUOBqixARc9un6nqUEwrj8L57dQaFRcdVxspY3Y42jp57Px0i8KG8FHq47vuxrb19FCglOD6zDpJgCI9idXO/wl25tKVGkWqYwbH6Xn8iTZQvMbqBd2ajEaWH52S4T0OEu3lJee2Ou6BC1FMYeJqDiEMgzd0siqb6xcQUC3daeXD95EpcoKEW4sWQPFcjb6OPEaufbvrO1syfQdlJd3Kd5hJxlpN3Pi3x6tMeg4i83GBFlXG5v+iZ/rOGPuPfz53L3zGByZ9q9+BxOnthRBuqxCG2UAeBsiHCEdjOKJCjcF+Y/1dYPb5CvJByjs1GaNGS9GiD9Y6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=poV+CTvCuIZa1xM46dnZJ5wrJV9W8Bqnd7X51keyTWM=;
 b=nqRPlKkalDzN4Jrg1OF7gWtYCSNdxyP6sMt+myTXSgneTmBNp6GbdPOQl6SUy9eCEmCCGwcZHK6D1MqVlT95vz9Ioy9Y8mxDYyN/dE5+ZbkG6By+j6pFevLbhtOAzNjDgFr9Nb6YTpSZRBnovOzrjSsgccBhrgIXOrsDG2gtvwk=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3119.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Tue, 16 Feb
 2021 22:55:14 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 22:55:14 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 2/3] net: phy: Add is_on_sfp_module flag and phy_on_sfp helper
Date:   Tue, 16 Feb 2021 16:54:53 -0600
Message-Id: <20210216225454.2944373-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216225454.2944373-1-robert.hancock@calian.com>
References: <20210216225454.2944373-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0034.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::47)
 To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0034.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38 via Frontend Transport; Tue, 16 Feb 2021 22:55:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d14ff04-667b-4df6-c657-08d8d2cdebdf
X-MS-TrafficTypeDiagnostic: YTBPR01MB3119:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB311904BCC5FD3EE6A162380CEC879@YTBPR01MB3119.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dimANinuKPsyS3sIaaDwfTw+A5JzMrM6cg2SQHBp5WAZs+maung4krufD/bT9gRuiAD2hv+rAE7FmoODPBIu1SpInOrxDm29NaMyRBpwQLvJ7ZYzIyomklAcxrIPekcwFQRIJDpK2mXmeUBwLIBMxeurHqPfkG4R0dRaOgD8APdC3jEnnyCvG3keo1rdMnabXZkJdBtc0Xucm8gOcfxQIc0IIrsWqpwhzN02CNCdGJ5z13Y1l16HrcHE/Vwlgvm70PbIF1eK0EQoXDV0Z4pk+VaPbMJvx8F0TuNAGJr7hru0W0IdJSa0Xpsug7Jf6DzQnX8roD8QIMygaU0hzeIK8tcLzsg1sGfVSceFREGIYq6NPC1YIa/EPufNloyYIZmZWA33002SlhNKO265NhY697W3NZI79CV49wBTE2OxD1zdRtNAaOomJTY/dpbnIZ1mrHprTaATArcdp7Jqny2D3NJAQJfEArARUR89d/sbPfDmhmI4eQQ/XTLkSlEHCj1L3Q948g1vHwiKAmsrj7l92PkwrzqrbH9TRXlwCoDAPpNfvmcj3TeJ/OCJVfFgE4XBJjsRLpWrP8phP43Ygtf/DQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(376002)(136003)(346002)(396003)(4326008)(8936002)(5660300002)(36756003)(66556008)(1076003)(66946007)(16526019)(2616005)(956004)(69590400012)(66476007)(6486002)(478600001)(107886003)(26005)(6506007)(86362001)(44832011)(6512007)(2906002)(52116002)(316002)(83380400001)(6666004)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?k67wDuAlqeHQze4CdHOijamyOQ1RJI2ep2cM2jUtwEcF1wnjjaYgCbCmZlOE?=
 =?us-ascii?Q?qOD50JYtDvI7ZGURUMW/t4x1oagPu0h37TMaSiN8xdTBYLWVGLcoqz8nN2pM?=
 =?us-ascii?Q?onnUNT4W1EbaL/HqHZmNbfOpEt8LePRukUnXdKq6UX9bzru4PGXXYCoCE8m5?=
 =?us-ascii?Q?XFrH4PDoYrBIRrTquOBob7NXfr9dC3ufUctRlqzHx8mLkiep4/jmDbd8sy4f?=
 =?us-ascii?Q?eOCBpN6Kt/VKZ/wIXlcw4zLCRFwQONmzOoFYssa10FzGEjEY2maQT1kG1Jrr?=
 =?us-ascii?Q?D8SsCebjIP5UgKQI6K8UraMzV1Tpau5OG3JcxaspQb4kbDziayh4eB9E1Ggs?=
 =?us-ascii?Q?1SzYl85wPRUWJD396dwVc+NXGFkoNXKr9NDVoNAYHKgZ35HtCUEBVoaPDKGY?=
 =?us-ascii?Q?FXFVEHaRY0RMOmL2vYtf0RvOfktjSDmLJzHaToz/D3JMSai4lzIGoBNCD7S0?=
 =?us-ascii?Q?0Ucb8Sqsp1Kkz7Ze+MoY4b+aegOWWDxWPlml88Kjlk/zPVeyJ6LPXLldZS4p?=
 =?us-ascii?Q?fO4VYvfft71rSPyVBr3ELDxIrnREk1OjqsLdhAf+ufK36w5y8Guvhr6UIuBT?=
 =?us-ascii?Q?0cqIjZeWPifTk0B6tnFa0M1PyPPbMNn2rORYQpSZqeXjZOiQtnFpqMlzEYfX?=
 =?us-ascii?Q?VYu42vEQMdeS36suVswC8j1qoqnOHbmrTz5PP3Qm+KC4Q8AQ/vAPhSi9mKzy?=
 =?us-ascii?Q?Z0GB1ZZ+2WpBy953DgVZ8QLtLPEr0HeIM98gy41jahe7D/GFmEPMgV7KWo0Z?=
 =?us-ascii?Q?vLjpvrwqvtV2YA29oY9HreTVRg55+O6ITL2IKOlMJsw9l6wM1JSNelknLwTy?=
 =?us-ascii?Q?vXy8gT//FyidnoG3qOCrdJg4CO4Ns7+6Do7qKiNwVbWERs+HHRQA2WoAjPPJ?=
 =?us-ascii?Q?vNZImcGpChrAqicykDiPHPDYEuJdigrHixBmMcHvErnby4F4cO1FNEV4pPJV?=
 =?us-ascii?Q?ayKtHhA0N9IMTReM/7WNYhvHSfqLLDmuU6hH++LFSsc2zJBVURyVhAfSCEGz?=
 =?us-ascii?Q?X6luknGBlT9icJ7bkrKffj904nBBnSofvIZy0Z6Ka/T/MY79myJR5c6m5CQ5?=
 =?us-ascii?Q?hFppoBlBiSsW44kRl86fIGjA0Na1eOXEGhLAkkMBSlUjnHG21D0f18+6qTZf?=
 =?us-ascii?Q?pTksiy3qHxGY6Cydj5spiNZ2i+pxpmoGh77rxoBkChekgIMWlpDJzs93KzpG?=
 =?us-ascii?Q?iVNOCgOH8rGQACUzQLYd0GBX1VPLzyjyso86bhCY4lMGb4jKfhpQaEarceMi?=
 =?us-ascii?Q?vjyZ+nYY8ztbpij0nw+0z+sh5hOW3MmP0HchB7JkSchGzRNgkB23RGT6mngM?=
 =?us-ascii?Q?IqP8UOS8YnIO0DaGLsR3nXvE?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d14ff04-667b-4df6-c657-08d8d2cdebdf
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 22:55:14.2203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 63zM/mpkvEaiB8/bLXTfRTiGMsBJY63dAyUIwKaOyfpFwob5FR5CQd8/Df51qei7yyXu+KvM4pSX8zTkIetz5OR/vJYZ7dUFVU+gdMXCxDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3119
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_14:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=769 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160183
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
index 0d537f59b77f..1a12e4436b5b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -492,6 +492,7 @@ struct macsec_ops;
  * @sysfs_links: Internal boolean tracking sysfs symbolic links setup/removal.
  * @loopback_enabled: Set true if this PHY has been loopbacked successfully.
  * @downshifted_rate: Set true if link speed has been downshifted.
+ * @is_on_sfp_module: Set true if PHY is located on an SFP module.
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
  * @irq: IRQ number of the PHY's interrupt (-1 if none)
@@ -565,6 +566,7 @@ struct phy_device {
 	unsigned sysfs_links:1;
 	unsigned loopback_enabled:1;
 	unsigned downshifted_rate:1;
+	unsigned is_on_sfp_module:1;
 
 	unsigned autoneg:1;
 	/* The most recently read link state */
@@ -1296,6 +1298,15 @@ static inline bool phy_is_internal(struct phy_device *phydev)
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

