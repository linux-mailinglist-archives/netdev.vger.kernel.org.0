Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BC32014EE
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 18:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394473AbgFSQP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 12:15:26 -0400
Received: from mail-eopbgr60073.outbound.protection.outlook.com ([40.107.6.73]:33411
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393578AbgFSQPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 12:15:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZOR1TjyRziC3N0nQ5W4Fx8lcngTh5mQR5eqMIygEoqKL/Z1YDeV5UxoU9hLH3Uqd+SBJaXm0O6AO5aQyvHYilmo/uw7WU0f7/oIGLW5YDQh4dZ0NZUGKBfLxGDkDSAMfXf9aX5W+IF+AqW67LpczyNBZvWajOiT68TBbTlN0cQlYNlBcs4Wv0mK/4pvN5xbiH+8EMf76pHA6kZgrZKtX5A7Dg+ttvOYzCmouMS/IvNucCWX9+ecylxOWH+ATjGkiiUB1YeciWQ6uYoYIe6ZhGht9jLS6QWSAMF4DMdqL456vZDDdlobJv+nv6aPIZ7JXUfOsIe3l6BM2HFGIIr1PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU/02ZpEMbkwDAIR3+PApVUrBDz01iDOurz2onq8FzA=;
 b=dljldcIqNUuDLjEc23WT0L/ImB7BvfDEEtvig9FzhXnEMHk+OR/ejYJaSlyE9gTbKPLzPfcit1jtsPmtP4zRlguA8gORKGg7PvkxH+vMIElEfD89APvcGpMl+rrY5I97uqHFd4lJHG03VKlmnxeE9/crqCNCi9xlzJMdrO/pW/ehurdVE03L94cCFK1sOGzHXx+uTf65kjAjPbgdX8ESHCpD2TKXfDd5ZvN3p+IUPJ0oECh+9zuqfus0uWvJgvctmMiUw09eZG294REWz9cS7DDMcbAkitmN0adeXUFiYZFtk/YQIe5FZCOatFcAZI772D0us/7bdwD8jLK/stfkrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU/02ZpEMbkwDAIR3+PApVUrBDz01iDOurz2onq8FzA=;
 b=YFYAlh+FfmcjzLOSWP37xxTdHGYGWRBnRWjd7m/B3HpOnnY9srm9rFg8av1NSp8Oh4iDdq4XdRBxZVpI6tgLKpA6VrIeH9MwkHDLkQMgbuqj2rC+BMvdEPJT+Uew2D2By+TJaT1cv9rDSbo2kW1M7yFYWH+HZUERRIyd0qGuVgY=
Authentication-Results: oneconvergence.com; dkim=none (message not signed)
 header.d=none;oneconvergence.com; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6914.eurprd05.prod.outlook.com (2603:10a6:20b:18e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Fri, 19 Jun
 2020 16:15:21 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::d067:e4b3:5d58:e3ab]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::d067:e4b3:5d58:e3ab%6]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 16:15:21 +0000
References: <20200619094156.31184-1-satish.d@oneconvergence.com> <20200619094156.31184-4-satish.d@oneconvergence.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     dsatish <satish.d@oneconvergence.com>
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, netdev@vger.kernel.org,
        simon.horman@netronome.com, kesavac@gmail.com,
        prathibha.nagooru@oneconvergence.com,
        intiyaz.basha@oneconvergence.com, jai.rana@oneconvergence.com
