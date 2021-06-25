Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B863B447D
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 15:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhFYNfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 09:35:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhFYNfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 09:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624627984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=4WGEeHEOrToI2S0MMtfDXbnl6cEpbPitw4MyHLwLqoQ=;
        b=MuoYfLIrbq1+bujHiPHBooki1ueGZ66fMYrAfM9TxksU/8GipK5ucAoX7PtN0rveuPuj8f
        Uj4EgUKxF8fs4A2m+rMvhL67NieEn2H24WnATTYMAXCDEysxjrrHtUFTqc6zvFmZ+JkRBP
        Z4SV88nVxNFdICHFI6msRVENBI/JzoQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-3vNXEGINNiqJOKZlIkXmjA-1; Fri, 25 Jun 2021 09:33:03 -0400
X-MC-Unique: 3vNXEGINNiqJOKZlIkXmjA-1
Received: by mail-wr1-f71.google.com with SMTP id j2-20020a5d61820000b029011a6a8149b5so3490516wru.14
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 06:33:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=4WGEeHEOrToI2S0MMtfDXbnl6cEpbPitw4MyHLwLqoQ=;
        b=D3SmD1Z5mAnsuTeOf0CqF06Ju1qJpBWZx5Ps8NKoDZUC+Qnp2XojwO1VeUxq4blrsG
         YJxi7D8gCyDResJYS1rQsackuaidHdjT5JA6bKxJ+JIqxtbp/UugLYCgtt0JsSvnFPke
         4AaxW5W+ldjWSVygDzver7dn1ya/zLIQ2aTLE3406ZX9LB+gFbrkmmT99cFyw3gtbTGb
         bCozrnajSxuM4Y2fhD/mODeSd+Uhy5wViSMa59+bXy7z01V1gHOVe+i0aG7OAGAUc2Su
         f9VJ67nMdOd5jmqsr9RuNRWoUg5yu7GlHtxu7NVzWhWIPuROADTOReN6lGy37735N9lq
         vs3g==
X-Gm-Message-State: AOAM533SIXP1x1OI+oQxvR8sQEPGQdprWxvnT48S4jp1ojNlZLFAGbCb
        OwFrChyBdTdOl2SJvBV0MgivkwZ83FfFLlB8F8xVJqQKe1Omz49AsSEJoqHgS7wyn8NxUoq8+ii
        AWGeqsppwAROa8mlr
X-Received: by 2002:a05:600c:2484:: with SMTP id 4mr10526731wms.76.1624627981711;
        Fri, 25 Jun 2021 06:33:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyN4fUx3P0hZBTGNc5FIRtCCifKaxZdOLobS56IQEHQ3c4qq9ZSygQenAK/93L0Kq+OMEkdAA==
X-Received: by 2002:a05:600c:2484:: with SMTP id 4mr10526706wms.76.1624627981487;
        Fri, 25 Jun 2021 06:33:01 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id l10sm6078893wrv.82.2021.06.25.06.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 06:33:01 -0700 (PDT)
Date:   Fri, 25 Jun 2021 15:32:59 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
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
Subject: [PATCH net-next 0/6] net: reset MAC header consistently across L3
 virtual devices
Message-ID: <cover.1624572003.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some virtual L3 devices, like vxlan-gpe and gre (in collect_md mode),
reset the MAC header pointer after they parsed the outer headers. This
accurately reflects the fact that the decapsulated packet is pure L3
packet, as that makes the MAC header 0 bytes long (the MAC and network
header pointers are equal).

However, many L3 devices only adjust the network header after
decapsulation and leave the MAC header pointer to its original value.
This can confuse other parts of the networking stack, like TC, which
then considers the outer headers as one big MAC header.

This patch series makes the following L3 tunnels behave like VXLAN-GPE:
bareudp, ipip, sit, gre, ip6gre, ip6tnl, gtp.

The case of gre is a bit special. It already resets the MAC header
pointer in collect_md mode, so only the classical mode needs to be
adjusted. However, gre also has a special case that expects the MAC
header pointer to keep pointing to the outer header even after
decapsulation. Therefore, patch 4 keeps an exception for this case.

Ideally, we'd centralise the call to skb_reset_mac_header() in
ip_tunnel_rcv(), to avoid manual calls in ipip (patch 2),
sit (patch 3) and gre (patch 4). That's unfortunately not feasible
currently, because of the gre special case discussed above that
precludes us from resetting the MAC header unconditionally.

The original motivation is to redirect bareudp packets to Ethernet
devices (as described in patch 1). The rest of this series aims at
bringing consistency across all L3 devices (apart from gre's special
case unfortunately).

Note: the gtp patch results from pure code inspection and has been
compiled tested only.


Guillaume Nault (6):
  bareudp: allow redirecting bareudp packets to eth devices
  ipip: allow redirecting ipip and mplsip packets to eth devices
  sit: allow redirecting ip6ip, ipip and mplsip packets to eth devices
  gre: let mac_header point to outer header only when necessary
  ip6_tunnel: allow redirecting ip6gre and ipxip6 packets to eth devices
  gtp: reset mac_header after decap

 drivers/net/bareudp.c | 1 +
 drivers/net/gtp.c     | 1 +
 net/ipv4/ip_gre.c     | 7 ++++++-
 net/ipv4/ipip.c       | 2 ++
 net/ipv6/ip6_tunnel.c | 1 +
 net/ipv6/sit.c        | 4 ++++
 6 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.21.3

