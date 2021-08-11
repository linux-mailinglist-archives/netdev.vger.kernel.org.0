Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0C43E9B73
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 02:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhHLAAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 20:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbhHLAAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 20:00:33 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65316C061765;
        Wed, 11 Aug 2021 17:00:09 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id nt11so6342790pjb.2;
        Wed, 11 Aug 2021 17:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KgEdvsrca1SF5BWDushaiKJ06kC9hIpnUAyfu0HpOFc=;
        b=B7VkmiO3h2XR7G2FVqaGzhMv0Ps38Udsf8F2g8R1NG7Pvhf+P+bINWGWULZtfpx1Dy
         plQ9otZwDXIeW/ZVQyZtbRsgUhJE5XIAYMoPmJuDrse9IBrcnqTKA9JGwHlwWTIUvgUH
         y4w4KZV9GZA40CBWma/k3Z0B0H3M5DQe16EluXTuK5G8bOH5JsZJcP+W2AwpAHewaHIt
         OwLPNGc8oBpich8fe+E/Ibjd2Ze4bX5RNBZ8HZG4BRmiqUGxJ/crF5kcZkGxiB96pMX1
         8JwVGxRHMGaNHACwT7exfKZ3is2m1gc/ltB2ksflk1LqbB5iJhz5m2eYDwwHn2YGz20C
         AZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KgEdvsrca1SF5BWDushaiKJ06kC9hIpnUAyfu0HpOFc=;
        b=hZQHRnfO5B39AfkTuH+rCy02fE2VUroq452v9D2z5D8IJDWxgFgMovNINlE4fZv+xd
         39dcYpEJwpnZcSrVci6ovuJhXp07pr2Pj1y0LWbB1FMsSIEvCO35O85wFEP1OLVN5VJ+
         DQN1NvSpFQjWS87VtA5CMpH0eS2lLqJgRSWP1/IlfrDXcbzc7Epg4SSxYcidNWUmh501
         8VGDJ1C+Io8tXwNW7zYEBneGyBeTPvhWo7neia0pkl+fWTH8jz/xh9n9kWO7MjrklkwF
         V4wARHjWzc3Vwr2bl6k1T4+2rr9rLAtZ0ON9+09UL2w/ehMRex1RgoZNJamOLFT/hGVO
         voXw==
X-Gm-Message-State: AOAM532+rqLh9iGG3LnQ7msyJ3326QTftt2zHE09uZGi84Uwmk4sVyWX
        tOnNhUCF0LcHnP8xX7sDZL8td3Rr8CBBrAyF
X-Google-Smtp-Source: ABdhPJxK4Nh5mOO6hzUscxWSTVLCtL+5kfxQU0/wJbk06HcMAQ5tA/jGj108pcu3I4KEs98kq18G8Q==
X-Received: by 2002:a17:90b:3802:: with SMTP id mq2mr1215768pjb.19.1628726408807;
        Wed, 11 Aug 2021 17:00:08 -0700 (PDT)
Received: from localhost.localdomain (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id g14sm762359pfr.31.2021.08.11.17.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 17:00:08 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, edumazet@google.com, atenart@kernel.org,
        alobakin@pm.me, weiwan@google.com, ap420073@gmail.com,
        bjorn@kernel.org, memxor@gmail.com
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+989efe781c74de1ddb54@syzkaller.appspotmail.com
Subject: [PATCH] net: drop skbs in napi->rx_list when removing the napi context.
Date:   Thu, 12 Aug 2021 07:59:59 +0800
Message-Id: <20210811235959.1099333-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The napi->rx_list is used to hold the GRO_NORMAL skbs before passing
them to the stack, these skbs only passed to stack at the flush time or
when the list's weight matches the predefined condition. In case the
rx_list contains pending skbs when we remove the napi context, we need
to clean out this list, otherwise, a memory leak will happen.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+989efe781c74de1ddb54@syzkaller.appspotmail.com
---
 net/core/dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index b51e41d0a7fe..319fffc62ce6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7038,6 +7038,13 @@ void __netif_napi_del(struct napi_struct *napi)
 	list_del_rcu(&napi->dev_list);
 	napi_free_frags(napi);

+	if (napi->rx_count) {
+		struct sk_buff *skb, *n;
+
+		list_for_each_entry_safe(skb, n, &napi->rx_list, list)
+			kfree_skb(skb);
+	}
+
 	flush_gro_hash(napi);
 	napi->gro_bitmask = 0;

--
2.25.1

