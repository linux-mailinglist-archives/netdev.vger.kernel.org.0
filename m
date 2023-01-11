Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9108B666432
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 20:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbjAKT5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 14:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbjAKT5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 14:57:09 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3249E5F7C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 11:57:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrOXrO2rLn7QQq3K8w+RJ0+JlylpR6GQcAzJwyT5DKHLPsFFIknKel+vy5JIW/HQ/k6iVUV80tlo5CweZ9Ulb34tE9Xgg0JAya8/P+6EJiD0QODtpRxiZ1pt4ChJD9zeUYKBDfteas0b6OfxfIm/bc/mSxN1BAA9QvolZlyd1BMdxFxsmnCG/HMLY6RilokMH13VvJPfZBd1HcPs5nP3J/5hGQSGdSbfNLYzsrX7TJf9g7oNH+WY/Tq6oLNS7RZF0fKl63p8C1yD+hCQUIPZyr6Dgrm3SCkDihWHWvaDkfx5o3IieJ3JcLlccu/bvBPzHSQzBNgqFBVJm5tixgsYtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJVxkwDkh1rYiRwZ8/mbagHkBO9CNrwCo4YBHEc1F88=;
 b=c5E//tbqtlonqNp9MGFC7if8P6mctHvCL7tmcGuD0tB2T2WCp4Hju/+9pRhxiA9DlHepk5H+GMaeEN/rk9gZ5DlrNvPJXVHGE7cSqhS3StskJE4Y8DkF2K7LZY743nHlMsO6k3blh6QP6/ppJrdSuQXpEW2gdjwenCjg5MS+zuMYlH8pWLT8yFoJX6BiqFub4WxqiyOt39ZDfSziKPTenUiAGx8hSo1hPVOwFJVN8tnOyw/z2tecIRkVO2wRGqg5kspC/vGtHXhdQjeua6bIYc8s/b11UIabELIDEkKBeypUMCuun+Vkxlf+c5HLJmZ1Mn2AmttbKtD2lCduJ0dI1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJVxkwDkh1rYiRwZ8/mbagHkBO9CNrwCo4YBHEc1F88=;
 b=FGwFooiErlGnrh9wfAAn70d5/UA6gv6FaRM5zj6cm6JTnthvKExA8Z7815rKIZxhulDK9Jkv9KEdDPLZdL9aUAYUPhA8QnNZYS18/s27mgCQWFkYUYEEu76pMyAUrY0DDWUyZ3j43/Rgy+jR4VOiUTUYIZeJwbf2ZBFoeHCe3nPvfJBZGz8CVjWpT7pVDqdgyMm9EcMJ/yQWATvq3Qh7fXsTZPcHQORZBH7aqlTs5ZljNEKvRhRvJtwRd8oGEN0sirUr/NNmCHGps9cLqNe+lrP2mVaAcd2YUXYrJvcU9pEaVkFjnWLpq0zsH32MfcdOR2lEOq0vi/qcF6cSUY0XYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CH2PR12MB4294.namprd12.prod.outlook.com (2603:10b6:610:a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 19:57:06 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 19:57:05 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: Re: [PATCH net] sch_htb: Avoid grafting on
 htb_destroy_class_offload when destroying htb
References: <20230110202003.25452-1-rrameshbabu@nvidia.com>
        <Y759ojjda4lh/vQk@nanopsycho>
Date:   Wed, 11 Jan 2023 11:56:52 -0800
In-Reply-To: <Y759ojjda4lh/vQk@nanopsycho> (Jiri Pirko's message of "Wed, 11
        Jan 2023 10:13:06 +0100")
Message-ID: <875ydcrgjf.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::12) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CH2PR12MB4294:EE_
X-MS-Office365-Filtering-Correlation-Id: e993aa11-a60c-4d02-9747-08daf40e03c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Al7rH2RzFsnO0Jypn9r21l/mfXeWLXYT3EpSJ0aZ+M44123Kkq7dADJa3YcYoPlz1hPRXp7eFf3jSJcfh38TEFnftcdjO0jFaxTZZPcgKrkR2SSTVzrKImsR2R/ZrviltlzjkktF0b2LsamVC9En53JK4xTVIH/8Mob9vny+O5F6yJN3xve8IpqHtXlx2WfYvJqUqj5hD7nqUAhT1z9pnYZ9cssMfnTNnmP//7z7chhwazu57ZGJPQjsqRqIJSIX2Kxe4uWx3glkXyS32lwzxM3LmazSDWSkA9KQ1kzBlS20uoNJ72Z8rPA7cXJBsOfcP+671hckSe8dm3Ll2NafTvzFHx1aKS4nSJ5OmhUalpatO2dQ09MfB6vwiL/rwcQhkIYdra75ba9kT0QE0oKLgnpao6Es/2QPgi/xENWX/gHd3UiJyL9UidpwGeV4CrhApm89g5NqzgSifK8XMsy7XGAIlHB8yV8M0BWdFgWjM88sMpI1aj8rFsWissO/Ol/lwlJWITnG3GasWXnwDg5JRZjh5esi3nRXdDdUAXuK3rcO60VLw5A9Uz7DSBtvhqGm24HD5NQZHpfeA6f3p+9zd6ahZxZavbMfWO3pJ6FbMcLLRSArzUHb4KrzSBaFfi7eaB2XA/0OU9bPmkHQmGLIjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199015)(8936002)(2906002)(5660300002)(41300700001)(66556008)(4326008)(316002)(8676002)(6916009)(66476007)(66946007)(54906003)(6512007)(2616005)(38100700002)(86362001)(186003)(83380400001)(36756003)(6506007)(6666004)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9R7M1CCA+ssSdw1wj/c1gHe6+vWVRYgw61DLyZjZyaHWP4zLTk6fCMxs+kGp?=
 =?us-ascii?Q?0/doirJCKJUx65s0CyPYjqOj03QLMUtHdRyT/g7Wo/4UXcYXJP7SQrusuaj+?=
 =?us-ascii?Q?SkkiqOUKbIvQC37cko7Uftm0rMo9H33/NrOq1RrpyhqXLmyAmo4R7wtiwX1z?=
 =?us-ascii?Q?QbEEeNiTl/wPDAIilRFJx4ggnwdi6ZCvz/+Bbd4Njs0rMZC6L6VMZBjrh9V8?=
 =?us-ascii?Q?0PbeRMPo1dbgFwkNa07qFRia31LIVHGu4plHGNuongQbeptQfV96imrydsQK?=
 =?us-ascii?Q?+t1TuEkrQ0GxpIYfS8Kk0fC2H6lWDBemphF9p4epZ45BVlrPtwbzyElcLU60?=
 =?us-ascii?Q?0o6HccxTNukp8uRg4W+6K+e8g0WZ8RUC2LOc8/QEyPpRxbd5EX/6ZCWJcB6P?=
 =?us-ascii?Q?BXXchiGaNIXmx6m7qJIbqVx1Mk6752YVeX0fdpGhKuziEpaf7NfRiijltkP6?=
 =?us-ascii?Q?HlUNWgHXlwFsE4wn1X4S/7RLTS8HgPFJE0WwkF8khMMhisgc0TaP01HT8t96?=
 =?us-ascii?Q?2gql5Bgoboh82gRksSHj/xEpGSmeRKpU1wcWEfWM1IVWn5U0/1YxH3XzvVP7?=
 =?us-ascii?Q?cdMsbmstxplpd6uvlJ6l14omsYSza2Vf7HBLxun9KlYiPhvcIkc0dgycdr8m?=
 =?us-ascii?Q?vpCPA3xUg6g6Hrp4CSgxM0yutcAn7/sf1ZipG0Bl/OVzJGmFTP5LEEj3DXoP?=
 =?us-ascii?Q?CEhpbJCNj6WdGEG0rSk60G9bPLTzjPAqV6vWN2cFIh1lYXtEnSVopXqGZYyT?=
 =?us-ascii?Q?gjbPwZ1ATzEHHiMRLaCTPEBi4gVB89sHx0UM2AmYGKqaKNSgSsvo2+rBz3T0?=
 =?us-ascii?Q?gwt9LTvVljfvM2frm13UIH1tEVAR5hDrVLm64ldWoFkM6Cai8Y5RixC3oSIY?=
 =?us-ascii?Q?U6zPx/XGbYoPrAbgDh7WPur4seabaUk2OleupPax/kYviNh7EuOty/fLhxzR?=
 =?us-ascii?Q?yr1CRiedwzJeuBMPFnXmh6IBPo1Y26GCB0L12kCBEjJPrs1DRM4hd/uo0BHM?=
 =?us-ascii?Q?4HWvvdluQOrcpnqWLcmNPV5pdiG5tlc3M8D4ML48KxgRmppF6kSB+iIoDprb?=
 =?us-ascii?Q?sSYlzd4vGiHuTvSEKZvj1s+5p2KRyUxVGGBgDlsSocf6gXmLHF1a8LuirogT?=
 =?us-ascii?Q?IwIhOa+67c5kgAnrw85XLjAbuiHemHvBW+GzWZh/0TQWyyuifr8WXy8/4ObL?=
 =?us-ascii?Q?4gSrnzmJ1Q9ph4gOgAhLnxQzkU/IS5ah0rLj7vUffZ9UFvO/5t5YvWE0JgML?=
 =?us-ascii?Q?HuurvmiEv3wwBw62SJwqAz2j0QDiMiP5TUKBq/mf91AEemDth9B808tjz3SH?=
 =?us-ascii?Q?e+fuMYZqOhHz/W6RzcH4GSQ1WhL3iBywm+aHqpaNsPRY+BI23j3v0MFIX1nD?=
 =?us-ascii?Q?TEIMM44kz1EKuq5zaUI4DNX+FhdnNfyPuIoH8TASa2TJ44Jlf43WXxAoN5AA?=
 =?us-ascii?Q?wa+M5kD6m/mBRgrs08MRpOaNRDk96SHAFlI4sI3nke2/ugJmLaYXF6kRIyuM?=
 =?us-ascii?Q?gedx5av2i5GMZ6STnBC7o5L/We0vBv3jfO3X/tDlEBpae5Tqpf7t6TyV0I9l?=
 =?us-ascii?Q?9Eocg4IjZHAp29nIsAeWCOxH1jOz4gVslF5Uwjq/mzZ1mtHPjZy6MURpEeaR?=
 =?us-ascii?Q?GRGHagh1NsTga/A8u1scQkJB6pIVmmqh3oMgPL2AaAYlwdqgqfBMELwbS0zz?=
 =?us-ascii?Q?u2lzkg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e993aa11-a60c-4d02-9747-08daf40e03c7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 19:57:05.7884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mzvVq2yfH9z/FpnTNcm6aTZMKDQOotIMw5tePbpHuzi8iloLxa/AX9dEht1Rd9qNPdpB/enZUZ8/dK7UUnzDUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4294
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Pirko <jiri@resnulli.us> writes:

> Tue, Jan 10, 2023 at 09:20:04PM CET, rrameshbabu@nvidia.com wrote:
>>Peek at old qdisc and graft only when deleting leaf class in the htb. When
>>destroying the htb, the caller may already have grafted a new qdisc that is
>>not part of the htb structure being destroyed. htb_destroy_class_offload
>>should not peek at the qdisc of the netdev queue since that will either be
>
> You are not telling the codebase what to do. Do it in order to make it
> obvious what the patch is doing. That makes the patch description easier
> to understand.
>

I do think this description does describe what the patch is trying to
logically achieve rather than what the codebase itself is doing. The
goal of this patch is to correct htb_destroy_class_offload, so that it
will not attempt to graft a qdisc that does not belong to the htb (the
new qdisc), when destroying the htb entirely (the htb is destroyed when
replaced with another qdisc or explicitly destroyed). When deleting a
leaf, it makes sense to graft the leaf back if it failed to be deleted
by the device.

>
>>the new qdisc in the case of replacing the htb or simply a noop_qdisc is
>>the case of destroying the htb without a replacement qdisc.
>
>
> Looks to me like 2 fixes, shouldn't this be 2 patches instead?

This change is one logical fix in terms of refactoring the code to only
peek and graft the old qdisc when deleting a leaf of the htb. It
resolves issues in two use cases though.

  tc qdisc delete dev eth2 root handle 1: htb default 1 # deleting the htb

  tc qdisc replace dev eth2 root pfifo # replace htb with another qdisc

>
>
>>
>>Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
>>Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
>>Cc: Eric Dumazet <edumazet@google.com>
>>Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
>>---
>> net/sched/sch_htb.c | 23 +++++++++++++----------
>> 1 file changed, 13 insertions(+), 10 deletions(-)
>>
>>diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>>index 2238edece1a4..360ce8616fd2 100644
>>--- a/net/sched/sch_htb.c
>>+++ b/net/sched/sch_htb.c
>>@@ -1557,14 +1557,13 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
>> 
>> 	WARN_ON(!q);
>> 	dev_queue = htb_offload_get_queue(cl);
>>-	old = htb_graft_helper(dev_queue, NULL);
>>-	if (destroying)
>>-		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
>>-		 * all queues.
>>+	if (!destroying) {
>>+		old = htb_graft_helper(dev_queue, NULL);
>>+		/* Last qdisc grafted should be the same as cl->leaf.q when
>>+		 * calling htb_destroy
>> 		 */
>>-		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
>>-	else
>> 		WARN_ON(old != q);
>>+	}
>> 
>> 	if (cl->parent) {
>> 		_bstats_update(&cl->parent->bstats_bias,
>>@@ -1581,10 +1580,14 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
>> 	};
>> 	err = htb_offload(qdisc_dev(sch), &offload_opt);
>> 
>>-	if (!err || destroying)
>>-		qdisc_put(old);
>>-	else
>>-		htb_graft_helper(dev_queue, old);
>>+	/* htb_offload related errors when destroying cannot be handled */
>>+	WARN_ON(err && destroying);
>>+	if (!destroying) {
>>+		if (!err)
>>+			qdisc_put(old);
>>+		else
>>+			htb_graft_helper(dev_queue, old);
>>+	}
>> 
>> 	if (last_child)
>> 		return err;
>>-- 
>>2.36.2
>>
