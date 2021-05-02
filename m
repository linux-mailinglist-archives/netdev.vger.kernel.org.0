Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9759370ACB
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 10:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhEBIj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 04:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhEBIj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 04:39:26 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D282DC06174A;
        Sun,  2 May 2021 01:38:35 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so2418665otf.12;
        Sun, 02 May 2021 01:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7/KTtjV7bJwA8G3GwppRxcxSa6k7CMAcgX+cDACvfCs=;
        b=k32FaUCCahjIPW4a/dG+KH3fEBtYc3zsZXeezvTnLvzvEqrwkzpjnC6xQkHzsZpXzL
         LLaOq9dmzkepvOXAUWI1eLCq+MxwOygNSS/o4YwjMFYIpdSU4ZDYa31Vo4UytZlJv8J7
         GvsKofuAXqM2RvU5BJbbmSy4odKnwEqMnTbsoaVkWQOSotjqQfQ/zWnoH+I7tVHdpcN6
         GSc6AQcxZfITzNWR3Atl5J3d3lAloy8fDN1pEfY9AFUs5emzBNiMJw5S+Adc/5BPiJkl
         PjNxInT2IiucPvN6ip4tmynars0Ltu4T5T7NRvmgZJxyX6qKsU6JIsM2Uc41Kv1qrwj8
         zoAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7/KTtjV7bJwA8G3GwppRxcxSa6k7CMAcgX+cDACvfCs=;
        b=EtuK5H7GvU97tFHqOg7e8KQ87GxrftjCoT2dK2r/ZxmL5nG6FDyiC85hTtLSGdBhKK
         cDkHaCL7oTk2FSckcnH69Ju96zKAI0RpKzGVix/rZN7M/GlJ9FH9zFNtgGph+fPMuEap
         fCnO7a9gV6JtWPVvBhxDkxr/pc3vNC5qfLo/23bE+PiZ4eO9mgxA0OrBftYTYTyqnS4H
         n6lSHMIzHtkYKsthyjEg3ZReLIbsD39jWe+oOMub2gGGmQkYMEvDaZb+38K6oEhBmtHY
         9x+g5pzZdVrLHfuzaz18uVNaFuKwO6HvlikCBSn4Iq3xHvZ078CWFgCgpeLRk0LfTekq
         XnHw==
X-Gm-Message-State: AOAM533Kg3xARzDR+GjS77KFAMCwp0kDM1tAAbvq4ipz+AXbVIVnKsyV
        1JvQYrcCB5csz7MIpOoCKGfQTJQjxIMorKyNkiQ=
X-Google-Smtp-Source: ABdhPJxmZOy0OdB29QArXCoRua4Ymo+mZkvf76wfIWnTK6MqlNz2U8ch3RWGS5fvnvhqq9SrIQwckl4aFfy5MtfsuKY=
X-Received: by 2002:a9d:6f05:: with SMTP id n5mr10337939otq.203.1619944715242;
 Sun, 02 May 2021 01:38:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210430062632.21304-1-heiko.thiery@gmail.com> <0daa2b24-e326-05d2-c219-8a7ade7376e0@gmail.com>
In-Reply-To: <0daa2b24-e326-05d2-c219-8a7ade7376e0@gmail.com>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Sun, 2 May 2021 10:38:24 +0200
Message-ID: <CAEyMn7ZtziLf__KOGWJfY5OUDoaHSN8jopbKJeK9ZSD1NsZDjw@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v2] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Vorel <petr.vorel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Am Sa., 1. Mai 2021 um 17:03 Uhr schrieb David Ahern <dsahern@gmail.com>:
>
> On 4/30/21 12:26 AM, Heiko Thiery wrote:
> > With commit d5e6ee0dac64b64e the usage of functions name_to_handle_at() and
>
> that is a change to ss:
>
> d5e6ee0dac64 ss: introduce cgroup2 cache and helper functions
>
>
> > open_by_handle_at() are introduced. But these function are not available
> > e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
> > availability in the configure script and in case of absence do a direct
> > syscall.
> >
>
> When you find the proper commit add a Fixes line before the Signed-off-by:

What do you mean with finding the right commit? This (d5e6ee0dac64) is
the commit that introduced the usage of the missing functions. Or have
I overlooked something?

>
> Fixes: <id> ("subject line")
> > Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> > ---
>
> make sure you cc the author of the original commit.

Ok.

>
> > v2:
> >  - small correction to subject
> >  - removed IP_CONFIG_HANDLE_AT:=y option since it is not required
> >  - fix indentation in check function
> >  - removed empty lines (thanks to Petr Vorel)
> >  - add #define _GNU_SOURCE in check (thanks to Petr Vorel)
> >  - check only for name_to_handle_at (thanks to Peter Vorel)
>
> you have 3 responses to this commit. Please send an updated patch with
> all the changes and the the above comments addressed.

I will implement the comments and send a new version.

> Thanks,

Thanks,
-- 
Heiko
