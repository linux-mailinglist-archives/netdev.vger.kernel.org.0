Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA6A3EC087
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 06:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbhHNEb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 00:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235780AbhHNEb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 00:31:56 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31848C0617AE
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 21:31:29 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id o20so19020224oiw.12
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 21:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=trxdMVQ5KE2YP5yvnKScVszVE8SqzwdPTILRnQVaJ1M=;
        b=x+GsK8bZhrM8+HG13n9myn7KnqIiZb/1gyMo3qxT0NXvFF9VbPvZO+jHrzNma4FKNQ
         lJUplLjqKCMVgc6QwobPe4rO/CMM1tbGBrdLYAsfFVrGenpg02EXuTyZKZTJtnqUmnrg
         FaMLNhOnmiW3En09myBUVftmG1BN/me920b36emrrIYl3kUubfnmWlfa6kTyuAPkoOTx
         vLeiWhP+fbDfYfEAopKDGm0yCMsG2aifnPGOkrqeGLJp1+aV/5JpqoXZgd1dFvf8o8bb
         lNNs6o/spzjxLH2TUf8EhMgAPG72DCgaQInEgbFTpKPaQIZz4S5eurCbSYTBT7Z4Oues
         x6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=trxdMVQ5KE2YP5yvnKScVszVE8SqzwdPTILRnQVaJ1M=;
        b=gacrnS5BNUEbL3XRHhhqkAmZxdjps/TaO7tYGcMTpaDVGBfZnu/Xh0ZsBTPrGDPv8K
         XbZv7eSAPFrSyplw6HGKRhZDOpEDpnWSUmY5u5smf/GKdCBCJCBdgruUKhzhujAvDZX3
         lhdzD0q4lp7vWPgA4UO9dpGoxfq5CrjQGGzuUQiHEOzGJqO7yLCrYCTOonS7R0Av7STQ
         /cwLXJzsrC3Vi+8dn95kXVV72zetIJXqPSgFIEtij1+smjtbMqtlz3uIn6bs+Zu0SBbI
         06SUOf0ATjyknWb0i59osbupk37lOYLClGhkjMqCu59+fhjEnzhZ0rD1SFnu9burooU1
         lRYg==
X-Gm-Message-State: AOAM531CHTARi8N7Dxrn/srfbr+0eYjjwYJKWmQf1LNf39XeZY3IL/0i
        ur7RpmgSeJdPJyaAq4xkR4M1PF9EbAdyZSYiJ162MA==
X-Google-Smtp-Source: ABdhPJwuR6+OhKaj+GqaApCHNsCgP1mRsAlEzLHwTrD7XiTtYCLV3kD2z1qF54HbnlGRtk0To9oPd1A/Oj1PNZu492M=
X-Received: by 2002:aca:2403:: with SMTP id n3mr4581565oic.109.1628915488554;
 Fri, 13 Aug 2021 21:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210809194742.1489985-1-jiang.wang@bytedance.com> <CAEf4BzZe-Kmoj4HKe0oiDMq_KaSQAfdVAEqksd3d8Tx7cX+Ftw@mail.gmail.com>
In-Reply-To: <CAEf4BzZe-Kmoj4HKe0oiDMq_KaSQAfdVAEqksd3d8Tx7cX+Ftw@mail.gmail.com>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Fri, 13 Aug 2021 21:31:17 -0700
Message-ID: <CAP_N_Z8Czh-hiKn3AwWb-Yib30805BOnVcY8urd=-2mVDctsjg@mail.gmail.com>
Subject: Re: Re: [PATCH bpf-next v6 0/5] sockmap: add sockmap support for unix
 stream socket
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?UTF-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
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

On Fri, Aug 13, 2021 at 3:42 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Aug 9, 2021 at 12:47 PM Jiang Wang <jiang.wang@bytedance.com> wrote:
> >
> > This patch series add support for unix stream type
> > for sockmap. Sockmap already supports TCP, UDP,
> > unix dgram types. The unix stream support is similar
> > to unix dgram.
> >
> > Also add selftests for unix stream type in sockmap tests.
> >
>
> Hey Jiang,
>
> This patch doesn't apply cleanly to bpf-next anymore ([0]), can you
> please rebase and resubmit, adding John's and Jakub's acks along the
> way? Thanks!
>

Sure, I just rebased, added ack and sent the patch again with the same title.
Let me know if there is any problem. Thanks.


>   [0] https://github.com/kernel-patches/bpf/pull/1563#issuecomment-896128082
>
> >
> > Jiang Wang (5):
> >   af_unix: add read_sock for stream socket types
> >   af_unix: add unix_stream_proto for sockmap
> >   selftest/bpf: add tests for sockmap with unix stream type.
> >   selftest/bpf: change udp to inet in some function names
> >   selftest/bpf: add new tests in sockmap for unix stream to tcp.
> >
> >  include/net/af_unix.h                         |  8 +-
> >  net/unix/af_unix.c                            | 91 +++++++++++++++---
> >  net/unix/unix_bpf.c                           | 93 ++++++++++++++-----
> >  .../selftests/bpf/prog_tests/sockmap_listen.c | 48 ++++++----
> >  4 files changed, 187 insertions(+), 53 deletions(-)
> >
> > v1 -> v2 :
> >  - Call unhash in shutdown.
> >  - Clean up unix_create1 a bit.
> >  - Return -ENOTCONN if socket is not connected.
> >
> > v2 -> v3 :
> >  - check for stream type in update_proto
> >  - remove intermediate variable in __unix_stream_recvmsg
> >  - fix compile warning in unix_stream_recvmsg
> >
> > v3 -> v4 :
> >  - remove sk_is_unix_stream, just check TCP_ESTABLISHED for UNIX sockets.
> >  - add READ_ONCE in unix_dgram_recvmsg
> >  - remove type check in unix_stream_bpf_update_proto
> >
> > v4 -> v5 :
> >  - add two missing READ_ONCE for sk_prot.
> >
> > v5 -> v6 :
> >  - fix READ_ONCE by reading to a local variable first.
> >
> > --
> > 2.20.1
> >
