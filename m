Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E336664E6
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjAKUiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjAKUiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:38:01 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9928D15FF0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:38:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UofHzmVSvqXd0Z5R1XAYjdbwjbcWaz+hf/m28MOkxcBnGjOCTj1vb6x0jRI9TbxE7ujDERTtZLZPZaJk9H4dwMbb0Y4JMZxvL+m08KBWRKEOMJfHOXG/9yjZQDsjXJu9FpCFSJyRsQc94zD60WR0s9Zn8zUOUAsw7HThtMY/0VBOgDHgTkW+iiEJnbwAAp440onETkYF9am7zORdqICkCYsbDo+x07wpMOyHpKymCnP3mPY8kiqHy1APQ2F738TglBkPb4TEudZYF+Rnlk7wtf1eMdOzSU3ay9WRPtH+yvtKLWEc/0pi3P40wjparVUz8xTlNBYGRgXtfrPLgH9vuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6S1u0LPbWY6mNIiMRPArAB5MJGYdV4OTX6YrmMVLnA=;
 b=l2wJzGwYt9i8TIZ19FzO2nc/UKspiV/yPzQE8F0rkaHQM5ka5z/l0hkIZiv16vCl0aSOSw7g4X+5wzREPOb0YrW7k/bNxzxPUNNpVrA0SZjIJVMCE/Zloh0KV1KbMSeCdq+o8cuD3Tj90+HqCDH4L9+GhBGvLdZraKz7llBhd+DqQar1dlMptpzdy9HxPlk9mbTbvcyz1eatUnsiI0UxCQ6sari6ljZ9C7i1CabhmaNVeF0j4x4mriEMpxIeEHHa0iHDacCn8QlLSuBhKKSBlrZ7SvcjHRSHzkzw4NPBQZVF7FF/qC80uDOx73VNdK/iBWy/tBBZSf6NZwpTf+fOuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6S1u0LPbWY6mNIiMRPArAB5MJGYdV4OTX6YrmMVLnA=;
 b=DVpDYh4j679VOqMDaNDCZ1G82SsG7RpU+uwhd85/I/hxii8nK6/UQ0wFqLUdPNUhkbUv0qS/f+akbRVWatzztm7Vr7shyvQFFcoSCCtG8fnwXyqonyStiMyUF3q9rfcMco14O101P6pjBspqNv7NwLTx9h82wawOaoe3vDmPwpe6pv3aWXtnmjhO1ZqMi/oD3zASWhr5nTMsm4iOuK1wyKibVXJKk+6UWiy7Cv2ENFbQUND73kjm08qSvvlr/ZMeKjo5ZqNThTdzVuunwN4eGMVFwwSfu2YKdUSTc080fquoZryrznZ5Gb/C3en/C8Vdi5Vq1dSJA3V39sFcqD2QCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW4PR12MB7214.namprd12.prod.outlook.com (2603:10b6:303:229::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 20:37:58 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 20:37:57 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net v2] sch_htb: Avoid grafting on htb_destroy_class_offload when destroying htb
Date:   Wed, 11 Jan 2023 12:37:33 -0800
Message-Id: <20230111203732.51363-1-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.36.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0102.namprd03.prod.outlook.com
 (2603:10b6:a03:333::17) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW4PR12MB7214:EE_
