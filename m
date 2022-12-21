Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A682652D48
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 08:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiLUHbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 02:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLUHbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 02:31:04 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B548C380;
        Tue, 20 Dec 2022 23:31:01 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0DF2E3200392;
        Wed, 21 Dec 2022 02:30:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 21 Dec 2022 02:31:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1671607859; x=1671694259; bh=O8xQM8FhPI
        CCXN5BDcGKLg4kecw/aF39ebQKzWbQUtw=; b=ZB4/OYBgAp4yD28FwV0OZWpgAU
        5+6nj+xrmQCeiamRopsAcq/HfHaI0z3/niTf62IwM50916uHqzjM94nWWckk4daw
        IOGFSa7zPzH3nGleZ9ql2HXxE9cP/t2SZ3mMtzqk8DwNxlR5ap9WCaA1jqYiqVfv
        LY6/MSnCHboPNeSbaDb5d4yAp/E1ei1VD1OcSbrj5/h9EUusQUWST55+BgDil8ur
        upSeQifi7D8CxjAl8nibev+B9cfFSTaKj0+yh6zwMHsF2HAmRfZYyXxE9eDdP7oS
        0nNbpZa+TLUESHQosi3cw7h2SnzQ9gzIrBZR6lBDinejz9nalpHTb39oIbww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1671607859; x=1671694259; bh=O8xQM8FhPICCXN5BDcGKLg4kecw/
        aF39ebQKzWbQUtw=; b=AhwJw5L+ggLWGoNyLZTvdivF9O7WW1Lo1qGQWFUy2gXX
        CSmtHs+vf4Yi1++gBWLuxxik2gkme+r2bNo9jVcAj19hNMyJcnPkP01dnbSKwwtF
        8k/ghOFmkzBPZR0thcUiNDHDm8HlhpoxIhnjFivEtb7KOONMcfy6Q32O9yQLCeR6
        E330A1PlS4CBrUp2Jas7XKzUWEv02Ho8mZVVHmQcqDkxY8dLuob6HER3SsEJn+C+
        7FQfFQuSrlDqAEL2MoxbDqgn0Idr36Ibn0z6M0OVFZptRWOjIKUzBCFOohUFybSx
        Pdu0+BMNn4cUw4MMco6KnDJgzYVMk6eCGo7kifWDog==
X-ME-Sender: <xms:M7aiYyNdCmHrk56UVMCnXiyDOtcRnnvqLguz1pEt6EhZAJplugFlBg>
    <xme:M7aiYw82UR-ita_nuM4pkkudyCaa-H6af2pjk1pJUxssZAkBX-z46TqqsSYHhhk9D
    077Wmh92BDKAA>
X-ME-Received: <xmr:M7aiY5TWWRuIYDwqwOxMRWTvr4QoROTdVjaE_FzexqEhzElFcbjz6gr6Y0IPy-uWl-TKSTmUt9woMJGh2R3vSXpwO65HWr6l>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeejgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:M7aiYyvBXMkm2Oj4MEu7CozzISS4TFI8NubXCSXGUjqk4esQejqbew>
    <xmx:M7aiY6el8qvSErucixu21IHdurxHL5kxL_XVtusDH_N9Jv5Bw1IMGQ>
    <xmx:M7aiY20u_z8fxHCdbWyikutIVqOdka9XRmBoq7tMZsf46Sm_6vhhYQ>
    <xmx:M7aiY9vdZKFcdmzHIBWWViNpvG84QsbGYjwozHmta6VXQf4eteB5eg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Dec 2022 02:30:58 -0500 (EST)
Date:   Wed, 21 Dec 2022 08:30:55 +0100
From:   Greg KH <greg@kroah.com>
To:     Leesoo Ahn <lsahn@ooseel.net>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usbnet: optimize usbnet_bh() to reduce CPU load
Message-ID: <Y6K2L+t5NjK/3ipj@kroah.com>
References: <20221221044230.1012787-1-lsahn@ooseel.net>
 <Y6KoglOyuFEqfp2k@kroah.com>
 <2d4033ea-3034-24cf-493c-f60258f9988d@ooseel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d4033ea-3034-24cf-493c-f60258f9988d@ooseel.net>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 04:19:45PM +0900, Leesoo Ahn wrote:
> 
> On 22. 12. 21. 15:32, Greg KH wrote:
> > On Wed, Dec 21, 2022 at 01:42:30PM +0900, Leesoo Ahn wrote:
> > > The current source pushes skb into dev->done queue by calling
> > > skb_queue_tail() and then pop it by calling skb_dequeue() to branch to
> > > rx_cleanup state for freeing urb/skb in usbnet_bh(). It takes extra CPU
> > > load, 2.21% (skb_queue_tail) as follows.
> > > 
> > > -   11.58%     0.26%  swapper          [k] usbnet_bh
> > >     - 11.32% usbnet_bh
> > >        - 6.43% skb_dequeue
> > >             6.34% _raw_spin_unlock_irqrestore
> > >        - 2.21% skb_queue_tail
> > >             2.19% _raw_spin_unlock_irqrestore
> > >        - 1.68% consume_skb
> > >           - 0.97% kfree_skbmem
> > >                0.80% kmem_cache_free
> > >             0.53% skb_release_data
> > > 
> > > To reduce the extra CPU load use return values jumping to rx_cleanup
> > > state directly to free them instead of calling skb_queue_tail() and
> > > skb_dequeue() for push/pop respectively.
> > > 
> > > -    7.87%     0.25%  swapper          [k] usbnet_bh
> > >     - 7.62% usbnet_bh
> > >        - 4.81% skb_dequeue
> > >             4.74% _raw_spin_unlock_irqrestore
> > >        - 1.75% consume_skb
> > >           - 0.98% kfree_skbmem
> > >                0.78% kmem_cache_free
> > >             0.58% skb_release_data
> > >          0.53% smsc95xx_rx_fixup
> > > 
> > > Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
> > > ---
> > > v2:
> > >    - Replace goto label with return statement to reduce goto entropy
> > >    - Add CPU load information by perf in commit message
> > > 
> > > v1 at:
> > >    https://patchwork.kernel.org/project/netdevbpf/patch/20221217161851.829497-1-lsahn@ooseel.net/
> > > ---
> > >   drivers/net/usb/usbnet.c | 19 +++++++++----------
> > >   1 file changed, 9 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> > > index 64a9a80b2309..6e82fef90dd9 100644
> > > --- a/drivers/net/usb/usbnet.c
> > > +++ b/drivers/net/usb/usbnet.c
> > > @@ -555,32 +555,30 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
> > >   /*-------------------------------------------------------------------------*/
> > > -static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
> > > +static inline int rx_process(struct usbnet *dev, struct sk_buff *skb)
> > >   {
> > >   	if (dev->driver_info->rx_fixup &&
> > >   	    !dev->driver_info->rx_fixup (dev, skb)) {
> > >   		/* With RX_ASSEMBLE, rx_fixup() must update counters */
> > >   		if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
> > >   			dev->net->stats.rx_errors++;
> > > -		goto done;
> > > +		return 1;
> > "1" means that you processed 1 byte, not that this is an error, which is
> > what you want to say here, right?
> No not at all..
> > Please return a negative error value
> > like I asked this to be changed to last time :(
> Could you help me to decide the message type at this point please? I am
> confused.

I do not know, pick something that seems correct and we can go from
there.  The important thing is that it is a -ERR value, not a positive
one as that makes no sense for kernel functions.

thanks,

greg k-h
