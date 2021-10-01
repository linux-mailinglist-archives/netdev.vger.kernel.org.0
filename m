Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F235A41F37D
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354975AbhJARrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:47:11 -0400
Received: from mail-dm6nam08on2049.outbound.protection.outlook.com ([40.107.102.49]:17959
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229642AbhJARrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 13:47:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYl74xwzWKauAXZVJoF8dhuzvcLt96G1V40P1pJXBc9EEXvKT20G8suzUM1DS+UdukXvn19goJwP+8MFXhY3bnb//eOO3KRCLuRq2QT1z4wctNJslB3xO+Fl2QF3K12Kv6rGIlB2KvFkrDVbYeLEMdrP5c8cxy81qU65nWRyXqpBm5bqv1OBd3R1tqJtQ/UVNCOuhPMB8roSnQrTpUkuY5VQ0ymaZqscL38Ub14fO5hekqCgRbg76UjGaPG6CVR3L23RKR3zO+W9obwNi9kGhmHNA58jVqsfi9jKGSB/DE7MjRWB2OQ3ZxWcWiMvocEZeqlmCWjnBzwyWou0QiL1JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EP9CLTTghV2y3h4EmvAr0U8eyqTmSu5+aO4eSwejEAo=;
 b=apJiqniBtxIskbVc3qrOrQyriJXFBTw7Lxf5Nj4eg2EplpX6cDCdHqW10IQ/8gfcdGx/9UFuTCPXi/A6f984ROOhz1k3Bc7VARsQfYDyCk9EunHojl5xj+tYLu4Snr3Mw1ZSUuEJxHvyP/EauxqKtVAlk+eiJNPBU0IkTUxfkKrWuz5zloivYo+t/1CKkLvuNbH3xGyLax/UNtbh0EY8zxS7swVzqFezv+SoLkOcA2TOoQ7iZ4F61UuQPphDM6MY6/8xS7M7BtmjXMVyzWPSh3MmmfLgtFEfvCjtqNO+0eLmGKyARHzDdboU5/ngLKiqS/tl2wbX5pDvxpeDPbcUeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EP9CLTTghV2y3h4EmvAr0U8eyqTmSu5+aO4eSwejEAo=;
 b=g4qlMFjka7/eLKW043BCmxyu8mJWOsGf7V6SG7vT9g3OXEDrQz2WcS0BApGz1x+LAkL4Jfjn2ualKqR6WL2X6ljKGWv5T0oV/kGWUEaAUp98uddJg0+PEBi4VWI8kjxELWufzYqrqWbLpYfRfkIXsoSpoxu02j8XCKYPLQqN3rsXwtRB69gqsx/Juvc05CqNgNfKzN5LKSmi2EYx0FHNFPfXthLcUWPwurA9KOgZTdYrAIo2kZdAYOgZcPB+DYUs7UrwTHMp/D49t6IJeBidv6zQXRpyGA95BHceu7KpLpP8f6/323SuWo2XMluvaoQA/i6Besiz/30muzZIgi5jWg==
Received: from BN9P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::12)
 by DM5PR12MB1737.namprd12.prod.outlook.com (2603:10b6:3:10e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 1 Oct
 2021 17:45:24 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::f2) by BN9P220CA0007.outlook.office365.com
 (2603:10b6:408:13e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend
 Transport; Fri, 1 Oct 2021 17:45:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 17:45:23 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 1 Oct 2021 17:45:20 +0000
References: <20211001113237.14449-1-simon.horman@corigine.com>
 <20211001113237.14449-6-simon.horman@corigine.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [RFC/PATCH net-next v2 5/5] flow_offload: validate flags of
 filter and actions
In-Reply-To: <20211001113237.14449-6-simon.horman@corigine.com>
Date:   Fri, 1 Oct 2021 20:45:18 +0300
Message-ID: <ygnhh7e0bpw1.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67790742-e71a-4002-9b7c-08d985033f0b
X-MS-TrafficTypeDiagnostic: DM5PR12MB1737:
X-Microsoft-Antispam-PRVS: <DM5PR12MB173727811BEA22096BDCED95A0AB9@DM5PR12MB1737.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:327;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iRcdKH+SZuyxtWo2VnLC8vwupy1YNLO9Q6kJzfCF1Un9tB/KKHzwWXHsqxGyLDLYCAtvRo7Pjpat3PTqPe/ErhUGj3J0g2zPQ+Y9Q32Kixvf+fQCLWL8erxCtNlK6BIPMBcO6ei9DXtqTOgPH2eo26TlT7pARf7hNZ/qBWGmExiDRkqYpOY/Bh6J8w5MKmbllxDpP87gCOQHxensgv5+Vory9TydThyZHU2DYwr4ce3MF7fRdvjCfFtcUyaC0AXS7OMtlsReAdmq7MSBGx/Lz4+XH18D9iNuYqg65zoK2TQil8ljd0FGE22LNeUKDEPOof02Gcb7R988CUWE9XAg7iBFWsdmT6Zym2xxybkazU0EygHa0HZ3eR1V8CM+JTaJ8kU95iihW75Si+xKjJywpr+zh1TpBszZ3Ng3KDiAbqO9HOuknOFXBBIWSSxhRTcR8jF3A9TzQs2fbjrpCQetCao0vaR90cLRwVu/zkDi9FjD0WWG+CgBVFez1unTLHRzA9WlwB3q8EnzfcmU3VmWQ3wtDbwJjKnFWITxL7z1vXPiY+baHVnzjEBgASdiFPXpIgA6JOnjSpTMgJP1Nb7fOO867aRmSj/3TFclvUe9pHVSLKk+nURmcgX5aZ5rLxOzNJL8wRvEShwr9d5zJpHHM4KxNc+sZ7OSolinDDGS1J20Mp8OU/mLWdwTizYLq/q+wggirmUwi4jJs3UIo9HGPg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(83380400001)(2616005)(7636003)(316002)(15650500001)(54906003)(6916009)(508600001)(4326008)(47076005)(8936002)(356005)(8676002)(26005)(82310400003)(86362001)(186003)(36756003)(7696005)(16526019)(2906002)(426003)(336012)(5660300002)(70206006)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 17:45:23.7070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67790742-e71a-4002-9b7c-08d985033f0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1737
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 01 Oct 2021 at 14:32, Simon Horman <simon.horman@corigine.com> wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> Add process to validate flags of filter and actions when adding
> a tc filter.
>
> We need to prevent adding filter with flags conflicts with its actions.
>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  include/net/pkt_cls.h    | 32 ++++++++++++++++++++++++++++++++
>  net/sched/cls_flower.c   |  5 +++++
>  net/sched/cls_matchall.c |  6 ++++++
>  net/sched/cls_u32.c      | 11 +++++++++++
>  4 files changed, 54 insertions(+)
>
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index 5c394f04feb5..2d51bed434d2 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -735,6 +735,38 @@ static inline bool tc_in_hw(u32 flags)
>  	return (flags & TCA_CLS_FLAGS_IN_HW) ? true : false;
>  }
>  
> +/**
> + * tcf_exts_validate_actions - check if exts actions flags are compatible with
> + * tc filter flags
> + * @exts: tc filter extensions handle
> + * @flags: tc filter flags
> + *
> + * Returns true if exts actions flags are compatible with tc filter flags
> + */
> +static inline bool
> +tcf_exts_validate_actions(const struct tcf_exts *exts, u32 flags)
> +{
> +#ifdef CONFIG_NET_CLS_ACT
> +	bool skip_sw = tc_skip_sw(flags);
> +	bool skip_hw = tc_skip_hw(flags);
> +	int i;
> +
> +	if (!(skip_sw | skip_hw))
> +		return true;
> +
> +	for (i = 0; i < exts->nr_actions; i++) {
> +		struct tc_action *a = exts->actions[i];
> +
> +		if ((skip_sw && tc_act_skip_hw(a->tcfa_flags)) ||
> +		    (skip_hw && tc_act_skip_sw(a->tcfa_flags)))
> +			return false;
> +	}
> +	return true;
> +#else
> +	return true;
> +#endif
> +}
> +

