Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A4D39CDA1
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 08:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhFFGYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 02:24:31 -0400
Received: from mail-sn1anam02on2074.outbound.protection.outlook.com ([40.107.96.74]:15975
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229478AbhFFGYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 02:24:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhYmBDSPDpykksEHfhq6d6zl7GqpZQEJEws/PjWtm/jLv+ClwZlboCc1qytKh37hGotBirEuWeFrOjAiNEuxpHUY98J6Gf/nCskK0gbWUL1R71zbB8TJ7fYN5+IPoFspM3ATaQoa7KcjUs8bZmG3BovFr0RSDzN7ztiEVd7i0V0m73pCZSnbuLu5Up0qsdSP0+JJGCTTs2dGFoXfcbQ+yfp7JQCHjye8Qa0nfw3uXdodKAgDe0wWefhnxD9Pyke9aM+xyNXdSLjgpNIoxXz5B8k4xjtmQo2nFyorMec34KWt+GMOy2+d1ZifvQBKCm5S9hlFffISBvNqRJkMNBjBDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXzca3XlXW5/lbkGBxGALqSk1CylJIX1TrIx30EHwd8=;
 b=CUbdX/EBWa1sBdkjUINzUFiRppmtwFhgM/3tuzIdGrO7TGrVxQFnbwhI0DSlGvbWrxTDM4cmwsP+AZIHjmw7DJl+jII1lcG4VFQuESINzHjgQXjAW7fczH3AJDxnjfseTTiali6JcfPnrU1M3L4B8eJXAhC6e9yhunjcuKD7kQKeYmF9cwxaGhlJG97Z9TYVWhP5YYUdS3O76KnY7wq7lFF43RS9ml04VmcBVwjViMOiXJmM7KB+b0WrsLDX7GTiXesxBHMDGaL3mOtHhBl+NBECJhWIdyOKlUtzcT26ggWsMEs5fSI3HEn35Q7cANk0CWSel6W/KnunyloRnDy3CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXzca3XlXW5/lbkGBxGALqSk1CylJIX1TrIx30EHwd8=;
 b=MEGaAqoeq+G5VKigxZfXQT9oCG0y6wu+a2/cdosy0pClvy8HLpXfsPTd3BLRvWXVDpuOTO8Nne84iVH4jdxO+aIb3ngYSTLChaODdGnV6MBzcAm3VKdr2Hngq+4BTegk08+Z0Heh2ARErH4XNVsVAYbAf4Dx2qF1lfDThYPBq+LSBlGrFRlyJkUYJBRfStbdR+MdDIafXZG0dmqq+hppZ0y6KHijt5rOgjbROf/RLbuqLK/w5HJOAgtrAhY0135zRJ6qE1P/0tLYxpOVunJdfyzuQZuW8ths0vnJQaJXK4xvaSOX9JG6Y1vfIipP3MAdj2JeHwwtr7SXGE0NirWPDw==
Received: from MW4PR04CA0282.namprd04.prod.outlook.com (2603:10b6:303:89::17)
 by MN2PR12MB3071.namprd12.prod.outlook.com (2603:10b6:208:cc::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Sun, 6 Jun
 2021 06:22:39 +0000
Received: from CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::3b) by MW4PR04CA0282.outlook.office365.com
 (2603:10b6:303:89::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend
 Transport; Sun, 6 Jun 2021 06:22:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT025.mail.protection.outlook.com (10.13.175.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Sun, 6 Jun 2021 06:22:38 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 6 Jun
 2021 06:22:38 +0000
Received: from c-141-25-1-007.mtl.labs.mlnx (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 6 Jun 2021 06:22:36 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next v3 1/1] police: Add support for json output
Date:   Sun, 6 Jun 2021 09:22:26 +0300
Message-ID: <20210606062226.59053-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8291d16-94eb-44b1-17ea-08d928b37baa
X-MS-TrafficTypeDiagnostic: MN2PR12MB3071:
X-Microsoft-Antispam-PRVS: <MN2PR12MB30715F2D6C65A2F67E46C38CB8399@MN2PR12MB3071.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:83;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tpfX1YAQTGteIBxCbmfosqOeyl7V53cuzPpntp540jYPxiYbOJIeGIET/bC9bSu6kx0J9cmKaZW5MhprGbp1Ps6TL/hARn5+KsFC6Ur0/MjJ/ls1G5muPsAGYabxqRtR52zNvGgn/URhfnUcdgxdd1uuWkDfOqj9wG64+IwljlHPtsgP7teq4ounVbtDLvymlwoBXOS3szHdDhwddSlMpXKqr4e1xz0QIjcd6EP7r94rY2LiDKlDEd8FoSy5wo3LVHn/0szjHtYD9wBvtXAvbOrhcBpJmO9oEnn0Rw2sa1/nLqaWeNzgu9VeO/7e7cBNW0ojEkDMl3hOuDfkMRhWOnb/M20EmtRN3QTZpemyKP3PE7HTVnUfbE/X8FW2nRlw5g+FuomMGHvNssIxrBWLpyx/GyDuuuVi+F5x50LFBF/JanzmTPGfFrjsP78YVyLS7otai5thHmI6bCBHxyvLyQ7u0nNPzUiHGcy11IfKeIzBS4zKn68PNu2tLy3kIgaZGIYkVg4yC9ao2ZpuD0TBZdLdQw3PX+e+7JlxqBqAw3y76dBF45eeCYSc5gTZmp3+VyruhQfSu2PgguKs4eHR3x892J5sauM/qOycxZ44amvyft5nKEk3NQJX4wwXdc9icdGyjjyScjtqrM5O0ACGJOCYilamzo/d8rCCnrVURvM=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(396003)(46966006)(36840700001)(336012)(7636003)(70206006)(2616005)(82310400003)(4326008)(1076003)(86362001)(8676002)(426003)(356005)(6666004)(26005)(5660300002)(83380400001)(36906005)(36756003)(316002)(2906002)(54906003)(8936002)(478600001)(36860700001)(82740400003)(47076005)(6916009)(70586007)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2021 06:22:38.7438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8291d16-94eb-44b1-17ea-08d928b37baa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3071
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
    
    v3
    - print errors to stderr.
    - return -1 on null key.

 tc/m_police.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/tc/m_police.c b/tc/m_police.c
index 9ef0e40b861b..560a793245c8 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -278,18 +278,19 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	__u64 rate64, prate64;
 	__u64 pps64, ppsburst64;
 
+	print_string(PRINT_ANY, "kind", "%s", "police");
 	if (arg == NULL)
 		return 0;
 
 	parse_rtattr_nested(tb, TCA_POLICE_MAX, arg);
 
-	if (tb[TCA_POLICE_TBF] == NULL) {
-		fprintf(f, "[NULL police tbf]");
-		return 0;
+	if (tb[TCA_POLICE_TBF] == NULL || true) {
+		fprintf(stderr, "[NULL police tbf]");
+		return -1;
 	}
 #ifndef STOOPID_8BYTE
 	if (RTA_PAYLOAD(tb[TCA_POLICE_TBF])  < sizeof(*p)) {
-		fprintf(f, "[truncated police tbf]");
+		fprintf(stderr, "[truncated police tbf]");
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
2.26.3

