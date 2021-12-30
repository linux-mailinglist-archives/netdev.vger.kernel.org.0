Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC8C48185B
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhL3CHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbhL3CHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:07:19 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C22C061574;
        Wed, 29 Dec 2021 18:07:19 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id bm14so92560111edb.5;
        Wed, 29 Dec 2021 18:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eziAz//rm+zZdRMe0WOS4XNDD8RYDjBI6BCQOt1ypTk=;
        b=hyudJDCbc80wPdgkm/SfS1OM+A0WKzuFaNGytS4b7WM3XABpQgK0Mhql4bzvoP8V6h
         nP3pF996IDP1yYRpOcEi+OeEr5OGOOUBjT6BJrSXYgQjdca/kYZ4mm8sqDc/HAu9leaa
         GFXj2QStD32fPQGyEpCgqnGiNCznoQNhPNjujanokAzCqZaKvEs6PEuqWiJrkWEl4DnY
         fmFk4fdkbX2YcazMT6A7Q44AdRseVaKIQzMehKEjGjfOG6UN4fcizMzUfCykCUQD/rjl
         VG9czivxN2NUi2LxJzrejxRDeLOFWOiUyaEFZ25vBCJq6mIuWDawkKM/u9Wy/4DpofcK
         dsSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eziAz//rm+zZdRMe0WOS4XNDD8RYDjBI6BCQOt1ypTk=;
        b=6yFK5dzT+NYEaeLdO+c4Tp4tEYxbx0Yt0Q31Zch+j4qDP/XufffZb/xnWbap6UEvf9
         rYRjx9wGyHAucbIGOmEdDhDhMrZXLrg8FOwwklh7c8lsFTVqSdgFN5HOO9BG7Lwwxzks
         rHjACtDx2r651DfkukDwZtaiTaxh2dpMbxqaMFkOdTSRPS+vJP4tHeVAO/bq0QEcnmox
         PL0OP5/eJGsToh1Eje41/RZb/FU0isFllU1zSBnH2qU/vKHQz6yZzOxlqHOxvpu2DdSw
         TgZBqKh30q2Vfc6eqln6+6wpiTjoKXGnaejf6hbcasWiJADrJJLsvPX+u4cYxep9BKoc
         wf7g==
X-Gm-Message-State: AOAM533Seg5TAPBeOGNB2L20ghGOZyrcaW6Q8/GO5RUFcexZQIGljlEk
        lx5107d8O28HMcolgThQKEmabLQc/Sx4SZDL/c4=
X-Google-Smtp-Source: ABdhPJw8+6Pp2hwBakFvTsIDO39nr/VX1akYVyLw1MK4MQdVxtjlkcOksCyYbGXStTKVcWdp6gKbDA6CeCQQA/Xs7fc=
X-Received: by 2002:a17:906:c156:: with SMTP id dp22mr24106682ejc.109.1640830037878;
 Wed, 29 Dec 2021 18:07:17 -0800 (PST)
MIME-Version: 1.0
References: <20211229113256.299024-1-imagedong@tencent.com> <CAADnVQLY2i+2YTj+Oi7+70e98sRC-t6rr536sc=3WYghpki+ug@mail.gmail.com>
In-Reply-To: <CAADnVQLY2i+2YTj+Oi7+70e98sRC-t6rr536sc=3WYghpki+ug@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 30 Dec 2021 10:04:08 +0800
Message-ID: <CADxym3Ya-=_zknyJmrQZ-fBKTK_PfPX1Njd=3pqYZR0_B8erJg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: bpf: add hook for close of tcp timewait sock
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 12:46 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Dec 29, 2021 at 3:33 AM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > The cgroup eBPF attach type 'CGROUP_SOCK_OPS' is able to monitor the
> > state change of a tcp connect with 'BPF_SOCK_OPS_STATE_CB' ops.
> >
> > However, it can't trace the whole state change of a tcp connect. While
> > a connect becomes 'TCP_TIME_WAIT' state, this sock will be release and
> > a tw sock will be created. While tcp sock release, 'TCP_CLOSE' state
> > change will be passed to eBPF program. Howeven, the real state of this
> > connect is 'TCP_TIME_WAIT'.
> >
> > To make eBPF get the real state change of a tcp connect, add
> > 'CGROUP_TWSK_CLOSE' cgroup attach type, which will be called when
> > tw sock release and tcp connect become CLOSE.
>
> The use case is not explained.

Sorry for the absence of use cases and selftests. In my case, it is for NAT of
a docker container.

Simply speaking, I'll add an element to a hash map during sys_connect() with
'BPF_SOCK_OPS_TCP_CONNECT_CB' ops of 'BPF_CGROUP_SOCK_OPS'
cgroup attach type. Therefore, the received packet of the host can do DNAT
according to the hash map.

I need to release the element in the hashmap when the connection closes.
With the help of 'BPF_SOCK_OPS_STATE_CB', I can monitor the TCP_CLOSE
of the connection. However, as I mentioned above, it doesn't work well when
it comes to tw sock. When the connect become 'FIN_WAIT2' or 'TIME_WAIT',
the state of the tcp sock becomes 'TCP_CLOSE', which doesn't match the connect
state. Therefore, the 'fin' packet that the host received can't be DNAT, as the
element is already removed.

In this patch, BPF_SOCK_OPS_TW_CLOSE_FLAG is introduced, which is used
make 'BPF_SOCK_OPS_STATE_CB' not called when this sock becomes
TCP_CLOSE if it is being replaced with a tw sock.

> Why bpf tracing cannot be used to achieve the same?

En...do you mean kprobe based eBPF trace? It can work, but I don't think it's
high-performance, especially for network NAT. Strictly speaking, attach types,
such as 'CGROUP_INET_SOCK_RELEASE', can be replaced by bpf tracing, but
they exist out of performance.

Thanks!
Menglong Dong

>
> Also there are no selftests.
