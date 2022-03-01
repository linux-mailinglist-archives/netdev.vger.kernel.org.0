Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1AC4C8C52
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbiCANNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiCANNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:13:34 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2112.outbound.protection.outlook.com [40.107.236.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C0F23BF1
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 05:12:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmSwCEPUciwxlWJiZTOvNsTm8962NYSYoU2LLp0v//stw4Hy0FsQryZ15/pJzxZyzvRhwATiVNs5D2AfV3Q/sZnctHut/QS/bnfAa32gjZU5RBW1nx8mkhnaNfjXcCtj6uRTrANgT2HJKU73sLk0m7BcohH1a5JdeolWgOY1izJgbbj9GqIMt+PdlzSAD9KcNQZ7JI5bMJvVI6mrRDWmlu6SWSVwiak56RV/fzAM1PZlN6RDZWI99Z8NpuEvscG1SjFHBiXy8bzcj1XnC28cLCdobrSTrj1+zyvWIo0hMzF/sxhrakdThUelZ4QE8zkpgj9FQeiYk0mKglBOx7HcTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+tQZho7AvI2QB9c44JcbMcsakt0I5t/wxbAAU7OEo00=;
 b=f869KvAhMajWJJdxkF3Odm3wvuaaotGmuUuYPVQD4g6DbnX1Dwxh4RQw6DqR7yefI7u2Y+M5Pc4V+GADkthmq8e8Lt1qTXGyvdUaRjCf4x/iYnQzQG8u0OeR29d9A5skDGreVlbnD0j2Q076wGx9LrUIEynWp9m3SH9bhEp3eVhq6AAHcNVKzBUL3ztf/1jMi0+t5sHnSsTek3zDPZ/5S2w/auoFIcizEL/ux9RA5tmlykuWYBkr3dD5nE05k7sIz/tcFCNt+EYKJv+CvNRmZPSy3+0R3Vlb31RRsbJZZN0BwwocxXnpE3kuj9ZzZ0NyDSTw0++d1aQW2WrUW2oD0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tQZho7AvI2QB9c44JcbMcsakt0I5t/wxbAAU7OEo00=;
 b=RYh+xmm/VkJyYGrE8Jdd9Ub8EBieK9VPaQ/XVrqChnmyOsH6QLxM+XaEJOPXCw5x5LMvu2ijPd0mvrtBWxIUnC9Y8VM7MGt1TYnLsIJBzle6Aeg8YpVTdRM28R+tcrdOpaeOduZBVNjzDyuRlKz7zgk1HViNHOx78qllDWjNGAk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR13MB4230.namprd13.prod.outlook.com (2603:10b6:4:aa::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.12; Tue, 1 Mar
 2022 13:12:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5038.014; Tue, 1 Mar 2022
 13:12:49 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: flower: Remove usage of the deprecated ida_simple_xxx API
Date:   Tue,  1 Mar 2022 14:12:12 +0100
Message-Id: <20220301131212.26348-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0043.eurprd03.prod.outlook.com (2603:10a6:208::20)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6e26e97-0125-427b-1c8d-08d9fb852f75
X-MS-TrafficTypeDiagnostic: DM5PR13MB4230:EE_
X-Microsoft-Antispam-PRVS: <DM5PR13MB42301BF782909378042BEAD1E8029@DM5PR13MB4230.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rSRSkn7hPJ1jCgh0XHB4D2x8u/5FeTqflGD4L4ewxNAJHYHvWw2SdHU7MpJPVGQe20nw8X0UjuVjNRfvRebzMM0M6tNiqWLQ1lpUDxhSU2vq0EBxwlB9q9b55vuslqZFvfcNQCjHu6kuf9U0w/TKhPuCxqw1W7OMBCAIqvbKrt30PeSXIdxQCAEaeY2RP1OY79zGriGYgHrfluYDAiLvLNnDoPXt46xfBsPafpZWkx/vM4BybpAzGTpnMg9Nn5XZVaGDV6Ep6RuvBaw3h1YJN0OKWqnxDlC33ial5sihgeHUQmoUrid1REWhVGkCd4d0/C15w1nXtMwMtbUQKoIn+EL4i4U7Df01HQdW2OEtFLgZwts9HtHBtoaGL2uENDYi2IDR+XR8SuC/znw/LIT4C5y99JrixYNYD7Yf8dJ6mV5a9SLbCWh+fI8nt0ruq2vlxomY43UacB8FR+rFvWdfvMPtiXli9SzmfqgqIH0XwU9g3DIqG16pGIZcHQJsdWIvDdOWadVOafa5W7GamRNJQO5NQ19a1XZlnbIvhwzLjFi3F+MwK1FM6Kz298GKLng3PqPco3zSXTs541GNJhPMMSd/phtJXJdutZqLxkPQerh1iiOEOxWbiX9Zy7GSPOzXwnI2JdQGExBzbKL3SRw3/XHrIw9iMsnDMyxglCV5DoCJzGZCY+k8dpUTZNcVhIWrTKRbMQiqAHMpoFOy23uAzNbzxeAJbcibqxVFzKdyXDshk7jwIHZwmsqhP/o4RFYX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(376002)(366004)(346002)(136003)(39830400003)(186003)(6506007)(6512007)(6486002)(6666004)(107886003)(83380400001)(52116002)(2906002)(36756003)(5660300002)(66946007)(66556008)(66476007)(4326008)(8676002)(38100700002)(508600001)(2616005)(1076003)(86362001)(316002)(8936002)(44832011)(110136005)(54906003)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7t60qHkFJg8KQEE/jY+Z693PMGlHrWmwFlzewIRbKEEf//OWwVNQ17iHwMa2?=
 =?us-ascii?Q?EmgO41MULOj45jten28mnCv2MhoWUJomp1gZ1qtYrXqkZeO5m6sKYWgjdSO7?=
 =?us-ascii?Q?tR345KQPamm6ZIfIuYb8zg6AdVGyJZ0Ed9MmcbfE+Sfip+VYOCm/eJuvIHKz?=
 =?us-ascii?Q?kxDJjaw8Erw2W2OdJLi0tuxvueCj7GPdWWP6ZvXwEajPoshm08xo4tWhTBUl?=
 =?us-ascii?Q?R9S6PbFLjlPzHlt3O3/x7MbOkC4GqI7oSiRwD+VhkJUEYSShkgVbFdzFvVtv?=
 =?us-ascii?Q?LNtjIjXeQffrbKSnsVOirxVoxqMfXS0C/X+enh3KHc5QqP1inhUC8NkkrZ1v?=
 =?us-ascii?Q?wJkIIY40qsMEs2NuRFH0t0T9DP7/na9wRgmeREsO9c0tkHZPBmbKOb/0CtWO?=
 =?us-ascii?Q?RYZrXnFzP8olo26L9kVGu+PZPMal7U3FRDRg/+PFnOvgRiWV8DHw2DCZoQ15?=
 =?us-ascii?Q?X/dT5Fz6LvazxjNu0025vtD14uamp2uFLJQ1C3uycyOw8YWJqOF5akDb/ASc?=
 =?us-ascii?Q?EjFzjvgX7XhF4fIr0EUZSLJR6cBS0IUc0I06bJ9p8H0Ve0pOJFlub5wo5hh1?=
 =?us-ascii?Q?Zcgnr/5bT9rtK0h96BPWjPguY4cO7/XjRwQc2675EpEQOP/1O0E4Mnwg55Pj?=
 =?us-ascii?Q?AV6WBnNZ5NfOuuWHV7ProDdhsib79yZYYMhvdJA6OYon+nGV6xpUAEMvfqqw?=
 =?us-ascii?Q?UtsrAYDEW2OyFpqSjvrzuAkQnGx1YTDuyIsdGMlX3tlDMwAJdAbzJ141XE/Q?=
 =?us-ascii?Q?ewDGqPvf3EBHOXKo0T1TmLnrjBs3qN2B4u6J7jwCx2986ng1EV7iA78ZkZ5a?=
 =?us-ascii?Q?XdLzpyZEdSt4/fEWv1cJYYwsvaORz5utguHJgE8q7JKegbyM3XSPobAerjOl?=
 =?us-ascii?Q?QuA1zMtKbbBbzHHnrDtcQe3u1VLTIcQj2bDN0dhn4QbpBWuBuYP9y8OglYXP?=
 =?us-ascii?Q?S0T4Zl7Bnxp2rYQlbMegIyWDO+gfR5ghDEPr2+CGPXg9MqLipmMwnth7SMUK?=
 =?us-ascii?Q?4tpU74+WZn+aqF+Gr68c/8zSxSUT2GPW1X2pqf7Jj7uJNEjfWtXpb/h/mFV8?=
 =?us-ascii?Q?SftwQW2uXH1WGY16tQYgmiagm7/zW1vyPjqT8zHUVCh9SVvlhVvSWOpfBeJs?=
 =?us-ascii?Q?WEq4IazLsBQOyR4zJzgUmy/a2hRlRNY3p1yrmOwJ8FY4t9hzN3Cvzs9GC6j4?=
 =?us-ascii?Q?RyO2CV0d0jdiyqGJVokJsOWwnC1HD6Qk/KDKn+X4wkJAiapj2e2lzKVJdCNM?=
 =?us-ascii?Q?D3WUE4HsLFbGKLgT4MeAA4VUWKxSv4xlWi0o2AKyuV+Xg9r8ZBsriBA6lj8l?=
 =?us-ascii?Q?wQw+dr1qysSXFI5tuQD+crpDQOLpxb4Ay0LHYO3XI6AHyocsXAwGgvgin8NE?=
 =?us-ascii?Q?63A/Nuw05aaUJgtQ85ijG5OQVvml7iggSPjBMQ9ISjOFFnpy8WcYGiWUo0Et?=
 =?us-ascii?Q?DfnIzrUed7eTOIPnwZlPYrzp6ey98b52tJLBfin7zt5/a+bYCfXdxFjCBU9h?=
 =?us-ascii?Q?O0kVq64Eyf8r0B5OAHh5UE8D3x+pXw211AlqMeGxGXF5UI3URj8c0HovHR3I?=
 =?us-ascii?Q?JvqcA/afpWW34YPRa0/ktlZ73nh7/fUyIX8ngC1N3GNTtSslM8JLn69Q8SlJ?=
 =?us-ascii?Q?0nJct3smFuGf4Wt/7NApOfMXyzwvga13SBTFD1J7YGalH3hYqcbk8dTplCYE?=
 =?us-ascii?Q?s8askQxi8ujH6xpQ0cCy/YoHRxgF11BZLr3mahDX+lkpMziIWomsQoG5o41J?=
 =?us-ascii?Q?16bojqVqnVwOiQOX4C7BS5DNWAQkj4Q=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e26e97-0125-427b-1c8d-08d9fb852f75
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 13:12:49.6948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dpk+kh2Q76Xc0msJ5Y727giG1Kfx45bx6PqqFzdkNXSUrMlE5tBeF0uvEFklZmLQcepbX+gp1/JyvKUAFgMP1Nm9G7+K5UYlvP3XNafqd3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB4230
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Use ida_alloc_xxx()/ida_free() instead to
ida_simple_get()/ida_simple_remove().
The latter is deprecated and more verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/tunnel_conf.c    | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 9244b35e3855..c71bd555f482 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -942,8 +942,8 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	if (!nfp_mac_idx) {
 		/* Assign a global index if non-repr or MAC is now shared. */
 		if (entry || !port) {
-			ida_idx = ida_simple_get(&priv->tun.mac_off_ids, 0,
-						 NFP_MAX_MAC_INDEX, GFP_KERNEL);
+			ida_idx = ida_alloc_max(&priv->tun.mac_off_ids,
+						NFP_MAX_MAC_INDEX, GFP_KERNEL);
 			if (ida_idx < 0)
 				return ida_idx;
 
@@ -998,7 +998,7 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	kfree(entry);
 err_free_ida:
 	if (ida_idx != -1)
-		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
+		ida_free(&priv->tun.mac_off_ids, ida_idx);
 
 	return err;
 }
@@ -1061,7 +1061,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 		}
 
 		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
-		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
+		ida_free(&priv->tun.mac_off_ids, ida_idx);
 		entry->index = nfp_mac_idx;
 		return 0;
 	}
@@ -1081,7 +1081,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	/* If MAC has global ID then extract and free the ida entry. */
 	if (nfp_tunnel_is_mac_idx_global(nfp_mac_idx)) {
 		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
-		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
+		ida_free(&priv->tun.mac_off_ids, ida_idx);
 	}
 
 	kfree(entry);
-- 
2.20.1

