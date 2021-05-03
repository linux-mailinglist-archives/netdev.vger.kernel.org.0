Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724CD371236
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 10:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhECIBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 04:01:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229817AbhECIBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 04:01:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620028818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KSlg/6TXM81jhkSAlJ0xj1Zt15A1EScYsDk40WJyrac=;
        b=fj3v/kjY8a6UWCkDyxzWxXo1bKBvEj1kGAhA7qyguCw9BSYcjVGiZmYLPoxxTfJmN7Dt+L
        O3oN2VukforY9iVSqnsrYFQ5tu56dNTyntOgfwUxPpEc8cWANF4WiwZWLHIKcFIFT+4Q0A
        wmhtPQUIeIZ6nfgACep8iEiLY8BZHGE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-L-uNhZ4XOjyktEsEb6Eeuw-1; Mon, 03 May 2021 04:00:17 -0400
X-MC-Unique: L-uNhZ4XOjyktEsEb6Eeuw-1
Received: by mail-wm1-f69.google.com with SMTP id o10-20020a05600c4fcab029014ae7fdec90so282963wmq.5
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 01:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KSlg/6TXM81jhkSAlJ0xj1Zt15A1EScYsDk40WJyrac=;
        b=I71QR/Vq0ziE5gpDzovi3Wi0doEs67ijLkPkcDm6TbXmpJVkpubUk/+gVVBU5shRoZ
         sYMoRudr9knufamdNoAv5QwxBJ3ciCedPvmQsICIRG4x5Fj0qVca1J7h/PqgwS5QIhy3
         Vduc6/42MzvF/nJob1mCcsYMT5xKWLLHbk+s5wO+Ty2fckbTNnMP3iLmeH0K1OGZj2iw
         jFMwUKXyaCfGi38AC5t091FKwhk+hKYh99bqQcTQC0intdMwrC2R0gA5a8WhI/1mTfAc
         hWxRuWAM6HS/ndGL4sUxLxRouEPo4ADPK/Kt/qztcttVBlOYgP6K7XYBAguq+6DrhSPn
         Uz6g==
X-Gm-Message-State: AOAM5327WAGZxbrTQrzlEEkek4Ss1rmm2SuW6ONneXzhLcxiq47xpLiN
        xuQfUcLxJMjNyy2b19gzutwm7ZXVmXMugoU/YcGGhiws/H69+T6SZt+fGN4+rh7eBvNQuqZZxv6
        Aq8aCRe9HFxRRiDiH
X-Received: by 2002:a05:600c:47d7:: with SMTP id l23mr30998081wmo.95.1620028816125;
        Mon, 03 May 2021 01:00:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG8f8FKrGEHlHEe8i1uSyVXb+d7Twhf4Z/yX/SHYitc/v+CFKORKHcvRNOcLGDI4wI56ww5A==
X-Received: by 2002:a05:600c:47d7:: with SMTP id l23mr30998070wmo.95.1620028815972;
        Mon, 03 May 2021 01:00:15 -0700 (PDT)
Received: from redhat.com ([2a10:800a:cdef:0:114d:2085:61e4:7b41])
        by smtp.gmail.com with ESMTPSA id r2sm1277623wrv.39.2021.05.03.01.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 01:00:15 -0700 (PDT)
Date:   Mon, 3 May 2021 04:00:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in
 skb_gro_receive
Message-ID: <20210503035959-mutt-send-email-mst@kernel.org>
References: <1619151585.3098595-1-xuanzhuo@linux.alibaba.com>
 <b2f5cab7-18dd-2817-7423-e84ea1907bf3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2f5cab7-18dd-2817-7423-e84ea1907bf3@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 12:33:09PM +0800, Jason Wang wrote:
