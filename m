Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B618645688
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiLGJe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiLGJe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:34:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFC32FFE0
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 01:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670405608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DNEaWgUnEyEq3pixNIdJuD3ogN+VEJSCbXOc5Itmm6k=;
        b=P8KHDA3yU84IdiMEog4hF2a6suIbX40GfwuyfjOlSkRqDoXKjhiYeIDzXGRkvUdbCI5Rdj
        vA/oFKpx+Owe/WUepJ/JvTUzcGr6aksDdD849xQ1C5eSzjT+qpqy0Rk2bznHMM1Es9XEMC
        cEpMMM2T+i3zWeDRfmQTtUwHwvEpmn8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-NrYwJWbiOXiO0gTLMg46rw-1; Wed, 07 Dec 2022 04:33:26 -0500
X-MC-Unique: NrYwJWbiOXiO0gTLMg46rw-1
Received: by mail-wm1-f72.google.com with SMTP id ay19-20020a05600c1e1300b003cf758f1617so538539wmb.5
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 01:33:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DNEaWgUnEyEq3pixNIdJuD3ogN+VEJSCbXOc5Itmm6k=;
        b=G8PZL1s+KT+excEEnajKK7sWYZ7hmS0kaSOKrIUb8P0mffBLnt3ZbQBeK3JWPCNujd
         fTIjhOecyCum3TTH7SW5LffqAXmovjfwzhqtbnBb06pn6bEI1LCDDm56AkBfGimi+TEk
         45Wvt+B2uuyK47CmNvBgrU6b3TmYfEc827eIWnIlsgQPAhuhVQgeYATBQn8Yjb7EXo1E
         YdDVQqdruEsFYeHFnePL5vvQqrccquQ5AYfDZuA2UERKYtLXH+sxADP+dDkYyW9SuCRR
         GMKnVwMp9cgsULCTc9q5wbYJ6GGpn4SUWYHkDLczJ+L7FCLYSYatDbK52NU4Xh3djGZM
         yuxQ==
X-Gm-Message-State: ANoB5pnoKDSe8oGR7m645CDZLhONoVrfcPX6odPzI5r4Wa2Np6o46Ozs
        UKbGxMrVKYDAu12ijUToKfm607UKxCNOUJFW9nFIed5pNXCXciM9BkH3QhJNerwF4/C8j465ZHC
        rX+rOudkv/a45TIZ+
X-Received: by 2002:adf:f40d:0:b0:242:2bd5:b1ce with SMTP id g13-20020adff40d000000b002422bd5b1cemr19518374wro.519.1670405605664;
        Wed, 07 Dec 2022 01:33:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7hVCwJXn1G2gZ1QbqkOxInRXOmGLIFnBp7xLwd5RYpissGS2YDvXCAQd5bcKlA67ovEbQGQw==
X-Received: by 2002:adf:f40d:0:b0:242:2bd5:b1ce with SMTP id g13-20020adff40d000000b002422bd5b1cemr19518344wro.519.1670405605403;
        Wed, 07 Dec 2022 01:33:25 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-100.dyn.eolo.it. [146.241.106.100])
        by smtp.gmail.com with ESMTPSA id n10-20020adffe0a000000b00241bd7a7165sm18392917wrr.82.2022.12.07.01.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 01:33:24 -0800 (PST)
Message-ID: <7cad964394ce47cff28ec7c2f5f1559880e29ae2.camel@redhat.com>
Subject: Re: [PATCH v5] virtio/vsock: replace virtio_vsock_pkt with sk_buff
From:   Paolo Abeni <pabeni@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
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
Date:   Wed, 07 Dec 2022 10:33:22 +0100
In-Reply-To: <Y3toiPtBgOcrb8TL@bullseye>
References: <20221202173520.10428-1-bobby.eshleman@bytedance.com>
         <863a58452b4a4c0d63a41b0f78b59d32919067fa.camel@redhat.com>
         <Y3toiPtBgOcrb8TL@bullseye>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-11-21 at 12:01 +0000, Bobby Eshleman wrote:
> On Tue, Dec 06, 2022 at 11:20:21AM +0100, Paolo Abeni wrote:
> > Hello,
> > 
> > On Fri, 2022-12-02 at 09:35 -0800, Bobby Eshleman wrote:
> > [...]
> > > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > > index 35d7eedb5e8e..6c0b2d4da3fe 100644
> > > --- a/include/linux/virtio_vsock.h
> > > +++ b/include/linux/virtio_vsock.h
> > > @@ -3,10 +3,129 @@
> > >  #define _LINUX_VIRTIO_VSOCK_H
> > >  
> > >  #include <uapi/linux/virtio_vsock.h>
> > > +#include <linux/bits.h>
> > >  #include <linux/socket.h>
> > >  #include <net/sock.h>
> > >  #include <net/af_vsock.h>
> > >  
> > > +#define VIRTIO_VSOCK_SKB_HEADROOM (sizeof(struct virtio_vsock_hdr))
> > > +
> > > +enum virtio_vsock_skb_flags {
> > > +	VIRTIO_VSOCK_SKB_FLAGS_REPLY		= BIT(0),
> > > +	VIRTIO_VSOCK_SKB_FLAGS_TAP_DELIVERED	= BIT(1),
> > > +};
> > > +
> > > +static inline struct virtio_vsock_hdr *virtio_vsock_hdr(struct sk_buff *skb)
> > > +{
> > > +	return (struct virtio_vsock_hdr *)skb->head;
> > > +}
> > > +
> > > +static inline bool virtio_vsock_skb_reply(struct sk_buff *skb)
> > > +{
> > > +	return skb->_skb_refdst & VIRTIO_VSOCK_SKB_FLAGS_REPLY;
> > > +}
> > 
> > I'm sorry for the late feedback. The above is extremelly risky: if the
> > skb will land later into the networking stack, we could experience the
> > most difficult to track bugs.
> > 
> > You should use the skb control buffer instead (skb->cb), with the
> > additional benefit you could use e.g. bool - the compiler could emit
> > better code to manipulate such fields - and you will not need to clear
> > the field before release nor enqueue.
> > 
> > [...]
> > 
> 
> Hey Paolo, thank you for the review. For my own learning, this would
> happen presumably when the skb is dropped? And I assume we don't see
> this in sockmap because it is always cleared before leaving sockmap's
> hands? I sanity checked this patch with an out-of-tree patch I have that
> uses the networking stack, but I suspect I didn't see issues because my
> test harness didn't induce dropping...

skb->_skb_refdst carries a dst and a flag in the less significative bit
specifying if the dst is refcounted. Passing to the network stack a skb
overloading such bit semanthic is quite alike intentionally corrupting
the kernel memory.

> I originally avoided skb->cb because the reply flag is set at allocation
> and would potentially be clobbered by a pass through the networking
> stack. The reply flag would be used after a pass through the networking
> stack (e.g., during transmission at the device level and when sockets
> close while skbs are still queued for xmit).

I assumed the 'tap_delivered' and 'reply' flag where relevant only
while the skb is owned by the virtio socket. If you need to preserve
such information _after_ delivering the skb to the network stack, that
is quite unfortunate - and skb->cb will not work.

The are a couple of options for adding new metadata inside the skb,
both of them are quite discouraged/need a strong use-case:

- adding new fields in some skb hole
- adding a new skb extension.

Could you please describe the 'reply' and 'tap_delivered' life-cycle
and their interaction with the network stack?


Cheers,

Paolo

