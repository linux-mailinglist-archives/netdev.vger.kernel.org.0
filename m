Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCFE214431
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 07:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgGDFM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 01:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgGDFM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 01:12:56 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D78C061794;
        Fri,  3 Jul 2020 22:12:56 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m22so5587973pgv.9;
        Fri, 03 Jul 2020 22:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ma2Ml363EHulT5h5Rsiz3nA4SNmBIS3npTE4f6WSazQ=;
        b=IlJwAbWSaj97IjOeI49oGlMOb3AJFimGQy7xG8Gnoy6Txh4qaAalBv7G3jOcH42HAg
         4OMJVs0orHOy/aIic4ndhGHozWP8uYj7AqKsKLgLWziwABDqyz0cha7HzHrqbCRhMYwy
         QRXMBTzzH4OEfTfgs1fW37w3++563Cq5dM8MRzXC9NmuzkVid4oa5nw5ZVIHmSP2QVRp
         orCY4l8wX6seQhCoaiNqairmmlplus89MZwZfj00g9WNVM2+k//Tj8t3EiyavGfFSXbR
         ouMhrN9BxChldZ+uH/VEy1trk8XuY3eYWtZtuf/dxtCg5nOdzjSZqNXF34BQ+A1Djqn7
         9Q5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ma2Ml363EHulT5h5Rsiz3nA4SNmBIS3npTE4f6WSazQ=;
        b=nyCkdE48WwJ3zHGwWM1U5hLfawjdDVUka+A3utPZGXzjm79uMHAFb6dUSzme+ECbfB
         Bnels+hgy3BNwi8ytkwPw2w5giNrvgCGS2BolZo5E1mVMftqT59zIaRQPsovhfCelg6H
         WMedVz+HO76qJmI+kDSGsu5rAK+/uv+0lNQv+IBmKGTs8mixuM4Dub6KMj5kX8ky3O/E
         ypXVtyi8smoyitl+DSXoaZVQOmfbc8DPzEspw06H0IvLnwN+z/4y6veeo3EnmVNxc1mn
         QBUShf1gZUE/IjaYekiz88Huwrfb07l1T/Moi1XKFdH6yT8CwN/4gTYLm772GQoyHSQO
         JQTQ==
X-Gm-Message-State: AOAM530Ji4ZP+qDrBGrflQAlkSGTzpywLkP32qWg8XwLjiW92q5cDky0
        pJURD1FBDZOMA/J9Z7onmn0=
X-Google-Smtp-Source: ABdhPJwD74/Qzeygpbm4qhFb0DeKTsOlq5OKSgY2QOWxmDbmBR762/4Jumv77jek964gkytmHCmLfQ==
X-Received: by 2002:a62:fb06:: with SMTP id x6mr36104598pfm.28.1593839576015;
        Fri, 03 Jul 2020 22:12:56 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:2ca3:c0f1:5ceb:7394])
        by smtp.gmail.com with ESMTPSA id e28sm13037953pfm.177.2020.07.03.22.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 22:12:55 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        Xie He <xie.he.0141@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Subject: [PATCH] drivers/net/wan/lapbether: Fixed the value of hard_header_len
Date:   Fri,  3 Jul 2020 22:12:46 -0700
Message-Id: <20200704051246.203413-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When transmitting data from upper layers or from AF_PACKET sockets,
  this driver will first remove a pseudo header of 1 byte,
  then the lapb module will prepend the LAPB header of 2 or 3 bytes,
  then this driver will prepend a length field of 2 bytes,
  then the underlying Ethernet device will prepend its own header.

So, the header length required should be:
  -1 + 3 + 2 + "the header length needed by the underlying device".

This patch fixes kernel panic when this driver is used with AF_PACKET
SOCK_DGRAM sockets.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/lapbether.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index e30d91a38cfb..3b5ed0928a4c 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -303,7 +303,6 @@ static void lapbeth_setup(struct net_device *dev)
 	dev->netdev_ops	     = &lapbeth_netdev_ops;
 	dev->needs_free_netdev = true;
 	dev->type            = ARPHRD_X25;
-	dev->hard_header_len = 3;
 	dev->mtu             = 1000;
 	dev->addr_len        = 0;
 }
@@ -324,6 +323,8 @@ static int lapbeth_new_device(struct net_device *dev)
 	if (!ndev)
 		goto out;
 
+	ndev->hard_header_len = -1 + 3 + 2 + dev->hard_header_len;
+
 	lapbeth = netdev_priv(ndev);
 	lapbeth->axdev = ndev;
 
-- 
2.25.1

