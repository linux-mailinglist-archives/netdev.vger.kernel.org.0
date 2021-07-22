Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F983D247A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbhGVMiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:38:46 -0400
Received: from mail-dm6nam10on2114.outbound.protection.outlook.com ([40.107.93.114]:37313
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232035AbhGVMio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 08:38:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8MGG1GM4nchu0HkkM0BME5uQMEsw7lPJtFMhdEo8mSoDyLi2RoWit+EzHhhlnz9+uGRBaIVRT+wJYnrCSvmyY92ed2FIvB7PjW6a14LpSIPsnbk5HaztOPN03N5cuYadTuz8ccNsm2L+o6dlKiqqqAWa6NOnK9JfOdDSSzAb1ZdDuGlA/c2Ko929efB/uNl4teSKlBdV3JGuc+wI0vHC9m4AcMPUk6StZOWxUXlF64m4iPPEkEo+p/Rx/92mohuD4zw4e3eCWaDjVdI+VuMnNTo03WRyC0yO9KIDO4wKeAOVDv+/VhJ1xs89NniskDibpwz9I1iJxeuOhDKhz1GbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5Hpq+QpnUDMoT8wkkB+XToexUjGm0r1QEK0PdIYZRg=;
 b=DSxWm8v2lr1d1JNxoXeUxW1ENoyetlNNyHJmNc7kwR5p5u5AdL3qykvZuBYY+vGwxHZtUUaBtHRpwKa5ZfQByXFipTZcCQV9FCA4KoypJrx8j3Ow71suuf+raaKfaOVzAsro5dbEpvsM+HsY1b+NtkY5AldnU0nedRhtIqyLPrkOmaGjLPTzPnk41zAYN2ysOmfor7VWH8xSWCYp4jj59Pm7oJ5Uq+vsqs3DTLm1RNLbE7ovQKYhdYFl08HL6U28+v7x2VsH/HYFjd9MEbsTDCWWbYvYDCbYOcs7pUgnLpRrB8NkgRI0dDBVJJiTPI5rHOCocOFMZU2tS4OnS+SbpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5Hpq+QpnUDMoT8wkkB+XToexUjGm0r1QEK0PdIYZRg=;
 b=hxSmiecD9DUEcmVEuGicooB6gZ1rtbOQtvob+2CJX0DegrtIrjDHhJvX1+MeWVSRJ8WFZ9qauzJO/Gth7ZOz6o7zLJfMjBWjohc2bpyHIThSPkjufNdrj1pPk22ULmWish0K4pUYNVrJVOYxhB8iX5tTvTm76ynQF1d12oYonVA=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5035.namprd13.prod.outlook.com (2603:10b6:510:75::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7; Thu, 22 Jul
 2021 13:19:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 13:19:17 +0000
Date:   Thu, 22 Jul 2021 15:19:11 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
Message-ID: <20210722131909.GB31574@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <2b7f3729-2f87-881b-6b1f-d21ed2df3b20@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b7f3729-2f87-881b-6b1f-d21ed2df3b20@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR02CA0033.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::46) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR02CA0033.eurprd02.prod.outlook.com (2603:10a6:208:3e::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 13:19:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13d264f9-583e-4078-8e79-08d94d134ed9
X-MS-TrafficTypeDiagnostic: PH0PR13MB5035:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB5035EE15644CD27A63093407E8E49@PH0PR13MB5035.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iaf3XOLoFGriSwWc+7G7qDdytVmDAk4RC8cmhKr9QhAl8jPv6MzbMCtiL/7+un5FTfhznnpifdWaqE81e1Vl3tHsMwMtyDgvUSEN6BCFXwcRurueFLuWGnqYsDXkR+gfOp/Pq8zFe1ytgm7FLlyYQEnHugZr1btCfMRQeIqMBeU3GNy6PYaH7Wo4o7roYUxB8IMt4izrK/L3auYbjmqxb27i2akaqKK/QRYt2NDbEUvSSYp3Ccpqc3Txqu10opP3ztf3OhAvAweZ1RXefYcnxgkDX8nFJA5Ax/LDOIEtEO8cFIE3iCzciTQrFRFG2MyKCAjcYjIcGgXkhWwxELwFz5IUgjQQvEcKAOkjZHYzj9IhkUYj/MEr3jnXy6Jiw5RMMf6HdWlNAkPyGqrukr1KlBr5y255VIxn/h8dFHrDXb9cfDpsB8tvGLdtlBph5EaIycLHqxrFMhuqwlJrHK5R3zoG421v85E45Mbq3EGxzsmOLvPWovCTlk3gS+rebUgkwHTltv1WAod9LI7cv6m7HjAg4W6S1krHXMkvMhC4aaQj8vBdlbwTWCOeo3wiDp3HyraAeZd/OBOFPyyQQ8eyZ3JxPtJuZ0qbq1kE6RZssCzRcNvWUrfe0DZK3A0RV7R7IsprfUD/dqrQpJgBYASKUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39840400004)(136003)(376002)(396003)(366004)(66556008)(66476007)(44832011)(478600001)(2616005)(38100700002)(54906003)(6666004)(1076003)(86362001)(6916009)(8886007)(8936002)(36756003)(8676002)(55016002)(66946007)(107886003)(186003)(5660300002)(4326008)(7696005)(52116002)(316002)(53546011)(83380400001)(2906002)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pTRUE33KgKe3VakUP8MxnB/MUny0iSdSh/alk7NEwb/G9kvyhs4pxedHJjiF?=
 =?us-ascii?Q?+kB/i8eu2VqlCieOFR3d+AfDMUscF5OOEqJjfD5MbbHQRdiYOsw8LRk1ROJN?=
 =?us-ascii?Q?rqs8ivELi5CtM2yv8YBayi+4ZcS2bxln6XFUCNJujh7T/vmrYPGVQB4ebi03?=
 =?us-ascii?Q?9q5uwxSU0EsVsuAMzeZEyiGvvlA6syRnyzA98VZhDLJQNwv43g1O2P1Y/6Qw?=
 =?us-ascii?Q?mkOvm1zDRBYEtYnbaLvA/QJirMEYhlb0iwISje2bOxlqd9vbWnuTPCopn6Ve?=
 =?us-ascii?Q?p2y5RFKzmPKESxfUsIUspRNl7V2D3Mv8iQ5rWhDTsPdWSTu5rbQphsyG8TEQ?=
 =?us-ascii?Q?tIBdbUuahOLOZD6p2J854lfPZGUcgURpVWttSJCZbvEUJnXMdosJuINAEIHB?=
 =?us-ascii?Q?rAYW9RbJk4DUDDiOOGLXdW3G1Q3UzqxPMF/NqUbKTO7UVe/V8itLP25OPlAy?=
 =?us-ascii?Q?Qljn75lbVjWOwZG89TWDr//JmT9NJH+ipwC+mj6QnwwGkRSWsS621yT+b1x9?=
 =?us-ascii?Q?E5275TtamSpiRm/H5/mUP9EjLwYTQwtylh5ouoNAtKYV32Sh4Q2r3ajENXBi?=
 =?us-ascii?Q?OB7FCDsPdAlY3p/Pyo5QKnE/6P72cmGeApY8zERy+XKfQRZyoECg7NLfxfAF?=
 =?us-ascii?Q?yflNa+XeG7wAdiepCi+uG2Kd9S7TT1K6aLyToGrLq4gwp79tRexrfSjm+/as?=
 =?us-ascii?Q?yLlnlASKsJQewMnAFnqFoB/uFOJGJLDzuNDYHdssc60Dych5pBkCd8rv7YVX?=
 =?us-ascii?Q?PIUJFoiSYSjZRqYaSzMPKPxo9FhxQR3gWfg+LewrSRYUBGMmdwDDwI0YoA0P?=
 =?us-ascii?Q?N0Ca8s2a9TpISo3XR4g876BwVKrNXIE7gkmW5dCs7b1hzEzqzS9/XoZnc6B5?=
 =?us-ascii?Q?ZzAmEsfrT6zwYrPqKgJijLzC66gLE/ka6JvFiG9R7ELpUKy0zpGEsFgtS6mC?=
 =?us-ascii?Q?LGhtrII2bzSk07cmrUuv2G6tJd1OmC9dCqwj/JTnLm0SzDdovoDYtv+0YgB+?=
 =?us-ascii?Q?5XSc+X7PWRZoYYSThroBiONicd1/ps9UR9twtw74p3pq4HYBxR6L79ICeEk5?=
 =?us-ascii?Q?6PMYxirOoEeQg1It8NhyQS0YBF08bROUDGD0D70qdvVLmcSw3oH0rJMWs1wE?=
 =?us-ascii?Q?l1GAh1dd4Wz1X8vAXQ4wEprcHvFm+ApAUd8cn2jd2pcP1Va/KWdGSJkRLaAU?=
 =?us-ascii?Q?+R9Idx0vAtTJuA+qzaIGW56wwxZBI4qnYrRbopljDXKR5Wl29YjXg3egLNV/?=
 =?us-ascii?Q?NKnqhGzMkR8tvdyAKmc92T+BpHfeL/9ndKZE4w9JKkf8OkDe88lnPegjeHve?=
 =?us-ascii?Q?qNrO+IN/9r/rY5RWkd/9S7DRWxMsspGsJZMOiDpEnIYAVxaNzxfRmCOAsr+S?=
 =?us-ascii?Q?fRJQdo4q7y9Jsibyh1+it5TBjlSo?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d264f9-583e-4078-8e79-08d94d134ed9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 13:19:17.3209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKVGQe9hPEZ5kqF0ZQQ4SgOeMPsMiBl0zW0MUfcnYPsB2WSxi9Ib6H1UcTwrOhYshwq9z43eSA60KL1xuONHcmzMGb3DREAfpRyi0qlXS6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 03:24:07PM +0300, Roi Dayan wrote:
> 
> 
> On 2021-07-22 12:19 PM, Simon Horman wrote:
> > From: Baowen Zheng <baowen.zheng@corigine.com>
> > 
> > Use flow_indr_dev_register/flow_indr_dev_setup_offload to
> > offload tc action.
> > 
> > We offload the tc action mainly for ovs meter configuration.
> > Make some basic changes for different vendors to return EOPNOTSUPP.
> > 
> > We need to call tc_cleanup_flow_action to clean up tc action entry since
> > in tc_setup_action, some actions may hold dev refcnt, especially the mirror
> > action.
> > 
> > As per review from the RFC, the kernel test robot will fail to run, so
> > we add CONFIG_NET_CLS_ACT control for the action offload.
> > 
> > Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> > Signed-off-by: Louis Peens <louis.peens@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > ---
> >   drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
> >   .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  3 ++
> >   .../ethernet/netronome/nfp/flower/offload.c   |  3 ++
> >   include/linux/netdevice.h                     |  1 +
> >   include/net/flow_offload.h                    | 15 ++++++++
> >   include/net/pkt_cls.h                         | 15 ++++++++
> >   net/core/flow_offload.c                       | 26 +++++++++++++-
> >   net/sched/act_api.c                           | 33 +++++++++++++++++
> >   net/sched/cls_api.c                           | 36 ++++++++++++++++---
> >   9 files changed, 128 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> > index 5e4429b14b8c..edbbf7b4df77 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> > @@ -1951,7 +1951,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
> >   				 void *data,
> >   				 void (*cleanup)(struct flow_block_cb *block_cb))
> >   {
> > -	if (!bnxt_is_netdev_indr_offload(netdev))
> > +	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
> >   		return -EOPNOTSUPP;
> >   	switch (type) {
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> > index 059799e4f483..111daacc4cc3 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> > @@ -486,6 +486,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
> >   			    void *data,
> >   			    void (*cleanup)(struct flow_block_cb *block_cb))
> >   {
> > +	if (!netdev)
> > +		return -EOPNOTSUPP;
> > +
> >   	switch (type) {
> >   	case TC_SETUP_BLOCK:
> >   		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
> > diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> > index 2406d33356ad..88bbc86347b4 100644
> > --- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
> > +++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> > @@ -1869,6 +1869,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
> >   			    void *data,
> >   			    void (*cleanup)(struct flow_block_cb *block_cb))
> >   {
> > +	if (!netdev)
> > +		return -EOPNOTSUPP;
> > +
> >   	if (!nfp_fl_is_netdev_to_offload(netdev))
> >   		return -EOPNOTSUPP;
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 42f6f866d5f3..b138219baf6f 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -923,6 +923,7 @@ enum tc_setup_type {
> >   	TC_SETUP_QDISC_TBF,
> >   	TC_SETUP_QDISC_FIFO,
> >   	TC_SETUP_QDISC_HTB,
> > +	TC_SETUP_ACT,
> >   };
> >   /* These structures hold the attributes of bpf state that are being passed
> > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > index 69c9eabf8325..26644596fd54 100644
> > --- a/include/net/flow_offload.h
> > +++ b/include/net/flow_offload.h
> > @@ -553,6 +553,21 @@ struct flow_cls_offload {
> >   	u32 classid;
> >   };
> > +enum flow_act_command {
> > +	FLOW_ACT_REPLACE,
> > +	FLOW_ACT_DESTROY,
> > +	FLOW_ACT_STATS,
> > +};
> > +
> > +struct flow_offload_action {
> > +	struct netlink_ext_ack *extack;
> > +	enum flow_act_command command;
> > +	struct flow_stats stats;
> > +	struct flow_action action;
> > +};
> > +
> > +struct flow_offload_action *flow_action_alloc(unsigned int num_actions);
> > +
> >   static inline struct flow_rule *
> >   flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
> >   {
> > diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> > index ec7823921bd2..cd4cf6b10f5d 100644
> > --- a/include/net/pkt_cls.h
> > +++ b/include/net/pkt_cls.h
> > @@ -266,6 +266,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
> >   	for (; 0; (void)(i), (void)(a), (void)(exts))
> >   #endif
> > +#define tcf_act_for_each_action(i, a, actions) \
> > +	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
> > +
> >   static inline void
> >   tcf_exts_stats_update(const struct tcf_exts *exts,
> >   		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
> > @@ -536,8 +539,19 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
> >   	return ifindex == skb->skb_iif;
> >   }
> > +#ifdef CONFIG_NET_CLS_ACT
> >   int tc_setup_flow_action(struct flow_action *flow_action,
> >   			 const struct tcf_exts *exts);
> > +#else
> > +static inline int tc_setup_flow_action(struct flow_action *flow_action,
> > +				       const struct tcf_exts *exts)
> > +{
> > +		return 0;
> > +}
> > +#endif
> > +
> > +int tc_setup_action(struct flow_action *flow_action,
> > +		    struct tc_action *actions[]);
> >   void tc_cleanup_flow_action(struct flow_action *flow_action);
> >   int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> > @@ -558,6 +572,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
> >   			  enum tc_setup_type type, void *type_data,
> >   			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
> >   unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
> > +unsigned int tcf_act_num_actions(struct tc_action *actions[]);
> >   #ifdef CONFIG_NET_CLS_ACT
> >   int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
> > diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> > index 715b67f6c62f..0fa2f75cc9b3 100644
> > --- a/net/core/flow_offload.c
> > +++ b/net/core/flow_offload.c
> > @@ -27,6 +27,27 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
> >   }
> >   EXPORT_SYMBOL(flow_rule_alloc);
> > +struct flow_offload_action *flow_action_alloc(unsigned int num_actions)
> > +{
> > +	struct flow_offload_action *fl_action;
> > +	int i;
> > +
> > +	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
> > +			    GFP_KERNEL);
> > +	if (!fl_action)
> > +		return NULL;
> 
> Hi Simon,
> 
> Our automatic tests got a trace from flow_action_alloc()
> introduced in this series.
> I don't have specific commands right now but maybe its easy
> to reproduce with option CONFIG_DEBUG_ATOMIC_SLEEP=y
> 
> fl_dump->fl_hw_update_stats->fl_hw_update_stats->tcf_exts_stats_update
>   ->tcf_action_update_hw_stats->tcf_action_offload_cmd_pre->
>     ->flow_action_alloc
> 
> Thanks,
> Roi

Thanks Roi,

we'll look into this.
