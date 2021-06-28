Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5393B69CB
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbhF1UnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:43:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233593AbhF1UnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 16:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624912834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x5K/oJgnPGKI81MPniksv1W+XkeZGg1io+fkZ95yOK8=;
        b=NnC/IS81t+tWeDRyFT+a4WMKGqPFmHvP2bTVLfw/2CoKnYgUEkbetduvnVv5sh7xM5sZ7r
        8MJKSu0L3hFuSMvPu0qkTKDmqN85rkHyyAcddv9RU7Y6qSvm/3RnKwmbUNL/iSQpgyhR8N
        1Pm3h4puE0AaX0Gr4iRN4umgTH8NMOg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-hqdMhdp4MIyFMIyXAV86zw-1; Mon, 28 Jun 2021 16:40:32 -0400
X-MC-Unique: hqdMhdp4MIyFMIyXAV86zw-1
Received: by mail-wr1-f69.google.com with SMTP id h104-20020adf90710000b029010de8455a3aso5101939wrh.12
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 13:40:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x5K/oJgnPGKI81MPniksv1W+XkeZGg1io+fkZ95yOK8=;
        b=bYvjN3/rdfhlF8ddaFD1rGtd4tpjBzO/AYe9ncJBUPi4pwXg6jeIPeCeGEtxo/ACvj
         pj+2/9v+hGZQbZQG2PNLL8FyApC9D+2iwGH3aPnT4eenXm17Zdv4/xibhhbLQIUbBhlH
         1tSv2IzQajV7IJpUx+KPL1XTE5fBLj40vhx82/NmkafJ8moLEj0T3FCFHNTvIY/+ZCwR
         seOnER8PswmE5R8fZvFKZDermFuAwNL11H6puqseD/Lm09fVnb13/U1YN4GVvtbZnCJ9
         GE6vYB24ePZec/MNYZW9RhUlLw7OVH14J0tnRrCAqPAtScutOsDLSlzEC8RjT75xZ4Ov
         Wq3w==
X-Gm-Message-State: AOAM532px6zE4C2lw/jU2DAZVFu8TCLC6bzVM2F12XLUNb1KCTkcCzzD
        blSGRidPiOamsR7rx7gNsRgA3/THHOcIavZESW0SNT38hSkQSDrymG7jLqErQS55KMrSc/0SCWS
        MZgUC8x7fQDktML+u
X-Received: by 2002:adf:c790:: with SMTP id l16mr29867555wrg.121.1624912831388;
        Mon, 28 Jun 2021 13:40:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDtUpJW1G2f+MFgvdu+HMJj9THUzTwsb3LQKCKXsl/En7LdlNtYaLi8vl4hxetccPNyZ+WMg==
X-Received: by 2002:adf:c790:: with SMTP id l16mr29867544wrg.121.1624912831212;
        Mon, 28 Jun 2021 13:40:31 -0700 (PDT)
Received: from pc-23.home (2a01cb058d44a7001b6d03f4d258668b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d44:a700:1b6d:3f4:d258:668b])
        by smtp.gmail.com with ESMTPSA id x18sm15713078wrw.19.2021.06.28.13.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 13:40:30 -0700 (PDT)
Date:   Mon, 28 Jun 2021 22:40:28 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Eli Cohen <elic@nvidia.com>, Jiri Benc <jbenc@redhat.com>,
        Tom Herbert <tom@herbertland.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        Andreas Schultz <aschultz@tpip.net>,
        Jonas Bonn <jonas@norrbonn.se>
Subject: Re: [PATCH net-next 0/6] net: reset MAC header consistently across
 L3 virtual devices
Message-ID: <20210628204028.GA15342@pc-23.home>
References: <cover.1624572003.git.gnault@redhat.com>
 <84fe4ab5-4a80-abf8-675f-29a2f8389b1a@gmail.com>
 <20210626205323.GA7042@pc-32.home>
 <2547b53c-9c22-67ec-99fb-e7e2b403f9f1@gmail.com>
 <20210628150436.GA3495@pc-23.home>
 <518fbc71-e3c7-b4d6-10af-c7b20b009a9b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518fbc71-e3c7-b4d6-10af-c7b20b009a9b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 12:46:24PM -0600, David Ahern wrote:
