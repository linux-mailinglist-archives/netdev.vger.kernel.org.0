Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF4F693D69
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 05:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBMEZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 23:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBMEZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 23:25:34 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2117.outbound.protection.outlook.com [40.107.20.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299FB658A;
        Sun, 12 Feb 2023 20:25:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ust4L2q/kI3KRqPC3Pt4Gl9v3JS8c6QYE2HVZm1ZHNokAZLIIrJXd+F+oPbUQeqemlb2aDe7HJnPKfzxSyLmU9EVraeAedLKs4mm5W8MuRWT5kwXhaWh/U0glKYASTV6Jw/lpGLDv3m2BWus3Ls964hAXYEQx4GftAZiUw/sTakMHuyWLmMsct3FDI6Eee3zPQYVzLJCvxBeGkZGnujxy4w40XfMS6RBqJGZ/CfyJ+s34hQImmm/O+ud386f4mdzX7Ta1SLJLV7mGHNhvLBsvoJPFNT4Ztvkn7vehYRHbvCWLy7eAypm9WXS7C3b2cAg9iE+jHZ1cC+wTIJLCkPhGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZ0n/EZ90zDwJjGANI+NG5VVJKkXBuK0gzI52r/2CQ4=;
 b=JTZ0qxUPRMb0VzkfZMZETVyHR/a9DrXJf/oAOkMBj4fw5D5JirewKMahbnYYaKtwtDbZmkY+QZQ7rtQIkGOp24qlVmiqFiPQANdnvB9GiQdcy4LEEqepkB62G/EfTt7dXEhGjhvnFfbaUAOReZiJTMySJD6zv3l+aEJAR2win4oJRYBlDyWtB+NZ7zkxbvJnzkpG7xR/GLAbyU81nrxQG/PLQ1grvZ9ijxyQDopGdLHofFJO36sjuy0e9cdWFZyXSSeEEXHOVHAL/DNr1wMsmrjWJC8JVpSocqUmdunjzAwXF/0qrCw0SxJIFhqLntZr5Y9aNEH8mw8eyrDrEJR5qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZ0n/EZ90zDwJjGANI+NG5VVJKkXBuK0gzI52r/2CQ4=;
 b=mfL9cezeI/+Fck9GYOuo6S/MQA6YHsJtyF08aEqeohSvthQVByw7OzcuHOqXFPXQqIT7218yNqMVqOayp9ov9Tq1ZYjDAbzeKFffSX3cq3qTkpzyuuVecU0ExNe28MEgXBfIYvCfzDTa+QXjZl5r4xFC/g5UweD1M3+NcICx8aFH70dka7w3snmuiRaZVwkcOvsUizy1CbwLAkyHtVg5918w7dm+8jQ7qycV+i3xzbxopBXVvaZirp5ZtDiAS4t+pal29LN5ftCDosUfvgZN5EMB3eTqLX78kZp/uxqP3JBqQBuiBRoS263G9z46mAQ/UhpNscmOwtifZ9XEQiGCPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by DU0PR08MB8208.eurprd08.prod.outlook.com (2603:10a6:10:3b1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 04:25:30 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::468a:8a3d:8bd2:6f5]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::468a:8a3d:8bd2:6f5%7]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 04:25:30 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH] netfilter: fix percpu counter block leak on error path when creating new netns
