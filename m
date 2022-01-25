Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B4849AB78
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 06:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbiAYE4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 23:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S253634AbiAYEdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 23:33:07 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273BBC06176D;
        Mon, 24 Jan 2022 19:13:42 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o12so27001259eju.13;
        Mon, 24 Jan 2022 19:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ivBaPA0R2xGHgAcixmHyX5HNKPDkPQG35LIw/TIU16o=;
        b=Q+b4DIhxL8LbXNFxHPsE0+GdM0/Oda0/lsIMTXCz5JgrVJ/GEcG3sMtTxYKRBY63E2
         4LT5AhtlujNW1UJgs3zYyHo1X5Rk6szJp85Y05wDnXu+qnUzzAHIsSXdvfkfcewm3j4R
         LK/mR/JJuRstDWjsZ6x/GPWeIP/qF4FZw1+khfrqb4jUYUmfUe089YxzYai7cJoDA72h
         Nx+wVT4Z4hAjlR+NfZot8zXTLqNMxj6Ve+bZXTA8Ty9SLwcOPWyHEAdaMkberniv2VkG
         0pt93nJCgCrcz9tTctKXtioXkcABN0NXBhwOcku0TAoREKhsb0Lf4gpTB7R89QOb9Vr2
         tJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ivBaPA0R2xGHgAcixmHyX5HNKPDkPQG35LIw/TIU16o=;
        b=m30kAlmMvxVji8mkUddFd+DdND5z02e6P67rbLH6wb3Cfca8JldZQM+2ho5o6Eu242
         /kIdO29soeJB3pUeahWFICbH+EzzyeAwXh3QYpk03AdtCPjNpf6pm+jj1FdbV6E7nBnN
         3VFUl8WYUQKfZLXm/IBOdVkMu4XcfQzQRVXT2lK1wcFar4mhnn5N/DNQUxO8EapNQtzL
         q2DfbIKsUVPcweN/hSvNOr/ZlFi6aADvpfk4nVM42f67qs9QN6vTZlLKpqDZ3Pnrvp8X
         dJOMGwpeI2OqDPNp/aowa8ccTsx6iwhvpdb4Lj1xKdqLddPS4A9675rAXIfMrS00D8kF
         06VA==
X-Gm-Message-State: AOAM532QzDNvX43Vc5f1xq7LxxiqB3Tylos2a+ldwoUmV9EdeHtE7iAo
        M3oNZ2zEB5uZowsR3+6Ijc4g4GIU/IJ5IKjv14c=
X-Google-Smtp-Source: ABdhPJxfQpFj4wSo+5WJnCbnJbiiH1inTmzryC1G9al3TAqFcH3uVDs/BWTwUTa2M8wIstuAQCedA72lrEkiXGqm3go=
X-Received: by 2002:a17:906:17d5:: with SMTP id u21mr14538687eje.348.1643080420569;
 Mon, 24 Jan 2022 19:13:40 -0800 (PST)
MIME-Version: 1.0
References: <20220113070245.791577-1-imagedong@tencent.com>
 <CAADnVQKNCqUzPJAjSHMFr-Ewwtv5Cs3UCQpthaKDTd+YNRWqqg@mail.gmail.com>
 <CADxym3bJZrcGHKH8=kKBkxh848dijAZ56n0fm_DvEh6Bbnrezg@mail.gmail.com>
 <20220120041754.scj3hsrxmwckl7pd@ast-mbp.dhcp.thefacebook.com>
 <CADxym3b-Q6LyjKqTFcrssK9dVJ8hL6QkMb0MzLyn64r4LS=xtw@mail.gmail.com>
 <CAADnVQKaaPKPkqYfhcM=YNCxodBL_ME6CMk3DPXF_Kq2zoyM=w@mail.gmail.com> <20220125003522.dqbesxtfppoxcg2s@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220125003522.dqbesxtfppoxcg2s@kafai-mbp.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 25 Jan 2022 11:09:13 +0800
Message-ID: <CADxym3a+tGhG2L4NdTydW7F7F7XP3Bwzd_XgNdqnKYVY5y_7tg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct bpf_sock'
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mengen Sun <mengensun@tencent.com>, flyingpeng@tencent.com,
        mungerjiang@tencent.com, Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 8:35 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Jan 20, 2022 at 09:17:27PM -0800, Alexei Starovoitov wrote:
