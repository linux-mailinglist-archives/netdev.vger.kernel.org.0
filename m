Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C537C393BE
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbfFGR5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:57:15 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43390 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfFGR5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 13:57:15 -0400
Received: by mail-qt1-f193.google.com with SMTP id z24so3271146qtj.10;
        Fri, 07 Jun 2019 10:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GnZ8utMoWZghJhijN6JzlV9oeMLjaDcVbBVuvmMM+oE=;
        b=HIaKGCP7j2Oexz3aBeGQhfU5Ec9tEOhUXebZdCbWcMQzjwUjGmh0eH+/I6lhmMjQ+T
         4TN3O9f7QY2EDIVjYSsnyZWuQbQvGPo0iF1dsaK5RKoEmridEBiZKapb6+UdLznvaGmN
         JP7pK93XXtJfIV5e/bxUe04yi8qj/t+bWg0Up/XjTZdwK8MqrqPems5c6QHJTCTvBELh
         8DSaYAQCGM6iFW6dDnptOi8CTayPb9qaxJlk+ej6xbQ/IgbExEwhnrcQI07RtbFt2Cji
         dHz50QLv8B+SN9TwdEydYgkhGcfBfvK+nFaL+6q2USPzBft6bAJE0jcOlWpg5xwoAV8Z
         2HJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GnZ8utMoWZghJhijN6JzlV9oeMLjaDcVbBVuvmMM+oE=;
        b=cztZJYqB1b84eK7Gs3VWVQZo09sqPHATAZqBM0irtHfaQ/rOo6KaZgEjyb1JYKDoRy
         5JpbeOVSm/OEerki3RR/Rq6Z+6DMfrU0scMIBX80RjP7a9SGWNgMDTQ4BesmhhHeymtI
         KZYz49TXNf/9xaxzvtAmNFslkJyEQ8OM95ZJwEHMX8SFMFEKmjaoSv8/ZwOvoPoAGNCo
         C1PIQBMcLSAtXyP6PluM+cOJtKdZdN00WeURXpO88DGzxn05kiHaIe+xlfSsL6C8d4ld
         T7GLfxUhaipU0CmcB7+3V7jrhoHdmPWr9efzLxNJxDDcdbYeYmlotfuIUQBCEm7PkR+C
         xSWw==
X-Gm-Message-State: APjAAAUL8ar45zsqywssMHm0xN3vXz0Osjp01k5FuVubJoL+DH9tMh/w
        OJT9kS9HT6tP0IeHOj6QbSa8NHHfGtNLD0Erdvw=
X-Google-Smtp-Source: APXvYqxytH8ATdRW6FH3DxJ28Wt+cgxpqJ2Bp6eZT5hPVVWSgpKxtG3oaaGTYEM3PNyRQGium/vtucr4fznKhnViYXI=
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr27329164qtl.117.1559930233882;
 Fri, 07 Jun 2019 10:57:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190607163759.2211904-1-hechaol@fb.com>
In-Reply-To: <20190607163759.2211904-1-hechaol@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 7 Jun 2019 10:57:02 -0700
Message-ID: <CAEf4BzYzfTAyHZwAdE1MPxZ4cUhP9LsAEDJ_VLQqx_PkVW9_0w@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/2] bpf: Add a new API libbpf_num_possible_cpus()
To:     Hechao Li <hechaol@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 7, 2019 at 9:38 AM Hechao Li <hechaol@fb.com> wrote:
>
> Getting number of possible CPUs is commonly used for per-CPU BPF maps
> and perf_event_maps. Add a new API libbpf_num_possible_cpus() that
> helps user with per-CPU related operations and remove duplicate
> implementations in bpftool and selftests.
>
> v4: Fixed error code when reading 0 bytes from possible CPU file
>
> Hechao Li (2):
>   bpf: add a new API libbpf_num_possible_cpus()
>   bpf: use libbpf_num_possible_cpus in bpftool and selftests
>
>  tools/bpf/bpftool/common.c             | 53 +++---------------------
>  tools/lib/bpf/libbpf.c                 | 57 ++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h                 | 16 ++++++++
>  tools/lib/bpf/libbpf.map               |  1 +
>  tools/testing/selftests/bpf/bpf_util.h | 37 +++--------------
>  5 files changed, 84 insertions(+), 80 deletions(-)
>
> --
> 2.17.1
>

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>
