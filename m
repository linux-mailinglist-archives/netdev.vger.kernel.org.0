Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E919F464600
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346566AbhLAEhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbhLAEhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:37:15 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419FEC061574;
        Tue, 30 Nov 2021 20:33:55 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id v138so59478047ybb.8;
        Tue, 30 Nov 2021 20:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HgPlX08iVhCHw9hxpajnttorkNd49rlMPuyi3Twywfg=;
        b=T+vYrxRqRC4OruAQddpJR6OllDmjwh/akcDo4VNt57UMAF/kWKnumEBUV7qtw0qFZl
         FoI05FLG0S2XmpE3kCrS3MpXfDiZNiaznB0665x5sYKIyD3kkmTow4pNvjkSmwjTwY+Y
         yYp4Nr+wQUwgZC3ioghY0kDapKvPXccEnpEmYlLbydhnA6IkajRPc22XbCBLuKlnZX26
         pm7Jm79bXBpOUx6Z8PBX2BJm/juS9bFo77OvF/XbZn7YlH7Qu5l/T/UpRyBjcwhtZtUX
         u1ajki7w/aCuTKA3LC5cNr3rJs2d1Gs9f90h0iylWPkJB6hL9WvzHZJOzhFaw/lwXrA2
         mNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HgPlX08iVhCHw9hxpajnttorkNd49rlMPuyi3Twywfg=;
        b=JbjqrYodD02JaIfLpamE9dhY8DvyS9j5HGUUlRi33vmkYb7ku1Ed19fE1WYE4qW1I9
         bnOB9RsKcVoW8YeDJhtHGRaygetjmO3yChFK4JBTp2RqVO4R0kgNgBDGVIB4LVZUKY38
         /8izSnwnaadRJO9enbVYbBgSYik5WtUe+M16pg2KpRzKRWCjkjg2TONxxrOLwRcvK2zn
         jdxw9WbAmHEUNs1J9HaJzQRmHnr/aKCQvgh9t6VPnAZjzYsepkc75ZUavxcwTG4jKIv7
         YSiA4d869PkxDGkDO/w3ldtmHMcTyxxcug5B0PB4wXUsHEm/Kpgyxh45eomtks1Eg1vZ
         2YGg==
X-Gm-Message-State: AOAM530FbCjSlURzo4bhrQfpdPiFdi4E0NhylN9VB7aoFfxxyccj9Jnx
        M4JQP7WsV6aftl3GTwB9DCU1MsuoHglTyxnec3Q=
X-Google-Smtp-Source: ABdhPJwIybvmDal0P6G8pbyJ9J48JU2pvinGXabx2uP2lP6LGxPKm7TZntqnx3xIOfea2p+QrqTrLCDJwNfJxoayTBU=
X-Received: by 2002:a25:54e:: with SMTP id 75mr4245787ybf.393.1638333234508;
 Tue, 30 Nov 2021 20:33:54 -0800 (PST)
MIME-Version: 1.0
References: <20211126204108.11530-1-xiyou.wangcong@gmail.com>
 <CAPhsuW4zR5Yuwuywd71fdfP1YXX5cw6uNmhqULHy8BhfcbEAAQ@mail.gmail.com>
 <YaU9Mdv+7kEa4JOJ@unknown> <CAPhsuW4M5Zf9ryWihNSc6DPnXAq0PDJReD2-exxNZp4PDvsSXQ@mail.gmail.com>
 <CAM_iQpVrv8C9opCCMb9ZYtemp32vdv8No2XDwYmDAaCgPtq+RA@mail.gmail.com>
