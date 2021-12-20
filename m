Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE9647A9CE
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 13:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhLTMjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 07:39:22 -0500
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:43765 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229820AbhLTMjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 07:39:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id D5FB92B000C1;
        Mon, 20 Dec 2021 07:39:15 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 20 Dec 2021 07:39:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=UEKM6353gMtwbj5uogFb1YAwTYE
        FzwELjSHU5Fnkdf8=; b=iIAdXOiq3/2RZ+MW8h/Q08xYleWGDB+LiyX4prk6Bv6
        LzAdJhsSIbXe1+aSSuLNslV7ZMnraXfPYMBmotXtmpMuM0ydyS47oS7Fen84IBEv
        +x1eaJbHzOPeWtLuv4C7HqUgpRj9VC1t3yEEo3eAEKPw7lyELdyXvhkgviWpZjsh
        Kt+wEE3WkP5LZvXaZobaItNS+oI+v61c5VmTnoJ8sl3CXMbIRy9WTeqnYEPRuycs
        fHymhPlOtzfUvt5/gIihvGHT44SrPEV3/8K8urCHwk7olWTqhaZGaicJxCeHEAl0
        qovzHpXvpF76rxdBN5einCAHctLJ0PYItYqFNsr+hpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UEKM63
        53gMtwbj5uogFb1YAwTYEFzwELjSHU5Fnkdf8=; b=RS+LveO7MG3CQJt2y+3Oz/
        BjiLK8cdwJUuZ8DeYJjBHGJP6Vc5hsaVJxKV3Aqo1k+6uu2bZKXYD99EipOhXECG
        AOhA+M81AgTERl0O1Iz2sUKN0gONuS0DgQ6bQS51k7ym5R+ncHfuqrsTeJAZE6O6
        sbNfgsBwTDNo3AIT57xZQ/t7JxmJSCXsBSc4sDI5Ph+3Z8kSAn5qOfZuKrUCdIur
        oefqk9ZpYSlu19V1fBsACVHpBTXQyjvEY8hEYxJHrMwLEflXg2/sOiNdRoceARuu
        Aq6De7UCTQYTxqblVlGmhVsyppBkthMmncb2GmWPqJRNzYckds/WpfQAczPVE3Gw
        ==
X-ME-Sender: <xms:cnnAYVTeIaz3W5-lKbZ4QsA87-e6sD8tfg5PGWAHqjhq3EYe3wm00g>
    <xme:cnnAYew9kc3u4P0-FYddHrmgoc9os6LHwxcc_KJXnR3w9NxqDgiaukqxP1WjsUcUG
    _YGUSpuQ1-HFw>
X-ME-Received: <xmr:cnnAYa29abms16yQYDwTh_a-91-y7pf82VjsGgm6RWnXfROpBD81CumwZc1Kh59i_t6Jlo6uoJx8PxkcVJRc4OtfXnfjWSzS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtvddggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:cnnAYdCczhiKrP_qvxqIJ8jUmnIPab60PWh-JHnYf84tTQ35kficzQ>
    <xmx:cnnAYeho31zb2JpAAllfw_cj09IXVsNEW3D2Fo24788vXuTRIqbVfw>
    <xmx:cnnAYRq3Jqp1UQOCwEsIbZucbJLIhMDV1bprGLNhNH_uaY_fwC2hyQ>
    <xmx:c3nAYUIp5PIKsl0Pm2qQWT3hoGvd0E3V22bmR-HxIkwLrL9gAwEWKtQKyf4>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Dec 2021 07:39:13 -0500 (EST)
Date:   Mon, 20 Dec 2021 13:39:11 +0100
From:   Greg KH <greg@kroah.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, clang-built-linux@googlegroups.com,
        ulli.kroll@googlemail.com, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, amitkarwar@gmail.com,
        nishants@marvell.com, gbhat@marvell.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, dmitry.torokhov@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org,
        linux-input@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH 4.14 5/6] ARM: 8788/1: ftrace: remove old mcount support
Message-ID: <YcB5b65dVUIhzgIh@kroah.com>
References: <20211220122506.3631672-1-anders.roxell@linaro.org>
 <20211220122506.3631672-6-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220122506.3631672-6-anders.roxell@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 01:25:05PM +0100, Anders Roxell wrote:
> From: Stefan Agner <stefan@agner.ch>
> 
> commit d3c61619568c88d48eccd5e74b4f84faa1440652 upstream.
> 
> Commit cafa0010cd51 ("Raise the minimum required gcc version to 4.6")

That commit is in 4.19, not 4.14.  So are you SURE this is ok for 4.14
and older kernels?

> raised the minimum GCC version to 4.6. Old mcount is only required for
> GCC versions older than 4.4.0. Hence old mcount support can be dropped
> too.

And as I asked on the 4.19 submission of this patch, what does this have
to do with clang?

thanks,

greg k-h