There is already a function named tcf_exts_validate() that is called by
classifiers before this new one and is responsible for action validation
and initialization. Having two similarly-named functions is confusing
and additional call complicates classifier init implementations, which
are already quite complex as they are. Could you perform the necessary
validation inside existing exts initialization call chain?

>  static inline void
>  tc_cls_common_offload_init(struct flow_cls_common_offload *cls_common,
>  			   const struct tcf_proto *tp, u32 flags,
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index eb6345a027e1..15e439349124 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -2039,6 +2039,11 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>  	if (err)
>  		goto errout;
>  
> +	if (!tcf_exts_validate_actions(&fnew->exts, fnew->flags)) {
> +		err = -EINVAL;
> +		goto errout;
> +	}
> +
>  	err = fl_check_assign_mask(head, fnew, fold, mask);
>  	if (err)
>  		goto errout;
> diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
> index 24f0046ce0b3..89dbbb9f31e8 100644
> --- a/net/sched/cls_matchall.c
> +++ b/net/sched/cls_matchall.c
> @@ -231,6 +231,11 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
>  	if (err)
>  		goto err_set_parms;
>  
> +	if (!tcf_exts_validate_actions(&new->exts, new->flags)) {
> +		err = -EINVAL;
> +		goto err_validate;
> +	}
> +
>  	if (!tc_skip_hw(new->flags)) {
>  		err = mall_replace_hw_filter(tp, new, (unsigned long)new,
>  					     extack);
> @@ -246,6 +251,7 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
>  	return 0;
>  
>  err_replace_hw_filter:
> +err_validate:
>  err_set_parms:
>  	free_percpu(new->pf);
>  err_alloc_percpu:
> diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> index 4272814487f0..8bc19af18e4a 100644
> --- a/net/sched/cls_u32.c
> +++ b/net/sched/cls_u32.c
> @@ -902,6 +902,11 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
>  			return err;
>  		}
>  
> +		if (!tcf_exts_validate_actions(&new->exts, flags)) {
> +			u32_destroy_key(new, false);
> +			return -EINVAL;
> +		}
> +
>  		err = u32_replace_hw_knode(tp, new, flags, extack);
>  		if (err) {
>  			u32_destroy_key(new, false);
> @@ -1066,6 +1071,11 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
>  		struct tc_u_knode __rcu **ins;
>  		struct tc_u_knode *pins;
>  
> +		if (!tcf_exts_validate_actions(&n->exts, n->flags)) {
> +			err = -EINVAL;
> +			goto err_validate;
> +		}
> +
>  		err = u32_replace_hw_knode(tp, n, flags, extack);
>  		if (err)
>  			goto errhw;
> @@ -1086,6 +1096,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
>  		return 0;
>  	}
>  
> +err_validate:
>  errhw:
>  #ifdef CONFIG_CLS_U32_MARK
>  	free_percpu(n->pcpu_success);

