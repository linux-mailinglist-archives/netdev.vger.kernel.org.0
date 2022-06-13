Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CFB549EA6
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 22:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350571AbiFMUMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 16:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242255AbiFMUMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 16:12:44 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B340E433AE
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 11:47:31 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id g25so7208679ljm.2
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 11:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gnUSbe8CiTQ19HP1QRaMovzHPwVV5AH7oRueQxzbr2w=;
        b=psqvyg4bPOOObXvl93Zxro9XA/ODLoG6iBN8VzURq2kWrUR7F3BHDeeHNMu0CFKyIh
         Niks5hKvSuVELNC275GXW5lNVLONvG604XONrgXtzQCBbODYI+FiNC4UHOy01ziKEw6P
         PnJJ8X8mCYdNE116ke64zsX9sSqEcXHCfXLltO9UXIpqgB60u1m1gOJgKSvqZ2Vu7Rt3
         Fab5Mj4u35jsb3FBf1q2tLM98qhaB60LVo3lH+ODCh+pfDogtGE59OZmPCThjZAo5F3C
         uARnmPJ0E0/9jMWP5IEUMjK7PRjAVPO04tktB/Od36POLALwftkbezadySNHJrj1LtR7
         bRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gnUSbe8CiTQ19HP1QRaMovzHPwVV5AH7oRueQxzbr2w=;
        b=4Yp+zIrTNXPVumigYHggZojMhoK70zUnJ/p0nh9qu6dj3bFyg8q5qaFWFBi2VMfCE2
         TCcrEUiZkSxpTBBLbhx1Wrb0FLaa5r5Tcm44tULm2Gc0SC9W7bwUrUoAtZzqzlktGsU+
         2LiQ65oKBwRcwH4xFu/qJ6l9I+VGVesxDvY7GEUL9tl76X0RSBM0jrFCyr6/YBl0XNes
         G6eQRxCrwcBy5BPzHYZIg9Py37r+YWyMD1FkXWSsfhHI0BCfNit9AIsZjmNf0Q2uB9ji
         68eT0Ewk6GUliHo+4NdTO4b0guejRrp/EP3ISBgV7yEwilz+9OjsKWqkg2367+3BL+/b
         rUYA==
X-Gm-Message-State: AJIora8ykgbuh+BeGrm7/74MjD3iGWELZdabvncCbSyWO+UIh2ABhLfH
        XEuuVT2SkhevH5mhR0pXaVl4Rx4gT72atFIKffa6
X-Google-Smtp-Source: AGRyM1uMA1RswQj/kRbYWxpa2gpbkIqW/H3Lhp9QgKWhkKjVKtC7uz71CWdrVgWOGoL64GzPA+QRw4qUugKbzHueGjo=
X-Received: by 2002:a05:651c:1581:b0:255:48d1:fdae with SMTP id
 h1-20020a05651c158100b0025548d1fdaemr472476ljq.286.1655146049852; Mon, 13 Jun
 2022 11:47:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com> <20220609221702.347522-9-morbo@google.com>
 <YqYTExy0IpVbunBL@equinox>
In-Reply-To: <YqYTExy0IpVbunBL@equinox>
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 13 Jun 2022 11:47:18 -0700
Message-ID: <CAGG=3QVc4STHym0hszpr1SP=RYWag5=J-MB-zhz4JzNZnRnbvg@mail.gmail.com>
Subject: Re: [PATCH 08/12] cdrom: use correct format characters
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     Bill Wendling <isanbard@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-mm@kvack.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 12, 2022 at 9:23 AM Phillip Potter <phil@philpotter.co.uk> wrote:
>
> On Thu, Jun 09, 2022 at 10:16:27PM +0000, Bill Wendling wrote:
> > From: Bill Wendling <isanbard@gmail.com>
> >
> > When compiling with -Wformat, clang emits the following warnings:
> >
> > drivers/cdrom/cdrom.c:3454:48: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
> >         ret = scnprintf(info + *pos, max_size - *pos, header);
> >                                                       ^~~~~~
> >
> > Use a string literal for the format string.
> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/378
> > Signed-off-by: Bill Wendling <isanbard@gmail.com>
> > ---
> >  drivers/cdrom/cdrom.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> > index 416f723a2dbb..52b40120c76e 100644
> > --- a/drivers/cdrom/cdrom.c
> > +++ b/drivers/cdrom/cdrom.c
> > @@ -3451,7 +3451,7 @@ static int cdrom_print_info(const char *header, int val, char *info,
> >       struct cdrom_device_info *cdi;
> >       int ret;
> >
> > -     ret = scnprintf(info + *pos, max_size - *pos, header);
> > +     ret = scnprintf(info + *pos, max_size - *pos, "%s", header);
> >       if (!ret)
> >               return 1;
> >
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
>
> Hi Bill,
>
> Thank you for the patch, much appreciated.
>
> Looking at this though, all callers of cdrom_print_info() provide 'header'
> as a string literal defined within the driver, when making the call.
> Therefore, I'm not convinced this change is necessary for cdrom.c -
> that said, in this particular use case I don't think it would hurt
> either.
>
> I've followed the other responses on parts of this series, so I
> understand that a different solution is potentially in the works.
> Thought I'd respond anyway though out of courtesy.
>
Thanks, Phillip.

I pointed out in a separate response that this specific warning is
disabled by default, but when I ran into while hacking stuff there
weren't a lot of places where the warning popped up (at least for x86
builds) and thought it would be a nice cleanup. I understand if you
don't think this patch is necessary for your code. There are some
places where visual inspection of the code is "good enough" to ensure
that nothing untoward will happen (Greg pointed out a similar thing in
an mm/ file).

Cheers!
-bw
