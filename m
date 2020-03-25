Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FB193016
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgCYSL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:11:56 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43897 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgCYSL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:11:56 -0400
Received: by mail-pl1-f196.google.com with SMTP id v23so1105315ply.10;
        Wed, 25 Mar 2020 11:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1ZGfQxjqN8pTrObO9fdvv2ieFFASvJUrZqBphbWo9t0=;
        b=J7rdu7pTM1Xfh6TGoapJ2ThnkPNyf1xBUMiaEJ/TJnWHlkK7Qz9bklOeif4x3FlJfJ
         o1F5rkhPwxkW5QLNexh2lK4lWwu3ljlzJN/ZhaCofAsE0IgFG/Ngg77Uak2rIjswzkdW
         8LcKP1ciu4pNKI1GAoUO8V0stIkXyA++z9Z3gHV/n7WLKZgX0rokcRhNoqqdiprfEPpz
         nKaqVuM1gZHRyaURrDVO1iDkndRnkFoBS73d9DQVY4Hv5jaxDvIdkR9FSbwyo7AxRC4x
         izY6hWnEx4N+3XwuiOK18jEpjltDsxSezrnyhsFk4l8AuP8ixySYSLguAdGTAj9uvQ/J
         mV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1ZGfQxjqN8pTrObO9fdvv2ieFFASvJUrZqBphbWo9t0=;
        b=tyUPZes4eJ/qUQupuQvRDrj9rUHLlnKZAx0VmWk4+UeA2csA7Y/D7ny1oBU0JHX9Sh
         NMBC5zcWo488nwAqw1YgLih/A9nbMNgOcKdVyTqekrFC1D0lTNVGTaM3bviIVuUHfJe0
         uFqK/18BQF4nA85P1DrsYT4ASq9Od01XKvLk/yfXmsqoBeMv23uwaH5n1KOp7lzSsdNK
         zHA8yWynCr0SF92rwgpDyC8sL3UDWMl+cGy+ks8clbq7PybLwZiq2exwZwf/CgRIMTJi
         stNJbClR/Zs1kC/FhuqejGWcL1s12ZNb+/Tps2qB4LixkEGOJbZ4R3c+kXeJPKwcbkze
         /kYw==
X-Gm-Message-State: ANhLgQ2G+uIokZ1HG6fno0hyCkbP5yYPCaeBzDg7je48/nhsk6dSrtW2
        Gwk1/DtGeA6VD2uyrSrKAZc=
X-Google-Smtp-Source: ADFU+vuZJS0/DSIo0pgwjhevct8zfc2KygDlKeWYExigBBW0RFIJpSUkRZElyumlDXXLktJjEMQ94g==
X-Received: by 2002:a17:902:9a8a:: with SMTP id w10mr4392873plp.218.1585159914236;
        Wed, 25 Mar 2020 11:11:54 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:b339])
        by smtp.gmail.com with ESMTPSA id h95sm4927989pjb.46.2020.03.25.11.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 11:11:53 -0700 (PDT)
Date:   Wed, 25 Mar 2020 11:11:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200325181150.ibqpvibo5yncrjaw@ast-mbp>
References: <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <5e7a5e07d85e8_74a82ad21f7a65b88d@john-XPS-13-9370.notmuch>
 <20200325013631.vuncsvkivexdb3fr@ast-mbp>
 <87wo78pvf2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wo78pvf2.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 11:42:57AM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Tue, Mar 24, 2020 at 12:22:47PM -0700, John Fastabend wrote:
> >> > 
> >> > Well, I wasn't talking about any of those subsystems, I was talking
> >> > about networking :)
> >> 
> >> My experience has been that networking in the strict sense of XDP no
> >> longer exists on its own without cgroups, flow dissector, sockops,
> >> sockmap, tracing, etc. All of these pieces are built, patched, loaded,
> >> pinned and otherwise managed and manipulated as BPF objects via libbpf.
> >> 
> >> Because I have all this infra in place for other items its a bit odd
> >> imo to drop out of BPF apis to then swap a program differently in the
> >> XDP case from how I would swap a program in any other place. I'm
> >> assuming ability to swap links will be enabled at some point.
> >> 
> >> Granted it just means I have some extra functions on the side to manage
> >> the swap similar to how 'qdisc' would be handled today but still not as
> >> nice an experience in my case as if it was handled natively.
> >> 
> >> Anyways the netlink API is going to have to call into the BPF infra
> >> on the kernel side for verification, etc so its already not pure
> >> networking.
> >> 
> >> > 
> >> > In particular, networking already has a consistent and fairly
> >> > well-designed configuration mechanism (i.e., netlink) that we are
> >> > generally trying to move more functionality *towards* not *away from*
> >> > (see, e.g., converting ethtool to use netlink).
> >> 
> >> True. But BPF programs are going to exist and interop with other
> >> programs not exactly in the networking space. Actually library calls
> >> might be used in tracing, cgroups, and XDP side. It gets a bit more
> >> interesting if the "same" object file (with some patching) runs in both
> >> XDP and sockops land for example.
> >
> > Thanks John for summarizing it very well.
> > It looks to me that netlink proponents fail to realize that "bpf for
> > networking" goes way beyond what netlink is doing and capable of doing in the
> > future. BPF_*_INET_* progs do core networking without any smell of netlink
> > anywhere. "But, but, but, netlink is the way to configure networking"... is
> > simply not true.
> 
> That was not what I was saying. Obviously there are other components to
> the networking stack than netlink.
> 
> What I'm saying is that netlink is the interface the kernel uses to
> *configure network devices*. And that attaching an XDP program is a
> network device configuration operation. I mean, it:
> 
> - Relies on the RTNL lock for synchronisation
> - Fundamentally alters the flow of network packets on the device
> - Potentially has side effects like link up/down, HWQ reconfig etc

sure. Attaching a prog to ingress qdisc can be considered a 'configuration'
of qdisc because rtnl is needed and what not.
That doesn't contradict my point that other apis (not only netlink) take
rtnl lock, etc.

> I'm wondering if there's a way to reconcile these views? Maybe making
> the bpf_link attachment work by passing the link fd to the netlink API?

what kind of frankenstein that would be?

> That would keep the network interface configuration over netlink, but
> would still allow a BPF application to swap out "its" programs via the
> bpf_link APIs?

It's not about swapping. bpf_link brings ownership concept in the first place.
It could be done via bpf syscall, new syscall, netlink, ioctl, you name it.
It's all secondary. The key concept is ownership.
