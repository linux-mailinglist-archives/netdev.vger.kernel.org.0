Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933213B5023
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 22:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhFZUzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 16:55:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43805 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230136AbhFZUzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 16:55:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624740809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uk7i8Ok37+HN/zn2yWmDegmohPrSRVU3PRPVL7u3f6s=;
        b=C6a4kwZVtR3C12HgwDORBArv3Std2sVZctwMT/kjvcmWWGnveLNwchuklFazBDCM6UB9/5
        AyGPz1ZsLGVbcOgYYcy0pj5Ecv98Eyhn2ec/gwoF9pJsuBYB8/iuhzkFjaz65+LPJ9mSJJ
        IjZUjYPTld63dpq3tdvyB7ekxDJGG2Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-B6_aiExINGuDu0Kz9oewYA-1; Sat, 26 Jun 2021 16:53:28 -0400
X-MC-Unique: B6_aiExINGuDu0Kz9oewYA-1
Received: by mail-wm1-f71.google.com with SMTP id z127-20020a1c7e850000b02901e46e4d52c0so2401155wmc.6
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 13:53:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uk7i8Ok37+HN/zn2yWmDegmohPrSRVU3PRPVL7u3f6s=;
        b=Y0d2OgJPcenvTYi+ka0ZN1XiuFzcP0OpaGkmIZ+VD8WjTqNGjbd5MWC/AcXPa5dsXu
         IXhCIhdCH593OD1qozEkKN589gDP3EQF/QJmUypGGoeloBhrjtzz6UVZsqk38c3wI0D/
         MyTT1rA5R7pp0Q3V2XsxTqBanRqHaIGDQc4J1YpXdv4JHIiHoP41ycYF2LV1tmEWgQlu
         o1s1Abc9tMeN6z90avoECDSflHY4ZM5pjys8MHKUxrZAKs2V/zbIaSTeozd3JW/HPQWw
         qfVISK6IAPDg5kuVDzkP73ap+8DCs1AIC1lwdtFf4jkBwztUhijDJvGmXC8LkKhC1ecA
         eC8A==
X-Gm-Message-State: AOAM533cWN00IW3GKeTgkMgvguS/tgIQtUzpRwoPFgLntm0XnwfhM6yB
        nkabF5EV6Xjct9heqp4FcILQKEAYMgq68YSHHnMLwoS8RFKqKhe3BNmzWF8KJp7YblvRCIbhFgh
        +wqWIlOMjnEA+jET6
X-Received: by 2002:adf:a284:: with SMTP id s4mr18623941wra.397.1624740807296;
        Sat, 26 Jun 2021 13:53:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy51g0zVXFsx3qtzXx9+g9skdDDfLnzcyHJHqo7FgrR3Kz08bq7CFvMJC61Qt+M+lC3eQUskw==
X-Received: by 2002:adf:a284:: with SMTP id s4mr18623929wra.397.1624740807163;
        Sat, 26 Jun 2021 13:53:27 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z3sm14487102wmi.29.2021.06.26.13.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 13:53:26 -0700 (PDT)
Date:   Sat, 26 Jun 2021 22:53:23 +0200
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
Message-ID: <20210626205323.GA7042@pc-32.home>
References: <cover.1624572003.git.gnault@redhat.com>
 <84fe4ab5-4a80-abf8-675f-29a2f8389b1a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84fe4ab5-4a80-abf8-675f-29a2f8389b1a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 26, 2021 at 11:50:19AM -0600, David Ahern wrote:
> On 6/25/21 7:32 AM, Guillaume Nault wrote:
> > Some virtual L3 devices, like vxlan-gpe and gre (in collect_md mode),
> > reset the MAC header pointer after they parsed the outer headers. This
> > accurately reflects the fact that the decapsulated packet is pure L3
> > packet, as that makes the MAC header 0 bytes long (the MAC and network
> > header pointers are equal).
> > 
> > However, many L3 devices only adjust the network header after
> > decapsulation and leave the MAC header pointer to its original value.
> > This can confuse other parts of the networking stack, like TC, which
> > then considers the outer headers as one big MAC header.
> > 
> > This patch series makes the following L3 tunnels behave like VXLAN-GPE:
> > bareudp, ipip, sit, gre, ip6gre, ip6tnl, gtp.
> > 
> > The case of gre is a bit special. It already resets the MAC header
> > pointer in collect_md mode, so only the classical mode needs to be
> > adjusted. However, gre also has a special case that expects the MAC
> > header pointer to keep pointing to the outer header even after
> > decapsulation. Therefore, patch 4 keeps an exception for this case.
> > 
> > Ideally, we'd centralise the call to skb_reset_mac_header() in
> > ip_tunnel_rcv(), to avoid manual calls in ipip (patch 2),
> > sit (patch 3) and gre (patch 4). That's unfortunately not feasible
> > currently, because of the gre special case discussed above that
> > precludes us from resetting the MAC header unconditionally.
> 
> What about adding a flag to ip_tunnel indicating if it can be done (or
> should not be done since doing it is the most common)?

That's feasible. I didn't do it here because I wanted to keep the
patch series focused on L3 tunnels. Modifying ip_tunnel_rcv()'s
prototype would also require updating erspan_rcv(), which isn't L3
(erspan carries Ethernet frames). I was feeling such consolidation
would be best done in a follow up patch series.

I can repost if you feel strongly about it. Otherwise, I'll follow up
with the ip_tunnel_rcv() consolidation in a later patch. Just let me
know if you have any preference.

> > The original motivation is to redirect bareudp packets to Ethernet
> > devices (as described in patch 1). The rest of this series aims at
> > bringing consistency across all L3 devices (apart from gre's special
> > case unfortunately).
> 
> Can you add a selftests that covers the use cases you mention in the
> commit logs?

I'm already having a selftests for most of the tunnels (and their
different operating modes), gtp being the main exception. But it's not
yet ready for upstream, as I'm trying to move the topology in its own
.sh file, to keep the main selftests as simple as possible.
I'll post it as soon as I get it in good shape.

Thanks for the rewiew.

