Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631C821BABB
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgGJQWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:22:12 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:52546
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726896AbgGJQWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 12:22:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jIbBWntmLLFPcLt9Ip48iA51MfPBWzEPmhSeS5LQFchYokPP21lrfPRNY6BtHP58+8D5vw8DKm3qZbZM6EM+JmrCYXyyyMLdbf/o/udfKcRp/lxIMBPJfRH7HIyRBBMtsHm7J4TZiOsjfYqEtbC1P9iZN1xFLFzRFZj+VovP0DoTuzj4aBwaPyWwivWhVqefgapHxk9QyBOcvJDz3qrXeyblVtmoOjcSgok/M+srvZ+r6S4z3p1urQZSLi5hApnbfY5XnN/DcSO+D0zGvKFVLaVcBumnV4rpffM6TJSK9T2XqI1A6g8a69/Pa87CMbcrWZ8lq2h88mywWRYqKEOQcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LaMgURbx1FETxfDAjZHRfcSVG9xCMdj7toQeZWJCo8=;
 b=YTOklWJ++lA7YlpJ1LnXKdnQ8geWefN3wTjBBcR4izEmFOaRkgELvPGlUW9v819Y4J6XgnQyN5ea+4PeYs6zPPsQxsdQSHuCP10AJO2sBa9wqdCFzT003ArX+vmkPlCdFOnoQ6Fd25+A+6cmGaHvF91FOO/dMQnHxvr7zcs1AkuBC2VHRbhEPePJEUq2yNED0tRo3J7UZhcOYb7gqbiux6kNgTnihULFzaMmmfb4oz7jGrAbiFamUKPqfuwx4XJSKrSUL0o9xN3poRThLtpKrFVfQRmDIflqJutJwP1lF7Rwx88CCmUN2/QlH4lAjmKsXovq3B8jZJM4f40KWIHU+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LaMgURbx1FETxfDAjZHRfcSVG9xCMdj7toQeZWJCo8=;
 b=Nmh5+L+A1Ui8N4CiInVSDz/y6fbqY6tcC1RahCFOUkZ/KAXFCBzvyQYBJgqKg3kdKPRxQFH5bsi+D29a7TPMO8DU3QB6ds7djAL72t0m+OUoDalJTFBASCimjON4n637qQGL6LBrfhg89OppDJtel09odQTjuP/IkcqCmQQRlR0=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0501MB2601.eurprd05.prod.outlook.com (2603:10a6:3:6a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Fri, 10 Jul 2020 16:22:07 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 16:22:07 +0000
References: <20200710135706.601409-1-idosch@idosch.org> <20200710135706.601409-2-idosch@idosch.org> <20200710141500.GA12659@salvia> <87sgdzflk4.fsf@mellanox.com> <20200710152648.GA14902@salvia>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 01/13] net: sched: Pass qdisc reference in struct flow_block_offload
In-reply-to: <20200710152648.GA14902@salvia>
Date:   Fri, 10 Jul 2020 18:22:03 +0200
Message-ID: <87r1tjfihg.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0083.eurprd04.prod.outlook.com
 (2603:10a6:208:be::24) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR04CA0083.eurprd04.prod.outlook.com (2603:10a6:208:be::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 16:22:05 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a54102ec-b007-41ed-e38e-08d824ed637f
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2601:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB2601579BD5DDA529181F4D87DB650@HE1PR0501MB2601.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hhzkXuQo4l5oGYyz30y0PI1Ag4CkbRRLy6ROniRaBSWJeP3mJ5k9zTGII22icuw3Ipw7YsNwQV+XK/3ezUgShVcBMV6BqGuDQlQKa4YJY2UZEyW6qnkeOQBqeiPT0/TvHLRQDZpliQW4gc4iYbm3eEUh+fOFgdyxwa32fg68wMBPbwLmQYieeCmCCCaZCQ/JWedUEtnP8GURTq/YNbCcDRRWIMSuDUQLqumpuQO3T7xBTdB9lFFwWRRque81CpFDIw0dA5Vj6e7Rt46Y65K05H9bGH/mG4kppi+tY1V2UKHnhVHQqxfqKjKva9+0CtgMBgI3QV6bO+5pOVYICDltsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(4326008)(956004)(54906003)(2616005)(2906002)(6496006)(52116002)(5660300002)(36756003)(8676002)(316002)(7416002)(6486002)(16526019)(186003)(86362001)(26005)(478600001)(83380400001)(66556008)(6916009)(107886003)(66476007)(8936002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mqLmqcBkkr4ns2oqYzuACinoRZrK1nU7QqR9jDw8MUAxE1RVzTlpolmw8sxqpPMJPHOIlwQRTaucpUCwTUYo+qG8wBLVTwEqIHFkB+t3J9OakzgAisXm7NjbzXhhS7yKgFa+XAeP/vpMVL4TSHiHECFxqZY8S3hrbgU3TD9LEZjUjNfjArcMrxRrkgMlEdeH3kyEiBuL4qBaPuyVv87RyFgFBVDBffMCwzsN7h5Pg+7zsUULAIKkRZzZcHsZmdcYj6KaNo8llVEukMd1QZWDllFRUqkZvfCKaJ8sU9ncl7QG//uXwYJr31wdv8bb8vQjMG9rOc8d0glml3ckJ+tnCaYXOoBhCrTT8UX5OFU504vAOQl+6wyGs2lhYW+vlEQsJlK/YAz/lGj8xGdTkhZqNxUSz5TCpG53jzl2SlmgT/G9tmmiDrEUNqDv3MJCOtbAiZNrx/0Mk5+b18+KTpQOoNbIFRbcON/lsqkNH4opk6FcT0BdoFdOcwQ/ESxeuMc4
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a54102ec-b007-41ed-e38e-08d824ed637f
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 16:22:07.0258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKnB8PBFRYtrAmEfxtlFL7AQxTuehAn+Rrm1CpL4ucdvMSxmimx7xnO0qHmu+aHZJypfBGD/wCuQm9VTSs5njg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2601
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Pablo Neira Ayuso <pablo@netfilter.org> writes:

>> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> >> index eefeb1cdc2ee..4fc42c1955ff 100644
>> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> >> @@ -404,7 +404,7 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
>> >>  static LIST_HEAD(mlx5e_block_cb_list);
>> >>
>> >>  static int
>> >> -mlx5e_rep_indr_setup_block(struct net_device *netdev,
>> >> +mlx5e_rep_indr_setup_block(struct Qdisc *sch,
>> >>  			   struct mlx5e_rep_priv *rpriv,
>> >>  			   struct flow_block_offload *f,
>> >>  			   flow_setup_cb_t *setup_cb,
>> >> @@ -412,6 +412,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
>> >>  			   void (*cleanup)(struct flow_block_cb *block_cb))
>> >>  {
>> >>  	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
>> >> +	struct net_device *netdev = sch->dev_queue->dev;
>> >
>> > This break indirect block support for netfilter since the driver
>> > is assuming a Qdisc object.
>>
>> Sorry, I don't follow. You mean mlx5 driver? What does it mean to
>> "assume a qdisc object"?
>>
>> Is it incorrect to rely on the fact that the netdevice can be deduced
>> from a qdisc, or that there is always a qdisc associated with a block
>> binding point?
>
> The drivers assume that the xyz_indr_setup_block() always gets a sch
> object, which is not always true. Are you really sure this will work
> for the TC CT offload?

I tested indirect blocks in general, but not CT offload.

> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -928,26 +928,27 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
>  }
>
>  static void nf_flow_table_block_offload_init(struct flow_block_offload *bo,
> -                                            struct net *net,
> +                                            struct net_device *dev,
>                                              enum flow_block_command cmd,
>                                              struct nf_flowtable *flowtable,
>                                              struct netlink_ext_ack *extack)
>  {
>         memset(bo, 0, sizeof(*bo));
> -       bo->net         = net;
> +       bo->net         = dev_net(dev);
>         bo->block       = &flowtable->flow_block;
>         bo->command     = cmd;
>         bo->binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
>         bo->extack      = extack;
> +       bo->sch         = dev_ingress_queue(dev)->qdisc_sleeping;
>         INIT_LIST_HEAD(&bo->cb_list);
>  }
>
>  static void nf_flow_table_indr_cleanup(struct flow_block_cb *block_cb)
>  {
>         struct nf_flowtable *flowtable = block_cb->indr.data;
> -       struct net_device *dev = block_cb->indr.dev;
> +       struct Qdisc *sch = block_cb->indr.sch;
>
> -       nf_flow_table_gc_cleanup(flowtable, dev);
> +       nf_flow_table_gc_cleanup(flowtable, sch->dev_queue->dev);
>         down_write(&flowtable->flow_block_lock);
>         list_del(&block_cb->list);
>         list_del(&block_cb->driver_list);
>
> Moreover, the flow_offload infrastructure should also remain
> independent from the front-end, either tc/netfilter/ethtool, this is
> pulling in tc specific stuff into it, eg.

Hmm, OK, so I should not have assumed there is always a qdisc associated
with a blocks.

I'm not sure how strong your objection to pulling in TC is. Would it be
OK, instead of replacing the device with a qdisc in flow_block_indr, to
put in both? The qdisc can be NULL for the "normal" binder types,
because there the block is uniquely identified just by the type. For the
"non-normal" ones it would be obvious how to initialize it.

> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index de395498440d..fda29140bdc5 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -444,6 +444,7 @@ struct flow_block_offload {
>         struct list_head cb_list;
>         struct list_head *driver_block_list;
>         struct netlink_ext_ack *extack;
> +       struct Qdisc *sch;
>  };
>
>  enum tc_setup_type;
> @@ -454,7 +455,7 @@ struct flow_block_cb;
>
>  struct flow_block_indr {
>         struct list_head                list;
> -       struct net_device               *dev;
> +       struct Qdisc                    *sch;
>         enum flow_block_binder_type     binder_type;
>         void                            *data;
>         void                            *cb_priv;
> @@ -479,7 +480,7 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
>                                                void *cb_ident, void *cb_priv,
>                                                void (*release)(void *cb_priv),
>                                                struct flow_block_offload *bo,
> -                                              struct net_device *dev, void *data,
> +                                              struct Qdisc *sch, void *data,
>                                                void *indr_cb_priv,
>                                                void (*cleanup)(struct flow_block_cb *block_cb));
>  void flow_block_cb_free(struct flow_block_cb *block_cb);
