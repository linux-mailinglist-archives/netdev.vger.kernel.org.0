Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964D32639CB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgIJCCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730108AbgIJBwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 21:52:30 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0729C0617BB;
        Wed,  9 Sep 2020 16:37:21 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q4so2091932pjh.5;
        Wed, 09 Sep 2020 16:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wy3pvFIOU9AYRFOAORk2oZwAI6ceicLhp4MvjKovBaM=;
        b=EKt8/cIS7m5Yk5BJIDHf7lewFwarx+7K29iGHkunzvAlV2DA7iPhuATSBxKMrbYG2j
         ifP/s6huRhzKNuzP1rRLUNTgszkZhVDowO6PgjWmV+2TXU2+fTAMHr/HMbyIuupX0AQY
         gRIAuIgqkzzR0SOqyI0P0PCWOvtPvczVI6HrpqXtPygh6V/gMzkSl2LftY5S4BDbMCAh
         LjtUDdc5QCOE+3ZAwKkKSOIafOOA3r6LgP2GSFKqDHkKLFtNxl3N0meI+k/fprpdlXRY
         rnX/MTJtzLz2YrvSRqvjkKXf/2h4gv2amVaOLkLMpuhHBiiI8vN2/CkH+/MSUrHum4Go
         FIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wy3pvFIOU9AYRFOAORk2oZwAI6ceicLhp4MvjKovBaM=;
        b=cygzhSklN9eQHND4MRaxJ5B+0MKjIwkQ8BDvpDfD97WP1cnZ4R8OqE6QMqTQQmUAoU
         80ADu1FcsIfLQfUpQBSqqdsxIksiEg/m4sElaL1GbvGsEjzdkniCpBISaD0bzlP6yCbR
         BZPtlAs4UPFVxYMe/y7unc9J4FV2bJKYRFzAjsSzj8xUZ32W2wYpMD61FJnc+v0bmA7W
         UARWyhu3NzjVGQgKXMJJKAYlNVnDFttEtxz7TZtBwL/uDRlx0ojE7EVFBBEwL86iaFhQ
         FNGFi4YqrkvTcJtb4hJDS27kylcNnJBBjcMh1MSOQzhCndX8SyWcC1fHxK9hnZT/Wf6B
         Uvgg==
X-Gm-Message-State: AOAM531FBajkh+N7tOqkf2F5SExnrF27FwlqnkPbrjtnDEZ030EPxGdR
        Btk4bQESU2KEHXuttH3g01XicjOmPs8=
X-Google-Smtp-Source: ABdhPJwxXqC1C4u6pEI1JyGeQvQiOf9hrSJ7lYII5Q7df8ofr6Mfjd5ELzMFhzAnPOz5DbMa4QwoPw==
X-Received: by 2002:a17:90a:de17:: with SMTP id m23mr2846141pjv.51.1599694641402;
        Wed, 09 Sep 2020 16:37:21 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6c81:1272:e4d7:3185])
        by smtp.gmail.com with ESMTPSA id e14sm3192638pgu.47.2020.09.09.16.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 16:37:20 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH net] net: Clarify the difference between hard_header_len and needed_headroom
Date:   Wed,  9 Sep 2020 16:37:15 -0700
Message-Id: <20200909233715.425941-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The difference between hard_header_len and needed_headroom has long been
confusing to driver developers. Let's clarify it.

The understanding of the difference in this patch is based on the
following reasons:

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
 include/linux/netdevice.h |  4 ++--
 net/packet/af_packet.c    | 19 +++++++++++++------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7bd4fcdd0738..3999b04e435d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1691,8 +1691,8 @@ enum netdev_priv_flags {
  *	@min_mtu:	Interface Minimum MTU value
  *	@max_mtu:	Interface Maximum MTU value
  *	@type:		Interface hardware type
- *	@hard_header_len: Maximum hardware header length.
- *	@min_header_len:  Minimum hardware header length
+ *	@hard_header_len: Maximum length of the headers created by header_ops
+ *	@min_header_len:  Minimum length of the headers created by header_ops
  *
  *	@needed_headroom: Extra headroom the hardware may need, but not in all
  *			  cases can this be guaranteed
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 2b33e977a905..0e324b08cb2e 100644
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
 
@@ -2937,10 +2940,14 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	skb_reset_network_header(skb);
 
 	err = -EINVAL;
+	if (!dev->header_ops)
+		WARN_ON_ONCE(dev->hard_header_len != 0);
 	if (sock->type == SOCK_DGRAM) {
 		offset = dev_hard_header(skb, dev, ntohs(proto), addr, NULL, len);
 		if (unlikely(offset < 0))
 			goto out_free;
+		WARN_ON_ONCE(offset > dev->hard_header_len);
+		WARN_ON_ONCE(offset < dev->min_header_len);
 	} else if (reserve) {
 		skb_reserve(skb, -reserve);
 		if (len < reserve + sizeof(struct ipv6hdr) &&
-- 
2.25.1

