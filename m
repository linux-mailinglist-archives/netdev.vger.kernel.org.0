Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9126508ED
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 09:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiLSIzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 03:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbiLSIzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 03:55:52 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B8E2DF7;
        Mon, 19 Dec 2022 00:55:50 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8C6595C0043;
        Mon, 19 Dec 2022 03:55:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 19 Dec 2022 03:55:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1671440148; x=
        1671526548; bh=eMMPh/ciG0DXgfI+9o4EtPudEkxX99ooCttHrCr6mKg=; b=B
        1LQMlTvdydkZ/exDbQA/COKdEJTiuSAPDsJoKXXMOrKKwwDOy5wUgebclFCOlO8y
        Jc+RLS2C0tLfBsyKGBSzA+So5Rk3ut49hjkVvwValp3DUJO4WcCpCJII39kShlXN
        P/B6DRdzzeTtTiZ3zBuuiBVEwABARZu7j38qybPjkYpIp1yjO9h11vF7hIlvAHyG
        gwXSonP/lWxUBrgKs1yFqsTyIKrec5aD/N/ma2ypi+GY5UGXEx7wcrT9YI9v5rq1
        zRW0ZtJHBQSUKyWP1XfKDj6k/OrhKjnXD2xBWeFbJp1z7YIRqwLk+Z0bVoRuNsRb
        Hu28BXdT9dS85Sp/VCgTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1671440148; x=
        1671526548; bh=eMMPh/ciG0DXgfI+9o4EtPudEkxX99ooCttHrCr6mKg=; b=p
        q1elzxYKPqIrfUgE3Hkw/BavN27iYlmD8Ri/vc/7g557mcFAiBrj7R9mz9gUZkQ2
        TVhbolU8DBCAdvPRaeTusEu65vwedeoptflLJLVHzcptOrwISmsZG8JBflFhXUTU
        ZVTIpNSoUtORkXmJ+aONeJ4ecAOOc3ju3owZYQeyLdtVO0mCO/HCTQsyhSvnvmc4
        eE2/mByaB4tw3fb40A2wfKNFXKTe663pRjJ6Z87mCzE3POAnKVo+4DBAm7YontDO
        09tXyi27Ihyyz7JizhPpRtxAP3IRhZDMhJ2jfEQsZ4Cz9NoCA5yS2uG2Nc6GCbp7
        5R6pPZug+T7c5AtY5fTVQ==
X-ME-Sender: <xms:FCegYz4nbb6vPFHnOdvbozEthiVZ6PVKREHPOc3dJuhF8ejVc_vTVw>
    <xme:FCegY46F2V650-NREpi4QXiiMFqmmKTAYeLZVKJo0tvXnHGNO6AtjypaC5dO-qC_r
    S4aqlauHkEWtg>
X-ME-Received: <xmr:FCegY6fJ4wo3qowdSN_SDB3F476RB7d7JGKXiVD7l_TTQ4OL-b3DyR3Gfn8ycNlc3ChR6UfV-5DnBlnkno4DIg9rf5G2fwL9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedvgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefgke
    ffieefieevkeelteejvdetvddtledugfdvhfetjeejieduledtfefffedvieenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:FCegY0JSAEeyCqs6z721Z3_qai_xDqU5C1OKXyn-s2ErRlhocuZFTw>
    <xmx:FCegY3IWJtJp5frQPv_1Vfp5IK0p51QW5vYtIl-RF_xHM3rC5h2jFQ>
    <xmx:FCegY9yWYMDwLHX7enGSnNAxnevPgfXiq021zUIaSU31nmNjAivCkA>
    <xmx:FCegYw6DTjuJ9sdGozETtf73NoPu79OJGHkqBm4J0HhqE1B2Tcx5aw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Dec 2022 03:55:47 -0500 (EST)
Date:   Mon, 19 Dec 2022 09:55:45 +0100
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
Message-ID: <Y6AnEWWd7DQg0b6o@kroah.com>
References: <20221217161851.829497-1-lsahn@ooseel.net>
 <Y57VkLKetDsbUUjC@kroah.com>
 <a2e0e98a-1044-908a-15bc-b165ff8b23ea@ooseel.net>
 <Y6AXqOlCUy7mahgj@kroah.com>
 <403f3ea8-eeec-2a78-640e-c11c3fe28f45@ooseel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <403f3ea8-eeec-2a78-640e-c11c3fe28f45@ooseel.net>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 05:09:21PM +0900, Leesoo Ahn wrote:
