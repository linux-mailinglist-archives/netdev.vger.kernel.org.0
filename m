Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8383C47C610
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241055AbhLUSNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:13:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241048AbhLUSNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 13:13:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640110413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DsJ9qSTeXG/G7hSN6w+8NwAe8IgqRArYsPMLUPGJL8w=;
        b=Dls9q1E47EIChBonNiORqg+abbY6rklwQYySp7Y0fvF/NjSBs1BuOvMRRzycykXwOMZiE9
        SELDrZL8D2ySLawgegCYea6dypmqwECtBdvRR5SrpC0OdrC4s0N96fl2iyH+ndjw4nSdsa
        W7i1NH18cvZcgZfKR4tIZRxyHwqeCHo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235--OHngBLZMCeOYsnoczRudA-1; Tue, 21 Dec 2021 13:13:32 -0500
X-MC-Unique: -OHngBLZMCeOYsnoczRudA-1
Received: by mail-qv1-f69.google.com with SMTP id kk20-20020a056214509400b004110a8ba7beso10489781qvb.20
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 10:13:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DsJ9qSTeXG/G7hSN6w+8NwAe8IgqRArYsPMLUPGJL8w=;
        b=vGZcKSTZd5uyLoSb8/kXePt4Sf90qi20TYy5ZAwLjpK7ADX1SJQou+QxJr+9q073YR
         4Kb+jMt7hFj9I0K9YS2cXyyCzSHxa4PxteO3mm/vyvg7mj891IidQz2q58/Eo5v0nj2r
         fPV3mcVY3a1jZsrv/XF6i+Zmd/8NZrhLhPDRI0WIsAlPSJIld+Kh6ucWTdye4B0UpL4s
         yX96I20rd7hro/IqySslSfxK/PfiNttbK48Xf0Rcw6NbouaiYAoRQxHMv/cZK3TAKLwq
         k0I3S/b0DMUKZBOFe85y7xpVaHXKbaA1FPaoMP9BFp/tALRenq3KfLgan2F8gYJV83GQ
         rMfA==
X-Gm-Message-State: AOAM532HoxfjREeDGP8b/ja5exoZ4F2Fg1BzdJ76yUML77pFU2hxpkC2
        TDyjfOLDywIJd6fNs6BWjTnOErf0eObKgD4gCciK2a4maPiyhp7fOQZEmnIE0Mw4FA7AAKsY+rg
        kt0hrEt0+2FO2v7M/
X-Received: by 2002:ad4:5c8b:: with SMTP id o11mr3422633qvh.130.1640110411409;
        Tue, 21 Dec 2021 10:13:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwN8XBo6cfgVnZTEtcosnpRE4BETiKCOULPkUCdzPIilsOoZbIgiJ5bUbc1u5KFAe5Xs0aBzg==
X-Received: by 2002:ad4:5c8b:: with SMTP id o11mr3422616qvh.130.1640110411151;
        Tue, 21 Dec 2021 10:13:31 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-225-60.dyn.eolo.it. [146.241.225.60])
        by smtp.gmail.com with ESMTPSA id q22sm13322854qki.46.2021.12.21.10.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 10:13:30 -0800 (PST)
Message-ID: <9e394d57ada54c604fca2a6798b1a4da3921874c.camel@redhat.com>
Subject: Re: tcp: kernel BUG at net/core/skbuff.c:3574!
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Date:   Tue, 21 Dec 2021 19:13:27 +0100
In-Reply-To: <CALrw=nEAEqq71Bwn0tJvFum3a1Ht6ynGedjH7uFpfFgSOU1AHg@mail.gmail.com>
References: <CALrw=nGtZbuQWdwh26qJA6HbbLsCNZjU4jaY78acbKfAAan+5w@mail.gmail.com>
         <CANn89i+CF0G+Yx_aJMURxBbr0mqDzS5ytQY7RtYh_pY0cOh01A@mail.gmail.com>
         <cf25887f1321e9b346aa3bf487bd55802f7bca80.camel@redhat.com>
         <CALrw=nG5-Qyi8f0j6-dmkVts4viX24j755gEiUNTQDoXzXv1XQ@mail.gmail.com>
         <3d6d818ff01b363ae7ec6740dc3cd3e62aa16682.camel@redhat.com>
         <CALrw=nEAEqq71Bwn0tJvFum3a1Ht6ynGedjH7uFpfFgSOU1AHg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-21 at 18:01 +0000, Ignat Korchagin wrote:
> On Tue, Dec 21, 2021 at 5:31 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > On Tue, 2021-12-21 at 17:16 +0000, Ignat Korchagin wrote:
> > > On Tue, Dec 21, 2021 at 3:40 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > 
> > > > On Tue, 2021-12-21 at 06:16 -0800, Eric Dumazet wrote:
> > > > > On Tue, Dec 21, 2021 at 4:19 AM Ignat Korchagin <ignat@cloudflare.com> wrote:
> > > > > > 
> > > > > > Hi netdev,
> > > > > > 
> > > > > > While trying to reproduce a different rare bug we're seeing in
> > > > > > production I've triggered below on 5.15.9 kernel and confirmed on the
> > > > > > latest netdev master tree:
> > > > > > 
> > > > > 
> > > > > Nothing comes to mind. skb_shift() has not been recently changed.
> > > > > 
> > > > > Why are you disabling TSO exactly ?
> > > > > 
> > > > > Is GRO being used on veth needed to trigger the bug ?
> > > > > (GRO was added recently to veth, I confess I did not review the patches)
> > > 
> > > Yes, it seems enabling GRO for veth actually enables NAPI codepaths,
> > > which trigger this bug (and actually another one we're investigating).
> > > Through trial-and-error it seems disabling TSO is more likely to
> > > trigger it at least in my dev environment. I'm not sure if this bug is
> > > somehow related to the other one we're investigating, but once we have
> > > a fix here I can try to verify before posting it to the mailing list.
> > > 
> > > > This is very likely my fault. I'm investigating it right now.
> > > 
> > > Thank you very much! Let me know if I can help somehow.
> > 
> > I'm testing the following patch. Could you please have a spin in your
> > testbed, too?
> 
> Seems with the patch the BUG does not reproduce for me anymore.

Thank you for testing. I'll submit that formally after some more
testing on my side.

Thanks!

Paolo

