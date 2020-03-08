Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8302417D295
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 09:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCHILo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 04:11:44 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:25057
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbgCHILn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Mar 2020 04:11:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjijeejHbPXwhZYe9mtAGTEM9cQiwpssgyqXc8qQjL1VJdPOIUPG8YBESHer/9dtZAzyvgLJ2AdmeNOUZ+4ex0XMdqbZBj8qy/1X456mXRJuM2YGk6J9RiB3LpjPHM6915MmAsamwPk/JVA1hF4SDXSG3gShXbgeQnoltgy7jD5zrbmsmUzHMaMJua+A0VEVJRCCgvfjhIQaRk7t2qf9qhhXOFwalxKYu957O0s9jkuJfBB8gzOc+EmOXfmINXF2IFBA7GYQwB8JPeCTzkMYg2w/C167mXtQFnqtR1zHpi4n9YbnZsrlwtegY5uOKKrj/TSr5bEkUSs2haiGuI6RWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yXwGd3CtlGZwZEADe/1q8Ald4fcSXmOv/e3GUjTYO0=;
 b=nScilyaiSbIUzqFPnIPHmFBhBnkFiiQByPjuLn2PNAKCPo49plOZiTJAe1G3xUSai4JFZAJm41uj/ArTmjJTDCr4GJllKEgPuV6dYoClwPbV5zHWlo4k9LGdEcTU/B8lpMOvImntgQt0sN9Yky34zznfSAJ0QsKyQ/li8uZKwAwEdeQFI/TCuwdApbFpyKeN/viS217XV8MSS8DGx4gAr2+aOi+KYbNujkKBesjZmfPqZv59DQQArXxqpvrXJXoGzoWpDyb7Y869hHpq9ua+nmzXd88gVownmm90a4RJZpB4PaJfy/7kzQKqADTxzQW6gTzNA+uk69xdE7fDaK6ebA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yXwGd3CtlGZwZEADe/1q8Ald4fcSXmOv/e3GUjTYO0=;
 b=N+erWE4jtAd9xrJQSxsajpDIHRWDh0XiMvg3aWIdwb7Zv6tH73TVCPwwiYtQNOWLTjKPQYopyJDCf8q2HaX1//2rWHr9aTkiGnfDIFnxxtxkvaeUt/1FXXs1Crrw+Cp/h1+rlseWN6rA3OgmvJ3j3BsrryODoZfe0hAuQzCL53E=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6616.eurprd05.prod.outlook.com (20.179.2.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Sun, 8 Mar 2020 08:11:40 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Sun, 8 Mar 2020
 08:11:40 +0000
Subject: Re: [PATCH net-next v6 1/3] net/sched: act_ct: Create nf flow table
 per zone
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
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <334b4af2-1ac0-d28b-f1a5-b9b604a9ba80@mellanox.com>
Date:   Sun, 8 Mar 2020 10:11:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <57a22ef3-63de-2b51-61cb-5ff00d2a5b81@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: ZR0P278CA0019.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::6) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by ZR0P278CA0019.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Sun, 8 Mar 2020 08:11:38 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1ddd30d7-479a-45af-d655-08d7c3385471
X-MS-TrafficTypeDiagnostic: AM6PR05MB6616:|AM6PR05MB6616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6616D91B3B54F5DCF3FF2BFFCFE10@AM6PR05MB6616.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03361FCC43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(366004)(136003)(39850400004)(189003)(199004)(478600001)(16576012)(186003)(36756003)(26005)(8936002)(66556008)(31686004)(66946007)(66476007)(2616005)(6636002)(5660300002)(316002)(956004)(8676002)(6486002)(110136005)(2906002)(81166006)(31696002)(81156014)(52116002)(86362001)(53546011)(16526019);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6616;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AjFqMlJXQ3E5z5Uks5jkl9J57UZ13AWTBbcO7KYeMrrINwSKIJ2fzP+R93PPTz9F2kgXKpwsw1cfC6bZw1uTyeFKQNNbfT30rHA4yJ792XWy1cFugR+54mzifqXhsYiz+CocZiMEYLckmhWv2+AKllpfc//K/wyyfQy65dtkLWHQ66uHDjMwUf9vDzP+EN9O57guGf+cTgS0G+9xF3erCtChaALyPAZ05eTX6QeKYF0lJOOJ+zpi5ZwUTgy9NigAyPdsCvAonyEowqL52Xpnifclp3uGJh4lc4C3unZ5k3GyuBAw2H4TuE6c2Cr9/7oOd9zEqPqPZ0GQRe8e2u9g7ZyN8dfaqn26b/tIoH5rPsDNo1bJIJCphNwvlh9MTjW7V9wwApWEhDSEeHR2rFlSUB0ebAuutvydxlHxn9yRdIF9h71hEeI/lhspJaKM5R4Y
X-MS-Exchange-AntiSpam-MessageData: 21shTk+Benu8m4nSJGtLuTDJ2D7ndFn8B/8TkSONXVbcF5owKGAGnApA1BDc1IUuxOAcnYI40nzIOg14Ccob/HvbM+DJxgzFnsczOJt8Kwub6OEQpmJyOB0dKyEVsotffHkM4ZSIKH6RAVCqMl+sgg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ddd30d7-479a-45af-d655-08d7c3385471
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2020 08:11:40.0694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 892Ck6InTS8zlZaGAEG5snr1j9vsYTRkYpmahtba0Ffpe1wQmoUIY+xYDBAvHzA2iveO2yjUYIZRRm5ZeMVYiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6616
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iirc I did the spin lock bh because we can be called from queue work rcu handler , so I wanted to disable soft irq.

