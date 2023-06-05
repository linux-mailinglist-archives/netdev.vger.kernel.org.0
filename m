Return-Path: <netdev+bounces-7928-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED17722246
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:34:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69578280D8C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31D813AEB;
	Mon,  5 Jun 2023 09:34:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCB0134A4
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:34:41 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2104.outbound.protection.outlook.com [40.107.237.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85919F4
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CniF6mxt+O1gr6Qa9Q3U6ZCQL7EaBOi+Xsfq3nWkJQYfiPYb3XC6OZwXbcAvc8LAcTfPc+WaHWG3tv66bMopW5LVeQahk8U5mtGEGGeHhr4jXNPp6wHWGN0wOxS/VdpwvbTthDzWJJB5lUSDwj8CS1iWDuGAK/CiWcs562Z+hSkmtyXWthBiIlUmUMta7Vvk3/lxiCtk1pyLy3B1SP7dz/oxAw5FPVilVMOLzg+OpGSvEx6mE9ioNbw1n1IR6Bygu3zcRIoLR3cBvq9qTsSbuwuNhSzGMGsRZnp9nic4IzSoIqVe9zfVMRvZI4ySicOdnN/Wl+ftRymljnFBKwwg2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8s+maAbTaXD0CShdfdMOsv56vv0J5fCfT+Y9gt05R6g=;
 b=mrJsAtiIgMzlSaHHfR3EgHvX7OB9+C6JPCQ/Rou/Y0baLOQ3BTYFHT8kiZwKuZcfp5KklpGAQBmu3Nyg7WUsb18FYdb4LU7CFLlKibhGJZthhcsLf9QRv0hGroWYLZLOke2uRDyBG4OkkNRmq2klZW29xeBM/4ifppskIrcM3dgc7vb1g/kkBPqBE11n6uuKrdVtJpUHp2aOshWwm1ZMzgd65jRTIe6iXdVraYTod/QGJO7MBJEiUxy72rje6LTLLlFiG/1UZ+EYpItTIG2BLjc66/EYoIj0xTbByyMTzn/7LqIR3sHHPU1UwexmicqWhT/n87lLeGJwpqUCFqqB8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8s+maAbTaXD0CShdfdMOsv56vv0J5fCfT+Y9gt05R6g=;
 b=GHT/SwtMSyal3iF5YoBv2fdixS0F068m0VcK3/1k4cHnnYD63xjMeCZX6+WUlHfUWRqO8RdqrBFhY8jMwa4RSG27H+95ldNwRko16mnX6qwGqlLzo/MMUJ+JPC88z7SHSR0s9wpu1iWZz/iSShO5CSeEMuRnLUujHV3eUmtfwq0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5788.namprd13.prod.outlook.com (2603:10b6:a03:3eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 09:34:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 09:34:34 +0000
Date: Mon, 5 Jun 2023 11:34:27 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Marcin Szycik <marcin.szycik@linux.intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	wojciech.drewek@intel.com, michal.swiatkowski@linux.intel.com,
	alexandr.lobakin@intel.com, davem@davemloft.net, kuba@kernel.org,
	jiri@resnulli.us, pabeni@redhat.com, jesse.brandeburg@intel.com,
	idosch@nvidia.com
Subject: Re: [RFC PATCH iwl-next 4/6] pfcp: always set pfcp metadata
Message-ID: <ZH2sI7IK+ZjDR6bu@corigine.com>
References: <20230601131929.294667-1-marcin.szycik@linux.intel.com>
 <20230601131929.294667-5-marcin.szycik@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601131929.294667-5-marcin.szycik@linux.intel.com>
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5788:EE_
X-MS-Office365-Filtering-Correlation-Id: 67da7cb1-3d33-4e70-04d9-08db65a812bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zrk4pKgectk7VKGQ+npvDsPUFPpDbftX80h/oNO7bAxfUFIn7n1/F3TFqzAGWFkG4okEXJZCQJGtnctPoH9ND69OcYLWkir2cSiIkOPOiBV8N69MsWVlcH6JMHTV6JhA1NIuXQX4D8PBEOy+KhWxGA8ET3492RaQR85Qhz3hMDyklnMmDwaeIz03R1jm7OjD5iuiM4VqtAFPnYQ5NgjDBYZEHwhQfiIdIoqecW9+FxoOJz+SoU9eoxIQ3A0LKW2d0qflCgRzG7lyy2vXm0aDTyfrTbg+xqY+FYessJp1a5SvOIFPwplp96UsdShhm0gK6scF2tAzmQ4sq7mmz+FLKONL888ivDWmq/zmJ74s+Rn9OE/ru9vcUtjG1Py/oF0NBP0lBUsd5sjFgRMqthAnrZjZP3Y8AT24eOIn1YNnYJcEau3vZ1WHRrrkHwa2uM16laU6ae4a6KNW3kPU2tqW12g81KUawOLRxqJctvX2pBVDCBa6+zOQKUkDEablC3QDm5dPN26eD7pEVm+38vWAGIUydbI2uOeW7OUwkaW+zov8rtKQff7uVXVqAubiio6ccj/yVUy1tsyZTwl5XGnAPKasWYl4bdoDHbsZDhFCAJTqMLQtjKfEwvojlUV29h2sm670EcXqKWNeQ9mBjtJOB8+ME7AbXPhtepjjiak4nK4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39840400004)(396003)(366004)(451199021)(478600001)(2906002)(36756003)(6486002)(6666004)(2616005)(6512007)(6506007)(86362001)(38100700002)(186003)(316002)(7416002)(8676002)(8936002)(66946007)(6916009)(4326008)(66556008)(66476007)(5660300002)(44832011)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ljHZwocDYsQLHwlUYtzQyOPy0g9THw8huWxff0ckl8bxtCBOmIiNVEqyYHjG?=
 =?us-ascii?Q?XQFCRwoUWjVylSAm3ql2PR68wCz8rWDiYgdlbZLskGNbss7qF9Qtn6B85GR+?=
 =?us-ascii?Q?X/x7QwOgK+MIMZTkgyixzqq2gCtSvBIyXM4pM8aD+ogmoYk/JmmGyAQ7O/Ae?=
 =?us-ascii?Q?OALE8fGQSv2kUikPdeyZAEHsBrny6prbbEqW4IdY2eM/BFThJqi0VOgqezjN?=
 =?us-ascii?Q?iv+RdclmM2unl91sct4oUWWVxjTeD9+ny3zYeP14bpsx24SYWzd1Iuo2NpR3?=
 =?us-ascii?Q?0dsNcJwBI/WFGl39VEoXNd+dGRDFz1RHBgPbkcLhnGx0yYqVZHCJHaSFG9Xg?=
 =?us-ascii?Q?F4d05TyCV5R2LdqSrsI9lVXbb9pn07iCEil1oqSMg1hkpPs2NgODPoQhYgel?=
 =?us-ascii?Q?UE2y+ZF5iadhlBVoyzBh8iGH8g5REJmYvJBCyzwoj2FJEFu07HK/KN/XESNw?=
 =?us-ascii?Q?32J5UosZHDJQNwRdiBCAi70aBL7myTUKBKRw4aPfZsa1JVIoWStepXXi1uTU?=
 =?us-ascii?Q?H9l/scuppO9G8BWDLNXiz0JXpjqRIyw0+K5HZBQ+OMLhO+u9qR+A2RGDy62f?=
 =?us-ascii?Q?RFLxjCUyufEZoRn6bvzE1mBxNwcntIOr6wXf1KKAMCPMJSqnMqnmxhql7Aqf?=
 =?us-ascii?Q?x7SYfXP9eUKw/d/LRamca6ALkfiBoFM6YmYyGWGbkFfJYoHkefRjiQfLUwVf?=
 =?us-ascii?Q?pD/5ydl9C/5wBeVq3sGzanwq9ZbrZJNkJBs3ePyGHDdRgwsO0lRQ/8pR2gaL?=
 =?us-ascii?Q?kP78QUMLoNJ2D3LnOfSQDK3JOdLCaZrUP/kxPPpMs0WXe2C9n7LedVqXe2Z9?=
 =?us-ascii?Q?temMbpR8T3lJN44UwEko6HYsWMiAvHLugoX+oBFuYPU1lb19qnMlaLt6wg3T?=
 =?us-ascii?Q?zTHa4Lbuw35rFkJ2SB4apeqssTdYxhgYrPdWlKKSxNOOnu+drvZ4CWUD1Gmr?=
 =?us-ascii?Q?c2pR/wu/tQMuDBTXkNYBm2cHhyQNVjWclJHGPdl9GrXKFALT9a+2i+n+eHBe?=
 =?us-ascii?Q?auvAkBIKNDJQEQM8soW6u6HatVlc4kFWQ++hU+Px9lr+sWGk29LO9Zm56Ozp?=
 =?us-ascii?Q?vgUmUAuXsifw52yT2CpXSL7Jvd0hvuDowc3MYGIxiNeYCL9c9ev29nsSFMfT?=
 =?us-ascii?Q?GL3u+hVYmuGKR4wWpbhZZbMoCEbgvtAiDEGJEefCwrSuYW2dtPMR3RP6Jxf5?=
 =?us-ascii?Q?cS/nd+WrbKwCWwmKSM/fItsCN8mYOyjRbqmPSnmQFFiZJhY88VMbEd7D2zNn?=
 =?us-ascii?Q?6UFhiiC+AceaVpzkBq1KyWHpkGKqV47zppiQ+51su4JgSd1s2FYhwMW47e10?=
 =?us-ascii?Q?37AhaWbtd5YTChsisf9ovmgIRUWbqdUi4zzVf12YUZ4oM54BCtb9ZXNHSroi?=
 =?us-ascii?Q?KhnWy2tRHLgQITLem7J8xYiwG/k7pIMOachIn7WgcRO8VAOnhzCG5fYg+GoV?=
 =?us-ascii?Q?1iLhUMpZgSU6xIsPehGIqPe+Vhnh0+Wzqt/RnrMiay7uATrjv1ai+yz8up1s?=
 =?us-ascii?Q?OPLk1BUCECEUzcT8kyxJ25nTRLf9WWW/TN07W3PNous9w7Cs4VXKVdganyhH?=
 =?us-ascii?Q?aC2r+VFc1tQA6ctN3/RfIBgnGbIDmwr6T5RcCFB8feX3LPzRykFFqdmFHGUb?=
 =?us-ascii?Q?EmeBgM9W7uG5RIzAX+ViQ+u62aOOtZJx9w7EhOt2f8xlPSDnh5C9QJpBSQWw?=
 =?us-ascii?Q?3K0aCA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67da7cb1-3d33-4e70-04d9-08db65a812bb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 09:34:34.7318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K8Y7HdAaDDpD0+vVfJEx4M6bf3qVdCzieqhvGK31JpBr9bHT4uhbE6Sd/gAhhazskoHpurZaDmsyKj2KSfrYvSU53/RJxsrYKpt4lIVEv1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5788
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 03:19:27PM +0200, Marcin Szycik wrote:
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> In PFCP receive path set metadata needed by flower code to do correct
> classification based on this metadata.
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>

A few minor nits below.
Otherwise, looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> @@ -30,6 +33,82 @@ struct pfcp_net {
>  	struct list_head	pfcp_dev_list;
>  };
>  
> +static int
> +pfcp_session_recv(struct pfcp_dev *pfcp, struct sk_buff *skb,
> +		  struct pfcp_metadata *md)
> +{
> +	struct pfcphdr_session *unparsed = pfcp_hdr_session(skb);
> +
> +	md->seid = unparsed->seid;
> +	md->type = PFCP_TYPE_SESSION;
> +
> +	return 0;
> +}

nit: This the return type of this function could be void.

> +
> +static int
> +pfcp_node_recv(struct pfcp_dev *pfcp, struct sk_buff *skb,
> +	       struct pfcp_metadata *md)
> +{
> +	md->type = PFCP_TYPE_NODE;
> +
> +	return 0;
> +}

Ditto.

> +
> +static int pfcp_encap_recv(struct sock *sk, struct sk_buff *skb)
> +{
> +	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
> +	struct metadata_dst *tun_dst;
> +	struct pfcp_metadata *md;
> +	struct pfcphdr *unparsed;
> +	struct pfcp_dev *pfcp;
> +
> +	if (unlikely(!pskb_may_pull(skb, PFCP_HLEN)))
> +		goto drop;
> +
> +	pfcp = rcu_dereference_sk_user_data(sk);
> +	if (unlikely(!pfcp))
> +		goto drop;
> +
> +	unparsed = pfcp_hdr(skb);
> +
> +	bitmap_zero(flags, __IP_TUNNEL_FLAG_NUM);
> +	tun_dst = udp_tun_rx_dst(skb, sk->sk_family, flags, 0,
> +				 sizeof(*md));
> +	if (unlikely(!tun_dst))
> +		goto drop;
> +
> +	md = ip_tunnel_info_opts(&tun_dst->u.tun_info);
> +	if (unlikely(!md))
> +		goto drop;
> +
> +	if (unparsed->flags & PFCP_SEID_FLAG)
> +		pfcp_session_recv(pfcp, skb, md);
> +	else
> +		pfcp_node_recv(pfcp, skb, md);
> +
> +	__set_bit(IP_TUNNEL_PFCP_OPT_BIT, flags);
> +	ip_tunnel_info_opts_set(&tun_dst->u.tun_info, md, sizeof(*md),
> +				flags);
> +
> +	if (unlikely(iptunnel_pull_header(skb, PFCP_HLEN, skb->protocol,
> +					  !net_eq(sock_net(sk),
> +					  dev_net(pfcp->dev)))))
> +		goto drop;
> +
> +	skb_dst_set(skb, (struct dst_entry *)tun_dst);
> +
> +	skb_reset_network_header(skb);
> +	skb_reset_mac_header(skb);
> +	skb->dev = pfcp->dev;
> +
> +	gro_cells_receive(&pfcp->gro_cells, skb);
> +
> +	return 0;
> +drop:
> +	kfree_skb(skb);
> +	return 0;
> +}

...

