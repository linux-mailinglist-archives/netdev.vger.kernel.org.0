Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC5C399BA2
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 09:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFCHf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:35:58 -0400
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:9505
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229567AbhFCHf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 03:35:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6dON412+XGI6n9SYt04acrGcFcmypcGp+cM/q7DCbOYXqm5IGXsfUmgNwTc+CpdLLu+0kAmp30NFfavvMehor2YEDagEhmhuh/vzOrNuQnok795xeMMuv0/TtEiEIBVVUMoXf8HY3D0+txVzL4wvLMwiYnOiMRwg/DKg0J/+24C68Bl4TBogGMVOLRFExoky77Z0aIzApjTB+Ten/juZCGrD1ynFR/ofJ+s30KGI4OLe4SNCspOZqUIQIJdsAHQN4QViAqXlW7xv7jyhSJvyFESJuzGQYrGm3nHw7HEMaOhqqgBpjVa/gimXkH2kDjjT+F0wx4mHEW5EjVhcYx/IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXIRGqDb1x7LpniKzFday7A/M1cgFb8K2G5SsVduOoA=;
 b=D2SdDJv1V0pYkBKrqQJqnrlp1vIpOufSOs7OQR7AA2kga9lEHk59Zu5lQX0ici7THSZmPFFilIZVn4bvM9J7ASKOp203p5AOdLNQH2HV44Bbh2Bh5WgpOw+RlMG/0csrfM2RaSmkGp5NIGkVLtMtNQ7etGyaExYGg4ym7hT1O7v20fJXCnMsGhqmdlJUmY4aN5+Eb+54enli7/3pD4EuOM6udhgO62bO8WaWHaVnsQG5RBbNg43uJnz3yUzA+LJludWrPP7gddlPWWjjVEh7OwS9Kfr8fi5u1zs5OhdMTae2MhgZ5dufaXuPD6B65u1z1kiJDOjaNXM229PGNWrf9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXIRGqDb1x7LpniKzFday7A/M1cgFb8K2G5SsVduOoA=;
 b=DVak7Dari6QkD8+jkKU1TGSpTn/8MqrA/LIvVPxLbrWiwdEe/IRtIsS5P+Srlv0a0NlBLeqoQIt4Dg45/NQJHBuL2rOuN4GyCvxq/XGT8MAPprdXKK67NlLQkz+jDkRu/1Nkac+/C6U/NSLqEzcWyiKTx/V/LAG4yQz6NLdGVJdpJBIoes0dfJuIwOMqzSLTSTUfvWRJFuLYYbbyFXMVIHUG0HlVzTFxgfbxUd3E4edfvAnokC/tKx0LW1F6Uz9i4R0RKuMMMLa/KUVUNI4WZtQO3O9p5MQSt+8fLFFlU4+lxXMARY+dv6u0iUxkr+QOhjEF5AEYSG07qQVm2fA7/w==
