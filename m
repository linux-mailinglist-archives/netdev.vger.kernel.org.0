Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E5EB73B9
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 09:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388449AbfISHJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 03:09:45 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:8616 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387931AbfISHJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 03:09:45 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8J78KJL020189;
        Thu, 19 Sep 2019 03:08:53 -0400
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2051.outbound.protection.outlook.com [104.47.34.51])
        by mx0b-00128a01.pphosted.com with ESMTP id 2v3vb5sfvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Sep 2019 03:08:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=me/6pYQsNfbykatTCV/xOkrSDdCdd79omSDsSJWYxllMfpUjVl5Aty81179qGoiKnZZ/a5/7dH20PmHoXmNVGT2ldrfMakClx9pez8LcGg7/UWIMfej2Tw2gStCaVNgWyuuIXkHGBxfC4sFXhBnlV5MOxY3Ok+caHLkBPZmjO3lGs6m9mZKNX6gwqV6456DHs2/OEEdCbCpcA5QER2MNzgwZmYs8Ls4gerfkmX0kpmTsmFxdR+GJUDx4uh+AiUCa7xdAz8ymGabFiSrTALfPys088EByimNKNvlqLhPA3hzMNAbdrvXXo9a8nPGYCkFGQMllO4nlJoxSjLKvJs4zqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbNjKdJvLSWIsH+SuIZf7KAOLVR6XbZfPXugafIVvO4=;
 b=maOjLE9j6CQe+0fb8z/Ecf3I2UEuM1fGv88819rvZUPHV/jRB4zNaCRnNY3oQXlsIxlbAcjoiT3c5AO+OldZbJ9UUMqv4f93HODAmKR20kc2ZzMWxWo3hK9/tUzDoueYkmr7iy0VDCzj26Zpy8YRLuoY/16NFXz8N4MiTpKMzTuzdsP1Gt3r/Y08j2ViXSEpn8g+jrfgxLZbTaTRiwfZWIX5RzPqVVQlkBAkNxKNP4JHz78JXllHMDa11/9mBMDlKeMm94p1S/tIYhAyazjT23I6HYzUwe/HCltTVm2IvY+mVIfr303Nke2obupgokknMAuoBA149tPwVQc6WOLrJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=tuxdriver.com smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbNjKdJvLSWIsH+SuIZf7KAOLVR6XbZfPXugafIVvO4=;
 b=Mg8Hf7nYIxxbbXe9R2wu2Gcm9BeCo7d1D8SQPHbvknrDFnrRYfWoXwqBOGP0R82LlX0aVVfKm65MFZpQ9jkHqc7Lxg2S6Mj5BEiQU2bX6UDt7DYQVHN7MKSivxyoZo4LkxlFXbcglEpzsiWKp/ggwgpe1Dl/lsW2mPCeLAzmucQ=
