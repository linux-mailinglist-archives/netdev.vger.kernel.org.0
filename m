Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7395160FA2F
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbiJ0OMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbiJ0OMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:12:07 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F20918499D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:12:06 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id y72so2142583yby.13
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pLdHfFfhX3cy94Z9ezJ5AxH6EUHLGwMeg9He6JWlo1o=;
        b=nF9DpgPE8ci2mTLmX0a3p7+qoPSiWnxUgg2EohZNshIAvRtxd7TENeOXVBzzc0iluq
         HqoXiS+4SFTKAJ/wKSELayYiLI1UA7dBWjG/3tgy96jLRaftFL7QlrUSZXcefN0PjtZh
         YNCQrS6b7Vb5Oo6cWIq1Z+MX9SVRQm94zpvTQnim7x8dzFXeblTcRZpY+7M4ff2391PI
         hDtV1VfWaSY60Bvv6P1wdDdqccm+HvuvlXtrj3jWa/oEA9hFdINefaHvm9GaDA97t3eu
         AojbYo9XArQO5Kfi0c4wyYhXs3DgX97tnR1tG5gjyfQ7ZF0h3SiY21LUnHEpDmxedhdw
         cG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pLdHfFfhX3cy94Z9ezJ5AxH6EUHLGwMeg9He6JWlo1o=;
        b=ZqdBk/KRRqMF3YUMyWB+PNcrED+SDYWO4LYdMNGieo3q1IzAR1oLqRW8gs5+qDKWcQ
         6ehfqrcmZ5omCzFwycis3fo9Y7d1mTziualTLThRb1DI7R55/MkJpLRpfBNMegGWbCmB
         SifZ3ixgFU3AKv/b/0ZhSEPb6URQwonxS+UvJ7mFpI9Mtb1Xa5wxQNP1wnrnr0fTTp4Q
         rG9S/3QRBAR4oxZDWogEo2IRm5RtPKJZ8cA75aaAluGG1/Zcr/hye8p45rm/9r5MJbHc
         44ERAmc17Hd1YW13JPmiCHVtX6KbwMcAxKUif3/VbJZNI6te3pxoDgdTM4MtTHQ4Aoes
         Ba3A==
X-Gm-Message-State: ACrzQf3St9L0qfKCTe4tKvNZKpF74qSV34IMNEsletTv1i39UYlogEaY
        aPyz3n1+m1hKziz0PmUTClPwQpPQb93LGjOkAPXc6w==
X-Google-Smtp-Source: AMsMyM5B6q5bggkExf5dg36Mc+GckGxJQ3TV8DeKZhTXD6qE02K3LSqznh5N0lehQYKvMjRJV7L+CtQrqHgKmL/1llA=
X-Received: by 2002:a25:7a01:0:b0:6b0:820:dd44 with SMTP id
 v1-20020a257a01000000b006b00820dd44mr41272285ybc.387.1666879925152; Thu, 27
 Oct 2022 07:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220907015618.2140679-1-william.xuanziyang@huawei.com>
 <CANn89iKPmDXvPzw9tYpiqHH7LegAgTb14fAiAqH8vAxZ3KsryA@mail.gmail.com>
 <efc3708e-47d8-b3e8-08a9-40031d11b8ff@huawei.com> <800a1c4eead00b97947e4b289ae49d2858e9f99e.camel@redhat.com>
