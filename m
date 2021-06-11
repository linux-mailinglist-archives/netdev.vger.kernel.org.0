Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3413A4AD1
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 23:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFKV73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 17:59:29 -0400
Received: from mail-yb1-f171.google.com ([209.85.219.171]:42604 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhFKV72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 17:59:28 -0400
Received: by mail-yb1-f171.google.com with SMTP id g142so6293692ybf.9;
        Fri, 11 Jun 2021 14:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vKPgQ89j3QyCfCYeBY1455dOcKAL4tKAP5fe4sX2ag0=;
        b=Bfk+0YeY+vRMJ16DSMea9TyNDURBGBs5tPbKc9ygm9LgS9SyPI9y80cDwiuLpVuXp6
         9SGj6m6wr6WbKilAY4OqwMNwTm7rE5z89Bc9z4VPGCTzTxcS24MtgdBHEftl9AJfCbOe
         6k4miRMkq8GiMvCQTsKjPcFzUxiyuwZffByNS28aH/7P7FpW9tfuiKV2FNuJSz+6mPLw
         wnOrEmteWNN4hqIPEGgX9/Iye1eFQb1/dCTlZ2AE/56Dr4ZqndkgWV008BPCP4OOBe5j
         JvfSZVq8k77rOrOwXtUCVuRg5EIGTTWQFmQ5BAkZpgq0/byeWgJyhqv9lCZIF6TC1oFu
         Fntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vKPgQ89j3QyCfCYeBY1455dOcKAL4tKAP5fe4sX2ag0=;
        b=TZQPLQS7VtscE/t5hfIOagc9KftlAPkAxlmh4Y+b630sLBl+H+Z4yl+iLswlrEY9mL
         Hvw1aQJvk/xvfUEHRqL48EIoJdS+SW+nn0t1oI53iEbqRFLGEq3ERXc+PRKt03XqFcsM
         OJSPYVSoS96fAgyJtrCve8Z+ZKWXln9Fy9cvBPvYRXhfwrRVnTjQs23awKLt1EzU2BrV
         Srpf6hBqYlTdS4zKwB8qqKTe2UJhiTeGmLCNpT6PqQIhChivI0D3W/xFSUPy7lV3CON9
         +xonE5ikNggBHI9wnolNXfX7Q174dml3S1QjU9NVOp5UMCv5tEMVvL5LNN/2+76EAw5f
         bujA==
X-Gm-Message-State: AOAM530qRqq1+f+s7Tb60mIzox4crN6KtAOxdZIA79iapo6caongyvcD
        +d7cZnS6uHE37DfDuVrTwfn31FyemVvickphupE=
X-Google-Smtp-Source: ABdhPJzZ9aflfxep0ru9H3ZTwv0O5zXETVR64m/9NDmxOSAbrYJ2axe5fXBuCjG4vAy6qlhZdkR0jXkoowAvuo9r1HU=
X-Received: by 2002:a5b:f05:: with SMTP id x5mr8502795ybr.425.1623448574291;
 Fri, 11 Jun 2021 14:56:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210512103451.989420-1-memxor@gmail.com> <CAEf4BzbgFE2qtC8iw7f5m2maKZhiAYngiYU_kpx30FT0Sy9j-w@mail.gmail.com>
 <20210611204611.4xdgvqwtcin6ckdc@apollo> <CAEf4BzZWBLYuuSY5p=TO1uj4ie+JCxZ4Js0uxUmgNBwQcwZ5+g@mail.gmail.com>
 <20210611212348.qnwkyvmpqar3qwjr@apollo>
In-Reply-To: <20210611212348.qnwkyvmpqar3qwjr@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Jun 2021 14:56:02 -0700
Message-ID: <CAEf4BzZn-5L27F0QwULRjZ9UsaWhV_=PvPPUoE8717zh340b3g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 0/3] Add TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Shaun Crampton <shaun@tigera.io>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 2:25 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sat, Jun 12, 2021 at 02:28:09AM IST, Andrii Nakryiko wrote:
> > On Fri, Jun 11, 2021 at 1:47 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Sat, Jun 12, 2021 at 01:31:56AM IST, Andrii Nakryiko wrote:
> > > > On Wed, May 12, 2021 at 3:35 AM Kumar Kartikeya Dwivedi
> > > > <memxor@gmail.com> wrote:
> > > > >
> > > > > This is the seventh version of the TC-BPF series.
> > > > >
> > > > > It adds a simple API that uses netlink to attach the tc filter and its bpf
> > > > > classifier program. Currently, a user needs to shell out to the tc command line
> > > > > to be able to create filters and attach SCHED_CLS programs as classifiers. With
> > > > > the help of this API, it will be possible to use libbpf for doing all parts of
> > > > > bpf program setup and attach.
> > > > >
> > > > > Changelog contains details of patchset evolution.
> > > > >
> > > > > In an effort to keep discussion focused, this series doesn't have the high level
> > > > > TC-BPF API. It was clear that there is a need for a bpf_link API in the kernel,
> > > > > hence that will be submitted as a separate patchset based on this.
> > > > >
> > > > > The individual commit messages contain more details, and also a brief summary of
> > > > > the API.
> > > > >
> > > > > Changelog:
> > > > > ----------
> > > >
> > > > Hey Kartikeya,
> > > >
> > > > There were few issues flagged by Coverity after I synced libbpf to
> > > > Github. A bunch of them are netlink.c-related. Could you please take a
> > > > look and see if they are false positives or something that we can
> > > > actually fix? See links to the issues below. Thanks!
> > > >
> > > >   [0] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901199&mergedDefectId=141815
> > > >   [1] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901193&mergedDefectId=322806
> > > >   [2] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901197&mergedDefectId=322807
> > > >   [3] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901195&mergedDefectId=322808
> > > >
> > >
> > > Hi Andrii,
> > >
> > > These links don't work for me (I get a timeout). Would you know why? Is there
> > > some other link where I can look at them?
> > >
> >
> > Sorry, I don't know any other way to share them.
> > https://scan3.coverity.com/reports.htm#v40547/p11903 should show all
> > libbpf issues. Maybe try creating an account with coverity.com?..
> >
>
> Thanks, that helped. I now see 401 Unauthorized, so I sent an approval request.

Approved.

>
> --
> Kartikeya
