Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBBF558C9
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfFYU14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:27:56 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:35732 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbfFYU14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:27:56 -0400
Received: by mail-lj1-f175.google.com with SMTP id x25so17609174ljh.2;
        Tue, 25 Jun 2019 13:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oRmYeVOh7NfY6hKbB5eNWP52w4vJxcXS9GCkFHd3G74=;
        b=eVeBnR+XAL2j5u3GGVsg3yWUIGA7z+jVikp+Bs7gMu1/yELD3OcstPMxguwV1tVjUI
         ECS6brRWHFnW+o/AKFNIFVvrAf9herve2aaUwPXanEsGEp5Wf7BuWmT2PiFJzlSZo/3F
         BI3NL9Akq09pK9GVK7uOugYJZ1fN57wvBf8A/850IhI+ZeE2z5NFL4Qc54Y/RB51ZdEb
         WM9M0qiOriFpM+Gvxa0QatwFUkcY7Ho04nHAN7rEfmyoerS6pw3eto6ZF1e9apHwzFJo
         ZXLjm/MkGvvaKkyOfEqfNnFqDx2VqLgQJcB4d1LUqsjVzb3aifJFB+//RgI1Ks0ioQWj
         Ffsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oRmYeVOh7NfY6hKbB5eNWP52w4vJxcXS9GCkFHd3G74=;
        b=H8vb8O3GtUY5nkbTcnsv4OvIafOZ4wZMS0Vuts4K9Yz9aKH/556/MR85ygAqWf2iQP
         q10EHI4yBWB8II+5Q0gFZhNHXerJ3S5ZZ7pGzqfJW/09YDbndKg7BLkUQSLS1/zEdQug
         kCTUas928QWk5gzyZBlXMe4ijLo8vKJwq5IjSPz8Vi9oZ0ntnimcVkAFYmw0hO0T5IXp
         Vr4dQkA3Y/48F6qbKBQAx/ofO39lTZ2jFx/Q+5NFMKSx0ZHJYbUmLJqsRqNqKAhkDNG9
         e0c9P7DMa0pjldaaS2LhZ+ywuvA6V1lp4wUb5ArKWz9f3TEmEZkICGD2pN8V6mvomKMM
         N8gg==
X-Gm-Message-State: APjAAAUPKHtedOF2FuhMff/BpkIYspp8RGg3s8J76HeWpREhtYLph0cY
        Xo92TuQfqbr/8HuIsPbmQGV9VeVYD5yussrJXUo=
X-Google-Smtp-Source: APXvYqyPbC29JdNWnZqiP3xde3zVIFnuhIOwlmPXNm+MesPHdP6UZWYfygK3ni7PqzwYZ8irnFTkkjFxUp3S1X4VZxo=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr273099ljj.17.1561494472994;
 Tue, 25 Jun 2019 13:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
 <CAEf4BzbTD8G_zKkj-S3MOeG5Hq3_2zz3bGoXhQtpt0beG8nWJA@mail.gmail.com>
 <20190621161752.d7d7n4m5q67uivys@xps.therub.org> <CAEf4BzaSoKA5H5rN=w+OAtUz4bD30-VOjjjY+Qv9tTAnhMweiA@mail.gmail.com>
 <20190624195336.nubi7n2np5vfjutr@xps.therub.org> <CAADnVQKZycXgSw6C0qa7g0y=W3xRhM_4Rqcj7ZzL=rGh_n4mgA@mail.gmail.com>
 <20190625153159.5utnn36dgku5545n@xps.therub.org>
In-Reply-To: <20190625153159.5utnn36dgku5545n@xps.therub.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 Jun 2019 13:27:41 -0700
Message-ID: <CAADnVQLoSc=PsKj=KdCsqMLfHO-sP_Bijgy63zROos6Cy=k+dw@mail.gmail.com>
Subject: Re: selftests: bpf: test_libbpf.sh failed at file test_l4lb.o
To:     Dan Rue <dan.rue@linaro.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 8:32 AM Dan Rue <dan.rue@linaro.org> wrote:
>
> On Mon, Jun 24, 2019 at 12:58:15PM -0700, Alexei Starovoitov wrote:
> > On Mon, Jun 24, 2019 at 12:53 PM Dan Rue <dan.rue@linaro.org> wrote:
> > >
> > > I would say if it's not possible to check at runtime, and it requires
> > > clang 9.0, that this test should not be enabled by default.
> >
> > The latest clang is the requirement.
> > If environment has old clang or no clang at all these tests will be failing.
>
> Hi Alexei!
>
> I'm not certain if I'm interpreting you as you intended, but it sounds
> like you're telling me that if the test build environment does not use
> 'latest clang' (i guess latest as of today?), that these tests will
> fail, and that is how it is going to be. If I have that wrong, please
> correct me and disregard the rest of my message.
>
> Please understand where we are coming from. We (and many others) run
> thousands of tests from a lot of test frameworks, and so our environment
> often has mutually exclusive requirements when it comes to things like
> toolchain selection.
>
> We believe, strongly, that a test should not emit a "fail" for a missing
> requirement. Fail is a serious thing, and should be reserved for an
> actual issue that needs to be investigated, reported, and fixed.
>
> This is how we treat test failures - we investigate, report, and fix
> them when possible. When they're not real failures, we waste our time
> (and yours, in this case).
>
> By adding the tests to TEST_GEN_PROGS, you're adding them to the general
> test set that those of us running test farms try to run continuously
> across a wide range of hardware environments and kernel branches.

you run the latest selftests/bpf on the latest kernel, right?
If not than selftests/bpf is not for your setup.

In the past people argued that selftests/bpf should check
features of the kernel and skip when features are not found.
My answer to that was always the same: such changes to selftests
for older kernels need to live out of tree.
selftests/bpf are one to one to the latest kernel.
Often kernel commit X will break selftests and they're fixed
in the commit X+1.
clang, pahole, bpftool, iproute2 provide those features for the kernel.
In other words new kernel features rely on new clang and
other tools and selftests are testing those latest kernel features.
Without new clang many new features cannot be tested exhaustively.
datasec and btf are just few examples.
Hence if your test farm cannot install the latest clang, pahole, etc then
I recommend not to run selftest/bpf.
