Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4D954587A
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346169AbiFIXS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346129AbiFIXSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:18:55 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1FC2228D2
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 16:18:45 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id m25so24486613lji.11
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 16:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=af6354Q+PYtjAeTE1fHxbOWk4spb0xe2rddSt4jQNw0=;
        b=qsw/gp8RDQr7TxcFAw67QADvplw4M8CuLpbXwYePEvTc9gyloRoNkLA0/65LPS2PHG
         lwvUx0Vk5tnQau+/eN+yj4vNNvEwrbFYrLKwsm69bjXQ0R4nOllOmIVjbhrvEDyLI/wP
         oUAGxwYePVYRcuzvMPpwS/H20SN6RBqtDq3M/sIFmsPVSQfFBqjqsQ4YrUJFt60H+vrG
         /vbIkayBKj2NafmzkfPK5WFIV3Pwo6mzHcJ+8+5Fy+N2x3QXFf68sSVrj/uvcZRdIojW
         qhr4netPBQEp3dEnvthXme6ipHwfVm1f0OwUWXWzeGYvw+rVPOiGjeTn1JUKCz0o06hy
         xlcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=af6354Q+PYtjAeTE1fHxbOWk4spb0xe2rddSt4jQNw0=;
        b=c9p2m+OMp0Wmc0l/emdw1NLyqh9RPH+1zqw0hZc2ZJXW5AqAU9RfJ1Wmz1Zjqo8fFR
         C4PGRVafX9Ih3vW9AJPMsT/eTG/GVQszZdyzlDRJXkVO80GOmXAstwSBk3hgIJOVQB64
         cTjkpy93q3P69cemzD0BVHh6LDnVTfZECT/3pYSMIkQjNL/fPMhxCCR1OcM3bhd3eqSv
         eLEA3whHEUgIZTMhqhpfkxffRZVXd+GDkwtuRI8xznRQGTXT9UJCzOvpV0YsJQw5LhnP
         Ym5sTL+5RvTBeqO+SIr7EN2MWiYnor8GvbmwggsjDA3PkdTLvfpva/dbfj2WR9IUBrYK
         u6dw==
X-Gm-Message-State: AOAM5336++x8oDLg6+kIflsAnJ9EuU0KZAonUOzdtkIrImBFN9pNw5/v
        aKq2M2OHE751qfEsCWPjyqEuvGaP6Amj6MAxpnGO
X-Google-Smtp-Source: ABdhPJzslpbBTkBZ3coZd7t5JavMPBitkHrctHqYQ1MeTY4oO+M4rEae62HvWxHeD6/VvLbJ6ql3Pgg1eI26i3ys1SY=
X-Received: by 2002:a2e:bc0e:0:b0:255:9fa0:ed4 with SMTP id
 b14-20020a2ebc0e000000b002559fa00ed4mr10953078ljf.390.1654816723853; Thu, 09
 Jun 2022 16:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com> <20220609221702.347522-2-morbo@google.com>
 <3a773edf-f850-e83d-828d-19f91a373384@infradead.org>
In-Reply-To: <3a773edf-f850-e83d-828d-19f91a373384@infradead.org>
From:   Bill Wendling <morbo@google.com>
Date:   Thu, 9 Jun 2022 16:18:31 -0700
Message-ID: <CAGG=3QVkvvc+25zvrfigo5Ohx85+1FCka_VMC4pm0dWUFMOqkA@mail.gmail.com>
Subject: Re: [PATCH 01/12] x86/mce: use correct format characters
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Bill Wendling <isanbard@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
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
        Daniel Kiper <daniel.kiper@oracle.com>,
        Ross Philipson <ross.philipson@oracle.com>,
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

On Thu, Jun 9, 2022 at 4:15 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> On 6/9/22 15:16, Bill Wendling wrote:
> > From: Bill Wendling <isanbard@gmail.com>
> >
> > When compiling with -Wformat, clang emits the following warnings:
> >
> > arch/x86/kernel/cpu/mce/core.c:295:9: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
> >                 panic(msg);
> >                       ^~~
> >
> > Use a string literal for the format string.
> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/378
> > Signed-off-by: Bill Wendling <isanbard@gmail.com>
> > ---
> >  arch/x86/kernel/cpu/mce/core.c | 2 +-
> >  scripts/Makefile.extrawarn     | 4 ++--
>
> Where is the scripts/ change?
>
I'm sorry about this. The change in that file was a mistake that I
reverted, but I forgot to change this part.

-bw

> >  2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
> > index 2c8ec5c71712..3d411b7c85ad 100644
> > --- a/arch/x86/kernel/cpu/mce/core.c
> > +++ b/arch/x86/kernel/cpu/mce/core.c
> > @@ -292,7 +292,7 @@ static noinstr void mce_panic(const char *msg, struct mce *final, char *exp)
> >       if (!fake_panic) {
> >               if (panic_timeout == 0)
> >                       panic_timeout = mca_cfg.panic_timeout;
> > -             panic(msg);
> > +             panic("%s", msg);
> >       } else
> >               pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
> >
>
> --
> ~Randy
