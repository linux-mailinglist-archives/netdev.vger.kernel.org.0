Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FB81742F3
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 00:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgB1XVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 18:21:41 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34246 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgB1XVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 18:21:41 -0500
Received: by mail-qt1-f193.google.com with SMTP id l16so3382584qtq.1;
        Fri, 28 Feb 2020 15:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=irfR243etnowtrBaZTxlqkSN/p6uwkEixC/FhFjbiBA=;
        b=vTYUSomiDcqQLb9RWmLAPHrVWnwGu44FmvFb0qyvJEChBSSF1gkvJ6Y91juxUtVmLv
         yW4APRnbDAI6bWzlfOgzWv9fY+IbXAqVYDH8LZ036bNkX9+8Y3T+rYY/uFoBkkoE0CBF
         TTyURT3zcx0igwUgXZl6cH+tXf303SRrAwWitybgD6Gb61XVwAsB5jrIpjjqxLjbk711
         sHYWO75/c2RRWswuVIpAwZ/xuXRs5+IwKoOL7n7++pMt03nhVg5sNblggTId2C4TAR16
         6oFC+/M51KqlZQr62mTqEx0bLCJZnobv4YqtNAPQm/NufjEiIIYFaCdM5mkmX4tSzgqk
         XEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=irfR243etnowtrBaZTxlqkSN/p6uwkEixC/FhFjbiBA=;
        b=HG1be9O7TgbKfX7AdmYBrIAycxUexikvrWNlc4rDo5bpf9U1pUtOYgs1FyrBYldjaw
         9r8wakuL0bPZoukBuz+VW0ATgYPebwyyXP1Wmtd5qMfT+vGeiSO/PTyqUWUoJO4KLSNu
         LjqmqgGBnwTy4gvDW5eh+2PrFkPxYkgGZcTmOyJejDSB4p4ypzh0766rU6n7HW3ZiSy3
         OHnG3F595//krPzjEYSDbVfLw31O4lNHdwBDBlfe6K2JGyfrbXIlVoz0FBKNpqO0Ana0
         4fNpMSIjZVoUeNV35lCMP4qW78EFlKxShlloG0/b7wFijnTmJbaBF2a2+9rtBZASLs22
         TWlQ==
X-Gm-Message-State: APjAAAWLDjCvZ3FA05RRUyZTPyIzeL8JIST7MBS+ORlBs4IKVHGdLcWS
        hPtGxglGDAsKjN3kcUk2lwse32YzSZy8GuPPV7M=
X-Google-Smtp-Source: APXvYqzJlz0qwxh4W38T6U8XtVqTY0BWG+pFj5Sz4URWaB4eX8OA+EPMVt9qD3TD5XsXVoBMhTlHVZIAJd5e1BzfHmY=
X-Received: by 2002:ac8:4581:: with SMTP id l1mr3577770qtn.59.1582932099922;
 Fri, 28 Feb 2020 15:21:39 -0800 (PST)
MIME-Version: 1.0
References: <158289973977.337029.3637846294079508848.stgit@toke.dk>
In-Reply-To: <158289973977.337029.3637846294079508848.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 28 Feb 2020 15:21:28 -0800
Message-ID: <CAEf4Bzaqr2uZca2iZvRpz54C-ohLsNK1sdN8daBr1qkRQ+NhWg@mail.gmail.com>
Subject: Re: [PATCH RFC] Userspace library for handling multiple XDP programs
 on an interface
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 6:22 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Hi everyone
>
> As most of you are no doubt aware, we've had various discussions on how
> to handle multiple XDP programs on a single interface. With the freplace
> functionality, the kernel infrastructure is now there to handle this
> (almost, see "missing pieces" below).
>
> While the freplace mechanism offers userspace a lot of flexibility in
> how to handle dispatching of multiple XDP programs, userspace also has
> to do quite a bit of work to implement this (compared to just issuing
> load+attach). The goal of this email is to get some feedback on a
> library to implement this, in the hope that we can converge on something
> that will be widely applicable, ensuring that both (a) everyone doesn't
> have to reinvent the wheel, and (b) we don't end up with a proliferation
> of subtly incompatible dispatcher models that makes it hard or
> impossible to mix and match XDP programs from multiple sources.
>

[...]

>
> **** Missing pieces
> While the libxdp code can assemble a basic dispatcher and load it into th=
e
> kernel, there are a couple of missing pieces on the kernel side; I will p=
ropose
> patches to fix these, but figured there was no reason to hold back postin=
g of
> the library for comments because of this. These missing pieces are:
>
> - There is currently no way to persist the freplace after the program exi=
ts; the
>   file descriptor returned by bpf_raw_tracepoint_open() will release the =
program
>   when it is closed, and it cannot be pinned.

This is completely addressed by patch set [0] I just posted. It will
allow you to pin freplace BPF link in BPF FS. Feel free to review and
comment there, if anything is missing.

  [0] https://patchwork.ozlabs.org/project/netdev/list/?series=3D161582&sta=
te=3D*

>
> - There is no way to re-attach an already loaded program to another funct=
ion;
>   this is needed for updating the call sequence: When a new program is lo=
aded,
>   libxdp should get the existing list of component programs on the interf=
ace and
>   insert the new one into the chain in the appropriate place. To do this =
it
>   needs to build a new dispatcher and reattach all the old programs to it=
.
>   Ideally, this should be doable without detaching them from the old disp=
atcher;
>   that way, we can build the new dispatcher completely, and atomically re=
place
>   it on the interface by the usual XDP attach mechanism.
>
> ---
>
> Toke H=C3=B8iland-J=C3=B8rgensen (1):
>       libxdp: Add libxdp (FOR COMMENT ONLY)
>
>
>  tools/lib/xdp/libxdp.c          |  856 +++++++++++++++++++++++++++++++++=
++++++
>  tools/lib/xdp/libxdp.h          |   38 ++
>  tools/lib/xdp/prog_dispatcher.h |   17 +
>  tools/lib/xdp/xdp-dispatcher.c  |  178 ++++++++
>  tools/lib/xdp/xdp_helpers.h     |   12 +
>  5 files changed, 1101 insertions(+)
>  create mode 100644 tools/lib/xdp/libxdp.c
>  create mode 100644 tools/lib/xdp/libxdp.h
>  create mode 100644 tools/lib/xdp/prog_dispatcher.h
>  create mode 100644 tools/lib/xdp/xdp-dispatcher.c
>  create mode 100644 tools/lib/xdp/xdp_helpers.h
>
