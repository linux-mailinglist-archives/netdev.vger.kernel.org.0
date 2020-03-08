Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84A217D297
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 09:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgCHIPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 04:15:11 -0400
Received: from mail-vi1eur05on2050.outbound.protection.outlook.com ([40.107.21.50]:6100
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgCHIPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Mar 2020 04:15:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYhKkf7kWjrF5pMeYrTPdOscbfGVUKL8zEcxsoQsKZprpQaKiN7ObjC789kxngLViWrmA8Eyf0gM21jizayFlwBEtan7xgCrtRqeav+3si+eii2OwuUmK6/9FIPVmI3WAyOFY0T2FFTNDAyfMmfu/MjrLQvtz53JWpNd7CgQraxOJOpIBw2Mwqq7TCiMRspF6XC+VUg6HcDwW00nQJCcxRdkMcBEv8R34uNNj8AdzwUUE8YhGcl2uWmcyOnjszfc5ZqB+/atzoNdYMur4oo44hjACRKcunChBdOad9iEpCV+8xy7BZooT0VU6JDGH7Vbsd2ie5oCVvfMZg2vuawm7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGvjwoXRgBwU4gxpIxdd+7i0LP9PA6cUJbT/R1u5avs=;
 b=NcrXdVoKJ0eoY7IMXvQN+PQT9VBRMDOxB3cNa91N4WLkUcjORvB6LrByDrDNEpzl+Yu8nGGByT6+HXdGGwZCBST54FbuA6UcQZrdyj6U9lBdzkL3MASm5/6T4IyFJcfjXN3mw+2J//cCTfU9OFWLUBl07Ruz7xBxkEW7nAa3gUah1flD84eMS6qaTJgDpupVYFyIqdeiC2ES0ebpSu9Awo+LtRgj79KnniUFpf6BnRBJcI68qs94py17hlYONOb/Qy9AaOiHGPSt+kxj3AGeeGG+ZhYVy48o+ZS5oVph4m3JYvMSxtDXGrrsNlX9KihqJTEPe1pZY1SY9n94fUzhIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGvjwoXRgBwU4gxpIxdd+7i0LP9PA6cUJbT/R1u5avs=;
 b=q2dgKcGwBuQT7Kji/tB06AYOekODxCAgS9t3jnlIwvwUwZnXyxFw3JlpRvIRK6pk18oStbeTug7M8hIzSAWDdCTgXzqbLPczE8fdWsQR059XzOfS4EnvJD0oHDcZzYmhPki7z+WN15FeZ3gc0S03+1zqJ4Q6F1xc3CB7Q9H3GCw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6616.eurprd05.prod.outlook.com (20.179.2.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Sun, 8 Mar 2020 08:15:04 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Sun, 8 Mar 2020
 08:15:04 +0000
Subject: Re: [PATCH net-next v6 1/3] net/sched: act_ct: Create nf flow table
 per zone
From:   Paul Blakey <paulb@mellanox.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
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
Message-ID: <69fa856f-4aaf-4f54-7324-009cdbf26e38@mellanox.com>
Date:   Sun, 8 Mar 2020 10:15:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <334b4af2-1ac0-d28b-f1a5-b9b604a9ba80@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: FR2P281CA0033.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::20) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by FR2P281CA0033.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Sun, 8 Mar 2020 08:15:03 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e667cdc1-c6ae-479e-fc91-08d7c338ce3e
X-MS-TrafficTypeDiagnostic: AM6PR05MB6616:|AM6PR05MB6616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB66161E9B717A72E258E44358CFE10@AM6PR05MB6616.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03361FCC43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(366004)(136003)(39850400004)(189003)(199004)(478600001)(16576012)(186003)(36756003)(26005)(8936002)(66556008)(31686004)(66946007)(66476007)(2616005)(6636002)(5660300002)(316002)(956004)(8676002)(6486002)(110136005)(2906002)(81166006)(31696002)(81156014)(52116002)(86362001)(53546011)(16526019);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6616;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eMF7o/AWy/0Sx5juVTHO1/h3hyG0wosQIILyYE3cI5UnejQYO6s+4cPwjOAdQ0RarLKjDoZVLOJp/rK1Ph6XtA3r19rg6FkG72nRfsP5sjHvPvgaMmaAvNAv+6/6I0teBXR9NPfei/4V/uYYFcL7dy1xCoCZn+tb11vpCAa/Px9wXVm8yuCN/j1eM132JNOLceXcR27kjmpB46QwaoNnt6gjqL3b9QeUg/QfjdGs+5OZqjjhNqcW809qZ8DWUJNCv1ubKrZ6vqJsVobGNH5AGV9F58oz+btvxqi5SkTmId5V+SjIT6WVg1HBMAlqLZXI3oUdQ28Xt4guV7jdNlPkokfsuP/39wUDtBBZ8WyeXg0Mn7NiduX51Wx5xsTbmYaPHy6trHoKGsGHs/l2cJRSXTV1UZD9SNrOK3doZ8v3JhM5QoK3jZIpoes8NdLHKLrM
X-MS-Exchange-AntiSpam-MessageData: OVit2iD8xT5KdwUMzdGbO2MHxRSvP2NIXRgXj06m1Ey8/y4dqHuq3EIRWdjk0O5TJ7zBfpHXAj/8dz3IZjumrjKysXOP2R3vXwj8LknLpdd0Kw58wv0TF1FH7HHd60DenFnGkLLOBILfqMK1RRB32g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e667cdc1-c6ae-479e-fc91-08d7c338ce3e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2020 08:15:04.3482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9IiSnZnRSpo3NChiruT9MvsSsuOru+FWnrBfR6U+4LZIib691FVK+r515SXnBeCzuQmZYaeF89X601CCgsp84g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6616
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/2020 10:11 AM, Paul Blakey wrote:

> iirc I did the spin lock bh because we can be called from queue work rcu handler , so I wanted to disable soft irq.
>
> I got a possible deadlock splat for that.

Here I meant this call rcu:

static void tcf_ct_cleanup(struct tc_action *a)
{
>-------struct tcf_ct_params *params;
>-------struct tcf_ct *c = to_ct(a);

>-------params = rcu_dereference_protected(c->params, 1);
>-------if (params)
>------->-------call_rcu(&params->rcu, tcf_ct_params_free);
}

static void tcf_ct_params_free(struct rcu_head *head)
{
>-------struct tcf_ct_params *params = container_of(head,
>------->------->------->------->------->-------    struct tcf_ct_params, rcu);

>-------tcf_ct_flow_table_put(params);

...


>
>
> On 3/7/2020 10:53 PM, Eric Dumazet wrote:
>
>> On 3/7/20 12:12 PM, Eric Dumazet wrote:
>>> On 3/3/20 7:57 AM, Paul Blakey wrote:
>>>> Use the NF flow tables infrastructure for CT offload.
>>>>
>>>> Create a nf flow table per zone.
>>>>
>>>> Next patches will add FT entries to this table, and do
>>>> the software offload.
>>>>
>>>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>>>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>>>> ---
>>>>   v4->v5:
>>>>     Added reviewed by Jiri, thanks!
>>>>   v3->v4:
>>>>     Alloc GFP_ATOMIC
>>>>   v2->v3:
>>>>     Ditch re-locking to alloc, and use atomic allocation
>>>>   v1->v2:
>>>>     Use spin_lock_bh instead of spin_lock, and unlock for alloc (as it can sleep)
>>>>     Free ft on last tc act instance instead of last instance + last offloaded tuple,
>>>>     this removes cleanup cb and netfilter patches, and is simpler
>>>>     Removed accidental mlx5/core/en_tc.c change
>>>>     Removed reviewed by Jiri - patch changed
>>>>
>>>> +	err = nf_flow_table_init(&ct_ft->nf_ft);
>>> This call is going to allocate a rhashtable (GFP_KERNEL allocations that might sleep)
>>>
>>> Since you still hold zones_lock spinlock, a splat should occur.
>>>
>>> "BUG: sleeping function called from invalid context in  ..."
>>>
>>> DEBUG_ATOMIC_SLEEP=y is your friend.
>>>
>>> And it is always a good thing to make sure a patch does not trigger a lockdep splat
>>>
>>> CONFIG_PROVE_LOCKING=y
>> Also abusing a spinlock and GFP_ATOMIC allocations in control path is highly discouraged.
>>
>> I can not test the following fix, any objections before I submit this officially ?
>>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index 23eba61f0f819212a3522c3c63b938d0b8d997e2..3d9e678d7d5336f1746035745b091bea0dcb5fdd 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -35,15 +35,15 @@
>>  
>>  static struct workqueue_struct *act_ct_wq;
>>  static struct rhashtable zones_ht;
>> -static DEFINE_SPINLOCK(zones_lock);
>> +static DEFINE_MUTEX(zones_mutex);
>>  
>>  struct tcf_ct_flow_table {
>>         struct rhash_head node; /* In zones tables */
>>  
>>         struct rcu_work rwork;
>>         struct nf_flowtable nf_ft;
>> +       refcount_t ref;
>>         u16 zone;
>> -       u32 ref;
>>  
>>         bool dying;
>>  };
>> @@ -64,14 +64,15 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>>         struct tcf_ct_flow_table *ct_ft;
>>         int err = -ENOMEM;
>>  
>> -       spin_lock_bh(&zones_lock);
>> +       mutex_lock(&zones_mutex);
>>         ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
>> -       if (ct_ft)
>> -               goto take_ref;
>> +       if (ct_ft && refcount_inc_not_zero(&ct_ft->ref))
>> +               goto out_unlock;
>>  
>> -       ct_ft = kzalloc(sizeof(*ct_ft), GFP_ATOMIC);
>> +       ct_ft = kzalloc(sizeof(*ct_ft), GFP_KERNEL);
>>         if (!ct_ft)
>>                 goto err_alloc;
>> +       refcount_set(&ct_ft->ref, 1);
>>  
>>         ct_ft->zone = params->zone;
>>         err = rhashtable_insert_fast(&zones_ht, &ct_ft->node, zones_params);
>> @@ -84,10 +85,9 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>>                 goto err_init;
>>  
>>         __module_get(THIS_MODULE);
>> -take_ref:
>> +out_unlock:
>>         params->ct_ft = ct_ft;
>> -       ct_ft->ref++;
>> -       spin_unlock_bh(&zones_lock);
>> +       mutex_unlock(&zones_mutex);
>>  
>>         return 0;
>>  
>> @@ -96,7 +96,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>>  err_insert:
>>         kfree(ct_ft);
>>  err_alloc:
>> -       spin_unlock_bh(&zones_lock);
>> +       mutex_unlock(&zones_mutex);
>>         return err;
>>  }
>>  
>> @@ -116,13 +116,11 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
>>  {
>>         struct tcf_ct_flow_table *ct_ft = params->ct_ft;
>>  
>> -       spin_lock_bh(&zones_lock);
>> -       if (--params->ct_ft->ref == 0) {
>> +       if (refcount_dec_and_test(&params->ct_ft->ref)) {
>>                 rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
>>                 INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
>>                 queue_rcu_work(act_ct_wq, &ct_ft->rwork);
>>         }
>> -       spin_unlock_bh(&zones_lock);
>>  }
>>  
>>  static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
>>
