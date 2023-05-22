Return-Path: <netdev+bounces-4300-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16FB570BF52
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCD5D1C209F4
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE42F13ACC;
	Mon, 22 May 2023 13:12:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E6D13AC4
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:12:09 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2138.outbound.protection.outlook.com [40.107.92.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041FE186;
	Mon, 22 May 2023 06:11:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvkjGLP1quNpgznahc6D6uUECMGtgJJs0VjPXqKeEYoV1S+F1ox8tVSkfEW4ojrhJlU5WiTuJ/tb3BqWuqUw0diI3jua/09atrDI+dEdgW2gi9y5KmzhzUeC62sIDp8+wMwiBRnZ07EJ1LttRHcR0fZFQ+nG74aDWOTwjDijjlPKebXRkb1odY2ZFQL7Qgp/nzxUWpKij7qpTNP2v+uT06/eXyizq4OVmu2fPlwo/1Xh02UtCKFhgO2K1m1+XiphP2J5Hh2lOa30h9Kj7PkUHSgGJg2c6CIeVkGC4f+lAJMwxxlS865l9dWwsRIGUQXu8XNZxfzpp2AyoBH6FU92ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=erAXgPI8uubtUVkKqI7MGjvk+EBWhdbYz3XOniZmA6w=;
 b=UsIPypfq+D+wskgNnOQIxL5ITaGKuvdJ7cGXQXR2yMjDT7Ht3Xy+fZFwMyN1wcnBNWVOV8BUJrb59lC+NgLWTeAdCty5yvCM4zbud2LJ9+uLRdQqtuQ+1j+INqmHjjKSj33JGCEqZil7SkYD6a96Ys2KBS43TC0rgQKpJ9YCCIlS9rqHZEvK4CqMn2n/QqXZodcUqOhop2syn1+Fpvg6qSzAwoFUrFPaZDquOtZq49tFyzQUpmmAm7V1UFLDNNtNx8r6JjEXFIu/yO7QogXPS42ZnKj6C/CX7LlFmnU1NN9LaaoU7BjRpvQDWCvZ2JFMqlyXGsoHW9m9IwnrqLcliw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erAXgPI8uubtUVkKqI7MGjvk+EBWhdbYz3XOniZmA6w=;
 b=F+vIB6srtvM7WLwncbX4cck3GFzflSuDlmMbC/oyToB2BMVjH8NHw2CI0lnVp8o8vqXYuvnPC41CUr73NFi7FIQreRVp2TYYjPMokrpYFI78FToDh35MDTu9vCwxPGU2lRmiBXEDjesFcWrHxxdvFhGwWZxlFVDvfC2Nf7fZqjo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS0PR13MB6307.namprd13.prod.outlook.com (2603:10b6:8:12a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Mon, 22 May
 2023 13:11:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 13:11:54 +0000
Date: Mon, 22 May 2023 15:11:46 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 05/17] vsock/virtio: MSG_ZEROCOPY flag support
Message-ID: <ZGtqEghjjiBnvEBW@corigine.com>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
 <20230522073950.3574171-6-AVKrasnov@sberdevices.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522073950.3574171-6-AVKrasnov@sberdevices.ru>
X-ClientProxiedBy: AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS0PR13MB6307:EE_
X-MS-Office365-Filtering-Correlation-Id: 30a179df-8334-43ae-fa91-08db5ac61ce2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gwtqIsW3XlGHePr6gfT9l+aYndmfLwjJvxcA4kHME8+rH9f9+In4VrEH3f3ncot74dSdpI5JF3rAnoRDQxGBf3GQSrQ9iqXKMk9JmZksyJOQNR+KFF5E+OTZSIzH5wfPA9N1k3xASpiZsxSHhDVZ2gfvho/lwEn/lvoXrqM0u2OqMtKQFo9I16WNaA6VQqEvca2o8wjKftfdMTrZoHgm8WKjtzlzkB+cXKBympXQG4gdI5DcA5cp8zVlz2ZJITkofgX55qvEppxaDlZfmAa2V+AS6RmkLNyu6SURHPbGCUKFDvSp3RBh8IHUuvGpKWesIbm1xqeiQ+sFZV3P680v440/g13T9lh0yQFCwqUo1L6FyZ0mNqt7Cjf3vnsPKwwhWuqknggM8G6vTbg4oDYaHxGsMT7BXvXoEXqmNP5EnQWWxNUElN/nKDFu+H418UzMxLx82Ob3KY7OYmJoAxq6VeD1tzVaMJ/hPtJij68TPEattuC+/h+MTbTjhhJgnSx/SUEEW3sH26hgaXzTVw7QIAzD7mSlhVlWga780GpGVlfIT2qnCTAq8kdjO5WmZs6V
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39840400004)(136003)(376002)(346002)(451199021)(66946007)(6916009)(66556008)(66476007)(478600001)(4326008)(54906003)(316002)(86362001)(36756003)(83380400001)(2616005)(6506007)(186003)(6512007)(5660300002)(7416002)(44832011)(2906002)(8936002)(41300700001)(6666004)(38100700002)(8676002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XlNF/C0N3Gfzkucp9LVHbktoTbO3H/sENt0q336ORS/fsm74uf1MVcxmxjYs?=
 =?us-ascii?Q?8hGAVmJvmkkdixteu3DdSG7jnchnwSBu89LnWj7axnjAq8vokt0VR6sUsM+L?=
 =?us-ascii?Q?myG8xnNrr6qwo0uc5+8FmJ5XMVp3FPBCf4U+khym8JMxAQxcpVCG9tHykcMl?=
 =?us-ascii?Q?OJo464yESlkWl9vK861JL/Npw97ed8TUqz1qAoH7rrEdluzY2DPsPEW/NfAb?=
 =?us-ascii?Q?wCqaWl/K7ayNasv3O6xL/X/f+pNeFg27trar/Olmd6GrYWDgI4R8jMv1M4II?=
 =?us-ascii?Q?A2YdfcZPATU5AheIuSx8puX33c0wq9KwICj406ljQDupg6WM7Suj/Ce2gh2d?=
 =?us-ascii?Q?bwTGu5nhVOYFf5BhlDgtgc3EVNSqZs7HKsIGhI9ajS5TeVAEsa68mMMwdk/x?=
 =?us-ascii?Q?Kyt52Cvu4U1alCSlfV1Lxpw/2Lv31vSut45koDVISmzgaqDg9AGe4fcvdOzb?=
 =?us-ascii?Q?A5/kTBgm0KZM4WHgzMJ+2lJjfS24he8+63sPGhSd2ONQGNIcAt5DRgjeylEQ?=
 =?us-ascii?Q?WbrMMvD6UOWHmbsqt6x8EZBo9DRGUyPrcL2aw34V8yBb96rxkUlrIsANzT0f?=
 =?us-ascii?Q?M8VZHAolKQrO++yUCYhUPg9VWMQUviBcwRltq4w871uwxM8UI2OSs0nzN5dE?=
 =?us-ascii?Q?zoUve3n0skBV4l7nPU3gz4AZwxjQlnE0S1NDc2EaY9cz3YVOJ8q8mqwtPVzZ?=
 =?us-ascii?Q?5mmkoO1fjexkALCTt9QTuRMAd9Ix/FJNGNj3jTz7WDpxxLKhAlhAdzKBF4/I?=
 =?us-ascii?Q?+DttcawZEBsFLYz2UEGdrcf8YZVzaNa/pOsGC/pYVw59ydrvcG/gkta7K7YY?=
 =?us-ascii?Q?Z6PEiVWrc7siJ+tjfMsNQFm0ImdOD11zu9wBNU03Anml5zLxGyvUGog1UWg0?=
 =?us-ascii?Q?r8szT0848vtLcUsqVnwhnklO+wue5rtx3VCE4L4q9ksAwvs3cJr5AaNjthZ/?=
 =?us-ascii?Q?xGJx/bYKnDxUqPISv8DEO8tUjE3O4nsikGgxZUS9qJMY+cBZj0N8qGXyh3pJ?=
 =?us-ascii?Q?BY2oduHLQvqO+Nl1m+9+Eoj7BLX3y9TYI4uWJHSZciy/UYb4n+BzTttNdfbo?=
 =?us-ascii?Q?gMIhbqzdslf0HWGGL2HoE//gBDajxYQSr2flSMxGF1KsheH4E8x0KDrC0D9Y?=
 =?us-ascii?Q?/CdmRDoUx8yVn8Tk8rrECSsT7Elf1DyTWUb80rZUuZ3Vs9vk3/XRshjO7ikD?=
 =?us-ascii?Q?Iw7987hUgJBjz3IyZ8WpHtx8WW0MPwr7+A/6sv3FEfEqFubxRkEeJMFsQLdz?=
 =?us-ascii?Q?6vug2FTGqntIgQonGnAZB1ABYTqQFZlUTBvTa+Ue61jifG9mOP8tIgkkKnWL?=
 =?us-ascii?Q?PXghwq1l2EuCEaklr2wyhXMOD42awSgC/CTHQsnFDUUEEl2rsTtypzqdQCq2?=
 =?us-ascii?Q?9Nu6qdK0B/wHeD36pvrkL+ph5Lnh7aGBv9gyu6KXYr6gAhV17x4SfBYdBPx4?=
 =?us-ascii?Q?l4aY0IRL/rk0xG5+ITlR8y4FLdnHYyAEfwxNw9pCXvGOz20+OuXSb9tnWqS2?=
 =?us-ascii?Q?mIqnwcmdBQgV+YAB8My7Nt8RLcTz3IRDFgVk4glOMcF2Dyr2kVkQNMbCXFPC?=
 =?us-ascii?Q?XPhwn2pt/LuFGJ0rShvdMua339YtIEak64NBpQC2LpgOnog6nVrmWWPc9M0z?=
 =?us-ascii?Q?x+sy/0mLFs2bzVIhQjcMzmkIFLjUVljgXl7Sp05+llG8osdApKuyGGN9JqAp?=
 =?us-ascii?Q?lkdIsQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a179df-8334-43ae-fa91-08db5ac61ce2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 13:11:53.9840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vDy4qj9Xlisxbz1qcZDsjSUB+yUq9XBzFaVCp98bMAIwnl1gjdVkiv+imWbmzbqBBoskLn2l7RyqH7Mt8+gdjQIC8QNQ/w7R3VtYhaKHfIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR13MB6307
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 10:39:38AM +0300, Arseniy Krasnov wrote:
> This adds handling of MSG_ZEROCOPY flag on transmission path: if this
> flag is set and zerocopy transmission is possible, then non-linear skb
> will be created and filled with the pages of user's buffer. Pages of
> user's buffer are locked in memory by 'get_user_pages()'.
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 305 +++++++++++++++++++-----
>  1 file changed, 243 insertions(+), 62 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 9854f48a0544..5acf824afe41 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -37,73 +37,161 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
>  	return container_of(t, struct virtio_transport, transport);
>  }
>  
> -/* Returns a new packet on success, otherwise returns NULL.
> - *
> - * If NULL is returned, errp is set to a negative errno.
> - */
> -static struct sk_buff *
> -virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
> -			   size_t len,
> -			   u32 src_cid,
> -			   u32 src_port,
> -			   u32 dst_cid,
> -			   u32 dst_port)
> -{
> -	const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
> -	struct virtio_vsock_hdr *hdr;
> -	struct sk_buff *skb;
> -	void *payload;
> -	int err;
> +static bool virtio_transport_can_zcopy(struct virtio_vsock_pkt_info *info,
> +				       size_t max_to_send)
> +{
> +	struct iov_iter *iov_iter;
> +	size_t max_skb_cap;
> +	size_t bytes;
> +	int i;
>  
> -	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
> -	if (!skb)
> -		return NULL;
> +	if (!info->msg)
> +		return false;
>  
> -	hdr = virtio_vsock_hdr(skb);
> -	hdr->type	= cpu_to_le16(info->type);
> -	hdr->op		= cpu_to_le16(info->op);
> -	hdr->src_cid	= cpu_to_le64(src_cid);
> -	hdr->dst_cid	= cpu_to_le64(dst_cid);
> -	hdr->src_port	= cpu_to_le32(src_port);
> -	hdr->dst_port	= cpu_to_le32(dst_port);
> -	hdr->flags	= cpu_to_le32(info->flags);
> -	hdr->len	= cpu_to_le32(len);
> +	if (!(info->flags & MSG_ZEROCOPY) && !info->msg->msg_ubuf)
> +		return false;
>  
> -	if (info->msg && len > 0) {
> -		payload = skb_put(skb, len);
> -		err = memcpy_from_msg(payload, info->msg, len);
> -		if (err)
> -			goto out;
> +	iov_iter = &info->msg->msg_iter;
> +
> +	if (iter_is_ubuf(iov_iter)) {
> +		if (offset_in_page(iov_iter->ubuf))
> +			return false;
> +
> +		return true;
> +	}
> +
> +	if (!iter_is_iovec(iov_iter))
> +		return false;
> +
> +	if (iov_iter->iov_offset)
> +		return false;
> +
> +	/* We can't send whole iov. */
> +	if (iov_iter->count > max_to_send)
> +		return false;
> +
> +	for (bytes = 0, i = 0; i < iov_iter->nr_segs; i++) {
> +		const struct iovec *iovec;
> +		int pages_in_elem;
> +
> +		iovec = &iov_iter->__iov[i];
> +
> +		/* Base must be page aligned. */
> +		if (offset_in_page(iovec->iov_base))
> +			return false;
>  
> -		if (msg_data_left(info->msg) == 0 &&
> -		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
> -			hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
> +		/* Only last element could have non page aligned size. */
> +		if (i != (iov_iter->nr_segs - 1)) {
> +			if (offset_in_page(iovec->iov_len))
> +				return false;
>  
> -			if (info->msg->msg_flags & MSG_EOR)
> -				hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
> +			pages_in_elem = iovec->iov_len >> PAGE_SHIFT;
> +		} else {
> +			pages_in_elem = round_up(iovec->iov_len, PAGE_SIZE);
> +			pages_in_elem >>= PAGE_SHIFT;
>  		}
> +
> +		bytes += (pages_in_elem * PAGE_SIZE);
>  	}

Hi Arseniy,

bytes is set but the loop above, but seems otherwise unused in this function.

>  
> -	if (info->reply)
> -		virtio_vsock_skb_set_reply(skb);
> +	/* How many bytes we can pack to single skb. Maximum packet
> +	 * buffer size is needed to allow vhost handle such packets,
> +	 * otherwise they will be dropped.
> +	 */
> +	max_skb_cap = min((unsigned int)(MAX_SKB_FRAGS * PAGE_SIZE),
> +			  (unsigned int)VIRTIO_VSOCK_MAX_PKT_BUF_SIZE);

Likewise, max_skb_cap seems to be set but unused in this function.

>  
> -	trace_virtio_transport_alloc_pkt(src_cid, src_port,
> -					 dst_cid, dst_port,
> -					 len,
> -					 info->type,
> -					 info->op,
> -					 info->flags);
> +	return true;
> +}

...

