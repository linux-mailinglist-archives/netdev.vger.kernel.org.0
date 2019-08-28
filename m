Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1C5A0C86
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfH1Vki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:40:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52191 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfH1Vki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:40:38 -0400
Received: by mail-wm1-f68.google.com with SMTP id k1so1564156wmi.1;
        Wed, 28 Aug 2019 14:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fl6SJhDThIzLVktnxnUQoR6p6jMmSRZeGxNzVfHmfGc=;
        b=hP0eYnVngg0lq1hP3JK2h2x4x8ZP/LkgNSObaO5dsLMMR2EJ6hZWoQU0HSs2LYhSsb
         jZvfF3tenLWEI+TfyOXld/nC78gwghtTXq74BisZRBq370GK9BohnQcL+QB/VOVBzyRN
         sHUYswv7Krf01vNRoTte5Qv63es97SoJOsPRRwu8NnmyqYX+eL8ro9JYWEOuONfzdNxp
         QKIKfpzf935Zo9T1KzQ35aqV+s9JSs1l9PnjjYCoAWY3soLZBXfPod0i/RQpPZVAIXjn
         8cFh1mpvHFd7YJpzBB7JyY2kJ8UTY+oxj5b63/JZLCRI08fYwRk3aBygjrSbuM3d0PUe
         pxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fl6SJhDThIzLVktnxnUQoR6p6jMmSRZeGxNzVfHmfGc=;
        b=YNXpt4eB6VwcugyOGFb7TBGkTRpMiV6Eij6/QBPawPfbSMWm8Ylf/iHoqbjsQHtLx+
         s6Pm6xdzw1HsLzPt+e7Y8aAOMB/B/oI2utPUEMe5b7U2gaX+wCXlOZMVM8Ap6oc7MQ5/
         FyN9KzlU3cohWgH35gxL9Wu7JMi03DoloQSJDUXwFhbtbLFSRGxqbKXudmnnV2EAgBbC
         +DSH4aSY2wjSxQgjn/E/U/os5UvykxxlWWQ8EYywMHRJNxf4tGK+WFylb2W8Ycvl6i32
         t9XlAH0Wk89AesBjHtjcUFeG2Jz4mWYtVKM6V/m21j+nEhDqWPkknfGmmYUVHHvA1jDr
         1pRQ==
X-Gm-Message-State: APjAAAVJfKpy4x9H1738j3Ed277aysixvBMMmuYZL84pr1PnpDnm2np4
        bqITU1mP4l/115T9di2E4jynp3yWTukebMXfK34=
X-Google-Smtp-Source: APXvYqxOcImQNzypGFeVWXGp9py8wxlKFKPpz27tdDyzrs1uINU6LbYMgXisOoMzDrWVf3NaJrKHA50+j9kgwxhzJro=
X-Received: by 2002:a7b:c3d4:: with SMTP id t20mr7052016wmj.71.1567028435172;
 Wed, 28 Aug 2019 14:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190822205533.4877-1-david.abdurachmanov@sifive.com>
 <alpine.DEB.2.21.9999.1908231717550.25649@viisi.sifive.com> <201908251446.04BCB8C@keescook>
In-Reply-To: <201908251446.04BCB8C@keescook>
From:   David Abdurachmanov <david.abdurachmanov@gmail.com>
Date:   Wed, 28 Aug 2019 14:39:59 -0700
Message-ID: <CAEn-LTpSPV6NDQ+J3GJxS=rtNMS384uQmq_EuR3ZN_qCGSbyww@mail.gmail.com>
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
To:     Kees Cook <keescook@chromium.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Tycho Andersen <tycho@tycho.ws>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
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

On Wed, Aug 28, 2019 at 10:36 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Aug 23, 2019 at 05:30:53PM -0700, Paul Walmsley wrote:
> > On Thu, 22 Aug 2019, David Abdurachmanov wrote:
> >
> > > There is one failing kernel selftest: global.user_notification_signal
> >
> > Is this the only failing test?  Or are the rest of the selftests skipped
> > when this test fails, and no further tests are run, as seems to be shown
> > here:
> >
> >   https://lore.kernel.org/linux-riscv/CADnnUqcmDMRe1f+3jG8SPR6jRrnBsY8VVD70VbKEm0NqYeoicA@mail.gmail.com/
> >
> > For example, looking at the source, I'd naively expect to see the
> > user_notification_closed_listener test result -- which follows right
> > after the failing test in the selftest source.  But there aren't any
> > results?
> >
> > Also - could you follow up with the author of this failing test to see if
> > we can get some more clarity about what might be going wrong here?  It
> > appears that the failing test was added in commit 6a21cc50f0c7f ("seccomp:
> > add a return code to trap to userspace") by Tycho Andersen
> > <tycho@tycho.ws>.
>
> So, the original email says the riscv series is tested on top of 5.2-rc7,
> but just for fun, can you confirm that you're building a tree that includes
> 9dd3fcb0ab73 ("selftests/seccomp: Handle namespace failures gracefully")? I
> assume it does, but I suspect something similar is happening, where the
> environment is slightly different than expected and the test stalls.
>
> Does it behave the same way under emulation (i.e. can I hope to
> reproduce this myself?)

This was tested in 5.2-rc7 and later in 5.3-rc with the same behavior.
Also VM or physical HW doesn't matter, same result.

>
> --
> Kees Cook
