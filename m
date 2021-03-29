Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9084C34DBF5
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhC2WiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhC2Whu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 18:37:50 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625ACC061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 15:37:50 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r12so21845493ejr.5
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 15:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8AH+FL7lbZXMekf59ITKcfLv2/Ezn2xR0hqjMW58zyk=;
        b=mywdgHOociJAjCEAqpThyLf50MFYbFNzkV91E6jfhARJbwRjD+7VfLOFrPmFOzDfu9
         CjH117iv9o5rhOlD+/4uaGdoEE0Gjyf5QPcRb0DRBCJ7/QD2CpUl74RIz4XlbSB+1Img
         JrA7HHyEoOoeiWAtURApZbkAB6qMyK0UVwma5ecJoKNQfG1uneZ1jVlXSTuEZJ50ahT2
         gKSq2OE+Cp57rPo+gJBzHu7/jlyNP37T4iM2bpx2y7DXx+wGrFHIkvG03Ee46r8fbmXM
         biV8WWxsO9hUz9BCiFd9ARNIkk2K2rRUJOAyB3Qezo/q1EnOtSSGtwKz+0NRr8X+EPhP
         d+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8AH+FL7lbZXMekf59ITKcfLv2/Ezn2xR0hqjMW58zyk=;
        b=eZL5sIR7mEt126KCKDyXf4ZSiKha8Di23QFXlMe9k9oIjRsJJAlp6rDLPiXqWglr2I
         P+XcEo2iPeCi8vsUhJgZ9K6+98zK+p7lFbnaPQbxGgUsxhx6oyTtsjHyls6+bkcyVHgc
         r363CePxFxZ4H17H1Um1z1XZBxJcgjLjfmTKkNsWLALWsRsjNwZNNOZcAIIzNWNzIH5t
         jHl0EBIIJeOUo0JxexoGwnnJi63jf+u1Xjri3zwh9KM5kCMTHItc3VNEdM12b/WCf24j
         hDcxRTcGEYxH45nzsBUzfo3J8Yr34ZYCu33KTqN65Y4Kt1UmIglTopt9r1AM8zvAMUEM
         I/ng==
X-Gm-Message-State: AOAM530akxgLqILCayzmHfFoerDklnTf3Wl1HTSSxoc1lwm34vWxBgvd
        OFIGy2hk1FmdmHwnTx7i6ngnIa9uhNs=
X-Google-Smtp-Source: ABdhPJzCw8ug4ncHhSVSQ+V7S/V6KoHvY99iMB1ac8UVb5ibvadEPD82yKQcSHB1Kmxl6ZLae2ULXQ==
X-Received: by 2002:a17:906:3643:: with SMTP id r3mr29798670ejb.527.1617057468638;
        Mon, 29 Mar 2021 15:37:48 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id g12sm9059822eje.120.2021.03.29.15.37.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 15:37:48 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id p19so7364420wmq.1
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 15:37:47 -0700 (PDT)
X-Received: by 2002:a05:600c:4150:: with SMTP id h16mr1032676wmm.120.1617057467503;
 Mon, 29 Mar 2021 15:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616692794.git.pabeni@redhat.com> <28d04433c648ea8143c199459bfe60650b1a0d28.1616692794.git.pabeni@redhat.com>
 <CA+FuTSed_T6+QbdgEUCo2Qy39mH1AVRoPqFYvt_vkRiFxfW7ZA@mail.gmail.com>
 <c7ee2326473578aa1600bf7c062f37c01e95550a.camel@redhat.com>
 <CA+FuTSfMgXog6AMhNg8H5mBTKTXYMhUG8_KvcKNYF5VS+hiroQ@mail.gmail.com>
 <1a33dd110b4b43a7d65ce55e13bff4a69b89996c.camel@redhat.com>
 <CA+FuTSduw1eK+CuEgzzwA+6QS=QhMhFQpgyVGH2F8aNH5gwv5A@mail.gmail.com>
 <c296fa344bacdcd23049516e8404931abc70b793.camel@redhat.com>
 <CA+FuTScQW-jYCHksXk=85Ssa=HWWce7103A=Y69uduNzpfd6cA@mail.gmail.com> <dc7a2ef8286516e805df7cae21f2b193d8da9761.camel@redhat.com>
In-Reply-To: <dc7a2ef8286516e805df7cae21f2b193d8da9761.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Mar 2021 18:37:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdjtTmtuETr9g+EAmdjpiDwWMFs7w6V8519or0-8QFasg@mail.gmail.com>
Message-ID: <CA+FuTSdjtTmtuETr9g+EAmdjpiDwWMFs7w6V8519or0-8QFasg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/8] udp: fixup csum for GSO receive slow path
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 12:24 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2021-03-29 at 11:24 -0400, Willem de Bruijn wrote:
> > On Mon, Mar 29, 2021 at 11:01 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > On Mon, 2021-03-29 at 09:52 -0400, Willem de Bruijn wrote:
> > > > > +       if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
> > > > > +               skb->csum_valid = 1;
> > > >
> > > > Not entirely obvious is that UDP packets arriving on a device with rx
> > > > checksum offload off, i.e., with CHECKSUM_NONE, are not matched by
> > > > this test.
> > > >
> > > > I assume that such packets are not coalesced by the GRO layer in the
> > > > first place. But I can't immediately spot the reason for it..
> >
> > As you point out, such packets will already have had their checksum
> > verified at this point, so this branch only matches tunneled packets.
> > That point is just not immediately obvious from the code.
>
> I understand is a matter of comment clarity ?!?
>
> I'll rewrite the related code comment - in udp_post_segment_fix_csum()
> - as:
>
>         /* UDP packets generated with UDP_SEGMENT and traversing:
>          *
>          * UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) -> UDP tunnel (rx)
>          *
>          * land here with CHECKSUM_NONE, because __iptunnel_pull_header() converts
>          * CHECKSUM_PARTIAL into NONE.
>          * SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST packets with no UDP tunnel will land
>          * here with valid checksum, as the GRO engine validates the UDP csum
>          * before the aggregation and nobody strips such info in between.
>          * Instead of adding another check in the tunnel fastpath, we can force
>          * a valid csum here.
>          * Additionally fixup the UDP CB.
>          */
>
> Would that be clear enough?

Definitely. Thanks!

> > > I do see checksum validation in the GRO engine for CHECKSUM_NONE UDP
> > > packet prior to this series.
> > >
> > > I *think* the checksum-and-copy optimization is lost
> > > since 573e8fca255a27e3573b51f9b183d62641c47a3d.
> >
> > Wouldn't this have been introduced with UDP_GRO?
>
> Uhmm.... looks like the checksum-and-copy optimization has been lost
> and recovered a few times. I think the last one
> with 9fd1ff5d2ac7181844735806b0a703c942365291, which move the csum
> validation before the static branch on udp_encap_needed_key.
>
> Can we agree re-introducing the optimization is independent from this
> series?

Yep :)
> Thanks!
>
> Paolo
>
>
