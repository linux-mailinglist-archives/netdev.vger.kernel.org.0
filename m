Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C99D8B8A6
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbfHMMgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:36:20 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42688 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfHMMgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:36:19 -0400
Received: by mail-lj1-f193.google.com with SMTP id 15so9619515ljr.9;
        Tue, 13 Aug 2019 05:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/4zbvSpEn2DpmCJ6tMtDBdGBohm95LMSJu2Rb3mH21k=;
        b=lrApJRtm6GOhWs3fCFPJSlcSNogP0GznPdE24vcG3Z/F5ysBIyHK4jr3TmLyVAenyu
         h+reeHqoCtu5DnUOonZfy2rp0wqpy0QvIWd1egLjw9T+fHOo9bX4D5YJplkiBANlzg+Z
         YxoJvdWuGbwSks5nTFsOOCwSZvZqkTUwflPOvOlwIZSX4gGr1CPhFztABch0yEq1LGEz
         niMncc0gUHJSPmGlCnp7eYd+vKKI1m13mmcPqKSQd33YlT2b2H8DFXOYUkcC6lFgsZvv
         RCcC5ce0ZlXrJuUsDAAaXHftEs3Uc66lwJtN2oFXfWLTEOEySRPJVNo9EtMHQqBQljfF
         I95w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/4zbvSpEn2DpmCJ6tMtDBdGBohm95LMSJu2Rb3mH21k=;
        b=ombUIQlKZI4sna0UtPXjiTZdDEAjW09UgskoowRxZu6uQxgnjy0Or9pBdvwUOHwk5C
         I1qGrcmx4z/wr1bRHgnJBdXj8C2u7dBkgnBOme5FKqsMI1U/Gb8cz9fdqOBCQWazB0s7
         Oir1/T7cJwCnIKCzYWuFZcDB6IQJ8bfPzPnkYge9zt4x9qXNfnVTLVhETB9dNNmS+Qm1
         i8HReInxcLZ1xzp6o2kbMv77R+bdZ1I9GDYs/4jxQ8LvH4gqun31BF1XL1+Y6saZHoKv
         NVgCQuz0CRtId328AIkm/KT2+YFbYp0ZM24JRz2DMqGYCHKaiWPqRX2Caz6ccQAdWINH
         7Nlw==
X-Gm-Message-State: APjAAAUw0jGg8zSE+jLTDdABOj1U86GKjU0iDWivaBZyygEJFY4oI3cz
        TDMhrET9Ik98e8WBwRYofDL+83XFhwRl+lqkZPI=
X-Google-Smtp-Source: APXvYqw9QQj9Ti8WKyo8gjlKSpGsqLRG2B9QmRI3Fs3vQL04NHHaPG06xFKmK+ZntPzsDk7jUfioPFAqkeTU3Op2eJs=
X-Received: by 2002:a2e:3a13:: with SMTP id h19mr21421766lja.220.1565699777265;
 Tue, 13 Aug 2019 05:36:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
 <20190812215052.71840-12-ndesaulniers@google.com> <20190813082744.xmzmm4j675rqiz47@willie-the-truck>
In-Reply-To: <20190813082744.xmzmm4j675rqiz47@willie-the-truck>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Tue, 13 Aug 2019 14:36:06 +0200
Message-ID: <CANiq72mAfJ23PyWzZAELgbKQDCX2nvY0z+dmOMe14qz=wa6eFg@mail.gmail.com>
Subject: Re: [PATCH 12/16] arm64: prefer __section from compiler_attributes.h
To:     Will Deacon <will@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, yhs@fb.com,
        clang-built-linux@googlegroups.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Enrico Weigelt <info@metux.net>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 10:27 AM Will Deacon <will@kernel.org> wrote:
>
> Hi Nick,
>
> On Mon, Aug 12, 2019 at 02:50:45PM -0700, Nick Desaulniers wrote:
> > GCC unescapes escaped string section names while Clang does not. Because
> > __section uses the `#` stringification operator for the section name, it
> > doesn't need to be escaped.
> >
> > This antipattern was found with:
> > $ grep -e __section\(\" -e __section__\(\" -r
> >
> > Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > ---
> >  arch/arm64/include/asm/cache.h     | 2 +-
> >  arch/arm64/kernel/smp_spin_table.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
>
> Does this fix a build issue, or is it just cosmetic or do we end up with
> duplicate sections or something else?

This should be cosmetic -- basically we are trying to move all users
of current available __attribute__s in compiler_attributes.h to the
__attr forms. I am also adding (slowly) new attributes that are
already used but we don't have them yet in __attr form.

> Happy to route it via arm64, just having trouble working out whether it's
> 5.3 material!

As you prefer! Those that are not taken by a maintainer I will pick up
and send via compiler-attributes.

I would go for 5.4, since there is no particular rush anyway.

Cheers,
Miguel
