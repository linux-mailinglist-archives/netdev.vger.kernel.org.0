Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992321EDAA6
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 03:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgFDBrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 21:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgFDBrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 21:47:07 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527BDC03E96D;
        Wed,  3 Jun 2020 18:47:07 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b5so4532359iln.5;
        Wed, 03 Jun 2020 18:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=0zAwzlZ1ZoyuyLwQ6ZCqaX3xkKXNzrbPMJM4RJOKE8Y=;
        b=RiWcHHKI56Z9AZJowOntF5u936U9IEK51bruLTnBwtpgY6flTWIj7E32dZiyi3E36V
         F9QFJ/DmaUt+6FtK9nVE7a362kXFNuXajbhWSZBN9kFlVl70OLrAqz2esEBdKBuFivro
         A9qssu5UloM2CAKZ+ub72N81xeKxH3DcJhLjQf6jDWZU5B2Y4dvhVxkrm4K+6NMXuKvM
         4laXIIAPQYAEaPgbIcTRbPHOmlzTu37C//5RJFQLwS95rQtZdmMD2VsAtg/VFDAfrgVs
         Orrn68scYzWQTCkVVNsNrdl4RozvHffrZrf07y1uPq3vyzyrAsZwGdABLmoft0K/4uYw
         UrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=0zAwzlZ1ZoyuyLwQ6ZCqaX3xkKXNzrbPMJM4RJOKE8Y=;
        b=G1T5sGrK162avuRluIej03Ig6u5jcwuzsZE2n1nVoIAXu80bSiRwp0dCLnryGsUSVM
         RUKLNquwqEOjTjRkwtNfwt+pDIQ9CYkt1VmawzCN5inLyLmMDTFgaZr9ST6vdzKvyzJg
         1BRsSuiuRUqtoRx6KtsYIxwvTamupL4C+1cXefYv745fWZBH8K48aFPRJeBxuoRk+bNo
         kvK2vakuoYQT2nXYT6UoG8VPdML0Y2+trJrXwPZ5wI5YILNFahTrgEoAJU3eaVt0mlRf
         8lC9iQWYCN80Dy7gnIiGmIwBOX7OD/6eHMCrZUfSbCi9jgu+Jt4TUbzClIeX5J7qUDaz
         Qbbg==
X-Gm-Message-State: AOAM53338A81KngJlQeCquMXfZeKB2HQHm5cXxuIc6FiYIoOu8FhUcoG
        mrCRbTQ4MNM2xb58POVMU0wWJMauOMQaIQrAk38=
X-Google-Smtp-Source: ABdhPJwmJLrHb81Eed1PmI9X9+VIktXvpC8BtsUPwROhoUZmxaC0zsnS0ewMB1G6ol0WVWmpdiNXo0KKpak7zpoVROg=
X-Received: by 2002:a92:498d:: with SMTP id k13mr2205901ilg.226.1591235226690;
 Wed, 03 Jun 2020 18:47:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200603233203.1695403-1-keescook@chromium.org>
 <CA+icZUVZwjM9o7aNXAkYu8K2BQAajw=60varP4g+NizCqu5gRw@mail.gmail.com> <202006031840.E2F0D15D8B@keescook>
In-Reply-To: <202006031840.E2F0D15D8B@keescook>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 4 Jun 2020 03:46:56 +0200
Message-ID: <CA+icZUUsfZpuwfyEcbBKOf7AJF0-Ao8b1kUscpMJ+-ZdfZotsg@mail.gmail.com>
Subject: Re: [PATCH 00/10] Remove uninitialized_var() macro
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 3:44 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Jun 04, 2020 at 03:23:28AM +0200, Sedat Dilek wrote:
> > what is the base for your patchset?
>
> Hi! This was actually on Linus's latest tree (which is basically -next),
> mostly because I figured this might be a bit of an RFC but if it was
> clean enough, it might actually make the merge window (I can dream).
>
> > I would like to test on top of Linux v5.7.
> >
> > Can you place the series in your Git tree for easy fetching, please?
>
> Sure! https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git in
> the kspp/uninit/v5.7/macro branch. There were three small differences.
> I'm doing the "all my cross compilers allmodconfig" build run now, but
> figured I'd push it for you now so you didn't have to wait.
>

Hi Kees!

Thanks :-).

Regards,
- Sedat -
