Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE94E4C41D
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 01:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbfFSX3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 19:29:09 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:47020 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfFSX3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 19:29:08 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so2394782iol.13
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 16:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JIKT2A+7xbF/qfbQ040F1fNEOR0i1CMLXEq+iT8Qz1U=;
        b=RgImnaVo3WVKTXPRIsBPYfx9nzdTc9i1dC33G3sPmjXw/l+nMGuG1cVuesUwDWxkEd
         bkaUP65+eQqykxfRKBUw7nqeRfcsR5h/4blYBNWkNcy7Ttm5Jl2GKtFdH9Mvl6lE2ml0
         L9FvM5pNzwT3oZctkUHInWX5ZF+hULeO0/31dI6CPnXa0V5d4x6e+vst1MQ/Nlry3I+r
         pO/uovcTMIFJuP9/1C8IPxg8dgBdmnzTvdz3G2g7k50H62u81sdF1k/3PcoVVzdtc59W
         b7zlwMMEmWI0sFWH05UeyQm/s46bkcW4wupHIt7PctlcL9S6mHjBAewiH6uCNBkKXcqj
         Dluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JIKT2A+7xbF/qfbQ040F1fNEOR0i1CMLXEq+iT8Qz1U=;
        b=n9xb92UF12w+6ToNBLFM9yr5O1BQrIE39p3VitEv1hCYLmOnG8K/MMcU+KzTLHzBSy
         EEUCg2NHbCIAMkgXk8vLZA52V+SXzN89gQShHONm7SzI9/Ufe+GbKsJZq22EVAtK++Gw
         d+kv1cLmHmMRka3Oyew0u1n0KgiB/Ku271U7xRQh22B8F/AGOWjio2ag3jzxudETepgW
         HdgSuAj8R4OCy4tsy2FqS/mIRC0zIz7ub4k9FEscUgTXZ6P0D6LG9lMDWWDds/8A+OGD
         J8Nuwefk5CanYBtKWCE8vIqV70kcd09S/68EDg5c6fjGiPVIxQlAvFg6eK84bMDyJixw
         LkHw==
X-Gm-Message-State: APjAAAUqu30x8lNzfKZCVntOCTu2px206+ztFZdI8cC5P902Jek0w+C6
        8m48vjUiZmDnQhwhA0OuMcsKDPNy9lvQjbXiZV3stA==
X-Google-Smtp-Source: APXvYqx89Eh8fxpFDdYmMyczSiyxdkZdhxAVweOIDE+To1tVGdGFwjf7Ylw6JvpMg3hv8UnB4EnNML+Rg2KZYmgAL34=
X-Received: by 2002:a6b:7606:: with SMTP id g6mr2067570iom.288.1560986947746;
 Wed, 19 Jun 2019 16:29:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190619223158.35829-1-tracywwnj@gmail.com> <20190619223158.35829-6-tracywwnj@gmail.com>
 <c0860def-4b20-610f-3fde-f9601eb1600e@gmail.com>
In-Reply-To: <c0860def-4b20-610f-3fde-f9601eb1600e@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 19 Jun 2019 16:28:56 -0700
Message-ID: <CAEA6p_DMFdBeC_RZ6sgBt1NXxWN1fdBzCtSoR+K3nRtDrLuOJg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 5/5] ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF
To:     David Ahern <dsahern@gmail.com>
Cc:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 4:21 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/19/19 4:31 PM, Wei Wang wrote:
> > diff --git a/include/net/l3mdev.h b/include/net/l3mdev.h
> > index e942372b077b..d8c37317bb86 100644
> > --- a/include/net/l3mdev.h
> > +++ b/include/net/l3mdev.h
> > @@ -31,8 +31,9 @@ struct l3mdev_ops {
> >                                         u16 proto);
> >
> >       /* IPv6 ops */
> > -     struct dst_entry * (*l3mdev_link_scope_lookup)(const struct net_device *dev,
> > -                                              struct flowi6 *fl6);
> > +     struct dst_entry * (*l3mdev_link_scope_lookup_noref)(
> > +                                         const struct net_device *dev,
> > +                                         struct flowi6 *fl6);
>
> I would prefer to add a comment about not taking a references vs adding
> the _noref extension. There is only 1 user for 1 context and the name
> length is getting out of hand (as evidenced by the line wrapping below).

Hmm OK. I was trying to make it clear to make sure future callers do
not misuse it.
