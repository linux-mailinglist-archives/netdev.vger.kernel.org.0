Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B161247553
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392428AbgHQTWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730177AbgHQPfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 11:35:52 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5996AC061342
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 08:35:51 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id o184so8488056vsc.0
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 08:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cEb0zHexycrquu3SwU59Hw8JXEFzK4Mw7ngI8zvr3VI=;
        b=V4ZaNW8MWoSUr+VbOvxeL19hA8gW8Jk5UzG/GuZxH3yhK8E3jXJXAP4toAEM8V3oTz
         q+ijHftIXg0rXyZGC9NaV4x5ytKxFXDJzDuMunixH7RBsWc3j6/g90oTWHTiY3AlodLe
         wE5X6d//CtVdFRWPCnguXBWnD7GtBrwLoYcLZg/28euJFhXigI4SmNdZy9+p0ahbDYYN
         XVOyhIepciHW0XE0rv2qeUCdkQEul81K+8bhTHlZVjvM2H6r+Uw4Q1OYzGWDgYANng4m
         cQJSCb+pRLHAbpE/JvxQDZfrQYTV/Bnp27sRXTjz2GX714jpO0EzmY+iGF3+ZWXtYhXf
         EzdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cEb0zHexycrquu3SwU59Hw8JXEFzK4Mw7ngI8zvr3VI=;
        b=IbpDkNIBU852j8TvUWM10DYfsUZs1v8cMK9ImoBXd4ukTSbfuznJVoTIBxBkx7tkiu
         DEWp4skVQe1etyh2yhDO91QrGyET7RmTVW87ScYZKzy0o7wLMdN+FRRPNRRe5Z18oj8R
         a9pPw4iauWW8u39J8AYc+bfE2RcSXXOWWBVfC/Y7ohqGMRqcKoA8ykidyBLTrlSlEvXU
         pNNu85W9Zdb5WuwfLXFPI8NbuPdARKo1Ykl4nLYGamsUOdmIXiEnNBXvsjvZi6hYalBM
         dahCQbvDMbqf0UH10gcd7apo7E1i7B6yHUykkAGLV3hJvCz9fdKjNWmHpmyITf8fTU12
         f7CQ==
X-Gm-Message-State: AOAM531F6MQiM46dD4Tyw8jhS4Qr+c1hF/cfZ+DWDcvDTGTkJWNgHLWe
        IcOfP9T0mEACaqCNlVBZ82YROlT6Imsmcg==
X-Google-Smtp-Source: ABdhPJxm+cZDQWLhUiaaEc6b0yojNSzfDjacWpSdPB6vlzrJ6TwI6wpIWcGJ32eAPHtGODq8E00VmA==
X-Received: by 2002:a67:3249:: with SMTP id y70mr8642932vsy.199.1597678549905;
        Mon, 17 Aug 2020 08:35:49 -0700 (PDT)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com. [209.85.222.45])
        by smtp.gmail.com with ESMTPSA id y6sm3591186vke.35.2020.08.17.08.35.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 08:35:48 -0700 (PDT)
Received: by mail-ua1-f45.google.com with SMTP id z12so4851727uam.12
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 08:35:48 -0700 (PDT)
X-Received: by 2002:ab0:2704:: with SMTP id s4mr7334531uao.141.1597678547765;
 Mon, 17 Aug 2020 08:35:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200804155642.52766-1-tom@herbertland.com> <CA+FuTSfw+XT9kQ4y-dY_M8zc2TksCSSEa-0WY+muyv_yr9_H=A@mail.gmail.com>
 <CALx6S36=C6P2khdWcZXfi3Cg4WktFBWUe_2U8L6=-vPD-ZZ81A@mail.gmail.com>
In-Reply-To: <CALx6S36=C6P2khdWcZXfi3Cg4WktFBWUe_2U8L6=-vPD-ZZ81A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 17 Aug 2020 17:35:11 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfa3yisSj6tm_BX4KhgKBsJFxSeCtvqh4zFUTNHuOE3+g@mail.gmail.com>
Message-ID: <CA+FuTSfa3yisSj6tm_BX4KhgKBsJFxSeCtvqh4zFUTNHuOE3+g@mail.gmail.com>
Subject: Re: [PATCH net-next] flow_dissector: Add IPv6 flow label to symmetric keys
To:     Tom Herbert <tom@herbertland.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 4:44 PM Tom Herbert <tom@herbertland.com> wrote:
>
> On Wed, Aug 5, 2020 at 1:27 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Tue, Aug 4, 2020 at 5:57 PM Tom Herbert <tom@herbertland.com> wrote:
> > >
> > > The definition for symmetric keys does not include the flow label so
> > > that when symmetric keys is used a non-zero IPv6 flow label is not
> > > extracted. Symmetric keys are used in functions to compute the flow
> > > hash for packets, and these functions also set "stop at flow label".
> > > The upshot is that for IPv6 packets with a non-zero flow label, hashes
> > > are only based on the address two tuple and there is no input entropy
> > > from transport layer information. This patch fixes this bug.
> >
> > If this is a bug fix, it should probably target net and have a Fixes tag.
> >
> > Should the actual fix be to remove the
> > FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL argument from
> > __skb_get_hash_symmetric?
> >
> > The original commit mentions the symmetric key flow dissector to
> > compute a flat symmetric hash over only the protocol, addresses and
> > ports.
> >
> > Autoflowlabel uses symmetric __get_hash_from_flowi6 to derive a flow
> > label, but this cannot be generally relied on. RFC 6437 suggests
> > even a PRNG as input, for instance.
>
> Willem,
>
> Yes, the "reliability" of flow labels argument is brought up often
> especially by routing vendors that seemingly want to continue doing
> their expensive DPI. I'm not exactly what "reliability" means in this
> context. I think it refers to the fact that some network devices might
> change the flow label in the middle of a flow (AFAIK we squashed all
> the instances in Linux stack where flow labels can change mid flow).
> In reality, our ability to do "reliable" DPI is dwindling anyway due
> to crypto, UDP encapsulation, and transports like QUIC that don't
> identify flows solely based 4-tuple.
>
> In any case, IMO the flow label should be part of the input entropy to
> the hash even if we do DPI. It's sufficient entropy along with the
> IPv6 addresses to produce a flow hash with conformant properties in
> more cases than DPI alone can provide due to the limitations above.
> One obvious problem with DPI is cost, especially in cases we need to
> parse over a bunch of headers just to locate transport ports (i.e.
> potential DOS). If the cost is shown negligible or there's other
> benefits then maybe we could eliminate
> FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL.

Yes, I suppose it's fair to assume that if the flowlabel is set, this
sufficiently identifies the flow.

The existing code that breaks out of dissection with
FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL with only network layer addresses
as flowhash input is clearly undesirable. Sounds good to fix it by
using the flowlabel instead of explicit fields.

Then this should go to net with a proper Fixes, or did you have a
specific reason to target net-next?
