Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9896E22DE1F
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 13:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgGZLFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 07:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgGZLFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 07:05:32 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80365C0619D2;
        Sun, 26 Jul 2020 04:05:31 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id s26so7594296pfm.4;
        Sun, 26 Jul 2020 04:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HiCRrQCxdIa5HIW679AjRc9wXiJ6/iMtc+VYMoge+3c=;
        b=WYkENyzYNLhggQIvWLddjbWxCjYrMSbzqNPQL1fj6YeDJ/9qPZxc5cQQwyNHLyZIM/
         FGCZ9jLTyq9WFfYDRg0E8vaLl0le0BdIJ14LYb2+DbnaHJV1UoWAXTcURJqo7n8C837A
         UlP3Rcv2MkXCbkjYNkwvi0vKnYAorDTChREz40/kYkvpaF8rvEEABaWVdEhpYCzMCFCy
         Qml69TMC14lB3pyB9RatZMP5mMEyL+JY+t9GodCEblfEf8rNTk4bFCFJv0LFLnUHQuAO
         pxjVfCsKTX2lM8rooNJj53HGkb1EaDKuaM5ardkNToiC64I5vBjEzx8nWDftzGytEXfC
         vPbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HiCRrQCxdIa5HIW679AjRc9wXiJ6/iMtc+VYMoge+3c=;
        b=Q0UmFUwI8mE5Y+bk1A75MsUeKSBNRAD6sgS/Mu+bsrRAeexunt95hJw9HuHm1YEEHC
         cQmZ/r/7DS3aLMH/W4XkS4KHJH3rNbv6pho/k+Sb7O1XgLh1TZ/+eAW2MH0TC541dqFD
         uCD1/ksLmUpPp2jnPTmGrY3D9D5navrFo3J7Nx6vd1/jNNRJBmf/iEUo6dbnlvbrgszv
         bDW3xO4kykpsB0ZF0l3ozylsUHy5pYsQdxzIVnzCIcHQ41mF7jsEGjRq/rBGPWitEEKj
         O686lGAn2XdZv5iWQ+jOrkbO+GQhTuiUXpiVNtVLlTmYk1waA5ckLHDRqycGUT+y9wwo
         nG5g==
X-Gm-Message-State: AOAM530J9qJtKfXeMQg23CPuctyGJ9aEYVYviU310i6GwZYCrvn6beIl
        koXX9w8P0F+Xl7sXR0lb75k=
X-Google-Smtp-Source: ABdhPJyiB5VtWifib5GOY++GVorvqouyq8vwC0EJyVkpB+Ix4FfPXx8aOuJ9pPX9LeT7k3oVTaNAHA==
X-Received: by 2002:a62:7712:: with SMTP id s18mr3235662pfc.65.1595761531090;
        Sun, 26 Jul 2020 04:05:31 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:2977:21:5b62:ff11])
        by smtp.gmail.com with ESMTPSA id q20sm12022374pfn.111.2020.07.26.04.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 04:05:30 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH] drivers/net/wan/lapbether: Use needed_headroom instead of hard_header_len
Date:   Sun, 26 Jul 2020 04:05:24 -0700
Message-Id: <20200726110524.151957-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In net/packet/af_packet.c, the function packet_snd first reserves a
headroom of length (dev->hard_header_len + dev->needed_headroom).
Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
which calls dev->header_ops->create, to create the link layer header.
If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
length (dev->hard_header_len), and assumes the user to provide the
appropriate link layer header.

So according to the logic of af_packet.c, dev->hard_header_len should
be the length of the header that would be created by
dev->header_ops->create.

However, this driver doesn't provide dev->header_ops, so logically
dev->hard_header_len should be 0.

So we should use dev->needed_headroom instead of dev->hard_header_len
to request necessary headroom to be allocated.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/lapbether.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index b2868433718f..34cf6db89912 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -305,6 +305,7 @@ static void lapbeth_setup(struct net_device *dev)
 	dev->netdev_ops	     = &lapbeth_netdev_ops;
 	dev->needs_free_netdev = true;
 	dev->type            = ARPHRD_X25;
+	dev->hard_header_len = 0;
 	dev->mtu             = 1000;
 	dev->addr_len        = 0;
 }
@@ -331,7 +332,8 @@ static int lapbeth_new_device(struct net_device *dev)
 	 * then this driver prepends a length field of 2 bytes,
 	 * then the underlying Ethernet device prepends its own header.
 	 */
-	ndev->hard_header_len = -1 + 3 + 2 + dev->hard_header_len;
+	ndev->needed_headroom = -1 + 3 + 2 + dev->hard_header_len
+					   + dev->needed_headroom;
 
 	lapbeth = netdev_priv(ndev);
 	lapbeth->axdev = ndev;
-- 
2.25.1

