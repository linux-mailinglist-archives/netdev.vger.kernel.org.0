Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7247330B39F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhBAXfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhBAXft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 18:35:49 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA2FC061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 15:35:09 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id m6so12915280pfk.1
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 15:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rqXxYXQ/zWZSYlP6IO3+Z7IUKTvxTdHGQXvUh88+tWw=;
        b=UT0I4/bxd7MoCOwIEwxKgekWkHmTu7KboUN8nZcho+FCKVUf9wItGat0C3pWp0y9/a
         yZw8+F2LJCB4+kTbNiNdn0OuSHsLSctc4+w8t/VK+sEGf7/uBIqt85XLvjcjBFWNVOuA
         s2bMMKAc0j94MiEggNGyLBBRNRBgZ7TQLazVhxPb+DpCBx0Mj+dvZISxILlXXDOPnVD7
         ogUF/XtxZ1T2351E6vQthsfBWYs0IF9ixUExqnxSARzk/fNmghWJ8KgVuyXl8vSAbx7V
         iweN5kret0dVoXSdgHw3oi5SK0/+Ru6Th+2rwA3k63B1M7yOP+ofRmoDUrus6GfbiCWJ
         gCoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rqXxYXQ/zWZSYlP6IO3+Z7IUKTvxTdHGQXvUh88+tWw=;
        b=j+OPWJ2N0qnzidgyBo4ptt0M0C6EIW3vsL414bNqKFT52Chi9zRQtkos48vFIe1ns7
         oHGIFCkeLyysktZNt9ci+bqw0v7GFptZSN+UdYIFkLnjtIiukFrLLFhKu3RrmYiUOr3u
         PZ2YUKX3DtgsVvNCLHFm6JYhl2dfYW9wqfep+fbJWCyl+8JCf6HFweY/VCkx878hzdBe
         /9O5BzLYOUleiSgq7G9ck8bm9ICXB8iJYSve03GJqjkY8VoOs7IMPZM50d3NbI/UiZWM
         EdWMCy/k5lzvr8UizGhVvErtCP4iB9c/s7BmRPO+qiAc2cz3WyBkm6SHte3VeXZFRXmo
         xPTg==
X-Gm-Message-State: AOAM531N8zoFJnU9jBbSqMlZVj47+hONpstOxzJuwmrgrc5ylZVrJ1gY
        OPUYWgGKZSlbdRZ8XP0IHmX4yMwgm1E=
X-Google-Smtp-Source: ABdhPJzOQ3WKXKASpxWBt31pDNT/oky/+G9+o10CwduKkIJ884wvBidWPpwe7RNzbZUmC3OAq8bpLA==
X-Received: by 2002:a63:4d1:: with SMTP id 200mr18521123pge.362.1612222508912;
        Mon, 01 Feb 2021 15:35:08 -0800 (PST)
Received: from jian-dev.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef8:759])
        by smtp.gmail.com with ESMTPSA id j18sm20520939pfc.99.2021.02.01.15.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 15:35:08 -0800 (PST)
From:   Jian Yang <jianyang.kernel@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: [PATCH net-next v3] net-loopback: set lo dev initial state to UP
Date:   Mon,  1 Feb 2021 15:34:45 -0800
Message-Id: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Yang <jianyang@google.com>

Traditionally loopback devices come up with initial state as DOWN for
any new network-namespace. This would mean that anyone needing this
device would have to bring this UP by issuing something like 'ip link
set lo up'. This can be avoided if the initial state is set as UP.

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Signed-off-by: Jian Yang <jianyang@google.com>
---
v3:
  * Addressed Jakub's comment to remove the sysctl knob

v2:
  * Updated sysctl name from `netdev_loopback_state` to `loopback_init_state`
  * Fixed the linking error when CONFIG_SYSCTL is not defined

 drivers/net/loopback.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index a1c77cc00416..24487ec17f8b 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -219,6 +219,12 @@ static __net_init int loopback_net_init(struct net *net)
 
 	BUG_ON(dev->ifindex != LOOPBACK_IFINDEX);
 	net->loopback_dev = dev;
+
+	/* bring loopback device UP */
+	rtnl_lock();
+	dev_open(dev, NULL);
+	rtnl_unlock();
+
 	return 0;
 
 out_free_netdev:
-- 
2.30.0.365.g02bc693789-goog

