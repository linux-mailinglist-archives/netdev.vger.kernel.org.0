Return-Path: <netdev+bounces-10427-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9402F72E6B1
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 730F91C20D05
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CFC339247;
	Tue, 13 Jun 2023 15:08:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C5734D6F;
	Tue, 13 Jun 2023 15:08:21 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2136.outbound.protection.outlook.com [40.107.93.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C734CD2;
	Tue, 13 Jun 2023 08:08:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVZ/8ou2G/CoRvMDDJySXTrfwzcmcLSx5beBAksUUAFfLrYqT8q0cwzRiaaTw+SjQFv//6RV9fRu/fa9UYMhbR5kTUar5dVGYO9vMdFo3qTRny5lf9RLT7IbYe1D10FiKe9zOAlJliaVBspjtzet4szWNQ+CRlwfQK/UtviiWR/mF+GE2pVRr0yT0KQzMjCrhs5CDH4yy+zq6MeVCQPGhfFtz/MCqzsNt3w0Mxen3KQAfeVifKaDk4WmBjPqIGxTOvukqZ/5VADMnTC7etmuDFpB25CCQHucfbow/602Nlv6PhA8L+YkvjUbp/cx5rkONksKAsxK1ZOcBd8TXvw3Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEvVYSs7SxFhzAUe9bF2DUk447pzxieC/jnQSdV+PdY=;
 b=Fcch1lrcYoz9IIpe93zx3GMlUoTG3rw3u9NGQEP4GKjOAaTsg3ADlC30hNCUS/wNqzxAX4/nN6NyLOJe8S+erJNQ+dy4gXlJ5HEe8LR0aTbVYsPH4RdvUvXreKMcUXwGtEkqWs6397pcM77LhTgJI7TFas5UuGQRm7I2uBKHyXIOSfEu4ouIty+HxKKstwaF0qkzmr4K+F1siwfHrrZiNGcJUD0Rzkw5axGz3u76BrnPNnBeMFNcCTGKJ8nwbbBAucoO/vOskGMUoIPV+/Uf2CkUph2MSBik+wvd6Amub0ZOHJuOkQsrLPrZ1C1H6wZgDhxCdV0IRqfjY3og13H17w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEvVYSs7SxFhzAUe9bF2DUk447pzxieC/jnQSdV+PdY=;
 b=q2dpOk+hr5rQGltZxrccv90P8W11mNUQ5PJlOPNvRkypMwTFrWayL5CdH9e004lmkmclmlECxNsDCr5f8K9+XHa386LC4sg9UmT9S09NbqYkcNSKBdXRmJQqHLReuxGBSwWwog0gBKVU4ftBCXOrZYv5L3HdXYj3OR06XKZVuBg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4053.namprd13.prod.outlook.com (2603:10b6:208:26c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 15:08:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 15:08:15 +0000
Date: Tue, 13 Jun 2023 17:08:06 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
	yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
	haoluo@google.com, jolsa@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC bpf-next 3/7] bpf: implement devtx hook points
Message-ID: <ZIiGVrHLKQRzMzGg@corigine.com>
References: <20230612172307.3923165-1-sdf@google.com>
 <20230612172307.3923165-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612172307.3923165-4-sdf@google.com>
X-ClientProxiedBy: AM8P189CA0003.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4053:EE_
X-MS-Office365-Filtering-Correlation-Id: fb19f1dc-9a5f-4446-6c8a-08db6c2002db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	++0ds+QVNs4MPTiNl7drMwWQznpVbYRIHdUooLHBfq4zYsN618726E+h7K4SwiLMnief6Ufc+UIraovGUkh5ll/lUzE+kTiDzADB4hz490UPvBTc2VHry3myEYCqUdZO7ipK5BzBbeH6hMAfu29EZ20POhImwm87WiyHMoyasEsDLyM7QngJ4JQjKPl60y3WnoDksYuUOKZW8/erblSXiXPdRsOrnMwwwpwVDysjQ0ugLLyqdYKnpv0uU9xbGRx0B25N7Ixf8vU94R86ylaVlGrgSr7FMMnwy4wc9NtXmVv+sHeo2XYb1DkLVVbJlZd4tP+ztgWn5VxD/AToFBEVF5QVyoPm6GIwcWbkarVYNNtxNz45EAAKm96GBcWw6RWsN5O1vXWlzh9+a2PRDnI3Kax1nopF6PyuhZoU4h1dEOxfOcXPPI6s4qb+AEtZWHBcDL+faHU0QsIa+sNBeAwEFCtrnovQPr8Zti0YIjivTkpNh9Qf4PnpCFJ4Ovkz9LhrBSHI41lKBXDc5LH3volJJpyvur/pe/W3+CvVWqY8s4xSVNxntf7YuqbVq+6yEefM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(39840400004)(376002)(136003)(451199021)(6916009)(316002)(4326008)(44832011)(7416002)(41300700001)(186003)(2906002)(66476007)(66556008)(66946007)(8676002)(8936002)(5660300002)(478600001)(6666004)(6486002)(6506007)(6512007)(83380400001)(36756003)(86362001)(2616005)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mfbSpsC3lLy4d46E/bTPtt6SUzbqZfTodAVenef84JVDUVHSwWyXYd3vtffj?=
 =?us-ascii?Q?pO9hBpu3Gl0k3whKPYkkWwW9CDALdE0dVZTLylGFo6Lj3Ih9qF/GeQGgPeAo?=
 =?us-ascii?Q?kkM1IFzF9UME/ph8VXCL5NCxN3/diFmY4ZfXHKSHYTWpB8ggI2xRC034DImj?=
 =?us-ascii?Q?jr0ZBtRHWVAHeEgT1vJJykk8PjMdMG1q2hZLe21MFOrgVLh0K2JfITqufOCk?=
 =?us-ascii?Q?8xcjY+BM2/pwHCajZs0cXutpDSfnfZ3zYskytO3tiHZqlzo7FiuVCXZOarrH?=
 =?us-ascii?Q?NmVtOFUUyu3392JzrsUZ3B80bJozZNWOP29ua096de5pZnKhunTbELv5O3p5?=
 =?us-ascii?Q?7fZsc2Bo5b4TOiWl5QbV4WhfQ1qGSXuFxzyqsmilgYCFQWqevjEi5wkxOC+y?=
 =?us-ascii?Q?w+t2tSrwmci9ziJQKiJeGDoyD+29z7yAoIEv4nIXZkh4BaKyU6Kbi+TWkOhN?=
 =?us-ascii?Q?f0MHeNyRZoPYZc0AsFpgEAc2k6sp5gaU77G7TI5NTGsOx28kZ4E9jjULE/95?=
 =?us-ascii?Q?0zqDJapDbJ75EsWFFsvtjeFAK2MaeNlzw9gyCAfBidedMsFMpyasaaJFLILD?=
 =?us-ascii?Q?Dt0gw4yMdwv97Pi77Ywfk4FMfJxlXUwaG0HXjkV3SkwJZH68m1amSjya2ZAa?=
 =?us-ascii?Q?W3OQ6c84FhubJjpy1vRZzNQYdDjxd4U0CiW7mMwNgDscj7tkoM/PB0jv8hZA?=
 =?us-ascii?Q?yC6hcG/TdNPJ9vOgMCDMmsadMVMmoSGzF4GYQUUekygNUzVL1BX/sm5NtYkG?=
 =?us-ascii?Q?p+czJX8NdHSw2F8wh06xS4kwXpt9Kvh9vQBtmQjqlG7bJfM7bMCbBlsYebiX?=
 =?us-ascii?Q?DKR9OvhIsDq89eqipG6WnYwotXWM/OFtYTY4TeG9N9lqPCiU5h4cGoV8c3+N?=
 =?us-ascii?Q?Y0eLpH0+WeU8os66dvYgSUgnkOFnYPeBA+7DbHRgsjIZFIBevm+ZZ+3Jh896?=
 =?us-ascii?Q?mh5Ty1SOfFlEoYDQgSkDMHdX4atLod2xW8v4Ezzb6f7ft7XLOz1UZ2Ea5/n2?=
 =?us-ascii?Q?rm3bdvZnUJ0lmERLGHGkkED5o6trnNPLI+6k1AJ4VdYrI+g4R7n3b3DkZzcE?=
 =?us-ascii?Q?sOpx50qd2x6n8QuclaCKxl/1nPM9EFCg2Xr9DJposIC0CrIwJx+K3Bvjmd+D?=
 =?us-ascii?Q?rKPlnARdxiWPRBdrZDZRW/8bB3hClxK7VpGSAzHlzGU82e5N+MFe0jXOQbav?=
 =?us-ascii?Q?smDfdGRi/Tyi+6rJNjNshzxyYg9LVjeThZm7Z2tnqwk9Iber1Sii4CiV+WTm?=
 =?us-ascii?Q?xzYSpzj7l4O1ErOd8RU66/06LMTop7ICu3Bn+9SrKlMg82Ow/t4if6LU/q9c?=
 =?us-ascii?Q?PvUANzenFsba+p9n3yWQWpgSUqq6mqm7zdvo5GNfB0v098plz1E/JprUoZYh?=
 =?us-ascii?Q?I2DZ1Z0uMX0BEdfaxcTR1Y7EjOCfoMSLPDVPG0NmtHuGQeFFZN3e1QYDf/AS?=
 =?us-ascii?Q?Rvox53DnvAAlFmOmizTfJyHLg2hLjbtX5zJDGPbHvJPW20I2OIx4VMDk8Ky7?=
 =?us-ascii?Q?CcD7Ng5bwHUxwBt3TY1EEIRF8BaN5mHgORUYVSKg8qlSrumU0sBAlh+cvm8q?=
 =?us-ascii?Q?T4ObRgQ2BBdS7GbxxURPZrsQkatvGHnuSuSmx/SVDvZ2qNmd7PNw+6F8+eX9?=
 =?us-ascii?Q?XbaCBtf2OyiTjJgljHw0uwZLRcRDvvnZXCq24kkWRpkzSRDmWwgsFVlNYpwG?=
 =?us-ascii?Q?41sdrw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb19f1dc-9a5f-4446-6c8a-08db6c2002db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 15:08:15.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22qa7nIgZYn0lvmhIxTW70TOS23oMSwG0Axga3hexlJG68kOcdBL/I9W19oXWAc+xhMGfNSYP0eISER5aL07yOZl6kcJOCDwitQD5jILphk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4053
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 10:23:03AM -0700, Stanislav Fomichev wrote:
> devtx is a lightweight set of hooks before and after packet transmission.
> The hook is supposed to work for both skb and xdp paths by exposing
> a light-weight packet wrapper via devtx_frame (header portion + frags).
> 
> devtx is implemented as a tracing program which has access to the
> XDP-metadata-like kfuncs. The initial set of kfuncs is implemented
> in the next patch, but the idea is similar to XDP metadata:
> the kfuncs have netdev-specific implementation, but common
> interface. Upon loading, the kfuncs are resolved to direct
> calls against per-netdev implementation. This can be achieved
> by marking devtx-tracing programs as dev-bound (largely
> reusing xdp-dev-bound program infrastructure).
> 
> Attachment and detachment is implemented via syscall BPF program
> by calling bpf_devtx_sb_attach (attach to tx-submission)
> or bpf_devtx_cp_attach (attach to tx completion). Right now,
> the attachment does not return a link and doesn't support
> multiple programs. I plan to switch to Daniel's bpf_mprog infra
> once it's available.
> 
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

...

> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22976,11 +22976,13 @@ L:	bpf@vger.kernel.org
>  S:	Supported
>  F:	drivers/net/ethernet/*/*/*/*/*xdp*
>  F:	drivers/net/ethernet/*/*/*xdp*
> +F:	include/net/devtx.h
>  F:	include/net/xdp.h
>  F:	include/net/xdp_priv.h
>  F:	include/trace/events/xdp.h
>  F:	kernel/bpf/cpumap.c
>  F:	kernel/bpf/devmap.c
> +F:	net/core/devtx.c
>  F:	net/core/xdp.c
>  F:	samples/bpf/xdp*
>  F:	tools/testing/selftests/bpf/*/*xdp*

Hi Stan,

some feedback from my side.

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 08fbd4622ccf..e08e3fd39dfc 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2238,6 +2238,8 @@ struct net_device {
>  	unsigned int		real_num_rx_queues;
>  
>  	struct bpf_prog __rcu	*xdp_prog;
> +	struct bpf_prog	__rcu	*devtx_sb;
> +	struct bpf_prog	__rcu	*devtx_cp;

It would be good to add these new fields to the kernel doc
for struct net_device.

>  	unsigned long		gro_flush_timeout;
>  	int			napi_defer_hard_irqs;
>  #define GRO_LEGACY_MAX_SIZE	65536u
> diff --git a/include/net/devtx.h b/include/net/devtx.h
> new file mode 100644
> index 000000000000..7eab66d0ce80
> --- /dev/null
> +++ b/include/net/devtx.h
> @@ -0,0 +1,76 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __LINUX_NET_DEVTX_H__
> +#define __LINUX_NET_DEVTX_H__
> +
> +#include <linux/jump_label.h>
> +#include <linux/skbuff.h>
> +#include <linux/netdevice.h>
> +#include <net/xdp.h>
> +
> +struct devtx_frame {
> +	void *data;
> +	u16 len;
> +	struct skb_shared_info *sinfo; /* for frags */
> +};
> +
> +#ifdef CONFIG_NET
> +void devtx_submit(struct net_device *netdev, struct devtx_frame *ctx);
> +void devtx_complete(struct net_device *netdev, struct devtx_frame *ctx);
> +bool is_devtx_kfunc(u32 kfunc_id);
> +void devtx_shutdown(struct net_device *netdev);
> +
> +static inline void devtx_frame_from_skb(struct devtx_frame *ctx, struct sk_buff *skb)
> +{
> +	ctx->data = skb->data;
> +	ctx->len = skb_headlen(skb);
> +	ctx->sinfo = skb_shinfo(skb);
> +}
> +
> +static inline void devtx_frame_from_xdp(struct devtx_frame *ctx, struct xdp_frame *xdpf)
> +{
> +	ctx->data = xdpf->data;
> +	ctx->len = xdpf->len;
> +	ctx->sinfo = xdp_frame_has_frags(xdpf) ? xdp_get_shared_info_from_frame(xdpf) : NULL;
> +}
> +
> +DECLARE_STATIC_KEY_FALSE(devtx_enabled);
> +
> +static inline bool devtx_submit_enabled(struct net_device *netdev)
> +{
> +	return static_branch_unlikely(&devtx_enabled) &&
> +	       rcu_access_pointer(netdev->devtx_sb);
> +}
> +
> +static inline bool devtx_complete_enabled(struct net_device *netdev)
> +{
> +	return static_branch_unlikely(&devtx_enabled) &&
> +	       rcu_access_pointer(netdev->devtx_cp);
> +}
> +#else
> +static inline void devtx_submit(struct net_device *netdev, struct devtx_frame *ctx)
> +{
> +}
> +
> +static inline void devtx_complete(struct net_device *netdev, struct devtx_frame *ctx)
> +{
> +}
> +
> +static inline bool is_devtx_kfunc(u32 kfunc_id)
> +{
> +	return false;
> +}
> +
> +static inline void devtx_shutdown(struct net_device *netdev)
> +{
> +}
> +
> +static inline void devtx_frame_from_skb(struct devtx_frame *ctx, struct sk_buff *skb)
> +{
> +}
> +
> +static inline void devtx_frame_from_xdp(struct devtx_frame *ctx, struct xdp_frame *xdpf)
> +{
> +}
> +#endif
> +
> +#endif /* __LINUX_NET_DEVTX_H__ */
> diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> index 235d81f7e0ed..9cfe96422c80 100644
> --- a/kernel/bpf/offload.c
> +++ b/kernel/bpf/offload.c
> @@ -25,6 +25,7 @@
>  #include <linux/rhashtable.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/rwsem.h>
> +#include <net/devtx.h>
>  
>  /* Protects offdevs, members of bpf_offload_netdev and offload members
>   * of all progs.
> @@ -228,6 +229,7 @@ int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
>  	int err;
>  
>  	if (attr->prog_type != BPF_PROG_TYPE_SCHED_CLS &&
> +	    attr->prog_type != BPF_PROG_TYPE_TRACING &&
>  	    attr->prog_type != BPF_PROG_TYPE_XDP)
>  		return -EINVAL;
>  
> @@ -238,6 +240,10 @@ int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
>  	    attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY)
>  		return -EINVAL;
>  
> +	if (attr->prog_type == BPF_PROG_TYPE_TRACING &&
> +	    !is_devtx_kfunc(prog->aux->attach_btf_id))
> +		return -EINVAL;
> +
>  	netdev = dev_get_by_index(current->nsproxy->net_ns, attr->prog_ifindex);
>  	if (!netdev)
>  		return -EINVAL;
> diff --git a/net/core/Makefile b/net/core/Makefile
> index 8f367813bc68..c1db05ccfac7 100644
> --- a/net/core/Makefile
> +++ b/net/core/Makefile
> @@ -39,4 +39,5 @@ obj-$(CONFIG_FAILOVER) += failover.o
>  obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
>  obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
>  obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
> +obj-$(CONFIG_BPF_SYSCALL) += devtx.o
>  obj-$(CONFIG_OF)	+= of_net.o
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 3393c2f3dbe8..ef0e65e68024 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -150,6 +150,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/prandom.h>
>  #include <linux/once_lite.h>
> +#include <net/devtx.h>
>  
>  #include "dev.h"
>  #include "net-sysfs.h"
> @@ -10875,6 +10876,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
>  		dev_shutdown(dev);
>  
>  		dev_xdp_uninstall(dev);
> +		devtx_shutdown(dev);
>  		bpf_dev_bound_netdev_unregister(dev);
>  
>  		netdev_offload_xstats_disable_all(dev);
> diff --git a/net/core/devtx.c b/net/core/devtx.c
> new file mode 100644
> index 000000000000..b7cbc26d1c01
> --- /dev/null
> +++ b/net/core/devtx.c
> @@ -0,0 +1,208 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <net/devtx.h>
> +#include <linux/filter.h>
> +
> +DEFINE_STATIC_KEY_FALSE(devtx_enabled);
> +EXPORT_SYMBOL_GPL(devtx_enabled);
> +
> +static void devtx_run(struct net_device *netdev, struct devtx_frame *ctx, struct bpf_prog **pprog)

Is an __rcu annotation appropriate for prog here?
Also elsewhere in this patch.

> +{
> +	struct bpf_prog *prog;
> +	void *real_ctx[1] = {ctx};
> +
> +	prog = rcu_dereference(*pprog);
> +	if (likely(prog))
> +		bpf_prog_run(prog, real_ctx);
> +}
> +
> +void devtx_submit(struct net_device *netdev, struct devtx_frame *ctx)
> +{
> +	rcu_read_lock();
> +	devtx_run(netdev, ctx, &netdev->devtx_sb);
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL_GPL(devtx_submit);
> +
> +void devtx_complete(struct net_device *netdev, struct devtx_frame *ctx)
> +{
> +	rcu_read_lock();
> +	devtx_run(netdev, ctx, &netdev->devtx_cp);
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL_GPL(devtx_complete);
> +
> +/**
> + * devtx_sb - Called for every egress netdev packet

As this is a kernel doc, it would be good to document the ctx parameter here.

> + *
> + * Note: this function is never actually called by the kernel and declared
> + * only to allow loading an attaching appropriate tracepoints.
> + */
> +__weak noinline void devtx_sb(struct devtx_frame *ctx)

I guess this is intentional.
But gcc complains that this is neither static nor is a forward
declaration provided. Likewise for devtx_cp()

> +{
> +}
> +
> +/**
> + * devtx_cp - Called upon egress netdev packet completion

Likewise, here too.

> + *
> + * Note: this function is never actually called by the kernel and declared
> + * only to allow loading an attaching appropriate tracepoints.
> + */
> +__weak noinline void devtx_cp(struct devtx_frame *ctx)
> +{
> +}
> +
> +BTF_SET8_START(bpf_devtx_hook_ids)
> +BTF_ID_FLAGS(func, devtx_sb)
> +BTF_ID_FLAGS(func, devtx_cp)
> +BTF_SET8_END(bpf_devtx_hook_ids)
> +
> +static const struct btf_kfunc_id_set bpf_devtx_hook_set = {
> +	.owner = THIS_MODULE,
> +	.set   = &bpf_devtx_hook_ids,
> +};
> +
> +static DEFINE_MUTEX(devtx_attach_lock);
> +
> +static int __bpf_devtx_detach(struct net_device *netdev, struct bpf_prog **pprog)
> +{

As per my prior comment about *prog and __rcu annotations.
I'm genuinely unsure how the usage of **pprog in this function sits with RCU.

> +	if (!*pprog)
> +		return -EINVAL;
> +	bpf_prog_put(*pprog);
> +	*pprog = NULL;
> +
> +	static_branch_dec(&devtx_enabled);
> +	return 0;
> +}
> +
> +static int __bpf_devtx_attach(struct net_device *netdev, int prog_fd,
> +			      const char *attach_func_name, struct bpf_prog **pprog)
> +{
> +	struct bpf_prog *prog;
> +	int ret = 0;
> +
> +	if (prog_fd < 0)
> +		return __bpf_devtx_detach(netdev, pprog);
> +
> +	if (*pprog)
> +		return -EBUSY;
> +
> +	prog = bpf_prog_get(prog_fd);
> +	if (IS_ERR(prog))
> +		return PTR_ERR(prog);
> +
> +	if (prog->type != BPF_PROG_TYPE_TRACING ||
> +	    prog->expected_attach_type != BPF_TRACE_FENTRY ||
> +	    !bpf_prog_is_dev_bound(prog->aux) ||
> +	    !bpf_offload_dev_match(prog, netdev) ||
> +	    strcmp(prog->aux->attach_func_name, attach_func_name)) {
> +		bpf_prog_put(prog);
> +		return -EINVAL;
> +	}
> +
> +	*pprog = prog;
> +	static_branch_inc(&devtx_enabled);
> +
> +	return ret;
> +}

...

