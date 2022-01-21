Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B72495919
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 06:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiAUFRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 00:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiAUFRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 00:17:39 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE49DC061574;
        Thu, 20 Jan 2022 21:17:38 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id l16so8388040pjl.4;
        Thu, 20 Jan 2022 21:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bunDHCeKO61OtYgL6XTkwDh49ksDeJZwuYnkiCJjD/k=;
        b=NUJtW1USk5ESjbrnfPaFxNndMaw6rESK9PforxuBh8OPDpgNPt3uf9069PBe0f9lX3
         8qX7sJ3m3HWKQrbkG0yOSFJp3afKkgda+Vx9/SA2/aybRD7yH0y3aGmCTtzoStvNO1KX
         7TzDMFicsgTRZrDcQNc3ukXTSL7jHbTYA/ZUliv2wmxhSzg8sVdXjBeJ08gDqJPtDKSU
         gIDuP9XR61LcQcpOWJ3/ZpoURnwbgeDdRYXvkj/CMCsBT3KuMqIXrC4QJXbMvR1+CW3C
         cWSXG73DQtkjfIDIHkcEAAs/D3mnfK0PVbMDiLag2NdySjUMU9JTJYyKZDWBqRSH03BW
         tfeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bunDHCeKO61OtYgL6XTkwDh49ksDeJZwuYnkiCJjD/k=;
        b=vPNBtqC2ohqtRcXC+wefwgTKGK8JSEZ5eGC3AebJ9vgl6KKrdDlALGXuXfzaiAMvXx
         Mtmweln5/zMKftgBz/K+Yw/y/cPSq0WLoClxLrpoyHOdITzzNtX7Z5uL4PbT3IuWqYSK
         I+M0n1rplnyMWsC4g5I35UaUdbZ1vDmP25q2SYMhXaHbqSNq48d6TgajCPeo4G6ZjGTK
         Z6vf2NyxWqaI95a6bK/P4V7TZx3BxzqNbAX3dbh2MKGPfFtLoNeCIn4w76bLmRWrlkMW
         8+6/k0bphU+Pau+SUVVhSXzPEPdwHsud2G/0+FNpPQh4cByDeaxT2XBgHl5JbdW82Sbl
         06hQ==
X-Gm-Message-State: AOAM5330bX1qXP7MRt9EJnjWrRVUXr7xAqSJmEdNFLgdyMRiRp057QKo
        P11s/CJk5bNz8PI2gRIEQsmFgWhFNxy1dmw/8l5Asf6OgYY=
X-Google-Smtp-Source: ABdhPJxpL6VhKWBKwersAkHVm8gNgOSr/yFy2odoJ2PQAxJmS1cW2PZsEZ1sFbbQteV7LQTBmFnx+uqkPeMZsDhX870=
X-Received: by 2002:a17:90a:de8e:: with SMTP id n14mr14803977pjv.122.1642742258116;
 Thu, 20 Jan 2022 21:17:38 -0800 (PST)
MIME-Version: 1.0
References: <20220113070245.791577-1-imagedong@tencent.com>
 <CAADnVQKNCqUzPJAjSHMFr-Ewwtv5Cs3UCQpthaKDTd+YNRWqqg@mail.gmail.com>
 <CADxym3bJZrcGHKH8=kKBkxh848dijAZ56n0fm_DvEh6Bbnrezg@mail.gmail.com>
 <20220120041754.scj3hsrxmwckl7pd@ast-mbp.dhcp.thefacebook.com> <CADxym3b-Q6LyjKqTFcrssK9dVJ8hL6QkMb0MzLyn64r4LS=xtw@mail.gmail.com>
In-Reply-To: <CADxym3b-Q6LyjKqTFcrssK9dVJ8hL6QkMb0MzLyn64r4LS=xtw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Jan 2022 21:17:27 -0800
Message-ID: <CAADnVQKaaPKPkqYfhcM=YNCxodBL_ME6CMk3DPXF_Kq2zoyM=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct bpf_sock'
To:     Menglong Dong <menglong8.dong@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
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

