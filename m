Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A52154592F
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 02:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239817AbiFJAdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 20:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239324AbiFJAdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 20:33:03 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CC336E11
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 17:33:00 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 20so947325lfz.8
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 17:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M1G6Hf9v6f6xyLP2a6Gh7yfuFJ+6ipgBJHHWwU80v1c=;
        b=GzLaviOqRCp4B7LqsBfA2qFyX6V1uMUAbIpS5ZG+ymr/9aN/hsQn1QW3PtN+GmgInQ
         He0Q1Uquu8aHzwNdzglLiDyax/ofVj35MhNvH0zBU7U/FgsC8lV4WZcV1MRSavA6givw
         MwwoH6cUS805gA1B/kna/OiRrljxuadDNbWQe2uk3jqSGIPZTj1Nggn2aFmaJOxpn0ee
         keyXmIa2x54GZzES+MYP7V0JK7Y0RzKUk9jyYpIawwn1bBhBPn8bT+rMBalAXRhKRGqN
         ws66+mukc8/rRLkWY5c5tACdnnEguXj7+LFVYthISMqK0wDGsAxLLnOu3EGgFefxrZxd
         +Qcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M1G6Hf9v6f6xyLP2a6Gh7yfuFJ+6ipgBJHHWwU80v1c=;
        b=00gsWllcUe5n6RTml7ygVBHQUcqO0By+rvYM2NTKEKMKBTckm3T6VztBM7B2dzwPo6
         PkHnbRr9K13u4/OHyh9r+DiLSN4pYwxI2HmCpIcMcV1lpQk3scw6EjEU82ACtmUOkJbD
         cWcB18Q4p6lsbqzLKvck8OyNYY6yXz8fAHspKuIIajpz3rio9/y9jxbMYPAz3rwraqN/
         5+1iwPxVp0kg0L8eyMKVKgiqMBRchZYV0fYpOHrSlc8zSA6D67U4PZWL2V2QvW98xCX0
         MbCpC9hWuKdiR33p/PSqu+MrwQswALi9PMUyqNhhvIiuHS1Uh5Jt7YZG1xvh0cagsSrg
         MJSA==
X-Gm-Message-State: AOAM530zwzXHjTVfrGARgVxil6QR/rAMoS567zwzQS45r8mqP1g/j26v
        lw9bFkD4W0Y8UjV8CxUFUdgXQy3bJ/tkh3A3TwxspQ==
X-Google-Smtp-Source: ABdhPJwmAai5PXOj7tGhLdM9ZQqNV5Wv1qkbCkukxf252/r1aHu4spL4q3u9asT4a5t/dEsKFtmgLChgmJAimWPi9do=
X-Received: by 2002:a05:6512:ad6:b0:479:5599:d834 with SMTP id
 n22-20020a0565120ad600b004795599d834mr11951775lfu.103.1654821178297; Thu, 09
 Jun 2022 17:32:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com> <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org>
In-Reply-To: <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 9 Jun 2022 17:32:46 -0700
Message-ID: <CAKwvOdmfC3kgGuimbtG8n74f8qJ5+vd3GeHg14oOxkKOfuQfBg@mail.gmail.com>
Subject: Re: [PATCH 00/12] Clang -Wformat warning fixes
To:     Andrew Morton <akpm@linux-foundation.org>,
        Bill Wendling <morbo@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
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
        Tom Rix <trix@redhat.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        clang-built-linux <llvm@lists.linux.dev>,
        Justin Stitt <jstitt007@gmail.com>,
        Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_TVD_FUZZY_SECURITIES,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 3:25 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu,  9 Jun 2022 22:16:19 +0000 Bill Wendling <morbo@google.com> wrote:
>
> > This patch set fixes some clang warnings when -Wformat is enabled.

It looks like this series fixes -Wformat-security, which while being a
member of the -Wformat group, is intentionally disabled in the kernel
and somewhat orthogonal to enabling -Wformat with Clang.

-Wformat is a group flag (like -Wall) that enables multiple other
flags implicitly.  Reading through
clang/include/clang/Basic/DiagnosticGroups.td in clang's sources, it
looks like:

1. -Wformat is a group flag.
2. -Wformat-security is a member of the -Wformat group; enabling
-Wformat will enable -Wformat-security.
3. -Wformat itself is a member of -Wmost (never heard of -Wmost, but
w/e). So -Wmost will enable -Wformat will enable -Wformat-security.
4. -Wmost is itself a member of -Wall. -Wall enables -Wmost enables
-Wformat enables -Wformat security.

Looking now at Kbuild:
1. Makefile:523 adds -Wall to KBUILD_CFLAGS.
2. The same assignment expression but on line 526 immediately disables
-Wformat-security via -Wno-format-security.
3. scripts/Makefile.extrawarn disables -Wformat via -Wno-format only
for clang (via guard of CONFIG_CC_IS_CLANG).

We _want_ -Wformat enabled for clang so that developers aren't sending
patches that trigger -Wformat with GCC (if they didn't happen to test
their code with both).  It's disabled for clang until we can build the
kernel cleanly with it enabled, which we'd like to do.

I don't think that we need to enable -Wformat-security to build with
-Wformat for clang.

I suspect based on Randy's comment on patch 1/12 that perhaps -Wformat
was _added_ to KBUILD_CFLAGS in scripts/Makefile.extrawarn rather than
-Wno-format being _removed_.  The former would re-enable
-Wformat-security due to the grouping logic described above.  The
latter is probably closer to our ultimate goal of enabling -Wformat
coverage for clang (or rather not disabling the coverage via
-Wno-format; a double negative).

I'm pretty sure the kernel doesn't support %n in format strings...see
the comment above vsnprintf in lib/vsprintf.c.  Are there other
attacks other than %n that -Wformat-security guards against? Maybe
there's some context on the commit that added -Wno-format-security to
the kernel?  Regardless, I don't think enabling -Wformat-security is a
blocker for enabling -Wformat (or...disabling -Wno-format...two sides
of the same coin) for clang.

> >
>
> tldr:
>
> -       printk(msg);
> +       printk("%s", msg);
>
> the only reason to make this change is where `msg' could contain a `%'.
> Generally, it came from userspace.  Otherwise these changes are a
> useless consumer of runtime resources.
>
> I think it would be better to quieten clang in some fashion.



-- 
Thanks,
~Nick Desaulniers
