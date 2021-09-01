Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8353FD402
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 08:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242402AbhIAGxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 02:53:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241096AbhIAGx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 02:53:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630479152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sS+ENc/4EvCCf2zYfOqIzQcGTVPDUUcKwCPkNAq9cUI=;
        b=RYFom7Sg4ICvHbInMaklbLildyPBgpCrujyWUVkGfXiR2UcOHQhTe9KNeak5Gi45R0FY8J
        DiCRh2+Dv03hRa8Lkil39FzCC0cY17DunthWvJDQdlBTEvjPvqJOiRRK/FxgcuFgH26CwI
        1vULeiN5KTgv59rhaClZo7tgLopHEmA=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-09fl-FHQN3a8deHPoG1-Bg-1; Wed, 01 Sep 2021 02:52:31 -0400
X-MC-Unique: 09fl-FHQN3a8deHPoG1-Bg-1
Received: by mail-pg1-f199.google.com with SMTP id r21-20020a63d9150000b029023ccd23c20cso1139577pgg.19
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 23:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sS+ENc/4EvCCf2zYfOqIzQcGTVPDUUcKwCPkNAq9cUI=;
        b=H3XPwLDpsrHypnLWd7JTEel2W0axfGOCrtrpYmUxwezd8/vKW5tiug03r8Lo1GmXs4
         6QP0L+343GMwrtfVLe73cfnniRLs/0F7DIBiHIHzyFS+Es0XejutqrnAtWDisugkS6HX
         XRFMW2Xn3ZccVoxgXVBG9LUymOkzVM+zo+9n3G3TJlhMfUjcwcMhiAeqpdAnNYtJzmkw
         YSeFxkzpaG406JBlE8JxxIYGTVxi1bDUijRxQUO5X8PRZIeyQlxlFAp35UcjI+NI2dJj
         ysGBbPk4tazj2kJIqoJYdRbJ6RgP9nb13r0PrHv+0fsxCp+0bh0ObP/WwZ1ZpHJOhX7g
         JiCA==
X-Gm-Message-State: AOAM530kN8STiTGo70uJUmETzvzv2ktWsbGPatPPO4nXtJxy0l/H8oJ+
        dFlm5eTrFRgJePPt/0ZXGe5szVd15oLeUTsXVmUstH0FiEnCrn02wISV17UEUzuzEBJCUXjMAlP
        8Aii24OYFEyBUv0Mv
X-Received: by 2002:a17:90a:29a6:: with SMTP id h35mr9935658pjd.188.1630479149958;
        Tue, 31 Aug 2021 23:52:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4M3DXDMra5cGnJcANgV7r3NSOaqkzwzYcCrm2jEsJTplrnszIxVJ/2Amugs0pRJMh26FPwA==
X-Received: by 2002:a17:90a:29a6:: with SMTP id h35mr9935634pjd.188.1630479149555;
        Tue, 31 Aug 2021 23:52:29 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u24sm21205082pfm.81.2021.08.31.23.52.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 23:52:29 -0700 (PDT)
Subject: Re: [RFC PATCH 1/3] drivers/net/virtio_net: Fixed vheader to use v1.
To:     Andrew Melnychenko <andrew@daynix.com>, mst@redhat.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210818175440.128691-1-andrew@daynix.com>
 <20210818175440.128691-2-andrew@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <65fe6644-bccd-00aa-7c72-53da385bd47e@redhat.com>
Date:   Wed, 1 Sep 2021 14:52:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818175440.128691-2-andrew@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/8/19 上午1:54, Andrew Melnychenko 写道:
> The header v1 provides additional info about RSS.
> Added changes to computing proper header length.
> In the next patches, the header may contain RSS hash info
> for the hash population.
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> ---
>   drivers/net/virtio_net.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 56c3f8519093..85427b4f51bc 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -240,13 +240,13 @@ struct virtnet_info {
>   };
>   
>   struct padded_vnet_hdr {
> -	struct virtio_net_hdr_mrg_rxbuf hdr;
> +	struct virtio_net_hdr_v1_hash hdr;
>   	/*
>   	 * hdr is in a separate sg buffer, and data sg buffer shares same page
>   	 * with this header sg. This padding makes next sg 16 byte aligned
>   	 * after the header.
>   	 */
> -	char padding[4];
> +	char padding[12];
>   };


So we had:

         if (vi->mergeable_rx_bufs)
                 hdr_padded_len = sizeof(*hdr);
         else
                 hdr_padded_len = sizeof(struct padded_vnet_hdr);

I wonder if it's better to add one ore condition for the hash header 
instead of enforcing it even if it was not negotiated.


>   
>   static bool is_xdp_frame(void *ptr)
> @@ -1258,7 +1258,7 @@ static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
>   					  struct ewma_pkt_len *avg_pkt_len,
>   					  unsigned int room)
>   {
> -	const size_t hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
> +	const size_t hdr_len = ((struct virtnet_info *)(rq->vq->vdev->priv))->hdr_len;
>   	unsigned int len;
>   
>   	if (room)
> @@ -1642,7 +1642,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
>   	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
>   	struct virtnet_info *vi = sq->vq->vdev->priv;
>   	int num_sg;
> -	unsigned hdr_len = vi->hdr_len;
> +	unsigned int hdr_len = vi->hdr_len;


Looks like an unnecessary change.


>   	bool can_push;
>   
>   	pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
> @@ -2819,7 +2819,7 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
>    */
>   static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqueue *vq)
>   {
> -	const unsigned int hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
> +	const unsigned int hdr_len = vi->hdr_len;


I think the change here and get_mergeable_buf_len() should be a separate 
patch.

Thanks


>   	unsigned int rq_size = virtqueue_get_vring_size(vq);
>   	unsigned int packet_len = vi->big_packets ? IP_MAX_MTU : vi->dev->max_mtu;
>   	unsigned int buf_len = hdr_len + ETH_HLEN + VLAN_HLEN + packet_len;

