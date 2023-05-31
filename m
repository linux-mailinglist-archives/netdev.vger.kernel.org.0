Return-Path: <netdev+bounces-6861-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C83771873D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:22:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50B5328153B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5808317ABB;
	Wed, 31 May 2023 16:22:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDAF174C6
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:22:33 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2107.outbound.protection.outlook.com [40.107.237.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ED611F;
	Wed, 31 May 2023 09:22:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkJdLkPiEcOpZgc34EBWi4MWxnpxPaPfiJbZm0i4F0ly2+xXlf6g0b4mdLb2yuzn6zdzy4TyMFglfpNAac7zGfWSR8Te6W9MY7qGNa+AIFiHF5pj34FGXGzN33RLLXHuhQ6JM7B4bWN90ZkxxrOAfYv63jRqD8oPvlAGHgv5QaiNKsQTFa1GHWS5Xu4zGxwvcEfjRJYlmIbPoFCbI2UFbbDZr3toTrX0XIQ0nYtzB3RDc4/AXCBBdBRL8lvFxypCgpx0IW1O5nc1LjFoqtdHxJmggoj1KmEq/w1tZiPTHh8V/+rBzP/zHfGmWSKaMOBamsezDbdo8Ofr1rMSODMPSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+jiX4gOd+HKCSgYdLy/OMll4IUn+PDUpdkkx3aLcpWw=;
 b=QM5+kETjC6h1GyDlYZHucTcomMds2y7nFP0aoFfkGLpyneVH/2BzK62jaKph2IrO4edNZV/syYXEcGfpf8BFDKtJwUA5JJWpGry+GylUZCXhAE+V2yKvRXz+NcfgeYEOZ07Y9a7fO5m4n3aqzDrTWeKI5WX9SyBhsuzM6YihmVUDpVEmDGZ6U8QA5E8t2Jy9MhvfUe83Z7EBTWc2Pafl0IcDPrikEJKpIN3dNs9OIP1VhcURNcghEBZ21DK9Fb41JGS1YvaHzqYhgIkYAi2eahY9iKjkq+yThcdhRKESfdqzDOwecOVafGJwo/1LIHcAtSVNTPEHUM7CJOnI732j7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+jiX4gOd+HKCSgYdLy/OMll4IUn+PDUpdkkx3aLcpWw=;
 b=Z4tlrCcaaweNC0Ybchv+M+igDDbO+v52nIKlYp8FN998brgPDv3/H4JRm7/qiJiCa5sE0mWIi1aS56MZq8UhzY2PJQksz27fFPY4z+15K0/f0KhqPiuVqULMzuHhx8q83GIUeKLGEvJQ373gzTEJwdjjPOTJNwQsA8d0Y1+BuUk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3717.namprd13.prod.outlook.com (2603:10b6:610:9d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 31 May
 2023 16:22:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:22:27 +0000
Date: Wed, 31 May 2023 18:22:19 +0200
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
	linux-hyperv@vger.kernel.org
Subject: Re: [PATCH RFC net-next v3 7/8] vsock: Add lockless sendmsg() support
Message-ID: <ZHd0O1L7FH2XJEnd@corigine.com>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
 <20230413-b4-vsock-dgram-v3-7-c2414413ef6a@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v3-7-c2414413ef6a@bytedance.com>
X-ClientProxiedBy: AM9P193CA0022.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3717:EE_
X-MS-Office365-Filtering-Correlation-Id: dafe0ad1-1ade-4b73-c472-08db61f33955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qKmKnvy7fEaWPN7JatqObqxvLGdbf+x43AhsZUofHmTy9TSkNAvTiexF7lWOzJa70qMVPz5UYeeVQeu3An/bVLNZmM4oP5yViGgJfI2QqJMo1jNC69Pi+6Y1owZoyEJLkC5acQG6KajG1ceCZJB/HZhlgCqiX87odxq5+vL4JPLaLMhScyGMKtFD/j3AxydgI4fw7gD+xGb78gTYC4fpX4a0kTIvoLhqWozOo/CgCnNkLpNZrBH1Ur8uP2pBKQpYr3u4m25fBDn1Ulhv8JAq+ax5qGOiaO4ToVNdjh9iar3fKJgI1x1qf0qWB9FfgSn8cXqyOUjbxaQv1PFTov6J89CfzRZNxyiPnPvHeqIJbWaDk2bmaL5Par1NKmr0iozv+rED7lLLe2ZMlWcudqcPPo9wJnLTzrb4sHNACiQyHSmq8NdMzwYniilNjdYNDOCki2MMUX4u9VVsnATO2NZCssEa3ycIrjUdWtwpuQEzcYoT5zaR/z3Bi3t67JlwHAzCTvJ/KGvYB8Wsrnxx2rJEbfaeJApF2vFzRGlzyfnx4m289hObTUi87l86LCqC8OlF3Z1y0n2Fe0l0lmR/Nl4JktO+U9buTGmDsJxVtrkgh08=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(136003)(376002)(39840400004)(451199021)(36756003)(6666004)(38100700002)(41300700001)(6486002)(5660300002)(54906003)(478600001)(2616005)(6512007)(2906002)(44832011)(6506007)(86362001)(186003)(7416002)(83380400001)(4326008)(8936002)(66946007)(6916009)(66476007)(8676002)(316002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vg8sEP3ZReXmc0eHMfNOXBsnhq1I3zHEzEEEVsauF9Kctai/NS9rsxSkf5KU?=
 =?us-ascii?Q?mW9KA4uTVUudzPKcKbuVyzRTLCeeeOsTiQOM/57DeC1V9vyHs3WpXQEuAzlo?=
 =?us-ascii?Q?bK8swoLHOhpI+szypXjReR0BkOriNCkfFj2yOZALrgiWOqrKvL3AdqGOpbQX?=
 =?us-ascii?Q?+SQH/PDtgKaj9mTBpLItMRB6266Me7O8C7WyByl+PsIzf2woSAZ7C0zC/M1H?=
 =?us-ascii?Q?Pky6c8ZkGeWY4pgEWwREunKGSzyieVZhIL1iFl5xfIICwwBPxburryPaf99o?=
 =?us-ascii?Q?/qu9L/9X1QlYPGu1QOjQiOt2PCmiXByjY+AwbBOsL3uGpv6nG0NmGkQPXLhE?=
 =?us-ascii?Q?b5ZKFvKYoM5JorgD6VRnn0LPnwP3c/e2E+ljeXzoINfARkivfd3/9DPvp8vj?=
 =?us-ascii?Q?lgtluAJJ/6cd9VQ/rcH181eu6+BeJ57HIA+LGamQ6Y+y5TVJ0XiYn92VilmU?=
 =?us-ascii?Q?4v7Y60XwwQ17aEPc6DN+dHsWq0OqWskejmbwHHehRO1+K83j4ZaHn/bT2c4U?=
 =?us-ascii?Q?0LbAe7ORguXdrWIDF3i9ydCreZsHIV2yCkpFczJrYeA8CuoTKx1oR44MVij/?=
 =?us-ascii?Q?Oyvz/iKKbEJ24GvCS5IoQqDY109RIP7dx9ngTCyxovwadfscPV0GIgfFCDxt?=
 =?us-ascii?Q?j/UiKrxTGbvFeaNuDKmd921TooEPHCKFvJQ8bG+3CZ/po7pH5cW/iuU6Wa6b?=
 =?us-ascii?Q?TpLE+J0/l4TN6YntSwlesYA39StQl13AIDZs5iWu0EroVN2HwgWoWqphUImV?=
 =?us-ascii?Q?emttUDiXDHgUw2K//Qad1SRYyMovsaIXql/i0x8/HQByxqlRMXKcIHdwUFx1?=
 =?us-ascii?Q?eJ9mqN66HSqCfROW2rc18Yr/6L+e1xKdhe2ADe5oLe4eF7ZMqqPDYHGWJ+u/?=
 =?us-ascii?Q?Sa+WnLdK0PvsyXI0pFDa0Z1zYBfmlL4NGLvG+1VhyetVEpVfk6k5kdW76Wa6?=
 =?us-ascii?Q?weXBhsPWolg8eFjgThSaSdwXO0RH57AY7WAIAfPjW12e+qrxTuWqRomYgcOE?=
 =?us-ascii?Q?3hYVe9Abpjv5ddnu+2WTb903lePGhP0zWjftRiVHa4u+dPKFVjOhuWWP3l92?=
 =?us-ascii?Q?9QRYI5CIxyrUFtqbCjgH4kKMpiGfsEqddK3pKV4TeD7j8ZMnJVu4oIz66IZ+?=
 =?us-ascii?Q?UdLf+k47bU7DRI0zC04QqvQUrN/CDxmNrkcNKn395AGZbqA+u8qbIf+BCoFs?=
 =?us-ascii?Q?GnVvBbpIERNiYIC7jAk3o0KKMchNB51IFN2kT15kC7iiBSwkFUoezbLvTWFw?=
 =?us-ascii?Q?7jzdExu31ea3nG2jJJRWxSUqC21JtJm04zbcJRgRyuYrVQ/j9D/MLFHy5LOq?=
 =?us-ascii?Q?c36WFAZbfMp8dngH2uOwQnizON0BvkJvBHnNAE1aSNzqEIxxMiuu4ByPM72z?=
 =?us-ascii?Q?6AIcEgrFUhw4tInZilSfVSYar1N/h+IIu2yFy0RX4fXwSmb1a/QhzRIehV1s?=
 =?us-ascii?Q?ykgWBjPqhjfRaASCP21+Fb/KQtv1NmBoYoYjXHJhmEtztM7DvI3rO63/fsmZ?=
 =?us-ascii?Q?+Lyowq4N4fJL92M0JqOEQdHi81dkDS0nzihJ+O+grqAbfgOHXcOMUyMewqXd?=
 =?us-ascii?Q?lcz/zHgDKCal+haTP0YLyCsgkPpYhf88lS81oEQ4Mg6cgjMDlJV9wGZw1JMR?=
 =?us-ascii?Q?bybClH9iRpRWWnXw72JA3oXcpJCwffwiwX/S/aRjBg5BwnSI7r7n/8t9DUDm?=
 =?us-ascii?Q?bQ//9Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dafe0ad1-1ade-4b73-c472-08db61f33955
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 16:22:27.2722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R1FzCkie19MjJwBjduRnvKipKA2NzRENuWeySDh1c+UDzJvWhyqMZP0HgtixiLhpaBdsrdTOVarFz7FMlj22wGYYB4CC5R3z6Dc0CUqc73I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3717
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 12:35:11AM +0000, Bobby Eshleman wrote:

...

Hi Bobby,

some more feedback from my side.

> Throughput metrics for single-threaded SOCK_DGRAM and
> single/multi-threaded SOCK_STREAM showed no statistically signficant

nit: s/signficant/significant/

> throughput changes (lowest p-value reaching 0.27), with the range of the
> mean difference ranging between -5% to +1%.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>

...

> @@ -120,8 +125,8 @@ struct vsock_transport {
>  
>  	/* DGRAM. */
>  	int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
> -	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
> -			     struct msghdr *, size_t len);
> +	int (*dgram_enqueue)(const struct vsock_transport *, struct vsock_sock *,
> +			     struct sockaddr_vm *, struct msghdr *, size_t len);

Perhaps just a personal preference, but the arguments for these callbacks
could have names.

>  	bool (*dgram_allow)(u32 cid, u32 port);
>  	int (*dgram_get_cid)(struct sk_buff *skb, unsigned int *cid);
>  	int (*dgram_get_port)(struct sk_buff *skb, unsigned int *port);
> @@ -196,6 +201,17 @@ void vsock_core_unregister(const struct vsock_transport *t);
>  /* The transport may downcast this to access transport-specific functions */
>  const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *vsk);
>  
> +static inline struct vsock_remote_info *
> +vsock_core_get_remote_info(struct vsock_sock *vsk)
> +{
> +

nit: no blank line here

> +	/* vsk->remote_info may be accessed if the rcu read lock is held OR the
> +	 * socket lock is held
> +	 */
> +	return rcu_dereference_check(vsk->remote_info,
> +				     lockdep_sock_is_held(sk_vsock(vsk)));
> +}
> +
>  /**** UTILS ****/
>  
>  /* vsock_table_lock must be held */

...

> @@ -300,17 +449,36 @@ static void vsock_insert_unbound(struct vsock_sock *vsk)
>  	spin_unlock_bh(&vsock_table_lock);
>  }
>  
> -void vsock_insert_connected(struct vsock_sock *vsk)
> +int vsock_insert_connected(struct vsock_sock *vsk)
>  {
> -	struct list_head *list = vsock_connected_sockets(
> -		&vsk->remote_addr, &vsk->local_addr);
> +	struct list_head *list;
> +	struct vsock_remote_info *remote_info;

nit: I know that this file doesn't follow the reverse xmas tree
     scheme - longest line to shortest - for local variable declarations.
     But as networking code I think it would be good towards towards
     that scheme as code is changed.

	struct vsock_remote_info *remote_info;
	struct list_head *list;

> +
> +	rcu_read_lock();
> +	remote_info = vsock_core_get_remote_info(vsk);
> +	if (!remote_info) {
> +		rcu_read_unlock();
> +		return -EINVAL;
> +	}
> +	list = vsock_connected_sockets(&remote_info->addr, &vsk->local_addr);
> +	rcu_read_unlock();
>  
>  	spin_lock_bh(&vsock_table_lock);
>  	__vsock_insert_connected(list, vsk);
>  	spin_unlock_bh(&vsock_table_lock);
> +
> +	return 0;
>  }

...

> @@ -1120,7 +1122,9 @@ virtio_transport_recv_connecting(struct sock *sk,
>  	case VIRTIO_VSOCK_OP_RESPONSE:
>  		sk->sk_state = TCP_ESTABLISHED;
>  		sk->sk_socket->state = SS_CONNECTED;
> -		vsock_insert_connected(vsk);
> +		err = vsock_insert_connected(vsk);
> +		if (err)
> +			goto destroy;

The destroy label uses skerr, but it is uninitialised here.

A W=1 or C=1 will probably tell you this.

>  		sk->sk_state_change(sk);
>  		break;
>  	case VIRTIO_VSOCK_OP_INVALID:

...

