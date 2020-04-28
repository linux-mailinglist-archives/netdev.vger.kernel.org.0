Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E086C1BBCCE
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 13:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgD1Lsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 07:48:43 -0400
Received: from mail-eopbgr00083.outbound.protection.outlook.com ([40.107.0.83]:54017
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726285AbgD1Lsm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 07:48:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Px7P+Ehrvlnw9DVb/m078u6c/YKnXdKH0UsZl66kMkwep3gLqaEpIfCyPdkzhmdAGvBlZci8SLf+ZGNPgmVYggAI6OSC5zS4CQheHEl9IqPXNUdy0RB+fO1YF0KRMYLMXpMAF5u6vUXhxuXk+Udg2sDcEAFuTRrJb3akokrzS/Sc0mZi92bhphr7uJ9cE3G7IRrl/fr8xAaN5/1+eHNViiVMhoEbnedrKys4GyfePDz983ATYrHERDpzvKmtF/8r3zMS2v9TTTqb4v4ESCn0i/d6Tez1cRXSixGzcd5ibioRCyrXG0iW1p4nG4VDfWrTY21hBmjybGVB4zzesmEA7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqwbCz91Ewm9KlHnhjUdaO45PMQuqM522X36UpvF9BM=;
 b=TFku5tF9BI/N1ertAY1UTFKpKtzvwpr4ZxXkmHhEVDa4lpdtgyEHGJFp3QfNMTqB5dUc6RVCZnayO7AeQ7qjyiUmFVO2+bvfOLpnJGItr2z1QVfsX4Vgf1ETwu7ogdFaN+q+3sfVaQl/3TZx5fs6EmkCFBCUTJC3BW8F+FFUJkBIxvHxRIVA3XCVy6tEzYrR0ehXNCq4V1SchAgcBaP6f/C9D0gDTEn4VD6/rSvxCzIpUnWUY0EGN0ix9+1m8MhkLEG6Of0ucX7SVX+m3mCxNeCTMeQr0vGH1bamePArO2F8Nrp3mgQtaqYAbF/gb+JsAm64CZSFjfL4DCntRkiJbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqwbCz91Ewm9KlHnhjUdaO45PMQuqM522X36UpvF9BM=;
 b=LdDB9Pa3DOh2LxZLt37ofWGlKTEZrAfOIMoM+Wuf9ziNf9SjygGmCc/mngMIJVZfuChYx7GYtsiD7edGJAJVpmVosEgikZzuJoqhfojSpM2CR3lhgzOHW8AXlqzCuOumJmLZGq4CXnHrwztVp+zEtwTUN3o1HKHKFBKkC5e2OdU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3515.eurprd05.prod.outlook.com (2603:10a6:7:2c::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Tue, 28 Apr 2020 11:44:59 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 11:44:59 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: [PATCH iproute2-next v2] tc: pedit: Support JSON dumping
Date:   Tue, 28 Apr 2020 14:44:33 +0300
Message-Id: <65858649cfcbad9e7dbedf392906d8aa31139735.1588074203.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0031.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::6) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P189CA0031.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 11:44:58 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f1e0160-f1a8-4ad8-cec7-08d7eb69945f
X-MS-TrafficTypeDiagnostic: HE1PR05MB3515:|HE1PR05MB3515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3515BF4952286097C5E753EADBAC0@HE1PR05MB3515.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(6486002)(52116002)(478600001)(66946007)(6506007)(66556008)(66476007)(2616005)(26005)(956004)(2906002)(5660300002)(6666004)(186003)(6916009)(4326008)(81156014)(316002)(8936002)(16526019)(6512007)(36756003)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Bkxqk4nbfJXRWY4npb8Xkmgnjp1wIgTLp4rmjMa/+7FegvHhUavAXzv2GsFyGQxZdg4zMkKerLy6kmALGuo85t2jPwEyepYLTdXK3dZJHY9yZJ04efIHn1qMRbfVCi7MTEvVpPczcxl+yfXLhKXhxUsU9cJ5KzOOjl1WHI6+KQ8F5uiFbryxTs/6oHIVNoPw/Wjr/wP7pgC5chMzk904nHGvVWOVfP+qlFfelDz8GvPdav0u1Dw2Ewbyxxt7wMMhnbzmhrv0C22ORfwyczswj2JOsi+HUQAXnFh7QBOr3aIFZVysljyruSJdjH53DKCRI7BNcIMLdHcqpOPjnfdWqJdnCg9iLRg/uMNPFiBk7N3WY1F33qIU1bpHssrQixHLwjdbHqUDgeRH37NLv4y/PqIhi+hi+Z18jrO70FTH3eMOTGW6PCJkPLS7/0EJNEQ
X-MS-Exchange-AntiSpam-MessageData: NNxD1yOs6LOcH2rnjgrNUI8EaaE7NW3f3tlKRXu7MJu8nJEOjTyzfpVKHYEaisBIJfS0/c/QBjX96+OquW/2FhIty8sgCqKKbkjvSKrgSRHgD+t1w8TH+TjiQXgh+85r2TmnqN/8jE856NcakjWD9rFmv2bsp3DSvwjkkFEVFwLd11Il49W5Pn7uwlLuRwqJP2f9L+Rrpwv5vmwN8NGw5Ct2ygotB9vSj8fz1RzdmftLeiz2oJn6JgdNhf3KDBIf/KXU6N4dsqoWIRt7eg0WBgnA6vz6KJLXeXwTRCd8K7SZGQz1/65pi+JMtow58HSCR8Lap/HDa5+0yFDfoS3wXmsWWKPG7yrx0HR+WJzhZc8EeC6v5BiPR5HqFD8CKcYcxE4blpO5pWdEqf7/7p7xpKYSCUPQzxfv981VjetJUZ/sq1t1rz9tajDCOM5ATA+dfsAMhFawWbGkok5LFxh253UxWFlT9320S6w9eThoxWNwE0j8XVzRRcT0B3745lIalVHW3g0H5az+WFp9deHtDeNZmzlMJn999HrtT3NtlOhfB4lrYPmUgActTmlRFMImbWeI4t2/xtF2bZDibak9YAexReVsWGVIk0tc8x3xKCLP0zQD+4vJafoRlGxM3iXYyKyoQQNrX9ZE07OENC3/TvOnhSIeaduqvl0clm/1eSAH/P+bgSx99iG6bI0Hpz5a9GLEQsHHjKZ8xMWsqJlwJfUh0YQXw1jY70bJvyZEldt9QGJDOGBJFuC/p78WqcudqaEO4SOqkunKBFtle1w5zAEnW8gVYfgUfGUO+19XUjY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1e0160-f1a8-4ad8-cec7-08d7eb69945f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 11:44:59.1423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7kwYxVJAjM+klFKDUYMFMi3lL9ejJlCoyQax0Z2UgHongD1dXKZF/WvSWC9sOFq+t/9+UI4nL+rWLkVbg9krw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3515
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

Notes:
    v2:
    - Add a comment explaining why the command reporting differs between
      FP and JSON.

 tc/m_pedit.c | 67 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 23 deletions(-)

diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index fccfd17c..51dcf109 100644
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
@@ -804,21 +815,31 @@ static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
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
+			/* In FP, report the "set" command as "val" to keep
+			 * backward compatibility. Report the true name in JSON.
+			 */
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

