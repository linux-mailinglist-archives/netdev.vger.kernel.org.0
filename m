Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8944819E6
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 07:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbhL3G06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 01:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbhL3G05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 01:26:57 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B330C061574;
        Wed, 29 Dec 2021 22:26:57 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id m25so20868705qtq.13;
        Wed, 29 Dec 2021 22:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LXwPadLSFVyvCah/M8sg90LtD8LX6hnEtvNkUP/6f18=;
        b=Xhr8y7bcZ3G1W9mpXC5Nn2rORqV0B8y1bdDmn7MhkodJWwYZ0UwYmPLxQVDsKUsB64
         xVpME2bsmaC7IIfj5j2Z9d/NqV5mxwq+FRCUyQ0OtsFEhvBsZ0FCx5V2bVQK9UvdrWIK
         LPxeZRWTi0c25XvjuZb+huwW0f/77/JQ4eTlmKuN6ONO8g8Ae2RlZBf3T6tsUh3rnhjz
         A1EG5icdUd8dhxmtbxRidQPmCf9Xm7NmAgGX4/0ehGJBnxVKA6DB5R41CAyOrVcGUAUw
         MkmVGuNcY1VI8niZI6W1gQUxKRCLAFsArP5nqpYMg3KpnF0ARYX+AMO1dpyGeKu/9Ojr
         C1jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LXwPadLSFVyvCah/M8sg90LtD8LX6hnEtvNkUP/6f18=;
        b=Z1L++1jNIvg0ZFVY0iNHUKSE9lYZrw7qSvKmFIXDCSsSA8NWemLFXbYXTHrsVmNNDr
         8ObiWpn49c4/MWJ97zLFtmZSNWjbk8JnHZSTFq0WiqXNef6tdz0jVy+qrd+H455o8gwp
         Ng/AIxsYYAhexisE8wmAVV2rftX1oWh9e98X0M8ZidonblMWuRA5UOCdHInt1HpyTY99
         ZdlKt+jNbYDpmxK8TLBwBC67ur+8U2xH96N3Un53WvVTga9pEvvujwHXD2WfybeH5Uib
         AWCgMSfpjWeJ9lVBDLc1Tom2Kxqx6ya1LJKwEgusrvHWe6lQPobX9XgDJpdRpazCMxS0
         lKPQ==
X-Gm-Message-State: AOAM531BZ8K5rSx9MKYxhWrzwtehfFjBmjpbnpYOHfSjCg/KWU+CSPJZ
        Iy321yHJ9UURruXHY0LDQmk=
X-Google-Smtp-Source: ABdhPJwFzmRXw+dujE4X9DnqppToPXo1Jmev6tVW7nhhOXF4cMdpZLH9j+BzqfOi17VWiVdB0vp1qA==
X-Received: by 2002:a05:622a:d1:: with SMTP id p17mr25284218qtw.207.1640845616499;
        Wed, 29 Dec 2021 22:26:56 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id r23sm10230969qkk.24.2021.12.29.22.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 22:26:56 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux] ethtool: Remove redundant ret assignments
Date:   Thu, 30 Dec 2021 06:26:44 +0000
Message-Id: <20211230062644.586079-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

The assignment here will be overwritten, so it should be deleted

The clang_analyzer complains as follows:

net/ethtool/netlink.c:

Value stored to 'ret' is never read

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 net/ethtool/netlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index b3729bd..5e23462 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -633,7 +633,6 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 	if (ret < 0)
 		goto err_cleanup;
 	reply_len = ret + ethnl_reply_header_size();
-	ret = -ENOMEM;
 	skb = genlmsg_new(reply_len, GFP_KERNEL);
 	if (!skb)
 		goto err_cleanup;
-- 
2.15.2