Subject: Re: [PATCH net-next 3/3] cls_flower: Allow flow offloading though masked key exist.
In-reply-to: <20200619094156.31184-4-satish.d@oneconvergence.com>
Date:   Fri, 19 Jun 2020 19:15:17 +0300
Message-ID: <vbfv9jn9gmi.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0030.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::17) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by ZR0P278CA0030.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 16:15:20 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 26f33e96-fcf6-4f8c-d368-08d8146bf70f
X-MS-TrafficTypeDiagnostic: AM7PR05MB6914:
X-Microsoft-Antispam-PRVS: <AM7PR05MB6914DF83C70AEAB3DAF868D6AD980@AM7PR05MB6914.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cdld+eO6XYi/DotYsdSJfN5loPX4cGlbL0VnUSyyboGiWZyIFqmxxnVQBcKtDs0vii2mxOq6xHMFY+FiwFiH5um83cJ5oiM13pIzGUt+56UXw/PUsH4gba0kgC2Rz/2bggxo8Hm/YENVa+pgdSDuPpYMRjTsmhwugdGRYaYNqL4Ba88WscarEgifd3O8Bc5E/zZya7VCfAwh65B4vqpnKH6t+Sexw87m/FgFVETqfmcG3UU1VRRSPcRhgVrQOPi1V8OzJVF4XG15tzSBZfzcdpgNTXHm+R67yPe3sw4wFMB7xY+IpoodKtbraX41Vz2cOjfeLI/27HlgGB2qoX8Qjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(66556008)(2616005)(66476007)(956004)(186003)(6666004)(5660300002)(26005)(2906002)(316002)(66946007)(6486002)(36756003)(8676002)(52116002)(16526019)(8936002)(7696005)(83380400001)(4326008)(478600001)(86362001)(6916009)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /x40q98nzdLYuAMe5aCDgMzNVKJjlCGpPn6rBr/NYi5324EMUkWC2YRZkNWxkJcqlj8ZT8kHmbcedYpnRse1oCJwhLnmoR5VxiLWNVIWYLq1DY0urJ/oKSzkA+d1ZwgTlgc7KJok5nUOsG9OplAoUco0YcFoeNahhg5KFJmJECKqU25OYFvwUmtO3C7njArM/uSMHB+06vosnDNx8gQPL6g8UWnwWT1L9ljucsI+KFMWnbpIZhoesg8887Efe7fmbN9yvt6h5lK+k/fPig/qBb7I0QkSCOoOUio/hyfyqIQxc11H+2bVdblUff/tnZ4A07bakomQhrVh+7SkKy8K9AkUCvUFKRdlpri8mN7nZyDYyH3flwDon62ZkJb69TucI1kn2fCNzdDWMIOa3KT6oYyBCGIxlhSWRK/whnosHAsDZpJHBJcnA5utSqZMIML4jUKi4NrThIrW1SMzFWR0wCvZGQMOK4/3SuTpCG8Gorw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f33e96-fcf6-4f8c-d368-08d8146bf70f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 16:15:21.5017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BEamcUGxbLWaIcpVPfQSSvSI54CWIBFExGPjzux2f0JVe/6pxDNUMT2z6LLuP9lEdx6ziRpls8YLJBofgj8DxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6914
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 19 Jun 2020 at 12:41, dsatish <satish.d@oneconvergence.com> wrote:
> A packet reaches OVS user space, only if, either there is no rule in
> datapath/hardware or there is race condition that the flow is added
> to hardware but before it is processed another packet arrives.
>
> It is possible hardware as part of its limitations/optimizations
> remove certain flows. To handle such cases where the hardware lost
> the flows, tc can offload to hardware if it receives a flow for which
> there exists an entry in its flow table. To handle such cases TC when
> it returns EEXIST error, also programs the flow in hardware, if
> hardware offload is enabled.
>
> Signed-off-by: Chandra Kesava <kesavac@gmail.com>
> Signed-off-by: Prathibha Nagooru <prathibha.nagooru@oneconvergence.com>
> Signed-off-by: Satish Dhote <satish.d@oneconvergence.com>
> ---
>  net/sched/cls_flower.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index f1a5352cbb04..d718233cd5b9 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -431,7 +431,8 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
>
>  static int fl_hw_replace_filter(struct tcf_proto *tp,
>  				struct cls_fl_filter *f, bool rtnl_held,
> -				struct netlink_ext_ack *extack)
> +				struct netlink_ext_ack *extack,
> +				unsigned long cookie)
>  {
>  	struct tcf_block *block = tp->chain->block;
>  	struct flow_cls_offload cls_flower = {};
> @@ -444,7 +445,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
>
>  	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
>  	cls_flower.command = FLOW_CLS_REPLACE;
> -	cls_flower.cookie = (unsigned long) f;
> +	cls_flower.cookie = cookie;
>  	cls_flower.rule->match.dissector = &f->mask->dissector;
>  	cls_flower.rule->match.mask = &f->mask->key;
>  	cls_flower.rule->match.key = &f->mkey;
> @@ -2024,11 +2025,25 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>  	fl_init_unmasked_key_dissector(&fnew->unmasked_key_dissector);
>
>  	err = fl_ht_insert_unique(fnew, fold, &in_ht);
> -	if (err)
> +	if (err) {
> +		/* It is possible Hardware lost the flow even though TC has it,
> +		 * and flow miss in hardware causes controller to offload flow again.
> +		 */
> +		if (err == -EEXIST && !tc_skip_hw(fnew->flags)) {
> +			struct cls_fl_filter *f =
> +				__fl_lookup(fnew->mask, &fnew->mkey);

You don't hold neither rcu read lock nor reference to the "f" filter
here, which means it can be concurrently destroyed at any time.

> +
> +			if (f)
> +				fl_hw_replace_filter(tp, fnew, rtnl_held,
> +						     extack,
> +						     (unsigned long)(f));
> +		}

It looks like you are inventing filter replace/overwrite functionality
here. However, such functionality is already supported. fl_change()
receives "fold" via "arg" argument, if filter with specified key exists
in classifier instance and NLM_F_EXCL netlink message flag is not set.

>  		goto errout_mask;
> +	}
>
>  	if (!tc_skip_hw(fnew->flags)) {
> -		err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack);
> +		err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack,
> +					   (unsigned long)fnew);
>  		if (err)
>  			goto errout_ht;
>  	}