> On 6/28/21 9:04 AM, Guillaume Nault wrote:
> > On Sun, Jun 27, 2021 at 09:56:53AM -0600, David Ahern wrote:
> >> On 6/26/21 2:53 PM, Guillaume Nault wrote:
> >>> On Sat, Jun 26, 2021 at 11:50:19AM -0600, David Ahern wrote:
> >>>> On 6/25/21 7:32 AM, Guillaume Nault wrote:
> >>>>> Some virtual L3 devices, like vxlan-gpe and gre (in collect_md mode),
> >>>>> reset the MAC header pointer after they parsed the outer headers. This
> >>>>> accurately reflects the fact that the decapsulated packet is pure L3
> >>>>> packet, as that makes the MAC header 0 bytes long (the MAC and network
> >>>>> header pointers are equal).
> >>>>>
> >>>>> However, many L3 devices only adjust the network header after
> >>>>> decapsulation and leave the MAC header pointer to its original value.
> >>>>> This can confuse other parts of the networking stack, like TC, which
> >>>>> then considers the outer headers as one big MAC header.
> >>>>>
> >>>>> This patch series makes the following L3 tunnels behave like VXLAN-GPE:
> >>>>> bareudp, ipip, sit, gre, ip6gre, ip6tnl, gtp.
> >>>>>
> >>>>> The case of gre is a bit special. It already resets the MAC header
> >>>>> pointer in collect_md mode, so only the classical mode needs to be
> >>>>> adjusted. However, gre also has a special case that expects the MAC
> >>>>> header pointer to keep pointing to the outer header even after
> >>>>> decapsulation. Therefore, patch 4 keeps an exception for this case.
> >>>>>
> >>>>> Ideally, we'd centralise the call to skb_reset_mac_header() in
> >>>>> ip_tunnel_rcv(), to avoid manual calls in ipip (patch 2),
> >>>>> sit (patch 3) and gre (patch 4). That's unfortunately not feasible
> >>>>> currently, because of the gre special case discussed above that
> >>>>> precludes us from resetting the MAC header unconditionally.
> >>>>
> >>>> What about adding a flag to ip_tunnel indicating if it can be done (or
> >>>> should not be done since doing it is the most common)?
> >>>
> >>> That's feasible. I didn't do it here because I wanted to keep the
> >>> patch series focused on L3 tunnels. Modifying ip_tunnel_rcv()'s
> >>> prototype would also require updating erspan_rcv(), which isn't L3
> >>> (erspan carries Ethernet frames). I was feeling such consolidation
> >>> would be best done in a follow up patch series.
> >>
> >> I was thinking a flag in 'struct ip_tunnel'. It's the private data for
> >> those netdevices, so a per-instance setting. I haven't walked through
> >> the details to know if it would work.
> > 
> > I didn't think about that. Good idea, that looks perfectly doable. But
> > I'd still prefer to centralise the skb_reset_mac_header() call in a
> > dedicated patch set. I we did it here, we'd have to not reset the mac
> > header by default, to guarantee that unrelated tunnels wouldn't be
> > affected.
> > However, I think that the default behaviour should be to reset the mac
> > header and that only special cases, like the one in ip_gre, should
> > explicitely turn that off. Therefore, we'd need a follow up patch
> > anyway, to change the way this "reset_mac" flag would be set.
> > 
> > IMHO, the current approach has the advantage of clearly separating the
> > new feature from the refactoring. But if you feel strongly about using
> > a flag in struct ip_tunnel, I can rework this series.
> > 
> 
> I am accustomed to doing refactoring first to add some new feature in
> the simplest and clearest way.

I agree on the general statement. Anyway, I've just received the
patchwork-bot message saying the series has been applied. I'll follow
up with the struct ip_tunnel flag once net-next reopens (as I guess it's
about to close).

