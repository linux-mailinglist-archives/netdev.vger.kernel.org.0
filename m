Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF17E48EECC
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243637AbiANQ5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:57:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243550AbiANQ5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:57:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642179429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L/VcfrWN/CJufq+iaNTecIlHvJcTa9A4ZW2s07umBv8=;
        b=bWIscXRrnD6sjUpxxVzS6GRUX+jRCYJ6VpFvbmA2n77IvevloQPPbzyE+xIHYco+bVpARF
        C74+uR9nFS8CcJs6Qo0pVKw8Vi6dqcn9hAfUQ/ctZJIN/KJOeZrVzxoO0/yfv1D9TvKBmP
        hhd35lI5XmAH3ng1iOSqgWpaz/4Uwqk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-0Dzn2gtVMHCru-TxDM-9ZA-1; Fri, 14 Jan 2022 11:57:08 -0500
X-MC-Unique: 0Dzn2gtVMHCru-TxDM-9ZA-1
Received: by mail-ed1-f69.google.com with SMTP id t1-20020a056402524100b003f8500f6e35so8671864edd.8
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 08:57:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=L/VcfrWN/CJufq+iaNTecIlHvJcTa9A4ZW2s07umBv8=;
        b=RL/WQJB4W+z3EJB8DWjLyA6jxjOLi7erd3hgDE1HewcUJ0aaJ7W/8QJSmHV3rDl7oz
         F3ajYk61wWWijX/TM0WxE+7eoTrcY4l5Jlm40oeLrSWk2exMfM1t48WR00LI/X5CY4ls
         B8NmpUmshSzKR9ikbYJ4TfySjIVJTEqTPRZlxqUb+rDSHsTcakGvYK8wGUpPlmf7x2St
         o1DB9lOkwENZYuoVurjef3JTrW2wVDlWucSavnzddD2ndopJHiHvGJt0CZh9ohLtoZEL
         N6zI9lisxN8hyF8jaN7B2gEkncsrb3VvZYBVRozkov8DAN7o1jWtb5zMgfb4CEx63jS+
         MGyA==
X-Gm-Message-State: AOAM531jB7kLwzNm2j/E3POV4KCm+acrtxU4GK0Ca9Y01gXmrXmdLYPd
        C5vGfj80seJC+j/7TPbJ1KARHi+Fs/0dWy8EYpzrpfIoDCfbvapHYYuLMlFmtAONxgOxpH+rMMx
        01Pd9mqGDk/MWpOXs
X-Received: by 2002:a17:906:2f97:: with SMTP id w23mr7752004eji.739.1642179424882;
        Fri, 14 Jan 2022 08:57:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBdhdFvT9wrbNEej3LojZ9TVAbSXZcep4xdKG41AVlohi7vwp5TAfgT7v2q1eob/+dkfPZeg==
X-Received: by 2002:a17:906:2f97:: with SMTP id w23mr7751960eji.739.1642179423950;
        Fri, 14 Jan 2022 08:57:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k16sm1994888ejk.172.2022.01.14.08.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:57:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 17EA61806B4; Fri, 14 Jan 2022 17:57:00 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Erik Kline <ek@google.com>,
        Fernando Gont <fgont@si6networks.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address
 calculation
In-Reply-To: <CAHmME9pR+qTn72vyANq8Nxx0BtGy7a_+dRvZS_F7RCag8Rvxng@mail.gmail.com>
References: <20220112131204.800307-1-Jason@zx2c4.com>
 <20220112131204.800307-3-Jason@zx2c4.com> <87r19cftbr.fsf@toke.dk>
 <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
 <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
 <CAHmME9pR+qTn72vyANq8Nxx0BtGy7a_+dRvZS_F7RCag8Rvxng@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 14 Jan 2022 17:57:00 +0100
Message-ID: <875yqmdzmr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Hi Hannes,
>
> On Thu, Jan 13, 2022 at 12:15 PM Hannes Frederic Sowa
> <hannes@stressinduktion.org> wrote:
>> > I'm not even so sure that's true. That was my worry at first, but
>> > actually, looking at this more closely, DAD means that the address can
>> > be changed anyway - a byte counter is hashed in - so there's no
>> > guarantee there.
>>
>> The duplicate address detection counter is a way to merely provide basic
>> network connectivity in case of duplicate addresses on the network
>> (maybe some kind misconfiguration or L2 attack). Such detected addresses
>> would show up in the kernel log and an administrator should investigate
>> and clean up the situation.
>
> I don't mean to belabor a point where I'm likely wrong anyway, but
> this DAD business has kept me thinking...
>
> Attacker is hanging out on the network sending DAD responses, forcing
> those counters to increment, and thus making SHA1(stuff || counter)
> result in a different IPv6 address than usual. Outcomes:
> 1) The administrator cannot handle this, did not understand the
> semantics of this address generation feature, and will now have a
> broken network;
> 2) The administrator knows what he's doing, and will be able to handle
> a different IPv6 address coming up.
>
> Do we really care about case (1)? That sounds like emacs spacebar
> heating https://xkcd.com/1172/. And case (2) seems like something that
> would tolerate us changing the hash function.

Privacy addresses mostly address identification outside of the local
network (because on the local network you can see the MAC address), so I
don't think it's unreasonable for someone to enable this and not have a
procedure in place to deal with DAD causing the address to change. For
instance, they could manage their network in a way that they won't
happen (or just turn off DAD entirely on the affected boxes).

>> Afterwards bringing the interface down and
>> up again should revert the interface to its initial (dad_counter == 0)
>> address.
>
> Except the attacker is still on the network, and the administrator
> can't figure it out because the mac addresses keep changing and it's
> arriving from seemingly random switches! Plot twist: the attack is
> being conducted from an implant in the switch firmware. There are a
> lot of creative different takes on the same basic scenario. The point
> is - the administrator really _can't_ rely on the address always being
> the same, because it's simply out of his control.
>
> Given that the admin already *must* be prepared for the address to
> change, doesn't that give us some leeway to change the algorithm used
> between kernels?
>
> Or to put it differently, are there _actually_ braindead deployments
> out there that truly rely on the address never ever changing, and
> should we be going out of our way to support what is arguably a
> misreading and misdeployment of the feature?
>
> (Feel free to smack this line of argumentation down if you disagree. I
> just thought it should be a bit more thoroughly explored.)

I kinda get where you're coming from, but most systems are not actively
under attack, and those will still "break" if this is just changed.
Which is one of those "a kernel upgrade broke my system" type of events
that we want to avoid because it makes people vary of upgrading, so
they'll keep running old kernels way past their expiry dates.

-Toke

