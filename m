Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD865966A0
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 03:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbiHQBXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 21:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237781AbiHQBXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 21:23:24 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A591087
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 18:23:21 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id b22so3657566uap.0
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 18:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Misl/B06841rsdf51Aa+ttnbhsZR7d3YzAIKfH1afCM=;
        b=MG0YgAX5i1o7sBUDQM1NCnFgnxkQaaQm8ZOK13l79EOrXwG3hxCVCuxw53YmF/GPmG
         BotdAEanspQc99c8od7et+xJJfH666g+PKM2nqgz3aozMVwIaZpREipg9SXYXgriDnmG
         gd/gkMlKOf8PYpghcO3mkXIF7SKNqJjlKBYT913vJf9YESWgf8pX2vYoNDz1IqpbTxV3
         ey8qpYsAzqcukQgw/XSXbpnh4iqMa5QXp6N0QLpAN0eT/f7DTXgLZh1huFFG57VyQyzn
         6HWrAgsd8srbQ2yyjWgBYeijyKZyB2lbk+DexhRKJ/HbmCuh55PZoJ2SmQL/CWZeRD8m
         GOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Misl/B06841rsdf51Aa+ttnbhsZR7d3YzAIKfH1afCM=;
        b=d8g6CyUFebIBUwJcrLfRV6vBDZYS6KKyk/DVDIKL9NHkF3/aAmYSahzwccAZjMyfC4
         3tCsgxJULPAIx7BHJPrp47t0dof5HhzwvawmwEAGD4GHajZoVtRD4ryux2Z0DqYb7gtU
         m2/Ci9zJT+2CkJFgnXCP+txGOueTduMY8As8d7QUalRmhb9m3IWJsxS8fgSpx94Ex4tK
         cF2BnLJPit7TkL/SDBByrr661NVgMcQsFG1Ga6awB1aIUtopMa/qkthifVWtbhkZ0Coe
         NUAeQB4nCgBW201U13pB9Stnw6U+Xnal2d3tC1LjB1ZIBC+aTayHA8HnDKCmZFi2YiUh
         eUfw==
X-Gm-Message-State: ACgBeo0rs7+qJuOxU7I1VU3aNgJXptowO0hxm7Z0J5y8rbZ5jjlKOdvz
        I2Ghl5kynMHOeU+nBjpMUUmGtRJtM0Fu876O5AlJ+w==
X-Google-Smtp-Source: AA6agR5ITNWjhKzMRt/O1Pao4VfpXIG2uEaU2CaLxbF3VzOqtgaIZ/UWesq0hyAy6dBXihAeRHYyLPGpOXaXwPHw0oU=
X-Received: by 2002:ab0:785a:0:b0:386:d33c:d636 with SMTP id
 y26-20020ab0785a000000b00386d33cd636mr10128457uaq.87.1660699400464; Tue, 16
 Aug 2022 18:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com>
 <20220816123701-mutt-send-email-mst@kernel.org> <20220816110717.5422e976@kernel.org>
 <YvtAktdB09tM0Ykr@bullseye> <20220816160755.7eb11d2e@kernel.org>
In-Reply-To: <20220816160755.7eb11d2e@kernel.org>
From:   "Cong Wang ." <cong.wang@bytedance.com>
Date:   Tue, 16 Aug 2022 18:23:09 -0700
Message-ID: <CAA68J_Z4voVS=UnY9Rg_dj2oUnEueWn82Q_qT328avdTtaASjA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 3/6] vsock: add netdev to vhost/virtio vsock
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 4:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
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

I interpret this in a different way: we just believe "one size does
not fit all",
as most Linux kernel developers do. I am very surprised you don't.

Feel free to suggest any other ways, eventually you will need to
reimplement TC one way or the other.

If you think about it in another way, vsock is networking too, its name
contains a "sock", do I need to say more? :)

>
> What comes to mind if you're just after queuing is that we already
> bastardized the CoDel implementation (include/net/codel_impl.h).
> If CoDel is good enough for you maybe that's the easiest way?
> Although I suspect that you're after fairness not early drops.
> Wireless folks use CoDel as a second layer queuing. (CC: Toke)

What makes you believe CoDel fits all cases? If it really does, you
probably have to convince Toke to give up his idea on XDP map
as it would no longer make any sense. I don't see you raise such
an argument there... What makes you treat this differently with XDP
map? I am very curious about your thought process here. ;-)

Thanks.
