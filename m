Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D58A6C14C6
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 15:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjCTObJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 10:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCTOa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 10:30:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD0FB474
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 07:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679322608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fYYltObAoBAJHBew4d0/wtXHVG5SadqFvZoyE4YqRs0=;
        b=f10J4hASCStdxFQIKgNY6DXLgOulvfTtL8ePrMtjc6a9Vez1krOI1Bs9exU2CTKMHOgDkE
        qJBztOZ6+3AWKab1OnAcL4pt3MfoI/WRUOcrbT6R9UbciOXP79Ae5RWvyoX2FSUTvnfg+a
        uZ1e3AjwsE8lWKFyr0230RI7WikjVR4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-mBeNNXH7MYGzPUb_QxwXrw-1; Mon, 20 Mar 2023 10:30:06 -0400
X-MC-Unique: mBeNNXH7MYGzPUb_QxwXrw-1
Received: by mail-qt1-f197.google.com with SMTP id h6-20020a05622a170600b003e22c6de617so1412348qtk.13
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 07:30:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679322605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYYltObAoBAJHBew4d0/wtXHVG5SadqFvZoyE4YqRs0=;
        b=mS5T56tHnCguePXZ2XxiVSMdrA9nS2REl7We3IG5Qyrbm9L5q3GBp7NoEbu9eMEH1V
         IacbhxUJsufITedujWScP1MofayLLnK6y4ttWay2LfldKMoFIe42gSucWpq3nutdquFQ
         3znQMwRTPt1RZ0VTZOd740j+c3wrFRfWV+eGI0krF9eC/63I7K4oF9gwEVv0FWhpj35j
         woT4hSy1W8Rc8zij7DE81RdqJapRFmmuwxt429efaWHFQydKEusVwSJ6SKf/FkXDXN3c
         QjQJXiSfEW0wF8uVvkot7ba0fNSS3tsQ3NFcds5ReEOdKRWP2KIxbl01MfpvlR4TuGUR
         mVwA==
X-Gm-Message-State: AO0yUKVfro0Dp01OnjG63YGjQ2hYB2a/oOD57fVoHKkoeSIqMj4XjXIy
        tN6txu48+P1tWhYmieDxpMSlJk6i7TNNBKorJsWer3hY2tKKchsh07O2JuOJRwF8rLw99dKjh3k
        MwEJFeR68/7fH/hqw
X-Received: by 2002:ac8:4e42:0:b0:3d7:57b:467c with SMTP id e2-20020ac84e42000000b003d7057b467cmr29522684qtw.43.1679322605291;
        Mon, 20 Mar 2023 07:30:05 -0700 (PDT)
X-Google-Smtp-Source: AK7set9hlZuyivlx1H18m4rYyb3oaING8patBHWuxdHYD2CvI9lsFliZKypqpOpiOcNd9X094fyYsg==
X-Received: by 2002:ac8:4e42:0:b0:3d7:57b:467c with SMTP id e2-20020ac84e42000000b003d7057b467cmr29522623qtw.43.1679322604965;
        Mon, 20 Mar 2023 07:30:04 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id t10-20020ac86a0a000000b003b9b48cdbe8sm6446788qtr.58.2023.03.20.07.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 07:30:04 -0700 (PDT)
Date:   Mon, 20 Mar 2023 15:29:59 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2] virtio/vsock: allocate multiple skbuffs on tx
Message-ID: <20230320142959.2wwf474fiyp3ex5z@sgarzare-redhat>
References: <ea5725eb-6cb5-cf15-2938-34e335a442fa@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ea5725eb-6cb5-cf15-2938-34e335a442fa@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 09:46:10PM +0300, Arseniy Krasnov wrote:
>This adds small optimization for tx path: instead of allocating single
>skbuff on every call to transport, allocate multiple skbuff's until
>credit space allows, thus trying to send as much as possible data without
>return to af_vsock.c.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> Link to v1:
> https://lore.kernel.org/netdev/2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru/
>
> Changelog:
> v1 -> v2:
> - If sent something, return number of bytes sent (even in
>   case of error). Return error only if failed to sent first
>   skbuff.
>
> net/vmw_vsock/virtio_transport_common.c | 53 ++++++++++++++++++-------
> 1 file changed, 39 insertions(+), 14 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 6564192e7f20..3fdf1433ec28 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -196,7 +196,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	const struct virtio_transport *t_ops;
> 	struct virtio_vsock_sock *vvs;
> 	u32 pkt_len = info->pkt_len;
>-	struct sk_buff *skb;
>+	u32 rest_len;
>+	int ret;
>
> 	info->type = virtio_transport_get_type(sk_vsock(vsk));
>
>@@ -216,10 +217,6 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>
> 	vvs = vsk->trans;
>
>-	/* we can send less than pkt_len bytes */
>-	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>-		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>-
> 	/* virtio_transport_get_credit might return less than pkt_len credit */
> 	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
>
>@@ -227,17 +224,45 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
> 		return pkt_len;
>
>-	skb = virtio_transport_alloc_skb(info, pkt_len,
>-					 src_cid, src_port,
>-					 dst_cid, dst_port);
>-	if (!skb) {
>-		virtio_transport_put_credit(vvs, pkt_len);
>-		return -ENOMEM;
>-	}
>+	ret = 0;
>+	rest_len = pkt_len;
>+
>+	do {
>+		struct sk_buff *skb;
>+		size_t skb_len;
>+
>+		skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
>+
>+		skb = virtio_transport_alloc_skb(info, skb_len,
>+						 src_cid, src_port,
>+						 dst_cid, dst_port);
>+		if (!skb) {
>+			ret = -ENOMEM;
>+			break;
>+		}
>+
>+		virtio_transport_inc_tx_pkt(vvs, skb);
>+
>+		ret = t_ops->send_pkt(skb);
>+
>+		if (ret < 0)
>+			break;
>
>-	virtio_transport_inc_tx_pkt(vvs, skb);
>+		rest_len -= skb_len;

t_ops->send_pkt() is returning the number of bytes sent. Current
implementations always return `skb_len`, so there should be no problem,
but it would be better to put a comment here, or we should handle the
case where ret != skb_len to avoid future issues.

>+	} while (rest_len);
>
>-	return t_ops->send_pkt(skb);
>+	/* Don't call this function with zero as argument:
>+	 * it tries to acquire spinlock and such argument
>+	 * makes this call useless.

Good point, can we do the same also for virtio_transport_get_credit()?
(Maybe in a separate patch)

I'm thinking if may be better to do it directly inside the functions,
but I don't have a strong opinion on that since we only call them here.

Thanks,
Stefano

>+	 */
>+	if (rest_len)
>+		virtio_transport_put_credit(vvs, rest_len);
>+
>+	/* Return number of bytes, if any data has been sent. */
>+	if (rest_len != pkt_len)
>+		ret = pkt_len - rest_len;
>+
>+	return ret;
> }
>
> static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>-- 
>2.25.1
>

