Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B133A4A4D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhFKUt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhFKUt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:49:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9026FC061574;
        Fri, 11 Jun 2021 13:47:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j12so3394399pgh.7;
        Fri, 11 Jun 2021 13:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y+p+pDw7EG4HJFiJZ0T8k2KWh0wkpqmorfpj2ONLcdg=;
        b=SE+SGd9OudxYtIn5NEPv3HA382vm2n/x7FgcDa67f7C89H7C1roD3xR7jlMw4AOpzU
         n8An2NrvnuLQpQYvu1vqqkthyG54fkQzCixuEY8cRbAx0GFVplJ1xfHZjTE8Y0Rkr3NF
         MklhZdl2AUca7XgWG6nOKAD7+BcWToQkRYjN2N5zIDWG5O9gJG9qzRWsw7OlKVfHDb4S
         7tH/Qq0OBP0G1l1Kvxv5Cng8z5Rbt1Q2Gt70msiPV0ATmBCOmTfiqcpFJK7OT8kZrIOH
         kCfGh7CdneFjpQsx95jUt8kCJLGxYf2nGcfLfPNSYBLECAheaqi6GdLbKuwDiD5vgd1w
         PHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y+p+pDw7EG4HJFiJZ0T8k2KWh0wkpqmorfpj2ONLcdg=;
        b=omscF1jo51b1+FJH6XYdG+NngyJmasaLxd/PQb2mTPl31RoDXCHTNbPQ57kMDSDO5H
         uRXNGSmvagZpQ5r0T+FfsCNmW8JnKhYcneh+MNZy3AVDLqf2/CvIfE5x+rOes6bly6zu
         IJjn5c0JDEC8zjGWAI4S2vs3gUhuORfaiSAAilHr01bkcDUYjAzqGaRXYAegguYm+vlh
         tLg2MSKvT5+Ok+oaPi/Sb0fJZPQg4dASclE9xhDl7ePWQYHXBVTj3xzlTDEWBBgOZQHk
         1knn5zdx+7dqoSVq5bjN3jLyex/K6eIdZw2Dp0+lIYDkePm2+UmDHx6dMJ+jt1hlFwep
         2ELA==
X-Gm-Message-State: AOAM530Y7NWQmY8ok5HNNdhVTrGyU8lT6RaFXPrDRDz0nzs4jlvqQ/W4
        Pv6E5LcYnfio02k+BhRa3vs=
X-Google-Smtp-Source: ABdhPJxitQ+i0dWxWyCRm8uL/06YbPjvVYVGyUdoPn/yFFe4umft5DtI3IX5YJZbBrw6uIB7DqBYxQ==
X-Received: by 2002:a63:1d42:: with SMTP id d2mr5361578pgm.21.1623444447933;
        Fri, 11 Jun 2021 13:47:27 -0700 (PDT)
Received: from localhost ([2402:3a80:11fa:b320:6829:855:e322:485])
        by smtp.gmail.com with ESMTPSA id n17sm5597515pfv.125.2021.06.11.13.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:47:27 -0700 (PDT)
Date:   Sat, 12 Jun 2021 02:16:11 +0530
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
Message-ID: <20210611204611.4xdgvqwtcin6ckdc@apollo>
References: <20210512103451.989420-1-memxor@gmail.com>
 <CAEf4BzbgFE2qtC8iw7f5m2maKZhiAYngiYU_kpx30FT0Sy9j-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbgFE2qtC8iw7f5m2maKZhiAYngiYU_kpx30FT0Sy9j-w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 12, 2021 at 01:31:56AM IST, Andrii Nakryiko wrote:
> On Wed, May 12, 2021 at 3:35 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This is the seventh version of the TC-BPF series.
> >
> > It adds a simple API that uses netlink to attach the tc filter and its bpf
> > classifier program. Currently, a user needs to shell out to the tc command line
> > to be able to create filters and attach SCHED_CLS programs as classifiers. With
> > the help of this API, it will be possible to use libbpf for doing all parts of
> > bpf program setup and attach.
> >
> > Changelog contains details of patchset evolution.
> >
> > In an effort to keep discussion focused, this series doesn't have the high level
> > TC-BPF API. It was clear that there is a need for a bpf_link API in the kernel,
> > hence that will be submitted as a separate patchset based on this.
> >
> > The individual commit messages contain more details, and also a brief summary of
> > the API.
> >
> > Changelog:
> > ----------
>
> Hey Kartikeya,
>
> There were few issues flagged by Coverity after I synced libbpf to
> Github. A bunch of them are netlink.c-related. Could you please take a
> look and see if they are false positives or something that we can
> actually fix? See links to the issues below. Thanks!
>
>   [0] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901199&mergedDefectId=141815
>   [1] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901193&mergedDefectId=322806
>   [2] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901197&mergedDefectId=322807
>   [3] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901195&mergedDefectId=322808
>

Hi Andrii,

These links don't work for me (I get a timeout). Would you know why? Is there
some other link where I can look at them?

> [...]
>
> >
> > Kumar Kartikeya Dwivedi (3):
> >   libbpf: add netlink helpers
> >   libbpf: add low level TC-BPF API
> >   libbpf: add selftests for TC-BPF API
> >
> >  tools/lib/bpf/libbpf.h                        |  43 ++
> >  tools/lib/bpf/libbpf.map                      |   5 +
> >  tools/lib/bpf/netlink.c                       | 554 ++++++++++++++++--
> >  tools/lib/bpf/nlattr.h                        |  48 ++
> >  .../testing/selftests/bpf/prog_tests/tc_bpf.c | 395 +++++++++++++
> >  .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 +
> >  6 files changed, 993 insertions(+), 64 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c
> >
> > --
> > 2.31.1
> >

--
Kartikeya
