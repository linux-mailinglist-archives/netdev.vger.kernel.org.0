Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B33268645
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgINHmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgINHmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:42:04 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56756C06174A;
        Mon, 14 Sep 2020 00:42:04 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id md22so4789885pjb.0;
        Mon, 14 Sep 2020 00:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Lks6efxXFomrH6KYFBOQMjC6drBRK3wyX746XI+NTs=;
        b=c0lpRyd7AVhRwxvB9sYkoZxIBUBDHbPm5xC/e6KabWR9RKDBwTu7N5rYFm1p54MkGU
         ZnKTJoQJPuzio5lNEVT4sIvUfr/ckB3e/83L3YKdW8Pd1UC5m9wxLyBa6JeqHwXMMe6h
         BEE9p6mOTe2ubtNVpg6dHclD3RruI2yt/MFNKGuAcc1RimQfeUWcgddUFHKF6g6QG4Sj
         KIqlnZqPqM0I9+LyRvLrUlKmDwZgjTGOvAnQPsJNv8M8mXXfD4/MKkfCuk5k6I9i5Qni
         /w4EwjRU6PG6t4qA7QWk/tPuNxq0OQrT1SsnsuDvWF/8X1V3ojmGyKo+TQnFDOWEqdKV
         WuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Lks6efxXFomrH6KYFBOQMjC6drBRK3wyX746XI+NTs=;
        b=jmj3aZRvlozfDGEyCYVEseu/Gc/JIxGHjvMjqM1cJI/NyJfvGtBVS+7DVheF8M7KdP
         FR/Muakuu1nBKUNXb/k7E1cUZWraE8sGQeLR496mSDFOU1eEhPcGR5Or+I5RS/NpeMXM
         8r/4YzyA9hGNDRvlU457gfGBcpWVxwfkJqlFNhKzJaGnuIddOP6qhQMAfwV+vFTDF7cR
         /uN7WvfLeY5Sm3wLRDzemHiDMVm3lDx6DVAmHbEKyJ7DhQ8I459hlf0L5Pf6OfINTKa3
         2KD9IYkVi+vj+6GF09eyBOYaicxRKyIcf144CkbEF0O1f5YS2s/B91R4dTRJJxMUuqMs
         lx8g==
X-Gm-Message-State: AOAM533TY1bT792rkmZX1a6fgYmtLR6riF/nMFb1IYqPKUf2mslnbssI
        iGaX8G3F/GJOK2UdrcUj6zRvuBhG074=
X-Google-Smtp-Source: ABdhPJzvkfmZravMN4vZoGHd4ltV16sBO1vu46ZnJfR70QIVfpCb5nT8jMYO1MlSH1lfUKiP4Hmxng==
X-Received: by 2002:a17:90a:8588:: with SMTP id m8mr12190268pjn.91.1600069323896;
        Mon, 14 Sep 2020 00:42:03 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:d0fe:61cf:2e8d:f96])
        by smtp.gmail.com with ESMTPSA id o20sm8182050pgh.63.2020.09.14.00.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:42:03 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH net-next v2] net/packet: Fix a comment about hard_header_len and headroom allocation
Date:   Mon, 14 Sep 2020 00:41:54 -0700
Message-Id: <20200914074154.1255716-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This comment is outdated and no longer reflects the actual implementation
of af_packet.c.

Reasons for the new comment:

1.

In af_packet.c, the function packet_snd first reserves a headroom of
length (dev->hard_header_len + dev->needed_headroom).
Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
which calls dev->header_ops->create, to create the link layer header.
If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
length (dev->hard_header_len), and checks if the user has provided a
header sized between (dev->min_header_len) and (dev->hard_header_len)
(in dev_validate_header).
This shows the developers of af_packet.c expect hard_header_len to
be consistent with header_ops.

2.

In af_packet.c, the function packet_sendmsg_spkt has a FIXME comment.
That comment states that prepending an LL header internally in a driver
is considered a bug. I believe this bug can be fixed by setting
hard_header_len to 0, making the internal header completely invisible
to af_packet.c (and requesting the headroom in needed_headroom instead).

3.

There is a commit for a WiFi driver:
commit 9454f7a895b8 ("mwifiex: set needed_headroom, not hard_header_len")
According to the discussion about it at:
  https://patchwork.kernel.org/patch/11407493/
The author tried to set the WiFi driver's hard_header_len to the Ethernet
header length, and request additional header space internally needed by
setting needed_headroom.
This means this usage is already adopted by driver developers.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/packet/af_packet.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index af6c93ed9fa0..2d5d5fbb435c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -93,12 +93,15 @@
 
 /*
    Assumptions:
-   - if device has no dev->hard_header routine, it adds and removes ll header
-     inside itself. In this case ll header is invisible outside of device,
-     but higher levels still should reserve dev->hard_header_len.
-     Some devices are enough clever to reallocate skb, when header
-     will not fit to reserved space (tunnel), another ones are silly
-     (PPP).
+   - If the device has no dev->header_ops, there is no LL header visible
+     above the device. In this case, its hard_header_len should be 0.
+     The device may prepend its own header internally. In this case, its
+     needed_headroom should be set to the space needed for it to add its
+     internal header.
+     For example, a WiFi driver pretending to be an Ethernet driver should
+     set its hard_header_len to be the Ethernet header length, and set its
+     needed_headroom to be (the real WiFi header length - the fake Ethernet
+     header length).
    - packet socket receives packets with pulled ll header,
      so that SOCK_RAW should push it back.
 
-- 
2.25.1

