Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8B15B0F37
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 23:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiIGVgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 17:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiIGVgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 17:36:11 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6964ABFC65
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 14:36:10 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 202so14795997pgc.8
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 14:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=XMZONAvozLBVefZoaV7ZL1PNKybf3wvvP3GOlFJP9U0=;
        b=EPwA159+YbxL4S3+XezAB5YH3Fjamo9rzwq5/Q8oUyi9CPzfDpYtXy3Ky2aAJtO/Lj
         ugPUmMQU2Eaffsf6u0sQhejognfohsmzWBvVYDRpeswq3edc6RLJlPpVzbOLKzLnGMoQ
         P1NrTaEBC3QXyL4Fwtlpmtd+ZIPwSBUE5tfhGqh1HavAHTdgQju7wOd6dkXMfZZbRVDs
         qDwde1o32R7kf5gqtgfpm1ST+DKVXJFYOE20yH2mLhroZXW2/fyC62JCWhWoIEuZOFmC
         xNccYjI1vPl5jDtBW0T2AW8KERAGlrszr7+5Zn1Jc0fa7pMQpJMcwUo9VRlPzA1wkhRw
         gzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=XMZONAvozLBVefZoaV7ZL1PNKybf3wvvP3GOlFJP9U0=;
        b=e2GjwCfVdDjeYd1hj9wBjSSEFwmXO4RsCPFVRYKtaZ+foUqLoJM/nU7TeJlDrg84rk
         6y33QlaggErDuuhq6CnO0pooGtjw+MS6kg/BHyjVwy6h3Vutwd6Sj6ce/JJn5dRrSoQF
         5uhLUiSD7B1c9i4nHWta753aSn1oofM2KJQuqOv5qCf0rvzHClsqv2GcdNuIWDky50xp
         93xRBi3sGcxMt3TxHeon8U7AyBFrYjDIxhCN0cqIwJTHNxKCr7RFRSKclQi93EcG1DiM
         nPtjZej4iRWtHsOJVWl2xkPbyAnO714Cv8T3RnYzJyLDxkcJAYM8LgPR2Y7dR3WjEWIv
         D4HQ==
X-Gm-Message-State: ACgBeo1VJ8jRKqjm/PR1rmKWhlt/kCH1PpAJdHD9zm8p3bHSyUAva1TS
        HoQ6un9ygE9wXUrQorpdkmI=
X-Google-Smtp-Source: AA6agR7cXXwq8HvB+yFzIEZBMPdatzuexxIvGQWD/Yc3EyU5A20hxeNFWM7qZgQNcL1DQuegLfDEMQ==
X-Received: by 2002:a63:290:0:b0:41c:506f:7ae9 with SMTP id 138-20020a630290000000b0041c506f7ae9mr5149715pgc.373.1662586569774;
        Wed, 07 Sep 2022 14:36:09 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.39.26])
        by smtp.googlemail.com with ESMTPSA id oa15-20020a17090b1bcf00b0020263b7177csm1043561pjb.3.2022.09.07.14.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 14:36:09 -0700 (PDT)
Message-ID: <dcffcf6fde8272975e44124f55fba3936833360e.camel@gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Date:   Wed, 07 Sep 2022 14:36:07 -0700
In-Reply-To: <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
         <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-07 at 22:19 +0200, Paolo Abeni wrote:
> Hello,
>=20
> reviving an old thread...
> On Wed, 2021-01-13 at 08:18 -0800, Eric Dumazet wrote:
> > While using page fragments instead of a kmalloc backed skb->head might =
give
> > a small performance improvement in some cases, there is a huge risk of
> > under estimating memory usage.
>=20
> [...]
>=20
> > Note that we might in the future use the sk_buff napi cache,
> > instead of going through a more expensive __alloc_skb()
> >=20
> > Another idea would be to use separate page sizes depending
> > on the allocated length (to never have more than 4 frags per page)
>=20
> I'm investigating a couple of performance regressions pointing to this
> change and I'd like to have a try to the 2nd suggestion above.=20
>=20
> If I read correctly, it means:
> - extend the page_frag_cache alloc API to allow forcing max order=3D=3D0
> - add a 2nd page_frag_cache into napi_alloc_cache (say page_order0 or
> page_small)
> - in __napi_alloc_skb(), when len <=3D SKB_WITH_OVERHEAD(1024), use the
> page_small cache with order 0 allocation.
> (all the above constrained to host with 4K pages)
>=20
> I'm not quite sure about the "never have more than 4 frags per page"
> part.
>=20
> What outlined above will allow for 10 min size frags in page_order0, as
> (SKB_DATA_ALIGN(0) + SKB_DATA_ALIGN(struct skb_shared_info) =3D=3D 384. I=
'm
> not sure that anything will allocate such small frags.
> With a more reasonable GRO_MAX_HEAD, there will be 6 frags per page.=C2=
=A0

That doesn't account for any headroom though. Most of the time you have
to reserve some space for headroom so that if this buffer ends up
getting routed off somewhere to be tunneled there is room for adding to
the header. I think the default ends up being NET_SKB_PAD, though many
NICs use larger values. So adding any data onto that will push you up
to a minimum of 512 per skb for the first 64B for header data.

With that said it would probably put you in the range of 8 or fewer
skbs per page assuming at least 1 byte for data:
  512 =3D	SKB_DATA_ALIGN(NET_SKB_PAD + 1) +
	SKB_DATA_ALIGN(struct skb_shared_info)

> The maximum truesize underestimation in both cases will be lower than
> what we can get with the current code in the worst case (almost 32x
> AFAICS).=C2=A0
>=20
> Is the above schema safe enough or should the requested size
> artificially inflatted to fit at most 4 allocations per page_order0?
> Am I miss something else? Apart from omitting a good deal of testing in
> the above list ;)=20

If we are working with an order 0 page we may just want to split it up
into a fixed 1K fragments and not bother with a variable pagecnt bias.
Doing that we would likely simplify this quite a bit and avoid having
to do as much page count manipulation which could get expensive if we
are not getting many uses out of the page. An added advantage is that
we can get rid of the pagecnt_bias and just work based on the page
offset.

As such I am not sure the page frag cache would really be that good of
a fit since we have quite a bit of overhead in terms of maintaining the
pagecnt_bias which assumes the page is a bit longer lived so the ratio
of refcnt updates vs pagecnt_bias updates is better.