Received: from BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33)
 by MN2PR03MB5007.namprd03.prod.outlook.com (2603:10b6:208:1a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20; Thu, 19 Sep
 2019 07:08:51 +0000
Received: from SN1NAM02FT033.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by BYAPR03CA0020.outlook.office365.com
 (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.21 via Frontend
 Transport; Thu, 19 Sep 2019 07:08:50 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT033.mail.protection.outlook.com (10.152.72.133) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2263.17
 via Frontend Transport; Thu, 19 Sep 2019 07:08:48 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x8J78mG7010718
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 19 Sep 2019 00:08:48 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 19 Sep 2019 03:08:47 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>
CC:     <linville@tuxdriver.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 2/2][ethtool] ethtool: implement support for Energy Detect Power Down
Date:   Thu, 19 Sep 2019 13:08:33 +0300
Message-ID: <20190919100833.6208-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190919100833.6208-1-alexandru.ardelean@analog.com>
References: <20190919100833.6208-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(136003)(376002)(346002)(396003)(85664002)(189003)(199004)(7696005)(47776003)(478600001)(246002)(4326008)(5660300002)(8676002)(8936002)(7636002)(106002)(1076003)(54906003)(50226002)(305945005)(6916009)(50466002)(44832011)(186003)(426003)(26005)(2906002)(36756003)(70206006)(70586007)(11346002)(446003)(86362001)(2870700001)(316002)(6666004)(14444005)(76176011)(356004)(48376002)(2616005)(2351001)(476003)(51416003)(126002)(107886003)(336012)(486006)(461764006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR03MB5007;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cecddd90-6552-461c-6c95-08d73cd03822
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:MN2PR03MB5007;
X-MS-TrafficTypeDiagnostic: MN2PR03MB5007:
X-Microsoft-Antispam-PRVS: <MN2PR03MB50071FCFFF365D87F14B3A09F9890@MN2PR03MB5007.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:323;
X-Forefront-PRVS: 016572D96D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: A281kqwtIwMA7+zzDgzvqYRGxBhuaqkm+I1dTJmuIXSgosXc1vSKx3wFAwF9ZDXswfvgEpbWIqPRzteI9d1IiR/5HWPLIh1B/jvasg5xkb6DvOZ/0NA+7lccIPEE3N6w+C2qvaTIPlmNH2RyBlq9Oo+JGx/amlOUz0hmiLCpAW5K8AMdKtCbxAtmZURcrmUiyg9yUeeGolpw53kZRErTsudAg3lur1orcNk6nWTs/uKfWGqG8xrn+wHWIpgv8sOCEAUwNceJwGsPLbWMok5RZ7Xsgo3fCOJqBTFocQokho2B3vjbKA7q1e82YC2aKyBGPWI5a6rsp1rAwHBRHfNyHiwjB+hIHqsqoHk6L2I/I7t8KHt53ML101rlVMu0m4xKFQ+14MGAnCgTMc0Ham3E626h11P7raAlMh73zBsYelU=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2019 07:08:48.7757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cecddd90-6552-461c-6c95-08d73cd03822
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB5007
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-19_02:2019-09-18,2019-09-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=15
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909190067
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds control for enabling/disabling Energy Detect Power Down
mode, as well as configuring wake-up intervals for TX pulses, via the new
ETHTOOL_PHY_EDPD control added in PHY tunable, in the kernel.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 ethtool.8.in | 28 +++++++++++++++++
 ethtool.c    | 87 +++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/ethtool.8.in b/ethtool.8.in
index cd3be91..609a05a 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -362,11 +362,17 @@ ethtool \- query or control network driver and hardware settings
 .A1 on off
 .BN msecs
 .RB ]
+.RB [
+.B energy\-detect\-power\-down
+.A1 on off
+.BN msecs
+.RB ]
 .HP
 .B ethtool \-\-get\-phy\-tunable
 .I devname
 .RB [ downshift ]
 .RB [ fast-link-down ]
+.RB [ energy-detect-power-down ]
 .HP
 .B ethtool \-\-reset
 .I devname
@@ -1100,6 +1106,24 @@ lB	l.
 	Sets the period after which the link is reported as down. Note that the PHY may choose
 	the closest supported value. Only on reading back the tunable do you get the actual value.
 .TE
+.TP
+.A2 energy-detect-power-down on off
+Specifies whether Energy Detect Power Down (EDPD) should be enabled (if supported).
+This will put the RX and TX circuit blocks into a low power mode, and the PHY will
+wake up periodically to send link pulses to avoid any lock-up situation with a peer
+PHY that may also have EDPD enabled. By default, this setting will also enable the
+periodic transmission of TX pulses.
+.TS
+nokeep;
+lB	l.
+.BI msecs \ N
+	Some PHYs support configuration of the wake-up interval to send TX pulses.
+	This setting allows the control of this interval, and 0 disables TX pulses
+	if the PHY supports this. Disabling TX pulses can create a lock-up situation
+	where neither of the PHYs wakes the other one. If unspecified the default
+	value (in milliseconds) will be used by the PHY.
+.TE
+.TP
 .PD
 .RE
 .TP
@@ -1122,6 +1146,10 @@ Some PHYs support a Fast Link Down Feature and may allow configuration of the de
 before a broken link is reported as being down.
 
 Gets the PHY Fast Link Down status / period.
+.TP
+.B energy\-detect\-power\-down
+Gets the current configured setting for Energy Detect Power Down (if supported).
+
 .RE
 .TP
 .B \-\-reset
diff --git a/ethtool.c b/ethtool.c
index c0e2903..45b5478 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -4897,6 +4897,30 @@ static int do_get_phy_tunable(struct cmd_context *ctx)
 		else
 			fprintf(stdout, "Fast Link Down enabled, %d msecs\n",
 				cont.msecs);
+	} else if (!strcmp(argp[0], "energy-detect-power-down")) {
+		struct {
+			struct ethtool_tunable ds;
+			u16 msecs;
+		} cont;
+
+		cont.ds.cmd = ETHTOOL_PHY_GTUNABLE;
+		cont.ds.id = ETHTOOL_PHY_EDPD;
+		cont.ds.type_id = ETHTOOL_TUNABLE_U16;
+		cont.ds.len = 2;
+		if (send_ioctl(ctx, &cont.ds) < 0) {
+			perror("Cannot Get PHY Energy Detect Power Down value");
+			return 87;
+		}
+
+		if (cont.msecs == ETHTOOL_PHY_EDPD_DISABLE)
+			fprintf(stdout, "Energy Detect Power Down: disabled\n");
+		else if (cont.msecs == ETHTOOL_PHY_EDPD_NO_TX)
+			fprintf(stdout,
+				"Energy Detect Power Down: enabled, TX disabled\n");
+		else
+			fprintf(stdout,
+				"Energy Detect Power Down: enabled, TX %u msecs\n",
+				cont.msecs);
 	} else {
 		exit_bad_args();
 	}
