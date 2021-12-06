Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D93946A3E9
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345394AbhLFSZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:25:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229739AbhLFSZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:25:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638814927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=vkmi1zD7AYVB/zWL7w5X4qUYEksSpCeFlycmELGn/YU=;
        b=GkLE+9MnnmzJH1iU02KN5MmzoBq3/3UVCuhrNAXi+Vv5P0Yy69gH7v2MuD39sU3LsZen7a
        UI4MQVP7BW09ZomS2JZxI538TqvgC1BwJhfkJp6cl181j+iXKx03cfQ54DWoDYa2oEgOiL
        Vc1YerUD//xbH6e4RChMamLbLXtQd6I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-vsMdD73PN_KWswGPGz-g3g-1; Mon, 06 Dec 2021 13:22:06 -0500
X-MC-Unique: vsMdD73PN_KWswGPGz-g3g-1
Received: by mail-wm1-f70.google.com with SMTP id p12-20020a05600c1d8c00b0033a22e48203so256944wms.6
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 10:22:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=vkmi1zD7AYVB/zWL7w5X4qUYEksSpCeFlycmELGn/YU=;
        b=gzvyJ7aCB9MPjzbvK7hOejn2fdHFgaywAoHel5/rezG0FA56ln1uwJ8O6523oLg7s6
         GadX4zk5HIg6rjuFybXPuk3Lfn4v4jSUxPDK/pva851ky7xqUpcDjUcGAl/Go2iKHdQC
         Tfdnd0QFju6tan4pruOpkB1meCLAjb+FGCwTHr5G1dHlpx0HXiRxG7LQAIODmNT82rpS
         XIuoa3v0xWnowAlvK2KrY+b2NyO6Vx2C79om5cclcaI7qG+XMGYn/Yq7853nNtgnNZL/
         JCHabVdWG5fMe/ODgqvIvY6lOBUjHhc+/wp8aYcZmI13Op8ZPRCmWkT6R94bGKBdmG3J
         bC3w==
X-Gm-Message-State: AOAM531y08B5Pu7/MsWv+SnsrNbOiwLxpjMXn/YM4MBW6pS6SSeoU8K7
        3Z4G7pkEAPs8FYvTrZgOBHdhcVMCNyIChlq/aGZedppnCkm9e1lvANWR3FBnW5Pcd3ycK71bRJP
        4lgBoO6q6MbOnIzfU
X-Received: by 2002:a05:6000:168f:: with SMTP id y15mr44524224wrd.61.1638814925624;
        Mon, 06 Dec 2021 10:22:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwOE5DmxdwpjM4LalwUw1rHPRNgDkfR1GquAoIz5LWAWTBh4uQwYDN/kL29TurjJtBOPs+AQA==
X-Received: by 2002:a05:6000:168f:: with SMTP id y15mr44524182wrd.61.1638814925290;
        Mon, 06 Dec 2021 10:22:05 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id n32sm166352wms.1.2021.12.06.10.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:22:04 -0800 (PST)
Date:   Mon, 6 Dec 2021 19:22:02 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Russell Strong <russell@strong.id.au>
Subject: [PATCH net-next 0/4] inet: Separate DSCP from ECN bits using new
 dscp_t type
Message-ID: <cover.1638814614.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following my talk at LPC 2021 [1], here's a patch series whose
objective is to start fixing the problems with how DSCP and ECN bits
are handled in the kernel. This approach seemed to make consensus among
the participants, although it implies a few behaviour changes for some
corner cases of ip rule and ip route. Let's see if this consensus can
survive a wider review :).

The problem to solve
====================

Currently, the networking stack generally doesn't clearly distinguish
between DSCP and ECN bits. The entire DSCP+ECN bits are stored in a
single u8 variable (or structure field), and each part of the stack
handles them in their own way, using different macros.

This has been, and still is, the source of several bugs:

  * Invalid use of RT_TOS(), leading to regression in VXLAN:
      - a0dced17ad9d ("Revert "vxlan: fix tos value before xmit"")

  * Other invalid uses of RT_TOS() in IPv6 code, where it doesn't make
    sense (RT_TOS() follows the old RFC 1349, which was never meant for
    IPv6):
      - grep for 'ip6_make_flowinfo(RT_TOS(tos)' for several examples
        that need to be fixed.

  * Failure to properly mask the ECN bits before doing IPv4 route
    lookups, leading to returning a wrong route:
      - 2e5a6266fbb1 ("netfilter: rpfilter: mask ecn bits before fib lookup"),
      - 8d2b51b008c2 ("udp: mask TOS bits in udp_v4_early_demux()"),
      - 21fdca22eb7d ("ipv4: Ignore ECN bits for fib lookups in fib_compute_spec_dst()"),
      - 1ebf179037cb ("ipv4: Fix tos mask in inet_rtm_getroute()"),
      - some more, uncommon, code paths still need to be fixed.

