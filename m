Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2E73EBE5C
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhHMWnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235059AbhHMWnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 18:43:19 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E51C061756;
        Fri, 13 Aug 2021 15:42:52 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id a93so21673925ybi.1;
        Fri, 13 Aug 2021 15:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xTB2rvbHdT9dtL5MF50csZwyabzYfgL7Ys+DI5bY+gw=;
        b=thjcz2D2EOw8ZvNwbYO7Fi2HV/gnwmqUkGFrnPkIyYRAXuvBejgor8x//38U9Q49me
         OhgJ2WUm+VNuXaL8tilmdOB/4ho699k1x8nnBVNcJjszAOdlyittP42T/nnJdJG3c2o3
         nwgQpatOoUCVfc5f8MMfeOVFqQDPOofLUpLKni7oJBDUCtXiOPJxuBZPykVHg2BY5Z/P
         CP6UVidnGJUXVfU21Mj3xYvqpaDZ/hhbGbCUkYGNRe4D32cPdsBnzANw8/WA1zZyqNna
         2jhFuoe8Zd0M4KZbUiWUU6bUewyqHBDfxaInfWT6WHk1FVVOEi06K2BGnaTkxVcVY3i3
         tG2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xTB2rvbHdT9dtL5MF50csZwyabzYfgL7Ys+DI5bY+gw=;
        b=GsXxqU3wAvTyYnc+G0ggd+8+E8PRE8A7p0e5iWQpujz1ytRXyGE0c6EQoKim+QChGv
         cTDi/+RlaraHZtYGTlcusN0IsUbmM1OjkepBbB1i3e6gpmHtdxCRSGdJORIGa1dZkIo6
         VnMwfdcD9CoArA4ZPACgwW8ZOCJsAgA5GHsuVtoqy8QqhyCa4x/ztr1kv3OLwCAmLK2w
         6AtmCgPQbeYX9IJ000U0w86rFI+2vNr4gasN04Y2MNCJKuPzjLq18rYCME0+oAc3x/j3
         Rn0GURs2jvER4S6XGjxcAtbd35l9rXy2nzEHfqx+x8evR7SByVdy7aH963qYxnTCD0Ah
         uUEQ==
X-Gm-Message-State: AOAM533g+RMykWxQ0A0/1pyRajvk2dXZDEN6SQkPFNUFsNaRtVNnwMmX
        QdMPvpfzQ9PAfESfncHQq/l0djbyEP3ojfk6DP4=
X-Google-Smtp-Source: ABdhPJyMTPvE6njUlI21+DZ+bucvJyt/fdXQuyljP3JG43YMotimNibvpvawTznutxh0UK65bRhf8PrL6aoassA+Lzc=
X-Received: by 2002:a25:5054:: with SMTP id e81mr5684764ybb.510.1628894571635;
 Fri, 13 Aug 2021 15:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210809194742.1489985-1-jiang.wang@bytedance.com>
In-Reply-To: <20210809194742.1489985-1-jiang.wang@bytedance.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Aug 2021 15:42:40 -0700
Message-ID: <CAEf4BzZe-Kmoj4HKe0oiDMq_KaSQAfdVAEqksd3d8Tx7cX+Ftw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 0/5] sockmap: add sockmap support for unix
 stream socket
To:     Jiang Wang <jiang.wang@bytedance.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 12:47 PM Jiang Wang <jiang.wang@bytedance.com> wrote:
>
> This patch series add support for unix stream type
> for sockmap. Sockmap already supports TCP, UDP,
> unix dgram types. The unix stream support is similar
> to unix dgram.
>
> Also add selftests for unix stream type in sockmap tests.
>

Hey Jiang,

This patch doesn't apply cleanly to bpf-next anymore ([0]), can you
please rebase and resubmit, adding John's and Jakub's acks along the
way? Thanks!

  [0] https://github.com/kernel-patches/bpf/pull/1563#issuecomment-896128082

>
> Jiang Wang (5):
>   af_unix: add read_sock for stream socket types
>   af_unix: add unix_stream_proto for sockmap
>   selftest/bpf: add tests for sockmap with unix stream type.
>   selftest/bpf: change udp to inet in some function names
>   selftest/bpf: add new tests in sockmap for unix stream to tcp.
>
>  include/net/af_unix.h                         |  8 +-
>  net/unix/af_unix.c                            | 91 +++++++++++++++---
>  net/unix/unix_bpf.c                           | 93 ++++++++++++++-----
>  .../selftests/bpf/prog_tests/sockmap_listen.c | 48 ++++++----
>  4 files changed, 187 insertions(+), 53 deletions(-)
>
> v1 -> v2 :
>  - Call unhash in shutdown.
>  - Clean up unix_create1 a bit.
>  - Return -ENOTCONN if socket is not connected.
>
> v2 -> v3 :
>  - check for stream type in update_proto
>  - remove intermediate variable in __unix_stream_recvmsg
>  - fix compile warning in unix_stream_recvmsg
>
> v3 -> v4 :
>  - remove sk_is_unix_stream, just check TCP_ESTABLISHED for UNIX sockets.
>  - add READ_ONCE in unix_dgram_recvmsg
>  - remove type check in unix_stream_bpf_update_proto
>
> v4 -> v5 :
>  - add two missing READ_ONCE for sk_prot.
>
> v5 -> v6 :
>  - fix READ_ONCE by reading to a local variable first.
>
> --
> 2.20.1
>
