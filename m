Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB6F6EF7BC
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbjDZPY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241267AbjDZPY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:24:58 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF61630C1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:24:57 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-38e4c98e5ceso2455485b6e.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682522697; x=1685114697;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=baANX6Z31YvvReEiX4VLfYzCt8FOjjhAK7xN6ls5ZK4=;
        b=f5ba3yiXHk6eY+VFX61eZurFkoi4SRTnrM9llDbFwHh+czMHUW/md0eGS6iUCzqv6P
         MsnwBXGXdy+F4UH2Ir5ComhYDMcNnqR6Z2OViRvPoEx1bnvNtjLb6D/ndI/hO+qvG7bZ
         KNDy5jcoDdWvl6bTNEVVzDL90u9a4QSXHILqrvnLsg+qEULnVdihADp1ki1/kVPaTBLg
         zCxXzZKAgWbE2/IDMscxP6Oo9fh9EZ8BSoupPAvNf8TCOVHPjsxnIIRs2/c8gTwHEc1Y
         UmXnDU+QoK8OGw/6ETXc17O+oyL3KsFGC9iyt+2mchej5fVfh32NSmMJKFbvV8QqYIc3
         cTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682522697; x=1685114697;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=baANX6Z31YvvReEiX4VLfYzCt8FOjjhAK7xN6ls5ZK4=;
        b=Qlui5A+WlS687clhYpM04708ScjS1/WL8QDw45zbGegYibthqNAV9Bl6o8BQhDE5Ds
         JmCPv92Kg9Z1up6NcL8thDjVDiCTPSn6Ga0Kc1n/LhI+ONiXNoWXaUoDMjnMSiaDrFTX
         hJ+Zvmu4gbDeg9TO1ZZjV8VMFr3JSOt/+Fqw5gfFeet398LLcHqko+lTenRK22yKKswB
         q+dINnoblFD+YvW+rcrY+pgeXD4AdBVfW50+M0X6fdOc9+UoPQlRGYA/KOouRS5K6hcd
         jRE3bQVOmCiRbagFE3yzEuqj03S2e/SGOgdVbKw6AAPdYoEHYAIRVTyJKMmyeCkHvlI6
         v58g==
X-Gm-Message-State: AAQBX9flRDzVhSwAquInc10AGyYshk1laVMaLx6vrZ9B7VuvsN0BZHV6
        CKTb9wY7gEHJbw/6uWrwHt/iXA==
X-Google-Smtp-Source: AKy350a3Zr+FI6NLgQOeQPy4DZPtVtmqfpjHb7W338md8xJepLXpkX+q1n2LjVeKt3TW+uIgZllEPA==
X-Received: by 2002:a05:6808:301e:b0:387:3b8:f879 with SMTP id ay30-20020a056808301e00b0038703b8f879mr10757929oib.56.1682522697044;
        Wed, 26 Apr 2023 08:24:57 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:fb2a:b3eb:47f1:343a? ([2804:14d:5c5e:44fb:fb2a:b3eb:47f1:343a])
        by smtp.gmail.com with ESMTPSA id 13-20020aca0f0d000000b0038ea7f7328bsm4729708oip.46.2023.04.26.08.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 08:24:56 -0700 (PDT)
Message-ID: <160346a2-1158-2f07-b793-39abaac11f14@mojatatu.com>
Date:   Wed, 26 Apr 2023 12:24:52 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Content-Language: en-US
To:     Vlad Buslov <vladbu@nvidia.com>, Ivan Vecera <ivecera@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, paulb@nvidia.com,
        simon.horman@corigine.com
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-3-vladbu@nvidia.com>
 <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
 <87bkjasmtw.fsf@nvidia.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <87bkjasmtw.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/04/2023 11:46, Vlad Buslov wrote:
