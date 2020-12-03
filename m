Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202342CDF3C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgLCT55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 14:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgLCT54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 14:57:56 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6809FC061A4E
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 11:57:16 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id t6so4481863lfl.13
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 11:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OX2SMwG51HvUvi+B+PocF0hk7d7exgcj6lP8+rKrjjs=;
        b=FFyRD27Mubz6B1RzFoK/vfuBNBlicnF5AqVaBzfkspFWarDQXm1G48GRCwRJ5WnVFV
         ceCpLDkx5GiSh/lBWd0aN71pqGdEd7ruda+cx2S/bbW0fAoDoycU7rYrYMDw5Vk5NUA4
         NoxUJal2d/tWgsWLVeLqj1vvs0QHd2cAQvDmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OX2SMwG51HvUvi+B+PocF0hk7d7exgcj6lP8+rKrjjs=;
        b=tLYugEin+AdFesokrxmhSlaGGLoZgVQyDx4Qt6Tc6X2D6MWed61V9AXZq3brN1pe8Y
         Qe38fw64bcI+267E/SQ8tlrBP0M/Yzsl8/j01mc5x4SthwAMH28JouqFIF7G9cWLGYX5
         Z2K+0zloiqi93Qt9RlPYP9EfQNyVNTvQUtFk8dz7Rtt11Uggx8T28EkpomPb91cBe9tZ
         Pc3pR/THEXBIkJnppaeobjVr2kVoGSBGqGkYLkeHo+oPk/zlqKa7TOOky7wSKHvobPVk
         8YZrxGC/maU9S6UEiP3060TKUgHS8b59dr8uv6WqHU0i+BLpowvNf4ykia2dtPW9jXPj
         tBPA==
X-Gm-Message-State: AOAM533AxvGQWrBvsRVqwch+ysEFOUIZZHeYy54UdHgd/eBB0ST6dIv9
        DYGtRc3tUdpE/s8oYj/Itb81EbOUX5GPyA==
X-Google-Smtp-Source: ABdhPJxwiRc0OQL8q43b09U7YgGLEQS4iLw/kX8jrtMFkasU2ZzrNi0k35+sIqaHNGlOxPRaibdfdA==
X-Received: by 2002:a05:6512:338f:: with SMTP id h15mr1973465lfg.40.1607025434562;
        Thu, 03 Dec 2020 11:57:14 -0800 (PST)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id v1sm849669lfq.210.2020.12.03.11.57.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 11:57:13 -0800 (PST)
Received: by mail-lj1-f173.google.com with SMTP id z1so3923992ljn.4
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 11:57:13 -0800 (PST)
X-Received: by 2002:a05:651c:339:: with SMTP id b25mr1977070ljp.285.1607025433176;
 Thu, 03 Dec 2020 11:57:13 -0800 (PST)
MIME-Version: 1.0
References: <20201203103315.GA3298@nautica>
In-Reply-To: <20201203103315.GA3298@nautica>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 3 Dec 2020 11:56:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wigRSokT5YLRGH5Jyun1CwgYHR_1RMcoHjUyz7NJ8wG_g@mail.gmail.com>
Message-ID: <CAHk-=wigRSokT5YLRGH5Jyun1CwgYHR_1RMcoHjUyz7NJ8wG_g@mail.gmail.com>
Subject: Re: [GIT PULL] 9p update for 5.10-rc7 (restore splice ops)
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 2:33 AM Dominique Martinet
<asmadeus@codewreck.org> wrote:
>
>
> Hi Linus,
>
> Someone just reported splice got disabled in 5.10-rc1, here's a couple
> of patches to turn it back on using generic helpers.

Pulled.

> (Thanks for letting me know my mails got flagged as spam last time, I've
> taken the time to setup dkim/dmarc which brings its share of problems
> with some mailing lists but hopefully will help here)

It looks good here, but I would suggest you edit your DKIM configuration a bit.

In particular, you have "List-ID" in your set of header files that
DKIM hashes, and that means that any mailing list that then adds that
header will destroy your DKIM hash.

So you seem to make it almost intentionally hard for your DKIM to be
valid when you send emails to a list.

I'd suggest you keep the DKIM hash to just the basic fields that your
MUA will fill in, ie things like

  Date:From:To:Cc:Subject:References:In-Reply-To:Message-ID

because if somebody messes with *those*, then I think they are doing
something wrong - in ways that adding a "List-ID" as it goes through a
mailing list is not.

(But I'm not a DKIM expert, just a spam hater).

              Linus
