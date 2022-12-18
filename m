Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5C664FE1E
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 09:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiLRIzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 03:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiLRIzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 03:55:50 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644115F9C;
        Sun, 18 Dec 2022 00:55:49 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DEB275C00E2;
        Sun, 18 Dec 2022 03:55:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 18 Dec 2022 03:55:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1671353746; x=
        1671440146; bh=HuE2xNjaCsqZcCimOMMVJ+moDlJHyApAuDFUa5X1uOI=; b=s
        KAtTR8dVPO6/9rTlLZrtLQMWIN+wRtzJ335GPnG10lT3d8W5wzzdhIVIAKQU4ddm
        22J/EZr6AdsfQOhxBzOE6e87A4rkjJnrEJb1phODD/4XUTO67nJOppO/+h290FIL
        MjmUleuYXMXRYsac+w83opNJPbYjlU8RT1vmFvgqGSt+a1O831bHcyysxIIm9gv4
        CcTcN0MdgwAc80b8OJoaE2yjx+ZZhzGOhwN0+Guyn51IHo/ObI0PToRlkkFCiKXu
        zFL3eIAfCIzoeH8qKfmjwQqnH7OMiwdUQiyG3Gm70tx6xy1dT3I9gBN6JSXMFPeb
        gtMeMcGnp8xFc493zmvmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1671353746; x=
        1671440146; bh=HuE2xNjaCsqZcCimOMMVJ+moDlJHyApAuDFUa5X1uOI=; b=v
        SB0nvwy9FHI37TGPI6fvkqhePxAsgli4lXWSLCsk1Fih76UchgJU/Vk0yqv5OcTH
        kUbuZXrJwo3etdrXJJ3tG2YKzpHsLVNSCc/FGTg6iBPWwFWVBmTeH02WphSqb1CF
        1wxnfTBrQtL0iZ98bkgaDdmiwvGQvPULiQ/5Q+yV4ONNmMBsq0JUUTRj2PX7r0ft
        jZvy2k5MBEfzoI59zD2ptGFeimKf5FCBwtw+Nq1Oy/Uz1U9plGhqQD9iGjL5GfBI
        X79PD3aECWAZL6WhlY1T/L6L9rDauqk2bzhGEsxOWjAPHKglXPrtv08N2jUBIj5e
        33FdQLG0jcJ2G6Fs+uo/g==
X-ME-Sender: <xms:ktWeY--j1vLLETFvw8SLrxlL3w7YI-QkASwWeBYqW-oa_5lqo8xPeA>
    <xme:ktWeY-ui9ub_8AIOq2bE_tL-30tTDbMDm5kH94qUrjY7oc_P2Pkz7GMRBY-dOGYA9
    8O0LRyJ5rAsUw>
X-ME-Received: <xmr:ktWeY0DYZt-4dotV2VtDTqyUzo3b3TkjQoT5WboFLG0Jgv4SoIXTIMssqX4WXa0Lht5G71RmCy-SRYBJ9JCakWiyehaqiW8T>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefgke
    ffieefieevkeelteejvdetvddtledugfdvhfetjeejieduledtfefffedvieenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:ktWeY2f_9qR2A0ASZM6aflweJP3E1K6bOn8UQ7IM7axRYUSMrL765Q>
    <xmx:ktWeYzMN2SeA1OSxgV-0QV3sP_DbI04F5d3fhS9OVOcWSj4ENVR2Fw>
    <xmx:ktWeYwkNMd97IFl_CNj-gUnaNyUVkY3yavTqTGf-0F0ZHi3Ac0d_hQ>
    <xmx:ktWeYwcMwafXcf25B8WTMkwOrm9aqo-52lXebmcd8v_BwUZtZOyAHw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 18 Dec 2022 03:55:46 -0500 (EST)
Date:   Sun, 18 Dec 2022 09:55:44 +0100
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
Message-ID: <Y57VkLKetDsbUUjC@kroah.com>
References: <20221217161851.829497-1-lsahn@ooseel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221217161851.829497-1-lsahn@ooseel.net>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 18, 2022 at 01:18:51AM +0900, Leesoo Ahn wrote:
> The current source pushes skb into dev->done queue by calling
> skb_queue_tail() and then, call skb_dequeue() to pop for rx_cleanup state
> to free urb and skb next in usbnet_bh().
> It wastes CPU resource with extra instructions. Instead, use return values
> jumping to rx_cleanup case directly to free them. Therefore calling
> skb_queue_tail() and skb_dequeue() is not necessary.
> 
> The follows are just showing difference between calling skb_queue_tail()
> and using return values jumping to rx_cleanup state directly in usbnet_bh()
> in Arm64 instructions with perf tool.
> 
> ----------- calling skb_queue_tail() -----------
>        │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
>   7.58 │248:   ldr     x0, [x20, #16]
>   2.46 │24c:   ldr     w0, [x0, #8]
>   1.64 │250: ↑ tbnz    w0, #14, 16c
>        │     dev->net->stats.rx_errors++;
>   0.57 │254:   ldr     x1, [x20, #184]
>   1.64 │258:   ldr     x0, [x1, #336]
>   2.65 │25c:   add     x0, x0, #0x1
>        │260:   str     x0, [x1, #336]
>        │     skb_queue_tail(&dev->done, skb);
>   0.38 │264:   mov     x1, x19
>        │268:   mov     x0, x21
>   2.27 │26c: → bl      skb_queue_tail
>   0.57 │270: ↑ b       44    // branch to call skb_dequeue()
> 
> ----------- jumping to rx_cleanup state -----------
>        │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
>   1.69 │25c:   ldr     x0, [x21, #16]
>   4.78 │260:   ldr     w0, [x0, #8]
>   3.28 │264: ↑ tbnz    w0, #14, e4    // jump to 'rx_cleanup' state
>        │     dev->net->stats.rx_errors++;
>   0.09 │268:   ldr     x1, [x21, #184]
>   2.72 │26c:   ldr     x0, [x1, #336]
>   3.37 │270:   add     x0, x0, #0x1
>   0.09 │274:   str     x0, [x1, #336]
>   0.66 │278: ↑ b       e4    // branch to 'rx_cleanup' state

Interesting, but does this even really matter given the slow speed of
the USB hardware?

> Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
> ---
>  drivers/net/usb/usbnet.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 64a9a80b2309..924392a37297 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -555,7 +555,7 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
>  
>  /*-------------------------------------------------------------------------*/
>  
> -static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
> +static inline int rx_process(struct usbnet *dev, struct sk_buff *skb)
>  {
>  	if (dev->driver_info->rx_fixup &&
>  	    !dev->driver_info->rx_fixup (dev, skb)) {
> @@ -576,11 +576,11 @@ static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
>  		netif_dbg(dev, rx_err, dev->net, "rx length %d\n", skb->len);
>  	} else {
>  		usbnet_skb_return(dev, skb);
> -		return;
> +		return 0;
>  	}
>  
>  done:
> -	skb_queue_tail(&dev->done, skb);
> +	return -1;

Don't make up error numbers, this makes it look like this failed, not
succeeded.  And if this failed, give it a real error value.

thanks,

greg k-h
