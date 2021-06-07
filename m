Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003A539D536
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 08:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhFGGqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 02:46:15 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:41545
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229436AbhFGGqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 02:46:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncjD8EanoFBvibfMJTR0GQPCDgH+/4lVDPgvzCdbqjR08TEVEdC63IFN73oMBAz7qPWOoCihpFa1jIvBrv26qnNbPLrsMplcYK9umOGjTKunpQwgl6eWSHNBKb6gjSaEPvDU/RjzhWHKvIOL9FJfVv7FIqudb0jwZQ9OCDOccBWrqsnxlriOvFJwegY6llJIsB532f/fUHK+aowdAL6ypcS5k0geOxwkMXkq3W9ustEghq2n/MyD75pdz3r9U3r/YCQgmWS5RrxKPD+BoHg7BsACnkOYtL/OR22xIOvgc+csptow8cx2XaiK5wyZYq36pgktI8w6bvjkbb+bIg6ehg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uO7mDxIcGYv/CZlHViplD4+YJrKYx5N9MjCootsIU8s=;
 b=LCxFVbHSWDpfuMyUCjKbL3WuYw+JG/Q/n170SQnT9Ux6CN2cyWrs95DSicCwEQ/uVCk6i3B0Ds9fmZS0oQ0w4j4olZlo3RE/kKZ3IvPwF8LGU/v/HQ76x1HxdgsXwYAwsZaLF048ojeMhg/YH4lNfO0aufxaZBhx3bHTEnlx0E6Nc69YIDs3cvF4yHlWVFzziW3uHYK682fVPLJVt5h34We7RGaJKNvr/gUVQIP5AXxD2p3VrNwuP6I7ZeSdHwOuZAcup3mnHJqqiu9pcgCrU2EGtW3GpjHN8RUPfglw7CB+0+Hzm+zaPWOrEzGL0pOEHgrvhaYm+pvqS8bVDNikag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uO7mDxIcGYv/CZlHViplD4+YJrKYx5N9MjCootsIU8s=;
 b=DuOWsqSe+W5ulIeWwBFw0mmNBFla8bMu7iMQri7c2kyy4tklU4fqCoJGGHTxMOnv1EENT/IIsejXiWw43RGOO6+IYgUczx3/hh1G0hKYAzyyaSpeWi2qw1N0HcqeDUCnb6NVf4dtqL5V6Z3HbefkNYYGwRdKr7Czxe6vWBjACqefdRMqKyVW6/4VZZ5Yq/Uhu0PaF2nlo+ZxZEmHDMzH5vbW4+H4nXvDM8DEBWxsr0kE4uphUnfm0V8bLEKPg0DYns9lwEbA4FuqN358JrG5M1IX6H/EE/wGG+xohdx9+lxZWBAvvyDWA6PG6HDSjAWuIkVikcUVleZdL8CkzOpvjQ==
Received: from MWHPR2201CA0058.namprd22.prod.outlook.com
 (2603:10b6:301:16::32) by MN2PR12MB4064.namprd12.prod.outlook.com
 (2603:10b6:208:1d3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 06:44:22 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:16:cafe::31) by MWHPR2201CA0058.outlook.office365.com
 (2603:10b6:301:16::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Mon, 7 Jun 2021 06:44:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 06:44:22 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 6 Jun
 2021 23:44:21 -0700
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Jun 2021 06:44:20 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>
Subject: [PATCH iproute2-next v4 1/1] police: Add support for json output
Date:   Mon, 7 Jun 2021 09:44:08 +0300
Message-ID: <20210607064408.1668142-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3afc127-4b3a-463c-f2f9-08d9297faf0d
X-MS-TrafficTypeDiagnostic: MN2PR12MB4064:
X-Microsoft-Antispam-PRVS: <MN2PR12MB406445EBFDC68EF3890B611DB8389@MN2PR12MB4064.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NdZJwtSpgx7mBuWNZPmik6JGfO77uo0nOoIg2ZihIg2IalUsKD+6hKSU7H1J/JBelUTRueia7K+JF14bSaY8T1YIlkUYdKL1n+Zz7fBmp6nNGW57t4EOK0XjEWY8PpvYsS9WVHPJforBQQk/mx73PgfI4NqbHipdPaPx4k5LkXsGN96mDjitdz/z+p5loOL6MNvuzRGMy+XopFg2B/q/+MEHYvIjNZauMrnt54/QQ1dAzQasWoKzcJLNAED3do1MqwTvFKZIbt8zK2nZJYTrVpVbSaM3nhwd2kv71tt4hVrMTLeQDH/D7kFDxCmW1OHXV+Kq6RZDYlhHbaY2fjIDuwmecM8SmgEyIB1teJty53jxZ5PMjBYCtTGeeGAVJjIpZUgz5ggvrvmBjZQFm8JwFma/xsgoEE4mpO6tivtQ5Nxfjs531fFzlnzpvr2idBdefJIZK3AZ+w8e4yTtGoVIwhsvaz5ZEYAMl2Hur1zsQcMuq7y3y4TWqvD8LrSty2XwTeWdJpvJGK2cRRfEb8pPPuS9qQGOLgpz218BTb+apoYhnd8Wn6EO8Y/PbUPmD4j8+YQLUZwFYGj80G7BsuI/kg92WA2oXdL/gOe6BfWhzq82rmlChaQdQDL9w4tyaPEEszE1cIjthkHwHF/rVyULYWybPI65fzhEwbYpU8TGE24=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(46966006)(36840700001)(36860700001)(36756003)(8676002)(426003)(1076003)(86362001)(186003)(26005)(336012)(6666004)(82310400003)(478600001)(2616005)(70586007)(8936002)(7636003)(70206006)(82740400003)(54906003)(6916009)(316002)(5660300002)(4326008)(356005)(47076005)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 06:44:22.3068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3afc127-4b3a-463c-f2f9-08d9297faf0d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4064
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
    
    v4
    - removed left over debug that was forgotten. sorry for that.

 tc/m_police.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/tc/m_police.c b/tc/m_police.c
index 9ef0e40b861b..2594c08979e0 100644
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
-		return 0;
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
2.21.0