@@ -5018,7 +5042,8 @@ static int parse_named_bool(struct cmd_context *ctx, const char *name, u8 *on)
 	return 1;
 }
 
-static int parse_named_u8(struct cmd_context *ctx, const char *name, u8 *val)
+static int parse_named_uint(struct cmd_context *ctx, const char *name,
+			    void *val, enum tunable_type_id type_id)
 {
 	if (ctx->argc < 2)
 		return 0;
@@ -5026,7 +5051,16 @@ static int parse_named_u8(struct cmd_context *ctx, const char *name, u8 *val)
 	if (strcmp(*ctx->argp, name))
 		return 0;
 
-	*val = get_uint_range(*(ctx->argp + 1), 0, 0xff);
+	switch (type_id) {
+	case ETHTOOL_TUNABLE_U8:
+		*(u8 *)val = get_uint_range(*(ctx->argp + 1), 0, 0xff);
+		break;
+	case ETHTOOL_TUNABLE_U16:
+		*(u16 *)val = get_uint_range(*(ctx->argp + 1), 0, 0xffff);
+		break;
+	default:
+		return 0;
+	}
 
 	ctx->argc -= 2;
 	ctx->argp += 2;
@@ -5034,6 +5068,16 @@ static int parse_named_u8(struct cmd_context *ctx, const char *name, u8 *val)
 	return 1;
 }
 
