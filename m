Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570E9246898
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgHQOoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHQOoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 10:44:17 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D024C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 07:44:17 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i6so12465954edy.5
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 07:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HaEB6iAlNUj3dKR3A04HXkptIIKosBZddIh2MVYOzAg=;
        b=T2qg8Izy7qgIroIk00lNzA8X8SHdRgBaoVDx83SM7kkPsyJ8a1gLLJRTYhUgeTwz/c
         ILjtAx4iN17ARD8TuXGgf05tBjlc/rsqbd9Q+9FR2VgQ1unrtzLKKnLwwpWjCphHTkI1
         maryld50rSmLVM8/nVqci7BiOmxRj+MPqHydyK5Ppzzkr6x/0dAENb/LjGkwQEiGoQCR
         0NX5cFna71ofDEZmuU5lkevrxfYcvHjayKcN8I0yrfKT1Eyu3d2MFwM6Rg9lVUK62Asm
         0s8qBraO117zj+Bzkuo4ZAEaEhCBnUc/wbEXkpcevmxfJwXHInZ7IolmAnpJJ+ibbpWn
         LTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HaEB6iAlNUj3dKR3A04HXkptIIKosBZddIh2MVYOzAg=;
        b=aqpCy5BChGbyquBt8aRSr25iQVqcQ+xuSrJo7NQC+aTr6MLlLQkKUg0nCsVHntRwGt
         aHoDTlqSxONfV4J0lnJz2cF9kHni47Zb8KYA0r8+rLqiptyQnJySfxL8aDB+tWT7eW0M
         xXBYuqTYxtpISKPp2oscmk8QdZBrLnRWrykEPParC36Ljcr/hvYjCwLU4+uFZQbesZU6
         f9WVpabVt0YJcmA/X6Rc6tx3lcD/q7oK0R2pOziW+GsZ8VPxcFTp8knBXnFB/Tamta7g
         fgFw2iRSxcP5v93//0trSWkklC2Ky73gZYZcDmvuDxmRmjSG4vCnEUfHvEjy5uDBPX9i
         DgzA==
X-Gm-Message-State: AOAM532dGVqXsj/Sm4JZRao4xB86+ey/D1HNMtUlxnd4sBFwfsZUSCwl
        u+gsoNaNhLjHz7RJgH8vuV7SNfeUVr1cFsaB1qvn3w==
X-Google-Smtp-Source: ABdhPJy6X7un7wLFrvwAKzT0GBdMMWdESYTFT/jRxeJYWAlsmkFYVjw2pNe1zlHH/hNQx+9g4iyYlM81C8mbEWFjKWs=
X-Received: by 2002:a05:6402:b45:: with SMTP id bx5mr15403633edb.22.1597675455742;
 Mon, 17 Aug 2020 07:44:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200804155642.52766-1-tom@herbertland.com> <CA+FuTSfw+XT9kQ4y-dY_M8zc2TksCSSEa-0WY+muyv_yr9_H=A@mail.gmail.com>
In-Reply-To: <CA+FuTSfw+XT9kQ4y-dY_M8zc2TksCSSEa-0WY+muyv_yr9_H=A@mail.gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Mon, 17 Aug 2020 07:44:04 -0700
Message-ID: <CALx6S36=C6P2khdWcZXfi3Cg4WktFBWUe_2U8L6=-vPD-ZZ81A@mail.gmail.com>
Subject: Re: [PATCH net-next] flow_dissector: Add IPv6 flow label to symmetric keys
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 1:27 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Aug 4, 2020 at 5:57 PM Tom Herbert <tom@herbertland.com> wrote:
> >
> > The definition for symmetric keys does not include the flow label so
> > that when symmetric keys is used a non-zero IPv6 flow label is not
> > extracted. Symmetric keys are used in functions to compute the flow
> > hash for packets, and these functions also set "stop at flow label".
> > The upshot is that for IPv6 packets with a non-zero flow label, hashes
> > are only based on the address two tuple and there is no input entropy
> > from transport layer information. This patch fixes this bug.
>
> If this is a bug fix, it should probably target net and have a Fixes tag.
>
> Should the actual fix be to remove the
> FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL argument from
> __skb_get_hash_symmetric?
>
> The original commit mentions the symmetric key flow dissector to
> compute a flat symmetric hash over only the protocol, addresses and
> ports.
>
> Autoflowlabel uses symmetric __get_hash_from_flowi6 to derive a flow
> label, but this cannot be generally relied on. RFC 6437 suggests
> even a PRNG as input, for instance.

Willem,

Yes, the "reliability" of flow labels argument is brought up often
especially by routing vendors that seemingly want to continue doing
their expensive DPI. I'm not exactly what "reliability" means in this
context. I think it refers to the fact that some network devices might
change the flow label in the middle of a flow (AFAIK we squashed all
the instances in Linux stack where flow labels can change mid flow).
In reality, our ability to do "reliable" DPI is dwindling anyway due
to crypto, UDP encapsulation, and transports like QUIC that don't
identify flows solely based 4-tuple.

In any case, IMO the flow label should be part of the input entropy to
the hash even if we do DPI. It's sufficient entropy along with the
IPv6 addresses to produce a flow hash with conformant properties in
more cases than DPI alone can provide due to the limitations above.
One obvious problem with DPI is cost, especially in cases we need to
parse over a bunch of headers just to locate transport ports (i.e.
potential DOS). If the cost is shown negligible or there's other
benefits then maybe we could eliminate
FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL.

Tom