> 
> 在 2021/4/23 下午12:19, Xuan Zhuo 写道:
> > On Fri, 23 Apr 2021 12:08:34 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > 在 2021/4/22 下午11:16, Xuan Zhuo 写道:
> > > > When "headroom" > 0, the actual allocated memory space is the entire
> > > > page, so the address of the page should be used when passing it to
> > > > build_skb().
> > > > 
> > > > BUG: KASAN: use-after-free in skb_gro_receive (net/core/skbuff.c:4260)
> > > > Write of size 16 at addr ffff88811619fffc by task kworker/u9:0/534
> > > > CPU: 2 PID: 534 Comm: kworker/u9:0 Not tainted 5.12.0-rc7-custom-16372-gb150be05b806 #3382
> > > > Hardware name: QEMU MSN2700, BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> > > > Workqueue: xprtiod xs_stream_data_receive_workfn [sunrpc]
> > > > Call Trace:
> > > >    <IRQ>
> > > > dump_stack (lib/dump_stack.c:122)
> > > > print_address_description.constprop.0 (mm/kasan/report.c:233)
> > > > kasan_report.cold (mm/kasan/report.c:400 mm/kasan/report.c:416)
> > > > skb_gro_receive (net/core/skbuff.c:4260)
> > > > tcp_gro_receive (net/ipv4/tcp_offload.c:266 (discriminator 1))
> > > > tcp4_gro_receive (net/ipv4/tcp_offload.c:316)
> > > > inet_gro_receive (net/ipv4/af_inet.c:1545 (discriminator 2))
> > > > dev_gro_receive (net/core/dev.c:6075)
> > > > napi_gro_receive (net/core/dev.c:6168 net/core/dev.c:6198)
> > > > receive_buf (drivers/net/virtio_net.c:1151) virtio_net
> > > > virtnet_poll (drivers/net/virtio_net.c:1415 drivers/net/virtio_net.c:1519) virtio_net
> > > > __napi_poll (net/core/dev.c:6964)
> > > > net_rx_action (net/core/dev.c:7033 net/core/dev.c:7118)
> > > > __do_softirq (./arch/x86/include/asm/jump_label.h:25 ./include/linux/jump_label.h:200 ./include/trace/events/irq.h:142 kernel/softirq.c:346)
> > > > irq_exit_rcu (kernel/softirq.c:221 kernel/softirq.c:422 kernel/softirq.c:434)
> > > > common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 14))
> > > > </IRQ>
> > > > 
> > > > Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > Reported-by: Ido Schimmel <idosch@nvidia.com>
> > > > Tested-by: Ido Schimmel <idosch@nvidia.com>
> > > > ---
> > > 
> > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > 
> > > The codes became hard to read, I think we can try to do some cleanups on
> > > top to make it easier to read.
> > > 
> > > Thanks
> > Yes, this piece of code needs to be sorted out. Especially the big and mergeable
> > scenarios should be handled separately. Remove the mergeable code from this
> > function, and mergeable uses a new function alone.
> 
> 
> Right, another thing is that we may consider to relax the checking of len <
> GOOD_COPY_LEN.


Want to post a patch on top?

> Our QE still see low PPS compared with the code before 3226b158e67c ("net:
> avoid 32 x truesize under-estimation for tiny skbs").
> 
> Thanks
> 
> 
> > 
> > Thanks.
> > 
> > > 
> > > >    drivers/net/virtio_net.c | 12 +++++++++---
> > > >    1 file changed, 9 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 74d2d49264f3..7fda2ae4c40f 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -387,7 +387,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> > > >    	unsigned int copy, hdr_len, hdr_padded_len;
> > > >    	struct page *page_to_free = NULL;
> > > >    	int tailroom, shinfo_size;
> > > > -	char *p, *hdr_p;
> > > > +	char *p, *hdr_p, *buf;
> > > > 
> > > >    	p = page_address(page) + offset;
> > > >    	hdr_p = p;
> > > > @@ -403,11 +403,15 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> > > >    	 * space are aligned.
> > > >    	 */
> > > >    	if (headroom) {
> > > > -		/* The actual allocated space size is PAGE_SIZE. */
> > > > +		/* Buffers with headroom use PAGE_SIZE as alloc size,
> > > > +		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
> > > > +		 */
> > > >    		truesize = PAGE_SIZE;
> > > >    		tailroom = truesize - len - offset;
> > > > +		buf = page_address(page);
> > > >    	} else {
> > > >    		tailroom = truesize - len;
> > > > +		buf = p;
> > > >    	}
> > > > 
> > > >    	len -= hdr_len;
> > > > @@ -416,11 +420,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> > > > 
> > > >    	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > > > 
> > > > +	/* copy small packet so we can reuse these pages */
> > > >    	if (!NET_IP_ALIGN && len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
> > > > -		skb = build_skb(p, truesize);
> > > > +		skb = build_skb(buf, truesize);
> > > >    		if (unlikely(!skb))
> > > >    			return NULL;
> > > > 
> > > > +		skb_reserve(skb, p - buf);
> > > >    		skb_put(skb, len);
> > > >    		goto ok;
> > > >    	}

