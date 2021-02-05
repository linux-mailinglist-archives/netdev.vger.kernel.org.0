Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAD6311907
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhBFCxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbhBFCnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:43:23 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61103C0698CE;
        Fri,  5 Feb 2021 14:42:09 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 18so3138186pfz.3;
        Fri, 05 Feb 2021 14:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwjcqJWWNcSXw2VIILl7w2i/g+DKyP5+Y7qQ/2dsy3Y=;
        b=C5k/72VaWxTYXyZABzbANvSq7XAPEorMLLNUKVWpBjewJ0/nNvm+LWaLOiohGp0ovm
         ydq/loPXlxbvHTL1shzzb08YlKvgpXHwTWOwbNvY9ea9Lz5aWjWVGhPe5YDV/Rds/lju
         cI2J85gWqlV8tlSZ73j/V3ulnwzlup5MdQG/QCYwzhdNdJDBwLOigLPH/tXOtcg0zbwR
         /ZXynTDDFBhICZr8++j9brg05NXzWmiegj9La0PuQ83gwZPzK8O8vsjAsp1+/XFgHuDa
         eEzttF2NnvzLPXLesD0FhxHGBRsh9LbT95mgvJFPWZZlkOvauqvq7kefG/HC5J0bNpUt
         oM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwjcqJWWNcSXw2VIILl7w2i/g+DKyP5+Y7qQ/2dsy3Y=;
        b=phzt6x4qM4BMQ5gzigrhkLs2x1kKnFrls/ln86453N7KGYndUQRoNwj7upoP8BGW2Q
         LwbU+Mtx3q8TXM3t3wWjBlWJwFr1Ebqv2bTqeSz1PrJxUUMAdcXf9iZb1T/qufhA9V+8
         wNwWVmEcPc59oz7uSShRr7WgzpvYOdNFho/vRir75ukPwkBk7IVnHiTsB+f6G97WDlnE
         jaY9sR9SZvTp1ZXS3uz5WE1fV56GZvxWDR623MaSNpdbeRLiV2PpUVE68mwSd8CIasZD
         G1IFhCIApY8DKlBMU4h6nttU4BgSi5+h9L2lCu1LI5SJi8115jJ0FMhd2gbiJFBXA9ZK
         1BtA==
X-Gm-Message-State: AOAM5338iNal9yj2gla3uMAjbG9l0azJfKXyWlDgJg23YkMrFKE+tozD
        DUoax7SRyJ7Gf16x154IqnASR7RS9E8=
X-Google-Smtp-Source: ABdhPJzly2jwOwnOUpYovP03NCN3AX5wGKFqAThbKdf3wsuPPvFzgc7Oi07uZKaTLsd7w7cpDenJRg==
X-Received: by 2002:a63:c54c:: with SMTP id g12mr6230188pgd.449.1612564929004;
        Fri, 05 Feb 2021 14:42:09 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:b867:f7ba:cb49:e834])
        by smtp.gmail.com with ESMTPSA id j9sm9194982pjn.32.2021.02.05.14.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:42:08 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Tanner Love <tannerlove@google.com>,
        Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] net/packet: Improve the comment about LL header visibility criteria
Date:   Fri,  5 Feb 2021 14:41:24 -0800
Message-Id: <20210205224124.21345-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "dev_has_header" function, recently added in
commit d549699048b4 ("net/packet: fix packet receive on L3 devices
without visible hard header"),
is more accurate as criteria for determining whether a device exposes
the LL header to upper layers, because in addition to dev->header_ops,
it also checks for dev->header_ops->create.

When transmitting an skb on a device, dev_hard_header can be called to
generate an LL header. dev_hard_header will only generate a header if
dev->header_ops->create is present.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/packet/af_packet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 6bbc7a448593..e24b2841c643 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -132,17 +132,17 @@ Resume
     because it is invisible to us.
 
 
 On transmit:
 ------------
 
-dev->header_ops != NULL
+dev_has_header(dev) == true
    mac_header -> ll header
    data       -> ll header
 
-dev->header_ops == NULL (ll header is invisible to us)
+dev_has_header(dev) == false (ll header is invisible to us)
    mac_header -> data
    data       -> data
 
    We should set network_header on output to the correct position,
    packet classifier depends on it.
  */
-- 
2.27.0

