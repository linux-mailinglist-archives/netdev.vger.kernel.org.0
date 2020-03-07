Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6361717D019
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 21:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCGUxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 15:53:15 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51925 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgCGUxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 15:53:15 -0500
Received: by mail-pj1-f65.google.com with SMTP id l8so2589165pjy.1
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 12:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tLwAzojyIe4i5z9kp91m1+Xby1voA0dDX+nfxXBKUyY=;
        b=VXZpMOwpzjDtikubwpWay/ZGEKMtRS2ahLZU5gU6MRLNhxZrg78HZXMLQ6q3fJ2HS1
         pSgmL+Fu4NrpZNjwbv3e4cRnhyGGQruA2+2CMuIrRhV+G67uF96lPJzco2gOifXgrETE
         jMFGmPGBXGpaGosnaE/Q/UKOBZUYZTr1qdKLSgVGsIQ7Eh7OhkYq+C29T93KALVqPkCf
         UuJjq5AKhFjRu1f1o2y2bniXvTb6ilUq8Tvsq9+mzAnmauZ9sOIkOeL1gF+ZsAdsXjfa
         yYXdDUoNEV755CL8dnqrU0Q5Ov8P87nbz7EjXns6mlUecuf41XpTI7Hf51huxgjU/yPZ
         plLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tLwAzojyIe4i5z9kp91m1+Xby1voA0dDX+nfxXBKUyY=;
        b=LUV7/Ss1eBYIYwqV+RMqckTzAxTUhrB17mhJSb3e4Kbr8SO/I6dHMel4t/7Qqayqjv
         sKytwfvtwyHz7N2C16P/KCw0W+uHvhhnb0yJxuB+w/jPY6wbqPppcoutx9GwoVfcEdrI
         zJmjAXaz5VSXrO/fEwfW3APdj0Bf2f0PLM5Nd1YJC75qlk41X3o4aGWApMEL1tmgQB1M
         funCmVg0hfMH+Mgwy+Ut3OlEuMaj5wefIQsiTGj1rIRqZD71USP4PDrAbTw6gR3ILU+3
         1xP7QtzF6MoYoZjpBQrW2eAGa5piPWn+MjrpFH/LBaKFIXzjEn0qkIkA7/qqqkXW6MuX
         ZKPg==
X-Gm-Message-State: ANhLgQ2Pi37n7gXWn+OvcrQZYDc3k0ba/4AFwMla43UwIiQgnRj5/gns
        bOjlg8pgINehdDzZ5qFgTdfr+chU
X-Google-Smtp-Source: ADFU+vue/idDalSTKBj1iDAk09k6858dPJxQUBs/qR4I5ed0U6uSZ4OM3NGO8fQN2j5XaPS3Ck+zKg==
X-Received: by 2002:a17:902:342:: with SMTP id 60mr8647848pld.206.1583614394067;
        Sat, 07 Mar 2020 12:53:14 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id a17sm13148109pjv.6.2020.03.07.12.53.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Mar 2020 12:53:13 -0800 (PST)
Subject: Re: [PATCH net-next v6 1/3] net/sched: act_ct: Create nf flow table
 per zone
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>,
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
Message-ID: <57a22ef3-63de-2b51-61cb-5ff00d2a5b81@gmail.com>
Date:   Sat, 7 Mar 2020 12:53:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c0c033e8-63ed-a33c-2e1b-afbedcb476ea@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/7/20 12:12 PM, Eric Dumazet wrote:
> 
> 
> On 3/3/20 7:57 AM, Paul Blakey wrote:
>> Use the NF flow tables infrastructure for CT offload.
>>
>> Create a nf flow table per zone.
>>
>> Next patches will add FT entries to this table, and do
>> the software offload.
>>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>   v4->v5:
>>     Added reviewed by Jiri, thanks!
>>   v3->v4:
>>     Alloc GFP_ATOMIC
>>   v2->v3:
>>     Ditch re-locking to alloc, and use atomic allocation
>>   v1->v2:
>>     Use spin_lock_bh instead of spin_lock, and unlock for alloc (as it can sleep)
>>     Free ft on last tc act instance instead of last instance + last offloaded tuple,
>>     this removes cleanup cb and netfilter patches, and is simpler
>>     Removed accidental mlx5/core/en_tc.c change
>>     Removed reviewed by Jiri - patch changed
>>
>> +	err = nf_flow_table_init(&ct_ft->nf_ft);
> 
> This call is going to allocate a rhashtable (GFP_KERNEL allocations that might sleep)
> 
> Since you still hold zones_lock spinlock, a splat should occur.
> 
> "BUG: sleeping function called from invalid context in  ..."
> 
> DEBUG_ATOMIC_SLEEP=y is your friend.
> 
> And it is always a good thing to make sure a patch does not trigger a lockdep splat
> 
> CONFIG_PROVE_LOCKING=y

Also abusing a spinlock and GFP_ATOMIC allocations in control path is highly discouraged.

I can not test the following fix, any objections before I submit this officially ?

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 23eba61f0f819212a3522c3c63b938d0b8d997e2..3d9e678d7d5336f1746035745b091bea0dcb5fdd 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -35,15 +35,15 @@
 
 static struct workqueue_struct *act_ct_wq;
 static struct rhashtable zones_ht;
-static DEFINE_SPINLOCK(zones_lock);
+static DEFINE_MUTEX(zones_mutex);
 
 struct tcf_ct_flow_table {
        struct rhash_head node; /* In zones tables */
 
        struct rcu_work rwork;
        struct nf_flowtable nf_ft;
+       refcount_t ref;
        u16 zone;
-       u32 ref;
 
        bool dying;
 };
@@ -64,14 +64,15 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
        struct tcf_ct_flow_table *ct_ft;
        int err = -ENOMEM;
 
-       spin_lock_bh(&zones_lock);
+       mutex_lock(&zones_mutex);
        ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
-       if (ct_ft)
-               goto take_ref;
+       if (ct_ft && refcount_inc_not_zero(&ct_ft->ref))
+               goto out_unlock;
 
-       ct_ft = kzalloc(sizeof(*ct_ft), GFP_ATOMIC);
+       ct_ft = kzalloc(sizeof(*ct_ft), GFP_KERNEL);
        if (!ct_ft)
                goto err_alloc;
+       refcount_set(&ct_ft->ref, 1);
 
        ct_ft->zone = params->zone;
        err = rhashtable_insert_fast(&zones_ht, &ct_ft->node, zones_params);
@@ -84,10 +85,9 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
                goto err_init;
 
        __module_get(THIS_MODULE);
-take_ref:
+out_unlock:
        params->ct_ft = ct_ft;
-       ct_ft->ref++;
-       spin_unlock_bh(&zones_lock);
+       mutex_unlock(&zones_mutex);
 
        return 0;
 
@@ -96,7 +96,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 err_insert:
        kfree(ct_ft);
 err_alloc:
-       spin_unlock_bh(&zones_lock);
+       mutex_unlock(&zones_mutex);
        return err;
 }
 
@@ -116,13 +116,11 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
 {
        struct tcf_ct_flow_table *ct_ft = params->ct_ft;
 
-       spin_lock_bh(&zones_lock);
-       if (--params->ct_ft->ref == 0) {
+       if (refcount_dec_and_test(&params->ct_ft->ref)) {
                rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
                INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
                queue_rcu_work(act_ct_wq, &ct_ft->rwork);
        }
-       spin_unlock_bh(&zones_lock);
 }
 
 static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,

