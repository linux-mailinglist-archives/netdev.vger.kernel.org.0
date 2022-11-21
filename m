Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8116460DF
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 19:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiLGSIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 13:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLGSIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 13:08:40 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446CC58BCC;
        Wed,  7 Dec 2022 10:08:36 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso2225166pjt.0;
        Wed, 07 Dec 2022 10:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BdY6BwR27p/sdP3ZWwkR+9jP3XrMrAerzNVcehEwvks=;
        b=Ixs0QMcywakQzVZ6RMzFDaj8e1SsgjnGQe4PkQcUFmSlmk37Ra/9h+E8T677Cquq+V
         LvRKDJaGMZj7Aq2Vbx4un03BqGYCeIoJnt6nXKGS0Rvm59mS8P5FzHtX8NJJetWtgwha
         yXIhejzkQt1xLLoFxqszqzIIGtqBeQYZVQv+F3GVbwPeo0DPA9G0wjvFVX+N1aWoC3Fx
         Wb695c1ims8pVTIGow7foMkejPRuDQbfgimnbUA5rSQOwsEzd0YlxL/CuM9JtN3IomYQ
         ACN07rGCfj9jys5ytodiNv8FNRTBEEEEOEityBtm11+rSa7FP6k8t6KQ+ucBlpZQtyXJ
         Slng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BdY6BwR27p/sdP3ZWwkR+9jP3XrMrAerzNVcehEwvks=;
        b=s6kUSWrLc25WGwkVg77yWK5eeO5RBYq7aNpisZDF7NZEsJzgmJx/G81fNLJUoC5ago
         aTL0y7P7nLuTpqhgIrDu9ghXHJsR/vpxj758JiFK89jMiKvrlQAd+j9faiwFLqCfCtsM
         KCPb/sjJ+iMwT2xiGqp4b6Yc7uMS5DEDW49twoh8L+EDXJn1x6wpEItCU1NUsXYICrl3
         FwkSGettohuo1MdEH8P0BPaDkaRNE7qL8Oe5ijY1cxAzjriJlqxliOVLcseLGgSEQyte
         V5eDdVfwZ5IFdIDvy/k2U3wTdGlWvL311l4/1NSk6/horT+Y1yIQ8wmylcD1ayBna0kd
         kcQg==
X-Gm-Message-State: ANoB5pncxoslumHGKBxQQhsXIDQnGTl3IJa0+NY2UH9cCwJbc+FG6so5
        WOZ1JQI102iivYkRrFzpf5E=
X-Google-Smtp-Source: AA0mqf5A+P0H9TOxoSRuHBnRwK34k9Rwpuk/1wJexb5dEDV1xFm5HZtPFKb5RioK5O085Var1vqMgw==
X-Received: by 2002:a17:90a:1b0b:b0:219:396c:9e32 with SMTP id q11-20020a17090a1b0b00b00219396c9e32mr911811pjq.16.1670436515585;
        Wed, 07 Dec 2022 10:08:35 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id c65-20020a17090a494700b002135e8074b1sm1465068pjh.55.2022.12.07.10.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 10:08:35 -0800 (PST)
Date:   Mon, 21 Nov 2022 20:19:53 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] virtio/vsock: replace virtio_vsock_pkt with sk_buff
Message-ID: <Y3vdaUS3rpoUdCIg@bullseye>
References: <20221202173520.10428-1-bobby.eshleman@bytedance.com>
 <863a58452b4a4c0d63a41b0f78b59d32919067fa.camel@redhat.com>
 <Y3toiPtBgOcrb8TL@bullseye>
 <7cad964394ce47cff28ec7c2f5f1559880e29ae2.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cad964394ce47cff28ec7c2f5f1559880e29ae2.camel@redhat.com>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 10:33:22AM +0100, Paolo Abeni wrote:
