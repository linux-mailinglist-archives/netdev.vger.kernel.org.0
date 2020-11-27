Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58A92C65C6
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 13:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgK0Mc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 07:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728558AbgK0Mc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 07:32:57 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13F4C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 04:32:56 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id m9so4628568iox.10
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 04:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HfEfbq/tYOUmc09OCCW/etavkSoEHDAAXUGPCUXY2tk=;
        b=nm5VOTVaKguXfXlaIZk0Z6qtL6faOyIuBQuxP0Vwz/TMG0geiDGFTYm7WJQVtCPTTo
         j5hvIIxZKrqN10do0/h6TmTBqMmWEshawTEgxoZ3UWc4mTvhsBqTiFloDQ6nnrajcGys
         fRp5kXJ4YXIplgnhd2Q685tqAZkwRdgB9g0n1lvR+qCtfn4JCz967kqPrsB3NtjLRQvc
         ssGSogT93AeZp6+NKlWtj6GIHUnB9P0lV7Xnl5bTI/UZtBZfuko9HCVOUPgtbD5kKtKr
         D1fGqCATz4gbDMpS1lJX72Uo+BY7fYuOjSVh8b+l0B0r0nJFnGVz0/jg9CzIpxfunbk/
         ROhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HfEfbq/tYOUmc09OCCW/etavkSoEHDAAXUGPCUXY2tk=;
        b=aPYkAnMHxlV9QQQhbCpXV+8j7j44Ue/GODdvN9OQ+xFOgBRA+3UthqLcgtK33IXAjO
         8ONI06t+TwTgXj59M2/0IsjiF1MKaf3OtyHrcuPzLDOFdrERkRQa8CU/RinAtpQ18eXp
         HQRhrAkwJ7yJKo/7u092/3n0y3esummeab62HP5DZ/W4ikKQatQAkFAWMIgW1MPYkbMX
         qoDhKSYEXftHi/uBTEzrCi9UH9KbX6z28HEwgEBoJTn8Y9Pqfz1jWApBaqoxeE/neQcx
         GNF5gDFlLe/nCq2IJxwMfxlIluexyAWBHTXCnrbUtQb9m33v9wbvkUtMwlIYnh8ab6rI
         KPuw==
X-Gm-Message-State: AOAM532Eij7u7qF7KPZfe7m+fU0TSkMiiP7TtAMOPl+B9oKs5SgOIM8u
        sGMytMCfOpaw5vCPaWN/fOMeoxLttt3Ia1NfcWB5MQbBR7UVMQ==
X-Google-Smtp-Source: ABdhPJw9Fb6w3+VNx4BpwarqFdQPhLxw4dwC7LTsexTmN/Pc6fiSA20qqe7JiWUgxp8T0EmjCTS/hd4xFkvOAAB1kfM=
X-Received: by 2002:a05:6602:185a:: with SMTP id d26mr5808256ioi.198.1606480376087;
 Fri, 27 Nov 2020 04:32:56 -0800 (PST)
MIME-Version: 1.0
References: <20201121142823.3629805-1-eyal.birger@gmail.com> <20201127094414.GC9390@gauss3.secunet.de>
In-Reply-To: <20201127094414.GC9390@gauss3.secunet.de>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Fri, 27 Nov 2020 14:32:44 +0200
Message-ID: <CAHsH6Gtgui7fbv1sPYUoOj_dZR5yajEd7+tLKwsv5FvQZCFOow@mail.gmail.com>
Subject: Re: [PATCH ipsec-next] xfrm: interface: support collect metadata mode
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     herbert@gondor.apana.org.au, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steffen,

On Fri, Nov 27, 2020 at 11:44 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Sat, Nov 21, 2020 at 04:28:23PM +0200, Eyal Birger wrote:
> > This commit adds support for 'collect_md' mode on xfrm interfaces.
> >
> > Each net can have one collect_md device, created by providing the
> > IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
> > altered and has no if_id or link device attributes.
> >
> > On transmit to this device, the if_id is fetched from the attached dst
> > metadata on the skb. The dst metadata type used is METADATA_IP_TUNNEL
> > since the only needed property is the if_id stored in the tun_id member
> > of the ip_tunnel_info->key.
>
> Can we please have a separate metadata type for xfrm interfaces?
>
> Sharing such structures turned already out to be a bad idea
> on vti interfaces, let's try to avoid that misstake with
> xfrm interfaces.

My initial thought was to do that, but it looks like most of the constructs
surrounding this facility - tc, nft, ovs, ebpf, ip routing - are built around
struct ip_tunnel_info and don't regard other possible metadata types.

For xfrm interfaces, the only metadata used is the if_id, which is stored
in the metadata tun_id, so I think other than naming consideration, the use
of struct ip_tunnel_info does not imply tunneling and does not limit the
use of xfrmi to a specific mode of operation.

On the other hand, adding a new metadata type would require changing all
other places to regard the new metadata type, with a large number of
userspace visible changes.

>
> > On the receive side, xfrmi_rcv_cb() populates a dst metadata for each
> > packet received and attaches it to the skb. The if_id used in this case is
> > fetched from the xfrm state. This can later be used by upper layers such
> > as tc, ebpf, and ip rules.
> >
> > Because the skb is scrubed in xfrmi_rcv_cb(), the attachment of the dst
> > metadata is postponed until after scrubing. Similarly, xfrm_input() is
> > adapted to avoid dropping metadata dsts by only dropping 'valid'
> > (skb_valid_dst(skb) == true) dsts.
> >
> > Policy matching on packets arriving from collect_md xfrmi devices is
> > done by using the xfrm state existing in the skb's sec_path.
> > The xfrm_if_cb.decode_cb() interface implemented by xfrmi_decode_session()
> > is changed to keep the details of the if_id extraction tucked away
> > in xfrm_interface.c.
> >
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
>
> The rest of the patch looks good.

Thanks for the review!
Eyal.
