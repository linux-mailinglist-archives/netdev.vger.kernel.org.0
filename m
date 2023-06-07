Return-Path: <netdev+bounces-8741-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8D27257D6
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F389D2812AA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC6646B7;
	Wed,  7 Jun 2023 08:34:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E53E653
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:34:38 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2108.outbound.protection.outlook.com [40.107.244.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962A010F8
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:34:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDmg+m4TQLfQYBboZkKwZ/7Nz3WWgH15P1a6mgTwlgo/M418phgYgnI8HkMG6ljf4K+4QPXlIcwVfcEB5Q6Q4TVMDIj/PlP2eVEqPrczcgVpnSp4m6RaTn1jkycmbE19zymT9lTlVGgHz3Es7qlNbjgjGxuopS7JhDXIQfTyA58v+Orhj9QH2XwyBRIVEFtrWnB57zft9RFYUxDhnXKvZM+BAV6vRkgojiBTWd7RZMD4PLMlA4EmIRh1ShLxQcCVB0cPMzXUYFS0rtdGfyQYHiO7jtjDtaO7l40n9MN/Vb6YA+gaGKt1Is7rnKYmFAkhQC48pDN1lXu6Y6/OdYjUkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCsqpCJ+M3snw4ASXmnhyurrKU2QsZWWQJA2WE1HjT0=;
 b=XnsjET8fSxyrNuAL24+gBAaFfEETyDAHplRiYA0XjpmKrIQbhlAGwETckrNOf0+89OPnA2OZATsM7nJgpuXXEunkY4AIYL4tjnWBTXh2uijzEz9g4/GigNao5G5cCW0iiZOv7bIhdGYH9UWebfKxqf3bTJIsulqXNCmW43fbMi/Dk3X86YPUBEjoX8/u/MsJIS7KaOZZAXJz96wRgzPP5pPp76auhfrKq84RinmTOmcW/JxNI+zUIat8Jtkr85aT0955bIpWQh2JfHMx8a3GUoM/hIARDy0ODy+PcCuRnjaaUooYmYsbbUouriCYt8xXim1nYJjhzFvHQy8RcPzsRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCsqpCJ+M3snw4ASXmnhyurrKU2QsZWWQJA2WE1HjT0=;
 b=nr20g2pLj8SOJIoRTS+xRfbcp6qaWhuIe22hNYiOiTKUVv8aRLqKbCGOr+uOW07I5WXR3RplUbRfos5eRGcXmqpti6zc+0Fk/igs9q3J1EVu+WlD+mk+mwEE01P4pSg5SLU6eTtauhKcO/ri4tzunPiFUCDOq7ZmYaasiw3e+No=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV8PR13MB6373.namprd13.prod.outlook.com (2603:10b6:408:189::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 08:34:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 08:34:22 +0000
Date: Wed, 7 Jun 2023 10:34:16 +0200
From: Simon Horman <simon.horman@corigine.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next 5/6] sfc: neighbour lookup for TC encap action
 offload
Message-ID: <ZIBBCD7UPbaSdFLb@corigine.com>
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
 <286b3685eabf6cdd98021215b9b00020b442a42b.1685992503.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <286b3685eabf6cdd98021215b9b00020b442a42b.1685992503.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AS4PR09CA0006.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV8PR13MB6373:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d7ec352-bf34-4fea-2856-08db6731fec4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+j7DD946ngbZy1nzb3cMXwZka6JfnXW/OtbSbOKaCn4ljNl/sNaAu24NW6ZqNJBJYlE1G5EvH7JNuRdp+f7PqopIZZ5HqRZzRu8bTE8ZhB5J9PcbuYuvAeSYEIfUn6ASaO//uRzGyJvopUYbTdXkOGKQmjzo5xK+L2Qb5D90ACqf6kUP+zYkqWQD7/wMqpMSWrc+5C9OYdTQDiI7HOXZ7BdcP1NUOHCbLI7y8qXjNQRR/Oy/7rmHjk+Qf6ft922sXghHPkrhm22iLzu11lDN6kwfTGbvnKY309JXg1/0cGVOKlwoTSnsHdU61CSmAiQlnMHf9OoBK5sD/LOkaoeQ1ZKKJ/HeKgmCFAzsf4TfrYDqaDCGUHNyYILSgpQjKYFdKJ6cEsl3nf/bqyaMp0FjyMcSpR9i3HWA37whebWlohiImHXyifISdGyLLYZKobosqYT+3zM+7JRmuO4/pjJQR0320BkiGf40oycBb6B4ZRVUPIgtXHnrel2YokAqRu19xughZ5l4NqsU8R6NzDtyCzl/gk8mJdxh6413Vgr2ZUyF+qPRHCXVnr+XtynmFgf6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(346002)(39840400004)(376002)(451199021)(6506007)(6512007)(36756003)(83380400001)(86362001)(38100700002)(2616005)(186003)(8936002)(41300700001)(44832011)(2906002)(6916009)(478600001)(66946007)(8676002)(4326008)(316002)(5660300002)(66476007)(6486002)(66556008)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Grawc1HNLmWMdKexcVU5VwNgBENFb1q+k5A0Mvee/Ykbzd2qLDkyFESohsGT?=
 =?us-ascii?Q?q3tKmNBTCLf/zjY2etdSfQqw0E/847q9GOGRujo7Q3jcfNu3l9XjRSdkobn7?=
 =?us-ascii?Q?3DLUHmMpfL0V+8KFCkF7XerVRcXHYS7XkupqdduUyBfmFf4IdlYgjLZ4KGP/?=
 =?us-ascii?Q?1M43ABcM33Z/kcpx76UtbgQT3HH8z4IeMM4j9qmrK05EGRUIDXto/WFDv9Hx?=
 =?us-ascii?Q?VBz/o+hz3tikWM0YU6M5wdm3pUq5GGcAy/C0XqFB43rERT/+7axbyrKycVHG?=
 =?us-ascii?Q?KB1yV59G0+tFw3P3EZs/vQ4BkY5CYWaMceK5kVh+6N3476HI6mDix43fUO/d?=
 =?us-ascii?Q?EmVhC86lv4ONS9z3jaR+54oqOwUQhSqI2NyK5D6t3EenTjA92Xq3gitETfj4?=
 =?us-ascii?Q?VJHQQAxgF/hmev2567KAdXkCaK773y9MS1tyWDrjFI4Czg0uPhKhMV1JiD2c?=
 =?us-ascii?Q?lMrqqnpq8Rcs/mkvWBn4EILNGAvC8p22ajY/fJ/HhTlT7BHvZfObub2R5Z7u?=
 =?us-ascii?Q?tlne519pipm1e0nZQpxfWDp/LMb65uX3fBTOTLGhWvfsRxjeQeCA5IlCbt6n?=
 =?us-ascii?Q?obSJetELkdbJH4tWCUWohnrw3bgr6sMglKSPzOIEa4EkJMig1LFQtb63h7rL?=
 =?us-ascii?Q?c2LJCiu0cI4c9fGRp9dqh0o/q4SrYOonXn/IGpr9bS78lZaBhFY5ry7Ok6kG?=
 =?us-ascii?Q?4WlDGqZPX2SopdnMtI22AKWuk4NuWz4QsY2DlsGHazl3enFCczIzMrbJW1wB?=
 =?us-ascii?Q?crW+mpeFWqDMHThPaPc8GVwB7P9fYG8nt5ZMFLaBj9VH7fUtWMCG0oEKze7a?=
 =?us-ascii?Q?Umv44VSwT+mUz7dypnzO39rTf1KAnj/MmngwmRRs2WG2YY4KZ/tVYNDh0nLm?=
 =?us-ascii?Q?kbfIujhz5Kr718dKgPQuMSKbWOgdufI+I12Y9bHOocn8wi9nBeiXHMJTHUMN?=
 =?us-ascii?Q?MXPCoDqXLlWD5mAsUh6g1ViuJE2IszxUMmwsW/30KW4NTJKi/LDZE1rLfMU1?=
 =?us-ascii?Q?JvKNFlIBSoxDMWMncmYWisnqS8yhzD/yUi0O3r2yKgaRgOYr/gQKHEcIaj8/?=
 =?us-ascii?Q?fLesR3/N4HRNrs0IJ6fnDgdd58mX6si3rOSihLNLztm8MmsIl2pgRM5M2Twz?=
 =?us-ascii?Q?SnifxuCBBa0T601BpMbF/YktGHxZ06B6OLy8A1NpjMWrPMsPN7lBqv3Mu6qL?=
 =?us-ascii?Q?mXP8mjVoLp+udytOc0EP7oj6A2o/LV2R7FHHrbs1RX54r5k8Rq+xr8XdIyuK?=
 =?us-ascii?Q?1rne/Y1d/zcZtVuOGvcecFu0rZZdXLUusgrfdkKbVETdsI8pQAZzRJn1nLeX?=
 =?us-ascii?Q?9aLbjSbvbfZQMfbb8RQLa+ZPvdzRMnMdXU3uNXJl+GfopeGjarUjkO3YNdyB?=
 =?us-ascii?Q?SC742l1lG5GJoeWRiGK096kND245/qzqlHrjQMJBNdUStUUsbXA9wwuwgF+c?=
 =?us-ascii?Q?QNjKfeQFQZnNALBYYHVvTZdNB0QsVP7QX5oG/cWEdDoPk5EgeiPwoszhT8SO?=
 =?us-ascii?Q?x7cC0dv2JNOwFXKodKyHIPbOXEABCZYN7G9FEiX43/At2oFJrbifvRQKdBGX?=
 =?us-ascii?Q?jVPco1w09aVsLgS4aofwtO2JWKgKxLn4sgcFLmoS0KTXK5dUtlt4CkeJevpK?=
 =?us-ascii?Q?k4ujlasA7ImKsKk+Zj4chhKmDEVDdmNQaYfyjTYFoi6GDU6+gvcztz+qk9rV?=
 =?us-ascii?Q?G+h8SQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7ec352-bf34-4fea-2856-08db6731fec4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 08:34:22.9463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8uxvnY5TnVRjVOuSAR3Ar3qVU0XJt8lsEsjYaMbGS+/zW3EVpgj/Y6NpwPsPoiJYTcAkJwPWQMeXNkJMUwu6lt0PdwTMQQyWSQRw1NdHgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR13MB6373
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 08:17:38PM +0100, edward.cree@amd.com wrote:

...

> +static int efx_bind_neigh(struct efx_nic *efx,
> +			  struct efx_tc_encap_action *encap, struct net *net,
> +			  struct netlink_ext_ack *extack)
> +{
> +	struct efx_neigh_binder *neigh, *old;
> +	struct flowi6 flow6 = {};
> +	struct flowi4 flow4 = {};
> +	int rc;
> +
> +	/* GCC stupidly thinks that only values explicitly listed in the enum
> +	 * definition can _possibly_ be sensible case values, so without this
> +	 * cast it complains about the IPv6 versions.
> +	 */
> +	switch ((int)encap->type) {
> +	case EFX_ENCAP_TYPE_VXLAN:
> +	case EFX_ENCAP_TYPE_GENEVE:
> +		flow4.flowi4_proto = IPPROTO_UDP;
> +		flow4.fl4_dport = encap->key.tp_dst;
> +		flow4.flowi4_tos = encap->key.tos;
> +		flow4.daddr = encap->key.u.ipv4.dst;
> +		flow4.saddr = encap->key.u.ipv4.src;
> +		break;
> +	case EFX_ENCAP_TYPE_VXLAN | EFX_ENCAP_FLAG_IPV6:
> +	case EFX_ENCAP_TYPE_GENEVE | EFX_ENCAP_FLAG_IPV6:
> +		flow6.flowi6_proto = IPPROTO_UDP;
> +		flow6.fl6_dport = encap->key.tp_dst;
> +		flow6.flowlabel = ip6_make_flowinfo(encap->key.tos,
> +						    encap->key.label);
> +		flow6.daddr = encap->key.u.ipv6.dst;
> +		flow6.saddr = encap->key.u.ipv6.src;
> +		break;
> +	default:
> +		NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported encap type %d",
> +				       (int)encap->type);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	neigh = kzalloc(sizeof(*neigh), GFP_KERNEL_ACCOUNT);
> +	if (!neigh)
> +		return -ENOMEM;
> +	neigh->net = get_net(net);
> +	neigh->dst_ip = flow4.daddr;
> +	neigh->dst_ip6 = flow6.daddr;
> +
> +	old = rhashtable_lookup_get_insert_fast(&efx->tc->neigh_ht,
> +						&neigh->linkage,
> +						efx_neigh_ht_params);
> +	if (old) {
> +		/* don't need our new entry */
> +		put_net(neigh->net);
> +		kfree(neigh);
> +		if (!refcount_inc_not_zero(&old->ref))
> +			return -EAGAIN;
> +		/* existing entry found, ref taken */
> +		neigh = old;
> +	} else {
> +		/* New entry.  We need to initiate a lookup */
> +		struct neighbour *n;
> +		struct rtable *rt;
> +
> +		if (encap->type & EFX_ENCAP_FLAG_IPV6) {
> +#if IS_ENABLED(CONFIG_IPV6)
> +			struct dst_entry *dst;
> +
> +			dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &flow6,
> +							      NULL);
> +			rc = PTR_ERR_OR_ZERO(dst);
> +			if (rc) {
> +				NL_SET_ERR_MSG_MOD(extack, "Failed to lookup route for IPv6 encap");
> +				goto out_free;
> +			}
> +			dev_hold(neigh->egdev = dst->dev);
> +			neigh->ttl = ip6_dst_hoplimit(dst);
> +			n = dst_neigh_lookup(dst, &flow6.daddr);
> +			dst_release(dst);
> +#else
> +			/* We shouldn't ever get here, because if IPv6 isn't
> +			 * enabled how did someone create an IPv6 tunnel_key?
> +			 */
> +			rc = -EOPNOTSUPP;
> +			NL_SET_ERR_MSG_MOD(extack, "No IPv6 support (neigh bind)");
> +#endif
> +		} else {
> +			rt = ip_route_output_key(net, &flow4);
> +			if (IS_ERR_OR_NULL(rt)) {
> +				rc = PTR_ERR(rt);

Hi Edward,

A minor nit from my side: perhaps this should use PTR_ERR_OR_ZERO().

> +				if (!rc)
> +					rc = -EIO;
> +				NL_SET_ERR_MSG_MOD(extack, "Failed to lookup route for encap");
> +				goto out_free;
> +			}
> +			dev_hold(neigh->egdev = rt->dst.dev);
> +			neigh->ttl = ip4_dst_hoplimit(&rt->dst);
> +			n = dst_neigh_lookup(&rt->dst, &flow4.daddr);
> +			ip_rt_put(rt);
> +		}
> +		if (!n) {
> +			rc = -ENETUNREACH;
> +			NL_SET_ERR_MSG_MOD(extack, "Failed to lookup neighbour for encap");
> +			dev_put(neigh->egdev);
> +			goto out_free;
> +		}
> +		refcount_set(&neigh->ref, 1);
> +		INIT_LIST_HEAD(&neigh->users);
> +		read_lock_bh(&n->lock);
> +		ether_addr_copy(neigh->ha, n->ha);
> +		neigh->n_valid = n->nud_state & NUD_VALID;
> +		read_unlock_bh(&n->lock);
> +		rwlock_init(&neigh->lock);
> +		INIT_WORK(&neigh->work, efx_neigh_update);
> +		neigh->efx = efx;
> +		neigh->used = jiffies;
> +		if (!neigh->n_valid)
> +			/* Prod ARP to find us a neighbour */
> +			neigh_event_send(n, NULL);
> +		neigh_release(n);
> +	}
> +	/* Add us to this neigh */
> +	encap->neigh = neigh;
> +	list_add_tail(&encap->list, &neigh->users);
> +	return 0;
> +
> +out_free:
> +	/* cleanup common to several error paths */
> +	rhashtable_remove_fast(&efx->tc->neigh_ht, &neigh->linkage,
> +			       efx_neigh_ht_params);
> +	synchronize_rcu();
> +	put_net(net);
> +	kfree(neigh);
> +	return rc;
> +}

...

