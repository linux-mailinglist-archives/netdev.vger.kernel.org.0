Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B669BDC2
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 14:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfHXMs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 08:48:57 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35652 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbfHXMs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 08:48:57 -0400
Received: by mail-lf1-f68.google.com with SMTP id h27so3160401lfp.2;
        Sat, 24 Aug 2019 05:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KWoEeG6vs6VCUSeGXmHbpQT+ujKELvjfgOGYqoxN0II=;
        b=vFr+uyBDpavs65AlLok3MR+CufBp1mBxwOEujmZshvy2vvsCO8+5X4Jsh5ZvtR3sJy
         LqavRLPmHKiziNsqIDTFOuYJxCD800oXZyqhwjMtS4ORIeq5F9TP83AO1qiePSK1CPjt
         1JUUdm11zfj8/kXKFarfgn14mRZOpmXmDEFUgvx88neKoXyvliFkrw/ZYkviDeykkKfs
         aTgEbKXlrMS2fBVG8WFrJRMa4ClsaeR95IeRpyl6mdJQkbb7bn+GYWOb5wud1DUUkidT
         CiS1V7SjkEmP/3VcLKiOvE0DHDLYyjxxvNexw0M0vrJV4GMcb6UjursF1lGq8WTufIlZ
         0fVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KWoEeG6vs6VCUSeGXmHbpQT+ujKELvjfgOGYqoxN0II=;
        b=iyRQqO8io3WViSA/ceLC2UvOXmc5Et0z9a5rDmSilSlRNW1FPdcRnTTG9bXExq14e+
         vDEk9Xh3FyxF+uHaWkFj8VG4pIgazYneoyHlwoS+fNUTv8aeAxovMKKefcn5rRGtNLmh
         2TNHiF3gMWVxcm9hSLYNPXjUIWCK7l+1UOHp4ZQePPjcR+lPXkou/gsYwzMWZDA8mnNL
         wMqOs5I1ImBORtJyppydbxnVJxb46cqYSuMQuWMoMT3VymchxeU9HUgYoUxFlOiBxBx5
         wrwMWAKi2Ib0CNdy5xtBXB6b9y3i92tjeM5jXNQOwVNy3dwAolPK5B1eiQzqKsLUYQdJ
         vvXw==
X-Gm-Message-State: APjAAAUrScnOqgEcm00geEqqiEcfsEXd3+rFeJPvdkmxKzluT0gYIXa+
        7UIHg8RQJeQaUbQcH3mFdN0soq0yap9EpbOLT7I=
X-Google-Smtp-Source: APXvYqwnCZ2QCveajf6BQHzrths1C2ZlN+b/72OTA3OlX8P3zC8nnVXdt5C9XMQ+b2iPAbpk1uaWSvp2qjQP5rbA5/U=
X-Received: by 2002:ac2:546c:: with SMTP id e12mr5441079lfn.133.1566650934562;
 Sat, 24 Aug 2019 05:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
 <20190812215052.71840-12-ndesaulniers@google.com> <20190813082744.xmzmm4j675rqiz47@willie-the-truck>
 <CANiq72mAfJ23PyWzZAELgbKQDCX2nvY0z+dmOMe14qz=wa6eFg@mail.gmail.com>
 <20190813170829.c3lryb6va3eopxd7@willie-the-truck> <CAKwvOdk4hca8WzWzhcPEvxXnJVLbXGnhBdDZbeL_W_H91Ttjqw@mail.gmail.com>
 <CANiq72mGoGpx7EAVUPcGuhVkLit8sB3bR-k1XBDyeM8HBUaDZw@mail.gmail.com>
 <CANiq72nUyT-q3A9mTrYzPZ+J9Ya7Lns5MyTK7W7-7yXgFWc2xA@mail.gmail.com>
 <CANiq72nfn4zxAO63GEEoUjumC6Jwi5_jdcD_5Xzt1vZRgh52fg@mail.gmail.com> <20190824112542.7guulvdenm35ihs7@willie-the-truck>
In-Reply-To: <20190824112542.7guulvdenm35ihs7@willie-the-truck>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sat, 24 Aug 2019 14:48:43 +0200
Message-ID: <CANiq72mcSniCzMzW6AX_5tG5W2edjEmZ=Rf=jo-Mw3H-9RVJqw@mail.gmail.com>
Subject: Re: [PATCH 12/16] arm64: prefer __section from compiler_attributes.h
To:     Will Deacon <will@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
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

On Sat, Aug 24, 2019 at 1:25 PM Will Deacon <will@kernel.org> wrote:
>
> Which bit are you pinging about? This patch (12/16) has been in -next for a
> while and is queued in the arm64 tree for 5.4. The Oops/boot issue is
> addressed in patch 14 which probably needs to be sent as a separate patch
> (with a commit message) if it's targetting 5.3 and, I assume, routed via
> somebody like akpm.

I was pinging about the bit I was quoting, i.e. whether the Oops in
the cover letter was #14 indeed. Also, since Nick said he wanted to
get this ASAP through compiler-attributes, I assumed he wanted it to
be in 5.3, but I have not seen the independent patch.

Since he seems busy, I will write a better commit message myself and
send it to Linus next week.

Cheers,
Miguel