X-MS-Office365-Filtering-Correlation-Id: a70bcea5-5fb1-4db0-db09-08daf413b94a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rmd/GKqJbLj8BP1JZpRXVLyqCUrW1v8OUn+SZUCmNtFfzCmGRB5vq7xNZZ1hVQANPp/vmkA5pS3+8k56YRA9zfRNmjOqf9CWA4yL70Siwn5ZNiAMuUYsBelBLBR0+Vik3xjN2HvUCuRzm/J1TJfG+q7y0mxTaDqfAygxZ7/iI1nMPAUx1GQWNNx9WHO6TVHBFaGqDwzOcCg7dFgAH/kwt+3Y+7BqmDN4W+nu8ZJ2VE1ulsgNGMNYFJJkXeMz2Ji0o6+n4vTaI0RUeUr+EGraQGY+xso388f4I2nP2lWK6j/wb+AtWq+KTPdi64oBryI8KY7OFxbehTHoPMXsdzPo2oGkXSQbR/lagN/ZRWHg9UbPmCdZCJbsmP3fukgjAy3iaL8+RtNWUFtl2cZNVmhKPW2+m2AGJKsL5yUZu4FhxQ+PWzGBe7ZBML2OiOQ3a9MAZLtdZMyC3bmkCAMNCuAsbU4YHvbE5QGNmja9aq6D/95f6E1auG/deX/fs7axrHqBL8IwDpWKRunCc5NBEwEJyrKOy+kp27uQ5gxXatmvAwMe5GGMXBoLmmAd2hIDy4sjHNSjMPp477E0U/dOfOlqyksxUBndED3HmfteyLmtDqCZmFXOJ88miKFTWq9LpNcejKaD5jaR+yrI1wxSbGsi2tNkG+wjEhRMYH+zlv2K2r+fFZY80jYfDon6B5Ibefw5pvYnwgFQEXdMohqObsHG2+Fhofky+BPqJdZJCCJX2WYbXa3yODo3c21SR7YPFyzKUeO51GWvNx5s/gevHtZPAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199015)(41300700001)(66476007)(4326008)(36756003)(54906003)(8676002)(2616005)(6916009)(66946007)(1076003)(66556008)(86362001)(8936002)(38100700002)(5660300002)(83380400001)(316002)(2906002)(6506007)(966005)(186003)(6666004)(6486002)(478600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lgUwmlgw2rVNax8iTqEnfNt0k569OeUHEZ8xZFczCh99QZYRo5AZmZXzGdg9?=
 =?us-ascii?Q?4goJKONnNF3NStN3a0NHu/3TmNqjelYmLbHk5qtEAIPxR0FXhNBisrsMRLcK?=
 =?us-ascii?Q?VuTAzN6b6kR1jkvcGIknMUZwSUoKc5YPP+7HLKPEgHyUX0Un7HVSXkwQSANk?=
 =?us-ascii?Q?K+neZD5Ty848tzlZHGhNVxJ8IMDcYAjHaZSqUfcMyQZl9ek1RmFL9MrJhGQO?=
 =?us-ascii?Q?v9+LETier/vFsy1+pRY2MATGmu3/0xIpFTZdB0ktewRTAG3fkjYRjlLTYFR1?=
 =?us-ascii?Q?lTio5TjeKsFH6iO00NRCsvj+F99egByOIv00fp/WyNLv9+DpUTNo8Q4OHouK?=
 =?us-ascii?Q?+f4VlbzJ5FQFhjsHEyoFth5Pc3ByRExx0xYMLKUwBHDv3p9PaZFdIa31/rfz?=
 =?us-ascii?Q?2E/chDsAsNdGN3d2DXJ77h9j0w/U6LjDzRYSJRBwjZmGK9KcrzS11zVTFY8l?=
 =?us-ascii?Q?2pj5GVgiBjY9xm5+tWjmkNmkGb0tMmC4N5T35ItJfLuL0IxtFwJXfsjq/PZw?=
 =?us-ascii?Q?JA/v3fotLADIlWbS7WZ58CPgcThABVMNR/m4i81Dr6FF6PHT63wv00GFP5IF?=
 =?us-ascii?Q?pEaqfYBSF699LkqVQrTIcOou56nqQecgVR9cXUiY6UCSuSeC7NlJnGj5ZsH9?=
 =?us-ascii?Q?k949F3qTGpcNZWzW5X6T0taPyEojgBhKQEWQkSwLioEBifHndsVRXvVJmmor?=
 =?us-ascii?Q?z1NRf18wQFxiHmXDsyGYmVzlqvo9bIWCsBNIAi38zCqDLZQIrB0qzDPftf3w?=
 =?us-ascii?Q?6UAG+gMWVmXlPRQtzqwb44xcFishITj3DDFy+SY8cs3VbfzBCqDajSn0bQLN?=
 =?us-ascii?Q?jfIgrJkLzffOCDLPIXGl3jQcNtEFzIbD86FL3Cj89cQQdg5H+nZ8uKH7nvws?=
 =?us-ascii?Q?IVJ9zeB00FA4vRLjs2+6lUqNBCscfeE1L2YIkr3MATDDPa14vN5Z+th/QKZZ?=
 =?us-ascii?Q?0dQwWaH0Kj8yPZzO96icXCh5eEF5cvIJGPMOq4BsFENkc7SHi4uGNLeaLr7E?=
 =?us-ascii?Q?GEjOiOvXBdLamd7FhuvESs8QcgvIq6gcsSLOFQJbMXms8/YyX5l1eW1wIjaT?=
 =?us-ascii?Q?bddSwSwmRkf5lNnqVVeAhEhXeVlE/II0eJaXEOcDRkXL1LSdAPAzf1lhHTL8?=
 =?us-ascii?Q?gW1WkkrhVeGeZ6AsB+z0y1qQV4SenaWlglBqiibs7XpYP9NqVl2pS8SdyJN6?=
 =?us-ascii?Q?0h9iE9rjf/vZPSxFtXTHytSEe85SZ0IpA5HugX0LHY+lQsjaoErDdFZRVlbS?=
 =?us-ascii?Q?5pcmmvnhs7gH7kvBjUeUSjqOkwpQPggYoJmpezjXsP8Tb6kRRHzViHQrGECh?=
 =?us-ascii?Q?ge6yx6f1p/TDQ6NqaKIhN9QNsiAxjSRlH59/9PB4PPP27qRK5nMWfZXOrzR5?=
 =?us-ascii?Q?FF9AZDW+DaW1vgeBkRUAa3xvBcJEKusbqhiOsC2UbU+GCXqNb65oJrCOPb8c?=
 =?us-ascii?Q?zQEZ9AFJ8tywx2BJH0H34Q3Kz4yR9w5n6FL+A84+qqygGfz1cSsr+xMtE/I3?=
 =?us-ascii?Q?kyvQQ6YgCgzcQFiEGacM29orq0DCxQseRFM8trUvWBWx8+UF8eF5SEWXKXHL?=
 =?us-ascii?Q?qzSrzg7j7XEFvWB9Bpj1Atknqbij2DJOk3sjeF0scLa3wZ9Yl+4H5gleG5Mi?=
 =?us-ascii?Q?ZdsxyPdOF561yIkG6fz2tBHgLsqCMt/LUkuJlLwiPjKnyFqrBnvk/cXIgUIg?=
 =?us-ascii?Q?zG2dfA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a70bcea5-5fb1-4db0-db09-08daf413b94a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 20:37:57.7686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bC6DAm6brE9UskOijWMqWukVh+z7nhGse42Rm9Dm2npjPQ2TKW3C9HnSOb6DjL/1UeKcKh0gevgFRXU6YNpGfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7214
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When destroying the htb, the caller may already have grafted a new qdisc
that is not part of the htb structure being destroyed.
htb_destroy_class_offload should not peek at the qdisc of the netdev queue.
Peek at old qdisc and graft only when deleting a leaf class in the htb,
rather than when deleting the htb itself.

This fix resolves two use cases.

  1. Using tc to destroy the htb.
  2. Using tc to replace the htb with another qdisc (which also leads to
     the htb being destroyed).

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 net/sched/sch_htb.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 2238edece1a4..360ce8616fd2 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1557,14 +1557,13 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 
 	WARN_ON(!q);
 	dev_queue = htb_offload_get_queue(cl);
-	old = htb_graft_helper(dev_queue, NULL);
-	if (destroying)
-		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
-		 * all queues.
+	if (!destroying) {
+		old = htb_graft_helper(dev_queue, NULL);
+		/* Last qdisc grafted should be the same as cl->leaf.q when
+		 * calling htb_destroy
 		 */
-		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
-	else
 		WARN_ON(old != q);
+	}
 
 	if (cl->parent) {
 		_bstats_update(&cl->parent->bstats_bias,
@@ -1581,10 +1580,14 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 	};
 	err = htb_offload(qdisc_dev(sch), &offload_opt);
 
-	if (!err || destroying)
-		qdisc_put(old);
-	else
-		htb_graft_helper(dev_queue, old);
+	/* htb_offload related errors when destroying cannot be handled */
+	WARN_ON(err && destroying);
+	if (!destroying) {
+		if (!err)
+			qdisc_put(old);
+		else
+			htb_graft_helper(dev_queue, old);
+	}
 
 	if (last_child)
 		return err;
-- 
2.36.2

Previous related discussions

[1] https://lore.kernel.org/netdev/20230110202003.25452-1-rrameshbabu@nvidia.com/
[2] https://lore.kernel.org/netdev/20230104174744.22280-1-rrameshbabu@nvidia.com/
[3] https://lore.kernel.org/all/CANn89iJSsFPBp5dYm3y6Jbbpuwbb9P+X3gmqk6zow0VWgx1Q-A@mail.gmail.com/
