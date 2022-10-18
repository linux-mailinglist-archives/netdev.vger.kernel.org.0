Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5765D6030E3
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 18:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiJRQlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 12:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJRQlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 12:41:39 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130B4E9869
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 09:41:38 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-333a4a5d495so142562347b3.10
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 09:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=blGUrUhYP+SApQpxHVK/AlYz98zBcf/OOrItMBTbDZE=;
        b=McnbNKemxZD43xb0EoChh/IKXBFVNODtkMIE0D9IEYxfoR7YwooZxVs52OwztG5gXL
         eFS42+vN6x3NGTFQA23GAJRdsqUutMYne5GWGibdnvFXdUCIl9k87MaBb75s9ZEX8QbQ
         5n7MG35Tqmx1xUOQvv9KxXwkgijt96J0VIKxpPkkFzw12b2CXbYC5gyXYMj4rP4Thq0/
         VLin8FnlezLV6sxSCt/5/fo6amrEOkJyYn2hTEoRzSaWzw1zOYfR4uUl3bnJVt1GwQPK
         kOCGa4zbZIkf00MrEpNNHNnmsYoq4ge9PE8tEwIKN7mBtOrO0Pe4XfDoMFAfvwPyT6v8
         OtjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=blGUrUhYP+SApQpxHVK/AlYz98zBcf/OOrItMBTbDZE=;
        b=pBjCDuz7bPuqcpyLaQD5s/cE7NpnmmvfbfpYmCLpLpgAguWRITfKbCPBUGsWMd6hAZ
         FI7Fc4G/FqVmaXKA5Sptn6vcX0EqWk7thzoj+Leq6CTKi6PjSZW7HDIV0SNfWSo7Wnzd
         yf3xPyuY103OqbxjoGZp2e3Q1ri1xCgdcPGbC5f9Y67TMuWrdBQ2PFPVmBXGudAxdOfq
         GnPgDGs+iAih71Tdgoo20fv6I+iaAEQxH+VzeT+rrGggSBevesnfD4lND0XbuaLLDWmG
         sDeplo1rvh9Sgt1Ega63IKS08l4rBJEdB1sZ5/DVRtWJKfjz2/z2lwSWmjjg7AWgJBA8
         8LCA==
X-Gm-Message-State: ACrzQf2ZlZdxOxoiSpKLu+b+uxyoqvVZMkKSbisxBbygPT/G0/mtPCVO
        VQcYVRRvc+NjpgD665YxWWhsZWBWHVCAyu8SNfmCNA==
X-Google-Smtp-Source: AMsMyM5n3sOHmeJ6X+2gDD+8WYy7+4/gPWR5amVk9WrNeoQI/szmRH9vmeomEfTMjru1S+CXMHNmoteP+7nakSPablQ=
X-Received: by 2002:a81:48d6:0:b0:355:8d0a:d8a1 with SMTP id
 v205-20020a8148d6000000b003558d0ad8a1mr3140500ywa.467.1666111296891; Tue, 18
 Oct 2022 09:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <20221012103844.1095777-1-luwei32@huawei.com> <CANn89iL3iWQkhbJ1-YgJ_DQErkhB6=rOD_JuJBiJaEb+36QrkA@mail.gmail.com>
 <15e10efe-f357-ac99-6733-3aefa9bd9525@huawei.com>
In-Reply-To: <15e10efe-f357-ac99-6733-3aefa9bd9525@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 18 Oct 2022 09:41:25 -0700
Message-ID: <CANn89i+dSNQqrfd+C1DzhbdNH_eip9tENNaKjrJFJ1OV7c6W8Q@mail.gmail.com>
Subject: Re: [PATCH -next] tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
To:     "luwei (O)" <luwei32@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 12:45 AM luwei (O) <luwei32@huawei.com> wrote:
>
>
> =E5=9C=A8 2022/10/12 8:31 PM, Eric Dumazet =E5=86=99=E9=81=93:
> > On Wed, Oct 12, 2022 at 2:35 AM Lu Wei <luwei32@huawei.com> wrote:
> >> The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
> >> in tcp_add_backlog(), the variable limit is caculated by adding
> >> sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
> >> of u32 and be truncated. So change it to u64 to avoid a potential
> >> signed-integer-overflow, which leads to opposite result is returned
> >> in the following function.
> >>
> >> Signed-off-by: Lu Wei <luwei32@huawei.com>
> > You need to add a Fixes: tag, please.
> >
> >> ---
> >>   include/net/sock.h  | 4 ++--
> >>   net/ipv4/tcp_ipv4.c | 6 ++++--
> >>   2 files changed, 6 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/include/net/sock.h b/include/net/sock.h
> >> index 08038a385ef2..fc0fa29d8865 100644
> >> --- a/include/net/sock.h
> >> +++ b/include/net/sock.h
> >> @@ -1069,7 +1069,7 @@ static inline void __sk_add_backlog(struct sock =
*sk, struct sk_buff *skb)
> >>    * Do not take into account this skb truesize,
> >>    * to allow even a single big packet to come.
> >>    */
> >> -static inline bool sk_rcvqueues_full(const struct sock *sk, unsigned =
int limit)
> >> +static inline bool sk_rcvqueues_full(const struct sock *sk, u64 limit=
)
> >>   {
> >>          unsigned int qsize =3D sk->sk_backlog.len + atomic_read(&sk->=
sk_rmem_alloc);
> > qsize would then overflow :/
> >
> > I would rather limit sk_rcvbuf and sk_sndbuf to 0x7fff0000, instead of
> > 0x7ffffffe
> >
> > If really someone is using 2GB for both send and receive queues,  I
> > doubt removing 64KB will be a problem.
> > .
>
> thanks for reply, I will change the type of qsize to u64 in V2. Besides,
> how to limit sk_rcvbuf and sk_sndbuf

Please do not add u64 where not really needed.

TCP stack is not ready for huge queues, we still have O(N)
pathological functions,
especially when dealing with memory pressure.

Unless you want to solve this difficult problem, let's not send wrong signa=
ls.

>
> to 0x7ffff0000, do you mean in sysctl interface? If so, the varible
> limit will still overflow since it's calculated


>
> by adding sk_rcvbuf and sk_sndbuf.

u32 limit =3D (u32) rcvbuf + (u32) sndbuf + 64*1024; does not overflow.

0x7fff0000U + 0x7fff0000U + 0x10000 =3D 0xffff0000

>
> --
> Best Regards,
> Lu Wei
>
