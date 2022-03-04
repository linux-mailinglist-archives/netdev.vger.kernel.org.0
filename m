Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE054CCB82
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 03:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiCDCCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 21:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiCDCCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 21:02:44 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2105.outbound.protection.outlook.com [40.107.93.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404D3137598
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 18:01:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWdAbqF61vlZIKduEnC9aXpgVtXU+HPVe8fqLJbFX9QSh0PQPzdazZf7cfPSFvcCP17bjuMSLF4/XULryiR59vlszQlABQPMXmBHPKmuBBDoMhx1z2IKdrO5UWbRh0rNJ34wlcyAO/RroeqA1TipL4OMe/rnfOVFVc81Vq54O1+awm4586AK4Ppeoh9njNJnohvxfoMQK01OLUkacIpe9vFkPREZL4cbc4XJGluZt+k3QjkzDAC7Zqsb0J6XPudSOWPTcuxNnIj/9rhw7MUQITsUvcEJEU1J2eWZcVTnubF4f0bzermCR/AmRYMNmpCxpdBpKAM295aa+XxSVW1aiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PYXUCPNKjgUVOTJVPJWj+1sWfm3Ci6KIGHqZlBnXpA=;
 b=NGdL44+jL6X/SEAgjsxdJve1vSsFJ0aZUu6MPA1Gcm23JYr12xW+S7M+KUZ7IvI5pmNl8xn0SgnH+CDvEdJbdbQ2k80JS+u8bsZJKG7l9OfUHqfzWz38viCj+q2+nN4OIgKdp+73IquKWiVVxM9qLjbvtGNbcAAnmqMfZOBTD137wDG4fFV57cPvpbC/hPgTGyPw1mZlMHxlDCj6IL1Vv6hkPHuO45DPcYuvxjTbMkfw+Im3+avLkW5H3ICjKBKtS/k6wgxm4maB5/zKqKadXle3Gg9SHMMySuoTccsQLQwi92BRN2SmgY4YNfSnvGdRorNXwpiZnaM2B8i2hpjRxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PYXUCPNKjgUVOTJVPJWj+1sWfm3Ci6KIGHqZlBnXpA=;
 b=aUexBvBn22NzXSpgjmlfvkDit3ImJABy5gnd4M2+QXpmGwqZ51xKBJULEaSZZseMM9MJlo9T0sfY6gmSQbpmufTZj/3XRN+Lu8Rr5rHHFuD8IRpFzPmBytji3JvI6OMSYE26xBHSd8SwR37E/I4VL92hKemMWGXF8c97vGG0EbY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by BN0PR13MB5149.namprd13.prod.outlook.com (2603:10b6:408:150::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.6; Fri, 4 Mar
 2022 02:01:54 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::2c25:4b50:106e:836e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::2c25:4b50:106e:836e%7]) with mapi id 15.20.5061.006; Fri, 4 Mar 2022
 02:01:54 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com, jhs@mojatatu.com,
        Victor Nogueira <victor@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>, roid@nvidia.com
Subject: [PATCH iproute2-next v1] tc: separate action print for filter and action dump
Date:   Fri,  4 Mar 2022 10:01:40 +0800
Message-Id: <1646359300-15825-1-git-send-email-baowen.zheng@corigine.com>
X-Mailer: git-send-email 2.5.0
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::20)
 To DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82da98ca-9f4c-425c-5320-08d9fd82f449
