Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11457122DFD
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 15:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfLQOGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 09:06:55 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:48123 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726164AbfLQOGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 09:06:54 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id C24962EC6;
        Tue, 17 Dec 2019 09:06:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 17 Dec 2019 09:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=eTfZFWGi2smTIboUi+zb16BN5p3
        65ojxo8UtApRdrno=; b=f9tkSxBnH8B04ocRQbrSrxJ/KUA5blrabluCkfWQWpA
        pMyPAQCTkyNRjEKBm65HGE2E31nkIdUTfnEsNATgqoL6UV6mlQJM6zlZX1XD0Iyf
        RM5JiSyQR0aOCRkQawfMsWTbBPd6sTuk1cjmGx7bsw1g0eAiw9MoGv8ZTrxU2/PN
        Z8MeoJre5CkhSj653Wme+Z5/rTacgCg/fXfDhNXVjCm+g03Cot7tSvS6I5GdoIUw
        IYldt+k8Bdcq74xc4auXBF2kjp5gbL73ug1am5NL+0ZAs/4NZX7TWgbC8wfR+sis
        T6Bgu7dd6EhZmen4w00L8qhfR2riV53ZIp00iDfb0Jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eTfZFW
        Gi2smTIboUi+zb16BN5p365ojxo8UtApRdrno=; b=AQDaSeiWpqvGSbZLeLnuaL
        wMmyVKG1UmbHGV1h0Ro+wZpDzTcfKV99i3YWJQ9o8xdrwgBwNemTYWPe1Tqbkb5l
        psF5yIMs5w5Ag0TQS17IyUV5LizKS9+f+KmR4VUG+Z3VY5lEOORMLfw0G3mMnmHQ
        AgaCFUGWKlmbW7M/VAnhDG/M75UEtkGVm1iLFss9Qk2v3ZV5VcV5e7+JtrTsYFVl
        aQjFFq42tujH5sP6ftZ6uVk6hU3YFVduevKL1kO5hmZJuG3vlktw4EHORNIrRL07
        tQPbu1Mr7M9VB7XyxG2d1UgMPUB4uR6rdlkw/rsf1lEpz3crliFwrx60TcSMWJAA
        ==
X-ME-Sender: <xms:--D4XdLZsdQmxSmgsLkN7cXn2bxx8gRHsYyHMJAfEnkmN8VANyuA0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtjedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepgh
    hrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:--D4XbEYHp2-kPuIG59C4Kl8OOlB_3tVYtLRDu2Ik_uE8uvfJa5XOg>
    <xmx:--D4XQF9seA1xGquH3HeVPyGspu2rwCEX1dFMcsKP5gk59cJI7bifA>
    <xmx:--D4XbtFPyAwX9F_pdIlKhzD8qV00SzbDSuAj4Jyc-fQGNtyALma6Q>
    <xmx:_OD4XW6MGPJBTTOQGOeoamg_JCrFeTZpL8VTexlu-vYMP6J95djZVA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8C92C80065;
        Tue, 17 Dec 2019 09:06:50 -0500 (EST)
Date:   Tue, 17 Dec 2019 15:06:46 +0100
From:   Greg KH <greg@kroah.com>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, dmitry.torokhov@gmail.com,
        jacek.anaszewski@gmail.com, pavel@ucw.cz, dmurphy@ti.com,
        arnd@arndb.de, masahiroy@kernel.org, michal.lkml@markovi.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] RFC: platform driver registering via initcall tables
Message-ID: <20191217140646.GC3489463@kroah.com>
References: <20191217102219.29223-1-info@metux.net>
 <20191217103152.GB2914497@kroah.com>
 <6422bc88-6d0a-7b51-aaa7-640c6961b177@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6422bc88-6d0a-7b51-aaa7-640c6961b177@metux.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 02:44:39PM +0100, Enrico Weigelt, metux IT consult wrote:
> On 17.12.19 11:31, Greg KH wrote:
> 
> Hi,
> 
> > No, what is so "special" about platform drivers that they require this?
> 
> Nothing, of course ;-)
> 
> It's the the starting point for this PoC. The idea actually is doing
> this for all other driver types, too (eg. spi, pci, usb, ...). But
> they'll need their own tables, as different *_register() functions have
> to be called - just haven't implemented that yet.

That's not needed, and you are going to break the implicit ordering we
already have with link order.  You are going to have to figure out what
bus type the driver is, to determine what segment it was in, to figure
out what was loaded before what.

Not good.

> > If anything, we should be moving _AWAY_ from platform drivers and use
> > real bus drivers instead.
> 
> That would be nice, but, unfortunately, we have lots of devices which
> aren't attached to any (probing-capable) bus. That's why we have things
> like oftree, etc.
> 
> > Please no, I don't see why this is even needed.
> 
> The idea is getting rid of all the init code, which all just does the
> same, just calls some *_register() function.

There's no need to get rid of it, what are you trying to save here?  How
can you be sure init order is still the same?

thanks,

greg k-h
