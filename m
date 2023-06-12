Return-Path: <netdev+bounces-10220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D881C72D063
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:24:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07E401C20B04
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96218C138;
	Mon, 12 Jun 2023 20:24:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B628F5F
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 20:24:21 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902C819B;
	Mon, 12 Jun 2023 13:24:19 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-653f9c7b3e4so3686652b3a.2;
        Mon, 12 Jun 2023 13:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686601459; x=1689193459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3BlD0eFxk9JA2Y17dTnj4ztqyoGe9HUFhDj3qpNJ2LU=;
        b=lDIuYJhZVN6yQXu7zcbXsXJY4Gc88rqLJ74xnhgc0NuL3ARAZA8orYmKVSOLV43aML
         ++W9C5mmmnpmHNORywokYEDEJmK0Ix+Z7XT8rjHZdNbT8L6hjBaYF9nPmI2brch6pRB8
         kamIbnUjGAI9cXl5TC/W8/itcmL7xmN4+iE8cEauLUxBGX4rUAEKTbjRCpAvKkQTwLiq
         vahbbb2JVxQ7VQ2ny8V5+ERuszx9MQI8jJtzvXD9Abu3+pjO/NgKj/TExAkBsXsmAfJD
         VhzdKP1tMsyND3/qY/a4HMxEZn77+vl1ROrNiSBXHd8bwCROvilLDUcD9uBQwYXWJH4Q
         0NAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686601459; x=1689193459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3BlD0eFxk9JA2Y17dTnj4ztqyoGe9HUFhDj3qpNJ2LU=;
        b=Mn2mcLe36ZEZddAGWqK2RS1fiw6cwRZjhEzw1IK1u3L+EBk2KbM7qIBn1M9YVgWz4d
         5w73PomS0uHVNV7e1YkIzrZzwF+Qu42LhSBtm7W1T9ZyWFuAzAsa8l+zeP04vv1CNiOu
         jf5Hquj74op+jfpUzFHM/scToHAkZyaoR7sFc4KuJijf7V4GlTCSwgcfcr74asE66Snx
         2xmf+vBHqEantD9bf+QAkegnH1lg96u6O26SGQSFXi/s8oA9rmOf7mbJ/wLR4VdCrpg+
         tPH41gMk1PJJpRQg/2TYzv/lwGv9T310wUJ3yCWriDG6hoP3Cj+iTThn7Qy0zjhqMSDH
         cYJA==
X-Gm-Message-State: AC+VfDwl02DvVdzNecEkZOkLdcp4EyPPrN08803EYjSkzlFiCUClHBjz
	ele+Ma6kUINjSiu2CwNALvw=
X-Google-Smtp-Source: ACHHUZ6dzH3pfkRpOOuFnjOjoVCxLb+7MvstvsH8N3/589NgjWFu+zcR7yMh4U9mwn9QhMlGy7yv1Q==
X-Received: by 2002:a05:6a20:1445:b0:111:2f20:d48f with SMTP id a5-20020a056a20144500b001112f20d48fmr11620903pzi.53.1686601458890;
        Mon, 12 Jun 2023 13:24:18 -0700 (PDT)
Received: from localhost (ec2-52-8-182-0.us-west-1.compute.amazonaws.com. [52.8.182.0])
        by smtp.gmail.com with ESMTPSA id x3-20020aa793a3000000b0063d47bfcdd5sm4254774pff.111.2023.06.12.13.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 13:24:18 -0700 (PDT)
Date: Mon, 12 Jun 2023 18:30:04 +0000
From: Bobby Eshleman <bobbyeshleman@gmail.com>
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
Subject: Re: [RFC PATCH v4 03/17] vsock/virtio: support to send non-linear skb
Message-ID: <ZIdkLI8TMMzIgI7d@bullseye>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-4-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230603204939.1598818-4-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 03, 2023 at 11:49:25PM +0300, Arseniy Krasnov wrote:
> For non-linear skb use its pages from fragment array as buffers in
> virtio tx queue. These pages are already pinned by 'get_user_pages()'
> during such skb creation.
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> ---
>  net/vmw_vsock/virtio_transport.c | 37 ++++++++++++++++++++++++++------
>  1 file changed, 31 insertions(+), 6 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index e95df847176b..6053d8341091 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -100,7 +100,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  	vq = vsock->vqs[VSOCK_VQ_TX];
>  
>  	for (;;) {
> -		struct scatterlist hdr, buf, *sgs[2];
> +		/* +1 is for packet header. */
> +		struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
> +		struct scatterlist bufs[MAX_SKB_FRAGS + 1];
>  		int ret, in_sg = 0, out_sg = 0;
>  		struct sk_buff *skb;
>  		bool reply;
> @@ -111,12 +113,35 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  
>  		virtio_transport_deliver_tap_pkt(skb);
>  		reply = virtio_vsock_skb_reply(skb);
> +		sg_init_one(&bufs[0], virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
> +		sgs[out_sg++] = &bufs[0];
> +
> +		if (skb_is_nonlinear(skb)) {
> +			struct skb_shared_info *si;
> +			int i;
> +
> +			si = skb_shinfo(skb);
> +
> +			for (i = 0; i < si->nr_frags; i++) {
> +				skb_frag_t *skb_frag = &si->frags[i];
> +				void *va = page_to_virt(skb_frag->bv_page);
> +
> +				/* We will use 'page_to_virt()' for userspace page here,
> +				 * because virtio layer will call 'virt_to_phys()' later
> +				 * to fill buffer descriptor. We don't touch memory at
> +				 * "virtual" address of this page.
> +				 */
> +				sg_init_one(&bufs[i + 1],
> +					    va + skb_frag->bv_offset,
> +					    skb_frag->bv_len);
> +				sgs[out_sg++] = &bufs[i + 1];
> +			}
> +		} else {
> +			if (skb->len > 0) {
> +				sg_init_one(&bufs[1], skb->data, skb->len);
> +				sgs[out_sg++] = &bufs[1];
> +			}
>  
> -		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
> -		sgs[out_sg++] = &hdr;
> -		if (skb->len > 0) {
> -			sg_init_one(&buf, skb->data, skb->len);
> -			sgs[out_sg++] = &buf;
>  		}
>  
>  		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
> -- 
> 2.25.1
> 

LGTM.

Reviewed-by: Bobby Eshleman <bobby.eshleman@bytedance.com>

