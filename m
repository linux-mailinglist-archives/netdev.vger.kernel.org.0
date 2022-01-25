Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B67B49AA89
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1326194AbiAYDkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1320973AbiAYDPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 22:15:35 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F78DC055A8A;
        Mon, 24 Jan 2022 17:03:33 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id g2so16948872pgo.9;
        Mon, 24 Jan 2022 17:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RQN7oZ9plFVrQA5Sl0VIV9Tk3Cf5PFAJZHSheb1Ub/8=;
        b=ezXvNoglxI1H5DJkd/RNQ4kyBza2i3uDSqjvLcW7c1U9NiOhmlf6XynlBKOG/1+TWa
         pNJXKQVn/sZ3qMpLakW7PjmDrkNfgrBiVb4PB2zEo/DwmuNAHcZi+ftI/mFM58Wp4FxV
         Fqve3RLcfnjfIAeugQ9Hb5zcJBK4BG5ktGnDnrxG4Y6ruoIM/DDyS+1Xd2ZEoNrb/TLg
         hcsRJTBZcJnouMItqZp6aCOy9VTOwWz0sxikTi1auYFu2e6vOx4S7WEEpCZ8igq8HfBK
         E45/LHMQrFZaGE71VTmyf38RjnDJJx65QVJW1gzHEgyIW7cZLQ4LJG29JVW7wedt+x2Q
         qkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RQN7oZ9plFVrQA5Sl0VIV9Tk3Cf5PFAJZHSheb1Ub/8=;
        b=5/RmIHFvh6d42KrXPt4V9XbrXqEy5Nn1bJk3Brim0+CkJv9c9U0GAWWIGuJm2EwVuP
         9kXKCJvQRjdkr7xcBgZu7HOQnm+CMzFVbYGELYX2Pj/IsJrpKlrg3cVT9Cb7TDxqvAFg
         HqOpiWjU0rQO2uFXJ83a7KweX+s7joFifvV/8tljHlhkQ6SBdzxrZ+O10OD/fO4kswj5
         fi76dbacZCqPoYs04HK52NktAzYlPnncvJWTS4TC6f2mlFmZXnE5kp3kpPJnnjE+iJD7
         YyRuB2kqHTarUKjvBtZroyvY3LARByBH2zapMD8/I6ibGnBubyvfRqF9ZnXHCN1nrNW6
         wcjA==
X-Gm-Message-State: AOAM5329dWJH1MvVRmT1QlAGm0xqao68mGNkV/5VXhi90OqWzkuv94XN
        rTpMPUap0b8xKsTdjqOpnZtw1xZIZ5H2FCc15iw=
X-Google-Smtp-Source: ABdhPJy/x8Ec1/eHT+cBWgjxwOCn+rdsQ9mnMJlswq/NOcRHrZSsT3o4Wu7U9je0rSTbVS/cou0UPw0fOO5wZOKYCBw=
X-Received: by 2002:a62:1cd6:0:b0:4c7:f6ae:2257 with SMTP id
 c205-20020a621cd6000000b004c7f6ae2257mr10623171pfc.59.1643072612363; Mon, 24
 Jan 2022 17:03:32 -0800 (PST)
MIME-Version: 1.0
References: <20220113070245.791577-1-imagedong@tencent.com>
 <CAADnVQKNCqUzPJAjSHMFr-Ewwtv5Cs3UCQpthaKDTd+YNRWqqg@mail.gmail.com>
 <CADxym3bJZrcGHKH8=kKBkxh848dijAZ56n0fm_DvEh6Bbnrezg@mail.gmail.com>
 <20220120041754.scj3hsrxmwckl7pd@ast-mbp.dhcp.thefacebook.com>
 <CADxym3b-Q6LyjKqTFcrssK9dVJ8hL6QkMb0MzLyn64r4LS=xtw@mail.gmail.com>
 <CAADnVQKaaPKPkqYfhcM=YNCxodBL_ME6CMk3DPXF_Kq2zoyM=w@mail.gmail.com> <20220125003522.dqbesxtfppoxcg2s@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220125003522.dqbesxtfppoxcg2s@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Jan 2022 17:03:20 -0800
Message-ID: <CAADnVQ+xnnuf3ssgmkR3Nui46WT6h37RUU1zsjhOhy+vCfVdXA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct bpf_sock'
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Menglong Dong <menglong8.dong@gmail.com>,
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

On Mon, Jan 24, 2022 at 4:35 PM Martin KaFai Lau <kafai@fb.com> wrote:
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

Sounds like the proposal is to do:
diff --git a/net/core/filter.c b/net/core/filter.c
index a06931c27eeb..1a8c97bc1927 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8276,9 +8276,9 @@ bool bpf_sock_is_valid_access(int off, int size,
enum bpf_access_type type,
        case offsetof(struct bpf_sock, family):
        case offsetof(struct bpf_sock, type):
        case offsetof(struct bpf_sock, protocol):
-       case offsetof(struct bpf_sock, dst_port):
        case offsetof(struct bpf_sock, src_port):
        case offsetof(struct bpf_sock, rx_queue_mapping):
+       case bpf_ctx_range(struct bpf_sock, dst_port):
        case bpf_ctx_range(struct bpf_sock, src_ip4):

and then document bpf_sock->dst_port and bpf_sk_lookup->remote_port
behavior and their difference vs
  __sk_buff->remote_port
  bpf_sock_ops->remote_port
  sk_msg_md->remote_port
?

I suspect we cannot remove lshift_16 from them either,
since it might break some prog as well.
