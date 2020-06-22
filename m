Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B23203F4E
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbgFVSjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730431AbgFVSjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 14:39:15 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1057C06179B
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 11:39:13 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y18so7940517plr.4
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 11:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gb+JetmJfxvfJpxHC8m6WwdUvvjtG/PEO/NrvZ7SUq0=;
        b=g47As6pTItcLFTPBKcE7GoqTMDitRniLcUVZb/sgo6Z6hU1SBXf3XA30MossVWhFm+
         WrZs8HM7KrKN7vIEe4hAi7PM9veaLBUBzmO1d6hg/ZrKjGDYlC+J8mnlzIu7m8jCiDVX
         oUMZ6YXzkXP7P/9ND3v2M3GdghI0Eiq5bwNDzgs5cWvWuZbpdd3bSkITbG7/ShPdrwrX
         oq7EH8OJ65SqfDB5bRXrhOWPzVNj9lb6ggrqKdEFfG/SWqJeDT88TfoVD+co4a3hK8cD
         TZxZzP6pibR5VmEHPFJiQguXyVlIy2oApu1xDzwGn7gtMfXUFW3LNOourTReEdtotVmu
         1u6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gb+JetmJfxvfJpxHC8m6WwdUvvjtG/PEO/NrvZ7SUq0=;
        b=cqLZJTc9v2brwIXIBwBPJ1oibWvN1z8u8ZMExjQf2B3XqVqiX/Wi3TYl6AVlUyhoJW
         zp0I/ip2ZD7YiH3u3hpr44R/BLyAxKrJtzYWlj5Nmo/kx9msPqaizsSTVlcLDg+7e/cQ
         frdwEvmzDLxXra11Men8cYvpb78chb0aKCE9fFMVPK8lBr5g7NgHP0t3TpJWNm6f829w
         H+Y0s+NkOMnSQk8QcY65OsLNWIucRRsdR5kj9r5IWLDiJIvjsvmIypLYutod8pt+fDoS
         /hi2ayWfWN3Rr0bNaQrLrSXovr4CtFNjnsaWVfgRqfNJcJBvKahCIOemxIUcCOKI9Woe
         x9Iw==
X-Gm-Message-State: AOAM533/miyk6sSUoC9ip8s1X9CWdq6e6rSIZZeYY9DwTkxsd5VqlXBQ
        pGrapCFdF2u6vb9g4gDOo5r7riOnV+YVytBOO7mFbg==
X-Google-Smtp-Source: ABdhPJxjYmvT3fQkCRcyhTKfiFZOdTkx+4rML9Oc+LRvsn6ucoVJwJ7PtyGZkVKmwrq2pv/vivr0Qr/enJgVlPaAiao=
X-Received: by 2002:a17:902:fe8b:: with SMTP id x11mr20457257plm.179.1592851152937;
 Mon, 22 Jun 2020 11:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200620033007.1444705-1-keescook@chromium.org> <20200620033007.1444705-12-keescook@chromium.org>
In-Reply-To: <20200620033007.1444705-12-keescook@chromium.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 22 Jun 2020 11:39:01 -0700
Message-ID: <CAKwvOdm7+8xhbMZRPq0+2X1hez=cNGf=psX7ofNUfqq9iY5ScA@mail.gmail.com>
Subject: Re: [PATCH v2 11/16] media: sur40: Remove uninitialized_var() usage
To:     Kees Cook <keescook@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org,
        Network Development <netdev@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 8:30 PM Kees Cook <keescook@chromium.org> wrote:
>
> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings (e.g.
> "unused variable"). If the compiler thinks it is uninitialized, either
> simply initialize the variable or make compiler changes. As a precursor
> to removing[2] this[3] macro[4], just remove this variable since it was
> actually unused:
>
> drivers/input/touchscreen/sur40.c:459:6: warning: variable 'packet_id' set but not used [-Wunused-but-set-variable]
>   459 |  u32 packet_id;
>       |      ^~~~~~~~~
>
> However, in keeping with the documentation desires outlined in commit
> 335abaea7a27 ("Input: sur40 - silence unnecessary noisy debug output"),
> comment out the assignment instead of removing it.
>
> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
>
> Fixes: 335abaea7a27 ("Input: sur40 - silence unnecessary noisy debug output")

Probably should comment out `/* u32 packet_id */` rather than removing
it then, but that doesn't really matter. Either way,
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/input/touchscreen/sur40.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
> index 34d31c7ec8ba..620cdd7d214a 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -456,8 +456,6 @@ static void sur40_poll(struct input_dev *input)
>  {
>         struct sur40_state *sur40 = input_get_drvdata(input);
>         int result, bulk_read, need_blobs, packet_blobs, i;
> -       u32 uninitialized_var(packet_id);
> -
>         struct sur40_header *header = &sur40->bulk_in_buffer->header;
>         struct sur40_blob *inblob = &sur40->bulk_in_buffer->blobs[0];
>
> @@ -491,7 +489,7 @@ static void sur40_poll(struct input_dev *input)
>                 if (need_blobs == -1) {
>                         need_blobs = le16_to_cpu(header->count);
>                         dev_dbg(sur40->dev, "need %d blobs\n", need_blobs);
> -                       packet_id = le32_to_cpu(header->packet_id);
> +                       /* packet_id = le32_to_cpu(header->packet_id); */
>                 }
>
>                 /*
> --
> 2.25.1
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200620033007.1444705-12-keescook%40chromium.org.



-- 
Thanks,
~Nick Desaulniers
