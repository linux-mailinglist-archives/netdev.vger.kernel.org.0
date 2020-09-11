Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D05326588B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 07:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgIKFEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 01:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgIKFEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 01:04:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F36AC061573;
        Thu, 10 Sep 2020 22:04:09 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id md22so2126678pjb.0;
        Thu, 10 Sep 2020 22:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yx/Fke02HsLsqjZq568nqGFfeg9NCMSeHqBf+5WYna4=;
        b=My6Po2Fp0H3kk+XIwNPn/IeW7vpf1VjXcZbND/d8ERdJMluqOgvpZTX/+gmA/hPqSE
         DO3qYso7L6vS4LuRhEaIJP08uvT6sVon3LI92FfYQIiHfWj3waTggE0B2MzFmoc95kk7
         P+PdufSwcp69b7JSGVJJsjBdxMiD4V6we9D54khIJm2B4wAEl8HxkScUDygZJLi7tYrc
         +Ivg1i6eK9ECGXM7zYgXInGTQs2AtbbA4gNdRGd60bfuVXFVTn1zDWOqoZScmwdRXTS2
         /idRqhh/cHj3tTlZNQ1j8hnxaAM0Wes6ho7zISxL3ZyGP8pXgnUo1IamKOf5t7yPoWB+
         WrJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yx/Fke02HsLsqjZq568nqGFfeg9NCMSeHqBf+5WYna4=;
        b=Kg5IyEAe+b+s+PUShREKmq2d88brPYYQoukw7s43voXT2ed2CPtq2PX9iKQ7ZkD3mY
         EUcQQF16NHk7f0QsSiuPzkK1zAfZWgrl09AnSoaCoN+5SSCgQ/fW+EKOYpVNjlgMVuV2
         a1dketw1p6A+MyvDZqJ8JTCmssOUTHu2WBEagSxRKVgMskShavzUbbsIAaQGMmDaSswB
         H5FnaBk5oBfQgXLdqyty3zYzNp21JN83m5UgoCr5JbaSjTCQKQur/gQwbdJ6WaMAK5Vx
         sxLGcxeuB2rVePMxV/3H6mkLodVaxuJ5HO7h2To7EUPTDWhoScVvTFSjnJnbNAPsfY+a
         6nug==
X-Gm-Message-State: AOAM533zNgPCvvfs64W1uFsH4sacjrfNFvzCPBrMzmTX66LrYP39KF8E
        HJN2Hmf8eRndbw+34QDNJ9s=
X-Google-Smtp-Source: ABdhPJzgF5vQKW9CktsXhzHxqL5P0NdJS/EhTQeiHwrB2+59n/ANj/ImRscuKpFQ1IFs7X2xt2haZg==
X-Received: by 2002:a17:90a:67cb:: with SMTP id g11mr638142pjm.56.1599800647227;
        Thu, 10 Sep 2020 22:04:07 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:54b8:5e43:7f25:9207])
        by smtp.gmail.com with ESMTPSA id x140sm756153pfc.211.2020.09.10.22.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 22:04:06 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH net-next] net/packet: Fix a comment about hard_header_len and add a warning for it
Date:   Thu, 10 Sep 2020 22:03:59 -0700
Message-Id: <20200911050359.25042-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch tries to clarify the difference between hard_header_len and
needed_headroom by fixing an outdated comment and adding a WARN_ON_ONCE
warning for hard_header_len.

The difference between hard_header_len and needed_headroom as understood
by this patch is based on the following reasons:

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
 net/packet/af_packet.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index af6c93ed9fa0..93c89d3b2511 100644
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
 
@@ -2936,6 +2939,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	skb_reset_network_header(skb);
 
 	err = -EINVAL;
+	if (!dev->header_ops)
+		WARN_ON_ONCE(dev->hard_header_len != 0);
 	if (sock->type == SOCK_DGRAM) {
 		offset = dev_hard_header(skb, dev, ntohs(proto), addr, NULL, len);
 		if (unlikely(offset < 0))
-- 
2.25.1

