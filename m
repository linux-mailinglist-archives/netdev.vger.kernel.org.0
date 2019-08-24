Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1819B9FC
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 03:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfHXBK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 21:10:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36296 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfHXBK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 21:10:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so10120369wrt.3;
        Fri, 23 Aug 2019 18:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=41qUMOD0eN9ewXy9evPZN0TYC9TGr+U54AtzmQ5x03o=;
        b=pJ1qttiH2/TAejvsSIaJsBfJC3X4ms0F4j8RBNKGcnx72+uqFvCTBkeN5ie4j8McDA
         sSURZK3R3i4+L04F5EL0a9zffYefEs0mukbwHcKkgrpvEFNCC3Df3OWVYuKhgQxXhrp0
         fBT5gy3NSGdZ2UUmBj6DliklL3SPZUtjzo6U1+95QeZsoEYIPMH+beo7Om5+qjGHJt0Q
         Ym2Fu8SZ+8lCwmFW+ACV3nO0tmLcQOvsq0pHt37Iov0myUSBC6NX40fSUGL60YIqbnXJ
         Ld7Q6qjxELcwawgYKLcmbKHmKe2Cg6Oe0GzhIaPOtY8KL1lb5JhzvkslSzPFCvlL7PsB
         uaKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=41qUMOD0eN9ewXy9evPZN0TYC9TGr+U54AtzmQ5x03o=;
        b=cvvccKQOM+8cXqVneBeE35sBAwKeNG1LYp1pyIs7Qlm56gNOGb0akRdbbIaPgmiXFn
         TtSqO4gLWf2mwCwJ9tftduGUVhMTX5tIWin8Ob/KbnUld8BVQCM6J6zdU8ciS2wAq7tk
         TqCiwcviXNIwzlWLk6BqnvAmJ7HbAQ9LdEkvcZZC8I/c2hyAPJeTst1bcsknBrlwUEIP
         omfA03wrsnFPgeMzwyknG/UBLJ9wIbF7ykQT9aNoaklex2w1TYyLLcqIHSI3AdYi4INa
         aUomqaYycfcnAGGlhGA1ATFAi4RehThqJGZfYqnljj7jZSqGT5KBEj0IqUfvwbsnifHz
         rISQ==
X-Gm-Message-State: APjAAAWDrQCbIZzIwsNba3Terj3iyRTpPKLgF0T/cfU1c3SezWmdoW6W
        T/yyIw7bl8g58Ka/Cn0CtMTkoe3Vi54GI4WhCfE=
X-Google-Smtp-Source: APXvYqydp+Vo49g56ZEwK2cZ0glM97zTlW8ryOGhTMmYD6lmAwzRBw5hzZmSPywrxkbYQA/edItRemRP6hCC9Zp+YEY=
X-Received: by 2002:adf:e5cd:: with SMTP id a13mr7785955wrn.316.1566609054327;
 Fri, 23 Aug 2019 18:10:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190822205533.4877-1-david.abdurachmanov@sifive.com>
 <alpine.DEB.2.21.9999.1908231717550.25649@viisi.sifive.com> <CAEn-LTp=ss0Dfv6J00=rCAy+N78U2AmhqJNjfqjr2FDpPYjxEQ@mail.gmail.com>
In-Reply-To: <CAEn-LTp=ss0Dfv6J00=rCAy+N78U2AmhqJNjfqjr2FDpPYjxEQ@mail.gmail.com>
From:   David Abdurachmanov <david.abdurachmanov@gmail.com>
Date:   Fri, 23 Aug 2019 18:10:17 -0700
Message-ID: <CAEn-LToT7YPwoBWO919Q0nkd9mj_Bup6n14q3LmXJYK1M1UXhg@mail.gmail.com>
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Tycho Andersen <tycho@tycho.ws>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Vincent Chen <vincentc@andestech.com>,
        Alan Kao <alankao@andestech.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, me@carlosedp.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 6:04 PM David Abdurachmanov
<david.abdurachmanov@gmail.com> wrote:
>
> On Fri, Aug 23, 2019 at 5:30 PM Paul Walmsley <paul.walmsley@sifive.com> wrote:
> >
> > On Thu, 22 Aug 2019, David Abdurachmanov wrote:
> >
> > > There is one failing kernel selftest: global.user_notification_signal
> >
> > Is this the only failing test?  Or are the rest of the selftests skipped
> > when this test fails, and no further tests are run, as seems to be shown
> > here:
> >
> >   https://lore.kernel.org/linux-riscv/CADnnUqcmDMRe1f+3jG8SPR6jRrnBsY8VVD70VbKEm0NqYeoicA@mail.gmail.com/
>
> Yes, it's a single test failing. After removing global.user_notification_signal
> test everything else pass and you get the results printed.
>
> >
> > For example, looking at the source, I'd naively expect to see the
> > user_notification_closed_listener test result -- which follows right
> > after the failing test in the selftest source.  But there aren't any
> > results?
>
> Yes, it hangs at this point. You have to manually terminate it.
>
> >
> > Also - could you follow up with the author of this failing test to see if
> > we can get some more clarity about what might be going wrong here?  It
> > appears that the failing test was added in commit 6a21cc50f0c7f ("seccomp:
> > add a return code to trap to userspace") by Tycho Andersen
> > <tycho@tycho.ws>.
>
> Well the code states ".. and hope that it doesn't break when there
> is actually a signal :)". Maybe we are just unlucky. I don't have results
> from other architectures to compare.
>
> I found that Linaro is running selftests, but SECCOMP is disabled
> and thus it's failing. Is there another CI which tracks selftests?
>
> https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/seccomp_seccomp_bpf?top=next-20190823

Actually it seems that seccomp is enabled in kernel, but not in
systemd, and somehow seccomp_bpf is missing on all arches thus
causing automatic failure.

> >
> >
> > - Paul
