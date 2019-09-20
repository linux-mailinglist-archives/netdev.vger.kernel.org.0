Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10206B8B38
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 08:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfITGpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 02:45:39 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:51272 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727318AbfITGpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 02:45:39 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8K6gnPU014310;
        Fri, 20 Sep 2019 02:44:45 -0400
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2056.outbound.protection.outlook.com [104.47.36.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 2v3vbdm1jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 02:44:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVE7iSbosAHfe2LJoP+80+Dcsr7MNa9XhmSkeG0KjdZtzZfvyqh0vb1+oJqwMXiIFEtiIEMiI7zcQQY4yCcK8JwJvlornNM/8W98sZ3ckT+sJcQKyk409wZdmzegbCoxsj5hWj94l6hhH4kacflZegHmvCn0rQ223xQ5bnu/VbUoVhNor9ULQyGPRX/vNXCVEgxX1MPw3/e0X9nsmvU94y/05faj1hd6rAeAIeOvTtDANScg9bVmk1RfS1Iz49J/Rxg8w61sk9oH2ydQMiyWDOGK62dAPi+/SL2TDc7UC4Ht0iU9kelCfwlRefm3DBUhlCU2l+3QAVvT22y6SPJmQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKnPhW6WYBTXf+Yn9ylqH0SmnySI1OLLFupOn2icm3E=;
 b=WN8AII8KBsCdcteUOI6W9woDuNZ0ZbVgLdHL0znlQjkZznIErzcSb3iTm/csFiUnR9EdjEbaGihHRBwDJbA0/C/FzgClRty8L/winpcrbNVDzjFM7mrkT0A5Jp3gxbiK3SjJXLZGeR+TnA18pGqO9fdInlDrzQLjuQT5fId8HEISE0CKXaSjWPROI9f4i5wiynGe6o0t3XDpkFdFPjghaX94+o10qzIcVIP/CKcfmriIoFweoiFjavvbvW3smkl1cKKfLGj6RuNrX2PNxPcEKMOpN9LKxgx+hXJSK50FvmrIcr6N+rfT2u0a7IkqJSOSEkjKzoIjTYd/k5eek3ARsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=tuxdriver.com smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKnPhW6WYBTXf+Yn9ylqH0SmnySI1OLLFupOn2icm3E=;
 b=KljZEdMSTng0fE0IVJMrFxVlFXv55MPmKpOnbl4DcHBdekro9FtLWqtcQ5rsgMGwC0AduFQNdYEvbIoryuGYvEz7LYNgj1aojLnKNELWD2UfhcY8UGzcbZ8JzdBDOQi7kFp+jOTwpggz2ts0lr6WzSjvD7ClKSq/eavmNKCxdnc=
Received: from MWHPR03CA0021.namprd03.prod.outlook.com (2603:10b6:300:117::31)
 by DM6PR03MB5228.namprd03.prod.outlook.com (2603:10b6:5:249::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20; Fri, 20 Sep
 2019 06:44:41 +0000
Received: from CY1NAM02FT055.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by MWHPR03CA0021.outlook.office365.com
 (2603:10b6:300:117::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20 via Frontend
 Transport; Fri, 20 Sep 2019 06:44:41 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT055.mail.protection.outlook.com (10.152.74.80) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2263.17
 via Frontend Transport; Fri, 20 Sep 2019 06:44:40 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x8K6iYRs010396
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 19 Sep 2019 23:44:34 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 20 Sep 2019 02:44:39 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>
CC:     <linville@tuxdriver.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 2/2][ethtool] ethtool: implement support for Energy Detect Power Down
Date:   Fri, 20 Sep 2019 12:44:31 +0300
Message-ID: <20190920094431.13806-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190920094431.13806-1-alexandru.ardelean@analog.com>
References: <20190920094431.13806-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(136003)(376002)(346002)(396003)(39860400002)(54534003)(85664002)(189003)(199004)(6666004)(356004)(36756003)(476003)(1076003)(126002)(336012)(4326008)(186003)(478600001)(2351001)(86362001)(44832011)(486006)(7696005)(26005)(51416003)(5660300002)(47776003)(2870700001)(76176011)(48376002)(2906002)(2616005)(107886003)(8676002)(8936002)(50466002)(246002)(426003)(14444005)(7636002)(305945005)(6916009)(70206006)(316002)(11346002)(106002)(54906003)(446003)(70586007)(50226002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB5228;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b422bf8-a566-4f53-4a58-08d73d96032a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR03MB5228;
X-MS-TrafficTypeDiagnostic: DM6PR03MB5228:
X-Microsoft-Antispam-PRVS: <DM6PR03MB5228DD7827DA983F755EB2E6F9880@DM6PR03MB5228.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:323;
X-Forefront-PRVS: 0166B75B74
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: A2cHarMDMthNZO6QA4hlOc52pDo35d5dk1AboGXdn/Su49S5xgj+fHfuWLoTPSd6VSAOTBH8Mo1tIp2kZNAQ7zwhdQzVTd8OTbasMAmjk7BnKY03PN+mFf7l3LlDNVU9LKH6bCkJkELLgFFJ/mJGLwONbeID1CCfRWe7EHqwuTbupmIsDzQdWAPSIL2Z16jB8VhrV6mJGytkN8SD26c3mKySGb4KFS7ARW+OBfBG0w63qNve6zbML19I5BgPIab2TCEkBkev+STPH5t5/xdgPvX5TxwxIg+jVjonQG0y4VA3KYr+N8Ix0uS/nqUr4a6Ek6K+gf1VnHGkNwR8ZYmJyqYYLu3MAGQ/4epA2VIHMy8hG2d2btQcRdGDvxEFXHUWAiekWE2CAKQ1kSIMpm240ABI7TUxdLAf1iTQd9gopwg=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2019 06:44:40.2545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b422bf8-a566-4f53-4a58-08d73d96032a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5228
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-20_01:2019-09-19,2019-09-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=15 adultscore=0 spamscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909200072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds control for enabling/disabling Energy Detect Power Down
mode, as well as configuring wake-up intervals for TX pulses, via the new
ETHTOOL_PHY_EDPD control added in PHY tunable, in the kernel.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---

Changelog v1 -> v2:
* reworked the parse_named_uint() function to avoid casting to types based
  on Andrew's feedback

 ethtool.8.in | 28 ++++++++++++++++
 ethtool.c    | 94 +++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 118 insertions(+), 4 deletions(-)

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
index c0e2903..082e37f 100644
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
@@ -5018,7 +5042,10 @@ static int parse_named_bool(struct cmd_context *ctx, const char *name, u8 *on)
 	return 1;
 }
 
-static int parse_named_u8(struct cmd_context *ctx, const char *name, u8 *val)
+static int parse_named_uint(struct cmd_context *ctx,
+			    const char *name,
+			    unsigned long long *val,
+			    unsigned long long max)
 {
 	if (ctx->argc < 2)
 		return 0;
@@ -5026,7 +5053,7 @@ static int parse_named_u8(struct cmd_context *ctx, const char *name, u8 *val)
 	if (strcmp(*ctx->argp, name))
 		return 0;
 
-	*val = get_uint_range(*(ctx->argp + 1), 0, 0xff);
+	*val = get_uint_range(*(ctx->argp + 1), 0, max);
 
 	ctx->argc -= 2;
 	ctx->argp += 2;
@@ -5034,6 +5061,30 @@ static int parse_named_u8(struct cmd_context *ctx, const char *name, u8 *val)
 	return 1;
 }
 
+static int parse_named_u8(struct cmd_context *ctx, const char *name, u8 *val)
+{
+	unsigned long long val1;
+	int ret;
+
+	ret = parse_named_uint(ctx, name, &val1, 0xff);
+	if (ret)
+		*val = val1;
+
+	return ret;
+}
+
+static int parse_named_u16(struct cmd_context *ctx, const char *name, u16 *val)
+{
+	unsigned long long val1;
+	int ret;
+
+	ret = parse_named_uint(ctx, name, &val1, 0xffff);
+	if (ret)
+		*val = val1;
+
+	return ret;
+}
+
 static int do_set_phy_tunable(struct cmd_context *ctx)
 {
 	int err = 0;
@@ -5041,6 +5092,8 @@ static int do_set_phy_tunable(struct cmd_context *ctx)
 	u8 ds_changed = 0, ds_has_cnt = 0, ds_enable = 0;
 	u8 fld_changed = 0, fld_enable = 0;
 	u8 fld_msecs = ETHTOOL_PHY_FAST_LINK_DOWN_ON;
+	u8 edpd_changed = 0, edpd_enable = 0;
+	u16 edpd_tx_interval = ETHTOOL_PHY_EDPD_DFLT_TX_MSECS;
 
 	/* Parse arguments */
 	if (parse_named_bool(ctx, "downshift", &ds_enable)) {
@@ -5050,6 +5103,11 @@ static int do_set_phy_tunable(struct cmd_context *ctx)
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
@@ -5074,6 +5132,16 @@ static int do_set_phy_tunable(struct cmd_context *ctx)
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
@@ -5109,6 +5177,22 @@ static int do_set_phy_tunable(struct cmd_context *ctx)
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
@@ -5361,10 +5445,12 @@ static const struct option {
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

