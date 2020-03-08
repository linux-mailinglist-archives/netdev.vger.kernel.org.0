Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68EDD17D62B
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 21:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgCHUmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 16:42:22 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37867 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgCHUmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 16:42:21 -0400
Received: by mail-pg1-f196.google.com with SMTP id z12so3754593pgl.4
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 13:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=i2pDcfq9QR5AaLHol8eXE7kAA5gs/LuiZpcTkmn9QCk=;
        b=QX/Z3t7tZx73iEVM65UG98MKvtTVB5p6+HCx64UCTs8jFDqQ1hJy89t/nC4WJ17Qpl
         mA9RXzJnYjdxNXwJ+Lq89Jpw145L6eyBZ6RuRCnPS9BWkPx4COWcLrrW0wOsP1AeFCcF
         87+tAH6ZT7ribq1DHZZBx60sLOBTcnzkwdhzFAf6y2W6N4VN1ICTXB6YpFpYF2Qk5fhl
         jx5g5b1YO5gsaA3mp2jtk8zjOVTIEPxowGMKbgYOMzMgyxdtWFOOzHd/oQfNhTQjZB8R
         W6saVmC/pnkvzapMzzrlejaTAKyZ/aOOqpu0ZCVmDkY/L22PSt/PbCXKqE2S68TKznXD
         NbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i2pDcfq9QR5AaLHol8eXE7kAA5gs/LuiZpcTkmn9QCk=;
        b=ZPNncLNGts38zig93QeZRCCSGzc6KufXgypimbz2OURvo7n2frMaEb49h2QrMenxxW
         vmHQT6n9SG4gMVcO7d9RX2Lr0MT90gcVzcELygeLumnaSvcJCZrus4Bg3NiezqJUFdoI
         X96gmkMPgGldmhzCVlTqK4IHHG9n/aXMxcwJk77IEtjHSCYViZt9Gm8meOsTVKwNX/Nj
         3OpZtnGMFrh/gtw+dyU2WIjMzs8336swG+633HO9D6R1UUoScah8SuL610NKIqgbvwFM
         Nzvssdu9EDpf5XkQ0sJQFmUP3+dYHMvcG1AyL1vsWsSznvZIbJNHVmNb7hNOOkEaJJY2
         udFQ==
X-Gm-Message-State: ANhLgQ14tNdh/+ocSdSC7837HiaS5c+nKfcB+MqQpE2puYA1xtFMafJE
        tW0mtZpYcFIunfqMFq1BoGXZSYlo
X-Google-Smtp-Source: ADFU+vsEIoRyXUqwYULBqOYohaOH5FVkaT/+CpDIu+epncoEYaS3w4m6I07rIemlpZEm9NHDL5nqFA==
X-Received: by 2002:a63:f757:: with SMTP id f23mr13328958pgk.223.1583700138553;
        Sun, 08 Mar 2020 13:42:18 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q21sm44200441pff.105.2020.03.08.13.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2020 13:42:17 -0700 (PDT)
Subject: Re: [PATCH net-next v6 1/3] net/sched: act_ct: Create nf flow table
 per zone
To:     Paul Blakey <paulb@mellanox.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583251072-10396-1-git-send-email-paulb@mellanox.com>
 <1583251072-10396-2-git-send-email-paulb@mellanox.com>
 <c0c033e8-63ed-a33c-2e1b-afbedcb476ea@gmail.com>
 <57a22ef3-63de-2b51-61cb-5ff00d2a5b81@gmail.com>
 <334b4af2-1ac0-d28b-f1a5-b9b604a9ba80@mellanox.com>
 <69fa856f-4aaf-4f54-7324-009cdbf26e38@mellanox.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5ab39d86-7ed3-b9b8-e6c2-2d96a3bd1f83@gmail.com>
Date:   Sun, 8 Mar 2020 13:42:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <69fa856f-4aaf-4f54-7324-009cdbf26e38@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/20 12:15 AM, Paul Blakey wrote:
> On 3/8/2020 10:11 AM, Paul Blakey wrote:
> 
>> iirc I did the spin lock bh because we can be called from queue work rcu handler , so I wanted to disable soft irq.
>>
>> I got a possible deadlock splat for that.
> 
> Here I meant this call rcu:
> 
> static void tcf_ct_cleanup(struct tc_action *a)
> {
>> -------struct tcf_ct_params *params;
>> -------struct tcf_ct *c = to_ct(a);
> 
>> -------params = rcu_dereference_protected(c->params, 1);
>> -------if (params)
>> ------->-------call_rcu(&params->rcu, tcf_ct_params_free);
> }
> 

Yes, understood, but to solve this problem we had many other choices,
and still keeping GFP_KERNEL allocations and a mutex for control path.

Have you read my patch ?

By not even trying to get a spinlock in tcf_ct_flow_table_put(),
and instead use a refcount for ->ref, we avoid having this issue in the first place.

static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
{
        struct tcf_ct_flow_table *ct_ft = params->ct_ft;

        if (refcount_dec_and_test(&params->ct_ft->ref)) {
                rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
                INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
                queue_rcu_work(act_ct_wq, &ct_ft->rwork);
        }
}

