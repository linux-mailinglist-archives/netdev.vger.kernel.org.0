Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF5D18FC7D
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgCWSO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:14:59 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:35321 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgCWSO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:14:58 -0400
Received: by mail-qv1-f67.google.com with SMTP id q73so7729317qvq.2;
        Mon, 23 Mar 2020 11:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U9nHg1Fsfs9USL2RHzNiYQwaWR3+1XDpcwcqzRjKAwE=;
        b=l63AnaTQEt6g4nVe2gQiaus6hKPcIKjqvu6eG9Wwa8TywuWL5FWwBwneZuDtzBnet8
         hWO9w8gyZBPkGxeYppbhPJcYZm9Tshtq3PdMzb4PO0cKVpOcxKQFOAdltJk7L/0BTYAm
         guWywFHY/2bDNpGXFBUwychg/zPkewzX/SZkOxwmDXFY9XE9UmsC0Pffxj9FjCt3of7P
         RGyccMNzZ7qcWvdKTA67sC4Sg0CPhdI8pBTGSA2E9iNAhzRiAtDKz/aQPbxdyTfR3mbz
         4jmjE0RtMwu6fcQ3nhf+OUO+a5i5BMAdA5vwXDGGiid3WpjGTlIie+QieWWZUm18vWMb
         gfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U9nHg1Fsfs9USL2RHzNiYQwaWR3+1XDpcwcqzRjKAwE=;
        b=cVTyGeuydmHB57ENokQZ1gA/vZq2wwvkvc6V6qeGNaPf3YfHSEEMsSQGDwvoH1htce
         Fx5oSi8uA23Jf5WDblFbEkk1YHTpWFxyhtp5n6Cwbr2Tyf3OHRqm9/mZPFts3TrIb0El
         YEAckwZNVidqbVz2cGeJM7g/EmrTiqYeAP9MzS4xsxrQ+f6jds2tIPVEhC021hahjnY/
         leObaCgaa6KLU0t3FGaQaj2vRpBTxAK7yLDL5racP+EjGw7fYpeG4UpCeGSwzxD7oRdL
         Vz3CN8m/hrZUMOxB8gJ/uucvcyPygqeoXPDG4b8tI2VtQ8B85TfNj/safDlDhxjApxZX
         5VPw==
X-Gm-Message-State: ANhLgQ3fXvPJgz9uRkUOSIpxvImOKgJhiJ0P6eVP/UW80JYSFN9l0z5U
        f/OovrVgPsIoffYT0ADfzQuzAyFp/3MG3s7sYwo=
X-Google-Smtp-Source: ADFU+vvvsu1/w0ZjzuCMHVDJhRMPiQBBmcKV1TzHaWmaYGqZoN9KscpdZpFh5OP9b+JwTzGSVCdMgR7ToUfGi9UvFnU=
X-Received: by 2002:a0c:ee28:: with SMTP id l8mr21978318qvs.196.1584987297411;
 Mon, 23 Mar 2020 11:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com> <87tv2f48lp.fsf@toke.dk>
In-Reply-To: <87tv2f48lp.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Mar 2020 11:14:46 -0700
Message-ID: <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 4:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Mar 20, 2020 at 11:31 AM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> >>
> >> Jakub Kicinski wrote:
> >> > On Fri, 20 Mar 2020 09:48:10 +0100 Toke H=C3=B8iland-J=C3=B8rgensen =
wrote:
> >> > > Jakub Kicinski <kuba@kernel.org> writes:
> >> > > > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote:
> >> > > >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> > > >>
> >> > > >> While it is currently possible for userspace to specify that an=
 existing
> >> > > >> XDP program should not be replaced when attaching to an interfa=
ce, there is
> >> > > >> no mechanism to safely replace a specific XDP program with anot=
her.
> >> > > >>
> >> > > >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, =
which can be
> >> > > >> set along with IFLA_XDP_FD. If set, the kernel will check that =
the program
> >> > > >> currently loaded on the interface matches the expected one, and=
 fail the
> >> > > >> operation if it does not. This corresponds to a 'cmpxchg' memor=
y operation.
> >> > > >>
> >> > > >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to exp=
licitly
> >> > > >> request checking of the EXPECTED_FD attribute. This is needed f=
or userspace
> >> > > >> to discover whether the kernel supports the new attribute.
> >> > > >>
> >> > > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.co=
m>
> >> > > >
> >> > > > I didn't know we wanted to go ahead with this...
> >> > >
> >> > > Well, I'm aware of the bpf_link discussion, obviously. Not sure wh=
at's
> >> > > happening with that, though. So since this is a straight-forward
> >> > > extension of the existing API, that doesn't carry a high implement=
ation
> >> > > cost, I figured I'd just go ahead with this. Doesn't mean we can't=
 have
> >> > > something similar in bpf_link as well, of course.
> >> >
> >> > I'm not really in the loop, but from what I overheard - I think the
> >> > bpf_link may be targeting something non-networking first.
> >>
> >> My preference is to avoid building two different APIs one for XDP and =
another
> >> for everything else. If we have userlands that already understand link=
s and
> >> pinning support is on the way imo lets use these APIs for networking a=
s well.
> >
> > I agree here. And yes, I've been working on extending bpf_link into
> > cgroup and then to XDP. We are still discussing some cgroup-specific
> > details, but the patch is ready. I'm going to post it as an RFC to get
> > the discussion started, before we do this for XDP.
>
> Well, my reason for being skeptic about bpf_link and proposing the
> netlink-based API is actually exactly this, but in reverse: With
> bpf_link we will be in the situation that everything related to a netdev
> is configured over netlink *except* XDP.

One can argue that everything related to use of BPF is going to be
uniform and done through BPF syscall? Given variety of possible BPF
hooks/targets, using custom ways to attach for all those many cases is
really bad as well, so having a unifying concept and single entry to
do this is good, no?

>
> Other than that, I don't see any reason why the bpf_link API won't work.
> So I guess that if no one else has any problem with BPF insisting on
> being a special snowflake, I guess I can live with it as well... *shrugs*=
 :)

Apart from derogatory remark, BPF is a bit special here, because it
requires every potential BPF hook (be it cgroups, xdp, perf_event,
etc) to be aware of BPF program(s) and execute them with special
macro. So like it or not, it is special and each driver supporting BPF
needs to implement this BPF wiring.

>
> -Toke
>
