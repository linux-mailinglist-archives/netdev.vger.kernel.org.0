Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916423A49C3
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFKUEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhFKUEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:04:20 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFA0C061574;
        Fri, 11 Jun 2021 13:02:08 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id q21so5925790ybg.8;
        Fri, 11 Jun 2021 13:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8BXDU5Il9MhAYZZTp8TLNlL4757oUPXDDBsk1f3EPwE=;
        b=CvdlGxP+ZD2r2YxLl6LRYf+IHpdddKQBDPJUlIuPuIYvXf3TSogSiEUQIGHYySAAav
         aXFzm0phOZNxkOp35+CmhtuVoF1GvYn3I5KT0b8fRxMdl0GK9/gilFGqqZrIrKoV7VIr
         tPE9oZiOIGhG4VMKvCh8HwqsATcD4fZhxRoncWbrgrxV+pl79wEkgfcAO+3esCnWIIGT
         WzYgJyeguHd5AyUuUWHs8Goxb55CTJg0Oi0QReddyLm3etXGaXCJyOqb7mdLE6rBn+CN
         +dgzyTys4dysSh4jYOdjaOvC9mMyzhE60ATwIpUZnLz2cIAI4XMfZdwuv3SUP8WEfx9q
         2gcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8BXDU5Il9MhAYZZTp8TLNlL4757oUPXDDBsk1f3EPwE=;
        b=rHqiTCVPKvhcm8PK33rK/3IqjpzaQAq+edxeVVsj2K+KgSBxvOtahqaOuDQGNZpUSl
         NcmOLQYr2od7fGdGZLTUk00HbmnWneW5OC9MCExZ0dE6f3nNiNz2uE6thL0aMtpdLMye
         NXwUXIpOFV552McotIGe367RV0iBWkPUbtDHD25oRT9oU8mypzv0lN8Tpd9NHRs5vU0Q
         HKjNM3supilVHMST/RypiOAw3H5mF/PYZczV/uGU+r2ofz2eXhaaHEwXzU0ZVTa4yW5Z
         77uo7a0f4uaWj5snp8CS+Z6f8QOhHsm3GF5vcIXYjG/J5BsTsbltyLrOusrvpmBcQcLp
         lFjA==
X-Gm-Message-State: AOAM531Rjx6u3I4FIKfxcW+aNQ07XnlXN48UfAbbK/O1673pQpBNl/b1
        jqHnnAkBigXVra7llBfBnqzmzRZHpoeqrm0UJaE=
X-Google-Smtp-Source: ABdhPJzbaN69AKr01u/wrBSciWp4geL3Mw1pOR5o5EdDLz5wLeFSOuCNRslooF6QHtla/pMxjbZaI/W6FFba13Fzk28=
X-Received: by 2002:a25:1455:: with SMTP id 82mr8270969ybu.403.1623441727464;
 Fri, 11 Jun 2021 13:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210512103451.989420-1-memxor@gmail.com>
In-Reply-To: <20210512103451.989420-1-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Jun 2021 13:01:56 -0700
Message-ID: <CAEf4BzbgFE2qtC8iw7f5m2maKZhiAYngiYU_kpx30FT0Sy9j-w@mail.gmail.com>
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

On Wed, May 12, 2021 at 3:35 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This is the seventh version of the TC-BPF series.
>
> It adds a simple API that uses netlink to attach the tc filter and its bpf
> classifier program. Currently, a user needs to shell out to the tc command line
> to be able to create filters and attach SCHED_CLS programs as classifiers. With
> the help of this API, it will be possible to use libbpf for doing all parts of
> bpf program setup and attach.
>
> Changelog contains details of patchset evolution.
>
> In an effort to keep discussion focused, this series doesn't have the high level
> TC-BPF API. It was clear that there is a need for a bpf_link API in the kernel,
> hence that will be submitted as a separate patchset based on this.
>
> The individual commit messages contain more details, and also a brief summary of
> the API.
>
> Changelog:
> ----------

Hey Kartikeya,

There were few issues flagged by Coverity after I synced libbpf to
Github. A bunch of them are netlink.c-related. Could you please take a
look and see if they are false positives or something that we can
actually fix? See links to the issues below. Thanks!

  [0] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901199&mergedDefectId=141815
  [1] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901193&mergedDefectId=322806
  [2] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901197&mergedDefectId=322807
  [3] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901195&mergedDefectId=322808

[...]

>
> Kumar Kartikeya Dwivedi (3):
>   libbpf: add netlink helpers
>   libbpf: add low level TC-BPF API
>   libbpf: add selftests for TC-BPF API
>
>  tools/lib/bpf/libbpf.h                        |  43 ++
>  tools/lib/bpf/libbpf.map                      |   5 +
>  tools/lib/bpf/netlink.c                       | 554 ++++++++++++++++--
>  tools/lib/bpf/nlattr.h                        |  48 ++
>  .../testing/selftests/bpf/prog_tests/tc_bpf.c | 395 +++++++++++++
>  .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 +
>  6 files changed, 993 insertions(+), 64 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c
>
> --
> 2.31.1
>
