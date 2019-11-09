Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E81F6156
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfKIUSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:18:22 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20754 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726467AbfKIUSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:18:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573330701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpNImDgbX6CrN9F5zMf5J6tTs676iLLen+Es4U5ORCA=;
        b=F6cjrTDzxPlz86K7coAsyyN7mL47d/jbHTJLLbsu7sZ0CBGAFLgOX473kO+ArZeELBf8x0
        4zvXhwEwshGGzJqYAevMaZlaLFDNQhD4xAFHYBdKrrwX+amLpWbEn1PRDOfDfSsdkep70Q
        FVU/VkDDewIZPKwFL2JnWFMYAWkDR34=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-Jk-L5ReANQiDKpr9itpYHA-1; Sat, 09 Nov 2019 15:18:15 -0500
Received: by mail-ed1-f72.google.com with SMTP id f22so7330712edj.14
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 12:18:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bpNImDgbX6CrN9F5zMf5J6tTs676iLLen+Es4U5ORCA=;
        b=RZqE6ww26AV7t06f71sPKf60oet4w6EYZ9MJGiWDN6Ovv9NhQAZtfpwjg6AzLsyU/q
         Y2+FOARBIDnJfSyWQZgmpqmIChAwG/l9GGtC20djcd2IRY6xxH4wDNyi5FgMCeVqLkOs
         P99WjJ25e+8yiH/k9TNOfYl8PBpzAESV2hyRtpkkGCy1rWZx/urEKwjASG6QY7jZgOtt
         lUP10RqlumNtVfe2Sdz531aWhq0AWnoZehQxouWo7vNYN3+ZiBhN52iJoR1oirxz+94/
         MI3HAqcEEY/uLWhc//5SNYJutDW4Z0bEf8Tu4Hqej234wjtClaVE0S5h5iIGdBthCg2e
         3DWg==
X-Gm-Message-State: APjAAAU3BChco9LyQi7FP85YjxqNCXAdZ/VTul73IUfOFwwOHZYwoLho
        TTCYuP1tafZYnsv0qxVQ1OLfLkqETyYkU/qdvLAMwsIi0SwnVE1BfpzwLMIT6QtG0NTTWP1bti9
        pkTzpqOYbOl7CtRnM
X-Received: by 2002:a50:8a88:: with SMTP id j8mr18403889edj.35.1573330693972;
        Sat, 09 Nov 2019 12:18:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqz9ajcWD1uISQgAQ+w+JSnuvrm3D7eHQq0VDDaCm/6OB7paj0JCINQ/byAxpQ50f/bKNPXZLA==
X-Received: by 2002:a50:8a88:: with SMTP id j8mr18403879edj.35.1573330693779;
        Sat, 09 Nov 2019 12:18:13 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id z31sm266605edz.13.2019.11.09.12.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 12:18:13 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8BC931800CC; Sat,  9 Nov 2019 21:18:12 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 5/6] libbpf: Add bpf_get_link_xdp_info() function to get more XDP information
In-Reply-To: <CAEf4BzbRGryvV+wYzOUECN3ceTZaGObtQQ3dQuaJJ4tTRbyyzw@mail.gmail.com>
References: <157325765467.27401.1930972466188738545.stgit@toke.dk> <157325766011.27401.5278664694085166014.stgit@toke.dk> <CAEf4BzYvv6pCHygeNyOBE4MRtcLxE1XP4Ww+sxoaPgQw5i1Rjw@mail.gmail.com> <87mud5qosd.fsf@toke.dk> <CAEf4BzbRGryvV+wYzOUECN3ceTZaGObtQQ3dQuaJJ4tTRbyyzw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 09 Nov 2019 21:18:12 +0100
Message-ID: <87h83cregr.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: Jk-L5ReANQiDKpr9itpYHA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sat, Nov 9, 2019 at 3:20 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Fri, Nov 8, 2019 at 4:01 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
>> >>
>> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>
>> >> Currently, libbpf only provides a function to get a single ID for the=
 XDP
>> >> program attached to the interface. However, it can be useful to get t=
he
>> >> full set of program IDs attached, along with the attachment mode, in =
one
>> >> go. Add a new getter function to support this, using an extendible
>> >> structure to carry the information. Express the old bpf_get_link_id()
>> >> function in terms of the new function.
>> >>
>> >> Acked-by: David S. Miller <davem@davemloft.net>
>> >> Acked-by: Song Liu <songliubraving@fb.com>
>> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> ---
>> >>  tools/lib/bpf/libbpf.h   |   10 ++++++
>> >>  tools/lib/bpf/libbpf.map |    1 +
>> >>  tools/lib/bpf/netlink.c  |   82 ++++++++++++++++++++++++++++++------=
----------
>> >>  3 files changed, 65 insertions(+), 28 deletions(-)
>> >>
>> >
>> > [...]
>> >
>> >>
>> >> -int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
>> >> +int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
>> >> +                         size_t info_size, __u32 flags)
>> >>  {
>> >>         struct xdp_id_md xdp_id =3D {};
>> >>         int sock, ret;
>> >>         __u32 nl_pid;
>> >>         __u32 mask;
>> >>
>> >> -       if (flags & ~XDP_FLAGS_MASK)
>> >> +       if (flags & ~XDP_FLAGS_MASK || info_size < sizeof(*info))
>> >>                 return -EINVAL;
>> >
>> > Well, now it's backwards-incompatible: older program passes smaller
>> > (but previously perfectly valid) sizeof(struct xdp_link_info) to newer
>> > version of libbpf. This has to go both ways: smaller struct should be
>> > supported as long as program doesn't request (using flags) something,
>> > that can't be put into allowed space.
>>
>> But there's nothing to be backwards-compatible with? I get that *when*
>> we extend the size of xdp_link_info, we should still accept the old,
>> smaller size. But in this case that cannot happen as we're only just
>> introducing this now?
>
> This seems like a shifting burden to next person that will have to
> extend this, but ok, fine by me.

Well, there's a good chance that this could be myself ;)

However, in this case, since it's just a getter, and we're already doing
size checks on how much data we memcpy back, I suppose that we don't
actually need any minimum size at all, do we (well, apart from a check
for 0)? We can just always copy whatever size the caller passes in, and
they'll just get whatever portion of the struct that happens to be?

-Toke