> > On Thu, Jan 20, 2022 at 6:18 AM Menglong Dong <menglong8.dong@gmail.com> wrote:
> > >
> > > On Thu, Jan 20, 2022 at 12:17 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Thu, Jan 20, 2022 at 11:02:27AM +0800, Menglong Dong wrote:
> > > > > Hello!
> > > > >
> > > > > On Thu, Jan 20, 2022 at 6:03 AM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > [...]
> > > > > >
> > > > > > Looks like
> > > > > >  __sk_buff->remote_port
> > > > > >  bpf_sock_ops->remote_port
> > > > > >  sk_msg_md->remote_port
> > > > > > are doing the right thing,
> > > > > > but bpf_sock->dst_port is not correct?
> > > > > >
> > > > > > I think it's better to fix it,
> > > > > > but probably need to consolidate it with
> > > > > > convert_ctx_accesses() that deals with narrow access.
> > > > > > I suspect reading u8 from three flavors of 'remote_port'
> > > > > > won't be correct.
> > > > >
> > > > > What's the meaning of 'narrow access'? Do you mean to
> > > > > make 'remote_port' u16? Or 'remote_port' should be made
> > > > > accessible with u8? In fact, '*((u16 *)&skops->remote_port + 1)'
> > > > > won't work, as it only is accessible with u32.
> > > >
> > > > u8 access to remote_port won't pass the verifier,
> > > > but u8 access to dst_port will.
> > > > Though it will return incorrect data.
> > > > See how convert_ctx_accesses() handles narrow loads.
> > > > I think we need to generalize it for different endian fields.
> > >
> > > Yeah, I understand narrower load in convert_ctx_accesses()
> > > now. Seems u8 access to dst_port can't pass the verifier too,
> > > which can be seen form bpf_sock_is_valid_access():
> > >
> > > $    switch (off) {
> > > $    case offsetof(struct bpf_sock, state):
> > > $    case offsetof(struct bpf_sock, family):
> > > $    case offsetof(struct bpf_sock, type):
> > > $    case offsetof(struct bpf_sock, protocol):
> > > $    case offsetof(struct bpf_sock, dst_port):  // u8 access is not allowed
> > > $    case offsetof(struct bpf_sock, src_port):
> > > $    case offsetof(struct bpf_sock, rx_queue_mapping):
> > > $    case bpf_ctx_range(struct bpf_sock, src_ip4):
> > > $    case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
> > > $    case bpf_ctx_range(struct bpf_sock, dst_ip4):
> > > $    case bpf_ctx_range_till(struct bpf_sock, dst_ip6[0], dst_ip6[3]):
> > > $        bpf_ctx_record_field_size(info, size_default);
> > > $        return bpf_ctx_narrow_access_ok(off, size, size_default);
> > > $    }
> > >
> > > I'm still not sure what should we do now. Should we make all
> > > remote_port and dst_port narrower accessable and endianness
> > > right? For example the remote_port in struct bpf_sock_ops:
> > >
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -8414,6 +8414,7 @@ static bool sock_ops_is_valid_access(int off, int size,
> > >                                 return false;
> > >                         info->reg_type = PTR_TO_PACKET_END;
> > >                         break;
> > > +               case bpf_ctx_range(struct bpf_sock_ops, remote_port):
> >
> > Ahh. bpf_sock_ops don't have it.
> > But bpf_sk_lookup and sk_msg_md have it.
> >
> > bpf_sk_lookup->remote_port
> > supports narrow access.
> >
> > When it accesses sport from bpf_sk_lookup_kern.
> >
> > and we have tests that do u8 access from remote_port.
> > See verifier/ctx_sk_lookup.c
> >
> > >                 case offsetof(struct bpf_sock_ops, skb_tcp_flags):
> > >                         bpf_ctx_record_field_size(info, size_default);
> > >                         return bpf_ctx_narrow_access_ok(off, size,
> > >
> > > If remote_port/dst_port are made narrower accessable, the
> > > result will be right. Therefore, *((u16*)&sk->remote_port) will
> > > be the port with network byte order. And the port in host byte
> > > order can be get with:
> > > bpf_ntohs(*((u16*)&sk->remote_port))
> > > or
> > > bpf_htonl(sk->remote_port)
> >
> > So u8, u16, u32 will work if we make them narrow-accessible, right?
> >
> > The summary if I understood it:
> > . only bpf_sk_lookup->remote_port is doing it correctly for u8,u16,u32 ?
> > . bpf_sock->dst_port is not correct for u32,
> >   since it's missing bpf_ctx_range() ?
> > . __sk_buff->remote_port
> >  bpf_sock_ops->remote_port
> >  sk_msg_md->remote_port
> >  correct for u32 access only. They don't support narrow access.
> >
> > but wait
> > we have a test for bpf_sock->dst_port in progs/test_sock_fields.c.
> > How does it work then?
> >
> > I think we need more eyes on the problem.
> > cc-ing more experts.
> iiuc,  I think both bpf_sk_lookup and bpf_sock allow narrow access.
> bpf_sock only allows ((__u8 *)&bpf_sock->dst_port)[0] but
> not ((__u8 *)&bpf_sock->dst_port)[1].  bpf_sk_lookup allows reading
> a byte at [0], [1], [2], and [3].
>
> The test_sock_fields.c currently works because it is comparing
> with another __u16: "sk->dst_port == srv_sa6.sin6_port".
> It should also work with bpf_ntohS() which usually is what the
> userspace program expects when dealing with port instead of using bpf_ntohl()?
> Thus, I think we can keep the lower 16 bits way that bpf_sock->dst_port
> and bpf_sk_lookup->remote_port (and also bpf_sock_addr->user_port ?) are
> using.  Also, changing it to the upper 16 bits will break existing
> bpf progs.
>
> For narrow access with any number of bytes at any offset may be useful
> for IP[6] addr.  Not sure about the port though.  Ideally it should only
> allow sizeof(__u16) read at offset 0.  However, I think at this point it makes
> sense to make them consistent with how bpf_sk_lookup does it also,
> i.e. allow byte [0], [1], [2], and [3] access.

I don't think it makes much sense to make dst_port allow byte [0],
[1], [2], and [3] access. The whole part of dst_port is in host byte
order, byte access can make the result inconsistent. For example,
byte[2],byte[3] are the port part for big endian, but byte[0],byte[1]
for little endian. Am I right?

So how about it if we do these:
- keep what remote_port and dst_port do
- make all remote_port (bpf_sock_ops, __sk_buff, sk_msg_md,
  etc) consistent in byte access
- document dst_port for it's different with remote_port

Glad to hear some better idea :/

>
> would love to hear how others think about it.
