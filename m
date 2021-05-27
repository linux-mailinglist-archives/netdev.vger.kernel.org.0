Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0686392F22
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 15:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbhE0NJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 09:09:21 -0400
Received: from mail-mw2nam12on2079.outbound.protection.outlook.com ([40.107.244.79]:24640
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235963AbhE0NJU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 09:09:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WarG+EtydZAfhbEWZf7nsjh86VJsVqRuaHnz17W0dhDpYmeksuytg5QKma/4BMUFj8yHul3A3idtH5flyf2spG650Fo7lNz7c1Av0x/JEsyomtUUVqbX7IX179WkNiAKNH6bbQNCfzXFLwIPt40RnL8cQqiQ/Ac6DpXFTYg5Q9L3Uas+kgqHJmWMPqwmyjRVb49uIYc4ZNL1KjUqBkAB65JUJWIE6s4ghKgAO2EEuBNvAKOynGpp9KCLCDmVPkntvKhKYo2tg/lhEihfyM5Ii5WgQNdXB5G/INuKHPb7EE+XIW926NZrEQRfP8NvdzJATBdR42Db3UezXGiPI33JOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fd05E//4abHwL9suMhjB+BBnTz6xgy7ycnEzUeasguU=;
 b=mZybSgltWHrMraNyy6an8iJ0Bj8rmUcLtr0RAfhyT/MypmRlMKIOLpx8OiuSy27dlZgAJFm1oqcTsjJD61lPg8b2+3eo+DTS20oDH4eCnVa1p2QtzcxpG7vv28Pk7aL9QQ/rC2qCdq/LGSflJF0IQi627XBbz/otmgcwVGV4J4kiK780PipG633Naj+MpABQbd0MWUlEksarkjFC6jdAbBjVy4RuN1k2zytrIbnxOa/jTD16dnTotCA09UWlNBxozSJuMwVB1P+RwfeKkCrlVAdyMl6PkDigNrAoK5RslFe4q8ERcBjJoI2ZQQCvCjADW8SKU2NwyinYznODRz59CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fd05E//4abHwL9suMhjB+BBnTz6xgy7ycnEzUeasguU=;
 b=lM3WE8errJmOHJ5oYKcl8vLjiQMW8igsSsHye8TliTExfsbD84DnPpV3fLH6jbO8cMtNQT/CnbMVyLSWafiBX496wvRn/oz6GvhlCZEUOvcbIalfh9Q/a11l0kA2QRYw37nPgMEU0QQbM8QSDgmOmWKXxXTx2T3RXWZVW+PO7t06lNkxF2gsypGsbCTHbhFnSwNpHS4xfcOQD9PsbGhYU1XnnYC1ZbAAlvNwT0MiTXl6vtb0cSvNEoby5nCwsZ3HWYo0OQQLEqPvakGP0jWf5tgW+9H8eriuniV3XPdmiW31fH6Mjm24QZ0G8Yg3lyVi7VvTzxOLMLn4E4iFJyyMkw==
Received: from DM5PR13CA0012.namprd13.prod.outlook.com (2603:10b6:3:23::22) by
 CH2PR12MB4905.namprd12.prod.outlook.com (2603:10b6:610:64::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.27; Thu, 27 May 2021 13:07:46 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::25) by DM5PR13CA0012.outlook.office365.com
 (2603:10b6:3:23::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.10 via Frontend
 Transport; Thu, 27 May 2021 13:07:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 27 May 2021 13:07:45 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 06:07:45 -0700
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 May 2021 13:07:44 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Subject: [PATCH iproute2-next] police: Add support for json output
Date:   Thu, 27 May 2021 16:07:42 +0300
Message-ID: <20210527130742.1070668-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73b52957-89e4-469c-7bd0-08d921106bb4
X-MS-TrafficTypeDiagnostic: CH2PR12MB4905:
X-Microsoft-Antispam-PRVS: <CH2PR12MB49055D7B3B52567D1A1BD144B8239@CH2PR12MB4905.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:65;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G9/AgIU1YRdcnBFJD9WFmxOG4AZn0oJGETg6Tu9GpxBg2W9GGUmkbTKidGOj0Sbt3e8DB3eyWfKliptds1i5aR9fU8dM9P8/pssww9S13agf5+vfJcfFxTI5xG4Sikn5xaFQ0/llV7cKh30eRHwJMRmbPyEy4VlDrab9BUO9farwwieE1y0IIKqfFyc2RfGw6IaAtKcADpVy/Apafu67x1n/hv5Cpzzmg/zzJ9vqPDcfxb+2SGcrld/hV/kIQ61aVhvPJW6KDHw/6tNrGBpEtpAgsmrumcJBImLtc3PGaNlrShQYkXTQNzXHk/uDTK2p2sNEGXxXiM04Ttz1NElI72JeR6toTlBxSMkpl7Vv5BO7tlwKrjntBvhkoP0dj959jawpR7S3J6QNEEYuMVrH/4Z8F+UaYvEdHAA9Hi9tT1lVjwYorm8i7bl52a4swGWp2KikljpZ39aZ/2+3V8KHrLHAAZ867PEVJD5g8ZhF3QTET0kzK1zp7YWq196wrI2ljq3NLvnFp7cF+CG2Umk7BXjHubPUV7dQhM1tsRmK7PqpsV/xAhICqRpbwS9egirRkKb2MGKTMbgZqNGoZ6vz6Z65ulL9NENT2kyMFoXTi8udz2ud20V3YHg698vUugGF9wTRSwqoLIs3ekrA490Vpg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(376002)(36840700001)(46966006)(1076003)(8936002)(82310400003)(426003)(107886003)(2906002)(47076005)(8676002)(26005)(7636003)(478600001)(82740400003)(86362001)(70586007)(70206006)(36860700001)(336012)(5660300002)(4326008)(36756003)(6916009)(186003)(2616005)(356005)(54906003)(316002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 13:07:45.8750
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73b52957-89e4-469c-7bd0-08d921106bb4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change to use the print wrappers instead of fprintf().

This is example output of the options part before this commit:

        "options": {
            "handle": 1,
            "in_hw": true,
            "actions": [ {
                    "order": 1 police 0x2 ,
                    "control_action": {
                        "type": "drop"
                    },
                    "control_action": {
                        "type": "continue"
                    }overhead 0b linklayer unspec
        ref 1 bind 1
,
                    "used_hw_stats": [ "delayed" ]
                } ]
        }

This is the output of the same dump with this commit:

        "options": {
            "handle": 1,
            "in_hw": true,
            "actions": [ {
                    "order": 1,
                    "police": 2,
                    "control_action": {
                        "type": "drop"
                    },
                    "control_action": {
                        "type": "continue"
                    },
                    "overhead": 0,
                    "linklayer": "unspec",
                    "ref": 1,
                    "bind": 1,
                    "used_hw_stats": [ "delayed" ]
                } ]
        }

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 tc/m_police.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/tc/m_police.c b/tc/m_police.c
index 9ef0e40b861b..23ec973bee26 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -284,12 +284,12 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_POLICE_MAX, arg);
 
 	if (tb[TCA_POLICE_TBF] == NULL) {
-		fprintf(f, "[NULL police tbf]");
+		print_string(PRINT_FP, NULL, "%s", "[NULL police tbf]");
 		return 0;
 	}
 #ifndef STOOPID_8BYTE
 	if (RTA_PAYLOAD(tb[TCA_POLICE_TBF])  < sizeof(*p)) {
-		fprintf(f, "[truncated police tbf]");
+		print_string(PRINT_FP, NULL, "%s", "[truncated police tbf]");
 		return -1;
 	}
 #endif
@@ -300,13 +300,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
 		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
 
-	fprintf(f, " police 0x%x ", p->index);
+	print_int(PRINT_ANY, "police", "police %d ", p->index);
 	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
 	buffer = tc_calc_xmitsize(rate64, p->burst);
 	print_size(PRINT_FP, NULL, "burst %s ", buffer);
 	print_size(PRINT_FP, NULL, "mtu %s ", p->mtu);
 	if (show_raw)
-		fprintf(f, "[%08x] ", p->burst);
+		print_hex(PRINT_FP, NULL, "[%08x] ", p->burst);
 
 	prate64 = p->peakrate.rate;
 	if (tb[TCA_POLICE_PEAKRATE64] &&
@@ -327,8 +327,8 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 		pps64 = rta_getattr_u64(tb[TCA_POLICE_PKTRATE64]);
 		ppsburst64 = rta_getattr_u64(tb[TCA_POLICE_PKTBURST64]);
 		ppsburst64 = tc_calc_xmitsize(pps64, ppsburst64);
-		fprintf(f, "pkts_rate %llu ", pps64);
-		fprintf(f, "pkts_burst %llu ", ppsburst64);
+		print_u64(PRINT_ANY, "pkts_rate", "pkts_rate %llu ", pps64);
+		print_u64(PRINT_ANY, "pkts_burst", "pkts_burst %llu ", ppsburst64);
 	}
 
 	print_action_control(f, "action ", p->action, "");
@@ -337,14 +337,17 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 		__u32 action = rta_getattr_u32(tb[TCA_POLICE_RESULT]);
 
 		print_action_control(f, "/", action, " ");
-	} else
-		fprintf(f, " ");
+	} else {
+		print_string(PRINT_FP, NULL, " ", NULL);
+	}
 
-	fprintf(f, "overhead %ub ", p->rate.overhead);
+	print_uint(PRINT_ANY, "overhead", "overhead %u ", p->rate.overhead);
 	linklayer = (p->rate.linklayer & TC_LINKLAYER_MASK);
 	if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
-		fprintf(f, "linklayer %s ", sprint_linklayer(linklayer, b2));
-	fprintf(f, "\n\tref %d bind %d", p->refcnt, p->bindcnt);
+		print_string(PRINT_ANY, "linklayer", "linklayer %s ",
+			     sprint_linklayer(linklayer, b2));
+	print_int(PRINT_ANY, "ref", "ref %d ", p->refcnt);
+	print_int(PRINT_ANY, "bind", "bind %d ", p->bindcnt);
 	if (show_stats) {
 		if (tb[TCA_POLICE_TM]) {
 			struct tcf_t *tm = RTA_DATA(tb[TCA_POLICE_TM]);
@@ -352,7 +355,7 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 			print_tm(f, tm);
 		}
 	}
-	fprintf(f, "\n");
+	print_nl();
 
 
 	return 0;
-- 
2.8.0

