Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D36633E93
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiKVOLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiKVOLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:11:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4613E45A12
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669126216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kUXtYQe0ohDvr6A78vOZ5b4tncoePLFzJblR8fMqSyk=;
        b=JetNRvQzpzFo9zRdmMZX7CWTtdHEoGKxAmAgfmhybgj4kAZ52tARYMWQCPJc/z/3aWyPx2
        apob4PmBX4l8UhaVqKI799SyvDrqJDQlbw79pXy8Ljt2bRBLrnp4cR6VThMwSlzERRaVl+
        1BrsCIZAzci4micOAzSwBx9L2dIidnU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-FN3sQiPONBGwIFx_62Fj_Q-1; Tue, 22 Nov 2022 09:10:15 -0500
X-MC-Unique: FN3sQiPONBGwIFx_62Fj_Q-1
Received: by mail-wm1-f72.google.com with SMTP id v188-20020a1cacc5000000b003cf76c4ae66so11033409wme.7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:10:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kUXtYQe0ohDvr6A78vOZ5b4tncoePLFzJblR8fMqSyk=;
        b=gXfkCx8mqPWCSqbsHYtuQFhMn3Teh5lhf/R+IYS6WHCDrKlH0uk8HXOcrTNk0MEHMq
         RJxY4Erls0cPPzdpvft8Gqf857J5wu+aMGSWr6kR8y/Kug+xrZLUu6l7Eu7AwpR08GTR
         WdNMxmvGn+/BqK0zEVx6qirdZwlc+UQAnNkAyH1q1zAFUfUdN97wOTPQk5R3iTqDYs3W
         7iwJeSCqJLF9Lvus/wjbRd0pKzW5gyJnYe6GUz1IuKhoZETW1JiD1ZM/Ux+iNI9k8V8o
         Lqmy1yll9TwOi+bTVsqbx+/I2b8RpQaVMztqLIpdH8TmJS7JgNGK2dAwmv8u1TXvflyZ
         v9sA==
X-Gm-Message-State: ANoB5plHll2ak20SRLvrW9GJWC2bJpuCX364Q2xYPVXf/RV+cfjxxE/S
        blvNp9p6iijBhJnqAPj6obpunKiYmgPGKWtKe88lSDcujlbN3bdGFhGytw3TiuN1GFdH7hiC88G
        ZcPSlVH2a4GHfhGAs
X-Received: by 2002:adf:e986:0:b0:241:8435:ea7e with SMTP id h6-20020adfe986000000b002418435ea7emr13610123wrm.103.1669126214054;
        Tue, 22 Nov 2022 06:10:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5vbCTaSmKUY7Zj6hCXQETQMUra7D0zA4edFEMtn2U+jmGpeBEffvptZMw6+34NERhptkMVJQ==
X-Received: by 2002:adf:e986:0:b0:241:8435:ea7e with SMTP id h6-20020adfe986000000b002418435ea7emr13610106wrm.103.1669126213814;
        Tue, 22 Nov 2022 06:10:13 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id n17-20020a05600c465100b003cf483ee8e0sm19995036wmo.24.2022.11.22.06.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 06:10:12 -0800 (PST)
Date:   Tue, 22 Nov 2022 15:10:11 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com,
        syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,
        syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
Subject: Re: [PATCH net] l2tp: Don't sleep and disable BH under writer-side
 sk_callback_lock
Message-ID: <20221122141011.GA3303@pc-4.home>
References: <20221119130317.39158-1-jakub@cloudflare.com>
 <f8e54710-6889-5c27-2b3c-333537495ecd@I-love.SAKURA.ne.jp>
 <a850c224-f728-983c-45a0-96ebbaa943d7@I-love.SAKURA.ne.jp>
 <87wn7o7k7r.fsf@cloudflare.com>
 <ef09820a-ca97-0c50-e2d8-e1344137d473@I-love.SAKURA.ne.jp>
 <87fseb7vbm.fsf@cloudflare.com>
 <f2fdb53a-4727-278d-ac1b-d6dbdac8d307@I-love.SAKURA.ne.jp>
 <871qpvmfab.fsf@cloudflare.com>
 <a3b7d8cd-0c72-8e6b-78f2-71b92e70360f@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3b7d8cd-0c72-8e6b-78f2-71b92e70360f@I-love.SAKURA.ne.jp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 08:14:33PM +0900, Tetsuo Handa wrote:
> On 2022/11/22 19:46, Jakub Sitnicki wrote:
> >> https://syzkaller.appspot.com/bug?extid=94cc2a66fc228b23f360 is the one
> >> where changing lockdep class is concurrently done on pre-existing sockets.
> >>
> >> I think we need to always create a new socket inside l2tp_tunnel_register(),
> >> rather than trying to serialize setting of sk_user_data under sk_callback_lock.
> > 
> > While that would be easier to handle, I don't see how it can be done in
> > a backward-compatible way. User-space is allowed to pass a socket to
> > l2tp today [1].
> 
> What is the expected usage of the socket which was passed to l2tp_tunnel_register() ?

It receives L2TP packets. Those can be either control or data ones.
Data packets are processed by the kernel. Control packets are queued to
user space.

> Is the userspace supposed to just close() that socket? Or, is the userspace allowed to
> continue using the socket?

User space uses this socket to send and receive L2TP control packets
(tunnel and session configuration, keep alive and tear down). Therefore
it absolutely needs to continue using this socket after the
registration phase.

> If the userspace might continue using the socket, we would
> 
>   create a new socket, copy required attributes (the source and destination addresses?) from
>   the socket fetched via sockfd_lookup(), and call replace_fd() like e.g. umh_pipe_setup() does
> 
> inside l2tp_tunnel_register(). i-node number of the socket would change, but I assume that
> the process which called l2tp_tunnel_register() is not using that i-node number.
> 
> Since the socket is a datagram socket, I think we can copy required attributes. But since
> I'm not familiar with networking code, I don't know what attributes need to be copied. Thus,
> I leave implementing it to netdev people.

That looks fragile to me. If the problem is that setup_udp_tunnel_sock()
can sleep, we can just drop the udp_tunnel_encap_enable() call from
setup_udp_tunnel_sock(), rename it __udp_tunnel_encap_enable() and make
make udp_tunnel_encap_enable() a wrapper around it that'd also call
udp_tunnel_encap_enable().

