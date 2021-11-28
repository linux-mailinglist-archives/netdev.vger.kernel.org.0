Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA64460661
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 14:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhK1NPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 08:15:00 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:52567 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236398AbhK1NM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 08:12:58 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3AB1A580367;
        Sun, 28 Nov 2021 08:09:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 28 Nov 2021 08:09:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=IXzF23
        awY0KdzU5MgQz9zPwiFr04JG1XhZuChJTmCZQ=; b=nKssalVhvN+7uF1sbfed7P
        A5T11HFa1cnA0kWJztHGAv1CCBpTRk0VqCHELOxn10m3PejKq2O3aDzofM/j3wlo
        VO6HHXx+Ro+0McHJpot3t9ftrgkD/CX6HESeXZUv9wg3CFZRALC+dYl7MqEUbGcR
        g7Ikyl5YQPTZAe02ya6YUTS5L4o97BGEE9pkBylAqJFJmzZ4bt0FPCpPP5W8EdhU
        99iBFJHr8Ro8+JDxUL/fwVInjGEVoJHQANt3e9Fm403lz8XRWpLD5LQdrBZWTloM
        33RCH6+GC5vGOKxhBBGUejGISqz6NZOTxThUDi30BuqVKEfO6H9Bio4r7gL1cEGg
        ==
X-ME-Sender: <xms:lX-jYeiXo43S-G51MaoI63-XKUunV4kQ1_GSKD5ST1cXfgnJ-edsmA>
    <xme:lX-jYfA5-MqVOl9tmRA7LVB-HEJxdY2IoMb-CirpUoCyYhUXz8m-W7xoRYejL6o2F
    ePTdbie0qtkyHM>
X-ME-Received: <xmr:lX-jYWGjXvAY6VTVkpZG4Uxx5mdpy_HSdUD10xPU7qHG64_UQBvAJO8mpV5I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrheeigdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfgkeev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:lX-jYXQiZF_6xjRnQ0v9HEMK-ec9eHVkjGP7r_aze33hQJBtMrvNRA>
    <xmx:lX-jYbynyivPT1bNBsu9gwzaW6H9LcrdP_kWWvcN0EjVjyLrnWCl0Q>
    <xmx:lX-jYV7vMuLAu6oxgE-NL9HHDoCXXO25pEPKM0Nc5ekAaVlYd-2Lug>
    <xmx:ln-jYSkm8WRIRH-ZVDU4KDqQmjo4BKaewSZLEwlP96sdI_GaWcR_KA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 Nov 2021 08:09:40 -0500 (EST)
Date:   Sun, 28 Nov 2021 15:09:38 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCH iproute2] ip route: save: exclude rtnh_flags which can't
 be set
Message-ID: <YaN/khA2eJJLgdte@shredder>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 04:43:10PM +0300, Alexander Mikhalitsyn wrote:
> +	/*
> +	 * Exclude flags which can't be set directly
> +	 * by the userspace from the rtmsg dump.
> +	 */

I believe iproute2 is following netdev style comments [1] so this should
be:

/* Exclude flags which can't be set directly
 * by the userspace from the rtmsg dump.
 */

At least it's consistent with other comments in the file.

[1] https://www.kernel.org/doc/html/v5.12/networking/netdev-FAQ.html#is-the-comment-style-convention-different-for-the-networking-content

> +	r->rtm_flags &= ~RTNH_REJECT_MASK;
> +
>  	ret = write(STDOUT_FILENO, n, n->nlmsg_len);
>  	if ((ret > 0) && (ret != n->nlmsg_len)) {
>  		fprintf(stderr, "Short write while saving nlmsg\n");
> -- 
> 2.31.1
> 