+static int parse_named_u8(struct cmd_context *ctx, const char *name, u8 *val)
+{
+	return parse_named_uint(ctx, name, val, ETHTOOL_TUNABLE_U8);
+}
+
+static int parse_named_u16(struct cmd_context *ctx, const char *name, u16 *val)
+{
+	return parse_named_uint(ctx, name, val, ETHTOOL_TUNABLE_U16);
+}
+
 static int do_set_phy_tunable(struct cmd_context *ctx)
 {
 	int err = 0;
@@ -5041,6 +5085,8 @@ static int do_set_phy_tunable(struct cmd_context *ctx)
 	u8 ds_changed = 0, ds_has_cnt = 0, ds_enable = 0;
 	u8 fld_changed = 0, fld_enable = 0;
 	u8 fld_msecs = ETHTOOL_PHY_FAST_LINK_DOWN_ON;
+	u8 edpd_changed = 0, edpd_enable = 0;
+	u16 edpd_tx_interval = ETHTOOL_PHY_EDPD_DFLT_TX_MSECS;
 
 	/* Parse arguments */
 	if (parse_named_bool(ctx, "downshift", &ds_enable)) {
@@ -5050,6 +5096,11 @@ static int do_set_phy_tunable(struct cmd_context *ctx)
 		fld_changed = 1;
 		if (fld_enable)
 			parse_named_u8(ctx, "msecs", &fld_msecs);
+	} else if (parse_named_bool(ctx, "energy-detect-power-down",
+				    &edpd_enable)) {
+		edpd_changed = 1;
+		if (edpd_enable)
+			parse_named_u16(ctx, "msecs", &edpd_tx_interval);
 	} else {
 		exit_bad_args();
 	}
@@ -5074,6 +5125,16 @@ static int do_set_phy_tunable(struct cmd_context *ctx)
 			fld_msecs = ETHTOOL_PHY_FAST_LINK_DOWN_OFF;
 		else if (fld_msecs == ETHTOOL_PHY_FAST_LINK_DOWN_OFF)
 			exit_bad_args();
+	} else if (edpd_changed) {
+		if (!edpd_enable)
+			edpd_tx_interval = ETHTOOL_PHY_EDPD_DISABLE;
+		else if (edpd_tx_interval == 0)
+			edpd_tx_interval = ETHTOOL_PHY_EDPD_NO_TX;
+		else if (edpd_tx_interval > ETHTOOL_PHY_EDPD_NO_TX) {
+			fprintf(stderr, "'msecs' max value is %d.\n",
+				(ETHTOOL_PHY_EDPD_NO_TX - 1));
+			exit_bad_args();
+		}
 	}
 
 	/* Do it */
@@ -5109,6 +5170,22 @@ static int do_set_phy_tunable(struct cmd_context *ctx)
 			perror("Cannot Set PHY Fast Link Down value");
 			err = 87;
 		}
+	} else if (edpd_changed) {
+		struct {
+			struct ethtool_tunable fld;
+			u16 msecs;
+		} cont;
+
+		cont.fld.cmd = ETHTOOL_PHY_STUNABLE;
+		cont.fld.id = ETHTOOL_PHY_EDPD;
+		cont.fld.type_id = ETHTOOL_TUNABLE_U16;
+		cont.fld.len = 2;
+		cont.msecs = edpd_tx_interval;
+		err = send_ioctl(ctx, &cont.fld);
+		if (err < 0) {
+			perror("Cannot Set PHY Energy Detect Power Down");
+			err = 87;
+		}
 	}
 
 	return err;
@@ -5361,10 +5438,12 @@ static const struct option {
 	  "		[ tx-timer %d ]\n"},
 	{ "--set-phy-tunable", 1, do_set_phy_tunable, "Set PHY tunable",
 	  "		[ downshift on|off [count N] ]\n"
-	  "		[ fast-link-down on|off [msecs N] ]\n"},
+	  "		[ fast-link-down on|off [msecs N] ]\n"
+	  "		[ energy-detect-power-down on|off [msecs N] ]\n"},
 	{ "--get-phy-tunable", 1, do_get_phy_tunable, "Get PHY tunable",
 	  "		[ downshift ]\n"
-	  "		[ fast-link-down ]\n"},
+	  "		[ fast-link-down ]\n"
+	  "		[ energy-detect-power-down ]\n"},
 	{ "--reset", 1, do_reset, "Reset components",
 	  "		[ flags %x ]\n"
 	  "		[ mgmt ]\n"
-- 
2.20.1

