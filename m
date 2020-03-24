Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9AE19180F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgCXRrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:47:03 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46625 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727630AbgCXRrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:47:03 -0400
Received: by mail-oi1-f195.google.com with SMTP id q204so11479021oia.13;
        Tue, 24 Mar 2020 10:47:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nFb0+kjYmZJ+cufuAmTc9QqVTkqcdWAu4mmr9TgT2PI=;
        b=dWeTlBW7R/Rq2LncUzlfdNWXtEWKi/rDgUyoDyRSkGfasfzNI2Xxa2UVJL8Su8RfgY
         e5rKWw4oroQKdBP42BI/CVt8qVt0sNcUC+yqu9pCFagtm7AxWenne5GWZin2rrEI2RKG
         /Ocg8xTmsRS4AtX1fX09srQHC6j9v0l9t4wX/OwcrpzOjz/7auUfH2CosKP2iK7RUQw2
         VRC2Fyux34blws4IcIanuXdVX+pg+Vo/yfkXnj3Eq9XF59Bw1ny8PogA6K5vKzZxLVAw
         X76SzAUSjJs1Tkz1XVfuYH/PEEp05U1pML811ik6oThr1s/5EKKvAqm7Hn+T04+OcSde
         SD4w==
X-Gm-Message-State: ANhLgQ1VusJwNCkxR3kSLDbB2v9nVF0/jJ3fQY0dKTppYvMQ2nPm+o4A
        jRDt426d0WVdcoROHJZ1g0w/RTm/ZfXnnmzvDGI=
X-Google-Smtp-Source: ADFU+vtUEnZc4Z6IuNrutvUwO6xPFEb3WzJnzZevlqI8IM7CDUn/S2FUiqebh+YHN+1v4ew7zhc/+OJM8G9W2DZKno4=
X-Received: by 2002:aca:ad93:: with SMTP id w141mr4451051oie.54.1585072022658;
 Tue, 24 Mar 2020 10:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200324161539.7538-1-masahiroy@kernel.org>
In-Reply-To: <20200324161539.7538-1-masahiroy@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 24 Mar 2020 18:46:51 +0100
Message-ID: <CAMuHMdWPNFRhUVGb0J27MZg2CrWWm06N9OQjQsGLMZkNXJktAg@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: wan: wanxl: use $(CC68K) instead of $(AS68K) for
 rebuilding firmware
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild <linux-kbuild@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yamada-san,

On Tue, Mar 24, 2020 at 5:17 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> As far as I understood from the Kconfig help text, this build rule is
> used to rebuild the driver firmware, which runs on the QUICC, m68k-based
> Motorola 68360.
>
> The firmware source, wanxlfw.S, is currently compiled by the combo of
> $(CPP) and $(AS68K). This is not what we usually do for compiling *.S
> files. In fact, this is the only user of $(AS) in the kernel build.
>
> Moreover, $(CPP) is not likely to be a m68k tool because wanxl.c is a
> PCI driver, but CONFIG_M68K does not select CONFIG_HAVE_PCI.
> Instead of combining $(CPP) and (AS) from different tool sets, using
> single $(CC68K) seems simpler, and saner.
>
> After this commit, the firmware rebuild will require cc68k instead of
> as68k. I do not know how many people care about this, though.
>
> I do not have cc68k/ld68k in hand, but I was able to build it by using
> the kernel.org m68k toolchain. [1]

Would this work with a "standard" m68k-linux-gnu-gcc toolchain, like
provided by Debian/Ubuntu, too?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
