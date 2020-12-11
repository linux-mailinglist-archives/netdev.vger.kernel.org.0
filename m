Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34632D82C5
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 00:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437258AbgLKXet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 18:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389512AbgLKXeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 18:34:24 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A73BC0613D3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 15:33:44 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id u8so3564417qvm.5
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 15:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=mnk0yNaQYUtc+OGm2Ej0P6u5h1xpL6GiZ/YPBHS5LOU=;
        b=c+eM5eQdQ+qiykEDoQ248iehOkFTnTi6bmZz/d+E0j8CJX7QCxjk8V3hpPsNuhBx7d
         2R8hJlVesC97oveCy4PMWfKfVWBOc7fk0umYrduba7carksZmqhlcbKjR4r1d1iRS08W
         /jvqX2Tr/4aHyAlhGUoDL5KEbqvaz3F363kf9i/w19D2vjmlN4KFowdkfgZj2VwMJXoh
         +sR49VR0qb7yNqjKfXqgPBMH9zWTKLmG/ipOsIp5wlM8l8JMeR/GTHcW4scrW7qj8Syq
         QEz5N0bmmL/3UifOOfG+XHMFi/gqGMmC6lR4LQPfXLiwZirO2XmO7raIUj2nv6eGWlEn
         iZvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=mnk0yNaQYUtc+OGm2Ej0P6u5h1xpL6GiZ/YPBHS5LOU=;
        b=Ct4rlblniOb7ihWPO7tes69v0LkWBDFTro/Y3WnOUyQiAMJxt+2g7zO1weo0aPt+pV
         BNA40Yo07ZAbORMv3dHDhpXf7PAV09ouN77S+XSfls0dBQaFjToSs+OY7CLkESGiffhZ
         bzc804Q3LAMSk9ciTuebCG5PwAPw9671E+3VmAZ1o/q6Vp/seq8CF6pIpnbN8nxPX/Gy
         p0bQL5pTIRlWx5j8QIKoxbVKSWvjz6FbE6xsCdI49RNZJKG7Gm7LEqP4YQb7/IacS+fx
         +IcMk9GmPt25ImFj90SuKrtXbniTZlGUgkne7ftXLGmUHMuJt+c7CK3W4ltgRs45cwDD
         bjng==
X-Gm-Message-State: AOAM532+mwCyvDjm4wpbZmGUlA+EglcknhQP9lM6u2JIItD1lPD3jXk1
        X2HaB02GUxRfhjh9ieLnjOHc3IiSQJaP
X-Google-Smtp-Source: ABdhPJw3rUExUwP8KkOPYO+NmCn8TOjKgcr1TfCSFfKJW1sOnzBlf40ElWIivAz7FlsIR8bHwBIXPS8NZ156
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a0c:f283:: with SMTP id
 k3mr13068839qvl.48.1607729623384; Fri, 11 Dec 2020 15:33:43 -0800 (PST)
Date:   Fri, 11 Dec 2020 23:33:36 +0000
Message-Id: <20201211233340.1503242-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v2 0/4] net: avoid indirect calls in dst functions
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: brianvv <brianvv@google.com>

Use of the indirect call wrappers in some dst related functions for the
ipv6/ipv4 case. This is a small improvent for CONFIG_RETPOLINE=y

Changed in v2:
-fix build issues reported by kernel test robot

brianvv (4):
  net: use indirect call helpers for dst_input
  net: use indirect call helpers for dst_output
  net: use indirect call helpers for dst_mtu
  net: indirect call helpers for ipv4/ipv6 dst_check functions

 include/net/dst.h     | 25 +++++++++++++++++++++----
 net/core/sock.c       | 12 ++++++++++--
 net/ipv4/ip_input.c   |  1 +
 net/ipv4/ip_output.c  |  1 +
 net/ipv4/route.c      | 13 +++++++++----
 net/ipv4/tcp_ipv4.c   |  5 ++++-
 net/ipv6/ip6_output.c |  1 +
 net/ipv6/route.c      | 13 +++++++++----
 net/ipv6/tcp_ipv6.c   |  5 ++++-
 9 files changed, 60 insertions(+), 16 deletions(-)

-- 
2.29.2.576.ga3fc446d84-goog

