Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE05820EF9D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731077AbgF3Hgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731033AbgF3Hgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:36:44 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616F8C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:36:44 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id f2so8136614plr.8
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nyPZ+yhG/9MphYqV/w1vI/pXRqBdFZ9sH6U6Ou9xjKk=;
        b=jYRcYPrRgFjn32GQm6HOGtJYgUzsBKSVkew2BYXl3tPDiDoAaFGwy+b83BZsF9WeYu
         02scE/Hz9HwCvJom8nLcJw+mJIJwd4xudUUAQqu4MNyhlZbpHjtfdPfLOfno9Le0gIje
         8XBH9qdDwtdr4Yzds6mrtX7lttBl0U1LggslOG09PBs/kohmJOtQKsFFiuFzUVnIFcIh
         /vKVvksEEBR4gAICjCMZC73yByEePl7UKyG27HLS/ia2LaBME3o5ayjMDNcB8YNry3qR
         LeNYaf11hzJbIjLQFDiYzI/UVq8XY6jzhs+gKrBwmOSglK60WCq9TAH8wVc0uLdV5pmr
         Eo4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nyPZ+yhG/9MphYqV/w1vI/pXRqBdFZ9sH6U6Ou9xjKk=;
        b=S276FECk9J/eBrVzKWjz4CEmF4+PTd6hCLHdxNp1McE4vCSVBFK/aRZAOfZ8Da7Mjs
         d59BeDR991ypIGoFj7McntNoc0EsFV/p/i45cw480haWy47oyVc8z+6IQmJWHcUeFA65
         cNuW/XH6cl8qtIXTAMqqA+VdayMMlT+RHMXNkmrCHPVDPv+JmDW11C48HUDKySKtaWD3
         Vfac+AQZPqgDBv78vyoO4FDP4QDvj3Nda/Frs4LtsOXbgzYK/kz6VS1sarKWrzuhr5mn
         MdkAXT1pOp7VLhx5r5DR3jo/5laQHiDrU3ZLOV2dNvU10iglbtV486HF8WuIoGJCUn3w
         IN7g==
X-Gm-Message-State: AOAM531EcgR5kirMAfpwJp+UkwhQxAsjvklxOCdl9GViduOg01YXoE8Z
        JtQb5EdhJzq0FnsaXO61sm3kwHda
X-Google-Smtp-Source: ABdhPJxlgmkv6H4Dw4bOtF/kP0BfoXa7/XcKTfQLvM0Xh/DLg4xhqzY1W7+OcleR++cdj+Tj28Gx5A==
X-Received: by 2002:a17:902:3:: with SMTP id 3mr15289675pla.120.1593502603597;
        Tue, 30 Jun 2020 00:36:43 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j5sm1684066pgi.42.2020.06.30.00.36.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:36:42 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec-next 00/10] xfrm: support ipip and ipv6 tunnels in vti and xfrmi
Date:   Tue, 30 Jun 2020 15:36:25 +0800
Message-Id: <cover.1593502515.git.lucien.xin@gmail.com>
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

v1->v2:
  - See Patch 2-3.

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
 net/ipv4/tunnel4.c        | 35 +++++++++++++++++++++++++++++-
 net/ipv6/ip6_vti.c        | 31 +++++++++++++++++++++++++++
 net/ipv6/ipcomp6.c        |  1 +
 net/ipv6/tunnel6.c        | 34 +++++++++++++++++++++++++++++
 net/xfrm/xfrm_input.c     | 24 +++++++++++----------
 net/xfrm/xfrm_interface.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 194 insertions(+), 40 deletions(-)

-- 
2.1.0

