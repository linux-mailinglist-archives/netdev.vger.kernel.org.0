Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483F71FBD1B
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730942AbgFPRgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 13:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbgFPRgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:36:44 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309B2C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:36:44 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l63so7282712pge.12
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kY7Alm4KlRN97e4pnSq6wGOFcxFcxgnyBrwZTBIF/tE=;
        b=gqBTXRrNt4+wuk/YO3WFCKXkL+w2mfFSALDUQBZJrYONkZJJcwVy++mVK+4KvjH/2g
         4xToniRSKL0IC1zFBfUrEdT4xACLvG4Gr1Vb0lpUbdFJb69lK7xrL9Ztjd0wkLtt73bH
         2rOfP551qQGUZ+k8sSO+CronALcadrRVVEezwMrfdJxpV/aY+MZM1Jl5xUYwZ4/S6yqG
         F7X2GDn25sPwtMA8KQSEu4cQb4id3Wn+clyzNNm7g2tH/+vAw7ZieFg9kcbdszMspV8R
         S5frg/N+q1V0mP5Xmr7ERlB6tMfscBktFzEm3/Fu1/gEZX/w0uIJGshAcYdJDvDqbObu
         4lfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kY7Alm4KlRN97e4pnSq6wGOFcxFcxgnyBrwZTBIF/tE=;
        b=X4nfd4LEBjWDTcmk600+XrXH/q8cQQ7WquGK1qdqsaeIoFyAQ4onnl/M5ukHEuCgGk
         KOBZxpEXhE16CuYq8qOBYPOuck+P1/G/i3D3y2vCjEhxYGekrzez5V2urgRUXDuPPQ5X
         GRhH3+6cnCpGrgCYDe747mHbZyPDrM3lyMBgFaclwWuf8GDbIbCKKQ5c0/OUnF49/KLk
         MCPbhzwmVW2HoGUtowqIBLPtm7NaYFlxk4ovQCe4fjHxUuPGDoyTGnq1aDTkfMG2nUeA
         nWF1coboBnf242J5e/nOBFlNA2OiiLeEEItZzsTZkZFgXUbMS5fqr8o4pkwUNdvTVDoD
         5iPA==
X-Gm-Message-State: AOAM5326zM+e5ia66wnT/5p88JIciTDuNcnqhSjnmTHuKECPMaYWLg6b
        5R00+AnRme0Vtkr1yiqYVMJiKhcy17k=
X-Google-Smtp-Source: ABdhPJwqGtmU7VwW1jWONuLptkkVzTt6SFsH/v8uZRYAdu+vR3Vn69mPYZs+COyeBOA7na6Ea2pnww==
X-Received: by 2002:a65:4bc8:: with SMTP id p8mr2904296pgr.418.1592329003412;
        Tue, 16 Jun 2020 10:36:43 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o18sm19653819pfu.138.2020.06.16.10.36.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 10:36:42 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 00/10] xfrm: support ipip and ipv6 tunnels in vti and xfrmi
Date:   Wed, 17 Jun 2020 01:36:25 +0800
Message-Id: <cover.1592328814.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now ipip and ipv6 tunnels processing is supported by xfrm4/6_tunnel,
but not in vti and xfrmi. This feature is needed by processing those
uncompressed small fragments and packets when using comp protocol.
It means vti and xfrmi won't be able to accept small fragments or
packets when using comp protocol, which is not expected.

xfrm4/6_tunnel eventually calls xfrm_input() to process ipip and ipv6
tunnels with an ipip/ipv6-proto state (a child state of comp-proto
state), and vti and xfrmi should do the same.

The extra things for vti to do is:

  - vti_input() should be called before xfrm_input() to set
    XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4/6 = tunnel. [A]

  - vti_rcv_cb() should be called after xfrm_input() to update
    the skb->dev. [B]

And the extra things for xfrmi to do is:

   - The ipip/ipv6-proto state should be assigned if_id from its
     parent's state. [C]

   - xfrmi_rcv_cb() should be called after xfrm_input() to update
     the skb->dev. [D]


Patch 4-7 does the things in [A].

To implement [B] and [D], patch 1-3 is to build a callback function
for xfrm4/6_tunnel, which can be called after xfrm_input(), similar
to xfrm4/6_protocol's .cb_handler. vti and xfrmi only needs to give
their own callback function in patch 4-7 and 9-10, which already
exists: vti_rcv_cb() and xfrmi_rcv_cb().

Patch 8 is to do the thing in [C] by assigning child tunnel's if_id
from its parent tunnel.

With the whole patch series, the segments or packets with any size
can work with ipsec comp proto on vti and xfrmi.

Xin Long (10):
  xfrm: add is_ipip to struct xfrm_input_afinfo
  tunnel4: add cb_handler to struct xfrm_tunnel
  tunnel6: add tunnel6_input_afinfo for ipip and ipv6 tunnels
  ip_vti: support IPIP tunnel processing with .cb_handler
  ip_vti: support IPIP6 tunnel processing
  ip6_vti: support IP6IP6 tunnel processing with .cb_handler
  ip6_vti: support IP6IP tunnel processing
  ipcomp: assign if_id to child tunnel from parent tunnel
  xfrm: interface: support IP6IP6 and IP6IP tunnels processing with
    .cb_handler
  xfrm: interface: support IPIP and IPIP6 tunnels processing with
    .cb_handler

 include/net/xfrm.h        |  5 ++++-
 net/ipv4/ip_vti.c         | 49 +++++++++++++++++++-----------------------
 net/ipv4/ipcomp.c         |  1 +
 net/ipv4/tunnel4.c        | 26 +++++++++++++++++++++++
 net/ipv6/ip6_vti.c        | 31 +++++++++++++++++++++++++++
 net/ipv6/ipcomp6.c        |  1 +
 net/ipv6/tunnel6.c        | 26 +++++++++++++++++++++++
 net/xfrm/xfrm_input.c     | 24 +++++++++++----------
 net/xfrm/xfrm_interface.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 178 insertions(+), 39 deletions(-)

-- 
2.1.0

