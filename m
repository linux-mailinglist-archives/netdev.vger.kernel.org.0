Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1340377E29
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 07:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfG1Flg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 01:41:36 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42398 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfG1Flg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 01:41:36 -0400
Received: by mail-lj1-f195.google.com with SMTP id t28so55303341lje.9;
        Sat, 27 Jul 2019 22:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rS+2HjE6KAJTFQivnkbEPDjEuihxfCbrvfKNsS+7/Fk=;
        b=JkAcS+jGrImQyUpa/TqCmZk1TUghgCXDwtI2lsHgY9oSUOVYWv+ASEEGdKHc37SGoe
         nzsAV7Scr4qC+LhyXnqvZXnUS1sPvkI/K1LkPaa1YfXAzSvkqCDSN5Aa4cH/Co+QCq7V
         0gZUu4/k61uZuLzgt/NTCgsbu/ujRWowctMEE1YRz3RPo09R2pLnaAhqCqLARxdWAGWI
         swq8GaR6MN6K+lmPjsgA8NWl1p9Sd8fm63symN5iMCsH2gFaMGnbgExHhfpA8flvZmYZ
         xzkw+mLonXP9pOaXuniTKIfmF83DhfSWX59YvWbekxbCZcZ1A+xY1nQMHseU9nb4bfYP
         jtYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rS+2HjE6KAJTFQivnkbEPDjEuihxfCbrvfKNsS+7/Fk=;
        b=c/DwA6rll/6O4vW4lHFHndSOWqhHWQtkuHwJa49abz0Wmr3itXcTV+9uwyAPAEz2wd
         gq1pYb/b54GcnKPeGkyAh9ge/H+uc8iO+8Ri4jMniLrdT6SKM6SvKW7mfkmBmm/vUE3t
         hYoGf2rHgQdRGeWLq7D3tOupVFrlDU2f8aol1q/iUCZJSA2S5DnAJPxiwnScCBwN+vCX
         n8jS6mfC0zjHkAcjK1imNtwWGV2hOfFajKtMztmY9Wde+KC3PFH/143xyec3fsBqU3xf
         O2waqzdxCvW0YGNV0gGVQ2y7ms2TgefC1m5mgd6vJzgk1s1UL0De2s6JGaW4GlpxxKgf
         NFTg==
X-Gm-Message-State: APjAAAU6Qx1raYiQa5YEpqyFY0N6ezm6Yg1Q2cej3JnzDfK61xmGlLDq
        SyDNPiLuYx6v45dGaHhCSYvjuNW6YMjPbc9Qi4M=
X-Google-Smtp-Source: APXvYqwnDwqnAdFYb2o4sy/Ibf0GAp+/Nf4JFV7XBjOrERfMWb+06hEmp6oj4iJJY0Yd7g0jq+o6p9sRhhvWIBr3p1A=
X-Received: by 2002:a2e:968e:: with SMTP id q14mr50552931lji.195.1564292494244;
 Sat, 27 Jul 2019 22:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190728032531.2358749-1-andriin@fb.com>
In-Reply-To: <20190728032531.2358749-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 27 Jul 2019 22:41:22 -0700
Message-ID: <CAADnVQKyaFQimj5B7KAREswWwfLX29L2tjQ4G_1GXZb49YWc3A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/9] Revamp test_progs as a test running framework
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 8:25 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set makes a number of changes to test_progs selftest, which is
> a collection of many other tests (and sometimes sub-tests as well), to provide
> better testing experience and allow to start convering many individual test
> programs under selftests/bpf into a single and convenient test runner.
>
> Patch #1 fixes issue with Makefile, which makes prog_tests/test.h compiled as
> a C code. This fix allows to change how test.h is generated, providing ability
> to have more control on what and how tests are run.
>
> Patch #2 changes how test.h is auto-generated, which allows to have test
> definitions, instead of just running test functions. This gives ability to do
> more complicated test run policies.
>
> Patch #3 adds `-t <test-name>` and `-n <test-num>` selectors to run only
> subset of tests.
>
> Patch #4 changes libbpf_set_print() to return previously set print callback,
> allowing to temporarily replace current print callback and then set it back.
> This is necessary for some tests that want more control over libbpf logging.
>
> Patch #5 sets up and takes over libbpf logging from individual tests to
> test_prog runner, adding -vv verbosity to capture debug output from libbpf.
> This is useful when debugging failing tests.
>
> Patch #6 furthers test output management and buffers it by default, emitting
> log output only if test fails. This give succinct and clean default test
> output. It's possible to bypass this behavior with -v flag, which will turn
> off test output buffering.
>
> Patch #7 adds support for sub-tests. It also enhances -t and -n selectors to
> both support ability to specify sub-test selectors, as well as enhancing
> number selector to accept sets of test, instead of just individual test
> number.
>
> Patch #8 converts bpf_verif_scale.c test to use sub-test APIs.
>
> Patch #9 converts send_signal.c tests to use sub-test APIs.
>
> v2->v3:
>   - fix buffered output rare unitialized value bug (Alexei);
>   - fix buffered output va_list reuse bug (Alexei);
>   - fix buffered output truncation due to interleaving zero terminators;

Looks great.
Applied. Thanks!
