Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2502F709E
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbhAOCd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732041AbhAOCd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:33:27 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731C5C0613C1;
        Thu, 14 Jan 2021 18:32:47 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id q7so5073802pgm.5;
        Thu, 14 Jan 2021 18:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Js7XzYqItBY+i0QhBsDA1F48BtZPIA6D0H3nxDg2jZQ=;
        b=iTWaP9JCYE8VuqxHMB/fdhtdNQan3plzui0/bBJtEnF3NsZJ0fU3HKQftknaZ73+V0
         DPyKVkAaYheuK8rHBALfOPFD6PMLRhdcAa+jC0XKipxtwDDT/tw2p+rlStYh6eZPoe/o
         zviNrteGG+EqM3vNDaZ1TzFCIB//nEq8siH7OXzLClrNfYg1Yas8JXBVCTi9koHV0Ylf
         BLLuhzaBz7BT37l3qR2Z6pMC9CGYUvzAJLdKTcG9jTrlzCbMTvWGXlCgrxdJSpDFpE3+
         D1nELygi+K5bDDugp1AwFgrQ1ZYy5gUnorftW7YwxANkt0jFYEtQVXqU5mISy5A4dER2
         9IqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Js7XzYqItBY+i0QhBsDA1F48BtZPIA6D0H3nxDg2jZQ=;
        b=BhiPeBvmN0lao0Oou9gOGWO+3QSdAZqLn9XEaLUruxVaFQMpITYbshxxYT4cKbFqEg
         1z+mKeHh8wgUHlkhwij2wGrxj92m4FzivOx511dLgdHhk3MYf5mS8hyc5Vo1JY9Lhrl3
         w4JylxzT7uDl2BZRKesvnSDbL8PfLNkXGj+uaEggVUErHjhjvnRe4su9oYmDnFgohEgA
         vieaC6fc3Zc/4qbdsJahdWZyveNTEkHevD3wPGHDKl6/7tkpPj12JuE9Y8s9bBoRyMVg
         Uai5aag/iOMmTtqZcVd/WWcQwN410Gv8RpKvFU6J1J9HM9pP1bvjEga3srgrWYYulHHt
         woUQ==
X-Gm-Message-State: AOAM5333ZdeA6G2+c8umLIw0KwRr4X4MZSWNSIdpelqOvsbAeeg3MlrA
        DHfCsz7pHtM++xuweaPNig4=
X-Google-Smtp-Source: ABdhPJwwtVMLJO6n2mOk8r73Bz2daX1Tru4uphSiBpryvFGidhNp3dYVV4+mExLgS9udWsqF6gYd0A==
X-Received: by 2002:a65:51c8:: with SMTP id i8mr10374458pgq.81.1610677966920;
        Thu, 14 Jan 2021 18:32:46 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id c3sm6720113pfi.135.2021.01.14.18.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 18:32:46 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v2 net-next] net: tap: check vlan with eth_type_vlan() method
Date:   Thu, 14 Jan 2021 18:32:38 -0800
Message-Id: <20210115023238.4681-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Replace some checks for ETH_P_8021Q and ETH_P_8021AD in
drivers/net/tap.c with eth_type_vlan.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
v2:
- use eth_type_vlan() in tap_get_user_xdp() too.
---
 drivers/net/tap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 3c652c8ac5ba..ff4aa35979a1 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -713,8 +713,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	skb_probe_transport_header(skb);
 
 	/* Move network header to the right position for VLAN tagged packets */
-	if ((skb->protocol == htons(ETH_P_8021Q) ||
-	     skb->protocol == htons(ETH_P_8021AD)) &&
+	if (eth_type_vlan(skb->protocol) &&
 	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
 
@@ -1164,8 +1163,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	}
 
 	/* Move network header to the right position for VLAN tagged packets */
-	if ((skb->protocol == htons(ETH_P_8021Q) ||
-	     skb->protocol == htons(ETH_P_8021AD)) &&
+	if (eth_type_vlan(skb->protocol) &&
 	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
 
-- 
2.25.1

