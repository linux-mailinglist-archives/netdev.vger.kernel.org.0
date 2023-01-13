Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6EA6688C5
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 01:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbjAMA4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 19:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbjAMA4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 19:56:51 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BD61C416
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 16:56:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzWucWZzBAwHIRzgDf7b4GmiyphKl8TUrUEk5dmVaKfLYNurScKexRHNeH9EwX9gfjiosU6dInseAn4bDk5ONjeWOCviemBRunhAe5et2Ao3YudCs1VkEw7nN7T0liFI1IUJGyf0qRabivSztLaVcPUl2Aa5MYVUTgHRQYy8r4EF9fP8hTQEdjvZN1tzy60vqqJy0vRDvNP7eiYtKvRxXO1qyi+5lIveWQrCY1u/2wePPJIT+KFRi7b+MOUje0pM21b9ue2uOK3T6sqz0PUhyA1JzxJD5dnLS89LYBW9FHsLYUyQOSxkG8iQsj2SAtr5rRE5qu3tKEsrwxojVBUEVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLrqgAMXKSJjgfz/YSWmu2yWm4Ar01e8CQb2lsv4UD4=;
 b=MFnvBGsHCIAQD3lA0eBaNClDXp6qOplHcCgXoC4O8WN/UBNPqrlPHcK0apEJb5RGZRPAsN8cVGXJUtzzt560PQfNPNqN7cLAW4IDMFO+ehLT/lsIkYYZ8G5y9O2Pw5SZwl2Lw7ep9Jfp0sfqIms6TKiH4pvuzU7ssOaWUBhBF6KdrpMEI2UtjM4xCDgRRY7UOV0Z3hgvEXZHijD/6xnW+GlfxgNpSVrxBn0iPEB0ZEJNGkpysj1woLK6VmII6cLmLgp6e4stAHMKSD0hRwZcBIOcMFjtSrwlvFb5xrYynJ94zFVqr6YyEdRMbELM610n0/1HEYgPuMfQGPOe2YmZjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLrqgAMXKSJjgfz/YSWmu2yWm4Ar01e8CQb2lsv4UD4=;
 b=gbS/kCvQtLBDFlPh9cZQoTsnX68vuFrWTZMleHnRLa9JijdOkG/aw+uY7uFlE4COlzWYQPmc2EORW6VfDq2/uEVi5hDRMwyrJPZMkYNXjtflTf6oiJTjtKJ1X7LB10YJjkr/erYIptWOLwYxirAIp3LVeOqIB3Tvq14cHKwwdLQ/fYrY/xiQz7L7wRb++1tLOCXblZJvj/SACKQXpuKKW9v3t79vyPVC+ohciX2843wXR6D0mDoO3q4yBP1S+Ixd/YcDevRnbMiWWCBVy7qktOtPsuvmiu3NQH1p0dA+TWB3CdAYpRY9BP+VMRuRka/hGQlBA7IGbc8lN7fxZIVJIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DS0PR12MB6606.namprd12.prod.outlook.com (2603:10b6:8:d2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 00:56:48 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 00:56:47 +0000
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
Subject: [PATCH net v3] sch_htb: Avoid grafting on htb_destroy_class_offload when destroying htb
Date:   Thu, 12 Jan 2023 16:55:29 -0800
Message-Id: <20230113005528.302625-1-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.36.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0154.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::9) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DS0PR12MB6606:EE_
X-MS-Office365-Filtering-Correlation-Id: b0f21628-b395-4cd8-ec13-08daf5010c39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5tnRblSKio9YgVOP+voi84247wU4Wy0mcN7QYLNCjQtzWUaslwNYZq7cE4KfqSJCwJzM91/kdXkbByLseFMCkRL7t3i+xfbP/gXjUN9kWweuLy9X7Q5nGjbNaaCwDWiVser7TYLowYxWNfSGm2oZPEGqOjvGESfPdVat4btumySHL1zkMI44Pp7V4YHOqCRgM0tcz/yDK+9h7akzYGZEGlpvHlgMh4wEjdhJbRY9Vf0SNkgYN8u2IdWwJ47jcUp5ReVrpnJOrgvjVRl1q2V9uJNDd4Dfz35tJRjg9YG1afupH1yfXrh/S89QSylNuc2gir2zgkzGMBnfwwiYR3aZ+HRoR4CI9stPE4AR3/iiC2MMngHmnMt82XdK8dJ2d5aUlAKO9gj2chDufFN0o+4Ck+clKwtFc+MgtJynho9IOq1ccJTQHZXrEEEF04boNqLLFW4o7iHPtDkAm2x0yficwWtmO+DabRXNMBSHXWGUZ5ewV8uf2ZYFVMp6apwciXtSGefAJdtPaO5dDdkEoWK34aNZK3XlEkN+EtvPGln62Lpdij1JeM8F1x8jgvXGYCVZqDOCUGGBec4W7kSz3ujudUt3cBTFIRhqsmRc3611C5MFK1Fw63OKXuUUSTwuKJS6msZgVYMHcul833EBbd6OFJoEMhWNS0B5BqzeKj/Y/wf62SyCknjOWK6ISsPbHVtbF3Z26xpVW9oS30ufBp1oOFBfL2uu+JI3Ov3K4FZohd8lwNvt6i8Jzc9HjIfNwqe1XebUQndjOdO+0PIPRG6P5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(36756003)(4326008)(66946007)(66556008)(54906003)(6916009)(8676002)(41300700001)(86362001)(66476007)(38100700002)(6666004)(966005)(6486002)(186003)(26005)(6506007)(478600001)(5660300002)(316002)(8936002)(83380400001)(1076003)(2906002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LJvNyQcCCQKEDlndPBx6QHpni9aWFjrTHatU4gqp4jpdv2BYF6yIK35TLlU7?=
 =?us-ascii?Q?9W7UN/XOYTbiwGCESae90tfwvXh61IJG66zCxTCN7CJ3+FoEMN6M1JpVzSC0?=
 =?us-ascii?Q?n4wfUI2DNXqGx2fLvyC/hqv4y2OxLTMeTXcwPF9RlP9+F1tk1KEak5Pjh8X1?=
 =?us-ascii?Q?rOIsnjT6BTsODJ249yuEiTwrP577M4ixW+JW0L4aRUI0Bg2h2WBRxRK4raIP?=
 =?us-ascii?Q?z/yuN6kYutehkXyMQep6witm7XVGhkkD00J++5FQz4DjpyTMQs1HFboOnMbK?=
 =?us-ascii?Q?15XxNyd7l9QEy4tcxcyxy8uJDjFXBUo2toaSntK/cD0AYSq7x+LQ7XLT1L4Y?=
 =?us-ascii?Q?Ut88HduS49CivXZZc67Qk/q7OktJQEly+IxVWjs8FBRETbKiqCrs7ThaXNKv?=
 =?us-ascii?Q?W2rSkEtlWkaA7z1JjIyJDcl0lkA9oHrlCsge54syomIZAVUljJr1svHXwSCf?=
 =?us-ascii?Q?7+6Yk/xT6+rst2bLryZhbU93NscZ2QF9bwN+BwZtGC1VOFf9p9j5mHBh6kYs?=
 =?us-ascii?Q?QQGcJXARtpvzlKtvW7NS3pvZWQ+pJxZWlMznIXY+z9V6KRKDL40fZrTARt4K?=
 =?us-ascii?Q?NkuAaqm4kTv0rYngxP4vi5qGFNEzfQocLbV78pzQYee6yrtd3budIcsQiKEX?=
 =?us-ascii?Q?PBCIZaHUGr40BuPAUuNWz6DlhRJPBlM5eI48GjaVSZi9c4Vfe1NOO7p6FVDN?=
 =?us-ascii?Q?PvOtzWpBIgUsuZmmCpJ/fhRKxSWXu8T0uROlf3vOzLJ4phYTw2h1Ntgi+dAn?=
 =?us-ascii?Q?rjqwcmiXdfivNbStoCgmnBUUze4iCAVLm7TOpb7bj7dCvT6XItIHEow7Og46?=
 =?us-ascii?Q?IDlBWIrnR1p7O/PnLaLiUcCAKhLyqVcTIwqjJAD0y4faFD0fiCPgaTsfC91s?=
 =?us-ascii?Q?De3xDmw8iUD11u3IBaP3A0/1CyvtL7gN/hgdWZ2BhbEUkV4DTMs7M959rXpR?=
 =?us-ascii?Q?n4CIzUR3svJ97G6DUXdI1ih4kPlxVJccXHHdfJRrjGdAmErA7V2/ty9NT8+w?=
 =?us-ascii?Q?X6tbPjVEyg4d89nmYLlJxiHclgopNJJKHmQJ4LnPEOJEKniJafIUik3/6pJ4?=
 =?us-ascii?Q?RHQIoQ9aw+RRbBsXwp5YDIlW6g+5UzQZKJnfcyM+Ek7FGnzQGTZt+NZYUkJW?=
 =?us-ascii?Q?Q6uRH7KXBss6arQja8W9UpolmZDQScLIgbl9l4efXOibwk2hAreOECiGo02K?=
 =?us-ascii?Q?U0jzWGLRlMKlnj7hvDAqkX0Rv7YdYSZCdNHmvCIgwh7oVcsIyIzoXbKtx25V?=
 =?us-ascii?Q?tBF+nldGsHoK4RrLVTKHbhXXn3rvpwkQaJq4dRdZifCvRjuwuwy1LZkIQr6v?=
 =?us-ascii?Q?RAxO//vCNMZFRCNqfiqt7t1C3nIbT18jxc2zdR+TUNxfTQ13LBtABLmgNAk5?=
 =?us-ascii?Q?p3I76p9TJ3FGllk6ruLx4rITAKv2ANJkOyEZ6JMPY0g+y1fuCgPjryQ6sWV+?=
 =?us-ascii?Q?ZrzvUKiqed+KMFyafXAJlztpyevX+IOm+ERwjbXwyJhUXwZGzQ40wXad+kCg?=
 =?us-ascii?Q?tPY1OOxnbCCY0ITL2vwWPKbDikB1bE8eVDdcSniN/rprF6ihHvYXqfryHkHb?=
 =?us-ascii?Q?lWwRj7vEGuLLBnhPiQUysNo03rdUvm70eg9I/z1m0yS0D8fSeP2PUHgRlXNc?=
 =?us-ascii?Q?8w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f21628-b395-4cd8-ec13-08daf5010c39
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 00:56:47.8053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+rIwuf/c65Cwk73hbNyqpvTyHbBbHTHzHD4VzqGom+jAbq/GOXLQDUPFmNRznNilc++fzBZV5FtVSmTXEr9Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6606
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peek at old qdisc and graft only when deleting a leaf class in the htb,
rather than when deleting the htb itself. Do not peek at the qdisc of the
netdev queue when destroying the htb. The caller may already have grafted a
new qdisc that is not part of the htb structure being destroyed.

This fix resolves two use cases.

  1. Using tc to destroy the htb.
    - Netdev was being prematurely activated before the htb was fully
      destroyed.
  2. Using tc to replace the htb with another qdisc (which also leads to
     the htb being destroyed).
    - Premature netdev activation like previous case. Newly grafted qdisc
      was also getting accidentally overwritten when destroying the htb.

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
---

Notes:
    Changelog
    
    v2->v3:
      - Removed NULL assignment to struct Qdisc *old to catch uninitialized usage
      - Improved code comments based on previous review feedback
      - Removed WARN_ON(err && destroying) to avoid being triggered when the
        TC_HTB_LEAF_DEL_LAST_FORCE offload operation is used
      - Described underlying design errors that caused issues for use cases
        mentioned in commit message
    v1->v2:
      - Added use cases that were triggering relevant issues in commit message

 net/sched/sch_htb.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 2238edece1a4..f46643850df8 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1549,7 +1549,7 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 	struct tc_htb_qopt_offload offload_opt;
 	struct netdev_queue *dev_queue;
 	struct Qdisc *q = cl->leaf.q;
-	struct Qdisc *old = NULL;
+	struct Qdisc *old;
 	int err;
 
 	if (cl->level)
@@ -1557,14 +1557,17 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 
 	WARN_ON(!q);
 	dev_queue = htb_offload_get_queue(cl);
-	old = htb_graft_helper(dev_queue, NULL);
-	if (destroying)
-		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
-		 * all queues.
+	/* When destroying, caller qdisc_graft grafts the new qdisc and invokes
+	 * qdisc_put for the qdisc being destroyed. htb_destroy_class_offload
+	 * does not need to graft or qdisc_put the qdisc being destroyed.
+	 */
+	if (!destroying) {
+		old = htb_graft_helper(dev_queue, NULL);
+		/* Last qdisc grafted should be the same as cl->leaf.q when
+		 * calling htb_delete.
 		 */
-		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
-	else
 		WARN_ON(old != q);
+	}
 
 	if (cl->parent) {
 		_bstats_update(&cl->parent->bstats_bias,
@@ -1581,10 +1584,12 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 	};
 	err = htb_offload(qdisc_dev(sch), &offload_opt);
 
-	if (!err || destroying)
-		qdisc_put(old);
-	else
-		htb_graft_helper(dev_queue, old);
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

[1] https://lore.kernel.org/netdev/20230111203732.51363-1-rrameshbabu@nvidia.com/
[2] https://lore.kernel.org/netdev/20230110202003.25452-1-rrameshbabu@nvidia.com/
[3] https://lore.kernel.org/netdev/20230104174744.22280-1-rrameshbabu@nvidia.com/
[4] https://lore.kernel.org/all/CANn89iJSsFPBp5dYm3y6Jbbpuwbb9P+X3gmqk6zow0VWgx1Q-A@mail.gmail.com/
