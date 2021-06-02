Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F795399287
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhFBS3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:29:38 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:40829 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhFBS3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:29:36 -0400
Received: by mail-lj1-f169.google.com with SMTP id u22so3802831ljh.7;
        Wed, 02 Jun 2021 11:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8UqDhXrXjsAxzr58NBRBsGjtJDHkgQVZ6cKClZ531zY=;
        b=ViFTnJXh801TRjKKj3i829MHXnMV6NvAvdOMnZKySEmLWpzUvVAKRccfZPdoKAS7AL
         jn5e8SG6OspXz3H3NRWqdL48aR3uKQoFzDe0T/wY3gg/FHkyNY8yM0B4punMfpTC4VSp
         rXUBtEQZOg5gSnvCn4CjKIaW69j/HtJe63tRgv7ePAr587hXVGXBUYxyGC+xvg1R9wj0
         sTq2XuRmQACXS6mRR0LUhUDPHFStiwmeTyzwPfGTz24qndtn7tE+jjXtJN36OSGwiIv2
         WY498QN+W7EZkBRcoY6oPJbFn7vmddfXRDnZ1j5zMMP4Zjtd5C/GbOiw/Billvdk6J36
         QgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8UqDhXrXjsAxzr58NBRBsGjtJDHkgQVZ6cKClZ531zY=;
        b=kau2KEEJe1FVKLJ3Q9dG650KKdr72ZU2sKnTUrTs/QUveJWqabAXl3lKlzHZ++mEKb
         EsP1CG1ULiCM2y7lmH9Zo3Bw9gfUnpxesL+9Rk+3ceZwjRShJjFy8//791bRTL8JiLZL
         zDNIwWpDgxBgI0wlyx/Z1HYYg0e+BhGiPTWvsnUmnT9PqS6omQAQmuZtjQUN9/Hj+bjk
         a9zotdj+hsmddTJNYwJjGBSKVL77GAVON+vFcOcSj1gNP4ZW+0KXeV6gb+HAx2Bn2cjB
         8ZL5nOFtFSglJeF1bJFtGP6J2DoK36Cow1zZAi8Umvq7fk0bJzI6QsjXqnxszD8z2IeG
         jpaQ==
X-Gm-Message-State: AOAM532F4Tvv3ZT2A3q+4EpsB1+J04wQINqZ0zAgNbm0mnc1+JtIBvOX
        lqUAEGBgeSZ+l9/wXzja16WcD28z9624QUUtmdg=
X-Google-Smtp-Source: ABdhPJxsBKRxQpr7tXw+0EuzmckLOWkArujX1A5ryUMwKzLh3yvcX9QyLrKqZyNUCEzvUM0LG3M7e++1C7kAute5220=
X-Received: by 2002:a2e:a489:: with SMTP id h9mr26720489lji.21.1622658412355;
 Wed, 02 Jun 2021 11:26:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
 <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
 <CAM_iQpXUBuOirztj3kifdFpvygKb-aoqwuXKkLdG9VFte5nynA@mail.gmail.com>
 <20210602020030.igrx5jp45tocekvy@ast-mbp.dhcp.thefacebook.com>
 <874kegbqkd.fsf@toke.dk> <20210602175436.axeoauoxetqxzklp@kafai-mbp> <20210602181333.3m4vz2xqd5klbvyf@apollo>
In-Reply-To: <20210602181333.3m4vz2xqd5klbvyf@apollo>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 2 Jun 2021 11:26:40 -0700
Message-ID: <CAADnVQJTJzxzig=1vvAUMXELUoOwm2vXq0ahP4mfhBWGsCm9QA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 11:14 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, Jun 02, 2021 at 11:24:36PM IST, Martin KaFai Lau wrote:
> > On Wed, Jun 02, 2021 at 10:48:02AM +0200, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote:
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > >
> > > >> > In general the garbage collection in any form doesn't scale.
> > > >> > The conntrack logic doesn't need it. The cillium conntrack is a =
great
> > > >> > example of how to implement a conntrack without GC.
> > > >>
> > > >> That is simply not a conntrack. We expire connections based on
> > > >> its time, not based on the size of the map where it residents.
> > > >
> > > > Sounds like your goal is to replicate existing kernel conntrack
> > > > as bpf program by doing exactly the same algorithm and repeating
> > > > the same mistakes. Then add kernel conntrack functions to allow lis=
t
> > > > of kfuncs (unstable helpers) and call them from your bpf progs.
> > >
> > > FYI, we're working on exactly this (exposing kernel conntrack to BPF)=
.
> > > Hoping to have something to show for our efforts before too long, but
> > > it's still in a bit of an early stage...
> > Just curious, what conntrack functions will be made callable to BPF?
>
> Initially we're planning to expose the equivalent of nf_conntrack_in and
> nf_conntrack_confirm to XDP and TC programs (so XDP one works without an =
skb,
> and TC one works with an skb), to map these to higher level lookup/insert=
.

To make sure we're on the same page...
I still strongly prefer to avoid exposing conntrack via stable helpers.
Pls use kfunc and unstable interface.
