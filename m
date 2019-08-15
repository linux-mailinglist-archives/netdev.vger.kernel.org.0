Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5968E7CE
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbfHOJIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:08:50 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33666 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730212AbfHOJIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 05:08:50 -0400
Received: by mail-lj1-f196.google.com with SMTP id z17so1669523ljz.0;
        Thu, 15 Aug 2019 02:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0UE6srbxTSzeQEGUqQmtIA5ElC0/7wYx3fPkt29gctA=;
        b=XlyDTQw/LApnV+/jl3INSQ0k5kkAC/D/oC26vZ9uWE9MEg3xW3781+knczAv4Aaf2a
         dDTP8F6TCi/OyI8bPVdVCN57ntl7atgf2pmtMC4foq3XyLYv54jwaSDTyigDmaFJTuLN
         HTYTpKOlcK2VdKCMk8hfpSwDNOy1+V/tesvKx3CEkop4q6eSIwmZjdmvxmfgW0VLzJpo
         VpiFsTYq9biPd7m6Uq3jDpyl2233BEL5+bvbFpJGe+zqxEAugwnqxL34d4WJhoZJQ/2G
         QKS1ERct7SoOBMBQ65iClNzCB5N9LYZ54uUvZj8xrYylAk3KOoTygKBs5tRFQQ6eXQyL
         LmQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0UE6srbxTSzeQEGUqQmtIA5ElC0/7wYx3fPkt29gctA=;
        b=a+voiIiLIwi5NsBzcfZcSslBsoILh0dphdCbQOOf5lK8bBWSYkdpfKPvs6ztlhxx2e
         2Mxr5KeTgPvNCha+zpoECKnaV90VC+pSX5TDA08D/dpaaWJH3VpOjzLgJnA5wwhyVvTs
         TbzIpwJ+3lRb6kSzCZPekrVt34cT1Jcqic3k5ItprtlauVuSuVy57hxDnZ15wYGQpH9j
         kNuSKcgdXEvPw8kYxVHwVfUMvTc1eDzwDZEN6zVsxlKS4H4gzYHHp8MlgZx+UWjDrc+M
         E6kjtfOqhUs1uvd8YQDCngTslf4aJyK5Y/NYKEPxINf/1hKAfvQTwsJQhK2LFhUXVez4
         bP2w==
X-Gm-Message-State: APjAAAUuxxQqzmMhUYuqLaesWinnzDaUr2XuaD8PMc+k2cqAGUZEon9j
        gRsOKlRi8nuiuIWwe+sULCBIjh9cv2nHbVeBoa0=
X-Google-Smtp-Source: APXvYqwMEUAJffcAHkjsEhd8NMusg/7M2UPC/oaiZA76NFZ6YUgtOx0nJ3OvlVQjfSslMzS/Nsbw4g+olqzqauqWEC8=
X-Received: by 2002:a2e:9252:: with SMTP id v18mr1033100ljg.93.1565860127855;
 Thu, 15 Aug 2019 02:08:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
 <20190812215052.71840-12-ndesaulniers@google.com> <20190813082744.xmzmm4j675rqiz47@willie-the-truck>
 <CANiq72mAfJ23PyWzZAELgbKQDCX2nvY0z+dmOMe14qz=wa6eFg@mail.gmail.com>
 <20190813170829.c3lryb6va3eopxd7@willie-the-truck> <CAKwvOdk4hca8WzWzhcPEvxXnJVLbXGnhBdDZbeL_W_H91Ttjqw@mail.gmail.com>
In-Reply-To: <CAKwvOdk4hca8WzWzhcPEvxXnJVLbXGnhBdDZbeL_W_H91Ttjqw@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 15 Aug 2019 11:08:36 +0200
Message-ID: <CANiq72mGoGpx7EAVUPcGuhVkLit8sB3bR-k1XBDyeM8HBUaDZw@mail.gmail.com>
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

On Thu, Aug 15, 2019 at 12:20 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> This lone patch of the series is just cosmetic, but patch 14/16 fixes
> a real boot issue:
> https://github.com/ClangBuiltLinux/linux/issues/619
> Miguel, I'd like to get that one landed ASAP; the rest are just for consistency.

Ah, interesting. It would be best to have sent that one independently
to the others, plus adding a commit message mentioning this in
particular. Let's talk about that in the thread.

> Miguel, how do you want to take the rest of these patches? Will picked
> up the arm64 one, I think the SuperH one got picked up.  There was
> feedback to add more info to individual commits' commit messages.

Yes, I told Will I would pick up whatever is not already picked up by
individual maintainers.

> I kept these tree wide changes separate to improve the likelihood that
> they'd backport to stable cleanly, but could always squash if you'd
> prefer to have 1 patch instead of a series.  Just let me know.

Since you already did the splitting work, let's take advantage of it.
I prefer them to be split anyway, since that gives maintainers a
chance to pick them up individually if they prefer to do so.

Cheers,
Miguel