> On Mon, 2022-11-21 at 12:01 +0000, Bobby Eshleman wrote:
> > On Tue, Dec 06, 2022 at 11:20:21AM +0100, Paolo Abeni wrote:
> > > Hello,
> > > 
> > > On Fri, 2022-12-02 at 09:35 -0800, Bobby Eshleman wrote:
> > > [...]
> > > > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > > > index 35d7eedb5e8e..6c0b2d4da3fe 100644
> > > > --- a/include/linux/virtio_vsock.h
> > > > +++ b/include/linux/virtio_vsock.h
> > > > @@ -3,10 +3,129 @@
> > > >  #define _LINUX_VIRTIO_VSOCK_H
> > > >  
> > > >  #include <uapi/linux/virtio_vsock.h>
> > > > +#include <linux/bits.h>
> > > >  #include <linux/socket.h>
> > > >  #include <net/sock.h>
> > > >  #include <net/af_vsock.h>
> > > >  
> > > > +#define VIRTIO_VSOCK_SKB_HEADROOM (sizeof(struct virtio_vsock_hdr))
> > > > +
> > > > +enum virtio_vsock_skb_flags {
> > > > +	VIRTIO_VSOCK_SKB_FLAGS_REPLY		= BIT(0),
> > > > +	VIRTIO_VSOCK_SKB_FLAGS_TAP_DELIVERED	= BIT(1),
> > > > +};
> > > > +
> > > > +static inline struct virtio_vsock_hdr *virtio_vsock_hdr(struct sk_buff *skb)
> > > > +{
> > > > +	return (struct virtio_vsock_hdr *)skb->head;
> > > > +}
> > > > +
> > > > +static inline bool virtio_vsock_skb_reply(struct sk_buff *skb)
> > > > +{
> > > > +	return skb->_skb_refdst & VIRTIO_VSOCK_SKB_FLAGS_REPLY;
> > > > +}
> > > 
> > > I'm sorry for the late feedback. The above is extremelly risky: if the
> > > skb will land later into the networking stack, we could experience the
> > > most difficult to track bugs.
> > > 
> > > You should use the skb control buffer instead (skb->cb), with the
> > > additional benefit you could use e.g. bool - the compiler could emit
> > > better code to manipulate such fields - and you will not need to clear
> > > the field before release nor enqueue.
> > > 
> > > [...]
> > > 
> > 
> > Hey Paolo, thank you for the review. For my own learning, this would
> > happen presumably when the skb is dropped? And I assume we don't see
> > this in sockmap because it is always cleared before leaving sockmap's
> > hands? I sanity checked this patch with an out-of-tree patch I have that
> > uses the networking stack, but I suspect I didn't see issues because my
> > test harness didn't induce dropping...
> 
> skb->_skb_refdst carries a dst and a flag in the less significative bit
> specifying if the dst is refcounted. Passing to the network stack a skb
> overloading such bit semanthic is quite alike intentionally corrupting
> the kernel memory.
> 
> > I originally avoided skb->cb because the reply flag is set at allocation
> > and would potentially be clobbered by a pass through the networking
> > stack. The reply flag would be used after a pass through the networking
> > stack (e.g., during transmission at the device level and when sockets
> > close while skbs are still queued for xmit).
> 
> I assumed the 'tap_delivered' and 'reply' flag where relevant only
> while the skb is owned by the virtio socket. If you need to preserve
> such information _after_ delivering the skb to the network stack, that
> is quite unfortunate - and skb->cb will not work.
> 
> The are a couple of options for adding new metadata inside the skb,
> both of them are quite discouraged/need a strong use-case:
> 
> - adding new fields in some skb hole
> - adding a new skb extension.
> 
> Could you please describe the 'reply' and 'tap_delivered' life-cycle
> and their interaction with the network stack?
> 

vsock has two layers: the socket layer and the transport layer.

'tap_delivered' is set and used only in the transport layer, upon
transmission, so I think skb->cb can easily be used for it. 

'reply' is set only for some types of packets like reset and response
packets. Sometimes this is originating from the socket layer, and
sometimes from the transport. They share the same sending function.

The reply flag is later used by the transport as a hint to queue a
worker to process more RX packets.

After looking at the reply flag closer, I think it can be derived from
the packet header. If derived like so, this problem should go away.

Given that the current implementation does not use the networking stack,
I suggest that we move both flags to skb->cb for this patch, to avoid
any possible future confusion. If future patches change vsock to use the
networking stack, then they should also include the changes to handle
these flags appropriately.

Thanks,
Bobby
