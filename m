Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D63A3A4A96
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 23:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhFKV1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 17:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhFKV1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 17:27:21 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64612C061574;
        Fri, 11 Jun 2021 14:25:08 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x73so5471410pfc.8;
        Fri, 11 Jun 2021 14:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EErh4AFEB9TSdc7WfIdaoOzA/fCcYXLQPgZuGLkqOcY=;
        b=PIam/HP72m4iEvTn90htVH+FbHnvL1D2rCMli854G13eHjMyEJkKuKhsZiEgnT+0zV
         JZoCZsRFU36/AppgDUousRi2batAyZ9sS+Te0AWQ9zeGS2Xqq3dp/roIikV0pNl1Lv3u
         6hvdt/CEox765CXl/6xwBOvmJMARg7jzURTpB4YELmXBfDrFFRzgJENSCqRZVYvAKlDo
         m/wohIaYriksspHPys3RTZz0PO+C8X23qaauLHJ46rzt211nE7B9H57YokumoJ/hSiTq
         488HAQdJGFbPnR5kRClIU9qHq3u5MZNJbeEPVZ3Bw8fkcmDCEGZyFuy3Ngi0jnk7S5S4
         iAMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EErh4AFEB9TSdc7WfIdaoOzA/fCcYXLQPgZuGLkqOcY=;
        b=K9Y7QXYqiG8cfcWlirYJh/NcQs6pvkjGYKSkNexlwFn6N3m2cYhyB4jQTS03qz0gVr
         erLIUdGAopDzQzM7nGiHin/TWLkOfCRx9li6KsmZXEHUT3n0gq8NqptY4xXOMRb2eqkF
         t5dSNCxONRSInJC651sxFXEMuuQR+DaIZrwG3Ei+xkCQTlAXcpkqDQQqYy6hflgyh0Pz
         k7BaUQnw3uBLnUcJl5CP/c7Xuv5fmx+gfMdcQpSSRuwTrjR9W0bdo8/hmhTKxVKYFwXk
         7kuR2xeN5aqnQohIPVIFMzjVll1GYBVTgdP0F9+N2UInKXOw2m6ifm21cA2b3skNBEHa
         KGvg==
X-Gm-Message-State: AOAM532WrbQ5Qzvz/UUctnkTuJN3f7xrxCVyHHWhG62mMPCO0gepvQ2n
        XI5WtYmAv77vk8r7/nQixHc=
X-Google-Smtp-Source: ABdhPJxUApQlw3zt2l1XcLt8eNiJyuprAK+wRCmqJ8EEL/EA8gYI5WeX2Oyi/8+iJZ3iyzamDYuK1g==
X-Received: by 2002:a63:e0e:: with SMTP id d14mr5453612pgl.426.1623446707759;
        Fri, 11 Jun 2021 14:25:07 -0700 (PDT)
Received: from localhost ([2409:4063:4d05:9fb3:bc63:2dba:460a:d70e])
        by smtp.gmail.com with ESMTPSA id x206sm5960002pfc.211.2021.06.11.14.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 14:25:07 -0700 (PDT)
Date:   Sat, 12 Jun 2021 02:53:48 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shaun Crampton <shaun@tigera.io>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v7 0/3] Add TC-BPF API
Message-ID: <20210611212348.qnwkyvmpqar3qwjr@apollo>
References: <20210512103451.989420-1-memxor@gmail.com>
 <CAEf4BzbgFE2qtC8iw7f5m2maKZhiAYngiYU_kpx30FT0Sy9j-w@mail.gmail.com>
 <20210611204611.4xdgvqwtcin6ckdc@apollo>
 <CAEf4BzZWBLYuuSY5p=TO1uj4ie+JCxZ4Js0uxUmgNBwQcwZ5+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZWBLYuuSY5p=TO1uj4ie+JCxZ4Js0uxUmgNBwQcwZ5+g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 12, 2021 at 02:28:09AM IST, Andrii Nakryiko wrote:
> On Fri, Jun 11, 2021 at 1:47 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Sat, Jun 12, 2021 at 01:31:56AM IST, Andrii Nakryiko wrote:
> > > On Wed, May 12, 2021 at 3:35 AM Kumar Kartikeya Dwivedi
> > > <memxor@gmail.com> wrote:
> > > >
> > > > This is the seventh version of the TC-BPF series.
> > > >
> > > > It adds a simple API that uses netlink to attach the tc filter and its bpf
> > > > classifier program. Currently, a user needs to shell out to the tc command line
> > > > to be able to create filters and attach SCHED_CLS programs as classifiers. With
> > > > the help of this API, it will be possible to use libbpf for doing all parts of
> > > > bpf program setup and attach.
> > > >
> > > > Changelog contains details of patchset evolution.
> > > >
> > > > In an effort to keep discussion focused, this series doesn't have the high level
> > > > TC-BPF API. It was clear that there is a need for a bpf_link API in the kernel,
> > > > hence that will be submitted as a separate patchset based on this.
> > > >
> > > > The individual commit messages contain more details, and also a brief summary of
> > > > the API.
> > > >
> > > > Changelog:
> > > > ----------
> > >
> > > Hey Kartikeya,
> > >
> > > There were few issues flagged by Coverity after I synced libbpf to
> > > Github. A bunch of them are netlink.c-related. Could you please take a
> > > look and see if they are false positives or something that we can
> > > actually fix? See links to the issues below. Thanks!
> > >
> > >   [0] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901199&mergedDefectId=141815
> > >   [1] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901193&mergedDefectId=322806
> > >   [2] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901197&mergedDefectId=322807
> > >   [3] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901195&mergedDefectId=322808
> > >
> >
> > Hi Andrii,
> >
> > These links don't work for me (I get a timeout). Would you know why? Is there
> > some other link where I can look at them?
> >
>
> Sorry, I don't know any other way to share them.
> https://scan3.coverity.com/reports.htm#v40547/p11903 should show all
> libbpf issues. Maybe try creating an account with coverity.com?..
>

Thanks, that helped. I now see 401 Unauthorized, so I sent an approval request.

--
Kartikeya
