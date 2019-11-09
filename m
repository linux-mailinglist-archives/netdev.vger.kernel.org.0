Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B433EF6113
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 20:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfKITKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 14:10:51 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:43109 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfKITKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 14:10:50 -0500
Received: by mail-qv1-f66.google.com with SMTP id cg2so3482270qvb.10;
        Sat, 09 Nov 2019 11:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9lPvnsm9QLh6XHrfYmLhUjqAsas7/lxQyvL6wH13db8=;
        b=svj2YiRGXR/MgL2mcZYxgEUWFIhrCyq3q/bIZ8PpSfLoJDN6UDclrbx3NQW/nZuIdC
         5JdAtZMqm18MuucBWF+CKV4hywYusTIpK6AbGszxaOBoPOaLHlPgLt0p2BpxQPv1y7Ty
         tpYbPyCtwEjxWEZ/h2VcABRGorOl46hzJX0g5X9dh5c4m0SMcEQszRtvAxeGBIVYc2m4
         u9xhFst1FeYIUu+LDj7/cviHmQTkMmQd9jF+LEVUSlVc+Ubm1QnzNastJJB/YW4ing+d
         fH5f9kWQrPzB/PVuUYaSH9WOeMuVq4z/J2Ak0KN13hYsUSJRjy3zNXtXmLwOHfF1XXf1
         1axA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9lPvnsm9QLh6XHrfYmLhUjqAsas7/lxQyvL6wH13db8=;
        b=jyzifOU40dVHYO3iivIiaW18V5HYxHevtq28okFEoVgbORjIzyLprryb3bs+60mVrw
         e8TxOrZgpjIaElDnbOo5m85rASvRk6SUjrrN2oli9CQVhv1fb0wENbhMow6YgG4SILNF
         cCboUj3+E4hvmVXOlEC548DU6dcMbQjnYaxIkc74ywrHUv1rqIP+2EHTI6zy6S10pjTp
         ZznhvZifS73BTp6trsVJkPwfB7XICXWq9X/BJPlDtT0QBN1eE1r9CXV5ZMMQo3p0jkSx
         KcnldAg6UhXM9aOXpTcigMVEIo3gArYD38ETCpEjdYSCQ16vmKrrvfmjryD0LnKi/6o5
         cZgA==
X-Gm-Message-State: APjAAAUcI81z62nkz9OKtxyKfM5E3ojsR0jUwbVfDoG24/Hu+bRefZyy
        W4nNvNcTd76iAxDVRkkki65Ls0BwUd6URo3wSIk=
X-Google-Smtp-Source: APXvYqyhN7i9s1RJ6RSAMFHbHn1WovNgHhulAP6lRkD0vGIrnC7sMBFXk5s+WKn7zJ7r458nHj5R8nTqv/w5IiSSZfk=
X-Received: by 2002:a05:6214:90f:: with SMTP id dj15mr2479613qvb.224.1573326649545;
 Sat, 09 Nov 2019 11:10:49 -0800 (PST)
MIME-Version: 1.0
References: <157325765467.27401.1930972466188738545.stgit@toke.dk>
 <157325766011.27401.5278664694085166014.stgit@toke.dk> <CAEf4BzYvv6pCHygeNyOBE4MRtcLxE1XP4Ww+sxoaPgQw5i1Rjw@mail.gmail.com>
 <87mud5qosd.fsf@toke.dk>
In-Reply-To: <87mud5qosd.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 9 Nov 2019 11:10:38 -0800
Message-ID: <CAEf4BzbRGryvV+wYzOUECN3ceTZaGObtQQ3dQuaJJ4tTRbyyzw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 5/6] libbpf: Add bpf_get_link_xdp_info()
 function to get more XDP information
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 9, 2019 at 3:20 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Nov 8, 2019 at 4:01 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> Currently, libbpf only provides a function to get a single ID for the =
XDP
> >> program attached to the interface. However, it can be useful to get th=
e
> >> full set of program IDs attached, along with the attachment mode, in o=
ne
> >> go. Add a new getter function to support this, using an extendible
> >> structure to carry the information. Express the old bpf_get_link_id()
> >> function in terms of the new function.
> >>
> >> Acked-by: David S. Miller <davem@davemloft.net>
> >> Acked-by: Song Liu <songliubraving@fb.com>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  tools/lib/bpf/libbpf.h   |   10 ++++++
> >>  tools/lib/bpf/libbpf.map |    1 +
> >>  tools/lib/bpf/netlink.c  |   82 ++++++++++++++++++++++++++++++-------=
---------
> >>  3 files changed, 65 insertions(+), 28 deletions(-)
> >>
> >
> > [...]
> >
> >>
> >> -int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
> >> +int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
> >> +                         size_t info_size, __u32 flags)
> >>  {
> >>         struct xdp_id_md xdp_id =3D {};
> >>         int sock, ret;
> >>         __u32 nl_pid;
> >>         __u32 mask;
> >>
> >> -       if (flags & ~XDP_FLAGS_MASK)
> >> +       if (flags & ~XDP_FLAGS_MASK || info_size < sizeof(*info))
> >>                 return -EINVAL;
> >
> > Well, now it's backwards-incompatible: older program passes smaller
> > (but previously perfectly valid) sizeof(struct xdp_link_info) to newer
> > version of libbpf. This has to go both ways: smaller struct should be
> > supported as long as program doesn't request (using flags) something,
> > that can't be put into allowed space.
>
> But there's nothing to be backwards-compatible with? I get that *when*
> we extend the size of xdp_link_info, we should still accept the old,
> smaller size. But in this case that cannot happen as we're only just
> introducing this now?

This seems like a shifting burden to next person that will have to
extend this, but ok, fine by me.

>
> -Toke