Also, this creates inconsistencies between subsystems:

 * IPv4 routes accept tos/dsfield options that have ECN bits set, but
   no packet can actually match them, as their ECN bits are cleared
   before lookup.

 * IPv4 rules accept tos/dsfield options that have the high order ECN
   bit set (but rejects those using the low order ECN bit). Like IPv4
   routes, such rules can't match actual packets as the rule lookup is
   done after clearing the packets ECN bits.

 * IPv6 routes accept the tos/dsfield options without any restriction,
   but silently ignores them.

 * IPv6 rules also accept any value of tos/dsfield, but compares all
   8 bits, including ECN. Therefore, a rule matching packets with a
   particular DSCP value stops working as soon as ECN is used (a work
   around is to define 4 rules for each DSCP value to match, one for
   each possible ECN code point).

 * Modules that want to distinguish between the DSCP and ECN bits
   create their own local macros (Netfilter, SCTP).

What this RFC does
==================

This patch series creates a dscp_t type, meant to represent pure DSCP
values, excluding ECN bits. Doing so allows to clearly separate the
interpretation of DSCP and ECN bits and enables Sparse to detect
invalid combinations of dscp_t with the plain u8 variables generally
used to store the full TOS/Traffic Class/DS field.

Note, this patch series differs slightly from that of the original talk
(slide 14 [2]). For the talk, I just cleared the ECN bits, while in
this series, I do a bit-shift. This way dscp_t really represents DSCP
values, as defined in RFCs. Also I've renamed the helper functions to
replace "u8" by "dsfield", as I felt "u8" was ambiguous. Using
"dsfield" makes it clear that dscp_t to u8 conversion isn't just a
plain cast, but that a bit-shift happens and the result has the two ECN
bits.

The new dscp_t type is then used to convert several field members:

  * Patch 1 converts the tclass field of struct fib6_rule. It
    effectively forbids the use of ECN bits in the tos/dsfield option
    of ip -6 rule. Rules now match packets solely based on their DSCP
    bits, so ECN doesn't influence the result anymore. This contrasts
    with previous behaviour where all 8 bits of the Traffic Class field
    was used. It is believed this change is acceptable as matching ECN
    bits wasn't usable for IPv4, so only IPv6-only deployments could be
    depending on it (that is, it's unlikely enough that a someone uses
    ip6 rules matching ECN bits in production).

  * Patch 2 converts the tos field of struct fib4_rule. This one too
    effectively forbids defining ECN bits, this time in ip -4 rule.
    Before that, setting ECN bit 1 was accepted, while ECN bit 0 was
    rejected. But even when accepted, the rule wouldn't match as the
    packets would normally have their ECN bits cleared while doing the
    rule lookup.

  * Patch 3 converts the fc_tos field of struct fib_config. This is
    like patch 2, but for ip4 routes. Routes using a tos/dsfield option
    with any ECN bit set is now rejected. Before this patch, they were
    accepted but, as with ip4 rules, these routes couldn't match any
    real packet, since callers were supposed to clear their ECN bits
    beforehand.

  * Patch 4 converts the fa_tos field of struct fib_alias. This one is
    pure internal u8 to dscp_t conversion. While patches 1-3 dealed
    with user facing consequences, this patch shouldn't have any side
    effect and is just there to give an overview of what such
    conversion patches will look like. These are quite mechanical, but
    imply some code churn.

Note that there's no equivalent of patch 3 for IPv6 (ip route), since
the tos/dsfield option is silently ignored for IPv6 routes.

Future work
===========

This is a minimal series, the objective of this RFC is just to validate
the dscp_t approach. More work will be needed to fully iron out the
problem:

  * Convert more internal structures to dscp_t (in particular the
    flowi4_tos field of struct flowi4).

  * Slowly remove the uses of IPTOS_TOS_MASK, and hence RT_TOS(), in
    the kernel, as it clears only one of the ECN bits and the TOS is
    going to be masked again anyway by IPTOS_RT_MASK, which is
    stricter.

  * Finally, start allowing high DSCP values in IPv4 routes and rules
    (the IPTOS_RT_MASK used in IPv4 clears the 3 high order bits of the
    DS field).

  * Maybe find a way to warn users that use the ignored tos/dsfield
    option with ip -6 route.

Feedbacks welcome!

Thanks,

William

[1] LPC talk: https://linuxplumbersconf.org/event/11/contributions/943/
[2] LPC slides: https://linuxplumbersconf.org/event/11/contributions/943/attachments/901/1780/inet_tos_lpc2021.pdf


Guillaume Nault (4):
  ipv6: Define dscp_t and stop taking ECN bits into account in ip6-rules
  ipv4: Stop taking ECN bits into account in ip4-rules
  ipv4: Reject routes specifying ECN bits in rtm_tos
  ipv4: Use dscp_t in struct fib_alias

 include/net/inet_dscp.h  | 54 +++++++++++++++++++++++++++++++++++++
 include/net/ip_fib.h     |  3 ++-
 include/net/ipv6.h       |  6 +++++
 net/ipv4/fib_frontend.c  | 10 ++++++-
 net/ipv4/fib_lookup.h    |  3 ++-
 net/ipv4/fib_rules.c     | 17 ++++++------
 net/ipv4/fib_semantics.c | 14 +++++-----
 net/ipv4/fib_trie.c      | 58 +++++++++++++++++++++++-----------------
 net/ipv4/route.c         |  3 ++-
 net/ipv6/fib6_rules.c    | 18 ++++++++-----
 10 files changed, 138 insertions(+), 48 deletions(-)
 create mode 100644 include/net/inet_dscp.h

-- 
2.21.3

