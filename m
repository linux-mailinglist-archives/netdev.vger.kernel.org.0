Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660A92544A2
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 13:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgH0L4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 07:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728836AbgH0Lyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 07:54:50 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16534C06121B
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:54:40 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id m23so5460319iol.8
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8+USI8ikGwM1YVVvEQswp7iF6TsNadsn4yeIDHk0x60=;
        b=iKPgt8S+hc3ldLTEfMwzYbyOW2bPHtZf2FLBepIe0Lb/Nl7GROM4sA5jMFIQ8TThaj
         7hD0DlbjWo2OBeGZcA/E48756aEptPNWWJA9he9tP15YfRp9mnnqdyqECxAd00QowRMT
         0Eu/H+z9WCp8lMWox8PIUwWGqikauK50Txrg7hfNybk74o0hLd5SZCKCWY48CvgdsHBr
         UMDXtqQqGYefaCTkIv136+mfOKOK+fVqTiSkRCumjBoAS6qVWURyXWF8TPijEe9apjX4
         JySNHI+pI2ZfhNPJNqmnQWPPj/ByOWTxtPWyc5+nKs+3dF2H6uhf69PxKNSIsQZWiLH7
         3bZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8+USI8ikGwM1YVVvEQswp7iF6TsNadsn4yeIDHk0x60=;
        b=Ea+LC5oVTok+hQXvCgdNkxAAq6k9y8NCsss5KSpIX+xN+BUk3uCOO42if2gwPBxeL6
         daiYNhOmQN1WwPmsliG9WP+ZQI8ts4IFsR0rxoLz/bxpoEqyGVayXgX3tYe8IaqaZdyC
         Y/+rKRoVDGDzwF1TagBAxfoDul08rSyKb8D7RpXkuNTCH5RtknK6m9qkAN3QIpWbErhx
         2+kkukuRJvkLMDqcLUIS2QKvIKMS+svWoHdFSo9FolyR4TZ6YrwHdpHil8JCICB477lY
         k6hqX94r1PDucLS2QMq3dyNOiVswJTYPH27ibsEu4P1FRBfXQ3dSRKL1HkblnUhjm9UN
         t3lw==
X-Gm-Message-State: AOAM532yRI7WTShlZJJTY82Bt0VJ7TwJRmxumbR007fh7VZXublTwvu2
        SUKi7Pp/n67AzixOmXu/DuJFiWbot/c4XxJcy9pRUA==
X-Google-Smtp-Source: ABdhPJxDt7pGRRQH12hccRAz5CdRFlNU9PBDsLVNqRw8lt88exBLdDxJiJ1WAlEYnsrXg/8+kO677G4mnlkkiBusRXI=
X-Received: by 2002:a05:6638:69d:: with SMTP id i29mr5435935jab.138.1598529279389;
 Thu, 27 Aug 2020 04:54:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200821151544.1211989-1-nicolas.rybowski@tessares.net>
 <20200824220100.y33yza2sbd7sgemh@ast-mbp.dhcp.thefacebook.com>
 <CACXrtpQCE-Yp9=7fbH9sB7-4k-OO12JD18JU=9GL_sYHcmnDtA@mail.gmail.com> <CAADnVQL1O3Ncr5iwmZx_5FgVrwbXmEWZfGm_ASrTcu0j6YGbiA@mail.gmail.com>
In-Reply-To: <CAADnVQL1O3Ncr5iwmZx_5FgVrwbXmEWZfGm_ASrTcu0j6YGbiA@mail.gmail.com>
From:   Nicolas Rybowski <nicolas.rybowski@tessares.net>
Date:   Thu, 27 Aug 2020 13:54:28 +0200
Message-ID: <CACXrtpSe0-E5sLH4k6Jmw_FDK=+yKdsPdiR9BDniOXC6NTQ=rQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] bpf: add MPTCP subflow support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        mptcp@lists.01.org, Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Wed, Aug 26, 2020 at 9:13 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 25, 2020 at 11:55 AM Nicolas Rybowski
> <nicolas.rybowski@tessares.net> wrote:
> >
> > Hi Alexei,
> >
> > Thanks for the feedback!
> >
> > On Tue, Aug 25, 2020 at 12:01 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Aug 21, 2020 at 05:15:38PM +0200, Nicolas Rybowski wrote:
> > > > Previously it was not possible to make a distinction between plain TCP
> > > > sockets and MPTCP subflow sockets on the BPF_PROG_TYPE_SOCK_OPS hook.
> > > >
> > > > This patch series now enables a fine control of subflow sockets. In its
> > > > current state, it allows to put different sockopt on each subflow from a
> > > > same MPTCP connection (socket mark, TCP congestion algorithm, ...) using
> > > > BPF programs.
> > > >
> > > > It should also be the basis of exposing MPTCP-specific fields through BPF.
> > >
> > > Looks fine, but I'd like to see the full picture a bit better.
> > > What's the point of just 'token' ? What can be done with it?
> >
> > The idea behind exposing only the token at the moment is that it is
> > the strict minimum required to identify all subflows linked to a
> > single MPTCP connection. Without that, each subflow is seen as a
> > "normal" TCP connection and it is not possible to find a link between
> > each other.
> > In other words, it allows the collection of all the subflows of a
> > MPTCP connection in a BPF map and then the application of per subflow
> > specific policies. More concrete examples of its usage are available
> > at [1].
> >
> > We try to avoid exposing new fields without related use-cases, this is
> > why it is the only one currently. And this one is very important to
> > identify MPTCP connections and subflows.
> >
> > > What are you thinking to add later?
> >
> > The next steps would be the exposure of additional subflow context
> > data like the backup bit or some path manager fields to allow more
> > flexible / accurate BPF decisions.
> > We are also looking at implementing Packet Schedulers [2] and Path
> > Managers through BPF.
> > The ability of collecting all the paths available for a given MPTCP
> > connection - identified by its token - at the BPF level should help
> > for such decisions but more data will need to be exposed later to take
> > smart decisions or to analyse some situations.
> >
> > I hope it makes the overall idea clearer.
> >
> > > Also selftest for new feature is mandatory.
> >
> > I will work on the selftests to add them in a v2. I was not sure a new
> > selftest was required when exposing a new field but now it is clear,
> > thanks!
> >
> >
> > [1] https://github.com/multipath-tcp/mptcp_net-next/tree/scripts/bpf/examples
> > [2] https://datatracker.ietf.org/doc/draft-bonaventure-iccrg-schedulers/
>
> Thanks! The links are certainly helpful.
> Since long term you're considering implementing path manager in bpf
> I suggest to take a look at bpf_struct_ops and bpf based tcp congestion control.
> It would fit that use case better.

We will definitively take a look at that, thanks ! It is indeed the
direction we should take.

> For now the approach proposed in this patch is probably good enough
> for simple subflow marking. From the example it's not clear what the networking
> stack is supposed to do with a different sk_mark.
> Also considering using sk local storage instead of sk_mark. It's arbitrary size.

Originally, this use-case was asked by Android for some app specific behaviours.
But the example is provided here to mainly illustrate the possibility
to put different sockopt per subflow knowing their relations with
other subflows.
Indeed in this example, per se, the marking of the subflows has no
interest, it is for illustration purpose only. It was an easy solution
to have quick tests in the userspace through nftables.

Also, the implementation of all the signals allowing dynamic subflows
creation / removal by the path manager to comply with the RFC [1] is
still under heavy development on the MPTCP side, so we cannot provide
more realistic examples at the moment.

[1] https://tools.ietf.org/html/rfc8684#section-3.4