In-Reply-To: <CAM_iQpVrv8C9opCCMb9ZYtemp32vdv8No2XDwYmDAaCgPtq+RA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Nov 2021 20:33:43 -0800
Message-ID: <CAEf4BzZUdE+gsgiLRRissh1Vskf2Ea4WT3gAseV1b9cvNnaBVQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing section "sk_skb/skb_verdict"
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Song Liu <song@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 8:19 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Nov 30, 2021 at 3:33 PM Song Liu <song@kernel.org> wrote:
> >
> > On Mon, Nov 29, 2021 at 12:51 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Fri, Nov 26, 2021 at 04:20:34PM -0800, Song Liu wrote:
> > > > On Fri, Nov 26, 2021 at 12:45 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > >
> > > > > When BPF_SK_SKB_VERDICT was introduced, I forgot to add
> > > > > a section mapping for it in libbpf.
> > > > >
> > > > > Fixes: a7ba4558e69a ("sock_map: Introduce BPF_SK_SKB_VERDICT")
> > > > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > >
> > > > The patch looks good to me. But seems the selftests are OK without this. So,
> > > > do we really need this?
> > > >
> > >
> > > Not sure if I understand this question.
> > >
> > > At least BPF_SK_SKB_STREAM_PARSER and BPF_SK_SKB_STREAM_VERDICT are already
> > > there, so either we should remove all of them or add BPF_SK_SKB_VERDICT for
> > > completeness.
> > >
> > > Or are you suggesting we should change it back in selftests too? Note, it was
> > > changed by Andrii in commit 15669e1dcd75fe6d51e495f8479222b5884665b6:
> > >
> > > -SEC("sk_skb/skb_verdict")
> > > +SEC("sk_skb")
> >
> > Yes, I noticed that Andrii made the change, and it seems to work
> > as-is. Therefore,
> > I had the question "do we really need it".
>
> Same question from me: why still keep sk_skb/stream_parser and
> sk_skb/stream_verdict? ;) I don't see any reason these two are more
> special than sk_skb/skb_verdict, therefore we should either keep all
> of them or remove all of them.
>

"sk_skb/skb_verdict" was treated by libbpf *exactly* the same way as
"sk_skb". Which means the attach type was set to BPF_PROG_TYPE_SK_SKB
and expected_attach_type was 0 (not BPF_SK_SKB_VERDICT!). So that
program is definitely not a BPF_SK_SKB_VERDICT, libbpf pre-1.0 just
has a sloppy prefix matching logic.

So Song's point is valid, we currently don't have selftests that tests
BPF_SK_SKB_VERDICT expected attach type, so it would be good to add
it. Or make sure that existing test that was supposed to test it is
actually testing it.

> >
> > If we do need to differentiate skb_verdict from just sk_skb, could you
>
> Are you sure sk_skb is a real attach type?? To me, it is an umbrella to
> catch all of them:
>
> SEC_DEF("sk_skb",               SK_SKB, 0, SEC_NONE | SEC_SLOPPY_PFX),
>
> whose expected_attach_type is 0. The reason why it works is
> probably because we don't check BPF_PROG_TYPE_SK_SKB in
> bpf_prog_load_check_attach().

We don't check expected_attach_type in prog_load, but
sock_map_prog_update in net/core/sock_map.c is checking expected
attach type and should return -EOPNOTSUPP. But given that no test is
failing our tests don't even try to attach anything, I assume. Which
makes them not so great at actually testing anything. Please see if
you can improve that.

>
> > please add a
> > case selftest for skb_verdict?
>
> Ah, sure, I didn't know we have sec_name_test.
>
> >
> > Also, maybe we can name it as "sk_skb/verdict" to avoid duplication?
>
> At least we used to call it sk_skb/skb_verdict before commit 15669e1dcd.

As I mentioned above, it could have been called "sk_skb!dontcare" and
that would still work (and still does if strict mode is not enabled
for libbpf). For consistency with UAPI expected_attach_type enum it
should be called "sk_skb/verdict" because BPF_SK_SKB_VERDICT vs
BPF_SK_SKB_STREAM_VERDICT vs BPF_SK_SKB_STREAM_PARSER.

>
> Thanks.
