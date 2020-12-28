Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6892E34A1
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 08:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgL1HEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 02:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgL1HEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 02:04:21 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5D8C061794
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 23:03:41 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id d9so8605462iob.6
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 23:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nfqwpN2JWqYoTO+q9PMBjn9baQ1f9k1LFtlpXMitnYI=;
        b=lU+xXWj+Q+K/zbhrq2l/SFM5cIdVTOC2mDFK/GdFCxgFE+RzCP3O/2x0pLjU1B965g
         Amdjribsb3DgT0rUqQqu2CYBfRU9xpSbmFYdJ12gIVjh8m52p8nJPB0PuprYk5tkIzdz
         VTUbDtaKTKEQigfzTWRXfRH5eA2L5YMNvvIfnqaeu/wOUVyHYOTfP8ubIdG6yzYOwfmo
         VkWmb35LeXJX8+p2lgY9BrW1zHAVwVxXT/442WGF1M/3tyGuKlLCUGriJRHmYXI/DJj+
         YHRZfm1NnSCjR44AZOjmw0haEVC2279Luh1AkEllyVSUH6Pm2jaSsEyku6QvMK3EKQHL
         n/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nfqwpN2JWqYoTO+q9PMBjn9baQ1f9k1LFtlpXMitnYI=;
        b=X7rfKPSu+iPIhlzvL/713zRgsLZNhRv5CiVsC/6OrNkwtL6tqpJjGmdZ+rLKy7aL/6
         M5jz85TDxsyvqAZFoUIT4yKEvjAjzink6o11Bq6c3dZCXohoIHz4BKpsmDZYhya+untw
         RARGIe4l7PJfbBU0aHTw2Yp734uZKoNEwTIUH7N8h27pRImdop20PX0rZLyktHIClfWq
         NgVeMfUDU4rsShiNX4itoiHK6xVBUkfYt/QjFnNrypNcooDfQ0nAH9TfNpJo0K2A4pPA
         o8iyK7CPPGBSU2rRtbRCoCk6aupq6V4Np1pg9RTRHB9ZYb48LlUl24QsTc7wdlU6tpRh
         R6Qw==
X-Gm-Message-State: AOAM532w62aA7d1JW99z+en2eOZ9HAp3TarEYbIPija1Eo/Fp6/Hq9Rd
        ShZqEseIUWeqjHmCMyiFbXDzUSfnZKCoCDYfKUYh13HghVZnKA==
X-Google-Smtp-Source: ABdhPJxYsdFCkHJYaipr+Bxy+NmDzCWExgFDJx22CQkFUm/+9lU9rpRVYDhlGbTufT8g9FavGyDAQqpw0PY5El9H/Kc=
X-Received: by 2002:a5e:a614:: with SMTP id q20mr35849129ioi.198.1609139020332;
 Sun, 27 Dec 2020 23:03:40 -0800 (PST)
MIME-Version: 1.0
References: <20201121142823.3629805-1-eyal.birger@gmail.com>
 <20201127094414.GC9390@gauss3.secunet.de> <CAHsH6Gtgui7fbv1sPYUoOj_dZR5yajEd7+tLKwsv5FvQZCFOow@mail.gmail.com>
 <20201202093747.GA85961@gauss3.secunet.de>
In-Reply-To: <20201202093747.GA85961@gauss3.secunet.de>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Mon, 28 Dec 2020 09:03:28 +0200
Message-ID: <CAHsH6GsOdi=ggOKLEb5YpkQk96xwz=9DQzudZNdy=tBwapd=Sg@mail.gmail.com>
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

On Mon, Dec 7, 2020 at 11:55 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Fri, Nov 27, 2020 at 02:32:44PM +0200, Eyal Birger wrote:
> > Hi Steffen,
> >
> > On Fri, Nov 27, 2020 at 11:44 AM Steffen Klassert
> > <steffen.klassert@secunet.com> wrote:
> > >
> > > On Sat, Nov 21, 2020 at 04:28:23PM +0200, Eyal Birger wrote:
> > > > This commit adds support for 'collect_md' mode on xfrm interfaces.
> > > >
> > > > Each net can have one collect_md device, created by providing the
> > > > IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
> > > > altered and has no if_id or link device attributes.
> > > >
> > > > On transmit to this device, the if_id is fetched from the attached dst
> > > > metadata on the skb. The dst metadata type used is METADATA_IP_TUNNEL
> > > > since the only needed property is the if_id stored in the tun_id member
> > > > of the ip_tunnel_info->key.
> > >
> > > Can we please have a separate metadata type for xfrm interfaces?
> > >
> > > Sharing such structures turned already out to be a bad idea
> > > on vti interfaces, let's try to avoid that misstake with
> > > xfrm interfaces.
> >
> > My initial thought was to do that, but it looks like most of the constructs
> > surrounding this facility - tc, nft, ovs, ebpf, ip routing - are built around
> > struct ip_tunnel_info and don't regard other possible metadata types.
>
> That is likely because most objects that have a collect_md mode are
> tunnels. We have already a second metadata type, and I don't see
> why we can't have a third one. Maybe we can create something more
> generic so that it can have other users too.
>
> > For xfrm interfaces, the only metadata used is the if_id, which is stored
> > in the metadata tun_id, so I think other than naming consideration, the use
> > of struct ip_tunnel_info does not imply tunneling and does not limit the
> > use of xfrmi to a specific mode of operation.
>
> I agree that this can work, but it is a first step into a wrong direction.
> Using a __be64 field of a completely unrelated structure as an u32 if_id
> is bad style IMO.
>
> > On the other hand, adding a new metadata type would require changing all
> > other places to regard the new metadata type, with a large number of
> > userspace visible changes.
>
> I admit that this might have some disadvantages too, but I'm not convinced
> that this justifies the 'ip_tunnel_info' hack.
>

I understand. I'll try to come up with something more generic.
I hope I can find a way to still utilize the existing userspace
constructs.

Thanks!
Eyal.