X-MS-TrafficTypeDiagnostic: BN0PR13MB5149:EE_
X-Microsoft-Antispam-PRVS: <BN0PR13MB51498247A93E5DDA377F635AE7059@BN0PR13MB5149.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L+ypB+nn5KyGt8dw7ES8qNR6Z8J/EzM6vqVqS7daow8OAGBPt6PfjBEU2HhZP1KpeLAEEDf3Rh5bn4j7bnxdH3vvwuo3sFtGx2ODAlHTsl/hw1jtSfOCF2oZ8cDnNw0yofxbMl0iTIk2aaiiVmcQ4PD2z0WvocFgF+Tmbsq9Ro+jJrjUWN27dMcR1zWLUKycqNbsRTUyrEvwOBxUQYBpD+wRrIbplamjzZK6QZLfItiSWanq61tglGJi8iz0rXFmd+ceYvgC6hsB0xqaM9NFdjZ9J5/rWx4iLKquZABBcrHDmIQ4TXo0bsSJ/6j6Sd58IXkAuehrSGoRFwCVoOXfv9M77z41QUI1tTXpPxmhx9kILDBmt0LFjvUCVhIoz0/VjuDzEQW/fCBCfVk7JVxTP4ZPk57T06J09JCrULK/bwRI8FEr+Bfdlb2c0h4cI/q1wZ1Ay0J2Yh08Of2kklUpgmKRXbcWAO2qDljuyNM3uqu1ULwqPoMWE1EChEzhip5XTXWQPVShG0jsZ19vervDs5AjeWwd2KF9sD2ZX8InZwWOjY3R3/19HJsLmCmr263/VUJ7QCeq5jFcLkjCn8u0A/9o0irUP8ch3UVrpOXn7NTY3tqAZnp6hFxBXBMvfVsmwclz8cDMHLy2C6PqwRCXB6/3gHRLD+8aLg0PEKfpoNUErC86SBa5auFJk+UUByL52hAnod1Rx/b4J3FGhT4qeP6PObyqUKZ5KNbuVY2eRp9askdpBDFjuWdkrB1ptgm0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(39840400004)(346002)(136003)(366004)(396003)(2906002)(508600001)(4326008)(66476007)(66946007)(316002)(66556008)(86362001)(8676002)(6916009)(38350700002)(54906003)(8936002)(5660300002)(44832011)(38100700002)(6486002)(6506007)(6666004)(2616005)(52116002)(6512007)(83380400001)(36756003)(186003)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1jKoi+/Yw9dJTc/2dO7JitgVOqOpgcHtlCd9lWUJspQlOczspCqo1qNCIVJY?=
 =?us-ascii?Q?om9y50e1/QHfXHfzfx6zthoOf84Gm4NWumk84u2cDjxIZrMDLRD1+GgzMJy4?=
 =?us-ascii?Q?Ic86SNC4yHbL8+DXAB7AxbzA2pg3VFVPQOle0z1H7K+rlxF8nzuhHXIGR/YF?=
 =?us-ascii?Q?qgTj59NCACTCpv6uixVojG9kx0D83oLquDmJyfz6+1ZnZ5LeOG7DNj9Nrva2?=
 =?us-ascii?Q?+8ylLudxmMRV2FsC+qjdv5zxEcSPBh/KULnCLlDXWAQ+38vznzoozblQQjcZ?=
 =?us-ascii?Q?sg8CxCUfEu7+ImxZ8KBXedV/HxvAozlVhZW0rEriTHcu6qyOtGgRtdD0GpOc?=
 =?us-ascii?Q?eBKqS4xoaSauWVT0IXbmyNq6BgvZLCDGDUOlceahUfwBz67ozpqoBN850Udw?=
 =?us-ascii?Q?Q8heKgrUCfBmYR0Jv5EJKRolSoPhRaLFEyU7EN2XpKfohsRJXCRFr9vQXIu9?=
 =?us-ascii?Q?BZ34NDPEB8EHDLnVzXUnx7OgAO/xZcLX4FO5b7VMwMgITSe0OmW7cejzIgDg?=
 =?us-ascii?Q?28SgALMhfW1NXkIn1XTkpWx73vWGIiLP0wbAKGZuS/EPKxlY17Q9ktMjK7Oh?=
 =?us-ascii?Q?4UUr2kdPoSwlUj5zs3WMzAANiRnLjbIJFrk1GSJ4rRoq9GWnELvndv1EdkGK?=
 =?us-ascii?Q?MdgioTLstADBZX+J9qZBpeyrcNSsVpqhLx4dq/jVbV0vIX+jnGELuHXg1oMz?=
 =?us-ascii?Q?Rph0DLDFbtNBbvHDfGqD/qTar4ci5bnmBYxQLqbivYcXO+2AapStKp5/CKBe?=
 =?us-ascii?Q?TQpGRN2UFSFH0EanGiAcV2ZioaR6uazJl3ZecrXWLi+w2pD7I0hwNpH7l1jk?=
 =?us-ascii?Q?8Q+VMS2Fepu/HR9LcZQxRI+tatqvvP8aoVZKc5jmNbbDM8Ygg9SEhrRD46sx?=
 =?us-ascii?Q?FhGURkzVwLKgxhzYpJyHZ4gOzHJqDscOuVqL3ln/j0t0hgOZj9DWwlAeScrr?=
 =?us-ascii?Q?T0jnFVWtFz6P0QyEyOmIVjNzHaNItWFnm/9Iemo754FTO+Cgmnt+y7GITLxQ?=
 =?us-ascii?Q?OM0J+UrVHBGpgsOIo+Wmc4T3jIBilDyHR8wWyi6HdDryqQxP11HvpTUCxeIb?=
 =?us-ascii?Q?Ym6pDnMkm6WVjWkUvKYcmjkWvP34IlbBHP6lJGGajam3Tgo3M7HgUG7HLrpY?=
 =?us-ascii?Q?wxoaRTiilLPOYgAkNgWyw8griSh6aYDeSNWdRxT2JypPUWIc8C+cS0EeR7HA?=
 =?us-ascii?Q?xOLNKX0BQsdwDJ54uDlySlt4GPf2iXzBUeKFOzvw9PCNAXhOwCJJ7lpx2MLH?=
 =?us-ascii?Q?DKSyDwUWNuuKA0tV51oYVeibsWhfxddVwk+XJvP9ZFH68gk+zjWpOmjHH5XV?=
 =?us-ascii?Q?m5QLWVnuCbAr1urTHYvQc++EJtMOSE//LGNjpmD/KE8mRnSELLdk7GzcQavz?=
 =?us-ascii?Q?bjyrJikR53B2BWgSnV8/wWuHGte8HXTI3SDGfJhtCn7qvQyJjX8LhzmobHTa?=
 =?us-ascii?Q?yDg9QF5FRFAfSmAQ1lTWaaLhzBiiKbPe+9K+Xyh1ppItUtY68u2ThA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82da98ca-9f4c-425c-5320-08d9fd82f449
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 02:01:53.9563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kxDEI+ECqah3a+9L41FB8Vah7aFR0OCNPmKvkQtKPmU9BKJ7EpyjjIHkpEcRFoenfXi6o+aZ7w09K/TPNdSKeYa3QUE24KUUGbcnhVCiJEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5149
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to separate action print for filter and action dump since
in action dump, we need to print hardware status and flags. But in
filter dump, we do not need to print action hardware status and
hardware related flags.

