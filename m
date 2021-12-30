Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9006E481897
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhL3CfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbhL3CfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:35:08 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B64C061574;
        Wed, 29 Dec 2021 18:35:07 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id q14so85019883edi.3;
        Wed, 29 Dec 2021 18:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=voLAT29uQmvFJF1yqoF/u59oF12nNcayLd/i0yTgxcE=;
        b=klj5Ud/6/7miOoip7cY5kX6vd2XS1JM5PqfQMAR/wDWBgfJ/+aRM5qX84G97T+2zHG
         qOt8SK82PhSR/VkSudotU/i1X2B6mlv3+71Cp/9BXoxtKoOlKUdf5G03p0SHpE5ldoxK
         i86gtsfW0Hm+9gsl0vyJbn+ovdvnKsU4+yOMTfxHgKlLQvPKX1zOT7S0Xj+22iyyzFBM
         RPI3gRg+L0A4tquV2g8YkQwbOUuyTH9nQvi/iSG9qh5OLmm5EEzB+lUrvUqU5cATNdh7
         It4wdKwgMIo+ZK0EPnSVzSmfPnXADzgsdQ96KKDgIFvipo9RCvCWoGLNftolrh5jOcSb
         huRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=voLAT29uQmvFJF1yqoF/u59oF12nNcayLd/i0yTgxcE=;
        b=nb2yG/d39758/1A3Yz74LhqBjRGSXwXO+e3ee30IJFSiyo8G3aE2jF3RYwnQjewzDr
         FV8qx9PnSkFOeNffALqhgDk3F42rzo7x8Gzf8x1/Ga+wQUFdYUXs+F+OCHPIefuCPzcV
         IvakTUiBeEeYc6oC6g8z0h7HuakfEe0qkqEtr5IlP3H000PG6BDHy9Uwpspt+Xnmeu2S
         jcd3OCGO44zpMF1PY8mwSbPGZPRhfOO6+5ePg0wlkh7CCwxQrHGs99nV4Pv8H4HgOOvX
         fp/+TLyartO79YMvhgYsC6rl+xujkoqc21QAphCySir/6vcTOlCZvDgipt4xRz7TvjRy
         OowA==
X-Gm-Message-State: AOAM533PFRBay+j+CKVlG9VuC0l/gMSxxjl8HVlHSIcyqEMmPDHw9BUt
        pMTEr8fKvxaO+vqF7EsZgP11RKc/2gjFHiOiIZg=
X-Google-Smtp-Source: ABdhPJw937o5vB6F8C+kDTsx8+yArOSfCjgkhSCZSiguf2aPH1MvnlCTJMTYRNwkOehSKHALS7+jkbwgg9l9oh1O2Qc=
X-Received: by 2002:a17:907:d19:: with SMTP id gn25mr23597114ejc.456.1640831706603;
 Wed, 29 Dec 2021 18:35:06 -0800 (PST)
MIME-Version: 1.0
References: <20211229113256.299024-1-imagedong@tencent.com>
 <CAADnVQLY2i+2YTj+Oi7+70e98sRC-t6rr536sc=3WYghpki+ug@mail.gmail.com>
 <CADxym3Ya-=_zknyJmrQZ-fBKTK_PfPX1Njd=3pqYZR0_B8erJg@mail.gmail.com> <CAADnVQK6FTp1wACyhH0bNztT73DDr_wbCMbj7GorLRrOOQB2SA@mail.gmail.com>
In-Reply-To: <CAADnVQK6FTp1wACyhH0bNztT73DDr_wbCMbj7GorLRrOOQB2SA@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 30 Dec 2021 10:31:56 +0800
Message-ID: <CADxym3Yc6-=HgM+4-t9xoNDDSEoFQNy6iUSLj+EVGhNHjHF_wQ@mail.gmail.com>
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

On Thu, Dec 30, 2021 at 10:12 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Dec 29, 2021 at 6:07 PM Menglong Dong <menglong8.dong@gmail.com> wrote:
> >
> > On Thu, Dec 30, 2021 at 12:46 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Dec 29, 2021 at 3:33 AM <menglong8.dong@gmail.com> wrote:
> > > >
> > > > From: Menglong Dong <imagedong@tencent.com>
> > > >
> > > > The cgroup eBPF attach type 'CGROUP_SOCK_OPS' is able to monitor the
> > > > state change of a tcp connect with 'BPF_SOCK_OPS_STATE_CB' ops.
> > > >
> > > > However, it can't trace the whole state change of a tcp connect. While
> > > > a connect becomes 'TCP_TIME_WAIT' state, this sock will be release and
> > > > a tw sock will be created. While tcp sock release, 'TCP_CLOSE' state
> > > > change will be passed to eBPF program. Howeven, the real state of this
> > > > connect is 'TCP_TIME_WAIT'.
> > > >
> > > > To make eBPF get the real state change of a tcp connect, add
> > > > 'CGROUP_TWSK_CLOSE' cgroup attach type, which will be called when
> > > > tw sock release and tcp connect become CLOSE.
> > >
> > > The use case is not explained.
> >
> > Sorry for the absence of use cases and selftests. In my case, it is for NAT of
> > a docker container.
> >
> > Simply speaking, I'll add an element to a hash map during sys_connect() with
> > 'BPF_SOCK_OPS_TCP_CONNECT_CB' ops of 'BPF_CGROUP_SOCK_OPS'
> > cgroup attach type. Therefore, the received packet of the host can do DNAT
> > according to the hash map.
> >
> > I need to release the element in the hashmap when the connection closes.
> > With the help of 'BPF_SOCK_OPS_STATE_CB', I can monitor the TCP_CLOSE
> > of the connection. However, as I mentioned above, it doesn't work well when
> > it comes to tw sock. When the connect become 'FIN_WAIT2' or 'TIME_WAIT',
> > the state of the tcp sock becomes 'TCP_CLOSE', which doesn't match the connect
> > state. Therefore, the 'fin' packet that the host received can't be DNAT, as the
> > element is already removed.
> >
> > In this patch, BPF_SOCK_OPS_TW_CLOSE_FLAG is introduced, which is used
> > make 'BPF_SOCK_OPS_STATE_CB' not called when this sock becomes
> > TCP_CLOSE if it is being replaced with a tw sock.
> >
> > > Why bpf tracing cannot be used to achieve the same?
> >
> > En...do you mean kprobe based eBPF trace? It can work, but I don't think it's
> > high-performance, especially for network NAT. Strictly speaking, attach types,
> > such as 'CGROUP_INET_SOCK_RELEASE', can be replaced by bpf tracing, but
> > they exist out of performance.
>
> kprobe at the entry is pretty fast.
> fentry is even faster. It's actually faster than cgroup based hook.

Really? Doesn't it already consider the data copy of bpf_probe_read()?
After all,
sock based eBPF can read sock data directly.

What's more, I'm not sure bpf tracing is enough, because I do NAT not for all
the docker containers, which means not all tcp connect close should call my
eBPF program, and that's the advantage of cgroup based eBPF.

Thanks!
Menglong Dong

> Give it a shot.
