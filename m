Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E4C34D1DF
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 15:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhC2Nxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 09:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhC2NxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 09:53:07 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4B7C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 06:53:06 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id e14so19544441ejz.11
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 06:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2etcq4q+I3dhTcVOMIR7xoB21FDeBCUqt9WXc+6J3xQ=;
        b=TK0uymtu7JC8C9tlYya5bR7UOq34Xd4XeOVwWg73P9xF9+h+SfjM63rhDbIHZclbtH
         hlcgm90C7+t+34rNwpriNWWKP2o/GsdjLbvBOk4UFNhH4fkQVJOrDRl0UN5OXpuXqg5B
         zAwF7UXeHn0brzcywtHb6B06aMggWHZWP5GzB8Fjvi+iKtxCITgmkCaTkIopQE7Gdvhj
         yW8+8kw1jQfdjtrN6ErJeJ6ZFVL95zsIZdnR73ZRE3O88wkHJU8NhZvwmAkrL4HpEceu
         fNDUrlU4vZwj21VCFEhgcoSnB9DPgNPHDRY1YrOdTg+cB7IzzYWXgng4Nv8Ctnikxrnl
         ZL3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2etcq4q+I3dhTcVOMIR7xoB21FDeBCUqt9WXc+6J3xQ=;
        b=NfBtFByonwQMO+abyte6yJLjVrhNTQ68VrNTprPIciqbXMJ41pr8ZxLQST65mQ9jsP
         Fvatofad+xFzCXSaTDWpLKEOxHydtCQi/7+V1LUbzm6TkPJyBd9hCDsSuBZWmJuZt9qL
         7kIeoASqUVsOgfDRw6PT7xXBEPACw4aWxs2tBgqThasbOmxXFmNMuQwXs6/pi29OQLM4
         yE0HsX6HvOgY75lTOCn1AJABw0/fSxze9OAIAeUQLoBGw4eI/kh3RxjE/PGEdJd9OmRJ
         49TXdB91tqoER1rD5Cmug9p5OgOW3aGqytGYwJ6p9wUvFMq8bCBpOVkSo+pfCVlO0jQO
         QRIg==
X-Gm-Message-State: AOAM533GBJk8TBAlZmuxrn5wEdlsq7tI+sGmAJakIItNFSpci8ribtyB
        AXAQc8AVG6Tk2JdxbTOuyApskjCh0vw=
X-Google-Smtp-Source: ABdhPJzHzRZrsNQMTfC62JKQ3kED/DmzmoiHL4uLEk+BVP1eRf3cErZjoS7KPJcTNLBjFiZ3lJuodQ==
X-Received: by 2002:a17:906:7842:: with SMTP id p2mr29795343ejm.87.1617025984961;
        Mon, 29 Mar 2021 06:53:04 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id j7sm9033186edv.40.2021.03.29.06.53.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 06:53:04 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id j9so11231923wrx.12
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 06:53:03 -0700 (PDT)
X-Received: by 2002:a5d:6cab:: with SMTP id a11mr29049928wra.419.1617025983400;
 Mon, 29 Mar 2021 06:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616692794.git.pabeni@redhat.com> <28d04433c648ea8143c199459bfe60650b1a0d28.1616692794.git.pabeni@redhat.com>
 <CA+FuTSed_T6+QbdgEUCo2Qy39mH1AVRoPqFYvt_vkRiFxfW7ZA@mail.gmail.com>
 <c7ee2326473578aa1600bf7c062f37c01e95550a.camel@redhat.com>
 <CA+FuTSfMgXog6AMhNg8H5mBTKTXYMhUG8_KvcKNYF5VS+hiroQ@mail.gmail.com> <1a33dd110b4b43a7d65ce55e13bff4a69b89996c.camel@redhat.com>
In-Reply-To: <1a33dd110b4b43a7d65ce55e13bff4a69b89996c.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Mar 2021 09:52:25 -0400
X-Gmail-Original-Message-ID: <CA+FuTSduw1eK+CuEgzzwA+6QS=QhMhFQpgyVGH2F8aNH5gwv5A@mail.gmail.com>
Message-ID: <CA+FuTSduw1eK+CuEgzzwA+6QS=QhMhFQpgyVGH2F8aNH5gwv5A@mail.gmail.com>
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

> > > > > Additionally the segmented packets UDP CB still refers to the original
> > > > > GSO packet len. Overall that causes unexpected/wrong csum validation
> > > > > errors later in the UDP receive path.
> > > > >
> > > > > We could possibly address the issue with some additional checks and
> > > > > csum mangling in the UDP tunnel code. Since the issue affects only
> > > > > this UDP receive slow path, let's set a suitable csum status there.
> > > > >
> > > > > v1 -> v2:
> > > > >  - restrict the csum update to the packets strictly needing them
> > > > >  - hopefully clarify the commit message and code comments
> > > > >
> > > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > > +       if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
> > > > > +               skb->csum_valid = 1;
> > > >
> > > > Not entirely obvious is that UDP packets arriving on a device with rx
> > > > checksum offload off, i.e., with CHECKSUM_NONE, are not matched by
> > > > this test.
> > > >
> > > > I assume that such packets are not coalesced by the GRO layer in the
> > > > first place. But I can't immediately spot the reason for it..
> > >
> > > Packets with CHECKSUM_NONE are actually aggregated by the GRO engine.
> > >
> > > Their checksum is validated by:
> > >
> > > udp4_gro_receive -> skb_gro_checksum_validate_zero_check()
> > >         -> __skb_gro_checksum_validate -> __skb_gro_checksum_validate_complete()
> > >
> > > and skb->ip_summed is changed to CHECKSUM_UNNECESSARY by:
> > >
> > > __skb_gro_checksum_validate -> skb_gro_incr_csum_unnecessary
> > >         -> __skb_incr_checksum_unnecessary()
> > >
> > > and finally to CHECKSUM_PARTIAL by:
> > >
> > > udp4_gro_complete() -> udp_gro_complete() -> udp_gro_complete_segment()
> > >
> > > Do you prefer I resubmit with some more comments, either in the commit
> > > message or in the code?
> >
> > That breaks the checksum-and-copy optimization when delivering to
> > local sockets. I wonder if that is a regression.
>
> The conversion to CHECKSUM_UNNECESSARY happens since
> commit 573e8fca255a27e3573b51f9b183d62641c47a3d.
>
> Even the conversion to CHECKSUM_PARTIAL happens independently from this
> series, since commit 6f1c0ea133a6e4a193a7b285efe209664caeea43.
>
> I don't see a regression here ?!?

I mean that UDP packets with local destination socket and no tunnels
that arrive with CHECKSUM_NONE normally benefit from the
checksum-and-copy optimization in recvmsg() when copying to user.

If those packets are now checksummed during GRO, that voids that
optimization, and the packet payload is now touched twice.
