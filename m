Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E229634D00B
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhC2M3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhC2M2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:28:50 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A501C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 05:28:50 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a7so19160614ejs.3
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 05:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xv1xpTelAYLRneZ2dLqVtumG89ZK33ftRc7cDDkhnJ4=;
        b=E9Cx25sRaFHvc2+yHACxm4yKNs88hmcauNAU4HBqcOVNZhyYwaRYdtjB8M9YB5ZwX6
         fwc7NJhX5dMkTYS9UFo+feNuA9eJR/zmSVP/iXI8HAuJtJn8SgpKhVLZoEQEeKaCsv5D
         eoS6S4hbzuaPqilUWsRXwnCAS7ykB+0CAFXqVxfuxV6nhWpndJEJHsuQJ4YrKwO2pU0G
         N/hnHZzjATx7HcODyGfbuqhmY4B2lxV/3ZCEwcm2/FlMgSPpQo0SUPNYtfNbKywxO/A5
         jDaNbtld403yuDNo4bwIcfHUplD1747l6nkGxP6wyN6KN+hEx714zky0W289Q0Oww2h9
         P1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xv1xpTelAYLRneZ2dLqVtumG89ZK33ftRc7cDDkhnJ4=;
        b=PjOqIbze+6opVZb10EFWFRArG4U4PtrUKw6NMS7ychTOPt3Z9VZPWRWNXKbt4XmFO2
         GE3PFGHXCS3ua4OlUjRNSAEKThB6yALfiE7l6UVBCc5AwtHk3SWl65P/Nv28IuZKJtuE
         qs8VBdmItYLciNF3HBXjawt5txZ0JNps/FhGEpNuNFNBhUyozkbkK0ylxcJFnyMHI/Xj
         3N67PK2dsIao/shE4n3rAU42HioQb1HtoGLf2sdOahYQ+nI3uuEjDn6waqJsQLJX777+
         Uv1GDAkhCafqmGnnMpWHm24aybafyesGn0uxGcyElSnNvxt5jdBgcEibruOXymaH065J
         dJpQ==
X-Gm-Message-State: AOAM532z3aMvHDNs5IVaPc/7ZTPnHCAkbn3mV5gtnLU79Ohx0IuIKqSA
        tDMIzEVFqfjEo2ntcbzlZ8L+8vEerjc=
X-Google-Smtp-Source: ABdhPJwmzgimvJiv4qJru9u6XgDokz0s1lG67hzda2k2IEKQGzPZfSApStM5WpohCQCkQ/0yYSMNCg==
X-Received: by 2002:a17:906:14d0:: with SMTP id y16mr28478505ejc.242.1617020928732;
        Mon, 29 Mar 2021 05:28:48 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id da17sm9087683edb.83.2021.03.29.05.28.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 05:28:47 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id v4so12635146wrp.13
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 05:28:47 -0700 (PDT)
X-Received: by 2002:a5d:640b:: with SMTP id z11mr27607539wru.327.1617020927111;
 Mon, 29 Mar 2021 05:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616692794.git.pabeni@redhat.com> <28d04433c648ea8143c199459bfe60650b1a0d28.1616692794.git.pabeni@redhat.com>
 <CA+FuTSed_T6+QbdgEUCo2Qy39mH1AVRoPqFYvt_vkRiFxfW7ZA@mail.gmail.com> <c7ee2326473578aa1600bf7c062f37c01e95550a.camel@redhat.com>
In-Reply-To: <c7ee2326473578aa1600bf7c062f37c01e95550a.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Mar 2021 08:28:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfMgXog6AMhNg8H5mBTKTXYMhUG8_KvcKNYF5VS+hiroQ@mail.gmail.com>
Message-ID: <CA+FuTSfMgXog6AMhNg8H5mBTKTXYMhUG8_KvcKNYF5VS+hiroQ@mail.gmail.com>
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

On Mon, Mar 29, 2021 at 7:26 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Fri, 2021-03-26 at 14:30 -0400, Willem de Bruijn wrote:
> > On Thu, Mar 25, 2021 at 1:24 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > When UDP packets generated locally by a socket with UDP_SEGMENT
> > > traverse the following path:
> > >
> > > UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) ->
> > >         UDP tunnel (rx) -> UDP socket (no UDP_GRO)
> > >
> > > they are segmented as part of the rx socket receive operation, and
> > > present a CHECKSUM_NONE after segmentation.
> >
> > would be good to capture how this happens, as it was not immediately obvious.
>
> The CHECKSUM_PARTIAL is propagated up to the UDP tunnel processing,
> where we have:
>
>         __iptunnel_pull_header() -> skb_pull_rcsum() ->
> skb_postpull_rcsum() -> __skb_postpull_rcsum() and the latter do the
> conversion.

Please capture this in the commit message.

> > > Additionally the segmented packets UDP CB still refers to the original
> > > GSO packet len. Overall that causes unexpected/wrong csum validation
> > > errors later in the UDP receive path.
> > >
> > > We could possibly address the issue with some additional checks and
> > > csum mangling in the UDP tunnel code. Since the issue affects only
> > > this UDP receive slow path, let's set a suitable csum status there.
> > >
> > > v1 -> v2:
> > >  - restrict the csum update to the packets strictly needing them
> > >  - hopefully clarify the commit message and code comments
> > >
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > +       if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
> > > +               skb->csum_valid = 1;
> >
> > Not entirely obvious is that UDP packets arriving on a device with rx
> > checksum offload off, i.e., with CHECKSUM_NONE, are not matched by
> > this test.
> >
> > I assume that such packets are not coalesced by the GRO layer in the
> > first place. But I can't immediately spot the reason for it..
>
> Packets with CHECKSUM_NONE are actually aggregated by the GRO engine.
>
> Their checksum is validated by:
>
> udp4_gro_receive -> skb_gro_checksum_validate_zero_check()
>         -> __skb_gro_checksum_validate -> __skb_gro_checksum_validate_complete()
>
> and skb->ip_summed is changed to CHECKSUM_UNNECESSARY by:
>
> __skb_gro_checksum_validate -> skb_gro_incr_csum_unnecessary
>         -> __skb_incr_checksum_unnecessary()
>
> and finally to CHECKSUM_PARTIAL by:
>
> udp4_gro_complete() -> udp_gro_complete() -> udp_gro_complete_segment()
>
> Do you prefer I resubmit with some more comments, either in the commit
> message or in the code?

That breaks the checksum-and-copy optimization when delivering to
local sockets. I wonder if that is a regression.