On Thu, Jan 20, 2022 at 6:18 AM Menglong Dong <menglong8.dong@gmail.com> wrote:
>
> On Thu, Jan 20, 2022 at 12:17 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jan 20, 2022 at 11:02:27AM +0800, Menglong Dong wrote:
> > > Hello!
> > >
> > > On Thu, Jan 20, 2022 at 6:03 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > [...]
> > > >
> > > > Looks like
> > > >  __sk_buff->remote_port
> > > >  bpf_sock_ops->remote_port
> > > >  sk_msg_md->remote_port
> > > > are doing the right thing,
> > > > but bpf_sock->dst_port is not correct?
> > > >
> > > > I think it's better to fix it,
> > > > but probably need to consolidate it with
> > > > convert_ctx_accesses() that deals with narrow access.
> > > > I suspect reading u8 from three flavors of 'remote_port'
> > > > won't be correct.
> > >
> > > What's the meaning of 'narrow access'? Do you mean to
> > > make 'remote_port' u16? Or 'remote_port' should be made
> > > accessible with u8? In fact, '*((u16 *)&skops->remote_port + 1)'
> > > won't work, as it only is accessible with u32.
> >
> > u8 access to remote_port won't pass the verifier,
> > but u8 access to dst_port will.
> > Though it will return incorrect data.
> > See how convert_ctx_accesses() handles narrow loads.
> > I think we need to generalize it for different endian fields.
>
> Yeah, I understand narrower load in convert_ctx_accesses()
> now. Seems u8 access to dst_port can't pass the verifier too,
> which can be seen form bpf_sock_is_valid_access():
>
> $    switch (off) {
> $    case offsetof(struct bpf_sock, state):
> $    case offsetof(struct bpf_sock, family):
> $    case offsetof(struct bpf_sock, type):
> $    case offsetof(struct bpf_sock, protocol):
> $    case offsetof(struct bpf_sock, dst_port):  // u8 access is not allowed
> $    case offsetof(struct bpf_sock, src_port):
> $    case offsetof(struct bpf_sock, rx_queue_mapping):
> $    case bpf_ctx_range(struct bpf_sock, src_ip4):
> $    case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
> $    case bpf_ctx_range(struct bpf_sock, dst_ip4):
> $    case bpf_ctx_range_till(struct bpf_sock, dst_ip6[0], dst_ip6[3]):
> $        bpf_ctx_record_field_size(info, size_default);
> $        return bpf_ctx_narrow_access_ok(off, size, size_default);
> $    }
>
> I'm still not sure what should we do now. Should we make all
> remote_port and dst_port narrower accessable and endianness
> right? For example the remote_port in struct bpf_sock_ops:
>
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8414,6 +8414,7 @@ static bool sock_ops_is_valid_access(int off, int size,
>                                 return false;
>                         info->reg_type = PTR_TO_PACKET_END;
>                         break;
> +               case bpf_ctx_range(struct bpf_sock_ops, remote_port):

Ahh. bpf_sock_ops don't have it.
But bpf_sk_lookup and sk_msg_md have it.

bpf_sk_lookup->remote_port
supports narrow access.

When it accesses sport from bpf_sk_lookup_kern.

and we have tests that do u8 access from remote_port.
See verifier/ctx_sk_lookup.c

>                 case offsetof(struct bpf_sock_ops, skb_tcp_flags):
>                         bpf_ctx_record_field_size(info, size_default);
>                         return bpf_ctx_narrow_access_ok(off, size,
>
> If remote_port/dst_port are made narrower accessable, the
> result will be right. Therefore, *((u16*)&sk->remote_port) will
> be the port with network byte order. And the port in host byte
> order can be get with:
> bpf_ntohs(*((u16*)&sk->remote_port))
> or
> bpf_htonl(sk->remote_port)

So u8, u16, u32 will work if we make them narrow-accessible, right?

The summary if I understood it:
. only bpf_sk_lookup->remote_port is doing it correctly for u8,u16,u32 ?
. bpf_sock->dst_port is not correct for u32,
  since it's missing bpf_ctx_range() ?
. __sk_buff->remote_port
 bpf_sock_ops->remote_port
 sk_msg_md->remote_port
 correct for u32 access only. They don't support narrow access.

but wait
we have a test for bpf_sock->dst_port in progs/test_sock_fields.c.
How does it work then?

I think we need more eyes on the problem.
cc-ing more experts.