I got a possible deadlock splat for that.



On 3/7/2020 10:53 PM, Eric Dumazet wrote:

>
> On 3/7/20 12:12 PM, Eric Dumazet wrote:
>>
>> On 3/3/20 7:57 AM, Paul Blakey wrote:
>>> Use the NF flow tables infrastructure for CT offload.
>>>
>>> Create a nf flow table per zone.
>>>
>>> Next patches will add FT entries to this table, and do
>>> the software offload.
>>>
>>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>>> ---
>>>   v4->v5:
>>>     Added reviewed by Jiri, thanks!
>>>   v3->v4:
>>>     Alloc GFP_ATOMIC
>>>   v2->v3:
>>>     Ditch re-locking to alloc, and use atomic allocation
>>>   v1->v2:
>>>     Use spin_lock_bh instead of spin_lock, and unlock for alloc (as it can sleep)
>>>     Free ft on last tc act instance instead of last instance + last offloaded tuple,
>>>     this removes cleanup cb and netfilter patches, and is simpler
>>>     Removed accidental mlx5/core/en_tc.c change
>>>     Removed reviewed by Jiri - patch changed
>>>
>>> +	err = nf_flow_table_init(&ct_ft->nf_ft);
>> This call is going to allocate a rhashtable (GFP_KERNEL allocations that might sleep)
>>
>> Since you still hold zones_lock spinlock, a splat should occur.
>>
>> "BUG: sleeping function called from invalid context in  ..."
>>
>> DEBUG_ATOMIC_SLEEP=y is your friend.
>>
>> And it is always a good thing to make sure a patch does not trigger a lockdep splat
>>
>> CONFIG_PROVE_LOCKING=y
> Also abusing a spinlock and GFP_ATOMIC allocations in control path is highly discouraged.
>
> I can not test the following fix, any objections before I submit this officially ?
>
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 23eba61f0f819212a3522c3c63b938d0b8d997e2..3d9e678d7d5336f1746035745b091bea0dcb5fdd 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -35,15 +35,15 @@
>  
>  static struct workqueue_struct *act_ct_wq;
>  static struct rhashtable zones_ht;
> -static DEFINE_SPINLOCK(zones_lock);
> +static DEFINE_MUTEX(zones_mutex);
>  
>  struct tcf_ct_flow_table {
>         struct rhash_head node; /* In zones tables */
>  
>         struct rcu_work rwork;
>         struct nf_flowtable nf_ft;
> +       refcount_t ref;
>         u16 zone;
> -       u32 ref;
>  
>         bool dying;
>  };
> @@ -64,14 +64,15 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>         struct tcf_ct_flow_table *ct_ft;
>         int err = -ENOMEM;
>  
> -       spin_lock_bh(&zones_lock);
> +       mutex_lock(&zones_mutex);
>         ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
> -       if (ct_ft)
> -               goto take_ref;
> +       if (ct_ft && refcount_inc_not_zero(&ct_ft->ref))
> +               goto out_unlock;
>  
> -       ct_ft = kzalloc(sizeof(*ct_ft), GFP_ATOMIC);
> +       ct_ft = kzalloc(sizeof(*ct_ft), GFP_KERNEL);
>         if (!ct_ft)
>                 goto err_alloc;
> +       refcount_set(&ct_ft->ref, 1);
>  
>         ct_ft->zone = params->zone;
>         err = rhashtable_insert_fast(&zones_ht, &ct_ft->node, zones_params);
> @@ -84,10 +85,9 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>                 goto err_init;
>  
>         __module_get(THIS_MODULE);
> -take_ref:
> +out_unlock:
>         params->ct_ft = ct_ft;
> -       ct_ft->ref++;
> -       spin_unlock_bh(&zones_lock);
> +       mutex_unlock(&zones_mutex);
>  
>         return 0;
>  
> @@ -96,7 +96,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>  err_insert:
>         kfree(ct_ft);
>  err_alloc:
> -       spin_unlock_bh(&zones_lock);
> +       mutex_unlock(&zones_mutex);
>         return err;
>  }
>  
> @@ -116,13 +116,11 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
>  {
>         struct tcf_ct_flow_table *ct_ft = params->ct_ft;
>  
> -       spin_lock_bh(&zones_lock);
> -       if (--params->ct_ft->ref == 0) {
> +       if (refcount_dec_and_test(&params->ct_ft->ref)) {
>                 rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
>                 INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
>                 queue_rcu_work(act_ct_wq, &ct_ft->rwork);
>         }
> -       spin_unlock_bh(&zones_lock);
>  }
>  
>  static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
>
