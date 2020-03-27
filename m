Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00BA195F6E
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgC0UKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:10:39 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:42456 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgC0UKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 16:10:39 -0400
Received: by mail-qv1-f67.google.com with SMTP id ca9so5560889qvb.9;
        Fri, 27 Mar 2020 13:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bQPqQaCr2BP7POKzSnMMa5s9klMZOk9k0p4wQFfkjjk=;
        b=hnAmxmEpH0rPovzE4G4LumprT8MRaxDcSeB3FZHKbdJ5kz9DNk7m9sQk9sOda6j530
         87vl+Pz6lFfR2IuFUZe3EOQK1Vqz/BESd678YsKlX/EKxAFErPpHD4uk8qrHS0GUD9iL
         FmrZUFBqe3CmvMr788PaZ1f3KM2ePrnKCcJBbRSdHRT97e/LdNjB7VQI6SiZFy/ZaBAq
         QtT+u0kRs6SsqnDeRQRWewvhVchA3Ku14BYH9hQO3yC0U+/lnnzXXZnu+LK+/CGz2xcP
         W1rQaSmq3UiI9kSvImxa4ZffgXcqrjAmN50dR9GXeg6CWUscIVfUZkqGsH2MCEFK2qdP
         Tb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bQPqQaCr2BP7POKzSnMMa5s9klMZOk9k0p4wQFfkjjk=;
        b=ajOUfqBopWpwhpMa5y3enqj2HqbMUNv079PSBchhJ6qmsfgSYzvQsiF5gV1vGum5St
         jgNv98ovzk6Vw1iPXFJPMcMQ3v7etnXJRll1M1kCu+XvZjH9+tTqZJn4DpXqJVtWNOyk
         FheGrTcpIxUgWgsWbEO7rj1+ea+dop4R5aonysxtrenNH0P9Qc28zVIoDXKJukutusjS
         RH8hSq037t+74bNYSmaEyCdivuXDAjVrBwyhY9W9E1r/tP7My0Tm6kv0yd01FfZU9kAC
         Et905Oh51VIhwGWAJY0Ca35cRcWeLei3ig5JpSYFMzfpwJHVtKRmSqLUltO81RMaO6yb
         PBtA==
X-Gm-Message-State: ANhLgQ0wi5I58L9pU+3otQqDNo/FCcojOobsERvtUQNFg16WJBBa0SRW
        XjyMeAAGal3GNbGXwwJ1BYXWoIqSSjm/aKAu7OY=
X-Google-Smtp-Source: ADFU+vs4PGPWBjzOxTWt5Rux+QUNCHji6zFL4jKemZj60moj7Ck54oIxLUJC9pJTGjzSEi5G+9sKiiY24YUad59G3ts=
X-Received: by 2002:a0c:bd2a:: with SMTP id m42mr988319qvg.163.1585339837848;
 Fri, 27 Mar 2020 13:10:37 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk> <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
 <CACAyw98yYE+eOx5OayyN2tNQeNqFXnHdRGSv6DYX7ehfMHt1+g@mail.gmail.com> <9f0ab343-939b-92e3-c1b8-38a158da10c9@gmail.com>
In-Reply-To: <9f0ab343-939b-92e3-c1b8-38a158da10c9@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Mar 2020 13:10:26 -0700
Message-ID: <CAEf4BzYuxS6VEy2S9OOdmXmsg=dXU2svSqpCsNdNzGjn-AHfHg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     David Ahern <dsahern@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 9:12 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/27/20 5:06 AM, Lorenz Bauer wrote:
> > However, this behaviour concerns me. It's like Windows not
> > letting you delete a file while an application has it opened, which just leads
> > to randomly killing programs until you find the right one. It's frustrating
> > and counter productive.
> >
> > You're taking power away from the operator. In your deployment scenario
> > this might make sense, but I think it's a really bad model in general. If I am
> > privileged I need to be able to exercise that privilege. This means that if
> > there is a netdevice in my network namespace, and I have CAP_NET_ADMIN
> > or whatever, I can break the association.
> >
> > So, to be constructive: I'd prefer bpf_link to replace a netlink attachment and
> > vice versa. If you need to restrict control, use network namespaces
> > to hide the devices, instead of hiding the bpffs.
>
> I had a thought yesterday along similar lines: bpf_link is about
> ownership and preventing "accidental" deletes. What's the observability
> wrt to learning who owns a program at a specific attach point and can
> that ever be hidden.

We are talking about adding LINK_QUERY command that will return
attached BPF program and ifindex or cgroup (or whatever else) that it
is attached to.

If it's about which applications holds open FD to bpf_link, it's the
same problem as with any other FD, I'm not sure there is a
well-defined solution to this problem. Using drgn script to get this
is one possible solution that can be implemented today without
extending any of kernel APIs.
