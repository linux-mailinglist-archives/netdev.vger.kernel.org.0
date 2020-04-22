Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5EC1B4B49
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgDVRGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 13:06:44 -0400
Received: from mail-eopbgr40049.outbound.protection.outlook.com ([40.107.4.49]:48004
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726466AbgDVRGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 13:06:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIrb74J6V4kWDgBnCGeQc935QFNEFxh/fkoeM3uB273OXbJlxBolbRVxEh9SE6aKYeCpyGgjnYhv8qiD8ccJtP5X09H89gDBcvVLB3JpdqvaxQGI9Au4aClSLcRCWdYuNzbhoGX3y1/9fmpG63dqGUnIh6ABUChe41o5sl2jPHnbUr3fgmKyYoakFMdGugy8qysPVH6yrhaD1lBwGpwSHDrVv9gdR/+9/lJhept+2Ir35xW+SMJGioKPxZivvw+WVwzzyLy/VIuBqNuTD3REFoLZIq7qWwLBcwPNB+OBZjYNQMoSwGlxEGgCjGDusN774B7FsaKXBTw2eTSevLAiVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofG16A5Kn+XkXn2ecu5560WpzT9KS930RQ+C64gclbs=;
 b=PC2NYBLcxWV/AY96fYYA11ZaozWEYswhM2mtzgOi/IPlAGKHSRKd00DpFof6Vp4EtGN5u/OgH118aWqJLqKN3sitpK/I3CZVPPE4JcuzEl/wwSu/gN2OQAmsbLO9udh4VhzDuTz5ziCo+47MDNRTR4ZtGJMfIGN0mIQ2AhuJj+UVpdAJXdP3S42uzPVxnY+pJ0G4JsgeCSLmBS8QGuUiOMsln2ffXrCtdJwZYQGCE30PRd0MTffiOXtSoFLfZevgT2Rg9vR7Psn2M26BxdIBV2KYJiNEdtHWSvLZJvwuBrbfwpswO1itlcQApv29lbdq5UA0pz5zi/C6gWgZ5/YVTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofG16A5Kn+XkXn2ecu5560WpzT9KS930RQ+C64gclbs=;
 b=pNoyYf1aHO1fljDPu5Z1vAidBH6fmpbFNAiCbM4Hj0ko6gENNh8gv0U5ZXfm/4gbatkDJ7tj+k8sOEGoWBTHCL8CmVEHW1QhqWZD1RD0wZTJYNZG9s21PqArwtp+BFbDZ+dOo1iZKbCUpd11SamDYr/e3BR2xGfmLLZnG/hChfI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3307.eurprd05.prod.outlook.com (2603:10a6:7:31::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Wed, 22 Apr 2020 17:06:38 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 17:06:38 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: [PATCH iproute2-next] tc: pedit: Support JSON dumping
Date:   Wed, 22 Apr 2020 20:06:15 +0300
Message-Id: <19073d9bc5a2977a5a366caf5e06b392e4b63e54.1587575157.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0117.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::33) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0117.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 17:06:37 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b5905a35-1d49-4d50-3979-08d7e6df851e
X-MS-TrafficTypeDiagnostic: HE1PR05MB3307:|HE1PR05MB3307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3307DA164E377B63D2DE3F50DBD20@HE1PR05MB3307.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(8676002)(2906002)(2616005)(26005)(956004)(6506007)(86362001)(8936002)(316002)(6486002)(6666004)(81156014)(6916009)(36756003)(16526019)(5660300002)(4326008)(66556008)(66946007)(186003)(478600001)(66476007)(6512007)(52116002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtgbLMLlUviqXXOAgzbXT+tZL9uqknQiK8UEnMiJBKUNBE00ZrIFuK7zs36LqMtgke94mA7ZU4YLhIhvad6gkxBb7f4AwGU5YNvf0aijY4Yx//mjDHbZfLDuHRuZ5NDmA0cuu4OsLSWK1qLPjc9j+hwTjUadxOxMp8/XwfS2VrN9t8w6yIvFk/4duHUZF3y7FE+HQcZhtK0rrh4h8EJGlkWYLBAximIqcojcAKZI49POHKnwi5KZXYWidqS9CbIa8b8+aNOxaUkMQ+0njs4Qw6M9ilRRD62hSU3wmG/3355Y2B1GSHYBioDTJHafz/ks7GCBOTTM6Kng4AN9XMgx4k2/9jQDB0dbRe39piWwAFpa9nbgndEhYuFGur0CiirRm6EMdjGGqRRqrEhCI1aYC4CuuqAOCk8cDH/PWVDdbILf5urxhoyMFcfjqcoNcghq
X-MS-Exchange-AntiSpam-MessageData: XNqqPlWxslbbqv9/zHcp3AK2RlgwL0wsErBjGxRCYvqjQdW9Olog9EE+00XJjo2LW3j0I6KPqnsl6q2gH+rFs5XoZKCKpw/vQ4M6QvCMUWBFI+vXgLYkFbs/LTYw29RUdfYac8wiQYwG3utPCvPjnA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5905a35-1d49-4d50-3979-08d7e6df851e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 17:06:38.3859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2A4SAw5LkrsGl/UhL58YaUvc4eIcIVEAws6UnBEQuInTjqrXzj7d4omM49jE9C5osAdUwPo0t5vF3item0Iyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3307
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The action pedit does not currently support dumping to JSON. Convert
print_pedit() to the print_* family of functions so that dumping is correct
both in plain and JSON mode. In plain mode, the output is character for
character the same as it was before. In JSON mode, this is an example dump:

$ tc filter add dev dummy0 ingress prio 125 flower \
         action pedit ex munge udp dport set 12345 \
	                 munge ip ttl add 1        \
			 munge offset 10 u8 clear
$ tc -j filter show dev dummy0 ingress | jq
[
  {
    "protocol": "all",
    "pref": 125,
    "kind": "flower",
    "chain": 0
  },
  {
    "protocol": "all",
    "pref": 125,
    "kind": "flower",
    "chain": 0,
    "options": {
      "handle": 1,
      "keys": {},
      "not_in_hw": true,
      "actions": [
        {
          "order": 1,
          "kind": "pedit",
          "control_action": {
            "type": "pass"
          },
          "nkeys": 3,
          "index": 1,
          "ref": 1,
          "bind": 1,
          "keys": [
            {
              "htype": "udp",
              "offset": 0,
              "cmd": "set",
              "val": "3039",
              "mask": "ffff0000"
            },
            {
              "htype": "ipv4",
              "offset": 8,
              "cmd": "add",
              "val": "1000000",
              "mask": "ffffff"
            },
            {
              "htype": "network",
              "offset": 8,
              "cmd": "set",
              "val": "0",
              "mask": "ffff00ff"
            }
          ]
        }
      ]
    }
  }
]

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 tc/m_pedit.c | 64 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index fccfd17c..d3aa08de 100644
--- a/tc/m_pedit.c
+++ b/tc/m_pedit.c
@@ -714,20 +714,28 @@ static const char * const pedit_htype_str[] = {
 	[TCA_PEDIT_KEY_EX_HDR_TYPE_UDP] = "udp",
 };
 
-static void print_pedit_location(FILE *f,
-				 enum pedit_header_type htype, __u32 off)
+static int print_pedit_location(FILE *f,
+				enum pedit_header_type htype, __u32 off)
 {
-	if (htype == TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK) {
-		fprintf(f, "%d", (unsigned int)off);
-		return;
+	char *buf = NULL;
+	int rc;
+
+	if (htype != TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK) {
+		if (htype < ARRAY_SIZE(pedit_htype_str))
+			rc = asprintf(&buf, "%s", pedit_htype_str[htype]);
+		else
+			rc = asprintf(&buf, "unknown(%d)", htype);
+		if (rc < 0)
+			return rc;
+		print_string(PRINT_ANY, "htype", "%s", buf);
+		print_int(PRINT_ANY, "offset", "%+d", off);
+	} else {
+		print_string(PRINT_JSON, "htype", NULL, "network");
+		print_int(PRINT_ANY, "offset", "%d", off);
 	}
 
-	if (htype < ARRAY_SIZE(pedit_htype_str))
-		fprintf(f, "%s", pedit_htype_str[htype]);
-	else
-		fprintf(f, "unknown(%d)", htype);
-
-	fprintf(f, "%c%d", (int)off  >= 0 ? '+' : '-', abs((int)off));
+	free(buf);
+	return 0;
 }
 
 static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
@@ -735,6 +743,7 @@ static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct tc_pedit_sel *sel;
 	struct rtattr *tb[TCA_PEDIT_MAX + 1];
 	struct m_pedit_key_ex *keys_ex = NULL;
+	int err;
 
 	if (arg == NULL)
 		return -1;
@@ -774,11 +783,12 @@ static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
 		}
 	}
 
-	fprintf(f, " pedit ");
+	print_string(PRINT_ANY, "kind", " %s ", "pedit");
 	print_action_control(f, "action ", sel->action, " ");
-	fprintf(f,"keys %d\n ", sel->nkeys);
-	fprintf(f, "\t index %u ref %d bind %d", sel->index, sel->refcnt,
-		sel->bindcnt);
+	print_uint(PRINT_ANY, "nkeys", "keys %d\n", sel->nkeys);
+	print_uint(PRINT_ANY, "index", " \t index %u", sel->index);
+	print_int(PRINT_ANY, "ref", " ref %d", sel->refcnt);
+	print_int(PRINT_ANY, "bind", " bind %d", sel->bindcnt);
 
 	if (show_stats) {
 		if (tb[TCA_PEDIT_TM]) {
@@ -787,6 +797,7 @@ static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
 			print_tm(f, tm);
 		}
 	}
+	open_json_array(PRINT_JSON, "keys");
 	if (sel->nkeys) {
 		int i;
 		struct tc_pedit_key *key = sel->keys;
@@ -804,21 +815,28 @@ static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
 				key_ex++;
 			}
 
-			fprintf(f, "\n\t key #%d", i);
+			open_json_object(NULL);
+			print_uint(PRINT_FP, NULL, "\n\t key #%d  at ", i);
 
-			fprintf(f, "  at ");
+			err = print_pedit_location(f, htype, key->off);
+			if (err)
+				return err;
 
-			print_pedit_location(f, htype, key->off);
-
-			fprintf(f, ": %s %08x mask %08x",
-				cmd ? "add" : "val",
-				(unsigned int)ntohl(key->val),
-				(unsigned int)ntohl(key->mask));
+			print_string(PRINT_FP, NULL, ": %s",
+				     cmd ? "add" : "val");
+			print_string(PRINT_JSON, "cmd", NULL,
+				     cmd ? "add" : "set");
+			print_hex(PRINT_ANY, "val", " %08x",
+				  (unsigned int)ntohl(key->val));
+			print_hex(PRINT_ANY, "mask", " mask %08x",
+				  (unsigned int)ntohl(key->mask));
+			close_json_object();
 		}
 	} else {
 		fprintf(f, "\npedit %x keys %d is not LEGIT", sel->index,
 			sel->nkeys);
 	}
+	close_json_array(PRINT_JSON, " ");
 
 	print_nl();
 
-- 
2.20.1

