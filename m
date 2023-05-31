Return-Path: <netdev+bounces-6859-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD7571870E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 732A01C20EEA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F1A17754;
	Wed, 31 May 2023 16:09:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75284174C6
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:09:25 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2123.outbound.protection.outlook.com [40.107.94.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A405DB2;
	Wed, 31 May 2023 09:09:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5gDheDCfyyjuaLE0CPauli+BRvkQadTUFUfVjeccpOxbFtgVNPIy6061mkxa5zB0gFUbvLia5OoG29/V0DcvtDHnsdgJQKGXv9nEZiNb2jqV+kxU+Kjl/Czjn+MFI2Jmi7+AvQtXUnmI1oWTdn69CuFWX0uxZ8ccJ9wCelk85ltwxEigM1r4uvAI8n12Bw/iKz+M88MuA9PiDsQWtPKd25WMcfpuQT35hkPPQOxUcoShsD96idnWPI9PgQNWdPjQJZYwgsOsybqon4hIFtlQKi30ZqUmH33Jp7xmT6mWPbHmIN/qDoYEyCZ28vx5a647Ff6cSqJ4JyVlnCuks1hcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Js0vWXJbBaSGdt4e3s/Za31Kjb8CSpqUVTYpb8PrC5E=;
 b=Ne/lKHyCQ/+IvFoQpHVLrjexBkt8zAkgw+mRy51NoP+zeJlZqz8uP3URk4kV4HoZ1fThDu/wvvHEeETHrX8IXBYqDK8DEwm8U3MA0S/r2IY7vMdc862EjUik0CuyK2G9k31Ny/0Jrq3Awoj9eNRYMWau9gM6JKatTeEmnICs2xkT4OQrDxERkk+0aP13fTSJHF0JhqFG449zl+JoWU2rSooEa3IXlmVskDyS11Cse8JHGLkAPUK7jcN90ngcBygxddlqtuqmRmlYBLfgsMMNyBXJgr/C8mz8t1T1pjqojLSEIxONn6+aK4dPFYiKfHcUTIw/muDDe2uPTH8zUniLXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Js0vWXJbBaSGdt4e3s/Za31Kjb8CSpqUVTYpb8PrC5E=;
 b=eti4Y5iIoHq9DRz4PTqhILRxchWyaiuSEqNA3I5SNULIarVvLrXVZdgAmMx6rw3oI3xuOZUPLf2HpcQIvE9yNK7CPzFxHWj0no4rGSJTZktyPWVdlNw7KWx8RDCH34eNfq2hEbYaIrf0Hf7qoYll2mYPfnRuwr6AEdZqPgb6w3Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5700.namprd13.prod.outlook.com (2603:10b6:510:117::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 16:09:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:09:19 +0000
Date: Wed, 31 May 2023 18:09:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH RFC net-next v3 6/8] virtio/vsock: support dgrams
Message-ID: <ZHdxJxjXDkkO03L4@corigine.com>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
 <20230413-b4-vsock-dgram-v3-6-c2414413ef6a@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v3-6-c2414413ef6a@bytedance.com>
X-ClientProxiedBy: AM3PR04CA0127.eurprd04.prod.outlook.com (2603:10a6:207::11)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5700:EE_
X-MS-Office365-Filtering-Correlation-Id: c8d32870-c90d-4c72-399f-08db61f16383
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Tc5XRF5F5FNjINoJ7gBs0RCHCL/KguV4FDtLktkb3pXqEWmIJilVv1p3rMyeP+yfdb37X02MmWtqgqOVIsbGxSOUHmW+HnFHnyyDiYuZ/RXBwe66z4xKystaZgfNUoc7sByFBvJC4OPZ7wBgigIqgkTrbstrVWgrPAOjh7Q82h2kHOuq4rumZsA1QFqj88bSP702L2FrkiR3K3ZnkqEaZX/dPRtrr9vMkHHQoA4fomDwKNS0+OTTpieJLS83CpPUDcIYyTShp/eL9qDbsxYoYDaYaDZpR8AezJDqQc7ELAqcy7MhRV35u4sVGXQD1DzkKpchv6X2YQFUEMB+2SKHuat1M6R4OobDCsn7FE5WJky1YWX+Wx3Olas/4KtV+RhfXrb9Ftse7kDCz7xU/kI3IQcNFkXYj+UWDnu4YXPVH1MLxwDYE0meVYDnHuZBJEq7UMKBI5gynv8QYy4VKM/jQrPhIZ1LJoqmI3KsM/wUJKP/bP5P2o130xFOZPtgWhbAENisjwgWGeZ2sf0zAOOLC/uBUDiTMQ/pONJR4fN+0ZpN0X+iO4ySPu+TbpQUSWY9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(376002)(396003)(39840400004)(451199021)(54906003)(478600001)(5660300002)(7416002)(44832011)(8936002)(8676002)(36756003)(2906002)(86362001)(66556008)(66476007)(4326008)(66946007)(6916009)(316002)(41300700001)(38100700002)(186003)(6512007)(6506007)(6486002)(83380400001)(2616005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UDdGFoMg3FFLRwJxK1m0L0zdiD9twr5j+GcFi7jf8Rw97CGwOLLnh40kSrnt?=
 =?us-ascii?Q?s0xjmc6E2LC3Nvwj4EWfNgrROkLyYyTeugbI+hhMLxeRzppsxKzBM6GoyKaS?=
 =?us-ascii?Q?eQ9ivDfS1gPKMzirqd/uO5HMtw616a1NRmO6YKcPtiaP3lz2Gl7gtBiXopy8?=
 =?us-ascii?Q?+kbsth9iq/0zrI0fXJsmk3JdoHanY8Zt1ftQip1G0ecT+co3DcSPGfpCPe5w?=
 =?us-ascii?Q?bvfk0LNkqR1KrkGINAlYEgjoV6UX+n5bSrGqBiPozx3qI66ribXVjFQrsMcR?=
 =?us-ascii?Q?E0zcyMwnFvkzTm9zdtcK6KmRroX8QcQDmKB3x/nA9wZcKlJUXV2JuOJPckE3?=
 =?us-ascii?Q?OqSRD+MjJuY7FM/8cmlWx3VkeyjQbtHRkpzAywx+n6R7iGtztF6v3p2xW9zC?=
 =?us-ascii?Q?domX7Cl7nSpw6kiFhYtBxiSkL+pvxAPaGP7fz0Sg4VHhXzJKIK7z5keBYxk0?=
 =?us-ascii?Q?FlruKlSPgLjEYWYwHweJJnGnNn8drBw3LwP/m3pM/oqCYq2D73O8ebS3xOq9?=
 =?us-ascii?Q?dj84OB0xjxHCasCxDILLuktcSaOMa4Y1JZ5trmcFA9ePmcl3KUbkPTwfqDf6?=
 =?us-ascii?Q?Ah3mHsM5j+w3hJ6/USM7OHMzULzLOGt+2NUNtcbuUubFN/JnAxX1n0M6D/02?=
 =?us-ascii?Q?fJ0jsy14R02eVUI7U5ONGdsRgxXtC4CQsAlwhDSaLvllhhSQCfioMd+gx2RX?=
 =?us-ascii?Q?AWB+pejT1gS6MdmodeujQa2/QmcoSe6bEWK0cgwSbbjqJOtVw2+Z0u4uY59u?=
 =?us-ascii?Q?twaxQN9HTP+pImALypHfUcgcKqdIVN9j66x1GBnan4XwUapoIenDV6C2VehU?=
 =?us-ascii?Q?r6pbq1ffxAj5cmhR9HSTTtnt9zxhWlJt1BIycvSsG1Jo9SzaFpnREpSMkV02?=
 =?us-ascii?Q?WJOnEG+cnTkvI7gPrWkhqhHSCf3YQVUOPkaGLEx7PtOJFtGdfcd15k8wAHJJ?=
 =?us-ascii?Q?iP2YYzm+4HFTTA2SUA6Y5X4uwHxV8XPKlOqRfkvzo4rnP4iAUj/5zMw9WLIQ?=
 =?us-ascii?Q?6NXyeWB+PfFjjNBOYnNFDkFfMhtp6pKhjRQqrJ1/hFMD4sKW+MnqmiHiTegr?=
 =?us-ascii?Q?UfZRfDMk/uCYH0v+YsA0CRvVMFz9rRsRrcBO2+jIAe2jmzY3roKuT6uSlibF?=
 =?us-ascii?Q?xdW4wxJoZIf01YmfXC8K2ZQtET+hePd+UwfAnHwwUPfMOO7WQ5iBlKiHh4wr?=
 =?us-ascii?Q?TK6tk8vr1+gZkhp9XfqHXprr00szHOsVVRhpKx142GAlmmonkTEvjiyxOn81?=
 =?us-ascii?Q?pOnI/NihDaBFUPYfhwbinqEwDolOXTNNWzSHayvAiIinSyNiwiIWhdtC/5Ff?=
 =?us-ascii?Q?i1lpfvtYGi2c0c/QwAw3fFho5uvcMDRwkfwcyIHbJlYoPkKx5H+zOy7TbKsx?=
 =?us-ascii?Q?uWU4s9vlDSSPNlV1fuoYgLOk5+oea8ENjDoa0GcfVtOgH98kXtpix7SAMLCx?=
 =?us-ascii?Q?CuRSsjHhQvxQFguq/15mV5JHuoOJ2XpB/0Ug29Y2T2iN6GKkeqsJ09PvV2IE?=
 =?us-ascii?Q?yQBXtait7V94fovDv2Z9rdIEgy+62yJAci9L2pePuOf49+4bYmheKCXnOtkD?=
 =?us-ascii?Q?zWK+gz/aDZKOMsE0L+EwCC7l+TrRiwqu1MiQlwd7p1wOzfHqt8qD07j56WrT?=
 =?us-ascii?Q?6pp+mBtTVrzO+Ronyr4mKCtQ1ob5ln4/t7mBN/ELVC+9wlGQ5WTYNCtupGod?=
 =?us-ascii?Q?CprG6Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8d32870-c90d-4c72-399f-08db61f16383
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 16:09:19.4374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WU8I58zo49duxBPC3laoKpiYIlqRRAlGQDsf1z3gfxaR6TZOu3KEUVqJRz3IhmX8YMypQw8lRDuwX5J1IIGu0zXBjAbDTsWW9uCXt7pU128=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5700
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+ Dan Carpenter

On Wed, May 31, 2023 at 12:35:10AM +0000, Bobby Eshleman wrote:
> This commit adds support for datagrams over virtio/vsock.
> 
> Message boundaries are preserved on a per-skb and per-vq entry basis.
> Messages are copied in whole from the user to an SKB, which in turn is
> added to the scatterlist for the virtqueue in whole for the device.
> Messages do not straddle skbs and they do not straddle packets.
> Messages may be truncated by the receiving user if their buffer is
> shorter than the message.
> 
> Other properties of vsock datagrams:
> - Datagrams self-throttle at the per-socket sk_sndbuf threshold.
> - The same virtqueue is used as is used for streams and seqpacket flows
> - Credits are not used for datagrams
> - Packets are dropped silently by the device, which means the virtqueue
>   will still get kicked even during high packet loss, so long as the
>   socket does not exceed sk_sndbuf.
> 
> Future work might include finding a way to reduce the virtqueue kick
> rate for datagram flows with high packet loss.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>

...

Hi Bobby,

some feedback from my side.

> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c

...

> @@ -730,11 +754,18 @@ int vsock_bind_stream(struct vsock_sock *vsk,
>  }
>  EXPORT_SYMBOL(vsock_bind_stream);
>  
> -static int __vsock_bind_dgram(struct vsock_sock *vsk,
> -			      struct sockaddr_vm *addr)
> +static int vsock_bind_dgram(struct vsock_sock *vsk,
> +			    struct sockaddr_vm *addr)
>  {
> -	if (!vsk->transport || !vsk->transport->dgram_bind)
> -		return -EINVAL;
> +	if (!vsk->transport || !vsk->transport->dgram_bind) {
> +		int retval;

nit: blank line here

> +		spin_lock_bh(&vsock_dgram_table_lock);
> +		retval = vsock_bind_common(vsk, addr, vsock_dgram_bind_table,
> +					   VSOCK_HASH_SIZE);
> +		spin_unlock_bh(&vsock_dgram_table_lock);
> +
> +		return retval;
> +	}
>  
>  	return vsk->transport->dgram_bind(vsk, addr);
>  }

...

> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c

...

> @@ -47,7 +76,8 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
>  			   u32 src_cid,
>  			   u32 src_port,
>  			   u32 dst_cid,
> -			   u32 dst_port)
> +			   u32 dst_port,
> +			   int *errp)
>  {
>  	const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
>  	struct virtio_vsock_hdr *hdr;
> @@ -55,9 +85,21 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
>  	void *payload;
>  	int err;
>  
> -	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
> -	if (!skb)
> +	/* dgrams do not use credits, self-throttle according to sk_sndbuf
> +	 * using sock_alloc_send_skb. This helps avoid triggering the OOM.
> +	 */
> +	if (info->vsk && info->type == VIRTIO_VSOCK_TYPE_DGRAM) {
> +		skb = virtio_transport_sock_alloc_send_skb(info, skb_len, GFP_KERNEL, &err);
> +	} else {
> +		skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
> +		if (!skb)
> +			err = -ENOMEM;
> +	}
> +
> +	if (!skb) {
> +		*errp = err;
>  		return NULL;
> +	}
>  
>  	hdr = virtio_vsock_hdr(skb);
>  	hdr->type	= cpu_to_le16(info->type);
> @@ -102,6 +144,7 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,

Smatch that err may not be initialised in the out label below.

Just above this context the following appears:

	if (info->vsk && !skb_set_owner_sk_safe(skb, sk_vsock(info->vsk))) {
		WARN_ONCE(1, "failed to allocate skb on vsock socket with sk_refcnt == 0\n");
		goto out;
	}

So I wonder if in that case err may not be initialised.

>  	return skb;
>  
>  out:
> +	*errp = err;
>  	kfree_skb(skb);
>  	return NULL;
>  }

...

