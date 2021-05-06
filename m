Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABD3374D01
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 03:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhEFBrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 21:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhEFBrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 21:47:16 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FBCC06174A
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 18:46:19 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id di13so4264699edb.2
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 18:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nCC16UrPwBZC9MtXIyH48K544cIIxJ7XOCk2iyqAPAU=;
        b=kvpJcDlKuHWZKjh/pMLbOz5mUlvlY2NX2nLGoZ6/j23WB+Ciwj4pZUTcrP0NPTZQzY
         8tPdr7CIjcchyXRZW5J3zErd/t42e7ZDJ9hBPqKN8zW9WPNUj9gm72vvKB1mTYPtW2pL
         Mcl2euv0lAKI01w6MfQTEZGp3GTSf6U4NFi7/1P2ymsYxVZEoDaOjQX4rphTn6ewgLIU
         KhLQPVpuCbxGK/ZzgOC9viM8aDQR7cpZ1V7Q75zhs2ziNMK1KSZYIUpd/N4R8FgCaiSR
         chWH12Gt5P3M112HYlA1p23ilvc1GsrD0yhOm9vM0m/OpPpWpTY0ccgwCVVGfBV2hcBV
         uN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nCC16UrPwBZC9MtXIyH48K544cIIxJ7XOCk2iyqAPAU=;
        b=qdgl4DHxloZBcrCh+Ke6ji3Erk+0V6EmMHJktCCGXOCOI/4QLGw3MFc5ZKUfIGqrKa
         S6mt2pv+b2UMleDugf38pib3zZOfJa0ulsMsLa1RDeSdrFJeNe1N7yQp97QgHAT8fx2z
         MFuKLOJ9+iriMv3LdCpdhgXUQ6cVNlN2Edw1C2ID/xN91MQqv6RT8HJ4LHlrMS5Rjaez
         cfsX3qLzHyBWtW6N/FEKfAWiiVcDZsCjpN8IQWVHvJbjzxWr9WCKjT+yGZl04TOHC0yI
         0kzfhvkrKGhTrWrdE9pzAP467p96DSLIeig/ol3lm1z9pIXFmwz/it0KRe1bVbVWrX+0
         a9tA==
X-Gm-Message-State: AOAM531wCd3IZ7vz7fbufO/IG5T/Qg/TYXEtoyhT8PE11Hr+xHKMLu7g
        gxEpL/rVdiRe01UtKdctdihzvQ852CPYaw==
X-Google-Smtp-Source: ABdhPJw3FC4DgYp+iauISGr/vv8ccZ4bgrMB3SQv0xQyiJ7EQwiFYnEqp+s/6fJdlNhDRJMnTCcNIQ==
X-Received: by 2002:aa7:d541:: with SMTP id u1mr2085077edr.95.1620265577139;
        Wed, 05 May 2021 18:46:17 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id v12sm466362edb.81.2021.05.05.18.46.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 18:46:16 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id l14so3830010wrx.5
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 18:46:16 -0700 (PDT)
X-Received: by 2002:adf:aa9a:: with SMTP id h26mr1848982wrc.419.1620265575663;
 Wed, 05 May 2021 18:46:15 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
 <1619690903-1138-1-git-send-email-dseok.yi@samsung.com> <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
 <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com>
In-Reply-To: <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 5 May 2021 21:45:37 -0400
X-Gmail-Original-Message-ID: <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
Message-ID: <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
To:     Dongseok Yi <dseok.yi@samsung.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 5, 2021 at 8:45 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
>
> On Wed, May 05, 2021 at 10:55:10PM +0200, Daniel Borkmann wrote:
> > On 4/29/21 12:08 PM, Dongseok Yi wrote:
> > > tcp_gso_segment check for the size of GROed payload if it is bigger
> > > than the mss. bpf_skb_proto_6_to_4 increases mss, but the mss can be
> > > bigger than the size of GROed payload unexpectedly if data_len is not
> > > big enough.
> > >
> > > Assume that skb gso_size = 1372 and data_len = 8. bpf_skb_proto_6_to_4

Is this a typo and is this intended to read skb->data_len = 1380?

The issue is that payload length (1380) is greater than mss with ipv6
(1372), but less than mss with ipv4 (1392).

I don't understand data_len = 8 or why the patch compares
skb->data_len to len_diff (20).

One simple solution if this packet no longer needs to be segmented
might be to reset the gso_type completely.

In general, I would advocate using BPF_F_ADJ_ROOM_FIXED_GSO. When
converting from IPv6 to IPv4, fixed gso will end up building packets
that are slightly below the MTU. That opportunity cost is negligible
(especially with TSO). Unfortunately, I see that that flag is
available for bpf_skb_adjust_room but not for bpf_skb_proto_6_to_4.


> > > would increse the gso_size to 1392. tcp_gso_segment will get an error
> > > with 1380 <= 1392.
> > >
> > > Check for the size of GROed payload if it is really bigger than target
> > > mss when increase mss.
> > >
> > > Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > ---
> > >   net/core/filter.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 9323d34..3f79e3c 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> > >             }
> > >
> > >             /* Due to IPv4 header, MSS can be upgraded. */
> > > -           skb_increase_gso_size(shinfo, len_diff);
> > > +           if (skb->data_len > len_diff)
> >
> > Could you elaborate some more on what this has to do with data_len specifically
> > here? I'm not sure I follow exactly your above commit description. Are you saying
> > that you're hitting in tcp_gso_segment():
> >
> >          [...]
> >          mss = skb_shinfo(skb)->gso_size;
> >          if (unlikely(skb->len <= mss))
> >                  goto out;
> >          [...]
>
> Yes, right
>
> >
> > Please provide more context on the bug, thanks!
>
> tcp_gso_segment():
>         [...]
>         __skb_pull(skb, thlen);
>
>         mss = skb_shinfo(skb)->gso_size;
>         if (unlikely(skb->len <= mss))
>         [...]
>
> skb->len will have total GROed TCP payload size after __skb_pull.
> skb->len <= mss will not be happened in a normal GROed situation. But
> bpf_skb_proto_6_to_4 would upgrade MSS by increasing gso_size, it can
> hit an error condition.
>
> We should ensure the following condition.
> total GROed TCP payload > the original mss + (IPv6 size - IPv4 size)
>
> Due to
> total GROed TCP payload = the original mss + skb->data_len
> IPv6 size - IPv4 size = len_diff
>
> Finally, we can get the condition.
> skb->data_len > len_diff
>
> >
> > > +                   skb_increase_gso_size(shinfo, len_diff);
> > > +
> > >             /* Header must be checked, and gso_segs recomputed. */
> > >             shinfo->gso_type |= SKB_GSO_DODGY;
> > >             shinfo->gso_segs = 0;
> > >
>
>
