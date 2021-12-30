Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071FB481865
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhL3CM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbhL3CM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:12:27 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773EBC061574;
        Wed, 29 Dec 2021 18:12:27 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so21330681pjf.3;
        Wed, 29 Dec 2021 18:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P7pjKssQQLwhAkIor5tG8npn/57O5TDUpvN25CBe8Ds=;
        b=DG+L6db+rogMzNUe1DGlz2X7K5Lmp9Hmx5UQ/WSKS65sf6fIRLpzUQ2VpWwAjRO07y
         ahnHkKmUmR10trSUjE49cKU7zrUpbymStqJ772CSzXxn9QRBpj+1mT9k81XEX9LNecmd
         kpYzW5mW+FNCqmk41s+x9OJ6yxfs5zOmK6rDa100TAIrnDxYq1PNXzrQ1rWrt/wdjN8/
         44euohhpCNcN6Nn7i5YX2tI4wzKFN3u0yVE1d2WkWPPbxGlf8Ef87Mh/qd+0/vZBSOw3
         FRcIVUVDwr+KOAiZHSzhEDQjup6+oGBY+2yM0qWgsavtB9ehbAvwvQf/5N4FCRwO/AEg
         y4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P7pjKssQQLwhAkIor5tG8npn/57O5TDUpvN25CBe8Ds=;
        b=XfkUEY73XXpIsBzouoZgp1+LU0ZYgd75ysX2fdtmSboPWnQDtFrddFttJ2/wikbIvs
         xqNj3of9HYbmj4MqbHS56UMx3Gf8O0jGDtF2WrXF94sHOfSpPQBIuGMTAZ8Puj0pdlGr
         bLhXht7vFPfQSWhHvnKodXAXa1++Pv5qMOpAJomrdDUfEBDzCbNrPxxrDPmD2iwKklno
         2F/alS0NU884crjjXhTKC6s+7sDn4E9KEgaFfSz6lUxI08csxa00HMvH91HfQjCyPKxR
         wYq+DrAW8/SLpOAUN6KnPNl654pKxzRrm5TKjkSFcX8xzHXSYD/bAXgwXWpv983Hgvkt
         VycQ==
X-Gm-Message-State: AOAM532Mq/m2MNxGbm+13BA0SPjDiH4poOFlgvfq2M6ADEIJv0zuxkNn
        8260lYHOsaEnI+mn/8+3GuUOFgBH6GNqkNOyr7/nk7I+
X-Google-Smtp-Source: ABdhPJwSKttGjrXE/JJj9gbIMHr8nf9eadTeXoh+6rS7zqsFe+rdEa5+t3933jq5DEd3KhGhr4hbe6yuJ9OGbLqHfXc=
X-Received: by 2002:a17:902:c443:b0:148:f689:d924 with SMTP id
 m3-20020a170902c44300b00148f689d924mr29114288plm.78.1640830346345; Wed, 29
 Dec 2021 18:12:26 -0800 (PST)
MIME-Version: 1.0
References: <20211229113256.299024-1-imagedong@tencent.com>
 <CAADnVQLY2i+2YTj+Oi7+70e98sRC-t6rr536sc=3WYghpki+ug@mail.gmail.com> <CADxym3Ya-=_zknyJmrQZ-fBKTK_PfPX1Njd=3pqYZR0_B8erJg@mail.gmail.com>
In-Reply-To: <CADxym3Ya-=_zknyJmrQZ-fBKTK_PfPX1Njd=3pqYZR0_B8erJg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Dec 2021 18:12:15 -0800
Message-ID: <CAADnVQK6FTp1wACyhH0bNztT73DDr_wbCMbj7GorLRrOOQB2SA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: bpf: add hook for close of tcp timewait sock
To:     Menglong Dong <menglong8.dong@gmail.com>
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

On Wed, Dec 29, 2021 at 6:07 PM Menglong Dong <menglong8.dong@gmail.com> wrote:
>
> On Thu, Dec 30, 2021 at 12:46 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Dec 29, 2021 at 3:33 AM <menglong8.dong@gmail.com> wrote:
> > >
> > > From: Menglong Dong <imagedong@tencent.com>
> > >
> > > The cgroup eBPF attach type 'CGROUP_SOCK_OPS' is able to monitor the
> > > state change of a tcp connect with 'BPF_SOCK_OPS_STATE_CB' ops.
> > >
> > > However, it can't trace the whole state change of a tcp connect. While
> > > a connect becomes 'TCP_TIME_WAIT' state, this sock will be release and
> > > a tw sock will be created. While tcp sock release, 'TCP_CLOSE' state
> > > change will be passed to eBPF program. Howeven, the real state of this
> > > connect is 'TCP_TIME_WAIT'.
> > >
> > > To make eBPF get the real state change of a tcp connect, add
> > > 'CGROUP_TWSK_CLOSE' cgroup attach type, which will be called when
> > > tw sock release and tcp connect become CLOSE.
> >
> > The use case is not explained.
>
> Sorry for the absence of use cases and selftests. In my case, it is for NAT of
> a docker container.
>
> Simply speaking, I'll add an element to a hash map during sys_connect() with
> 'BPF_SOCK_OPS_TCP_CONNECT_CB' ops of 'BPF_CGROUP_SOCK_OPS'
> cgroup attach type. Therefore, the received packet of the host can do DNAT
> according to the hash map.
>
> I need to release the element in the hashmap when the connection closes.
> With the help of 'BPF_SOCK_OPS_STATE_CB', I can monitor the TCP_CLOSE
> of the connection. However, as I mentioned above, it doesn't work well when
> it comes to tw sock. When the connect become 'FIN_WAIT2' or 'TIME_WAIT',
> the state of the tcp sock becomes 'TCP_CLOSE', which doesn't match the connect
> state. Therefore, the 'fin' packet that the host received can't be DNAT, as the
> element is already removed.
>
> In this patch, BPF_SOCK_OPS_TW_CLOSE_FLAG is introduced, which is used
> make 'BPF_SOCK_OPS_STATE_CB' not called when this sock becomes
> TCP_CLOSE if it is being replaced with a tw sock.
>
> > Why bpf tracing cannot be used to achieve the same?
>
> En...do you mean kprobe based eBPF trace? It can work, but I don't think it's
> high-performance, especially for network NAT. Strictly speaking, attach types,
> such as 'CGROUP_INET_SOCK_RELEASE', can be replaced by bpf tracing, but
> they exist out of performance.

kprobe at the entry is pretty fast.
fentry is even faster. It's actually faster than cgroup based hook.
Give it a shot.