Date:   Mon, 13 Feb 2023 12:25:05 +0800
Message-Id: <20230213042505.334898-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KL1PR01CA0088.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::28) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR08MB4989:EE_|DU0PR08MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 57a453c6-1d97-47fb-0e20-08db0d7a56d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5rX8hhWpqJFAuk2nZiQygwlKgfDaZhlea+z9RNn2I/jmlU3tbHtQL5Hqvl7kmlpGbfFhChX2HonNR+95urh4cuyJqKbhlT5xtmkZr7HEYBWptXkTkPnBHFYZOj2sPprWmskiHsyu/Jr3vLPYioV5iF9e4r62kIoodsgWzwoxEhmYkwUGIz0rvZLtijlAUuR8I7ArW8ZY2xpEfqjqgkoomDyo9NneTV3VnLYGKvZ30QUyARhX3MlknuMmYuuodl30WiBfZX2cbOsO+Wl6Ubfu5CyllmIL6At3cnQs+j4Tq9P9f8NayCDPGqk1jmrxL1D0F5g91bmx1blsLjXvBhZupG5Rk576PkUben1G8mv3/gukK8aDs7uabqPZ6gidMMwvvHl/uWegAyYtPymjhEFGusCDyExfDk52jMBUGcm+EcluFcVCf5aW0O7e/6FBOtoVOIqRGPv02FSmTqgJANXk2jOPHERPsDjWdUPWFJCCyqvxLzhgdso+rtHahVx4l+zYbGr+zmA1l/3ygSDnYmMcSO6fJfVbvCX4BZw7Jtk8MvZDIJFJ+E+vUW0uyxCY1qoLDY0MSRLlBMI8N1NiP3C8UakaPMvPVwhbxU0f7hP18adRIqFjRCjk3BMqyMCqeSmenUmAGbP84UOwVHZRobgEzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39850400004)(376002)(136003)(346002)(451199018)(86362001)(316002)(5660300002)(8936002)(2906002)(4326008)(66476007)(66946007)(66556008)(8676002)(41300700001)(36756003)(6486002)(52116002)(6666004)(83380400001)(1076003)(186003)(6512007)(478600001)(2616005)(107886003)(6506007)(110136005)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B0pmKAStwff5AHg4RWiB0aXsz9zuQ252i6+SNZygQz73lH30GbeGhMHocBeM?=
 =?us-ascii?Q?Lv/exc6oLU2SCrQ0RiHFTiD7A9UEfitCd5liamepaCrb/ddvrd6DcYyyeQ1L?=
 =?us-ascii?Q?YLKZh2HHA+bkBSI1ZpOiW7Itt//neOJYCl1UFTexEmBGX/XP4Ln0vhb+WyHt?=
 =?us-ascii?Q?amUJwP85FxBkYvz7B9lrY7Kmag1ihgN6P4G+dzUopBE3drygK9eWtxw/C0Nl?=
 =?us-ascii?Q?o2v74X5E3hNYBLO3mDlrlb4UOHMM1OJ53Lq2jaVuCeR3WqS6D8Jkhd3u2lsO?=
 =?us-ascii?Q?V03CERv5NVRkQmRlRE/Kq6OrKB4UGe7oGAjnwORw9f+8ZJ1NOFQH35lksWbG?=
 =?us-ascii?Q?iSUGMJ1tgR6opz5B3kJUg6ULhzaQS+4NrTrbWmx1Gma7KbuETLpo8g54ldbY?=
 =?us-ascii?Q?CibU6EWdJ5kYpgLd07hWgezHDFckRbEjgZu0GqbpATzRdpmP+yosIMfIE2VA?=
 =?us-ascii?Q?tx6xOtqSgLeXWmHWUNBtA9mTmMZpf27gKyh6P+RUZjy69NEs+uyixPAjbTx0?=
 =?us-ascii?Q?k26+dMQsei2q8ZRV4olSAA6D7sjyztxqGbkfdK/QJu85o+rzf+o+b62MdOWn?=
 =?us-ascii?Q?/FyCn6iQCiGUi41HkGJ1CpyNafi6KEIjvCHd7lRBnlWwSsJayt/SrQxeLuYu?=
 =?us-ascii?Q?T0cGHy4/Zoc0Gv5XsKFxUKNf1o7XOI72mpUpoQmRqEftRzi8mHUGszD4kl8f?=
 =?us-ascii?Q?c08O+VP4t5OhWYWztQSCygVJb96gQCLgNfR2v03/GTrAPE252Nx0tdQ2Sy8H?=
 =?us-ascii?Q?2Xs6PFgTSU3S17fn4gTBr6ltxW4BstJVb7jMmskb62RcmzOxvTWyxmP0qC3c?=
 =?us-ascii?Q?cr3ROcQFIFiJ9x6jFpcSnILWKUk1mKuyt0SSgMwHvd4Zvb/nugfgc0yds97P?=
 =?us-ascii?Q?AakocGpVSDoMZwQdqfgvxVNthGCfQj7NmkEchhAClO+tWoefngzom6eWqYqE?=
 =?us-ascii?Q?Barf60mDj1EV9KBSrgq6pI/EcQ6bgi9dwURunRG4/tqU9+KUKBWI4WbNUgjD?=
 =?us-ascii?Q?ZdEIaqmtMUpOtnCaC0yxbwMn6cLRI1xqiCtKNBIrL1uGQ67Sv4VC9sSFi0A6?=
 =?us-ascii?Q?Rf08uC21B7DWM3vlk6iSBzbUx7c5RzWcv6UreoZZ3geoMQrO5Oj7a9Bjq8pW?=
 =?us-ascii?Q?tRbJUvnbZUfo2nQsSFM6xUyPRsVf2JDr7g500BgOVUcXDAh58FBDLGQKRrw+?=
 =?us-ascii?Q?coufUbbUOjPju3Td7sHLdtRijDK69+h/8ACbIgDlJuZwDGnoFKaLDfGpPBYw?=
 =?us-ascii?Q?XNvWIdwnM4eMbm/tDcbaHv9JF2eMSjeKGw1GYr0E5v2pL/nJ4xjXRjuZ50Eg?=
 =?us-ascii?Q?D4COWA2E1KM6AGHswMn5AsNvKcODaGAEflMRv3kBUW3JR0ELSJ2JtH8piLeW?=
 =?us-ascii?Q?Ytq4mf6v3hJT7Oc8SSvimfr3JSbNheByrtH0pg9T9PwDW2f6MAHHZWFX1/lv?=
 =?us-ascii?Q?pWl+hDB1WnjBse+peY2xa0fjmLWdJt3pQFz7X0P6PY7AfsawqwWROH5p4AqG?=
 =?us-ascii?Q?p3czJW+SbLnLOdH+MWZokajS6VGww9SoLNlENnS/j9om5aVJXLDB7bkAgjcP?=
 =?us-ascii?Q?uUGqXrCiFmoTg6AJPVTpBkRh+UPO19p8IG1dcn+f9K+KQDzQmhTwXNQEynkz?=
 =?us-ascii?Q?mSHFbtmdUb+iDf0k7y/lMvnTKTBa1u3Xc9SnSN1z/ZfBH9V+VtbKw3OcQYV0?=
 =?us-ascii?Q?g1CU9Q=3D=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a453c6-1d97-47fb-0e20-08db0d7a56d3
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:25:29.8931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K8jRnhMTKUINB9NAIql3J+lvGiob50WS5mJ6okw0fcD81Rq3pGZM74lnqZm+edmtxziz+HOWMWmVlf0D4RTyME1/wja8m9Gwo95/m4jjbqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8208
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is the stack where we allocate percpu counter block:

  +-< __alloc_percpu
    +-< xt_percpu_counter_alloc
      +-< find_check_entry # {arp,ip,ip6}_tables.c
        +-< translate_table

And it can be leaked on this code path:

  +-> ip6t_register_table
    +-> translate_table # allocates percpu counter block
    +-> xt_register_table # fails

there is no freeing of the counter block on xt_register_table fail.
Note: xt_percpu_counter_free should be called to free it like we do in
do_replace through cleanup_entry helper (or in __ip6t_unregister_table).

Probability of hitting this error path is low AFAICS (xt_register_table
can only return ENOMEM here, as it is not replacing anything, as we are
creating new netns, and it is hard to imagine that all previous
allocations succeeded and after that one in xt_register_table failed).
But it's worth fixing even the rare leak.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 net/ipv4/netfilter/arp_tables.c | 4 ++++
 net/ipv4/netfilter/ip_tables.c  | 4 ++++
 net/ipv6/netfilter/ip6_tables.c | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index ffc0cab7cf18..2407066b0fec 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1525,6 +1525,10 @@ int arpt_register_table(struct net *net,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct arpt_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2ed7c58b471a..2eb0852ad2b1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1742,6 +1742,10 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct ipt_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2d816277f2c5..34eeb53bc9fb 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1751,6 +1751,10 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct ip6t_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
-- 
2.39.1

