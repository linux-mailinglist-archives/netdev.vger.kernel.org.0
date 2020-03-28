Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57AB8196A0F
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 00:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgC1Xfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 19:35:53 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38631 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbgC1Xfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 19:35:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id w3so5080892plz.5;
        Sat, 28 Mar 2020 16:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ACQeb6LQ4nfWUsrQ8+o5DuwseaQ8z40xUr8nUaFi+oM=;
        b=N46Q6MlTIsRy19tYannoaOxeLV/zARqXUmyYZzOz9/tO9PPTYw0s4gvF5GbVDubVF5
         sVfVDrNMk3BLw1zQKNvMlv+0FpjfAts+fbak7O+VLhsw/8BDwwsuSJNSkqhb7rydq+Of
         dSsalljOmP8mFh+e4C9YoyxTE1+al2wNmdnhbyPUqPbtr+9QnkXRXglLv6+UOER9UHoe
         acuCtzopKXY8fsuuXHrJon3okDKlpOZcngJJHugZXrX9ydsxubbLuKupoKmVroFYv8L6
         a9zmxzCf3nHul0Kfpr24nugW0nITPjHxs+BFdfumCg4o6aF7Gg7gb8xqMIXxwJDDFMD1
         26gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ACQeb6LQ4nfWUsrQ8+o5DuwseaQ8z40xUr8nUaFi+oM=;
        b=gj/d6cpt4Mj81247et6CwOGMNaKAd4Syzt85RcX3x2i3D2/cY/BieLqr32cQQd65HB
         /2El3NLtyCxvJjYW+0Rkj+9SSg+aIzShSUUxWJMWtgqcJXb7Yt5Q0WTRPI3YvetTN6y6
         Ntud3B8akF/c9YfQ6zJ+etNP8qo9hVorWQKMHXRA06c++obWhdsMS3CKlA5ioOdxdh1Y
         qSBMpK6a4ZENriUWAWbaTFnquzrUDjI4VmfF6AN4Ie0DlSHo7uSK7NNfv7S9W7B23smQ
         m2pukL5K5OogaMLLJnhE1ZiPfAt/kszeIPDWOvwpGSBDC9blrH/U7R2Eku0LFKvGcqWu
         9bgA==
X-Gm-Message-State: ANhLgQ384Emom5kMFYUYSHOhlvnSh+C6RWRzCb8ci5AkyNQBxBshd+By
        EW71MWaDUmxqLEJeiGj0Iz0=
X-Google-Smtp-Source: ADFU+vvZjBe29kRFwqkFVAUzQk+N6c/uBxhQUPUjfDrdDRP3Npzd8Qs4er4w1ZvzyLRtOHF954Gc/Q==
X-Received: by 2002:a17:90a:ba04:: with SMTP id s4mr7500864pjr.128.1585438550260;
        Sat, 28 Mar 2020 16:35:50 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:d9cf])
        by smtp.gmail.com with ESMTPSA id g4sm7003939pfb.169.2020.03.28.16.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 16:35:49 -0700 (PDT)
Date:   Sat, 28 Mar 2020 16:35:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
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
Message-ID: <20200328233546.7ayswtraepw3ia2x@ast-mbp>
References: <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk>
 <20200327230047.ois5esl35s63qorj@ast-mbp>
 <87lfnll0eh.fsf@toke.dk>
 <20200328022609.zfupojim7see5cqx@ast-mbp>
 <87eetcl1e3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87eetcl1e3.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 08:34:12PM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Sat, Mar 28, 2020 at 02:43:18AM +0100, Toke Høiland-Jørgensen wrote:
> >> 
> >> No, I was certainly not planning to use that to teach libxdp to just
> >> nuke any bpf_link it finds attached to an interface. Quite the contrary,
> >> the point of this series is to allow libxdp to *avoid* replacing
> >> something on the interface that it didn't put there itself.
> >
> > Exactly! "that it didn't put there itself".
> > How are you going to do that?
> > I really hope you thought it through and came up with magic.
> > Because I tried and couldn't figure out how to do that with IFLA_XDP*
> > Please walk me step by step how do you think it's possible.
> 
> I'm inspecting the BPF program itself to make sure it's compatible.
> Specifically, I'm embedding a piece of metadata into the program BTF,
> using Andrii's encoding trick that we also use for defining maps. So
> xdp-dispatcher.c contains this[0]:
> 
> __uint(dispatcher_version, XDP_DISPATCHER_VERSION) SEC(XDP_METADATA_SECTION);
> 
> and libxdp will refuse to touch any program that it finds loaded on an
> iface which doesn't have this, or which has a version number that is
> higher than what the library understands.

so libxdp will do:
ifindex -> id of currently attached prog -> fd -> prog_info -> btf -> read map
-> find "dispatcher_version"
and then it will do replace_fd with new version of the dispatcher ?
I see how this approach helps the second set of races (from fd into "dispatcher_version")
when another libxdp is doing the same.
But there is still a race in query->id->fd. Much smaller though.
In that sense replace_fd is a better behaved prog replacement than
just calling bpf_set_link_xdp_fd() without XDP_FLAGS_UPDATE_IF_NOEXIST.
But not much. The libxdp doesn't own the attachment.
If replace_fd fails what libxdp is going to do?
Try the whole thing from the beginning?
ifindex -> id2 -> fd2 ...
Say it succeeded.
But the libxdp1 that won the first race has no clue that libxdp2
retried and there is a different dispatcher prog there.
So you'll add netlink notifiers for libxdp to watch ?
That would mean that some user space process has to be always running
while typical firewall doesn't need any user space. The firewall.rpm can 
install its prog with all firewall rules, permanently link it to
the interface and exit.
But let's continue. So single libxdp daemon is now waiting for notifications
or both libxdp1 and libxdp2 that are part of two firewalls that are
being 'yum installed' are waiting for notifications?
How fight between libxdp1 and libxdp2 to install what they want going
to be resolved?
If their versions are the same I think they will settle quickly
since both libraries will see dispatcher prog with expected version number, right?
What if versions are different? Older libxdp or newer libxdp suppose to give up?
If libxdp2 is newer it will still be able to use older dispatcher prog
that was installed by libxdp1, but it would need to disable all new
user facing library features?

I guess all that is acceptable behavior to some libxdp users.

> > I'm saying that without bpf_link for xdp libxdp has no ability to
> > identify an attachment that is theirs.
> 
> Ah, so *that* was what you meant with "unique attachment". It never
> occurred to me that answering this question ("is it my program?") was to
> be a feature of bpf_link; I always assumed that would be a property of
> the bpf_prog itself.
> 
> Any reason what I'm describing above wouldn't work for you?

I don't see how this is even apples to apples comparison.
Racy query via id with sort-of "atomic" replacement and no ownership
vs guaranteed attachment with exact ownership and no races.

> > I see two ways out of this stalemate:
> > 1. assume that replace_fd extension landed and develop libxdp further
> >    into fully fledged library. May be not a complete library, but at least
> >    for few more weeks. If then you still think replace_fd is enough
> >    I'll land it.
> > 2. I can land replace_fd now, but please don't be surprised that
> >    I will revert it several weeks from now when it's clear that
> >    it's not enough.
> >  
> > Which one do you prefer?
> 
> I prefer 2. Reverting if it does turn out that I'm wrong is fine. Heck,
> in that case I'll even send the revert myself :)

Ok. Applied.