In-Reply-To: <800a1c4eead00b97947e4b289ae49d2858e9f99e.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Oct 2022 07:11:54 -0700
Message-ID: <CANn89iLcJhA4XGWb-NE0CQg8emKTXVRxDySTNKxnw37eP9M6BQ@mail.gmail.com>
Subject: Re: [PATCH net] net: tun: limit first seg size to avoid oversized linearization
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Petar Penkov <peterpenkov96@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Sep 15, 2022 at 3:31 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-09-13 at 20:07 +0800, Ziyang Xuan (William) wrote:
> > > On Tue, Sep 6, 2022 at 6:56 PM Ziyang Xuan
> > > <william.xuanziyang@huawei.com> wrote:
> > > >
> > > > Recently, we found a syzkaller problem as following:
> > > >
> > > > ========================================================
> > > > WARNING: CPU: 1 PID: 17965 at mm/page_alloc.c:5295
> > > > __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
> > > > ...
> > > > Call trace:
> > > >  __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
> > > >  __alloc_pages_node include/linux/gfp.h:550 [inline]
> > > >  alloc_pages_node include/linux/gfp.h:564 [inline]
> > > >  kmalloc_large_node+0x94/0x350 mm/slub.c:4038
> > > >  __kmalloc_node_track_caller+0x620/0x8e4 mm/slub.c:4545
> > > >  __kmalloc_reserve.constprop.0+0x1e4/0x2b0 net/core/skbuff.c:151
> > > >  pskb_expand_head+0x130/0x8b0 net/core/skbuff.c:1654
> > > >  __skb_grow include/linux/skbuff.h:2779 [inline]
> > > >  tun_napi_alloc_frags+0x144/0x610 drivers/net/tun.c:1477
> > > >  tun_get_user+0x31c/0x2010 drivers/net/tun.c:1835
> > > >  tun_chr_write_iter+0x98/0x100 drivers/net/tun.c:2036
> > > >
> > > > It is because the first seg size of the iov_iter from user space
> > > > is
> > > > very big, it is 2147479538 which is bigger than the threshold
> > > > value
> > > > for bail out early in __alloc_pages(). And skb->pfmemalloc is
> > > > true,
> > > > __kmalloc_reserve() would use pfmemalloc reserves without
> > > > __GFP_NOWARN
> > > > flag. Thus we got a warning.
> > > >
> > > > I noticed that non-first segs size are required less than
> > > > PAGE_SIZE in
> > > > tun_napi_alloc_frags(). The first seg should not be a special
> > > > case, and
> > > > oversized linearization is also unreasonable. Limit the first seg
> > > > size to
> > > > PAGE_SIZE to avoid oversized linearization.
> > > >
> > > > Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP
> > > > driver")
> > > > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> > > > ---
> > > >  drivers/net/tun.c | 5 ++---
> > > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > > index 259b2b84b2b3..7db515f94667 100644
> > > > --- a/drivers/net/tun.c
> > > > +++ b/drivers/net/tun.c
> > > > @@ -1454,12 +1454,12 @@ static struct sk_buff
> > > > *tun_napi_alloc_frags(struct tun_file *tfile,
> > > >                                             size_t len,
> > > >                                             const struct iov_iter
> > > > *it)
> > > >  {
> > > > +       size_t linear = iov_iter_single_seg_count(it);
> > > >         struct sk_buff *skb;
> > > > -       size_t linear;
> > > >         int err;
> > > >         int i;
> > > >
> > > > -       if (it->nr_segs > MAX_SKB_FRAGS + 1)
> > > > +       if (it->nr_segs > MAX_SKB_FRAGS + 1 || linear >
> > > > PAGE_SIZE)
> > > >                 return ERR_PTR(-EMSGSIZE);
> > > >
> > >
> > > This does not look good to me.
> > >
> > > Some drivers allocate 9KB+ for 9000 MTU, in a single allocation,
> > > because the hardware is not SG capable in RX.
> >
> > So, do you mean that it does not matter and keep current status, or
> > give a bigger size but PAGE_SIZE (usually 4KB size)?
> >
> > Would like to hear your advice.
>
> I'm guessing that what Eric is suggesting here is to use a bigger limit
> for 'linear'. Possibly ETH_MAX_MTU could fit. @Eric, fell free to
> correct me :)
>

Something like that, yes. We need to be careful when approaching 64K limit,
because of possible u16 fields overflows.

We just got another patch in GRO layer, just because tun has not been fixed yet.



> Thanks!
>
> Paolo
>
