Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF15D64BBD1
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 19:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbiLMSUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 13:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236256AbiLMSUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 13:20:15 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CC618B;
        Tue, 13 Dec 2022 10:20:14 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g1so2797145pfk.2;
        Tue, 13 Dec 2022 10:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=12L7Z+MEDZZwbqdCC2cbVjIty7N4/EBKUaDawJXCP64=;
        b=Obe3K9oqhURedPlDLQyxc4+H7IMBElvpTTJ5KnsfHhRpClEgYnRBwiilY0sPViIrYR
         m2N+yHYkDX1D1odshVfvZQaWTbooGMdeU202FuS6zqOB2oHiUMcprJzsWM94WBqXzOp2
         /YEU3wTQLNjO/tqkHrDYb9mx2C9gU0EgUL/EmKcBhwhIlFy9d98534d5NO8g2wYdrBLn
         uPTIZdudDIBek4aVxg1UjIiX+PKNiJZlJ343w/Y/b6GblBLCVSfxJckDxcuG605hIMy5
         3q+jmwUozeRcA9t0fPKe9fyMustqF12DrWzPs6hrSehbuUb3dNS9UDtShUY58eaW4EXJ
         Goiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=12L7Z+MEDZZwbqdCC2cbVjIty7N4/EBKUaDawJXCP64=;
        b=gZVyQGhPJnOiotZIXV7menEQxF5HMIVHNoHxJCDoIweWeClAi7M5VamScqCNvRqSxP
         kogEJfhfLtdrpoyCmIpE6MCWJZq+ANxRvrtplzN02s9mQj5RvrAhx4fURltI8/vqV6Qi
         ARY4DBrZY7YrOcKaKn9VkSMzArX0KF51u125Y4i/D45kMV0kGHXUgfpmRr/iVX+WzRqe
         RJVM2iJV74CCeIsySN3+tsYaQ4Or23Osefaux2Rc36zJEM4YUDCqUWURatvLgTIk7/UY
         eyrBoLRPOLkNJNJPLT6xCYbLNIDyDyj+hfL556zZrk7ae3FLMkiRXkLj4wvMrD2s69W0
         QkMg==
X-Gm-Message-State: ANoB5pnHaIjdyCa0G2cSHCxWtVMQEYmYfPwov4miRivE74Rap/ZWTaCC
        6ENubmAWJGqf4YjqmEdrdl0=
X-Google-Smtp-Source: AA0mqf7B/t8kQ8DMVePJFYIFKLlu1ypmHi38pqTVS5zUqPpl3q21s9Zh62nS/l0TMxjP/CXn5w0Xfw==
X-Received: by 2002:a62:fb11:0:b0:56c:3696:ad68 with SMTP id x17-20020a62fb11000000b0056c3696ad68mr21069016pfm.8.1670955613572;
        Tue, 13 Dec 2022 10:20:13 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id f136-20020a62388e000000b00574679561b4sm7946846pfa.134.2022.12.13.10.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 10:20:13 -0800 (PST)
Date:   Wed, 23 Nov 2022 12:31:28 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Jiang Wang <jiang.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v6] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
Message-ID: <Y34SoH1nFTXXLWbK@bullseye>
References: <20221213072549.1997724-1-bobby.eshleman@bytedance.com>
 <20221213102232.n2mc3y7ietabncax@sgarzare-redhat>
 <20221213100510-mutt-send-email-mst@kernel.org>
 <20221213154304.rjrwzbv6jywkrpxq@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213154304.rjrwzbv6jywkrpxq@sgarzare-redhat>
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

On Tue, Dec 13, 2022 at 04:43:04PM +0100, Stefano Garzarella wrote:
> On Tue, Dec 13, 2022 at 10:06:23AM -0500, Michael S. Tsirkin wrote:
> > On Tue, Dec 13, 2022 at 11:22:32AM +0100, Stefano Garzarella wrote:
> > > > +	if (len <= GOOD_COPY_LEN && !skb_queue_empty_lockless(&vvs->rx_queue)) {
> > > 
> > > Same here.
> > > 
> > > If there are no major changes to be made, I think the next version is the
> > > final ones, though we are now in the merge window, so net-next is closed
> > > [1], only RFCs can be sent [2].
> > > 
> > > I suggest you wait until the merge window is over (two weeks usually) to
> > > send the next version.
> > 
> > Nah, you never know, could be more comments. And depending on the timing
> > I might be able to merge it.
> 
> Right, in the end these changes are only to virtio-vsock transport, so they
> can go smoothly even with your tree.
> 
> @Bobby, so if you can fix the remaining small things, we can try to merge it
> :-)
> 
> Thanks,
> Stefano

Sure thing. I'll change / send now.

Best,
Bobby
