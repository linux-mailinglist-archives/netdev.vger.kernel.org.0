Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7CD1BAED9
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgD0UJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:09:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34016 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726587AbgD0UJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588018148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZTGTYS+fxXiO6YyT7faWyasQJ7/0+NQkGzZLoNiYFp0=;
        b=ZkhSOi3Cemp19S2nTW9HK8+LZcT50euA/4QboNAP8pftJ4En4quDJf9REibuTq5SEziNgs
        ZXn2WhpShk3cD3jVPi1GBmtIhPxchDg+ukyhVOSXzwCFOmidGHVicR39nCuYsBDW4ldZGO
        +Um6vOJc70Tuo7ISm/pO9iUvuoBdpcs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-D3RfbJ47PBWDv-wRvDrnXg-1; Mon, 27 Apr 2020 16:09:05 -0400
X-MC-Unique: D3RfbJ47PBWDv-wRvDrnXg-1
Received: by mail-lf1-f72.google.com with SMTP id t11so7956768lfc.17
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZTGTYS+fxXiO6YyT7faWyasQJ7/0+NQkGzZLoNiYFp0=;
        b=AgHeSCTiySvAl6EuMuUd05ZhP7AGX0zU2Mb8txb5JkvVvaVLzpdYCWHiOigZek+vZa
         1ZzzONcm4rI7YOm6f9UIODVZ3oQk9Oi5ajocDVuei2/b+ZWsnH0jxuJjcC6Ub2crsyiz
         Ia0PSoiiKFEejl2EEwMfhOQgt+iI+5kb5u2HzJ8Y4nTve5QQewm54ukT29DDQHakxkhA
         A9Qefs7sadqxf96O7JajNXkT3ju/hOZKrP+/f4aIzMMOgXP1FYUMxyT0nAVmGbXSF7ns
         xPGul/kVNdyCemFjbQ2E9ZRiLgCZu2SVGhCDmqy0zmw0G5L4h9T9TxbJgHGL49hNZoVy
         +Ifg==
X-Gm-Message-State: AGi0PuaTwB7Epbcgh42yUfGVUpjZkFkylb+LRY8pVR+y9qCOv1aUqTOW
        QGH8qyMOcnGcfN3DmDpaEVHAsf6+8mRRmQuc9+saivko+kp/2NIfUx3wK5/js02KDJs4Wvf7UyJ
        15ZO/jYBmALft31KX
X-Received: by 2002:a19:c216:: with SMTP id l22mr15616067lfc.172.1588018143797;
        Mon, 27 Apr 2020 13:09:03 -0700 (PDT)
X-Google-Smtp-Source: APiQypICOo5kN2qQWX/a0Lbd5g19rxTjNKOgQfrJjE3t0nLzBdmEmFGO7r5f5jahuWMU1mQ3BADdFA==
X-Received: by 2002:a19:c216:: with SMTP id l22mr15616059lfc.172.1588018143560;
        Mon, 27 Apr 2020 13:09:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q16sm10576141ljj.23.2020.04.27.13.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 13:09:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2CCAF1814FF; Mon, 27 Apr 2020 22:08:58 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC v2] net: xdp: allow for layer 3 packets in generic skb handler
In-Reply-To: <CAHmME9oygxd=Sa5PvXWYm7Mth4tc_LfqnZXM+XrHuouKP1AQxg@mail.gmail.com>
References: <CAHmME9qXrb0ktCTeMJwt6KRsQxOWkiUNL6PNwb1CT7AK4WsVPA@mail.gmail.com> <20200427102229.414644-1-Jason@zx2c4.com> <58760713-438f-a332-77ab-e5c34f0f61b6@gmail.com> <CAHmME9oygxd=Sa5PvXWYm7Mth4tc_LfqnZXM+XrHuouKP1AQxg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 Apr 2020 22:08:58 +0200
Message-ID: <87ftcoy9lx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> On Mon, Apr 27, 2020 at 8:45 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 4/27/20 4:22 AM, Jason A. Donenfeld wrote:
>> > @@ -4544,6 +4544,13 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>> >        * header.
>> >        */
>> >       mac_len = skb->data - skb_mac_header(skb);
>> > +     if (!mac_len) {
>> > +             add_eth_hdr = true;
>> > +             mac_len = sizeof(struct ethhdr);
>> > +             *((struct ethhdr *)skb_push(skb, mac_len)) = (struct ethhdr) {
>> > +                     .h_proto = skb->protocol
>> > +             };
>>
>> please use a temp variable and explicit setting of the fields; that is
>> not pleasant to read and can not be more performant than a more direct
>>
>>                 eth_zero_addr(eth->h_source);
>>                 eth_zero_addr(eth->h_dest);
>>                 eth->h_proto = skb->protocol;
>
> Ack, will change for the non-RFC v3 patch. I need to actually figure
> out how to test this thing first though...

You could try the xdp-filter application in this repo:

https://github.com/xdp-project/xdp-tools

(make sure you use --recurse-submodules when you clone it)

That will allow you to install simple IP- and port-based filters; should
be enough to check that XDP programs will correctly match the packet
contents, I think?

-Toke

