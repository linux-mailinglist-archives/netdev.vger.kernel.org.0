Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF73652CDE
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 07:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiLUGcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 01:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLUGcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 01:32:45 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE031CFDB;
        Tue, 20 Dec 2022 22:32:43 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 5722F3200681;
        Wed, 21 Dec 2022 01:32:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 21 Dec 2022 01:32:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1671604359; x=1671690759; bh=tFNiZ7mgC2
        UQrzBtyZ3/s34vGBOo01zeIS5TXuytIYA=; b=0fTPqp5inZjkIMorbKtDswd7LB
        qVShUvfAiQdzIA8ieiVn4vemMq2jphJ8ah3svtA0EAF64GqZteS7dCn/ThPWqQnD
        YcQjEf6+mhUX53s/WIPRMkCxcnRQSMAvYMPm1rdK6tPSACp3D9CpdC5Jr9Oqwml9
        4wxwvKskigTWC9buuwl1sM0Lk9qGJYdqWQsSVaZWeoMxnpfooh5rJGDHarRBQu88
        1hFZLVeq6w5RyTyuIglA9dOhn14tg2rfpgU2Fmz5yFjDjsUEUUlkIgxNoiQlJ1kC
        fM6YeKR4xHMUTh7DpmSij+D9OyA332/2cpkAJGo8DUV6Fjzua+eqLfOBgwGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1671604359; x=1671690759; bh=tFNiZ7mgC2UQrzBtyZ3/s34vGBOo
        01zeIS5TXuytIYA=; b=W2rnJyTrv06heRz1ddhHlrNPNWI4d8yM6PS++6s8ectX
        8gZAUrBEiRTFTbva8RnFUsUhypISHj3Xi3piWBrbWP1GSH13I95xNLVZYsKK6x1e
        RGTFgtoVmc3Qd23euYwkDHbDj4DVKFFo5nAC2wtw6F7l7WmUHrUkn20mcFy3uPoP
        1GlWaGzEG9R83hRrRi/QEcbok5Yd96UJZ/RCgMJZzLPFFXqcyMQkIxgVWnpGoiZw
        rw1Tw2s9OZ39Cj13d4zDX8eqRD8jy2D0NJoeIE7zQ1U+PocNK0Gy+S/UajkXtoYK
        vOzxyVCFzWKHVTiCykGOZ4Ldf6cAb8VdqHxZ3X15jA==
X-ME-Sender: <xms:h6iiYw70ja8YNVbPPVH-0cfOyhqq5VfQgqWJaa7YXDI5PLUB6h-HNg>
    <xme:h6iiYx6ak7H8UXZCA9Hae9FYJrjypwVp85vdmprv2i9blA25k8Ty26qqZ8S4Dl9VD
    v5TGBbA1y-HAw>
X-ME-Received: <xmr:h6iiY_fqV0eqqHX41tz7khWDiKw_HY9f0DK1ywpc79_Co-l7OowUYiXB7AB6xtTXwxuzzXfbx_QzPZQLeQQwy1mT5HVVWDPH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeejgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:h6iiY1JhIHAgM2oOIYsl9XQt2rFiB2qw5I0rO1G80frxb2jfSi22LQ>
    <xmx:h6iiY0LgFOVNLeIG2aAOERlG3XQpuJFk4DRDAAjiepsb3YynAMU4dw>
    <xmx:h6iiY2xkHcW5UwnWClTeqVDqlwzEt-m2RbUk4RwXc1nOBrna7EwBgg>
    <xmx:h6iiY17y_AdWYsQmfUGeijUxR0_niKRs2uTd8tOxFHnF7BGjPvmlvA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Dec 2022 01:32:39 -0500 (EST)
Date:   Wed, 21 Dec 2022 07:32:34 +0100
From:   Greg KH <greg@kroah.com>
To:     Leesoo Ahn <lsahn@ooseel.net>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usbnet: optimize usbnet_bh() to reduce CPU load
Message-ID: <Y6KoglOyuFEqfp2k@kroah.com>
References: <20221221044230.1012787-1-lsahn@ooseel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221044230.1012787-1-lsahn@ooseel.net>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 01:42:30PM +0900, Leesoo Ahn wrote:
> The current source pushes skb into dev->done queue by calling
> skb_queue_tail() and then pop it by calling skb_dequeue() to branch to
> rx_cleanup state for freeing urb/skb in usbnet_bh(). It takes extra CPU
> load, 2.21% (skb_queue_tail) as follows.
> 
> -   11.58%     0.26%  swapper          [k] usbnet_bh
>    - 11.32% usbnet_bh
>       - 6.43% skb_dequeue
>            6.34% _raw_spin_unlock_irqrestore
>       - 2.21% skb_queue_tail
>            2.19% _raw_spin_unlock_irqrestore
>       - 1.68% consume_skb
>          - 0.97% kfree_skbmem
>               0.80% kmem_cache_free
>            0.53% skb_release_data
> 
> To reduce the extra CPU load use return values jumping to rx_cleanup
> state directly to free them instead of calling skb_queue_tail() and
> skb_dequeue() for push/pop respectively.
> 
> -    7.87%     0.25%  swapper          [k] usbnet_bh
>    - 7.62% usbnet_bh
>       - 4.81% skb_dequeue
>            4.74% _raw_spin_unlock_irqrestore
>       - 1.75% consume_skb
>          - 0.98% kfree_skbmem
>               0.78% kmem_cache_free
>            0.58% skb_release_data
>         0.53% smsc95xx_rx_fixup
> 
> Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
> ---
> v2:
>   - Replace goto label with return statement to reduce goto entropy
>   - Add CPU load information by perf in commit message
> 
> v1 at:
>   https://patchwork.kernel.org/project/netdevbpf/patch/20221217161851.829497-1-lsahn@ooseel.net/
> ---
>  drivers/net/usb/usbnet.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 64a9a80b2309..6e82fef90dd9 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -555,32 +555,30 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
>  
>  /*-------------------------------------------------------------------------*/
>  
> -static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
> +static inline int rx_process(struct usbnet *dev, struct sk_buff *skb)
>  {
>  	if (dev->driver_info->rx_fixup &&
>  	    !dev->driver_info->rx_fixup (dev, skb)) {
>  		/* With RX_ASSEMBLE, rx_fixup() must update counters */
>  		if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
>  			dev->net->stats.rx_errors++;
> -		goto done;
> +		return 1;

"1" means that you processed 1 byte, not that this is an error, which is
what you want to say here, right?  Please return a negative error value
like I asked this to be changed to last time :(

thanks,

greg k-h
