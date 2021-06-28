Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7301F3B6490
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 17:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhF1PKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 11:10:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235782AbhF1PHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 11:07:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624892681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RAbFDBOjD9LaZNO2zarmNXDMoVmASJ4Tb3C07ZP8I2E=;
        b=GhNxBV4qU7imuIuSEniB8vd2wYdqBj6qW4quZpHFYUWaNWUXjHaFyeBJw0rj/7DJSH69wj
        c3lT1W+IR+jwZZVG0rzMNSBFwRwyGoh2wDL78+vH2wyrci6onHoHcUSCpF5LuFYyEetPWi
        FfWBknF0QfLNzYtQ14ihdDTI5FSF2Ew=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-pR4syP61Meq7Idrri_9xeQ-1; Mon, 28 Jun 2021 11:04:40 -0400
X-MC-Unique: pR4syP61Meq7Idrri_9xeQ-1
Received: by mail-wr1-f69.google.com with SMTP id k3-20020a5d62830000b029011a69a4d069so4721102wru.21
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 08:04:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RAbFDBOjD9LaZNO2zarmNXDMoVmASJ4Tb3C07ZP8I2E=;
        b=Vlq3pHH3QTQU+IwFEAWaZ/wR9nQgrzbu2+A+JpHWneykVEA/SDBHpxPKIRN6vyjEzo
         W8lO+SLm9ow787PI7/PKY5/JRJ90ppCDwoy1Q8HgUfHfJX2l6SWMeca5QgaOuaFFr5Vs
         ehq0Lx/cA1IMV4xBUl8t+B6umU2TmiJ+y5GwfT3xjp1uCVJqQQl3bej78jTrwWKOdWIs
         uzmzk8CaNi7+fAXIF5sVOOQiXQ9kZsa8wgXbgs65zsGnfkVkB2TK/DC9Ien1SlWYALT3
         WaI6Yz4xUQCQ+km2m6sumdPpDnpJ2JJVjWrIaDv+Wh/7AU2scYNMmslcDEHjQGUMhBZa
         MMLg==
X-Gm-Message-State: AOAM533NS7VqydgkAylhRSyXUZWIxRp0M+NUWyM5kmn2eE3fEPQjODoP
        32cjPdxno4IFp9RPoTcVuiDhMavT3+3BRjrSYE66xamfUeEbM6YWUql6qYkxrUq7HcUqHFwCy74
        KqohlhfhH8UOKsc3W
X-Received: by 2002:a5d:4e52:: with SMTP id r18mr27978440wrt.372.1624892679195;
        Mon, 28 Jun 2021 08:04:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyD7T8os0hrNkxCKhYzQ58xBNSwagB/ZeVXJ0MHMayIHyCi7EtEOp6OSqRLpvQ1/2XDuWnaKQ==
X-Received: by 2002:a5d:4e52:: with SMTP id r18mr27978424wrt.372.1624892679082;
        Mon, 28 Jun 2021 08:04:39 -0700 (PDT)
Received: from pc-23.home (2a01cb058d44a7001b6d03f4d258668b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d44:a700:1b6d:3f4:d258:668b])
        by smtp.gmail.com with ESMTPSA id c12sm17756173wrr.90.2021.06.28.08.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 08:04:38 -0700 (PDT)
Date:   Mon, 28 Jun 2021 17:04:36 +0200
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
Message-ID: <20210628150436.GA3495@pc-23.home>
References: <cover.1624572003.git.gnault@redhat.com>
 <84fe4ab5-4a80-abf8-675f-29a2f8389b1a@gmail.com>
 <20210626205323.GA7042@pc-32.home>
 <2547b53c-9c22-67ec-99fb-e7e2b403f9f1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2547b53c-9c22-67ec-99fb-e7e2b403f9f1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 27, 2021 at 09:56:53AM -0600, David Ahern wrote:
> On 6/26/21 2:53 PM, Guillaume Nault wrote:
> > On Sat, Jun 26, 2021 at 11:50:19AM -0600, David Ahern wrote:
> >> On 6/25/21 7:32 AM, Guillaume Nault wrote:
> >>> Some virtual L3 devices, like vxlan-gpe and gre (in collect_md mode),
> >>> reset the MAC header pointer after they parsed the outer headers. This
> >>> accurately reflects the fact that the decapsulated packet is pure L3
> >>> packet, as that makes the MAC header 0 bytes long (the MAC and network
> >>> header pointers are equal).
> >>>
> >>> However, many L3 devices only adjust the network header after
> >>> decapsulation and leave the MAC header pointer to its original value.
> >>> This can confuse other parts of the networking stack, like TC, which
> >>> then considers the outer headers as one big MAC header.
> >>>
> >>> This patch series makes the following L3 tunnels behave like VXLAN-GPE:
> >>> bareudp, ipip, sit, gre, ip6gre, ip6tnl, gtp.
> >>>
> >>> The case of gre is a bit special. It already resets the MAC header
> >>> pointer in collect_md mode, so only the classical mode needs to be
> >>> adjusted. However, gre also has a special case that expects the MAC
> >>> header pointer to keep pointing to the outer header even after
> >>> decapsulation. Therefore, patch 4 keeps an exception for this case.
> >>>
> >>> Ideally, we'd centralise the call to skb_reset_mac_header() in
> >>> ip_tunnel_rcv(), to avoid manual calls in ipip (patch 2),
> >>> sit (patch 3) and gre (patch 4). That's unfortunately not feasible
> >>> currently, because of the gre special case discussed above that
> >>> precludes us from resetting the MAC header unconditionally.
> >>
> >> What about adding a flag to ip_tunnel indicating if it can be done (or
> >> should not be done since doing it is the most common)?
> > 
> > That's feasible. I didn't do it here because I wanted to keep the
> > patch series focused on L3 tunnels. Modifying ip_tunnel_rcv()'s
> > prototype would also require updating erspan_rcv(), which isn't L3
> > (erspan carries Ethernet frames). I was feeling such consolidation
> > would be best done in a follow up patch series.
> 
> I was thinking a flag in 'struct ip_tunnel'. It's the private data for
> those netdevices, so a per-instance setting. I haven't walked through
> the details to know if it would work.

I didn't think about that. Good idea, that looks perfectly doable. But
I'd still prefer to centralise the skb_reset_mac_header() call in a
dedicated patch set. I we did it here, we'd have to not reset the mac
header by default, to guarantee that unrelated tunnels wouldn't be
affected.
However, I think that the default behaviour should be to reset the mac
header and that only special cases, like the one in ip_gre, should
explicitely turn that off. Therefore, we'd need a follow up patch
anyway, to change the way this "reset_mac" flag would be set.

IMHO, the current approach has the advantage of clearly separating the
new feature from the refactoring. But if you feel strongly about using
a flag in struct ip_tunnel, I can rework this series.