> 
> On 22. 12. 19. 16:50, Greg KH wrote:
> > On Mon, Dec 19, 2022 at 04:41:16PM +0900, Leesoo Ahn wrote:
> > > On 22. 12. 18. 17:55, Greg KH wrote:
> > > > On Sun, Dec 18, 2022 at 01:18:51AM +0900, Leesoo Ahn wrote:
> > > > > The current source pushes skb into dev->done queue by calling
> > > > > skb_queue_tail() and then, call skb_dequeue() to pop for rx_cleanup state
> > > > > to free urb and skb next in usbnet_bh().
> > > > > It wastes CPU resource with extra instructions. Instead, use return values
> > > > > jumping to rx_cleanup case directly to free them. Therefore calling
> > > > > skb_queue_tail() and skb_dequeue() is not necessary.
> > > > > 
> > > > > The follows are just showing difference between calling skb_queue_tail()
> > > > > and using return values jumping to rx_cleanup state directly in usbnet_bh()
> > > > > in Arm64 instructions with perf tool.
> > > > > 
> > > > > ----------- calling skb_queue_tail() -----------
> > > > >          │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
> > > > >     7.58 │248:   ldr     x0, [x20, #16]
> > > > >     2.46 │24c:   ldr     w0, [x0, #8]
> > > > >     1.64 │250: ↑ tbnz    w0, #14, 16c
> > > > >          │     dev->net->stats.rx_errors++;
> > > > >     0.57 │254:   ldr     x1, [x20, #184]
> > > > >     1.64 │258:   ldr     x0, [x1, #336]
> > > > >     2.65 │25c:   add     x0, x0, #0x1
> > > > >          │260:   str     x0, [x1, #336]
> > > > >          │     skb_queue_tail(&dev->done, skb);
> > > > >     0.38 │264:   mov     x1, x19
> > > > >          │268:   mov     x0, x21
> > > > >     2.27 │26c: → bl      skb_queue_tail
> > > > >     0.57 │270: ↑ b       44    // branch to call skb_dequeue()
> > > > > 
> > > > > ----------- jumping to rx_cleanup state -----------
> > > > >          │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
> > > > >     1.69 │25c:   ldr     x0, [x21, #16]
> > > > >     4.78 │260:   ldr     w0, [x0, #8]
> > > > >     3.28 │264: ↑ tbnz    w0, #14, e4    // jump to 'rx_cleanup' state
> > > > >          │     dev->net->stats.rx_errors++;
> > > > >     0.09 │268:   ldr     x1, [x21, #184]
> > > > >     2.72 │26c:   ldr     x0, [x1, #336]
> > > > >     3.37 │270:   add     x0, x0, #0x1
> > > > >     0.09 │274:   str     x0, [x1, #336]
> > > > >     0.66 │278: ↑ b       e4    // branch to 'rx_cleanup' state
> > > > Interesting, but does this even really matter given the slow speed of
> > > > the USB hardware?
> > > It doesn't if USB hardware has slow speed but in software view, it's still
> > > worth avoiding calling skb_queue_tail() and skb_dequeue() which work with
> > > spinlock, if possible.
> > But can you actually measure that in either CPU load or in increased
> > transfer speeds?
> > 
> > thanks,
> > 
> > greg k-h
> 
> I think the follows are maybe what you would be interested in. I have tested
> both case with perf on the same machine and environments, also modified
> driver code a bit to go to rx_cleanup case, not to net stack in a specific
> packet.
> 
> ----- calling skb_queue_tail() -----
> -   11.58%     0.26%  swapper          [k] usbnet_bh
>    - 11.32% usbnet_bh
>       - 6.43% skb_dequeue
>            6.34% _raw_spin_unlock_irqrestore
>       - 2.21% skb_queue_tail
>            2.19% _raw_spin_unlock_irqrestore
>       - 1.68% consume_skb
>          - 0.97% kfree_skbmem
>               0.80% kmem_cache_free
>            0.53% skb_release_data
> 
> ----- jump to rx_cleanup directly -----
> -    7.62%     0.18%  swapper          [k] usbnet_bh
>    - 7.44% usbnet_bh
>       - 4.63% skb_dequeue
>            4.57% _raw_spin_unlock_irqrestore
>       - 1.76% consume_skb
>          - 1.03% kfree_skbmem
>               0.86% kmem_cache_free
>            0.56% skb_release_data
>         0.54% smsc95xx_rx_fixup
> 
> The first case takes CPU resource a bit much by the result.

Ok, great!  Fix up the patch based on the review comments and add this
information to the changelog as well.

thanks,

greg k-h
