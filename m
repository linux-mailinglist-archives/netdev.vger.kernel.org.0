Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96995443E67
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 09:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhKCIb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 04:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhKCIb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 04:31:28 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C9EC061714;
        Wed,  3 Nov 2021 01:28:52 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k4so1962954plx.8;
        Wed, 03 Nov 2021 01:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i00n7ZrM5fqbcYZ0dL4GZEF2pe2591w/kRaRvHeY6D8=;
        b=o+zbYQ/+3smyDPnCLyw8MpsJuUzw276DpyNBilTO9MlCZjVgDnIfdrP4NFFolxLLhl
         kNGOcEpuPEVdtN2dy3uV+2UjimHNXXCVcxCx4aKcqytqFqpCz1JkPKnmYEsIoamNtA1+
         OOhBrD0LHm+8uxp+WxPVuzcGsoAiQnuat8wQXMle1SGTmCoE3REsH5gSXPEWxPPP8cxp
         QT50VkxFHup30eESzMQkZCLvUNjyBnETHe6yozl48Y9pkOBtUgZbZ3YwbU46z1EyuqFX
         g4LwXr/nlawT4OnQ2x5XAFtjf4psLh5jv3hLgvo/HFyegBu1MViaZv4w/tMSTIYSTaXB
         yb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i00n7ZrM5fqbcYZ0dL4GZEF2pe2591w/kRaRvHeY6D8=;
        b=pzGwsQ+nK6zZGAnE8C4oU3jIEoolYMg166cSTxkDjapCLyGhx8TX6ypifshtrAsmo7
         bii8TBka9vS8RLHdZzJV5NPzPXWuga+EXGviDDO5gZAIpKZHBFsydNNBsC6jMcRqmtOE
         DgspQ3um3xEHszIhK7p0ZS980bN0pZo6Tqrg9V53F7gYTu/Fz48d0y12Gbaue+ZL6hcJ
         xB5YoKdNhOKOmiglIzAchk9bW/7JnjX5IMrNk6ZKzRm0PIwgHYIyCAyfCIgkVzp2Gkzn
         gcB37Tc9FQQmFYvMSJC86i0TgYp3bCMQ+z9mqdQlI3K7//Whs5fHmOcuESNOYipgaZSv
         yJVg==
X-Gm-Message-State: AOAM531qZHUz/vfjDZWEl6p5oJ0husq1hUPuO+TuBfGVi0F1Gbl+f+oX
        ZSOONYSg1Wq0bNRzHfFrNdRFVGWcHWA=
X-Google-Smtp-Source: ABdhPJxO9RIWpTTaBTlTVVUZtvvGGaP/lw+7donogRs6IF6wxoaCXU4nnO67EBFBR1MKsn6XCbBCyg==
X-Received: by 2002:a17:90a:fe87:: with SMTP id co7mr12800459pjb.21.1635928132059;
        Wed, 03 Nov 2021 01:28:52 -0700 (PDT)
Received: from desktop.cluster.local ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id z16sm1520490pfr.69.2021.11.03.01.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 01:28:51 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     yoshfuji@linux-ipv6.org
Cc:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next] net: udp6: replace __UDP_INC_STATS() with __UDP6_INC_STATS()
Date:   Wed,  3 Nov 2021 16:28:43 +0800
Message-Id: <20211103082843.521796-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

__UDP_INC_STATS() is used in udpv6_queue_rcv_one_skb() when encap_rcv()
fails. __UDP6_INC_STATS() should be used here, so replace it with
__UDP6_INC_STATS().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv6/udp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8d785232b479..4fd8c87c607f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -700,9 +700,9 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 
 			ret = encap_rcv(sk, skb);
 			if (ret <= 0) {
-				__UDP_INC_STATS(sock_net(sk),
-						UDP_MIB_INDATAGRAMS,
-						is_udplite);
+				__UDP6_INC_STATS(sock_net(sk),
+						 UDP_MIB_INDATAGRAMS,
+						 is_udplite);
 				return -ret;
 			}
 		}
-- 
2.27.0

