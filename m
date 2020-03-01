Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD5F174E3E
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 17:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgCAQLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 11:11:33 -0500
Received: from mail-eopbgr40067.outbound.protection.outlook.com ([40.107.4.67]:13953
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725945AbgCAQLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 11:11:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiTstLpcx/6/x02H8etsM1MerHNM6ksRvZ6aYoDo0BgnasrobPN/T5WG/VY1kyrTcUqKyMci0G5kle97m5tCzUKtZC0mRSzXpu8YNg6EB0oK5ycsJumirbmut4aEqAAVw0Wx54p16Lzz3wupUJC1pto/QeLR1nmQlHOkb/TViga1C23R4F1zJut8vtisHiVy1i9ETamAZ2d8qRBsQSQ9aFs6sV8aL2DT1AUdi5A9B6Crsl1nIEVufdVL/T6kaS32UUIUWazgYwYEOXV2gleHC+tMlnvoRG3VcxlJEeiuip8iH3vJs+MYTUwe3CvPIYe1wIRJCJNc24Hef+xTVrGXpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0m4bFbqv19qrazlq52Um4LLM2Jm9NAN2tAMjO82Vgg=;
 b=UTCLmFr7ZLu/APHit6wLz+bQQRYZQXCaK+NvTmIMfoNmP5GQ+FNaXbuKR5flCav5H1gFoADXI4Y9lHi5p7/XtJ3BBB+mycSSrZ/GeiQ6q05xAHo5DPV0GqWwgSfwBjCilarjkiRUTknlj8cmb4pHav79/CesWaX4Y8YuAKLCmlLMH0b129AekOjaa//MqulLT0QSZGhvUdQ2iCz+Gi8KWT+NyhH0omBM5xdjU5GrrdswhCGVomQ8yxdBMADJ6zeF/zDU0hVmeBTtB/G8owJLycNSD89wL4/9NB3MtkMI/eQZi6/W9asUArA4kE77Fbs75rfjCM2ccjbkGPNdbL9z0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0m4bFbqv19qrazlq52Um4LLM2Jm9NAN2tAMjO82Vgg=;
 b=Qn3P3cpWJL7zzN3zUGpe8yJf/zAPu+CRB6qXa5A1HiyjsRv1vQra3ka3Dmjgxt/vbtldrqMjLQeV74tXL8F3s29Qosnn2hF7AJsnIAiG3OmnSvhZKpPyDCp0s9w8axU06LENKxbUn0kzcKgTvs4x9r0dKvdfNfdRt1+FLNckw1s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Sun, 1 Mar 2020 16:11:28 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Sun, 1 Mar 2020
 16:11:28 +0000
Subject: Re: [PATCH net-next v2 1/3] net/sched: act_ct: Create nf flow table
 per zone
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583067523-1960-1-git-send-email-paulb@mellanox.com>
 <1583067523-1960-2-git-send-email-paulb@mellanox.com>
 <20200301154701.GU26061@nanopsycho>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <7d173492-0b70-4318-6ddf-cc4dd015f217@mellanox.com>
Date:   Sun, 1 Mar 2020 18:11:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200301154701.GU26061@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::13) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Sun, 1 Mar 2020 16:11:27 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 745512ae-b138-46c4-08b9-08d7bdfb32c6
X-MS-TrafficTypeDiagnostic: AM6PR05MB4198:|AM6PR05MB4198:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4198F067CEC80D9AAD5449DACFE60@AM6PR05MB4198.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0329B15C8A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(2906002)(6486002)(36756003)(16526019)(6916009)(26005)(478600001)(956004)(81166006)(8676002)(2616005)(6666004)(8936002)(81156014)(107886003)(52116002)(316002)(16576012)(5660300002)(66556008)(66476007)(66946007)(54906003)(31686004)(86362001)(186003)(31696002)(4326008)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4198;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AfuOJ4mrbwyC5gIbLq2uhtPq7CF2sQfJxayeL9VA5bUAmdvGimFAz9HvpL4QnlMcpgGywsnwjF+iZW1+6V3YAzX7Th73e7jwneJZNaYUOuUozy+cYynkPvAPLm6FHEeoO8Yyz14sdR1Y2yzMDzVJIlMlvFW4YZ8Mcr9J0dnsfTPxOUg5v/hgL5UAoPzt5EKMRPXggdv9+Qsw0g/lXDSMZd/BWan2suVlf91Zmti5G2bC4StNHbTvtmCrKDn7GGQL4EhPwr/Ehft48NO2EsfQwZtPC7wht5qr1mD+SE/ojZi30+3KlRcn0yvRbXIIS1AmZLVmv1xqy2K59ajrloMb+vktLO+UQ2NG4yY/99kZuCyB0DG4TwR/zsUZh2VWCz5kVHMHVpQdKGJOeY9Esj+CvhD/443T76W2E93E3WDxlr/UCRWqS1HrLyHrW3bFZ0f7
X-MS-Exchange-AntiSpam-MessageData: qXBmKcX929yv2Lmx3ASJAO2C9r9RVC79fsGQeD0m0ZT0K1si3d+MtZt1+xDMrmAn02urlYNccMyAnU2GSGGt92kyVj6/4A3wu3p67HEsfCI6hCEip7j3s4HP7TarSo/SYQO+cyLFKpxZq/QNMLcyMw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 745512ae-b138-46c4-08b9-08d7bdfb32c6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2020 16:11:28.4033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lt38PEaPNESYMoouVCZBvnwH002ibZX6OIeuo7I4ZawZ4rUyVXXCS4mlMBZSX6hEcqsEnNrSXeGcJJxtoILVPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/1/2020 5:47 PM, Jiri Pirko wrote:
> Sun, Mar 01, 2020 at 01:58:41PM CET, paulb@mellanox.com wrote:
>> Use the NF flow tables infrastructure for CT offload.
>>
>> Create a nf flow table per zone.
>>
>> Next patches will add FT entries to this table, and do
>> the software offload.
>>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> ---
>> Changelog:
>>  v1->v2:
>>    Use spin_lock_bh instead of spin_lock, and unlock for alloc (as it can sleep)
>>    Free ft on last tc act instance instead of last instance + last offloaded tuple,
>>    this removes cleanup cb and netfilter patches, and is simpler
>>    Removed accidental mlx5/core/en_tc.c change
>>    Removed reviewed by Jiri - patch changed
>>
>> include/net/tc_act/tc_ct.h |   2 +
>> net/sched/Kconfig          |   2 +-
>> net/sched/act_ct.c         | 143 ++++++++++++++++++++++++++++++++++++++++++++-
>> 3 files changed, 145 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
>> index a8b1564..cf3492e 100644
>> --- a/include/net/tc_act/tc_ct.h
>> +++ b/include/net/tc_act/tc_ct.h
>> @@ -25,6 +25,8 @@ struct tcf_ct_params {
>> 	u16 ct_action;
>>
>> 	struct rcu_head rcu;
>> +
>> +	struct tcf_ct_flow_table *ct_ft;
>> };
>>
>> struct tcf_ct {
>> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
>> index edde0e5..bfbefb7 100644
>> --- a/net/sched/Kconfig
>> +++ b/net/sched/Kconfig
>> @@ -972,7 +972,7 @@ config NET_ACT_TUNNEL_KEY
>>
>> config NET_ACT_CT
>> 	tristate "connection tracking tc action"
>> -	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT
>> +	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT && NF_FLOW_TABLE
>> 	help
>> 	  Say Y here to allow sending the packets to conntrack module.
>>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index f685c0d..43dfdd1 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -15,6 +15,7 @@
>> #include <linux/pkt_cls.h>
>> #include <linux/ip.h>
>> #include <linux/ipv6.h>
>> +#include <linux/rhashtable.h>
>> #include <net/netlink.h>
>> #include <net/pkt_sched.h>
>> #include <net/pkt_cls.h>
>> @@ -24,6 +25,7 @@
>> #include <uapi/linux/tc_act/tc_ct.h>
>> #include <net/tc_act/tc_ct.h>
>>
>> +#include <net/netfilter/nf_flow_table.h>
>> #include <net/netfilter/nf_conntrack.h>
>> #include <net/netfilter/nf_conntrack_core.h>
>> #include <net/netfilter/nf_conntrack_zones.h>
>> @@ -31,6 +33,117 @@
>> #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
>> #include <uapi/linux/netfilter/nf_nat.h>
>>
>> +static struct workqueue_struct *act_ct_wq;
>> +static struct rhashtable zones_ht;
>> +static DEFINE_SPINLOCK(zones_lock);
>> +
>> +struct tcf_ct_flow_table {
>> +	struct rhash_head node; /* In zones tables */
>> +
>> +	struct rcu_work rwork;
>> +	struct nf_flowtable nf_ft;
>> +	u16 zone;
>> +	u32 ref;
>> +
>> +	bool dying;
>> +};
>> +
>> +static const struct rhashtable_params zones_params = {
>> +	.head_offset = offsetof(struct tcf_ct_flow_table, node),
>> +	.key_offset = offsetof(struct tcf_ct_flow_table, zone),
>> +	.key_len = sizeof_field(struct tcf_ct_flow_table, zone),
>> +	.automatic_shrinking = true,
>> +};
>> +
>> +static struct nf_flowtable_type flowtable_ct = {
>> +	.owner		= THIS_MODULE,
>> +};
>> +
>> +static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>> +{
>> +	struct tcf_ct_flow_table *ct_ft, *new_ct_ft;
>> +	int err;
>> +
>> +	spin_lock_bh(&zones_lock);
>> +	ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
>> +	if (ct_ft)
>> +		goto take_ref;
>> +
>> +	spin_unlock_bh(&zones_lock);
>> +	new_ct_ft = kzalloc(sizeof(*new_ct_ft), GFP_KERNEL);
> Don't unlock-lock and just use GFP_ATOMIC.
Sure will do.
>
>
>> +	if (!new_ct_ft)
>> +		return -ENOMEM;
>> +
>> +	new_ct_ft->zone = params->zone;
>> +	spin_lock_bh(&zones_lock);
>> +	ct_ft = rhashtable_lookup_get_insert_fast(&zones_ht, &new_ct_ft->node,
>> +						  zones_params);
>> +	if (IS_ERR(ct_ft)) {
>> +		err = PTR_ERR(ct_ft);
>> +		goto err_insert;
>> +	} else if (ct_ft) {
>> +		/* Already exists */
>> +		kfree(new_ct_ft);
>> +		goto take_ref;
>> +	}
>> +
>> +	ct_ft = new_ct_ft;
>> +	ct_ft->nf_ft.type = &flowtable_ct;
>> +	err = nf_flow_table_init(&ct_ft->nf_ft);
>> +	if (err)
>> +		goto err_init;
>> +
>> +	__module_get(THIS_MODULE);
>> +take_ref:
>> +	params->ct_ft = ct_ft;
>> +	ct_ft->ref++;
>> +	spin_unlock_bh(&zones_lock);
>> +
>> +	return 0;
>> +
>> +err_init:
>> +	rhashtable_remove_fast(&zones_ht, &new_ct_ft->node, zones_params);
>> +err_insert:
>> +	spin_unlock_bh(&zones_lock);
>> +	kfree(new_ct_ft);
>> +	return err;
>> +}
>> +
>> +static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
>> +{
>> +	struct tcf_ct_flow_table *ct_ft;
>> +
>> +	ct_ft = container_of(to_rcu_work(work), struct tcf_ct_flow_table,
>> +			     rwork);
>> +	nf_flow_table_free(&ct_ft->nf_ft);
>> +	kfree(ct_ft);
>> +
>> +	module_put(THIS_MODULE);
>> +}
>> +
>> +static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
>> +{
>> +	struct tcf_ct_flow_table *ct_ft = params->ct_ft;
>> +
>> +	spin_lock_bh(&zones_lock);
>> +	if (--params->ct_ft->ref == 0) {
>> +		rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
>> +		INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
>> +		queue_rcu_work(act_ct_wq, &ct_ft->rwork);
>> +	}
>> +	spin_unlock_bh(&zones_lock);
>> +}
>> +
>> +static int tcf_ct_flow_tables_init(void)
>> +{
>> +	return rhashtable_init(&zones_ht, &zones_params);
>> +}
>> +
>> +static void tcf_ct_flow_tables_uninit(void)
>> +{
>> +	rhashtable_destroy(&zones_ht);
>> +}
>> +
>> static struct tc_action_ops act_ct_ops;
>> static unsigned int ct_net_id;
>>
>> @@ -207,6 +320,8 @@ static void tcf_ct_params_free(struct rcu_head *head)
>> 	struct tcf_ct_params *params = container_of(head,
>> 						    struct tcf_ct_params, rcu);
>>
>> +	tcf_ct_flow_table_put(params);
>> +
>> 	if (params->tmpl)
>> 		nf_conntrack_put(&params->tmpl->ct_general);
>> 	kfree(params);
>> @@ -730,6 +845,10 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
>> 	if (err)
>> 		goto cleanup;
>>
>> +	err = tcf_ct_flow_table_get(params);
>> +	if (err)
>> +		goto cleanup;
>> +
>> 	spin_lock_bh(&c->tcf_lock);
>> 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
>> 	params = rcu_replace_pointer(c->params, params,
>> @@ -974,12 +1093,34 @@ static void __net_exit ct_exit_net(struct list_head *net_list)
>>
>> static int __init ct_init_module(void)
>> {
>> -	return tcf_register_action(&act_ct_ops, &ct_net_ops);
>> +	int err;
>> +
>> +	act_ct_wq = alloc_ordered_workqueue("act_ct_workqueue", 0);
>> +	if (!act_ct_wq)
>> +		return -ENOMEM;
>> +
>> +	err = tcf_ct_flow_tables_init();
>> +	if (err)
>> +		goto err_tbl_init;
>> +
>> +	err = tcf_register_action(&act_ct_ops, &ct_net_ops);
>> +	if (err)
>> +		goto err_register;
>> +
>> +	return 0;
>> +
>> +err_tbl_init:
>> +	destroy_workqueue(act_ct_wq);
>> +err_register:
>> +	tcf_ct_flow_tables_uninit();
>> +	return err;
>> }
>>
>> static void __exit ct_cleanup_module(void)
>> {
>> 	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
>> +	tcf_ct_flow_tables_uninit();
>> +	destroy_workqueue(act_ct_wq);
>> }
>>
>> module_init(ct_init_module);
>> -- 
>> 1.8.3.1
>>
