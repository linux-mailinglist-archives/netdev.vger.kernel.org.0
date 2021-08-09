Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9326C3E4C71
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 20:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbhHISyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 14:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbhHISyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 14:54:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14F9C06179A
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 11:53:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso377050pjb.2
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 11:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=msDBfvypGF+QFncTPxEyuELjbqMQjQ7a4HrzvWfjHnk=;
        b=OvlIPZfBS2S1KnY2gu3S8oZHPlroB9+JSYPCwKTG7mwHf3j2qU32XgVlG5kWrfAxkU
         KwtXoMkdXMV+RU7WDyLeaz6HwSS4tTRfg/Mlwx1zV+WwQNuAfffq1rN66QlE5K+aL94y
         +kCFbnJBRFcGzMWNq+k6mmMtCH8me5gkV01dJTCMbgmQEZvq7eGPtAQ/21Z0O5FuAdFr
         DrXBxuqtImpMMUSSOx9DSdP2tPILgvWyPKizQ3K60rsV3bldWigBv6M8RX2YlOeVAGyc
         Gb2pyF8Au3gO2Z4bm0kK4acGZtL6ABFRnxvjXwdGdCg2UdRK19HiU9aA4TasVAUFYzPQ
         jqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=msDBfvypGF+QFncTPxEyuELjbqMQjQ7a4HrzvWfjHnk=;
        b=guBxSqUXAOHHS06RH+u1f8ijY90Cu5AnAnAIrlhC+7Pg+Dm881rFhqm3t32s8bU3fP
         Tslr7kaMBBfryHSE+6J7XP9wY7agGJ6GrTicGqy9D+/t7B8h6a8KfX1fpElvC6BNXSMH
         bcArRryvuDFCRAKhONDIsVOTclmnJBsgk9Ay1QX6Drzb6EWEmlaixxr1r0OTBteMsjrD
         HGWqlzAqhx5ip1JCArwXTPatG6zi1cyAVI5tH2ndUWglA/6nfM+03x16vMFNqwkpTtyX
         DxzarutrPI+We+XyrGupU7tDQvfD/Rd2vxfQK/AGU7644ZQrytLA+2mPPm65MYRtnB36
         GUWQ==
X-Gm-Message-State: AOAM531QbYC+kvfR5D5fxFqJ3YlltUDrEClB0z7QpbqZXXdRrnY+eQUU
        30oVc1QRBgVLo6x28Y/NVGmc7i/oZ3MTbYNA
X-Google-Smtp-Source: ABdhPJxa7kSztu5s2jyuQdQLo9uDgLZ8irKinKRh9XrVP5OOTcG5nFOdgDfcIqGXdY+93RzP36X1uQ==
X-Received: by 2002:a62:8fd4:0:b029:3af:3fa7:c993 with SMTP id n203-20020a628fd40000b02903af3fa7c993mr25391796pfd.77.1628535223876;
        Mon, 09 Aug 2021 11:53:43 -0700 (PDT)
Received: from localhost.localdomain ([12.33.129.114])
        by smtp.gmail.com with ESMTPSA id b28sm21255364pff.155.2021.08.09.11.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 11:53:43 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, brakmo@fb.com,
        ycheng@google.com, eric.dumazet@gmail.com, a.e.azimov@gmail.com
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH net-next 0/3] txhash: Make hash rethink configurable and change the default
Date:   Mon,  9 Aug 2021 11:53:11 -0700
Message-Id: <20210809185314.38187-1-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Azimov performed some nice analysis of the feature in Linux
stack where the IPv6 flow label is changed when the stack detects a
connection is failing. The idea of the algorithm is to try to find a
better path. His reults are quite impressive, and show that this form
of source routing can work effectively.

Alex raised an issue in that if the server endpoint is an IP anycast
address, the connection might break if the flow label changes routing
of packets on the connection. Anycast is known to be susceptible to
route changes, not just those caused be flow label. The concern is that
flow label modulation might increases the chances that anycast
connections might break, especially if the rethink occurs after just
one RTO which is the current behavior.

This patch set makes the rethink behavior granular and configurable.
It allows control of when to do the hash rethink: upon negative advice,
at RTO in SYN state, at RTO when not in SYN state. The behavior can
be configured by sysctl and by a socket option.

This patch set the defautl rethink behavior to be to do a rethink only
on negative advice. This is reverts back to the original behavior of
the hash rethink mechanism. This less aggressive with the intent of
mitigating potentail breakages when anycast addresses are present.
For those users that are benefitting from changing the hash at the
first RTO, they would retain that behavior by setting the sysctl.
*** BLURB HERE ***

Tom Herbert (3):
  txhash: Make rethinking txhash behavior configurable via sysctl
  txhash: Add socket option to control TX hash rethink behavior
  txhash: Change default rethink behavior to be less aggressive

 arch/alpha/include/uapi/asm/socket.h  |  2 ++
 arch/mips/include/uapi/asm/socket.h   |  2 ++
 arch/parisc/include/uapi/asm/socket.h |  2 ++
 arch/sparc/include/uapi/asm/socket.h  |  3 ++-
 include/net/netns/core.h              |  2 ++
 include/net/sock.h                    | 32 +++++++++++++++++++--------
 include/uapi/asm-generic/socket.h     |  2 ++
 include/uapi/linux/socket.h           | 13 +++++++++++
 net/core/net_namespace.c              |  4 ++++
 net/core/sock.c                       | 16 ++++++++++++++
 net/core/sysctl_net_core.c            |  7 ++++++
 net/ipv4/tcp_input.c                  |  2 +-
 net/ipv4/tcp_timer.c                  |  5 ++++-
 13 files changed, 80 insertions(+), 12 deletions(-)

-- 
2.25.1

