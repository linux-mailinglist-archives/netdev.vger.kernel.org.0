Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE701228C2
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 11:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfLQKb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 05:31:58 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:38269 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbfLQKb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 05:31:57 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id CBD7B6C1D;
        Tue, 17 Dec 2019 05:31:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 17 Dec 2019 05:31:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=WVOKI5Xa8ynfxOHUH8uTfezXeuU
        ofMPbouYAeeiBwfo=; b=bmijsgR9pBP2Ebh5XRA1uJIvaotKaT0uunVjVlY8l1C
        aoxODXf2Z/oIfgaiOn3GfxvN12hOlmxSVrt/DaUn2ui5y4YWSoDc09CpwSTSPvtv
        EpCAVbR4ENthlY2tusERvGdA4V9WukWKml4U8LbisXwsFqGk1MgOy+dKLHjxHdSZ
        tyhvxw41ZOLsopmAjnd9nL0d0uAsWaB51tldwy0lqX74f4dbGKrZ/mRVPrNLxV+M
        svbfpDgHzf/aKOcs6RlMmOlKIh1N8lDoWOt+0RBjBAS6nPLpU/KfKRRvelNIHB04
        GM/lHpfosT7/ny01Wzi9gelg9d+2McwmJLd6HiJHazw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WVOKI5
        Xa8ynfxOHUH8uTfezXeuUofMPbouYAeeiBwfo=; b=JQpNJtE7YDoUUklw9zvFjP
        wZ9Ih3qPBkDVD9rCoT5gWFxZZMwAusismfQXbuYWFxuPirAhMF5u+liubo54g2f9
        VSPkmDIF7Z97Skk7gKtoH/EFJbwhbIq5myFJfZ1wZMfnXUVwYdTnTdbRYh7eeVJZ
        gJr09v+76QbaX2xWEI3SPIzQs13zYK+p0ljuNvrE/AQuYI3MW6dLZmiD5Z7rxO48
        XkEdENERvqJHzLTz0PGGUNfi9qhPrrHD1byP+9dNJtTDnPd2NMWkBFlCPwUsYFit
        JZjF92wtLbfZEF63mps1svac1aKgx7nquB1ubhn+c8c1T9KtwpDHE9SUMhQ+u0pA
        ==
X-ME-Sender: <xms:mq74XbTn4Mg9VZkNfMUDm5tvQnvEyJ2uURgkgoUYXKa8WCLK8XbTTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtjedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepgh
    hrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mq74XU4x3XQ7_I5tSP0AKITnKCi65jdaYkOmpNjBtanvDdZYLiOoiQ>
    <xmx:mq74XQUg-13Hasut9Vfn0iVM61swGMfn27ddmuXCObXilt8-pdnw2g>
    <xmx:mq74Xa-et88YfpMZI-Zc-HV_sTQU6ySLnoywFpS3bcb4zJHuXMgkdg>
    <xmx:m674Xe8EJYjeh9FVPEltY81zCiKvaT4ZKJ8GAjBTR6L8hMaNwuJDaQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E5FF8005C;
        Tue, 17 Dec 2019 05:31:54 -0500 (EST)
Date:   Tue, 17 Dec 2019 11:31:52 +0100
From:   Greg KH <greg@kroah.com>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, dmitry.torokhov@gmail.com,
        jacek.anaszewski@gmail.com, pavel@ucw.cz, dmurphy@ti.com,
        arnd@arndb.de, masahiroy@kernel.org, michal.lkml@markovi.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] RFC: platform driver registering via initcall tables
Message-ID: <20191217103152.GB2914497@kroah.com>
References: <20191217102219.29223-1-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217102219.29223-1-info@metux.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 11:22:19AM +0100, Enrico Weigelt, metux IT consult wrote:
> A large portion of platform drivers doesn't need their own init/exit
> functions. At source level, the boilerplate is already replaced by
> module_platform_driver() macro call, which creates this code under
> the hood. But in the binary, the code is still there.
> 
> This patch is an attempt to remove them it, by the same approach
> already used for the init functions: collect pointers to the driver
> structs in special sections, which are then processed by the init
> code which already calls the init function vectors. For each level,
> the structs are processed right after the init funcs, so we guarantee
> the existing order, and explicit inits always come before the automatic
> registering.

No, what is so "special" about platform drivers that they require this?

If anything, we should be moving _AWAY_ from platform drivers and use
real bus drivers instead.

> Downside of apprach: cluttering init code w/ a little bit knowledge
> about driver related stuff (calls to platform_driver_register(), etc).

Exactly, don't.

> For now, only implemented for the built-in case (modules still go the
> old route). The module case is a little bit trickier: either we have to
> extend the module header (and modpost tool) or do some dynamic symbol
> lookup.
> 
> This patch is just a PoC for further discussions, not ready for mainline.
> It also changes a few drivers, just for illustration. In case the general
> approach is accepted, it will be cleaned up and splitted.

Please no, I don't see why this is even needed.

greg k-h
