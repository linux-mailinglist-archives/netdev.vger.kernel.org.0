Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA8413278C
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgAGN1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:27:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36299 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727658AbgAGN1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 08:27:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578403666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMfocC79KEEX1M+QAjVMMUyocf9wSjOM37B8czKfGfU=;
        b=N4JpqB+/bs6YZwRP/Slt2rGRKLR+ozgmGnXQjiHlqL12uY4STior7dONTyQ9Jg4VhBbzjO
        1MrxicElnOzP7OKEbuBygHHWpSmHxjZmicaDeap3eIHrmybrAJHASpLC4+IrBhdUsBUdGv
        aLsVoy3xuVdcLjTVy86EOpuzSq5CPEQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-H_zeRGY0O7Ch6SU83HPI7Q-1; Tue, 07 Jan 2020 08:27:43 -0500
X-MC-Unique: H_zeRGY0O7Ch6SU83HPI7Q-1
Received: by mail-wr1-f69.google.com with SMTP id r2so26427080wrp.7
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 05:27:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=rMfocC79KEEX1M+QAjVMMUyocf9wSjOM37B8czKfGfU=;
        b=AcfsLp9UH7aGWPH3g7sAh+Gh1IC6UXAx15CA5QWCuEy4vrD1CmhTZmeoeHodW0wp0t
         D8/UqJumrhf9rtVPFLCNKf57uac325/Xqzp0Qnj6SLFacUy1d8C4naCSzuotDSLg6T98
         yELU7PLIbg6GFhA2R/XcWFpm+amXMmtFARIoY5VtYPNMcGIBoBCmd9HG9AxQNvwaOR4T
         AMgcasuTlk9mkF24BHFj7M5wel7SbG+c5SzRRywhuEmLkoU75CWi41VTSDRHk/5hjxMR
         QGT1z2bmiFBEJBigl69F/69dO+Fs1Z4WEbrh52P2ojl/DOTzcgyjww5kJAJGOWJrJdpw
         IJbA==
X-Gm-Message-State: APjAAAVxUNSztUb3t6tWevTchrJH+Wa5CbxfY3dn41ZC38ucb3lG8vKm
        4yfvRVsTh0jbyBFxW6wd/a/b3pKwcr5khUw3QKpMkcOvGd5sJW2isgBQJrMRD4s2szZ7oNaxtgY
        zUEXW4nf5dtTPlwJh
X-Received: by 2002:adf:df0e:: with SMTP id y14mr41745958wrl.377.1578403662700;
        Tue, 07 Jan 2020 05:27:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwUXaHz6hx2/7xO//JHMw8mPcHq9qVdsCJpaSZeLyVlrM5Rsv9kmTnJNT2coB/nD3fr5/7AnA==
X-Received: by 2002:adf:df0e:: with SMTP id y14mr41745935wrl.377.1578403662501;
        Tue, 07 Jan 2020 05:27:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g21sm82342017wrb.48.2020.01.07.05.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 05:27:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 206FA180960; Tue,  7 Jan 2020 14:27:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v2 0/8] Simplify xdp_do_redirect_map()/xdp_do_flush_map() and XDP maps
In-Reply-To: <20200107140544.6b860e28@carbon>
References: <20191219061006.21980-1-bjorn.topel@gmail.com> <CAADnVQL1x8AJmCOjesA_6Z3XprFVEdWgbREfpn3CC-XO8k4PDA@mail.gmail.com> <20191220084651.6dacb941@carbon> <20191220102615.45fe022d@carbon> <87mubn2st4.fsf@toke.dk> <CAJ+HfNhLDi1MJAughKFCVUjSvdOfPUcbvO9=RXmXQBS6Q3mv3w@mail.gmail.com> <87zhezik3o.fsf@toke.dk> <20200107140544.6b860e28@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 07 Jan 2020 14:27:41 +0100
Message-ID: <87r20biegi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Tue, 07 Jan 2020 12:25:47 +0100
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>=20
>> > On Fri, 20 Dec 2019 at 11:30, Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:=20=20
>> >>
>> >> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> >>=20=20
>> > [...]=20=20
>> >> > I have now went over the entire patchset, and everything look perfe=
ct,
>> >> > I will go as far as saying it is brilliant.  We previously had the
>> >> > issue, that using different redirect maps in a BPF-prog would cause=
 the
>> >> > bulking effect to be reduced, as map_to_flush cause previous map to=
 get
>> >> > flushed. This is now solved :-)=20=20
>> >>
>> >> Another thing that occurred to me while thinking about this: Now that=
 we
>> >> have a single flush list, is there any reason we couldn't move the
>> >> devmap xdp_bulk_queue into struct net_device? That way it could also =
be
>> >> used for the non-map variant of bpf_redirect()?
>> >>=20=20
>> >
>> > Indeed! (At least I don't see any blockers...)=20=20
>>=20
>> Cool, that's what I thought. Maybe I'll give that a shot, then, unless
>> you beat me to it ;)
>=20=20
> Generally sounds like a good idea.
>
> It this only for devmap xdp_bulk_queue?

Non-map redirect only supports redirecting across interfaces (the
parameter is an ifindex), so yeah, this would be just for that.

> Some gotchas off the top of my head.
>
> The cpumap also have a struct xdp_bulk_queue, which have a different
> layout. (sidenote: due to BTF we likely want rename that).
>
> If you want to generalize this across all redirect maps type. You
> should know, that it was on purpose that I designed the bulking to be
> map specific, because that allowed each map to control its own optimal
> bulking.  E.g. devmap does 16 frames bulking, cpumap does 8 frames (as
> it matches sending 1 cacheline into underlying ptr_ring), xskmap does
> 64 AFAIK (which could hurt-latency, but that is another discussion).

Bj=C3=B6rn's patches do leave the per-type behaviour, they just get rid of
the per-map flush queues... :)

-Toke

