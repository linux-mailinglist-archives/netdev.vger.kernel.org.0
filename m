Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E666D1A09F3
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 11:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgDGJUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 05:20:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35181 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726591AbgDGJUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 05:20:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586251245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zHheQ4cXaiXVgGbo8v83Bgx9sbs24SZb8yrhs6z5g9c=;
        b=FZL7H5kR4/R37Jf1yBOoqjXILn4yN3juGDGXa/Ja1YXkHsvYkQfXCtZQ6Z4rPkUiGLM3s7
        rISi89buTt5A1Euu/avYuie/6J2L35/x8TKi0xwleuUhLVpbufLFmt77W0S/J44/E8aa1l
        mUnmC8dULSNboyeHSqLXJDWWnuvM7U0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-aOimOKH3N922fxLnouYm4Q-1; Tue, 07 Apr 2020 05:20:43 -0400
X-MC-Unique: aOimOKH3N922fxLnouYm4Q-1
Received: by mail-lj1-f200.google.com with SMTP id k13so324523ljg.12
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 02:20:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zHheQ4cXaiXVgGbo8v83Bgx9sbs24SZb8yrhs6z5g9c=;
        b=kTKupQZJPcyD2AnuUcM6hryS0OI0TR9anSY31Ps4bnLafjlNFnWG/cZi08H6ZcYCBt
         Qg0W36K6KkanodgIL49n9LpqsV3ifmIF0NygDo1jSs9cxMAI5ksD0gwV2eF0crnCUUEO
         kI+tTPcEZgne69r3nTq8Mq1u3FkUF3FLY/sMUKf7dlMHw/qMLvjrS7zo7UHPavH8F+u6
         SlFrG4VGKg2ZvH3rnUip4fjlib0BqtoRHuEy0iYS60OVHbOykM6B4f110lNlSxY0szzH
         h+VBGZAEJ8WafBPEfz2AxevTz2e5DPrAaBXQ/ab8CAFxYlh67+E1q2tZVLP/0G9L5gWp
         wKtg==
X-Gm-Message-State: AGi0PuabwH4eAi3tTufCPtqB0KSw0aJ5Auc5GrIA6A2cg8PkoKZwJqQa
        mN9qZIaeL97ugpketbKPxgvXmKS3OsSkocNUW3l2jZ5q1aMatYRAnQkX+spogf5KfTOC/uKFSub
        adeI9TVqtODvMryvZ
X-Received: by 2002:a05:651c:113:: with SMTP id a19mr1118143ljb.167.1586251242448;
        Tue, 07 Apr 2020 02:20:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypJSBwRiwTlfH3R7I/88M5kzTyq71MYwQLlb/KbRH0EOaBB/nsLP1m3lQ1L0421ng6GvXDJV+A==
X-Received: by 2002:a05:651c:113:: with SMTP id a19mr1118133ljb.167.1586251242217;
        Tue, 07 Apr 2020 02:20:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r2sm12883940lfn.35.2020.04.07.02.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 02:20:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2866D1804E7; Tue,  7 Apr 2020 11:20:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
In-Reply-To: <20200407014455.u7x36kkfmxcllqa6@ast-mbp.dhcp.thefacebook.com>
References: <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com> <20200326195340.dznktutm6yq763af@ast-mbp> <87o8sim4rw.fsf@toke.dk> <20200402202156.hq7wpz5vdoajpqp5@ast-mbp> <87o8s9eg5b.fsf@toke.dk> <20200402215452.dkkbbymnhzlcux7m@ast-mbp> <87ftdldkvl.fsf@toke.dk> <20200407014455.u7x36kkfmxcllqa6@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 07 Apr 2020 11:20:39 +0200
Message-ID: <87r1wzabyw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Apr 03, 2020 at 10:38:38AM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>=20
>> > It's a different link.
>> > For fentry/fexit/freplace the link is pair:
>> >   // target           ...         bpf_prog
>> > (target_prog_fd_or_vmlinux, fentry_exit_replace_prog_fd).
>> >
>> > So for xdp case we will have:
>> > root_link =3D (eth0_ifindex, dispatcher_prog_fd) // dispatcher prog at=
tached to eth0
>> > link1 =3D (dispatcher_prog_fd, xdp_firewall1_fd) // 1st extension prog=
 attached to dispatcher
>> > link2 =3D (dispatcher_prog_fd, xdp_firewall2_fd) // 2nd extension prog=
 attached to dispatcher
>> >
>> > Now libxdp wants to update the dispatcher prog.
>> > It generates new dispatcher prog with more placeholder entries or new =
policy:
>> > new_dispatcher_prog_fd.
>> > It's not attached anywhere.
>> > Then libxdp calls new bpf_raw_tp_open() api I'm proposing above to cre=
ate:
>> > link3 =3D (new_dispatcher_prog_fd, xdp_firewall1_fd)
>> > link4 =3D (new_dispatcher_prog_fd, xdp_firewall2_fd)
>> > Now we have two firewalls attached to both old dispatcher prog and new=
 dispatcher prog.
>> > Both firewalls are executing via old dispatcher prog that is active.
>> > Now libxdp calls:
>> > bpf_link_udpate(root_link, dispatcher_prog_fd, new_dispatcher_prog_fd)
>> > which atomically replaces old dispatcher prog with new dispatcher prog=
 in eth0.
>> > The traffic keeps flowing into both firewalls. No packets lost.
>> > But now it goes through new dipsatcher prog.
>> > libxdp can now:
>> > close(dispatcher_prog_fd);
>> > close(link1);
>> > close(link2);
>> > Closing (and destroying two links) will remove old dispatcher prog
>> > from linked list in xdp_firewall1_prog->aux->linked_prog_list and from
>> > xdp_firewall2_prog->aux->linked_prog_list.
>> > Notice that there is no need to explicitly detach old dispatcher prog =
from eth0.
>> > link_update() did it while replacing it with new dispatcher prog.
>>=20
>> Yeah, this was the flow I had in mind already. However, what I meant was
>> that *from the PoV of an application consuming the link fd*, this would
>> lead to dangling links.
>>=20
>> I.e., an application does:
>>=20
>> app1_link_fd =3D libxdp_install_prog(prog1);
>>=20
>> and stores link_fd somewhere (just holds on to it, or pins it
>> somewhere).
>>=20
>> Then later, another application does:
>>=20
>> app2_link_fd =3D libxdp_install_prog(prog2);
>>=20
>> but this has the side-effect of replacing the dispatcher, so
>> app1_link_fd is now no longer valid.
>>=20
>> This can be worked around, of course (e.g., just return the prog_fd and
>> hide any link_fd details inside the library), but if the point of
>> bpf_link is that the application could hold on to it and use it for
>> subsequent replacements, that would be nice to have for consumers of the
>> library as well, no?
>
> link is a pair of (hook, prog). I don't think that single bpf-link (FD)
> should represent (hook1, hook2, hook3, prog). It will be super confusing =
to the
> user space when single FD magically turns into multi attach.

I do agree with this, actually, and mostly brought it up as a point of
discussion to see if we could come up with something better. And I think
this:

> bpf_link_update_hook(app1_link1_fd, app1_link2_fd);
> here I'm proposing a new operation that will close 2nd link and will upda=
te
> hook of the first link with the hook of 2nd link if prog is the same.
> Conceptually it's a similar operation to bpf_link_update() which replaces=
 bpf
> prog in the hook. bpf_link_update_hook() can replace the hook while keepi=
ng the
> program the same.

will work for me, so great! :)

-Toke

