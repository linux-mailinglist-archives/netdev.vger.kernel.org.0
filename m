Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28C25A01A5
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 20:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbiHXS4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 14:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239105AbiHXS4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 14:56:47 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2F27C1B9;
        Wed, 24 Aug 2022 11:56:46 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id c9so12280824qkk.6;
        Wed, 24 Aug 2022 11:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=7QVSZeYFR+YSEpI6l2GdFUkQIzB65gx2ENykSnZSwW8=;
        b=YtVl+cSoPOT27J7XMmGoXyc2+I49TsXZAGTeBVFjxjlMWGRjZisI8bieVGlCvkEVOw
         hYeUTZsS2VLIZdeeyGKJoTw9TFna69k5WHiIOo0yEPGw6RI12CXlOPBz78n9ZZXCu2Ir
         bmqNqgxmou2K4ur47zZXneSUKwGA7zT2Dqa9gr1qzPwn+YgZKZxd3FqBwkHuUBgpHdTL
         HfBIgNXMmn/amJJak30GAxCMQmT15yr7oPfNA23BUpIet3eYeDVuevFmFYnMYUQJ81E6
         Mf3zR63G7sOCc4iiSNV04Sf1hJ6w3NryShGlKN1xPEWqJaZbUYx0GeJIbM+pPyIMvBLD
         kHGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=7QVSZeYFR+YSEpI6l2GdFUkQIzB65gx2ENykSnZSwW8=;
        b=BdpG56CqjQtFgpbqKCHhfLzxh6hdTYO57bTbvgZ6vokZzqyUGijdBuIPOLQhLNyA3O
         jc7X0v7yWxhn0Gm/C1mPwJ49aKHWenxVovysqMVf8qoQymXx53qkrSR8rVm5kzbqMdBq
         BwaV0GZj13UNC0Lg1qOiNp9RmJOcFMa02v2GRPM4OyRGBvU/hVoOEIUASbw6arU+4g0e
         R8tJxm8qV/Udhj/90TVC+a3m1bEyLQfOJLXJSTY6ixtqfN0dXs4oNoYrUqw6IpUJGXta
         cnZYB6cAk+RgX2Vu2qkxayV9xdV7Uz8W05pm+LuDDj1OTPp6GTErXEpq3JXyQ4QzYMJ/
         zGhw==
X-Gm-Message-State: ACgBeo1rzmNc56bIZNvz8pJRsNuSx1LbitleZqFrP2mBuEHXiTv7wE2e
        CqUXTHFP8WU18G/UqAgPy3vMoFkNaqrE0Xms7hM=
X-Google-Smtp-Source: AA6agR6/wOTnBNyiqvreJiyyaWNd2D1MQzYmd5RICP3xKJjKXWjWW1I9KsbLFrzOsSIv5/xW4Tq8DJrpTtXBy/sAqyA=
X-Received: by 2002:a05:620a:1011:b0:6bc:62fc:6e4 with SMTP id
 z17-20020a05620a101100b006bc62fc06e4mr512668qkj.484.1661367405396; Wed, 24
 Aug 2022 11:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220823154557.1400380-1-eyal.birger@gmail.com>
 <20220823154557.1400380-4-eyal.birger@gmail.com> <565cce1e-0890-dd35-7b26-362da2cde128@6wind.com>
In-Reply-To: <565cce1e-0890-dd35-7b26-362da2cde128@6wind.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Wed, 24 Aug 2022 21:56:34 +0300
Message-ID: <CAHsH6Gv0AaNamsumhdqVtuTCMkJCwcAam07kZZoQ0vbuZi7tHA@mail.gmail.com>
Subject: Re: [PATCH ipsec-next 3/3] xfrm: lwtunnel: add lwtunnel support for
 xfrm interfaces in collect_md mode
To:     nicolas.dichtel@6wind.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, pablo@netfilter.org,
        contact@proelbtn.com, dsahern@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, devel@linux-ipsec.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On Wed, Aug 24, 2022 at 6:21 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
>
> Le 23/08/2022 =C3=A0 17:45, Eyal Birger a =C3=A9crit :
> > Allow specifying the xfrm interface if_id as part of a route metadata
> > using the lwtunnel infrastructure.
> >
> > This allows for example using a single xfrm interface in collect_md
> > mode as the target of multiple routes each specifying a different if_id=
.
> >
> > With the appropriate changes to iproute2, considering an xfrm device
> > ipsec1 in collect_md mode one can for example add a route specifying
> > an if_id like so:
> >
> > ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1
> It would be nice to be able to specify the link also. It may help to comb=
ine
> this with vrf. Something like
> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1 dev eth0

I think I understand how this would work on xmit - if you mean adding link
to the metadata and using it to set fl.flowi_oif in xfrmi_xmit() - in which
case the link would be used in the underlying lookup such that routes in
a vrf could specify a device which is part of the vrf for egress.

On RX we could assign the link in the metadata in xfrmi_rcv_cb() to the ori=
ginal
skb->dev. I suspect this would be aligned with the link device, but any inp=
ut
you may have on this would be useful.

Eyal.
