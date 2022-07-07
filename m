Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40485569EA7
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 11:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbiGGJjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 05:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiGGJi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 05:38:59 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D9F64EC;
        Thu,  7 Jul 2022 02:38:58 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id x1so21893739qtv.8;
        Thu, 07 Jul 2022 02:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6asbgKWz5KHYE7O0UZbtRVtmQMjaffUmkO0hZOBuxeQ=;
        b=QZLwCBKyScydvvSOVtGD1qyZw3hrB10MO+G+M0RTJ0CdbEsv5bCrs/twvrHUVXpCLf
         ORqVcBS34PqcOfTkm69xUoT/vD3Jrfrdg3hgONzXu+MmeyJuQl6oFRcmoL360lMQMN3Z
         TUcheJAsOhEeOEXCo38BP1aCCoOqMtpZLS4AStuc03Nu6x8q7LLMfzxQq2S9Q8UYP5uD
         woqYfOdoZWGifHEzFmi4UBdW235DipK8dN+c7/PgEF98ZJ58jXX9SrK4xUELE1UWcG9A
         qCj31+W9q3mwNZDyVirI6n0q8fAbDp/lrSECKgOMb4PCPh2oRHJ+P2QOp/6GMo2+CnIX
         eMeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6asbgKWz5KHYE7O0UZbtRVtmQMjaffUmkO0hZOBuxeQ=;
        b=kWmXOBk4bN0cYM+zJaVHVo/fUALAbCviQkk7s34ZnzXaBcBICliXL8Thr3pQYRg50I
         oZeDaMgUy8ruaF+HpUtmlrftUoAJndn/qkSb+q47ULbKEQGIcEjyNpC0tan7XYZIVeRy
         ygwa4pSkYMg6M0I82IUyWuF5yc/d1xcA1hv3NIzaukkZ1gUsuooyl9Ih+eKggLYQo2ZX
         ECyr+XyN2xEx7T283q+wvzsJGcTiEXQwMrd3V8n5jFOunE5BGdg4TiMEz0JT3lmWF0ah
         2gVo+WnnDN0JjMuAw/VahbFKgm68dCu4lPqNSegV941CwPFvLc3OEtc51f2v4/F9v3lS
         9cIg==
X-Gm-Message-State: AJIora+4djS+uOBKiOKyGlfSg2o0KPp7ZMfk82beJLy0/NOeEw2i1VGw
        liSzxj216K7b/8zbJwQTYY8+kmMmXi3nQDhKe8CdNoEroWXMUw==
X-Google-Smtp-Source: AGRyM1u1DxVEueyr4AjU7AJ8HsYZD917QDTURHYtEpLChyDxMkomtkQpXPfMEGhLJHPknvmFFijnt7114s+rnyC5QSQ=
X-Received: by 2002:a0c:9719:0:b0:473:2d8e:60b9 with SMTP id
 k25-20020a0c9719000000b004732d8e60b9mr1921725qvd.122.1657186737605; Thu, 07
 Jul 2022 02:38:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220706160021.10710-1-matthias.may@westermo.com>
 <CAHsH6GsN=kykC32efTWhHKSPqi8Qn3HYgRursSSY2JiFf2hijw@mail.gmail.com> <45a19551-6004-2453-2f16-a7af5d5c0a59@westermo.com>
In-Reply-To: <45a19551-6004-2453-2f16-a7af5d5c0a59@westermo.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 7 Jul 2022 12:38:46 +0300
Message-ID: <CAHsH6GtyXozwURA17DANjmmEVNRXTKZ-HASD6RhzisJ-+LZ=8Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2] ip_tunnel: allow to inherit from VLAN
 encapsulated IP frames
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 7, 2022 at 10:44 AM Matthias May <matthias.may@westermo.com> wrote:
>
> On 7/6/22 19:24, Eyal Birger wrote:
> >
> > Hi,
> >
> > On Wed, Jul 6, 2022 at 7:54 PM Matthias May <matthias.may@westermo.com <mailto:matthias.may@westermo.com>> wrote:
> >
> >     The current code allows to inherit the TOS, TTL, DF from the payload
> >     when skb->protocol is ETH_P_IP or ETH_P_IPV6.
> >     However when the payload is VLAN encapsulated (e.g because the tunnel
> >     is of type GRETAP), then this inheriting does not work, because the
> >     visible skb->protocol is of type ETH_P_8021Q.
> >
> >     Add a check on ETH_P_8021Q and subsequently check the payload protocol.
> >
> >     Signed-off-by: Matthias May <matthias.may@westermo.com <mailto:matthias.may@westermo.com>>
> >     ---
> >     v1 -> v2:
> >       - Add support for ETH_P_8021AD as suggested by Jakub Kicinski.
> >     ---
> >       net/ipv4/ip_tunnel.c | 22 ++++++++++++++--------
> >       1 file changed, 14 insertions(+), 8 deletions(-)
> >
> >     diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> >     index 94017a8c3994..bdcc0f1e83c8 100644
> >     --- a/net/ipv4/ip_tunnel.c
> >     +++ b/net/ipv4/ip_tunnel.c
> >     @@ -648,6 +648,13 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
> >              u8 tos, ttl;
> >              __be32 dst;
> >              __be16 df;
> >     +       __be16 *payload_protocol;
> >     +
> >     +       if (skb->protocol == htons(ETH_P_8021Q) ||
> >     +           skb->protocol == htons(ETH_P_8021AD))
> >     +               payload_protocol = (__be16 *)(skb->head + skb->network_header - 2);
> >     +       else
> >     +               payload_protocol = &skb->protocol;
> >
> >
> > Maybe it's better to use skb_protocol(skb, true) here instead of open
> > coding the vlan parsing?
> >
> > Eyal
>
> Hi Eyal
> I've looked into using skb_protocol(skb, true).
> If skip_vlan is set to true, wouldn't it make sense to use vlan_get_protocol(skb) directly?

Since it's inlined i don't think it makes a practical difference.
Personally I'd find it more readable to use skb_protocol() here because
VLANs are the less expected path, and the change is basically to ignore
them.

Eyal.