> static void tcf_ct_params_free(struct rcu_head *head)
> {
>> -------struct tcf_ct_params *params = container_of(head,
>> ------->------->------->------->------->-------    struct tcf_ct_params, rcu);
> 
>> -------tcf_ct_flow_table_put(params);
> 
> ...
> 
> 
>>
>>
>> On 3/7/2020 10:53 PM, Eric Dumazet wrote:
>>
>>> On 3/7/20 12:12 PM, Eric Dumazet wrote:
>>>> On 3/3/20 7:57 AM, Paul Blakey wrote:
>>>>> Use the NF flow tables infrastructure for CT offload.
>>>>>
>>>>> Create a nf flow table per zone.
>>>>>
>>>>> Next patches will add FT entries to this table, and do
>>>>> the software offload.
>>>>>
>>>>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>>>>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>>>>> ---
>>>>>   v4->v5:
>>>>>     Added reviewed by Jiri, thanks!
>>>>>   v3->v4:
>>>>>     Alloc GFP_ATOMIC
>>>>>   v2->v3:
>>>>>     Ditch re-locking to alloc, and use atomic allocation
>>>>>   v1->v2:
>>>>>     Use spin_lock_bh instead of spin_lock, and unlock for alloc (as it can sleep)
>>>>>     Free ft on last tc act instance instead of last instance + last offloaded tuple,
>>>>>     this removes cleanup cb and netfilter patches, and is simpler
>>>>>     Removed accidental mlx5/core/en_tc.c change
>>>>>     Removed reviewed by Jiri - patch changed
>>>>>
>>>>> +	err = nf_flow_table_init(&ct_ft->nf_ft);
>>>> This call is going to allocate a rhashtable (GFP_KERNEL allocations that might sleep)
>>>>
>>>> Since you still hold zones_lock spinlock, a splat should occur.
>>>>
>>>> "BUG: sleeping function called from invalid context in  ..."
>>>>
>>>> DEBUG_ATOMIC_SLEEP=y is your friend.
>>>>
>>>> And it is always a good thing to make sure a patch does not trigger a lockdep splat
>>>>
>>>> CONFIG_PROVE_LOCKING=y
>>> Also abusing a spinlock and GFP_ATOMIC allocations in control path is highly discouraged.
>>>
>>> I can not test the following fix, any objections before I submit this officially ?
>>>
>>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>>> index 23eba61f0f819212a3522c3c63b938d0b8d997e2..3d9e678d7d5336f1746035745b091bea0dcb5fdd 100644
>>> --- a/net/sched/act_ct.c
>>> +++ b/net/sched/act_ct.c
>>> @@ -35,15 +35,15 @@
>>>  
>>>  static struct workqueue_struct *act_ct_wq;
>>>  static struct rhashtable zones_ht;
>>> -static DEFINE_SPINLOCK(zones_lock);
>>> +static DEFINE_MUTEX(zones_mutex);
>>>  
>>>  struct tcf_ct_flow_table {
>>>         struct rhash_head node; /* In zones tables */
>>>  
>>>         struct rcu_work rwork;
>>>         struct nf_flowtable nf_ft;
>>> +       refcount_t ref;
>>>         u16 zone;
>>> -       u32 ref;
>>>  
>>>         bool dying;
>>>  };
>>> @@ -64,14 +64,15 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>>>         struct tcf_ct_flow_table *ct_ft;
>>>         int err = -ENOMEM;
>>>  
>>> -       spin_lock_bh(&zones_lock);
>>> +       mutex_lock(&zones_mutex);
>>>         ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
>>> -       if (ct_ft)
>>> -               goto take_ref;
>>> +       if (ct_ft && refcount_inc_not_zero(&ct_ft->ref))
>>> +               goto out_unlock;
>>>  
>>> -       ct_ft = kzalloc(sizeof(*ct_ft), GFP_ATOMIC);
>>> +       ct_ft = kzalloc(sizeof(*ct_ft), GFP_KERNEL);
>>>         if (!ct_ft)
>>>                 goto err_alloc;
>>> +       refcount_set(&ct_ft->ref, 1);
>>>  
>>>         ct_ft->zone = params->zone;
>>>         err = rhashtable_insert_fast(&zones_ht, &ct_ft->node, zones_params);
>>> @@ -84,10 +85,9 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>>>                 goto err_init;
>>>  
>>>         __module_get(THIS_MODULE);
>>> -take_ref:
>>> +out_unlock:
>>>         params->ct_ft = ct_ft;
>>> -       ct_ft->ref++;
>>> -       spin_unlock_bh(&zones_lock);
>>> +       mutex_unlock(&zones_mutex);
>>>  
>>>         return 0;
>>>  
>>> @@ -96,7 +96,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>>>  err_insert:
>>>         kfree(ct_ft);
>>>  err_alloc:
>>> -       spin_unlock_bh(&zones_lock);
>>> +       mutex_unlock(&zones_mutex);
>>>         return err;
>>>  }
>>>  
>>> @@ -116,13 +116,11 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
>>>  {
>>>         struct tcf_ct_flow_table *ct_ft = params->ct_ft;
>>>  
>>> -       spin_lock_bh(&zones_lock);
>>> -       if (--params->ct_ft->ref == 0) {
>>> +       if (refcount_dec_and_test(&params->ct_ft->ref)) {
>>>                 rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
>>>                 INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
>>>                 queue_rcu_work(act_ct_wq, &ct_ft->rwork);
>>>         }
>>> -       spin_unlock_bh(&zones_lock);
>>>  }
>>>  
>>>  static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
>>>
