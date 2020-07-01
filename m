Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA592115BA
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgGAWRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGAWRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:17:21 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5076BC08C5C1;
        Wed,  1 Jul 2020 15:17:21 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z24so4210425ljn.8;
        Wed, 01 Jul 2020 15:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0hjOP2xWJYBFB1lJ44pZ1iwrgg794l/jK5E/p4AXI4Y=;
        b=Xgu2wjxM8gR3RdyappZ8oWPk1hZNwzaHxbRsdwv1ih9IYYRvRIqKdKk+NPPFJMIgGf
         tuGmbf6th2afvmfrQgZ17KsSvoXzw3M/DdERL+haWnWYQ/yivIh04Il/0SVpOwIJChfl
         nXaI+90956OkrqnzY6idFn3fR1CkNiI5oxM4OI6aNVN+5CqeuerOXeXz9wcOK4mEwFS2
         U56SI4t7ivgqYcuMz2DZjhfloweXi09Cjg5M/y/YDMDXPgOxjXBlw2JdLi09TJrwyhFJ
         day/jgYuHZH1a/2z0VXf3QdBEoV+fYkMqyeFxhJwrcFsfZvEJ/UtDGJgzS0li4MLQMx+
         A5Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0hjOP2xWJYBFB1lJ44pZ1iwrgg794l/jK5E/p4AXI4Y=;
        b=tEggY2p9BWi6NCXwIeCK+9b1GLianUnoRbEoDcSz6TiF5G4PFWKBogJSjTHCFzUZdz
         jA0x0HknrpKx5kOH9UJ8bERPQ7cor4LnZXZKFfEWRRWp+x4xnS80aIUKRqKJdNMt0Q4d
         klGwKrqNFq/2RYk8pDKtqZW5Hxh/jUqBY13nJfZHXUnel06iGS8Kl3j9u+0S0ZUOvfGW
         1/L9vq66m0ZY6BVj5n+SiUXrK9T5oekQLkD2gtF6Aaf6LiBryn2VgOb1x/QkvQe1aG2v
         WPs8/LEEL9JLPXySfxgVi4GC79K8x/BcMwhqryQW4xNqQRF0pfmCWVVCjSlpNGpP8EsU
         Ou9g==
X-Gm-Message-State: AOAM533A/LUpocLk4YMG6jg1Ofl17r70xz+ituTUXxEWG19TwBz8owyw
        8bjVbOpX6utFYI24JR0SEKLYw+PU4D8FdcWEDqg=
X-Google-Smtp-Source: ABdhPJy5vPSx7u8xpYmsgb/HuUaDybMaWgfQGMlx4w2etWh/E2gQtbxZbUoCO0Vwt7DaK6VEGMyi7t2ve6zYyr4FuE8=
X-Received: by 2002:a2e:9bc3:: with SMTP id w3mr6345365ljj.121.1593641839001;
 Wed, 01 Jul 2020 15:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200701175315.1161242-1-haoluo@google.com> <aab03e4b-2779-3b71-44ea-735a7b92a70f@fb.com>
In-Reply-To: <aab03e4b-2779-3b71-44ea-735a7b92a70f@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Jul 2020 15:17:07 -0700
Message-ID: <CAADnVQK5o1uhJOXLKAbf9Hp_Y0fVsowD3DwRWwBd_++KTTOJHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Switch test_vmlinux to use hrtimer_range_start_ns.
To:     Yonghong Song <yhs@fb.com>
Cc:     Hao Luo <haoluo@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 11:04 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/1/20 10:53 AM, Hao Luo wrote:
> > The test_vmlinux test uses hrtimer_nanosleep as hook to test tracing
> > programs. But in a kernel built by clang, which performs more aggresive
> > inlining, that function gets inlined into its caller SyS_nanosleep.
> > Therefore, even though fentry and kprobe do hook on the function,
> > they aren't triggered by the call to nanosleep in the test.
> >
> > A possible fix is switching to use a function that is less likely to
> > be inlined, such as hrtimer_range_start_ns. The EXPORT_SYMBOL functions
> > shouldn't be inlined based on the description of [1], therefore safe
> > to use for this test. Also the arguments of this function include the
> > duration of sleep, therefore suitable for test verification.
> >
> > [1] af3b56289be1 time: don't inline EXPORT_SYMBOL functions
> >
> > Tested:
> >   In a clang build kernel, before this change, the test fails:
> >
> >   test_vmlinux:PASS:skel_open 0 nsec
> >   test_vmlinux:PASS:skel_attach 0 nsec
> >   test_vmlinux:PASS:tp 0 nsec
> >   test_vmlinux:PASS:raw_tp 0 nsec
> >   test_vmlinux:PASS:tp_btf 0 nsec
> >   test_vmlinux:FAIL:kprobe not called
> >   test_vmlinux:FAIL:fentry not called
> >
> >   After switching to hrtimer_range_start_ns, the test passes:
> >
> >   test_vmlinux:PASS:skel_open 0 nsec
> >   test_vmlinux:PASS:skel_attach 0 nsec
> >   test_vmlinux:PASS:tp 0 nsec
> >   test_vmlinux:PASS:raw_tp 0 nsec
> >   test_vmlinux:PASS:tp_btf 0 nsec
> >   test_vmlinux:PASS:kprobe 0 nsec
> >   test_vmlinux:PASS:fentry 0 nsec
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> Thanks!
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
