Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AD52156F0
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbgGFMBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbgGFMBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:01:47 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21469C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:01:47 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id o13so15313652pgf.0
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HOvDjZdrCSwaOj0Z+PWQILLKjKsOX+gOJMlMMbd/iPY=;
        b=PsuZo0WU1Aw8U8G0cm0PKX5Ab1aEX0DRk4tyFEVAt0gGnoFjzcvsf6JnXF+dwRruv0
         yvkyrZ9BSUq4SO4DzUAiA5Ss4pmb8fVnRofcg9S3qCi0VVdrmGEgwmgAvHrmzXKgi39z
         sUY5pz0epTlJryGhyI+10XpGOC2XWhE6MHVhBKcwzh+E5jmflcnoIUdvxhOXhDr3zyjt
         Fd2Rx8vFWZWLUsSvRcrFKUB4IQe/7IQT6fwf7UtQ/gwaY/O9vBXk9hiegb1HRfFA09yD
         wxFRwRpYlApCeFyOSS8aUcM+0yjElZZ/7pQvsWGZnQTY0fyYf10HllkVYmrfbJUb0s3d
         ocgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HOvDjZdrCSwaOj0Z+PWQILLKjKsOX+gOJMlMMbd/iPY=;
        b=IA10NddMKer76zNvmFPAtPwmUITNjDwyw7XsEayskkmetmRK1bzrkBY5Fk6m4Ii53f
         zJREfTN66vjh9suT7aVxXO7UiGk3UoQxLhASrlahYL9BprmD6eNPFSPFmJRl1+HRoChV
         HGV8LUOkXKbOJCyLduDR/X5Wx6iUW2c3zBMZWAFxvwWwhNpFWCpo0xTCIZpnfbjZboyj
         fHOYe8gj5LLxQvjdvf+WdAu4Q7MiAHFOgrREdE0A08lgxIQtshMkhB2infAw7xWhb9u/
         bKt+7XWla7PNxT2Cvp9OlPrgVoKuJj4Y7sFgQ26y8hXBsI/LMOWmQHzsC/kpWKOaesZM
         V0/w==
X-Gm-Message-State: AOAM531J848ayKqCThkPyQy1sDBkfOv2WhPxvIDyiQubrp+hYB3tlaaj
        HaAC5eUnTyHs0nAPmg4n8zXdHRx+T+8=
X-Google-Smtp-Source: ABdhPJwysYeLv3AAWVGIwqwAwoI9vMV2V+z7ATbJLapdTBUUm0AW0wIr41B1VTzxMGxVFwjUPG82QA==
X-Received: by 2002:a65:6150:: with SMTP id o16mr25140414pgv.237.1594036906279;
        Mon, 06 Jul 2020 05:01:46 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k4sm18161390pjt.16.2020.07.06.05.01.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 05:01:45 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv3 ipsec-next 00/10] xfrm: support ipip and ipv6 tunnels in vti and xfrmi
Date:   Mon,  6 Jul 2020 20:01:28 +0800
Message-Id: <cover.1594036709.git.lucien.xin@gmail.com>
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
v2->v3:
  - See Patch 2-3, 4, 6, 9-10.

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

 include/net/xfrm.h        |  5 +++-
 net/ipv4/ip_vti.c         | 67 +++++++++++++++++++++++----------------------
 net/ipv4/ipcomp.c         |  1 +
 net/ipv4/tunnel4.c        | 43 +++++++++++++++++++++++++++++
 net/ipv6/ip6_vti.c        | 39 ++++++++++++++++++++++++++
 net/ipv6/ipcomp6.c        |  1 +
 net/ipv6/tunnel6.c        | 41 +++++++++++++++++++++++++++
 net/xfrm/xfrm_input.c     | 24 ++++++++--------
 net/xfrm/xfrm_interface.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 247 insertions(+), 44 deletions(-)

-- 
2.1.0