> On Wed 26 Apr 2023 at 11:22, Pedro Tammela <pctammela@mojatatu.com> wrote:
>> On 26/04/2023 09:14, Vlad Buslov wrote:
>>> When replacing a filter (i.e. 'fold' pointer is not NULL) the insertion of
>>> new filter to idr is postponed until later in code since handle is already
>>> provided by the user. However, the error handling code in fl_change()
>>> always assumes that the new filter had been inserted into idr. If error
>>> handler is reached when replacing existing filter it may remove it from idr
>>> therefore making it unreachable for delete or dump afterwards. Fix the
>>> issue by verifying that 'fold' argument wasn't provided by caller before
>>> calling idr_remove().
>>> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization
>>> earlier")
>>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>>> ---
>>>    net/sched/cls_flower.c | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>>> index 1844545bef37..a1c4ee2e0be2 100644
>>> --- a/net/sched/cls_flower.c
>>> +++ b/net/sched/cls_flower.c
>>> @@ -2339,7 +2339,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>>>    errout_mask:
>>>    	fl_mask_put(head, fnew->mask);
>>>    errout_idr:
>>> -	idr_remove(&head->handle_idr, fnew->handle);
>>> +	if (!fold)
>>> +		idr_remove(&head->handle_idr, fnew->handle);
>>>    	__fl_put(fnew);
>>>    errout_tb:
>>>    	kfree(tb);
>>
>> Actually this seems to be fixing the same issue:
>> https://lore.kernel.org/all/20230425140604.169881-1-ivecera@redhat.com/
> 
> Indeed it does, I've missed that patch. However, it seems there
> is an issue with Ivan's approach. Consider what would happen when
> fold!=NULL && in_ht==false and rhashtable_insert_fast() fails here:
> 
> 
>          if (fold) {
>                  /* Fold filter was deleted concurrently. Retry lookup. */
>                  if (fold->deleted) {
>                          err = -EAGAIN;
>                          goto errout_hw;
>                  }
> 
>                  fnew->handle = handle; // <-- fnew->handle is assigned
> 
>                  if (!in_ht) {
>                          struct rhashtable_params params =
>                                  fnew->mask->filter_ht_params;
> 
>                          err = rhashtable_insert_fast(&fnew->mask->ht,
>                                                       &fnew->ht_node,
>                                                       params);
>                          if (err)
>                                  goto errout_hw; /* <-- err is set, go to
>                                                       error handler here */
>                          in_ht = true;
>                  }
> 
>                  refcount_inc(&fnew->refcnt);
>                  rhashtable_remove_fast(&fold->mask->ht,
>                                         &fold->ht_node,
>                                         fold->mask->filter_ht_params);
>                  /* !!! we never get to insert fnew into idr here, if ht insertion fails */
>                  idr_replace(&head->handle_idr, fnew, fnew->handle);
>                  list_replace_rcu(&fold->list, &fnew->list);
>                  fold->deleted = true;
> 
>                  spin_unlock(&tp->lock);
> 
>                  fl_mask_put(head, fold->mask);
>                  if (!tc_skip_hw(fold->flags))
>                          fl_hw_destroy_filter(tp, fold, rtnl_held, NULL);
>                  tcf_unbind_filter(tp, &fold->res);
>                  /* Caller holds reference to fold, so refcnt is always > 0
>                   * after this.
>                   */
>                  refcount_dec(&fold->refcnt);
>                  __fl_put(fold);
>          }
> 
> ...
> 
>   errout_ht:
>           spin_lock(&tp->lock);
>   errout_hw:
>           fnew->deleted = true;
>           spin_unlock(&tp->lock);
>           if (!tc_skip_hw(fnew->flags))
>                   fl_hw_destroy_filter(tp, fnew, rtnl_held, NULL);
>           if (in_ht)
>                   rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
>                                          fnew->mask->filter_ht_params);
>   errout_mask:
>           fl_mask_put(head, fnew->mask);
>   errout_idr:
>           /* !!! On next line we remove handle that we don't actually own */
>           idr_remove(&head->handle_idr, fnew->handle);
>           __fl_put(fnew);
>   errout_tb:
>           kfree(tb);
>   errout_mask_alloc:
>           tcf_queue_work(&mask->rwork, fl_uninit_mask_free_work);
>   errout_fold:
>           if (fold)
>                   __fl_put(fold);
>           return err;
> 
> 
> Also, if I understood the idea behind Ivan's fix correctly, it relies on
> the fact that calling idr_remove() with handle==0 is a noop. I prefer my
> approach slightly better as it is more explicit IMO.
> 
> Thoughts?

I agree with your analysis
