Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5EAE1328AE
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 15:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgAGOSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 09:18:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50433 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727658AbgAGOSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 09:18:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578406724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dwyvg67DJwvCEGPdHoUekyN8Sa5PQ1ZZpEVbYehHqHA=;
        b=TrgFYE/0gBEtHP/zcIeuEh5d7WBaWIZX+oiPJPcS83KrARnu//YzTuGXB11k3nDhgDOZsU
        ojz6XZ6VBLQjoW01IVHaX9kgsh8Iaxx3hsXi+WSa4VMM68ysZQ8LJIin2Pr5YCckJw/nuM
        /0Y3L/AzNYMm+SUgqfeEmhCW23UgLaY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-hJX-IzoYP_O4Y9aZC0i_tA-1; Tue, 07 Jan 2020 09:18:41 -0500
X-MC-Unique: hJX-IzoYP_O4Y9aZC0i_tA-1
Received: by mail-wm1-f71.google.com with SMTP id t17so1990367wmi.7
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 06:18:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dwyvg67DJwvCEGPdHoUekyN8Sa5PQ1ZZpEVbYehHqHA=;
        b=poIb5Z7/Fj5yE430qhD/EqmdWygsUHw4RUP3PNKyu/X05t3lkur4nW1G4are9UNML5
         OhuZp0IZpObwvzFfALGxKsaQCZtSTZW8jr3cXXxL8xCvBMR3uyc6HiI2PKUrq1GT07ku
         QZ4he2kOq3XUhPlwzY1rBC87Bh/MLXWZbOiNerSqzlYJUpxMn63ZlUgkiq/rxQqk4dcu
         SS9tg5qOwwHcYFGTecJz/eU3X6pAU2TV/UlXCLt087+ZVflBSqvCCsS/HScvgCWkRpIQ
         RPPBkx+MDNTM3PVl7HMS0nem67+vd5CWrZwnCBIqMM2FT9WzeL5gOfA94jtvoZpJvN3u
         4+SA==
X-Gm-Message-State: APjAAAWTsDNeOLU7iR4RPfZlP81UJXOgftEe+gbYD/zrBRuZW95nYWVw
        vhExNb5191f8DLcrI1uWYjhKFH1it03G5ZzXVsEN/AkpMVN2U06lfg0drh86l96bzvrLXsbtYOY
        9THA0b/9fhIefmkqo
X-Received: by 2002:a1c:1d8c:: with SMTP id d134mr41918260wmd.16.1578406720727;
        Tue, 07 Jan 2020 06:18:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqyADp7GmjQSBXAuaenLqVJaMkCyR6L3r4oLo9lEV9rc3vX9GlGTkB9BwXeNur20SHQoOH+swA==
X-Received: by 2002:a1c:1d8c:: with SMTP id d134mr41918230wmd.16.1578406720482;
        Tue, 07 Jan 2020 06:18:40 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v3sm78128561wru.32.2020.01.07.06.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 06:18:39 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 354FB180960; Tue,  7 Jan 2020 15:18:38 +0100 (CET)
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
In-Reply-To: <20200107145204.76710703@carbon>
References: <20191219061006.21980-1-bjorn.topel@gmail.com> <CAADnVQL1x8AJmCOjesA_6Z3XprFVEdWgbREfpn3CC-XO8k4PDA@mail.gmail.com> <20191220084651.6dacb941@carbon> <20191220102615.45fe022d@carbon> <87mubn2st4.fsf@toke.dk> <CAJ+HfNhLDi1MJAughKFCVUjSvdOfPUcbvO9=RXmXQBS6Q3mv3w@mail.gmail.com> <87zhezik3o.fsf@toke.dk> <20200107140544.6b860e28@carbon> <87r20biegi.fsf@toke.dk> <20200107145204.76710703@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 07 Jan 2020 15:18:38 +0100
Message-ID: <87o8vfic3l.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Tue, 07 Jan 2020 14:27:41 +0100
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>>=20
>> > On Tue, 07 Jan 2020 12:25:47 +0100
>> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>> >=20=20
>> >> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>> >>=20=20=20
>> >> > On Fri, 20 Dec 2019 at 11:30, Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:=20=20=20=20
>> >> >>
>> >> >> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> >> >>=20=20=20=20
>> >> > [...]=20=20=20=20
>> >> >> > I have now went over the entire patchset, and everything look pe=
rfect,
>> >> >> > I will go as far as saying it is brilliant.  We previously had t=
he
>> >> >> > issue, that using different redirect maps in a BPF-prog would ca=
use the
>> >> >> > bulking effect to be reduced, as map_to_flush cause previous map=
 to get
>> >> >> > flushed. This is now solved :-)=20=20=20=20
>> >> >>
>> >> >> Another thing that occurred to me while thinking about this: Now t=
hat we
>> >> >> have a single flush list, is there any reason we couldn't move the
>> >> >> devmap xdp_bulk_queue into struct net_device? That way it could al=
so be
>> >> >> used for the non-map variant of bpf_redirect()?
>> >> >>=20=20=20=20
>> >> >
>> >> > Indeed! (At least I don't see any blockers...)=20=20=20=20
>> >>=20
>> >> Cool, that's what I thought. Maybe I'll give that a shot, then, unless
>> >> you beat me to it ;)=20=20
>> >=20=20
>> > Generally sounds like a good idea.
>> >
>> > It this only for devmap xdp_bulk_queue?=20=20
>>=20
>> Non-map redirect only supports redirecting across interfaces (the
>> parameter is an ifindex), so yeah, this would be just for that.
>
> Sure, then you don't need to worry about below gotchas.
>
> I do like the idea, as this would/should solve the non-map redirect
> performance issue.

Yes, that was exactly my thought. Taking a stab at it now... :)

>> > Some gotchas off the top of my head.
>> >
>> > The cpumap also have a struct xdp_bulk_queue, which have a different
>> > layout. (sidenote: due to BTF we likely want rename that).
>> >
>> > If you want to generalize this across all redirect maps type. You
>> > should know, that it was on purpose that I designed the bulking to be
>> > map specific, because that allowed each map to control its own optimal
>> > bulking.  E.g. devmap does 16 frames bulking, cpumap does 8 frames (as
>> > it matches sending 1 cacheline into underlying ptr_ring), xskmap does
>> > 64 AFAIK (which could hurt-latency, but that is another discussion).=
=20=20
>>=20
>> Bj=C3=B6rn's patches do leave the per-type behaviour, they just get rid =
of
>> the per-map flush queues... :)
>
> Yes, I know ;-)

I know you do; was just a bit puzzled why you brought up all that other
stuff, and, well, had to answer something, didn't I? ;)

-Toke

