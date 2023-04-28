Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC596F1667
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 13:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345685AbjD1LKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 07:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345445AbjD1LKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 07:10:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10hn2202.outbound.protection.outlook.com [52.100.157.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CCE2D45
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 04:10:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJseCjc/RiiT4L/W9hlW51K4/uJK13vc7qdy7wBnJqHB/wfb1pCUmMD1VYDDBYdqag9kkgBkmVtNxdRsGqdM1BkEnualU9teyv3A5msvYtZym7gjV0phviN2/AjepiNajHqQX89zYpB8wPJmefsso7Gg4BzWh7p381BO1UmwGBAiYBNQNa+RrkEkgzA1zy+pPgMcDLc34pfY8zjox8ABv7yIXgUx/Wb4lX5fCPRMn8NxMIFcaCtSiea3z10B5sgmkLcRJzO8qqzvM8AoiRVhTDyv4T5DiMgCD+viYL8jJnJGGUtoAxdpGSfxjKUfCeDOmKhjK1fmxtjLOkOlTO+w6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2WNPrQK1vJl2wml0m1Se8etLx745aHA/vHexD8t1htI=;
 b=l4p1f9QJT1RmIpzAzf0qabfZ922B8XzZLd7NgAKUijy8cerfmEmkBJwozB7vZ9A1DMPnu77rPAPNXemzS6E/GEoHSm8+Lk8wbEMp9n1eCugwDvKdjX9XUTvXsMsswTetUiipBg1vR+QUudvMmKD6BOZh7gYVxdTzqx9YvTpOKzeEeF0/ny4Qho8cA3p442fHMRoZnla8cj/a9XmtugsCIsWWtNhyTlzMH4oaFsGdfinlIR/zMadTNsECWJJf5qTPdMLxz/E2vEsFAV3NB94M7ZV6An8cZ2IsKRksOAQijfcKzcjNFf0NcgdRvtcFzuupanqlwRLvXdfSiXkUEEaQ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WNPrQK1vJl2wml0m1Se8etLx745aHA/vHexD8t1htI=;
 b=n4l6YcPIhN+EFlf7ehbv/m3mrzSnl8vssJml0hHlIjHHhdhsozCHGnJF5twYRDu9VaW9z8R0FGhdlLAu1S/Xu5kZSEcax8hjvwNwMMts7L1bl+EjFsLuUhf/klFzUjb8kbQLozqqh4XVddeB6HR49T/kXaZpHapDNu7yBZFF2wCFGkiVZTYQmW1iFK5HPs+90hk2CRSAOi7qw6pZYUj1cPeFSIBFUqXoXl6N6uwwJ8xxJwNqzbh7+MXoou+cxhclHTJAqr0c2b53YZmo2MaQE5lYpAAW04ctAEEkCoN3S5+mVfocbmPDcdQqKP+nUa4uBae7bPSxTIa/ttwrpZB6LA==
Received: from BN9PR03CA0954.namprd03.prod.outlook.com (2603:10b6:408:108::29)
 by BN9PR12MB5211.namprd12.prod.outlook.com (2603:10b6:408:11c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 11:10:13 +0000
Received: from BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::1a) by BN9PR03CA0954.outlook.office365.com
 (2603:10b6:408:108::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23 via Frontend
 Transport; Fri, 28 Apr 2023 11:10:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT078.mail.protection.outlook.com (10.13.176.251) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.24 via Frontend Transport; Fri, 28 Apr 2023 11:10:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 28 Apr 2023
 04:10:02 -0700
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 28 Apr
 2023 04:09:58 -0700
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-3-vladbu@nvidia.com>
 <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
 <87bkjasmtw.fsf@nvidia.com>
 <1bf81145-0996-e473-4053-09f410195984@redhat.com>
 <ZEtxvPaa/L3jHa2d@corigine.com>
 <bf6591ac-2526-6ca8-b60b-70536a31ae2a@redhat.com>
User-agent: mu4e 1.8.11; emacs 28.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Ivan Vecera <ivecera@redhat.com>
CC:     Simon Horman <simon.horman@corigine.com>,
        Pedro Tammela <pctammela@mojatatu.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <marcelo.leitner@gmail.com>, <paulb@nvidia.com>,
        "Paolo Abeni" <pabeni@redhat.com>
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Date:   Fri, 28 Apr 2023 14:03:19 +0300
In-Reply-To: <bf6591ac-2526-6ca8-b60b-70536a31ae2a@redhat.com>
Message-ID: <87354ks1ob.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT078:EE_|BN9PR12MB5211:EE_
X-MS-Office365-Filtering-Correlation-Id: bf414a48-f208-4e1d-ae32-08db47d92341
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HrfNKLmi0P0IKX1De395TbZfmXm/vhh+Xs2nQ3kvwkdO/aitEfa3lJcPQuC6k0Y8r1hlLTIKNBDGvXvVdzn7C3wu4cIc265axZsJkSNHvNeJjvdkIJqU8NHmlx5ZPhmjUV5w0F0dj/f3a7BUz+30tJf8fH9wQnizSyL4DkTiH1eY5MYUSNSTGB3uHmSQPl+NOtgiH7BNoJn3UBe2X69nE5IK8gRwbcd8ezlbTyfhowzY3PpluE4afipH6ofkU/p7tkqVSL4xcyztTMMJZQoiTd+Syut94eptx5P2+9vpKrHX20GOKceTyS+mdP4JN191KheIC0ilLaeTbVlzVYNWj97LsdjzgYTj0bsPzT6W9+x06IBeouTk9jM9ABuLhxpsLOglSaZsSG7IYDjQYpfn2ooRErgJvSCNbBK6DT57ysLqsuNJ+WPVUtUhNSedYURfZI4EVDX6OmszbBDTRxPbEyVy2bHqkhaKq8xnGz9SilLAoaks3tKlq1IDpdAVUF13WVkssqHL2b2fV+ik1EgEw7vq8wLCSiutlYDMqQBujQrHNnwml+i4zzT/Udo1Pxz2C2xnjETUecikO1CxtT3gBkLctUKhvXx6wEe9BAc84F+914qxZb7cN+aHj5xTj1cKBcYouBlrHgqX0OB2lWe/l+geshabZY8OsynW6oX/6xBXG4KFR4zjVrJhfxbFefD5ZdU+QxzJn8ZNVqd+P3TaS9iHTrnmZNvnVxHcMc9MNuiekGrM3qUx6C0whGZi+eyx0goO860P5Wow+3weMXObtri/SnPqQAWuhYuGZ5oAbjUvP+PQfcIBKUYylb3wlDVoDsxkCpaYiQatfXUCdJNYvM9TKgESuAFO0/6nClevapQ=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199021)(5400799015)(46966006)(36840700001)(40470700004)(478600001)(7696005)(36860700001)(70206006)(70586007)(2616005)(40460700003)(6916009)(4326008)(356005)(82310400005)(26005)(53546011)(8676002)(8936002)(41300700001)(16526019)(7416002)(36756003)(186003)(7636003)(86362001)(5660300002)(40480700001)(82740400003)(54906003)(316002)(966005)(6666004)(34020700004)(336012)(426003)(83380400001)(2906002)(47076005)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 11:10:12.6008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf414a48-f208-4e1d-ae32-08db47d92341
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5211
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 28 Apr 2023 at 10:20, Ivan Vecera <ivecera@redhat.com> wrote:
> On 28. 04. 23 9:11, Simon Horman wrote:
>> On Wed, Apr 26, 2023 at 05:39:09PM +0200, Ivan Vecera wrote:
>>>
>>>
>>> On 26. 04. 23 16:46, Vlad Buslov wrote:
>>>> On Wed 26 Apr 2023 at 11:22, Pedro Tammela <pctammela@mojatatu.com> wrote:
>>>>> On 26/04/2023 09:14, Vlad Buslov wrote:
>>>>>> When replacing a filter (i.e. 'fold' pointer is not NULL) the insertion of
>>>>>> new filter to idr is postponed until later in code since handle is already
>>>>>> provided by the user. However, the error handling code in fl_change()
>>>>>> always assumes that the new filter had been inserted into idr. If error
>>>>>> handler is reached when replacing existing filter it may remove it from idr
>>>>>> therefore making it unreachable for delete or dump afterwards. Fix the
>>>>>> issue by verifying that 'fold' argument wasn't provided by caller before
>>>>>> calling idr_remove().
>>>>>> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization
>>>>>> earlier")
>>>>>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>>>>>> ---
>>>>>>     net/sched/cls_flower.c | 3 ++-
>>>>>>     1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>>>>>> index 1844545bef37..a1c4ee2e0be2 100644
>>>>>> --- a/net/sched/cls_flower.c
>>>>>> +++ b/net/sched/cls_flower.c
>>>>>> @@ -2339,7 +2339,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>>>>>>     errout_mask:
>>>>>>     	fl_mask_put(head, fnew->mask);
>>>>>>     errout_idr:
>>>>>> -	idr_remove(&head->handle_idr, fnew->handle);
>>>>>> +	if (!fold)
>>>>>> +		idr_remove(&head->handle_idr, fnew->handle);
>>>>>>     	__fl_put(fnew);
>>>>>>     errout_tb:
>>>>>>     	kfree(tb);
>>>>>
>>>>> Actually this seems to be fixing the same issue:
>>>>> https://lore.kernel.org/all/20230425140604.169881-1-ivecera@redhat.com/
>>>>
>>>> Indeed it does, I've missed that patch. However, it seems there
>>>> is an issue with Ivan's approach. Consider what would happen when
>>>> fold!=NULL && in_ht==false and rhashtable_insert_fast() fails here:
>>>>
>>>>
>>>>           if (fold) {
>>>>                   /* Fold filter was deleted concurrently. Retry lookup. */
>>>>                   if (fold->deleted) {
>>>>                           err = -EAGAIN;
>>>>                           goto errout_hw;
>>>>                   }
>>>>
>>>>                   fnew->handle = handle; // <-- fnew->handle is assigned
>>>>
>>>>                   if (!in_ht) {
>>>>                           struct rhashtable_params params =
>>>>                                   fnew->mask->filter_ht_params;
>>>>
>>>>                           err = rhashtable_insert_fast(&fnew->mask->ht,
>>>>                                                        &fnew->ht_node,
>>>>                                                        params);
>>>>                           if (err)
>>>>                                   goto errout_hw; /* <-- err is set, go to
>>>>                                                        error handler here */
>>>>                           in_ht = true;
>>>>                   }
>>>>
>>>>                   refcount_inc(&fnew->refcnt);
>>>>                   rhashtable_remove_fast(&fold->mask->ht,
>>>>                                          &fold->ht_node,
>>>>                                          fold->mask->filter_ht_params);
>>>>                   /* !!! we never get to insert fnew into idr here, if ht insertion fails */
>>>>                   idr_replace(&head->handle_idr, fnew, fnew->handle);
>>>>                   list_replace_rcu(&fold->list, &fnew->list);
>>>>                   fold->deleted = true;
>>>>
>>>>                   spin_unlock(&tp->lock);
>>>>
>>>>                   fl_mask_put(head, fold->mask);
>>>>                   if (!tc_skip_hw(fold->flags))
>>>>                           fl_hw_destroy_filter(tp, fold, rtnl_held, NULL);
>>>>                   tcf_unbind_filter(tp, &fold->res);
>>>>                   /* Caller holds reference to fold, so refcnt is always > 0
>>>>                    * after this.
>>>>                    */
>>>>                   refcount_dec(&fold->refcnt);
>>>>                   __fl_put(fold);
>>>>           }
>>>>
>>>> ...
>>>>
>>>>    errout_ht:
>>>>            spin_lock(&tp->lock);
>>>>    errout_hw:
>>>>            fnew->deleted = true;
>>>>            spin_unlock(&tp->lock);
>>>>            if (!tc_skip_hw(fnew->flags))
>>>>                    fl_hw_destroy_filter(tp, fnew, rtnl_held, NULL);
>>>>            if (in_ht)
>>>>                    rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
>>>>                                           fnew->mask->filter_ht_params);
>>>>    errout_mask:
>>>>            fl_mask_put(head, fnew->mask);
>>>>    errout_idr:
>>>>            /* !!! On next line we remove handle that we don't actually own */
>>>>            idr_remove(&head->handle_idr, fnew->handle);
>>>>            __fl_put(fnew);
>>>>    errout_tb:
>>>>            kfree(tb);
>>>>    errout_mask_alloc:
>>>>            tcf_queue_work(&mask->rwork, fl_uninit_mask_free_work);
>>>>    errout_fold:
>>>>            if (fold)
>>>>                    __fl_put(fold);
>>>>            return err;
>>>>
>>>>
>>>> Also, if I understood the idea behind Ivan's fix correctly, it relies on
>>>> the fact that calling idr_remove() with handle==0 is a noop. I prefer my
>>>> approach slightly better as it is more explicit IMO.
>>>>
>>>> Thoughts?
>>>
>>> Yes, your approach is better...
>>>
>>> Acked-by: Ivan Vecera <ivecera@redhat.com>
>> In the meantime it seems that Ivan's patch has been accepted into net.
>> - [net] net/sched: flower: Fix wrong handle assignment during filter change
>>    https://git.kernel.org/netdev/net/c/32eff6bacec2
>> Is some adjustment to this patch required to take that into account?
>
> I think something like this is necessary to cover Vlad's findings:
>
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 6ab6aadc07b8da..ce937baefcf00e 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -2279,8 +2279,6 @@ static int fl_change(struct net *net, struct sk_buff
> *in_skb,
>                         goto errout_hw;
>                 }
>
> -               fnew->handle = handle;
> -
>                 if (!in_ht) {
>                         struct rhashtable_params params =
>                                 fnew->mask->filter_ht_params;
> @@ -2297,6 +2295,7 @@ static int fl_change(struct net *net, struct sk_buff
> *in_skb,
>                 rhashtable_remove_fast(&fold->mask->ht,
>                                        &fold->ht_node,
>                                        fold->mask->filter_ht_params);
> +               fnew->handle = handle;
>                 idr_replace(&head->handle_idr, fnew, fnew->handle);
>                 list_replace_rcu(&fold->list, &fnew->list);
>                 fold->deleted = true;
>
> Just move fnew->handle assignment immediately prior idr_replace().
>
> Thoughts?

Note that with these changes (both accepted patch and preceding diff)
you are exposing filter to dapapath access (datapath looks up filter via
hash table, not idr) with its handle set to 0 initially and then resent
while already accessible. After taking a quick look at Paul's
miss-to-action code it seems that handle value used by datapath is taken
from struct tcf_exts_miss_cookie_node not from filter directly, so such
approach likely doesn't break anything existing, but I might have missed
something.

