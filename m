Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EBD391516
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhEZKkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbhEZKkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:40:15 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A4CC061574;
        Wed, 26 May 2021 03:38:43 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z17so573421wrq.7;
        Wed, 26 May 2021 03:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eEJBvAJNdQ3TWhc6UQ3SG7E4z1X44qBsRXW0KJTjH1o=;
        b=mk/VqvDz9f3oamLa6yPoeg1mnQupQXus5xIeeJLLan/2JVEKMiInbMvjAT8INq0dvX
         liwFn2RR6OLGan56VQg/uK2CmxJLy3FK41cmXoWc1K6Hz/J6eeJ3aN1AfP4x3wMq0/Df
         SL7KKaLpSRSAnnIJqChz1a+65q4scLJLHRgVnfCxDgcSAOW2DJTnifVLapMg5o8nGeFt
         /uX6uibj3c1IunGjfYzo3aJJh7RPWzd0fHGgSkgLRfk/EkPggaXv2n/v5aw/XINW6w24
         iL2A4KEKXNEmNfDvX97Gvh3O9Tsc8LpFVkItOW6RLjPifnFY0CjsKprQtelyk/77t7cJ
         jNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eEJBvAJNdQ3TWhc6UQ3SG7E4z1X44qBsRXW0KJTjH1o=;
        b=nwFjcdjJ4hZ9VPmij7hLLBGYxTUaEy9XSdYfHcrC72W7fjwUrlhRZrqfUt+gmb4tb3
         cCADWAsIr54j2uuL9dNoHuGRzsOVqTODKBxPZzmkJPN0dIF7C/oKi/zr5tfRNKbv0A2y
         EJ2SfGYuPT5Wpy9WtflL7Zq3ORU5MYq8Ui43/tF3cniwNUxnPdV7N2E4+zNpFyTiUkU0
         cDpaFRHyQ2ryYkIUar7FoaVerwbxr7VkmfZSepKpxhV3ALF9GhoKuqkV7kLBSM95VfWP
         IzUZBebjwB1pfa3Nq8/nHdgdiDSYxrS4ua7vXmhAom2CFN+Ki6wZ2SCQ+qEoiX2qEfEd
         o5pQ==
X-Gm-Message-State: AOAM530IlDxUrIx+SCq5Y5Aoh746le4kUcWaTNvq74YT4BrYc6eMrKx/
        KiVQ/kpwXxK8ZQQnM6YnBM0=
X-Google-Smtp-Source: ABdhPJyv681klVAeoQUcyBDU5ZgW2xtXgYmlCQ3xhAt3qu7f3vVdElrRTJ38SOgnrTSD/+JyfdqnLA==
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr2818584wrw.335.1622025521800;
        Wed, 26 May 2021 03:38:41 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:a50a:8c74:4a8f:62b3])
        by smtp.gmail.com with ESMTPSA id j101sm15364927wrj.66.2021.05.26.03.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 03:38:41 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Neal Cardwell <ncardwell@google.com>,
        Matt Mathis <mattmathis@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Leonard Crestez <lcrestez@drivenets.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFCv2 0/3] tcp: Improve mtu probe preconditions
Date:   Wed, 26 May 2021 13:38:24 +0300
Message-Id: <cover.1622025457.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
in order to accumulate enough data" but in practice linux only sends
probes when a lot of data accumulates on the send side.

Another improvement is to rely on TCP RACK performing timely loss detection
with fewer outstanding packets. If this is enabled the size required for a
probe can be shrunk.

Successive successful mtu probes will result in reducing the cwnd since
it's measured in packets and we send bigger packets. The cwnd value can get
stuck below 11 on low-latency links and this prevents further probing. The
cwnd logic in tcp_mtu_probe can be reworked to be based on the the number of
packets that we actually need to send instead of arbitrary constants.

It is difficult to improve this behavior without introducing unreasonable
delays or even stalls. Looking at the current behavior of tcp_mtu_probe it
already waits in some scenarios: when there is not enough room inside cwnd
or when there is a gap of unacklowledged data between snd_una and snd_nxt.
It appears that it is safe to wait if packets_in_flight() != 0.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>

---

Previous RFC: https://lore.kernel.org/netdev/cover.1620733594.git.cdleonard@gmail.com/

This series seems to be "correct" this time, I would appreciate any feedback.
It possible my understanding of when it is safe to return 0 from tcp_mtu_probe
is incorrect. It's possible that even current code would interact poorly with
delayed acks in some circumstances?

The tcp_xmit_size_goal changes were dropped. It's still possible to see strange
interactions between tcp_push_one and mtu probing: If the receiver window is
small (60k) the sender will do a "push_one" when half a window is accumulated
(30k) and that would prevent mtu probing even if the sender is writing more
than enough data in a single syscall.

Leonard Crestez (3):
  tcp: Use smaller mtu probes if RACK is enabled
  tcp: Adjust congestion window handling for mtu probe
  tcp: Wait for sufficient data in tcp_mtu_probe

 Documentation/networking/ip-sysctl.rst | 10 ++++
 include/net/netns/ipv4.h               |  2 +
 net/ipv4/sysctl_net_ipv4.c             | 14 ++++++
 net/ipv4/tcp_ipv4.c                    |  2 +
 net/ipv4/tcp_output.c                  | 70 +++++++++++++++++++++-----
 5 files changed, 86 insertions(+), 12 deletions(-)


base-commit: e4e92ee78702b13ad55118d8b66f06e1aef62586
-- 
2.25.1

