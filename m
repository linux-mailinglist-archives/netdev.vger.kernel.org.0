Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8B66B4442
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 15:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjCJOWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 09:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbjCJOWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 09:22:12 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2097.outbound.protection.outlook.com [40.107.100.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0244813D4F
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 06:21:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQcwiBtdw3L/cUwiP+KxseiEE37SkibyocRA80Qq8MzFa4XYm3JF8uLOe/OqFOAStQXzE+CpAMCmCWg3IL+ACiQ7bxWsu2hXdFt6bhFP7pubyTg74qmf9GdG+O8nEK5cptNcbvwGtX/e5ckPqMC6eccQCDhI6ru+brtoznfD2Z+itiaJq/EuscFcN0pJA1Y44AvISsO4lCu7lKGtiLB/H5BJC/p2feXvU5ax2X36FnpWn+kyZnzjh7cnuYiA8JVluLVCpjIrqXi65CY7p6JPdOQBMShB33ICK5S9jGgqe3O6K4lI0OlB1pnHfP1bjGqIEt589zCs3P2nkO/RRU2StQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPXKUA8wJR8RenIY+XOtd5ppa0clIyFGeGcmIm7yXI8=;
 b=lSMVAK/fSWy8lC7BVFK4JaXIVeMZmh0h/63ZX+ehkGl7VsgeBBqaQ39b3Oct1sZuOCebAGMCqTUJ5bpGidX2JUwn/UshmiARKlpnLx4eGsOG6WxnJtJQHRDF2iWbcyxcFEcoci5bIuwSFsN4A+LXBaF2VnP+ux24DJ1/xRXH/xsLeUKgAhGDKrafzgVCiJ9UTZvDDi7AADEihyvG02fYYo5Zaou2F+oNpQ9+BaoR4xah5nhB1xqaUp0y0mq+7Un1Blpexsj9uihLxO25EsxrW/1q62c9CXoY0RBZO2UgQJuE9UxEVb97K6GsDEtFcyQ4e5e0VGc8Hr1G9TwIHEAbvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPXKUA8wJR8RenIY+XOtd5ppa0clIyFGeGcmIm7yXI8=;
 b=JBTr6zIE3qU7gzadx+6qsRksTSt0HdxuAaw48NhNUspPfoOWI4VWcxgT/UMeg97YuWqwAuMtMKbbhOQ4JEXjgQihmiJPkHaqCXA61UD096NMbkp6N1y46Rsz7DrWgYMZlUgkuuPQjRGLk9kPXYHdzMD19UBukgYiqWRvgGtsBKs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4828.namprd13.prod.outlook.com (2603:10b6:510:93::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 14:21:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 14:21:22 +0000
Date:   Fri, 10 Mar 2023 15:21:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next 3/3] net/sched: act_pedit: rate limit datapath
 messages
Message-ID: <ZAs83FgjdfizV3Nh@corigine.com>
References: <20230309185158.310994-1-pctammela@mojatatu.com>
 <20230309185158.310994-4-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309185158.310994-4-pctammela@mojatatu.com>
X-ClientProxiedBy: AS4P251CA0021.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4828:EE_
X-MS-Office365-Filtering-Correlation-Id: 883e9f39-a1a4-4b78-9056-08db2172b93f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUxrtQQBjuXMxooePvHhu83DvqBSLX2oB4R28kUHqIB1sYRB5uBZAIIcLuexaEWeNilbFvYiHIvGmPy0kWFU8h8IBUe+dCrgFdaHECwgBGSvB/DzgTcXN8kEpeuMZp7Bk5Vt0DROco55uyBEGpUU/p/F+Xx3TT0lx6rS365HR2zCRnLg9i1A887N/MQjXXwXIUe5L4HgBks3Mok88EU1thD1ArijSFSfMc6Y07e0hwl5P4tqJbiyVGqJuvzhq7LZph+6E8d1VB8CsISWgyAN0YmivjFp0FKtIwnkT4glaBAq86Y4j/5tmAMMw0+lAMDamrdSc21vWDscSIbxs/at+ZzsqZFYec8cfj71N5gR+4Y0BIw6svvXxVnUOZUtcDdrtIWucOrt+7xa99yK8eJa3vnh6rIh/4HbV9pO7/HpO4iWAjPujzU+MTRqaLRRuvbWUrhbSVTgCwUQ6nQVzkG1JUdzHOgcCxMFFHZpMTLlnFWhPzQp0BTd9RlDZpdLQ2+JMFph4iHV2/xxAl04uAroDoQT09zxp6QVIjx3kbmE0vjcuFNMYyemD+tipolSsOSPpyvfAsfwcfEos/UPSNmKeGoV0CVUHDsR/oxLEANs51oXNCMyXlowqWOaT4ESXYxYxHsQNcA0ICLJMTU0A+vm25L8a78L0gjEUN3wQ+0nLdkW1n47+M/RZusMlvxeclYO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(366004)(396003)(376002)(346002)(451199018)(66946007)(6916009)(4326008)(8676002)(41300700001)(44832011)(83380400001)(316002)(66556008)(66476007)(2906002)(8936002)(478600001)(5660300002)(36756003)(2616005)(15650500001)(38100700002)(6486002)(186003)(6512007)(6506007)(6666004)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MNbmpU6tXDpka2gjZQDkgUYqrjyMUubqWQvZD5d+ekyDJopcb1+Ej+oV9+Fl?=
 =?us-ascii?Q?6fHauprDZPwKRrrI4buGgY6U0u6TtXwNF+A2g1bNX8iEYlmPql8cL5nXpcOT?=
 =?us-ascii?Q?zIC6EeFbhjaHho2996Tc+jUJtFZppCE30pGEK8kOshIqhMgGOrhvIiiLecOa?=
 =?us-ascii?Q?kIQfMfPU2rgCiwkfnox7y+MIDR7CMCJciEtV1zC8y++NE7Do1X1dDlGvp0+f?=
 =?us-ascii?Q?NvAk+I8S+r4/T9KXxx7y5aSVXZKnurPHq/d6UeA6osagxzLudQe9dTEg3XLX?=
 =?us-ascii?Q?HHu0MLCG41vW0EODiuMy8rWPWtvAZ+NmIxEQzitlv0XfvatHb3uBwHjlti6q?=
 =?us-ascii?Q?9McOBpGQBI3f1ZmkhdIwgAWuQlsRALvUPd+HjAHIQTp545SowJNOLK1JMUoH?=
 =?us-ascii?Q?hPjMzd55W9M85QZuqjPOjZMY4gvzTiuaE6jR7sAcilOgj8o07dHeUVO+eq/T?=
 =?us-ascii?Q?oNCvJe1sBm4BtBysfg3xw73HdxEeUXazw1ztuiGEyziciBCQYLEknnKkpLw2?=
 =?us-ascii?Q?O9uifHyeG9C1txs7x3L4h1N5SK8OOhV638RMLL4IeSR5TqGFA2P0fWC7glBN?=
 =?us-ascii?Q?zVeExaHeYwrNzvRz1IcPGvG5O/ueWkRAAyj+lKLeukWBIRzPJsrogDp96R/X?=
 =?us-ascii?Q?GfGwy4ndz0EGINqZf3LKp787p+n94J7QRFmMnQAb//mXCFO40mIKXvrbmWKF?=
 =?us-ascii?Q?poDol5kivsYpIqApqvZxJSlpRrBMVDoaJ1GtVjPZHAMuQbAGmkY3DNeIIX+A?=
 =?us-ascii?Q?PtxgLMZtZQbv9BPS4gGbIQXfqcfRvB6QFeY6pLuJu+4LiVumFeaHmyFWBLtJ?=
 =?us-ascii?Q?RDVgmNBMg5JvZwtJVn7oaQjsuhLpg7Pv1cnqb0VN7nlYQVpzvzrNIGfXkwhY?=
 =?us-ascii?Q?xqReGdeeyblD8tCZvrPZHvx9Xq8DTUGQJYqO13/hgJ868e4q9/uxfgUoJcQF?=
 =?us-ascii?Q?w/emvQLg85Y4WXi3zkSy+Qklk3/J9AnSKvj1XtFQN3B3nyLgjX/E0T2Wi9aZ?=
 =?us-ascii?Q?Qe/CnhDNV9CScZGWK+PezkdTqVADfxSe3KnQcWu7fOuDhpf5QZgJtXwfXlaJ?=
 =?us-ascii?Q?f4QXvhuYQb1kwWGlLx0UlfXIn7uic4rgY03CKqUpu6pe2TwSQwUpRJVc3Rss?=
 =?us-ascii?Q?vwr7jRTmF8wfvz1xlBnxbKQ/PfRhZnR2Ot5n4fFyCqdmHyQ+QIV+WvdCUPbz?=
 =?us-ascii?Q?WWkWg5g4o+DYhwN24U8APIbb2Vj3y69mQpoRbzWRLwMWYj+AdGOESllPzrI9?=
 =?us-ascii?Q?G6KxoGO1H+W41Es1p3uVUcSb7BQ5exmDAFH9LpSoZf34Hcxuqp0EeYxl1ic2?=
 =?us-ascii?Q?9L+knqVRereyeGV3jC/g3w2o0H0ggTmqmd17PlK7sgCF4CGNVcdZweXazoZl?=
 =?us-ascii?Q?E6dcK/Q8VSA0Hk/EmnAW8Y2Ah6kGjKnbbapGL9LH39IN2Lew47O1xxGEuN29?=
 =?us-ascii?Q?yxon6PYKtBNK5Yw8f+MedyDqIOVXaQ9E1h0U0iscjslFKeVY/yDlrlOnUMPp?=
 =?us-ascii?Q?4hcxZSyCXxV3ebrugabPVCk95XZ80V0HgjakmH0Z7wUWc/bdpYcs0IqEFhbj?=
 =?us-ascii?Q?+4vq19eY3ZCOyySnRazc7oGdtlkAmKREcN5xdCyAJUeQFGCCY5wmKxVtvJZ2?=
 =?us-ascii?Q?YGgaXhY2Cm4n3eqbyY5hnf5Ur5EzlKgsoNwStmXO0vysxkW7+eOlspIrzika?=
 =?us-ascii?Q?hzQDgw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 883e9f39-a1a4-4b78-9056-08db2172b93f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 14:21:22.2714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /NmRKKfuCyb4VaTeYjIm+8ftwSCE11WQeaJasyogxx4Bpyfrm6U+m6OH+2WYzowVJmYU1Txso8MIFqDfgB1qn9a7BbUJjJQIWB0nWLVly/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4828
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:51:58PM -0300, Pedro Tammela wrote:
> Unbounded info messages in the pedit datapath can flood the printk ring buffer quite easily
> depending on the action created. As these messages are informational, usually printing
> some, not all, is enough to bring attention to the real issue.

Would this reasoning also apply to other TC actions?

> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  net/sched/act_pedit.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index e42cbfc369ff..b5a8fc19ee55 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -388,9 +388,8 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
>  		}
>  
>  		rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
> -		if (rc) {
> -			pr_info("tc action pedit bad header type specified (0x%x)\n",
> -				htype);
> +		if (unlikely(rc)) {

Do you really need unlikely() here (and no where else?)

> +			pr_info_ratelimited("tc action pedit bad header type specified (0x%x)\n", htype);
>  			goto bad;
>  		}
>  

...
