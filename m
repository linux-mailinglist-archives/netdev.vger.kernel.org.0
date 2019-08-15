Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652338E7DD
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbfHOJM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:12:28 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39290 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731003AbfHOJM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 05:12:28 -0400
Received: by mail-lj1-f193.google.com with SMTP id x4so1645470ljj.6;
        Thu, 15 Aug 2019 02:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/iZpzZ2apqtPNAYN3rBQkZr4GG5AMuxH/SW/Plc3ffA=;
        b=QElReFqQP1GK1jybq9AdaL5hGB8HmAAs0wfsjh6CmTuxeo6TEfpfCDoP/+HHCVw2A1
         3i3+mnn+llz0xTIikJA14Xpr1gVhFAfaTwJmRt5SqcsiF1KeM0jPzS5lvDKb8OMOh+GY
         i1vgJaEZIKCh8lSCkUui0aAgkjIg4L206m/sGzk9t6O6QQvrLU8yWFknvH19qAjVW4Fd
         nF9QzblURTEbZ/R1/afeTL+rln+KXYM3Ne/zhEr90OEO3jzL4Ikq8WJTHukdGQn/wyhN
         adWSLc2bj5U6uGjvYIJzNFyX46OWUcpQmn4mMK+8HUZ346uWMznEAPX5nqG0MRJz032l
         rD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/iZpzZ2apqtPNAYN3rBQkZr4GG5AMuxH/SW/Plc3ffA=;
        b=Kd+whwjLkcwJZCSnANBkFC9w2J9s2rLouK+R2KdlSsJyQWXOJYasCYcBLdY5chUqA2
         TYvuxjfF+DlWnml03GpjlKmcqSjmalkREne4+n1CydD8g4HcMNsCfu7+EFDl/EJHzXOZ
         w/8GGri/fuVHlgQual3reAt6R031QguJDc8HPyoe8EpjZmc3MZOv10fCgm6cuEP71dSI
         jVMxH7Q4/P2NEJ10LAlTzMeRnlfOb6PyJKRlZbGAaFiIL94LVi2h+BH5WxB1U4hrS9cW
         FvO9ZdtEdT5IDsgvohb5jJyZas5lK3p3dFVthl+BgUUKDMIPOvfHvsLCe74DbAL36aI2
         dU6w==
X-Gm-Message-State: APjAAAWFjkRMngKj5LhO5LcIymFkJsGTLhD7gavEylZdg8bb8wCrwKkE
        awYANU2xpYdBMNerIM4r5MX9fhklScco9SsRk/U=
X-Google-Smtp-Source: APXvYqyGUoGw9duO+xloOL4EihgDXFOKCU7bXBE4DDDHi6q2U92avBXabuArt3Vzj00ddjUnjW901Y7mAjAa9KYeXcg=
X-Received: by 2002:a05:651c:ca:: with SMTP id 10mr2132619ljr.144.1565860346166;
 Thu, 15 Aug 2019 02:12:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
 <20190812215052.71840-12-ndesaulniers@google.com> <20190813082744.xmzmm4j675rqiz47@willie-the-truck>
 <CANiq72mAfJ23PyWzZAELgbKQDCX2nvY0z+dmOMe14qz=wa6eFg@mail.gmail.com>
 <20190813170829.c3lryb6va3eopxd7@willie-the-truck> <CAKwvOdk4hca8WzWzhcPEvxXnJVLbXGnhBdDZbeL_W_H91Ttjqw@mail.gmail.com>
 <CANiq72mGoGpx7EAVUPcGuhVkLit8sB3bR-k1XBDyeM8HBUaDZw@mail.gmail.com>
In-Reply-To: <CANiq72mGoGpx7EAVUPcGuhVkLit8sB3bR-k1XBDyeM8HBUaDZw@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 15 Aug 2019 11:12:15 +0200
Message-ID: <CANiq72nUyT-q3A9mTrYzPZ+J9Ya7Lns5MyTK7W7-7yXgFWc2xA@mail.gmail.com>
Subject: Re: [PATCH 12/16] arm64: prefer __section from compiler_attributes.h
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Yonghong Song <yhs@fb.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
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

On Thu, Aug 15, 2019 at 11:08 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Thu, Aug 15, 2019 at 12:20 AM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > This lone patch of the series is just cosmetic, but patch 14/16 fixes
> > a real boot issue:
> > https://github.com/ClangBuiltLinux/linux/issues/619
> > Miguel, I'd like to get that one landed ASAP; the rest are just for consistency.
>
> Ah, interesting. It would be best to have sent that one independently
> to the others, plus adding a commit message mentioning this in
> particular. Let's talk about that in the thread.

Btw, I guess that is the Oops you were mentioning in the cover letter?

Cheers,
Miguel
