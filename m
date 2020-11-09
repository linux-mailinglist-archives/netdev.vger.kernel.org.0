Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DAA2AC8ED
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbgKIW5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbgKIW5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 17:57:36 -0500
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E785BC0613CF;
        Mon,  9 Nov 2020 14:57:35 -0800 (PST)
Received: by mail-ua1-x944.google.com with SMTP id x13so3186564uar.4;
        Mon, 09 Nov 2020 14:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=es9iLiu0OSLSHKxLFLhvMkFrTkEk1Ugq3hgIApTVdA4=;
        b=QSa2KbZUZBeiY6NmYmou9TcUHL2mMhtVRei27UWYHAb46yUOQkKktBWns05VgjjuTF
         stFXNzBZCzP1fuwR4TNNxNwyMUzmwhtt5sltInl1r2bKmDdcypwjZbt8PzRIO8KrDwUl
         ieQvZrehxLl4DUlWtfXWT6e7vG45IlbTywBIhEX8OfjcZ+W90CycrLOFP1YbhebrxoIJ
         UqD8wmuHA4ImO2iW1pPGSyGwSH4KDHyjJTT2jrixizne93gJD9UdERQRX4s21QoFpVw5
         OIB3fkOowBrJKZ4zuhdNdB2qECMStmssc2V67oUoNulHdQu/+2+dRVf6zaS14pEti2Xv
         ArQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=es9iLiu0OSLSHKxLFLhvMkFrTkEk1Ugq3hgIApTVdA4=;
        b=IneoU7ooJRnLZfL4MCQgh2pvByP/M2v5Z+GxBROHqHEsiG6nJvQkUvgSsYeAWZnbv4
         R5u1OrqBeb2pvHlQbcM4n74SBXkrkLkc5hlyyPiGVaAhxbaMhjs7+uqs7ann9jTrkYK7
         wRoyIZlnJ30XsKkrSCykwL369Y1CQjufhdJbgBe6Hs14gF+fqyoo/7eg93SSWhvwmQvB
         28QuY7PV9AbXD1sH3u8poyVHViXd6K4rWoFsw453zC+oFo2aagUwFABMAa1Dpxflv8cq
         T8fo8gWybDi9c+8dLl69xbbxc1vxxIXhlSAymlEUGM5WSzBJ97yHrWG3SVHPrZSO1t8Q
         41ig==
X-Gm-Message-State: AOAM532zEmqtSy6T5GZq0nyOdxJqdzoMxeRq5rJp2sUofuKhaK9mdYEm
        zYXnatngw1NW0r/70S72IDYfzcFA4UqIlIeGkQ8=
X-Google-Smtp-Source: ABdhPJwFa7an96vyH8MvBY/oU8X6kOVJMSjRz4wVsldBAfAM2w8ioAG4UQs/ueWwRE/AHBC+0/JEcwgX4BOTm9P/POI=
X-Received: by 2002:ab0:281a:: with SMTP id w26mr8262195uap.49.1604962655139;
 Mon, 09 Nov 2020 14:57:35 -0800 (PST)
MIME-Version: 1.0
References: <20201109193117.2017-1-TheSven73@gmail.com> <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiUt8MBCugYfjUJMa_h0iekubnOwVwenE7gY50DnRXq5VQ@mail.gmail.com>
 <20201109132421.720a0e13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiXeBRBzDuUScfxnkG2NwO=oPw5dwfxzim1yDf=Lo=LZxA@mail.gmail.com>
 <20201109140428.27b89e0e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiWUJ=bdJVMjzXBOc54H4Ubx5vQmaFnUbAWUjhaZ8nvP3A@mail.gmail.com>
 <20201109142322.782b9495@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiVaQ4u7-2HJ6X92vJ9D4ZuC+GZhGmr2LhSMjCKBYfbZuA@mail.gmail.com>
 <20201109143605.0a60b2ab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiWYKsTURi0pRMxX=SjzPnx-OF0cC43dnaGc+o15kLwk_A@mail.gmail.com> <20201109145049.42e0abe5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109145049.42e0abe5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Mon, 9 Nov 2020 17:57:23 -0500
Message-ID: <CAGngYiX_Wt9po7wE82UROvj6hLpR8PrJH4=gMVuiFQYPqAmmLA@mail.gmail.com>
Subject: Re: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI
 mode flags
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 5:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
>   But please at least repost for net and CC Mark and the SPI list
>   for input.
>
> Maybe Mark has a different idea on how client drivers should behave.
>
> Also please obviously CC the author of the patch who introduced
> the breakage.

I believe they're aware: I tried to propose a patch to fix this in the
spi core, but it looks like it was rejected - with feedback: "fix the
client drivers instead"

https://patchwork.kernel.org/project/spi-devel-general/patch/20201106150706.29089-1-TheSven73@gmail.com/#23747737

I will respin this minimal fix as v2, add Fixes tags and Cc the
people involved, as you suggested.
