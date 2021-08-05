Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A0F3E1C26
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242232AbhHETIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbhHETIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:08:50 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617B6C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 12:08:34 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k4so4018140wms.3
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 12:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=JRVOBU22/4EewlO/b8oAz5a46oCU2XYL39mDzxU1rUU=;
        b=K/jc0SsBo6DflWqJZiKG/zDRN12la/AD1x8utmhM8Str2VhO0o1PWzAfbZGH5BhPCU
         kikFk7YboT0dLCLfgBIyVC7o0fBcxV4WM3Ch09VrbTwPJqxnhJOXDs10VLb1D4nV4WTG
         E/JLbxv9qrCoAzPnzLHESimcmfj933QJPzjnT9WT0brL0iPfj+nuXPBIxUlW6gF+Df/a
         RHK7+gTpws1rsek+xCTJboJw0Brp+z6CivLo/+OiucqZTDlBRu91pzLV+BU6KPCWtDS5
         MsjdTXgbmsUriX6WWlPOBvYUOsD5d3md/Jvj9Sw4zqjxOiQPd8aRQrtV9XqvgQGUVBw1
         XJNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=JRVOBU22/4EewlO/b8oAz5a46oCU2XYL39mDzxU1rUU=;
        b=hYebznad7BIkw7E72nRDAXsva1qniYSte4Y6LrwIwXda6NF1QbT/FvEHkZIq8FCB7w
         VMvZofl6Gii4Zs1a7hOl9Md31fXqWKm7VSIdxPmg3VjBO83FmF0WI6vwdzI6AgArF2rq
         5lTKASzm9lt99xoCUADvSkDTNpxwUq2ddpA3e1H1phLAQwyqm26KYijrDvrQFRp/GDkx
         DE2zozB3/1z+yju4zhvri0Eo6agZo/j6BslzKVHGvXkkrNEjf4W/IvtbuVZPC33LqnM2
         k+PzZYR8WHtIhrg/dKlXco20hSG9+AxcRlHSr8vzwirTBSd99l0CVCJth/wZOgUHVd0A
         aQVQ==
X-Gm-Message-State: AOAM531R/Xhqt4gCXUknZ/JppINOQ+ImzQiPrdk99NEucU49uQZHg8Gz
        kP+hO+RLick0AOrhTOLCmAs=
X-Google-Smtp-Source: ABdhPJx/cMdCjO4IdQjsCqGwSeS2hkg7vmWSBVYLfhUY0ixMCnTCoFTSJVC96X9/nD2ik9RNFzUbnA==
X-Received: by 2002:a7b:c353:: with SMTP id l19mr16328497wmj.127.1628190513073;
        Thu, 05 Aug 2021 12:08:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:75d1:7bfc:8928:d5ba? (p200300ea8f10c20075d17bfc8928d5ba.dip0.t-ipconnect.de. [2003:ea:8f10:c200:75d1:7bfc:8928:d5ba])
        by smtp.googlemail.com with ESMTPSA id z6sm6225818wmp.1.2021.08.05.12.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 12:08:32 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] ethtool: return error from ethnl_ops_begin if dev is
 NULL
Message-ID: <21a1abb0-300f-ccae-56da-16f016c4fff2@gmail.com>
Date:   Thu, 5 Aug 2021 21:08:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Julian reported that after d43c65b05b84 Coverity complains about a
missing check whether dev is NULL in ethnl_ops_complete().
There doesn't seem to be any valid case where dev could be NULL when
calling ethnl_ops_begin(), therefore return an error if dev is NULL.

Fixes: d43c65b05b84 ("ethtool: runtime-resume netdev parent in ethnl_ops_begin")
Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/ethtool/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 417aaf9ca..fe8bf2b3c 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -35,7 +35,7 @@ int ethnl_ops_begin(struct net_device *dev)
 	int ret;
 
 	if (!dev)
-		return 0;
+		return -ENODEV;
 
 	if (dev->dev.parent)
 		pm_runtime_get_sync(dev->dev.parent);
@@ -61,7 +61,7 @@ int ethnl_ops_begin(struct net_device *dev)
 
 void ethnl_ops_complete(struct net_device *dev)
 {
-	if (dev && dev->ethtool_ops->complete)
+	if (dev->ethtool_ops->complete)
 		dev->ethtool_ops->complete(dev);
 
 	if (dev->dev.parent)
-- 
2.32.0

