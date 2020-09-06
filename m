Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC3D25EC4E
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 05:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgIFDSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 23:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728491AbgIFDSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 23:18:48 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121A4C061573;
        Sat,  5 Sep 2020 20:18:47 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t14so906622pgl.10;
        Sat, 05 Sep 2020 20:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IpvK3HoqWAOQ1R8/ZzpsWMNP8syUhrNvFNEe7Tqcb3s=;
        b=tJ7JhfCZ94UYWX+SFvce6yHYkfntr/VvDxWFnsGypb6UPNU4pJSyJoeOQ0J3yPGd5d
         NErVoENMGhJmuMZwZoycmnvNeDICFktYKxah28bPAUEJoNIa+LY9vo0gTnJPDabqO/JM
         ymjE/k3uj6RzK3ko+Ctj+BEdGxfSscx/zjbO3/OumkawsTs+wYWgjYs9/NJbEGXxrqIy
         w/cH0J/B2vHW/pMpHC1TZq/AeKSzH+R1TJfWe3/EQunEk3fHLLszbCwEsHahpXlD5NkM
         WYzW8qFgVnlMUXaSz+24hR4ZNIFO5D8ikHXKpFe9sWgq2OZuR+RNy7llvA8zP0Abjxzd
         foKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IpvK3HoqWAOQ1R8/ZzpsWMNP8syUhrNvFNEe7Tqcb3s=;
        b=k8i4BotN9g3i0VT/kpLvVX/U3tW7XoFp6RJQz4EjLTaOCg4wj5qVYevKwi1VBAnb9t
         B7fbUy6VUeo9p6liPUze2g4AvVx909VCVFvmxI9iHOhuOs835ci4nxa//fHp/6JKCEJI
         cpGratv7dU8oVqgq+PliEQXedQwjb3owkfSZYTD3OC8DD2QwVI5V7UU0vCFm5lKz8tQe
         OvJ+tgHT6VlNY+AertzXX8zOkEdw7DcG0LXo5zPxUsNVK+uYR54bWrOvqVghObpFC2fZ
         6VZ+ic/5J52wqSGHqlF+ExeGQWGoCg++AQKM08ubyMcpq7glwonN7pmFgDRF05tQ1wy1
         V2mQ==
X-Gm-Message-State: AOAM532Ch50LPCIWlFKfppMm+9ldwxl45MBA9h9tSDN0BBPZVtIh/hVv
        703IqCQ1ayylSqHWRaJV1ME=
X-Google-Smtp-Source: ABdhPJwzuqHYpfbk2NKD08MkaOrVYTXanNjNJx+Nn2mSZU7LvdBDhZ8TGqvGNcLCITGFhaQJ/mKvWQ==
X-Received: by 2002:a63:2a89:: with SMTP id q131mr12311424pgq.330.1599362327091;
        Sat, 05 Sep 2020 20:18:47 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:2d19:46ee:e8e6:366f])
        by smtp.gmail.com with ESMTPSA id 203sm10878779pfz.131.2020.09.05.20.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 20:18:46 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Mao Wenan <maowenan@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Arnd Bergmann <arnd@arndb.de>, Xie He <xie.he.0141@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH net] net/packet: Fix a comment about hard_header_len and headroom allocation
Date:   Sat,  5 Sep 2020 20:18:26 -0700
Message-Id: <20200906031827.16819-1-xie.he.0141@gmail.com>
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

In this file, the function packet_snd first reserves a headroom of
length (dev->hard_header_len + dev->needed_headroom).
Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
which calls dev->header_ops->create, to create the link layer header.
If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
length (dev->hard_header_len), and checks if the user has provided a
header of length (dev->hard_header_len) (in dev_validate_header).
This shows the developers of af_packet.c expect hard_header_len to
be consistent with header_ops.

2.

In this file, the function packet_sendmsg_spkt has a FIXME comment.
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
setting needed_headroom. This means this usage is already adopted by
driver developers.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/packet/af_packet.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 2b33e977a905..c808c76efa71 100644
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
+     outside of the device. In this case, its hard_header_len should be 0.
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

