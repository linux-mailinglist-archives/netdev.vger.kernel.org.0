Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A383A6951
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfICNGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:06:52 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:6334 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729419AbfICNGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:06:51 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83D32pN016281;
        Tue, 3 Sep 2019 09:06:47 -0400
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2058.outbound.protection.outlook.com [104.47.41.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 2uqnt8cv6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 09:06:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMVNdy/bsiL2ufOsN8YGmzVwHCGsFFNlbzpJwiNTflaI0XS3+dhVth+jhPcbEtQZv9bu7nR+whNoUcDaP984CXmjww2FMlrMtv87LP/rkrbn/UyJEzNtUgxfxRYGBn25Exp6Mb4OEvL8WUimTDUF81Sll/+33XMejBbbkgX1ULF+RPUMrUmYIoMzOWkO4cQmYzaGrQ59iczkKMx2SaSGnuOG5w6NFMjgvX55HbQbssX9xLy37KxA4jDQE3ilAcx+2h7UrAWrJDUNGXMzBlD0aUr+nBRmClAyTIzWl1H/OpGgAhm/Ma2k/OTP5cgITfBvSki/JkSt2/+jHnknomDFig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=126dswSa853dDGm6mfNb71XOC2qutR9mP2EDaU0Qs9M=;
 b=baqF5zUA2DfX5VREn7LA0TWfIKzuBLeFfaCPsWTKQWTZo7xO4Z58EWXr7iaoHqKYN+fZopRBcDdELddnEYTr/rYTgVckr4NIzBM2thcQOGCtebrPsUYU/fWM/x2aBN0NLnVIL2PgHwxycSAguASUG+epU3ae5Whpca5dt6h/FFpMrx+M5Vp7RF/S3WkUgJz1SAUigU8pz/IHoejFYAW8bACeOXbiio9HUfTX7j+n36In/3cDJdlOhij/aLEYr6uyP9le5BOGtEQIr24eqhWZfTlcz8m3R4p05NHRziWC4tu3SsvPxyLQqMOWGwcsUw+Y7RRGBmc/NEKp5PgW3Z5tnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=lunn.ch smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=126dswSa853dDGm6mfNb71XOC2qutR9mP2EDaU0Qs9M=;
 b=rqYXtqkPNQDggLvcGC4J31QJP+KnCU1QE+wTzYt5eK2uqWqML3pHDBfsUmcEkJmTlIPkvMn5NEIwpwvOLGApnOiGzGXVBZnJgNHig16/UCSRcELXCcpHB5k390qq8UQj3SJcw8asTfYaztldtAbIPJU3yEakjy9b2cmjSMXLaBM=
Received: from DM6PR03CA0069.namprd03.prod.outlook.com (2603:10b6:5:100::46)
 by SN2PR03MB2285.namprd03.prod.outlook.com (2603:10b6:804:d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.20; Tue, 3 Sep
 2019 13:06:45 +0000
Received: from BL2NAM02FT025.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::203) by DM6PR03CA0069.outlook.office365.com
 (2603:10b6:5:100::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.19 via Frontend
 Transport; Tue, 3 Sep 2019 13:06:45 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT025.mail.protection.outlook.com (10.152.77.151) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Tue, 3 Sep 2019 13:06:44 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x83D6dZw024888
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 3 Sep 2019 06:06:39 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Tue, 3 Sep 2019 09:06:43 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 4/4] [ethtool] ethtool: implement support for Energy Detect Power Down
Date:   Tue, 3 Sep 2019 19:06:26 +0300
Message-ID: <20190903160626.7518-5-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903160626.7518-1-alexandru.ardelean@analog.com>
References: <20190903160626.7518-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(376002)(39860400002)(2980300002)(85664002)(189003)(199004)(316002)(107886003)(336012)(70586007)(7696005)(76176011)(86362001)(26005)(70206006)(6666004)(356004)(54906003)(110136005)(2906002)(106002)(50466002)(1076003)(44832011)(36756003)(50226002)(186003)(126002)(476003)(8936002)(51416003)(426003)(7636002)(486006)(14444005)(305945005)(47776003)(2870700001)(446003)(478600001)(8676002)(5660300002)(246002)(11346002)(48376002)(4326008)(2616005)(461764006);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR03MB2285;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85e4eb23-fa35-43b2-b9de-08d7306f91cc
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:SN2PR03MB2285;
X-MS-TrafficTypeDiagnostic: SN2PR03MB2285:
X-Microsoft-Antispam-PRVS: <SN2PR03MB22856B7378933FCC211A114BF9B90@SN2PR03MB2285.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:323;
X-Forefront-PRVS: 01494FA7F7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: yWqMKhkgC1b7XtXhbNLPI2H8RWpHMpxNPtYY3ztHXBIUrrSsawfJ4L7pA2iNEmoVwbbXP7ow+QnybmJIY8tltEpjENGr0rJ8Z59KMsnq7ACckBSou8NK5JL6vAVnGOhhIWuquvwQqNpLDEcSZCcpnjqU1soqHA6UPdmUTcykLle56P0xkcMX7x22NOK+g6o1jWmHY7bTpMd5uut1mCNTe06mQ2KGtrf8sJrQvUpNkqG3pOCaOASqR4dqy1qGD+/oDlwTzduqdAgYQxDofhoUt0eBYrqU1OAJnaqUYba0sqDO12yjlp2Gp5raNPJMIVnehq5dPWblw8IJErVzSfEQ+FCGtjoErsEmVfGM5hDVNvMxnXbIAJZ6sKje1ChF8mgQOXICeYZjo9HXJT19hSR9+UE7mqGZwzFFiJGsRElp9vA=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2019 13:06:44.0749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85e4eb23-fa35-43b2-b9de-08d7306f91cc
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR03MB2285
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_02:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 suspectscore=9 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909030137
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
index cd3be91..a32d48b 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -362,11 +362,17 @@ ethtool \- query or control network driver and hardware settings
 .A1 on off
 .BN msecs
 .RB ]
