Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329813E1BD1
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241846AbhHES6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241061AbhHES6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:08 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08004C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:57:54 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id x15so8660955oic.9
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yVPLgQpPXe6+N9RqmGThhjXXoGbGoZZT+RMEhfb9dZ0=;
        b=uWVqTueJs5sKWacVP6wxSeFX7hUF3YqDH2C4nGH96ld6Yrzyy6+5jksS242PH6RWkm
         vyoUn7mPt5ZXWouupL1LIquqz8Zc1JOzuXWgveh9mzOEqcX/RrpjkNXQIqTnmcv0YE+f
         JXmS5Vj73rM8W59oYfq0yF4AixbW5J+CzoyHtc48HiBQotHaO3JxEQuU+BaWJNkBfBkc
         GDFY6EAXVlfW6epHu+FrGujgFeVZxJ3F4uuFMm0vMNCb7PiXVvISxNfl7xqR7Lqe7FJE
         8Rs0elyNBX0Q3tTlBnC20qowtzoI3jLrvKrr9PQjijdEWxIFmqejm6AAUwLK4kE/NhG5
         1hLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yVPLgQpPXe6+N9RqmGThhjXXoGbGoZZT+RMEhfb9dZ0=;
        b=AQpvCqa9xVT6becnwoHmpecpZJNdfCWp2ax6OLxCJbb6Tz3PiTjqs07Fu6tJzBDRm3
         9NzvHxOEkEg+BuZXFZL+NDd5OiGekdrHiNK3RFX+Pmsr0ZWhgCnhmRugvMUkk5o2CfJy
         KeSkcl3KokliprMLQpQRORYEGoFKMIAPzgGLz2bdjnCKwg7zXPPWrXWmoCGwUHDACltG
         VJvSZekAtI9T8BLTkwqYANqup+f/ct1P7MXV/gUe6OIJgCiUep8rrNL4/uSJBRx30YHN
         AxCyuMsouF4+VOJFpEwuJ/xxoW28GbD+GG1wIz0p8QNezTLgwnVGC5h+MJH5E9muTCFV
         z7lw==
X-Gm-Message-State: AOAM531uAGLUqnRx5OGiksF7OBZDWgrh2eV5Ae/M/YNC0qgXNypwwXsP
        YbYqYpnaxE6vD/tFGNQg6geXILzbaIk=
X-Google-Smtp-Source: ABdhPJwEcY8L19YAwqJvOpo8G4f/P5fOOSCIjiqWSAtxMyzqwUNOHKdQfOLEAHvLXza9RzEXeE5ypQ==
X-Received: by 2002:aca:919:: with SMTP id 25mr1902606oij.145.1628189873250;
        Thu, 05 Aug 2021 11:57:53 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:57:52 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 00/13] net: add more tracepoints to TCP/IP stack
Date:   Thu,  5 Aug 2021 11:57:37 -0700
Message-Id: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset adds 12 more tracepoints to TCP/IP stack, both
IPv4 and IPv6. The goal is to trace skb in different layers
and to measure the latency of each layer.

We only add information we need to each trace point. If any other
information is needed, it is easy to extend without breaking ABI,
see commit 3dd344ea84e1 ("net: tracepoint: exposing sk_family in all
tcp:tracepoints").

And similar to trace_qdisc_enqueue(), we only intend to trace
success cases, because most (if not all) failure cases can be traced
via kfree_skb() even if they are really interesting.

Lastly, per previous discussion, trace ring buffer is only accessible
to privileged users, it is safe to use a real kernel address with %px.

Qitao Xu (13):
  net: introduce a new header file include/trace/events/ip.h
  ipv4: introduce tracepoint trace_ip_queue_xmit()
  tcp: introduce tracepoint trace_tcp_transmit_skb()
  udp: introduce tracepoint trace_udp_send_skb()
  udp: introduce tracepoint trace_udp_v6_send_skb()
  ipv4: introduce tracepoint trace_ip_rcv()
  ipv6: introduce tracepoint trace_ipv6_rcv()
  ipv4: introduce tracepoint trace_ip_local_deliver_finish()
  udp: introduce tracepoint trace_udp_rcv()
  ipv6: introduce tracepoint trace_udpv6_rcv()
  tcp: introduce tracepoint trace_tcp_v4_rcv()
  ipv6: introduce tracepoint trace_tcp_v6_rcv()
  sock: introduce tracepoint trace_sk_data_ready()

 include/trace/events/ip.h   | 140 ++++++++++++++++++++++++++++++++++++
 include/trace/events/sock.h |  19 +++++
 include/trace/events/tcp.h  |  27 ++++++-
 include/trace/events/udp.h  |  74 +++++++++++++++++++
 net/core/net-traces.c       |   7 ++
 net/ipv4/ip_input.c         |   9 ++-
 net/ipv4/ip_output.c        |  10 ++-
 net/ipv4/tcp_input.c        |   8 ++-
 net/ipv4/tcp_ipv4.c         |   2 +
 net/ipv4/tcp_output.c       |   8 ++-
 net/ipv4/udp.c              |  17 ++++-
 net/ipv6/ip6_input.c        |   5 +-
 net/ipv6/tcp_ipv6.c         |   3 +
 net/ipv6/udp.c              |   9 ++-
 14 files changed, 327 insertions(+), 11 deletions(-)
 create mode 100644 include/trace/events/ip.h

-- 
2.27.0

