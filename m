Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFC1545853
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345996AbiFIXQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241260AbiFIXQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:16:31 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE823C0EBD
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 16:16:29 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id s6so40226081lfo.13
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 16:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+qQsabkwxRvA8bdaAfDmJWrhJnuevA/KFdg/I1GgKtI=;
        b=Ild0j7K/fhaVoC0PM7iI7pWdMAhRoR7/W2DRfNt0y6B95s4E9BAdtVXpgi3bEW9uNf
         AG1lgqOnQ2uv5vAvry2j8xPExVeLJ3BYnAE/tN+xXqHuPln6DSb5D7skU1STvZI/NDhW
         jtR8Pxq27ZSax7URoP+iTQwlBmGjk0LFf4D0uom1Imt1fNNlM84d4KYNh2dTlJaTBsbT
         JVm5nxYhNIVv0OxKdscaj9QMvA2PvsOaMEbHHEGSiRoofkVzd7gclfaU8PJEykQKLQma
         53nit31M3stTWvFisr1YokQQjCrMXni13o6jwb6NDhQT5srtIccNwD3iLK4QBnuEEitd
         6fKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+qQsabkwxRvA8bdaAfDmJWrhJnuevA/KFdg/I1GgKtI=;
        b=AfeK6H60L8aylKiCA5Ye3hdhHk4MZiV/W7rqKjfLfLzyZI6BSHlvwQ8hddoT65YhX+
         lBWUKdoFqQvn4HQ6aj0+isP7ARIgQGc/LzEvhPchCQ3uSuzdUiRGaC1cM2a638k0pH/E
         aanuHEA9aVMIY7oNpsiZ6Ka56//asMARcCWnsspciRt69/myEMUApNHcwXXDsYwhbJuj
         gjlOBuwea0Vb6Nk4kYKT/IZy9nolTbMrSGGedMlyUazmZyTOcQei3nRzjL3z0s0vKeSH
         qn1rm9iyPuFfg7NqNnCH4ymyctXd/cgPoxNtYoh/jcGy+89ux9G5UXaSgEseRyheAn1M
         OXog==
X-Gm-Message-State: AOAM533tpyijmSJCkNbhRWs6Q1mxqd/5sxuxskX8HZvFxsob8ZbKPY4n
        w0Un3iVYUdvmbqjFNIT0wSDSjgKohRumqkyaCKsh
X-Google-Smtp-Source: ABdhPJxylpDJBi9Oyjp7yXKp6FA+T0ynmXHzLKYVD27usilZLqbUqbJzR3v4r67aMe0WXL7WusF4sc80jjd/QAokEMo=
X-Received: by 2002:a05:6512:280a:b0:47a:e70d:63e9 with SMTP id
 cf10-20020a056512280a00b0047ae70d63e9mr5068916lfb.288.1654816587358; Thu, 09
 Jun 2022 16:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com> <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org>
 <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com> <nssn2ps-6n86-nqq6-9039-72847760nnq@vanv.qr>
In-Reply-To: <nssn2ps-6n86-nqq6-9039-72847760nnq@vanv.qr>
From:   Bill Wendling <morbo@google.com>
Date:   Thu, 9 Jun 2022 16:16:16 -0700
Message-ID: <CAGG=3QU0XJhQKJXLMayOkQSiF2yjBi2p2TEZ9KNTzU5mmye-gg@mail.gmail.com>
Subject: Re: [PATCH 00/12] Clang -Wformat warning fixes
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Bill Wendling <isanbard@gmail.com>,
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

On Thu, Jun 9, 2022 at 4:03 PM Jan Engelhardt <jengelh@inai.de> wrote:
> On Friday 2022-06-10 00:49, Bill Wendling wrote:
> >On Thu, Jun 9, 2022 at 3:25 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >> On Thu,  9 Jun 2022 22:16:19 +0000 Bill Wendling <morbo@google.com> wrote:
> >>
> >> > This patch set fixes some clang warnings when -Wformat is enabled.
> >>
> >> tldr:
> >>
> >> -       printk(msg);
> >> +       printk("%s", msg);
> >>
> >> Otherwise these changes are a
> >> useless consumer of runtime resources.
> >
> >Calling a "printf" style function is already insanely expensive.
> >[...]
> >The "printk" and similar functions all have the "__printf" attribute.
> >I don't know of a modification to that attribute which can turn off
> >this type of check.
>
> Perhaps you can split vprintk_store in the middle (after the call to
> vsnprintf), and offer the second half as a function of its own (e.g.
> "puts"). Then the tldr could be
>
> - printk(msg);
> + puts(msg);

That might be a nice compromise. Andrew, what do you think?

-bw