In filter dump, actions hardware status should be same with filter.
so we will not print action hardware status in this case.

Action print for action dump:
  action order 0:  police 0xff000100 rate 0bit burst 0b mtu 64Kb pkts_rate 50000 pkts_burst 10000 action drop/pipe overhead 0b linklayer unspec
  ref 4 bind 3  installed 666 sec used 0 sec firstused 106 sec
  Action statistics:
  Sent 7634140154 bytes 5109889 pkt (dropped 0, overlimits 0 requeues 0)
  Sent software 84 bytes 3 pkt
  Sent hardware 7634140070 bytes 5109886 pkt
  backlog 0b 0p requeues 0
  in_hw in_hw_count 1
  used_hw_stats delayed

Action print for filter dump:
  action order 1:  police 0xff000100 rate 0bit burst 0b mtu 64Kb pkts_rate 50000 pkts_burst 10000 action drop/pipe overhead 0b linklayer unspec
  ref 4 bind 3  installed 680 sec used 0 sec firstused 119 sec
  Action statistics:
  Sent 8627975846 bytes 5775107 pkt (dropped 0, overlimits 0 requeues 0)
  Sent software 84 bytes 3 pkt
  Sent hardware 8627975762 bytes 5775104 pkt
  backlog 0b 0p requeues 0
  used_hw_stats delayed

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 tc/m_action.c | 53 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/tc/m_action.c b/tc/m_action.c
index 1dd5425..b3fd019 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -364,7 +364,7 @@ bad_val:
 	return -1;
 }
 
