Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE732CD6AA
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbgLCNY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:24:56 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:57107 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730533AbgLCNYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:24:55 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3A7215803EB;
        Thu,  3 Dec 2020 08:24:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 03 Dec 2020 08:24:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=TIrQvB3UrbufB/GyXub/EtdF/K7
        1e6rUtngpjAms+UI=; b=ZLIDlDHeAU1tKCcbMe3fBkWwIMdX26uYk8+UPkJ94sd
        KxxedTHTYUr+G6ogpB2nnSgV6Vbi2j5HemALBtFNWlR/n1NQrOGre4P9rUP62FwW
        yBZ9j79D7jR1dGk42sYYYY74x0KN3CitVkwn08gqF9Zc09GoY7cYKa/bI5tfgQLR
        ICEjLxgiY/O0ahT5MV6ogK1Xq1T7EkdSgiPMnggw+lFt7CeBO5A9RphsiZTRl9KS
        HaIF22EVLDtCI0+mZi14FZme8606SpCsGdRASnepRlkvFXOTmYnaarJYxMAPiwu4
        bSl1jaBk0Ajn3tCI03AP8lSsurfhloRXeG3ODhhUrGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TIrQvB
        3UrbufB/GyXub/EtdF/K71e6rUtngpjAms+UI=; b=kj8Vw1pYu5t4qjQqPe8A8Z
        iTxnV0PjwrJ+wrKDn5gK6uhFfZmPaJ6Ox6ttwKzH/iOt3OQsZeP3Ji9yn8vZjr2f
        e/D/dA9fAVhXXSJYe0nFBMP8b6tWM3/Q8wouRJkmrmgba7i/VLo8oTaOTMovxPN9
        mGdvOglQfuVTvqkEy3/alSXZH1TtU/rWmcwndMb/NrCtKqb6zA9rlBEg7ua32x4z
        Z/fH8OMpHHMKr+xnhoeLQf2rlmsQuF4pxrWB/F7aelwlLzcghzK5U7cz7afzQUXW
        NH6EU6CekucaxD6rpZx7CgrU60V4xVpdmAoXheNIgxe1PPMtwBCMOfoJOzyU/ljQ
        ==
X-ME-Sender: <xms:9-bIX2JkrJc_idGOXw7CJ0Efs1Xrw2Glr-GZAlv7mOU_1Qsq6VZZyg>
    <xme:9-bIX7ulMuhkk1uvbX4CL9t_Y3KezJP4t-UP2UozEuT6JsRO43nl1JV7DT-ZWDL3c
    iJbIb5mpfIVUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeiiedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepveeuheejgfffgfeivddukedvkedtleelleeghfeljeeiue
    eggeevueduudekvdetnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtoh
    hm
X-ME-Proxy: <xmx:9-bIX9IAit820Ldv33Vx9Ua7TvUDsr2s0yP72w8tNHoQB3wNZRyfgw>
    <xmx:9-bIX8_Zy08d821_6TB9NYEmrE08EnnPc5yxHln1xQysJJ3H07SDVA>
    <xmx:9-bIX-wWnb7BJW7CkZUOFN2TWGVPRj6MOef8KPlBhelkLEnARbsBWA>
    <xmx:-ebIXz61tF8SSagFmVsGikb66R3ACi6YeXeDoVMjFaRN9ddN1wellQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2B38124005B;
        Thu,  3 Dec 2020 08:24:07 -0500 (EST)
Date:   Thu, 3 Dec 2020 14:25:15 +0100
From:   Greg KH <greg@kroah.com>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        toddpoynor@google.com, sbranden@broadcom.com, rjui@broadcom.com,
        speakup@linux-speakup.org, rcy@google.com, f.fainelli@gmail.com,
        rspringer@google.com, laurent.pinchart@ideasonboard.com,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        mchehab@kernel.org, nsaenzjulienne@suse.de,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 01/11] drivers: staging: speakup: remove unneeded
 MODULE_VERSION() call
Message-ID: <X8jnO5cPUQGEK9cr@kroah.com>
References: <20201203124803.23390-1-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203124803.23390-1-info@metux.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 01:47:53PM +0100, Enrico Weigelt, metux IT consult wrote:
> Remove MODULE_VERSION(), as it doesn't seem to serve any practical
> purpose. For in-tree drivers, the kernel version matters.
> 
> The drivers have received lots of changes, without the module version
> (or the underlying DRV_VERSION macro) ever changed, since the code
> landed in the kernel tree. So, it doesn't seem to have any practical
> meaning anymore.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>
> ---
>  drivers/accessibility/speakup/main.c           | 1 -

<snip>

Yous subject line is odd, these are not "staging" drivers anymore, so
why do you say they are there?

thanks,

greg k-h
