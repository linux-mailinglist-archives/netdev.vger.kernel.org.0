Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966F4596669
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 02:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237932AbiHQAsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 20:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiHQAsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 20:48:20 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592914507F;
        Tue, 16 Aug 2022 17:48:17 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r69so10719271pgr.2;
        Tue, 16 Aug 2022 17:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Kx0SDyoGz5baTC5VWufEpt94hdYzxNIFK0QLS5qScpM=;
        b=W8tkYlLCu461r1WPMOa4OrgYYHvPKVQv+KdcgNwZRoPLSfpGBkMZ/rZD3CH0bEvBwq
         8Z0Uz7N272AQICqZoAlC+AMG9G1KUDG2mj+Oy7WhCiJQs04nhacEwQayoAwW1r3lrRLl
         YpQTLbfT4Vs9L9hhadDUI5kYzZoO2ZcArAc5BLwIrFw1dG4etHRQysJJ3qZqbj2q9OH1
         Hn/734Td6MNMkIsQbaOw1EahDhh3EdN9wTHrj/kZ74FGh2q6xm8BVMfEM1FMxLBwBg69
         pDdfbYduCMCgiQBPXE8hBLgvWTq9nCesIYuejafo32dBBiT5X/3j5n2SMMwhTgOvkhPs
         dy+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Kx0SDyoGz5baTC5VWufEpt94hdYzxNIFK0QLS5qScpM=;
        b=F/4Pcv2EMfVvFsbtZAHFdmK/OENBQh2YuxtSFItetG2NmwhMBGcpmipHcBOuBwOqLe
         eDxk5Ek4XgGCMEEoIuDyXQpsyBTAgd4YDI3LzZb8zZqm+DSoe9Q6ch6M5ghFll9YC5To
         4jjijoI9pW4V7LKIl8d42QwwfwKmRC6OoQ5ag/lzXfD8tedu6GWSvb/7hUZtKc25dLNf
         YTmwNB+xSO58W7Vt1Jk8sfcHQ+LSbHz46JLjkrKqqDZU2zlJc/DGbOLsQ34XgZlPd2ay
         KsVPFkLgcIX6WGxPe4ctcCsmI2OoJBVtHgz+xE5SZ1hUoTUGfN2nwZTVe9nc/3B7D4fN
         ipaw==
X-Gm-Message-State: ACgBeo0qUr8ETRzm6miHRBEIUWwIQBzAloHyOnu3HQ32/PHsFeZb7PA9
        70VloYmRCSltjpxz+qFF0gs=
X-Google-Smtp-Source: AA6agR6OkLaN74Ce+Y5REASwUP72Q8mDKIaiTvt2m6iuXILxrbzYxJ5EY9aLoHH3YlLZoZdOxMekrg==
X-Received: by 2002:a63:211b:0:b0:41b:8f73:576d with SMTP id h27-20020a63211b000000b0041b8f73576dmr19900345pgh.106.1660697296811;
        Tue, 16 Aug 2022 17:48:16 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id t5-20020aa79465000000b0052d78e73e6asm9032883pfq.184.2022.08.16.17.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:48:16 -0700 (PDT)
Date:   Tue, 16 Aug 2022 08:29:04 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH 3/6] vsock: add netdev to vhost/virtio vsock
Message-ID: <YvtVN195TS1xpEN7@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com>
 <20220816123701-mutt-send-email-mst@kernel.org>
 <20220816110717.5422e976@kernel.org>
 <YvtAktdB09tM0Ykr@bullseye>
 <20220816160755.7eb11d2e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816160755.7eb11d2e@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 04:07:55PM -0700, Jakub Kicinski wrote:
> On Tue, 16 Aug 2022 07:02:33 +0000 Bobby Eshleman wrote:
> > > From a cursory look (and Documentation/ would be nice..) it feels
> > > very wrong to me. Do you know of any uses of a netdev which would 
> > > be semantically similar to what you're doing? Treating netdevs as
> > > buildings blocks for arbitrary message passing solutions is something 
> > > I dislike quite strongly.  
> > 
> > The big difference between vsock and "arbitrary message passing" is that
> > vsock is actually constrained by the virtio device that backs it (made
> > up of virtqueues and the underlying protocol). That virtqueue pair is
> > acting like the queues on a physical NIC, so it actually makes sense to
> > manage the queuing of vsock's device like we would manage the queueing
> > of a real device.
> > 
> > Still, I concede that ignoring the netdev state is a probably bad idea.
> > 
> > That said, I also think that using packet scheduling in vsock is a good
> > idea, and that ideally we can reuse Linux's already robust library of
> > packet scheduling algorithms by introducing qdisc somehow.
> 
> We've been burnt in the past by people doing the "let me just pick
> these useful pieces out of netdev" thing. Makes life hard both for
> maintainers and users trying to make sense of the interfaces.
> 
> What comes to mind if you're just after queuing is that we already
> bastardized the CoDel implementation (include/net/codel_impl.h).
> If CoDel is good enough for you maybe that's the easiest way?
> Although I suspect that you're after fairness not early drops.
> Wireless folks use CoDel as a second layer queuing. (CC: Toke)
> 

That is certainly interesting to me. Sitting next to "codel_impl.h" is
"include/net/fq_impl.h", and it looks like it may solve the datagram
flooding issue. The downside to this approach is the baking of a
specific policy into vsock... which I don't exactly love either.

I'm not seeing too many other of these qdisc bastardizations in
include/net, are there any others that you are aware of?

> > > Could you recommend where I can learn more about vsocks?  
> > 
> > I think the spec is probably the best place to start[1].
> > 
> > [1]: https://docs.oasis-open.org/virtio/virtio/v1.2/virtio-v1.2.html
> 
> Eh, I was hoping it was a side channel of an existing virtio_net 
> which is not the case. Given the zero-config requirement IDK if 
> we'll be able to fit this into netdev semantics :(

It's certainly possible that it may not fit :/ I feel that it partially
depends on what we mean by zero-config. Is it "no config required to
have a working socket" or is it "no config required, but also no
tuning/policy/etc... supported"?

Best,
Bobby
