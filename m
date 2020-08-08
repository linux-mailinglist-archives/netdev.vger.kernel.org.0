Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389D723F866
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 19:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgHHRxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 13:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgHHRxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 13:53:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D57C061756;
        Sat,  8 Aug 2020 10:53:30 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a79so2848864pfa.8;
        Sat, 08 Aug 2020 10:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0OxlVIsSWOu661PCHopxBsGPjLO2EKn1MEWmBcl2YxE=;
        b=HGmxCskZb14zf46Qx83DUIcy+ZyCnozH2SUkSKakWwtDY5XVn4+AReZcLfgmDfqbwt
         UNjNhtBTKNFtKvhZ1jlX8mxSxwMwyN00VKaJmPbgjJ5wIC7Hyq5E1faMrtGVXjCATUfo
         QslmjjazU2psIsfzuKxYsM9CbKRGA5CEgznYDOK57dS95sykvb+cRczeVhaiJDUS7wzr
         BUXWIhN4s0gLJYuU5KmGvJXL5o8K10bvPkl1IgK/j/Dy3hB8OXoWHvKDJ42gF8xowqNT
         4s/zkaNxSPSpEkKdQLVIzYph369FWKpegpDgwilaHsTZo8rSRWSWkbQgEWUAPFwsLhCo
         drSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0OxlVIsSWOu661PCHopxBsGPjLO2EKn1MEWmBcl2YxE=;
        b=mE9GjV3Gx3/KvzTEiJW/W2vfn67G5qLrJaCvRqQbuDGNeBPZ5n3ORrLTIJyyIfru1T
         B1nxUxC3f7NWSty7GQrlu3mzyJ4xcCo1VD2uZVxEdwa9f3VAiYotnC8HEoMFaINUETwC
         VMR1rS8ZJ3Hb9+FHiZndwf28+JIllySWPzhbN+wfokN9IpJ7K3YINsP0vwXH9sYw6r1F
         nA5zenIAI4+xMHBlU7RCgUTVr4pdaXBajSUCRoPvdCj7wbRZUFuKjGIyKD6b42Odn6Rt
         qWvRw35kfe+h+v3EaQG7SAgFhT1pkGpF30eBTHT7RGk4WlQVMoR6k5k10aYKGdXxYhDU
         hKKg==
X-Gm-Message-State: AOAM533MSqpr/jjvse5LWxw0JdFZc0DZINQAISUwQUpGKv5mgf7BEdsz
        5vzgB7R+Mvo/OP1j2xbSgUg=
X-Google-Smtp-Source: ABdhPJwhlh22iVKxVKAhKTLQDIEwn+0ITzThUX8fGPczPeC5C4yNTRXWi+e1a8IY1nyKz6G01L8gUg==
X-Received: by 2002:a63:cb06:: with SMTP id p6mr5997774pgg.43.1596909209163;
        Sat, 08 Aug 2020 10:53:29 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:8cf2:183:7fb5:ce6a])
        by smtp.gmail.com with ESMTPSA id j20sm14171826pjy.51.2020.08.08.10.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 10:53:28 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net] drivers/net/wan/lapbether: Added needed_tailroom
Date:   Sat,  8 Aug 2020 10:52:51 -0700
Message-Id: <20200808175251.582781-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The underlying Ethernet device may request necessary tailroom to be
allocated by setting needed_tailroom. This driver should also set
needed_tailroom to request the tailroom needed by the underlying
Ethernet device to be allocated.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/lapbether.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 1ea15f2123ed..cc297ea9c6ec 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -340,6 +340,7 @@ static int lapbeth_new_device(struct net_device *dev)
 	 */
 	ndev->needed_headroom = -1 + 3 + 2 + dev->hard_header_len
 					   + dev->needed_headroom;
+	ndev->needed_tailroom = dev->needed_tailroom;
 
 	lapbeth = netdev_priv(ndev);
 	lapbeth->axdev = ndev;
-- 
2.25.1

