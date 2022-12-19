Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B165265082F
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 08:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiLSHuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 02:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiLSHuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 02:50:09 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C836166;
        Sun, 18 Dec 2022 23:50:08 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 581C95C012D;
        Mon, 19 Dec 2022 02:50:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 19 Dec 2022 02:50:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1671436205; x=
        1671522605; bh=/TgQfkHiZPsILU6Pg4Zx4XUedwaIG/fCiEbtj6MluG8=; b=q
        9Ry/+b+C9wee79UmRtN4fUJ7If6/uEdEyueaUuAxczU7Cl7F4WrFsmrd7b5DWKV3
        O4oNp26Su5JrkksI1/YhAzJ1u+QC7ag796Wg1fwQNaS23IgCAZdikJyD7eDELa9s
        8ueBH5UZ5wZ5vEYRoeiPmM4U7el99JwCeDO0FBJohYEV/yfJmIjVaX3R/oRI42uh
        L2L0a/1O/v5ffWZwc/RQR3Zfeg4VBHbXodrE4dO5rE33/EGAdvKNcK5UoPccdfyr
        XvzkO6ABmsOgEdTfH45V+z1fOPrpumwwRzna8bLYYltULAkg8+3oOtm29IMqm5ia
        6L4bbsgQAs0fT3dCQsQVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1671436205; x=
        1671522605; bh=/TgQfkHiZPsILU6Pg4Zx4XUedwaIG/fCiEbtj6MluG8=; b=j
        4Rul20eoJ39+IbsepLw93ikm+vraM3KOqUQhPv89ambGyVyrm9r4PEZWeApCklRK
        RtVM8MnfJznH8V6ER9H76CkcbjG1R0Mm5bm9nezpt1vSWyXpIXSE9safw7eNUXph
        teaBEu2dQQvdJeuB6/7bjo32loeusMIO7NcB/ocX6EkD1xUbDdsTgwRcEjY/txLk
        UIVy19AQZNy5cNp93t5xXuFfEaQd99NifWZsIjbGkD7Nf5wD9zzRa32Cq7VfMIwg
        M3efIHVebcyg+Xeerlv4/W0jRpZO303tH6eU0hrvC8jPYCMy9OasRsHxVvQp73+E
        OXSS30TISEdC5OqYtrHKQ==
X-ME-Sender: <xms:rBegY3yfq4rkLJvg8vEQsI3iZIBMoe1L_XYFBj5GHbZqLdX2VgjxvQ>
    <xme:rBegY_RrohJnd6VpOWvxt-A1XEAfjxYYRShXWC6uEUewOqroF-ukTYAWCoWW9Hf5P
    Kdy_XKBSYB3Qw>
X-ME-Received: <xmr:rBegYxWHdfCqTwO_GiLkcpd-GgmwpjQ0Q-RmY4vUNZhLXg_4joCUIL8g9E-bGUD20_8j08WgpPohAq8PcLU_HBbdWPEpxk7I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedvgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefgke
    ffieefieevkeelteejvdetvddtledugfdvhfetjeejieduledtfefffedvieenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:rRegYxjOpvs5-qlG2xvCwAMyarcLSvnL6DOl41NZABwQPtdxBvdSog>
    <xmx:rRegY5AUkw1YZhOff0SEBGBxT4n-zsM_87nVIZSdMaRszKWUJH53DA>
    <xmx:rRegY6K9v0GAiPrLKYIXTOfP__ekd9mJDRXwEXB250kFHfnbi9P7EA>
    <xmx:rRegY7znpobrDA5Puga96_3blmxw4lP9IUmmzcx1B_2rk-8IEAVHrQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Dec 2022 02:50:04 -0500 (EST)
Date:   Mon, 19 Dec 2022 08:50:00 +0100
From:   Greg KH <greg@kroah.com>
To:     Leesoo Ahn <lsahn@ooseel.net>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbnet: jump to rx_cleanup case instead of calling
 skb_queue_tail
Message-ID: <Y6AXqOlCUy7mahgj@kroah.com>
References: <20221217161851.829497-1-lsahn@ooseel.net>
 <Y57VkLKetDsbUUjC@kroah.com>
 <a2e0e98a-1044-908a-15bc-b165ff8b23ea@ooseel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a2e0e98a-1044-908a-15bc-b165ff8b23ea@ooseel.net>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 04:41:16PM +0900, Leesoo Ahn wrote:
> 
> On 22. 12. 18. 17:55, Greg KH wrote:
> > On Sun, Dec 18, 2022 at 01:18:51AM +0900, Leesoo Ahn wrote:
> > > The current source pushes skb into dev->done queue by calling
> > > skb_queue_tail() and then, call skb_dequeue() to pop for rx_cleanup state
> > > to free urb and skb next in usbnet_bh().
> > > It wastes CPU resource with extra instructions. Instead, use return values
> > > jumping to rx_cleanup case directly to free them. Therefore calling
> > > skb_queue_tail() and skb_dequeue() is not necessary.
> > > 
> > > The follows are just showing difference between calling skb_queue_tail()
> > > and using return values jumping to rx_cleanup state directly in usbnet_bh()
> > > in Arm64 instructions with perf tool.
> > > 
> > > ----------- calling skb_queue_tail() -----------
> > >         │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
> > >    7.58 │248:   ldr     x0, [x20, #16]
> > >    2.46 │24c:   ldr     w0, [x0, #8]
> > >    1.64 │250: ↑ tbnz    w0, #14, 16c
> > >         │     dev->net->stats.rx_errors++;
> > >    0.57 │254:   ldr     x1, [x20, #184]
> > >    1.64 │258:   ldr     x0, [x1, #336]
> > >    2.65 │25c:   add     x0, x0, #0x1
> > >         │260:   str     x0, [x1, #336]
> > >         │     skb_queue_tail(&dev->done, skb);
> > >    0.38 │264:   mov     x1, x19
> > >         │268:   mov     x0, x21
> > >    2.27 │26c: → bl      skb_queue_tail
> > >    0.57 │270: ↑ b       44    // branch to call skb_dequeue()
> > > 
> > > ----------- jumping to rx_cleanup state -----------
> > >         │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
> > >    1.69 │25c:   ldr     x0, [x21, #16]
> > >    4.78 │260:   ldr     w0, [x0, #8]
> > >    3.28 │264: ↑ tbnz    w0, #14, e4    // jump to 'rx_cleanup' state
> > >         │     dev->net->stats.rx_errors++;
> > >    0.09 │268:   ldr     x1, [x21, #184]
> > >    2.72 │26c:   ldr     x0, [x1, #336]
> > >    3.37 │270:   add     x0, x0, #0x1
> > >    0.09 │274:   str     x0, [x1, #336]
> > >    0.66 │278: ↑ b       e4    // branch to 'rx_cleanup' state
> > Interesting, but does this even really matter given the slow speed of
> > the USB hardware?
> 
> It doesn't if USB hardware has slow speed but in software view, it's still
> worth avoiding calling skb_queue_tail() and skb_dequeue() which work with
> spinlock, if possible.

But can you actually measure that in either CPU load or in increased
transfer speeds?

thanks,

greg k-h
