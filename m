Return-Path: <netdev+bounces-10215-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9B4B72CFD4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FF562810C0
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E316A92A;
	Mon, 12 Jun 2023 19:50:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A688833
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 19:50:31 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2523ED7;
	Mon, 12 Jun 2023 12:50:30 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b3be39e35dso17592905ad.0;
        Mon, 12 Jun 2023 12:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686599429; x=1689191429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MOoF/vQdU2Aiyxi0xZ9RaUaGYrilRuj0Hy/ULdNFUkM=;
        b=VGCSEi5r6+cjMh8b1JNLTuOhx9yuyd298tWlU300TiX99Gxq/wJv9a51hTTj/FEmyV
         +k1Qy+dpUQBH3hEPowT4Nax1I520pqfGtmnOsBart4a89ciniDOkut0vAANtidufjudJ
         xcmrPRoWDRvICajBmfxkjx32TfR2Aw4C6HdHCDRIXSDpH+N09P8CblI+24WNVfBplgut
         lI1PM64dawMStNcv6eRLkOY6nuu1Xqg1i06RMoRUGIbqhdNpcTHXsetWToRdc8cD3TXZ
         TA38DBh0qSQDLqqPBTgwvJnDS3Y2Y8FmGRYCFzJVmB7cFnoTeRqPyQhDihEIur+fKd46
         yw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686599429; x=1689191429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOoF/vQdU2Aiyxi0xZ9RaUaGYrilRuj0Hy/ULdNFUkM=;
        b=eoGV6TymAXDNK3Z1K/Hp5GqfgxsuDNlSf1p3+vngn1wBff5WeMRccIpI2XRBHK+wJN
         t7rDmBtcuL9bOerokFxD+tWWZuq3v6Ispa99uY7aIpS1OuYGVh1yzx9Ll/e8/XefcG4D
         8iZJoh3gjUsTnomo7zcloM4WA5UEaXYOZdypRBsu84Rf70SiikNx/0H1M/m9zFQ2U4na
         sDN5K2m/QEiTgvcqr2X1Rh79YTXNTxGPU2w0P9ONEE5xb4hRinFEeNRcHBMgbixUaL62
         wwWkRTV7MkzksK/JOvHrM06DdL4P1PG+cF/BMncUSHEo1u7ihDQ+c7tzeaKaLkqk6zU5
         Uglg==
X-Gm-Message-State: AC+VfDzw6T8djpssPQe+bPhRf4WURP3nK4Pv3+Tbc0nvX4GxW2Et5yHs
	6pbXp9nRE4g3C+Mnk8Cbw6c=
X-Google-Smtp-Source: ACHHUZ7OhPai3uWA834fndvGh2fiP+1+6Wo2P992KJGLAFBRrwQ7rrU2gppW9O17Sl6bSGfcaSEL9w==
X-Received: by 2002:a17:902:d2c4:b0:1ab:253e:6906 with SMTP id n4-20020a170902d2c400b001ab253e6906mr8708967plc.67.1686599429472;
        Mon, 12 Jun 2023 12:50:29 -0700 (PDT)
Received: from localhost (ec2-52-8-182-0.us-west-1.compute.amazonaws.com. [52.8.182.0])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902ab8c00b001aaed524541sm8622843plr.227.2023.06.12.12.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 12:50:29 -0700 (PDT)
Date: Mon, 12 Jun 2023 17:53:25 +0000
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
Subject: Re: [RFC PATCH v4 02/17] vhost/vsock: read data from non-linear skb
Message-ID: <ZIdblVkbADonJzNY@bullseye>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-3-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230603204939.1598818-3-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 03, 2023 at 11:49:24PM +0300, Arseniy Krasnov wrote:
> This adds copying to guest's virtio buffers from non-linear skbs. Such
> skbs are created by protocol layer when MSG_ZEROCOPY flags is used. It
> changes call of 'copy_to_iter()' to 'skb_copy_datagram_iter()'. Second
> function can read data from non-linear skb.
> 
> See commit to 'net/vmw_vsock/virtio_transport_common.c' with the same
> name for more details.
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> ---
>  drivers/vhost/vsock.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 6578db78f0ae..b254aa4b756a 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -156,7 +156,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  		}
>  
>  		iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[out], in, iov_len);
> -		payload_len = skb->len;
> +		payload_len = skb->len - VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
>  		hdr = virtio_vsock_hdr(skb);
>  
>  		/* If the packet is greater than the space available in the
> @@ -197,8 +197,10 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  			break;
>  		}
>  
> -		nbytes = copy_to_iter(skb->data, payload_len, &iov_iter);
> -		if (nbytes != payload_len) {
> +		if (skb_copy_datagram_iter(skb,
> +					   VIRTIO_VSOCK_SKB_CB(skb)->frag_off,
> +					   &iov_iter,
> +					   payload_len)) {
>  			kfree_skb(skb);
>  			vq_err(vq, "Faulted on copying pkt buf\n");
>  			break;
> @@ -212,13 +214,13 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  		vhost_add_used(vq, head, sizeof(*hdr) + payload_len);
>  		added = true;
>  
> -		skb_pull(skb, payload_len);
> +		VIRTIO_VSOCK_SKB_CB(skb)->frag_off += payload_len;
>  		total_len += payload_len;
>  
>  		/* If we didn't send all the payload we can requeue the packet
>  		 * to send it with the next available buffer.
>  		 */
> -		if (skb->len > 0) {
> +		if (VIRTIO_VSOCK_SKB_CB(skb)->frag_off < skb->len) {
>  			hdr->flags |= cpu_to_le32(flags_to_restore);
>  
>  			/* We are queueing the same skb to handle
> -- 
> 2.25.1
> 

LGTM.

Reviewed-by: Bobby Eshleman <bobby.eshleman@bytedance.com>