Received: from CO2PR04CA0099.namprd04.prod.outlook.com (2603:10b6:104:6::25)
 by MWHPR12MB1357.namprd12.prod.outlook.com (2603:10b6:300:b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26; Thu, 3 Jun
 2021 07:34:12 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:6:cafe::91) by CO2PR04CA0099.outlook.office365.com
 (2603:10b6:104:6::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Thu, 3 Jun 2021 07:34:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 07:34:11 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 07:34:11 +0000
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 07:34:09 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next v2 1/1] police: Add support for json output
Date:   Thu, 3 Jun 2021 10:33:45 +0300
Message-ID: <20210603073345.1479732-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b899ef6f-c103-4a63-ad8c-08d92661fb5e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1357:
X-Microsoft-Antispam-PRVS: <MWHPR12MB13575A9C71CF1D7C1F51A0E1B83C9@MWHPR12MB1357.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:78;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BbiXo8A3MDTJrCwpYIv3dlJBu0R9vhgntDPo2LMA0hfUZt4YH/D2YGt2tRk6cnr7fGHldrKTYVt7YHtQBZVW5LjvJyIN2+hwJ7vGUgrkV2qJbFpiXT3P62BCPpE1FOMuoxadd93dPQQjOD57UzKms+Dw5kmRKFV0EglJP8BskLg0M7+RmZBabXWb0gbXuIi/yw/ZUiva+BbXngDKab7RKxhppiD9rdEWLgstyz6Bd9rXZpgdRtsLzFKxhUmlqYTeDWzIq0cJYFwUJBzOxa01uuUks5qfnAzIJRhlDbF032UNNHzFBKOaeFyKPNdsZADh78j8AcBFI0a2TWCjidu3SgCfzb3NmVyR1Gj+9ccLjwJT2hq6BN479nE3OHb/iib2Em32lrAtyFr9aA7cmg9PQ9eBKUe2/5XhtdJSZzcXJQjN9WqycbKw94fitBQFKBg6fx9+a7QH/cIIGs11LdCHX6pe/GpPBsjvC+Uqnl5kYMneb1kms7b4GiXg73cI/7ZyS0pqbNT2aOnc5QxlRqoW+XVgxjqkYZlO9LE3gl16jIdKg48SDoqWwXqNoH2ovdGIgM4Kes5xyAgijA/SoH4PmW3oHWCooM9bWlAMNVlC4Ow3EyF0UrTp+o4CJIcVkA+9dBi+V1gMMsLi6Q3IprL/+C6YTxD5T3czYsu94sVwRtM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966006)(36840700001)(478600001)(36860700001)(70586007)(86362001)(6916009)(5660300002)(54906003)(1076003)(336012)(426003)(316002)(6666004)(7636003)(82740400003)(36756003)(36906005)(70206006)(47076005)(356005)(8936002)(26005)(8676002)(186003)(82310400003)(4326008)(2906002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 07:34:11.9425
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b899ef6f-c103-4a63-ad8c-08d92661fb5e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1357
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
                    "kind": "police",
                    "index": 2,
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

Notes:
    v2
    - fix json output to match correctly the other actions
      i.e. output the action name in key 'kind' and unsigned for the index

 tc/m_police.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/tc/m_police.c b/tc/m_police.c
index 9ef0e40b861b..a78e96c9cf18 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -278,18 +278,19 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	__u64 rate64, prate64;
 	__u64 pps64, ppsburst64;
 
+	print_string(PRINT_ANY, "kind", "%s", "police");
 	if (arg == NULL)
 		return 0;
 
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
@@ -300,13 +301,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
 		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
 
-	fprintf(f, " police 0x%x ", p->index);
+	print_uint(PRINT_ANY, "index", "\t index %u ", p->index);
 	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
 	buffer = tc_calc_xmitsize(rate64, p->burst);
 	print_size(PRINT_FP, NULL, "burst %s ", buffer);
 	print_size(PRINT_FP, NULL, "mtu %s ", p->mtu);
 	if (show_raw)
-		fprintf(f, "[%08x] ", p->burst);
+		print_hex(PRINT_FP, NULL, "[%08x] ", p->burst);
 
 	prate64 = p->peakrate.rate;
 	if (tb[TCA_POLICE_PEAKRATE64] &&
@@ -327,8 +328,8 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 		pps64 = rta_getattr_u64(tb[TCA_POLICE_PKTRATE64]);
 		ppsburst64 = rta_getattr_u64(tb[TCA_POLICE_PKTBURST64]);
 		ppsburst64 = tc_calc_xmitsize(pps64, ppsburst64);
-		fprintf(f, "pkts_rate %llu ", pps64);
-		fprintf(f, "pkts_burst %llu ", ppsburst64);
+		print_u64(PRINT_ANY, "pkts_rate", "pkts_rate %llu ", pps64);
+		print_u64(PRINT_ANY, "pkts_burst", "pkts_burst %llu ", ppsburst64);
 	}
 
 	print_action_control(f, "action ", p->action, "");
@@ -337,14 +338,17 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
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
@@ -352,7 +356,7 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 			print_tm(f, tm);
 		}
 	}
-	fprintf(f, "\n");
+	print_nl();
 
 
 	return 0;
-- 
2.26.2