-static int tc_print_one_action(FILE *f, struct rtattr *arg)
+static int tc_print_one_action(FILE *f, struct rtattr *arg, bool bind)
 {
 
 	struct rtattr *tb[TCA_ACT_MAX + 1];
@@ -415,26 +415,37 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 	}
 	if (tb[TCA_ACT_FLAGS] || tb[TCA_ACT_IN_HW_COUNT]) {
 		bool skip_hw = false;
+		bool newline = false;
+
 		if (tb[TCA_ACT_FLAGS]) {
 			struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_ACT_FLAGS]);
 
-			if (flags->selector & TCA_ACT_FLAGS_NO_PERCPU_STATS)
+			if (flags->selector & TCA_ACT_FLAGS_NO_PERCPU_STATS) {
+				newline = true;
 				print_bool(PRINT_ANY, "no_percpu", "\tno_percpu",
 					   flags->value &
 					   TCA_ACT_FLAGS_NO_PERCPU_STATS);
-			if (flags->selector & TCA_ACT_FLAGS_SKIP_HW) {
-				print_bool(PRINT_ANY, "skip_hw", "\tskip_hw",
-					   flags->value &
-					   TCA_ACT_FLAGS_SKIP_HW);
-				skip_hw = !!(flags->value & TCA_ACT_FLAGS_SKIP_HW);
 			}
-			if (flags->selector & TCA_ACT_FLAGS_SKIP_SW)
-				print_bool(PRINT_ANY, "skip_sw", "\tskip_sw",
-					   flags->value &
-					   TCA_ACT_FLAGS_SKIP_SW);
+			if (!bind) {
+				if (flags->selector & TCA_ACT_FLAGS_SKIP_HW) {
+					newline = true;
+					print_bool(PRINT_ANY, "skip_hw", "\tskip_hw",
+						   flags->value &
+						   TCA_ACT_FLAGS_SKIP_HW);
+					skip_hw = !!(flags->value & TCA_ACT_FLAGS_SKIP_HW);
+				}
+				if (flags->selector & TCA_ACT_FLAGS_SKIP_SW) {
+					newline = true;
+					print_bool(PRINT_ANY, "skip_sw", "\tskip_sw",
+						   flags->value &
+						   TCA_ACT_FLAGS_SKIP_SW);
+				}
+			}
 		}
-		if (tb[TCA_ACT_IN_HW_COUNT] && !skip_hw) {
+		if (tb[TCA_ACT_IN_HW_COUNT] && !bind && !skip_hw) {
 			__u32 count = rta_getattr_u32(tb[TCA_ACT_IN_HW_COUNT]);
+
+			newline = true;
 			if (count) {
 				print_bool(PRINT_ANY, "in_hw", "\tin_hw",
 					   true);
@@ -446,7 +457,8 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 			}
 		}
 
-		print_nl();
+		if (newline)
+			print_nl();
 	}
 	if (tb[TCA_ACT_HW_STATS])
 		print_hw_stats(tb[TCA_ACT_HW_STATS], false);
@@ -483,8 +495,9 @@ tc_print_action_flush(FILE *f, const struct rtattr *arg)
 	return 0;
 }
 
-int
-tc_print_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts)
+static int
+tc_dump_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts,
+	       bool bind)
 {
 
 	int i;
@@ -509,7 +522,7 @@ tc_print_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts)
 			print_nl();
 			print_uint(PRINT_ANY, "order",
 				   "\taction order %u: ", i);
-			if (tc_print_one_action(f, tb[i]) < 0)
+			if (tc_print_one_action(f, tb[i], bind) < 0)
 				fprintf(stderr, "Error printing action\n");
 			close_json_object();
 		}
@@ -520,6 +533,12 @@ tc_print_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts)
 	return 0;
 }
 
+int
+tc_print_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts)
+{
+	return tc_dump_action(f, arg, tot_acts, true);
+}
+
 int print_action(struct nlmsghdr *n, void *arg)
 {
 	FILE *fp = (FILE *)arg;
@@ -570,7 +589,7 @@ int print_action(struct nlmsghdr *n, void *arg)
 	}
 
 	open_json_object(NULL);
-	tc_print_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0);
+	tc_dump_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0, false);
 	close_json_object();
 
 	return 0;
-- 
2.5.0

