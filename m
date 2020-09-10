Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A2D263CAB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 07:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgIJFnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 01:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgIJFnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 01:43:39 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD70C061573;
        Wed,  9 Sep 2020 22:43:37 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d19so366756pld.0;
        Wed, 09 Sep 2020 22:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=di1goxFupnGyNP6fSKn5I/OqYyLz699zXGy1HXQIcso=;
        b=pltYjI2/rYpbfvhSB3S0DHUsuxuVT6N0zKDh1mEa/LU5Qp/JewtEZ2LnYwmT8J8fvj
         K83LwfjydpkwlaphU0jxeVLmwQfYV2g92HYwkl8lWX1aH5L9igy/P0Dzit/X143HqLYk
         mURDzGgN3u1vUjBbg929nf1dr/WbL/3MRn1iATs93fgvEjEX32UJd+NzWOTyCaEKKu9Q
         Ekp72veYPmbOnHhJ2BpR1RVGuLmxWIGYo4Su6fzbhe/N2fOg6aIBP3Csg+M3qQQSFY9K
         4fPB/J1oxktO5ANLvZiVQaY/SeyNkfcbBDO5H2rjQszjtuodJqEkppJSimKZI/yNVirf
         vQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=di1goxFupnGyNP6fSKn5I/OqYyLz699zXGy1HXQIcso=;
        b=AWdPTnkz8nGbZfVGyi6Vff5yYrdbWllyyGNocFi63FuEqX986NzLBmc6d4Uicprbe/
         d4D/j3VPuxHZx5wOLZLpUW1HCuzDQ6CREpPyOwt0VwKpWnSMmXlfs2QtxjP5CcODfdAm
         vf/FeoJ9bStIwSfGitw0hN9PmOYpLoiBE37CNgf+TEPWTsiSNKAjT3NW0Yfoxef3mjv0
         CRz3I4lErHyTz7kx/oPuufaptq38wdyPnkQDNcN+Hz9msJ6C7GgqIRAwA3Rcb6NYH0e8
         UWQZU1cwLEe+Jc7VDZoCLSQZd3DYI72nXq07IQfDGH5CSL52RRllMlE+T/vc07IRX0Ks
         Ekxg==
X-Gm-Message-State: AOAM530LE2mqyHb/nkTusCTEy5NaFkm4V+ucl6+ueYzVOoBI25Lwdx0G
        Fk5Nsp287kbVGYX75BTiLVU=
X-Google-Smtp-Source: ABdhPJzyjROpGAWrpe+NSxf0hqYA/v53VQgX3FgXUkMaTFOUct2efcsN1WnknMlC+e7I5hkriVDH2A==
X-Received: by 2002:a17:902:264:: with SMTP id 91mr4139984plc.88.1599716617454;
        Wed, 09 Sep 2020 22:43:37 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6c81:1272:e4d7:3185])
        by smtp.gmail.com with ESMTPSA id u2sm858303pji.50.2020.09.09.22.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 22:43:36 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH net v2] net: Clarify the difference between hard_header_len and needed_headroom
Date:   Wed,  9 Sep 2020 22:43:33 -0700
Message-Id: <20200910054333.447888-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The difference between hard_header_len and needed_headroom has long been
confusing to driver developers. Let's clarify it.

The understanding on this issue in this patch is based on the following
reasons:

1.

In af_packet.c, the function packet_snd first reserves a headroom of
length (dev->hard_header_len + dev->needed_headroom).
Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
which calls dev->header_ops->create, to create the link layer header.
If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
length (dev->hard_header_len), and checks if the user has provided a
header of length (dev->hard_header_len) (in dev_validate_header).
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
setting needed_headroom. This means this usage is already adopted by
driver developers.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---

Change from v1:
Small change to the commit message.

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

