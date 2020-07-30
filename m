Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353C3232CA6
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 09:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgG3HhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 03:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbgG3HhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 03:37:09 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A66C061794;
        Thu, 30 Jul 2020 00:37:09 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t10so7969181plz.10;
        Thu, 30 Jul 2020 00:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K+Oo0bHEpODF7XLQBQ6GDyIq38DUDAb0nnpXubPm0uI=;
        b=gcQTdkUwMvU1FPhnUFLPP+UPLAy2jxmTogTN2emcrLTfrpzcy5xxre8T4B4/PeTPEJ
         /Mz40YKCWv+F52Z6VI00Fcf+4FmiJBl4341OILo+enlqoGli0586/XSBRTjL6//WiKwP
         vKPo3NFq1H1Or6BHlxSLKDq/odvYSy39q+pTv6ZY/3p1D/RnFpPm0exZGMgVTUO3AWmm
         IpYo5g1xmDgnp4nPd+y0n7W/3HY7rCx8MW5Ac65Xl3gUOsq/mD2nLfPhJfxahNzeBgFS
         lZ5uTeDWusdNq07HOOiqipYsL1aL/A6NsaThNpZkivIqJfZp/sCT7q1zWe0NQ6CTry2K
         8kjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K+Oo0bHEpODF7XLQBQ6GDyIq38DUDAb0nnpXubPm0uI=;
        b=TV2NuetAAFOQ/MSaPdKa3NHFH4VHTllkPy2kePIsW1AfO13xcVpi/6IF5ZFdm7fhLH
         fq0G65nejx4NZ6dIrHFUqWFO0LfXt6G54XdHiL3O7lM/sbvAz80/2YFBu4ds4e7PkNIS
         QNLgmjYQUOUBr5/6+vBbKcYkJUYDr5JRxsflkXu1gCNcPj3m4CFXJ8I/v64o1+fkMXkE
         Aei/SGB4S8NrhakirtAq55UV7u/qEdRDVrHtS2X6URL3opt5UVZrufeBh49aUqY++B1m
         HPit+LsdyoN+fo+ysQhB7VQyCIKq3jfyPWWcDuX6Ux+Ac3kg2udBJpJCIuFXTaDOF+Ek
         JMnA==
X-Gm-Message-State: AOAM533RJ3pXo+TasrC1qYzEDOQjInFAyfaac7NDEXOwWDVXU+L5PTfl
        NvKiNUfKSDNJXWZsqKhN4MYiRSVY
X-Google-Smtp-Source: ABdhPJxPHZwDLjW/Q8zuk2uuWdoo43CpqfYLo+tFfec3HcKfuVt0EK9EZSKqNEI/8lIatQ3t+2rpZw==
X-Received: by 2002:a17:902:c405:: with SMTP id k5mr30209769plk.202.1596094629206;
        Thu, 30 Jul 2020 00:37:09 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:e460:1d84:b10c:de38])
        by smtp.gmail.com with ESMTPSA id o19sm287113pjs.8.2020.07.30.00.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 00:37:08 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH v2] drivers/net/wan/lapbether: Use needed_headroom instead of hard_header_len
Date:   Thu, 30 Jul 2020 00:37:02 -0700
Message-Id: <20200730073702.16887-1-xie.he.0141@gmail.com>
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

Patch v2 has no difference from v1.
I re-submitted it because I want to find new reviewers,
and I want to free new reviewers from the burden of reading the
lengthy discussion and explanations in the v1 email threads.

Summary of v1 discussion:
Cong Wang referred me to Brian Norris, who did a similar change before.
Brian Norris agreed with me on "hard_header_len vs needed_headroom",
but was unfamiliar with X.25 drivers.

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