+.RB [
+.B energy\-detect\-power\-down
+.A1 on off
+.BN tx-interval
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
+.BI tx-interval \ N
+	Some PHYs support configuration of the wake-up interval to send TX pulses.
+	This setting allows the control of this interval, and 0 disables TX pulses
+	if the PHY supports this. Disabling TX pulses can create a lock-up situation
+	where neither of the PHYs wakes the other one. If the PHY supports only
+	a single interval, any non-zero value will enable this.
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
index c0e2903..c0a18f8 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -4897,6 +4897,30 @@ static int do_get_phy_tunable(struct cmd_context *ctx)
 		else
 			fprintf(stdout, "Fast Link Down enabled, %d msecs\n",
 				cont.msecs);
+	} else if (!strcmp(argp[0], "energy-detect-power-down")) {
+		struct {
+			struct ethtool_tunable ds;
+			u16 tx_interval;
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
+		if (cont.tx_interval == ETHTOOL_PHY_EDPD_DISABLE)
+			fprintf(stdout, "Energy Detect Power Down: disabled\n");
+		else if (cont.tx_interval == ETHTOOL_PHY_EDPD_NO_TX)
+			fprintf(stdout,
+				"Energy Detect Power Down: enabled, TX disabled\n");
+		else
+			fprintf(stdout,
+				"Energy Detect Power Down: enabled, TX %u intervals\n",
+				cont.tx_interval);
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
+	u16 edpd_tx_interval = ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL;
 
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
+			parse_named_u16(ctx, "tx-interval", &edpd_tx_interval);
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
+		else if (edpd_tx_interval > ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL) {
+			fprintf(stderr, "'tx-interval' max value is %d.\n",
+				(ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL - 1));
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
+			u16 tx_interval;
+		} cont;
+
+		cont.fld.cmd = ETHTOOL_PHY_STUNABLE;
+		cont.fld.id = ETHTOOL_PHY_EDPD;
+		cont.fld.type_id = ETHTOOL_TUNABLE_U16;
+		cont.fld.len = 2;
+		cont.tx_interval = edpd_tx_interval;
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
+	  "		[ energy-detect-power-down on|off [tx-interval N] ]\n"},
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

