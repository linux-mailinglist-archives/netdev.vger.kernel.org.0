Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9550C5974DE
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbiHQRN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237925AbiHQRNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:13:25 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3C27F0A8;
        Wed, 17 Aug 2022 10:13:23 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s206so12504695pgs.3;
        Wed, 17 Aug 2022 10:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=00zDI5xu+hbyWvZmiPOtpUInG8lTXtHgE5kFx8f3aeU=;
        b=iyMpBBARMzX1OK3vY0WOZXMC7OcsctdNegE2rFZL0q/9qECKntEoL6j8tXqfurpTEH
         RsmsMockFAvu/65a51euUIEGxcUVchyw53G6mtTfdz0m2UEr0Dccift+Pk8VFoe8TK+q
         2Jg6so7kJhUvOndBCb/FXeK4K5zcObxQuLE02tjeu7PWi2iqesbrmTjl63VgzIabZ+GG
         e7JOyBlXYHpTUvpgs9O2dJWrz4o4/9PMoeABdghcyDqDSihDiYvt906hXuP883hM+Kds
         NfJuDS3Ikya8Yn6peyEfzg+8FBIcEyWQHWXa1lbOQpl60k4hgyKXy+LQZXqGORTXiVMz
         XLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=00zDI5xu+hbyWvZmiPOtpUInG8lTXtHgE5kFx8f3aeU=;
        b=5+BOtg0AF4TVg/xwH6pOTS5hWl6q+m7Kx2+RAL1GLeIhMn0NXZjcFY9yKmKEk6CS/+
         nkl1Eyn/rIm00GM0QnexfYQDzg+4MttzHx5Hab4oX/2flJfsIWg9jCSfSkhMtleEzJZa
         lZsYxrOSP4XR/wwpj5QJmyBpOM3On361z18cr1PYMVxJr/EPrHWZW4z62BkkMvsEqtuX
         4FnaxuEyiQ7nuqmehsGToIAJ0ajva1cipFb6hr9PHG782mOdtaqloDoTdAOTQdkY18Sc
         OAy3kMIBNmnUEbRCbXudKJXIBLxbsB2sAhHdKdfmANMf28HXfOLBq/1AAiVvejV+YvlW
         fwhw==
X-Gm-Message-State: ACgBeo0Pob32kacG/Ky1gXhkdVPCMotqy+2RXTbWc0xbobSnelpf7sHZ
        DsV2uX6aBx9IJYty7fL+GGQ=
X-Google-Smtp-Source: AA6agR6bqIUckQRPYc2RcF5QP5U6VvtF4uY92Fwhr7MsjV73IENo/25otKwa5/jCbtFHei7xRi3g/w==
X-Received: by 2002:a63:fd0b:0:b0:415:f76b:a2cd with SMTP id d11-20020a63fd0b000000b00415f76ba2cdmr22185575pgh.440.1660756402581;
        Wed, 17 Aug 2022 10:13:22 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id z6-20020a170903018600b001729da53673sm194988plg.14.2022.08.17.10.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:13:20 -0700 (PDT)
Date:   Tue, 16 Aug 2022 10:50:55 +0000
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
Message-ID: <Yvt2f5i5R9NNNYUL@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com>
 <20220816123701-mutt-send-email-mst@kernel.org>
 <20220816110717.5422e976@kernel.org>
 <YvtAktdB09tM0Ykr@bullseye>
 <20220816160755.7eb11d2e@kernel.org>
 <YvtVN195TS1xpEN7@bullseye>
 <20220816181528.5128bc06@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816181528.5128bc06@kernel.org>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 06:15:28PM -0700, Jakub Kicinski wrote:
> On Tue, 16 Aug 2022 08:29:04 +0000 Bobby Eshleman wrote:
> > > We've been burnt in the past by people doing the "let me just pick
> > > these useful pieces out of netdev" thing. Makes life hard both for
> > > maintainers and users trying to make sense of the interfaces.
> > > 
> > > What comes to mind if you're just after queuing is that we already
> > > bastardized the CoDel implementation (include/net/codel_impl.h).
> > > If CoDel is good enough for you maybe that's the easiest way?
> > > Although I suspect that you're after fairness not early drops.
> > > Wireless folks use CoDel as a second layer queuing. (CC: Toke)
> > 
> > That is certainly interesting to me. Sitting next to "codel_impl.h" is
> > "include/net/fq_impl.h", and it looks like it may solve the datagram
> > flooding issue. The downside to this approach is the baking of a
> > specific policy into vsock... which I don't exactly love either.
> > 
> > I'm not seeing too many other of these qdisc bastardizations in
> > include/net, are there any others that you are aware of?
> 
> Just what wireless uses (so codel and fq as you found out), nothing
> else comes to mind.
> 
> > > Eh, I was hoping it was a side channel of an existing virtio_net 
> > > which is not the case. Given the zero-config requirement IDK if 
> > > we'll be able to fit this into netdev semantics :(  
> > 
> > It's certainly possible that it may not fit :/ I feel that it partially
> > depends on what we mean by zero-config. Is it "no config required to
> > have a working socket" or is it "no config required, but also no
> > tuning/policy/etc... supported"?
> 
> The value of tuning vs confusion of a strange netdev floating around
> in the system is hard to estimate upfront. 

I think "a strange netdev floating around" is a total
mischaracterization... vsock is a networking device and it supports
vsock networks. Sure, it is a virtual device and the routing is done in
host software, but the same is true for virtio-net and VM-to-VM vlan.

This patch actually uses netdev for its intended purpose: to support and
manage the transmission of packets via a network device to a network.

Furthermore, it actually prepares vsock to eliminate a "strange" use of
a netdev. The netdev in vsockmon isn't even used to transmit
packets, it's "floating around" for no other reason than it is needed to
support packet capture, which vsock couldn't support because it didn't
have a netdev.

Something smells when we are required to build workaround kernel modules
that use netdev for ciphoning packets off to userspace, when we could
instead be using netdev for its intended purpose and get the same and
more benefit.

> 
> The nice thing about using a built-in fq with no user visible knobs is
> that there's no extra uAPI. We can always rip it out and replace later.
> And it shouldn't be controversial, making the path to upstream smoother.

The issue is that after pulling in fq for one kind of flow management,
then as users observe other flow issues, we will need to re-implement
pfifo, and then TBF, and then we need to build an interface to let users
select one, and to choose queue sizes... and then after awhile we've
needlessly re-implemented huge chunks of the tc system.

I don't see any good reason to restrict vsock users to using suboptimal
and rigid queuing.

Thanks.
