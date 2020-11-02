Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDEA2A2F6A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgKBQOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgKBQOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:14:51 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139AAC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 08:14:51 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id a9so15250876wrg.12
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 08:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hB6EGdyTci9pTnlI28fHi/qT+wIqJGOIju9qHZww+/I=;
        b=RB7539KIov3X4sPGxeinze34CFDxLVVloPOhshl835Nt9om7AYre4qOcECOZFH1IAH
         vMTcwLGWhP+ODkYCFuUEh+A1dm/nxx6o2z+ioGLNyxHoRoihb3CUO4c01AOrFn3SU+a6
         1OEH2XgiVf3aqlJr4V1ERjpUQAnJfjmJLK03K196UfstSkBmLT35bI90+HQTUN+obqod
         ZnEjtExqSaymW3woFyMRe9NRai+BvqECXpVOpfnDdrCXRSwGKppZAbAJHYLSvdqZwTNN
         Hq38OzcJvrK1X3RIgwqicJ4DxJJCjB+vPHY2w05zGOldP/1C3rJA3IyAheb99trE8ZVy
         Kf5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hB6EGdyTci9pTnlI28fHi/qT+wIqJGOIju9qHZww+/I=;
        b=BwE/UEgc1xpS1wapycku/c5odiRu5YAbQQobGyMqZV4dMhysy0Rki4cQ3c5K9WWdk+
         KKta9mJTkL8if6JpqXIR3cj9suuz8ZQpi9BIZlg1QKAV3b9Rh+fq2bw+v8fgtGVDwGOd
         VYJK6cfu6PJYzt2S1cN5geRKOfe/2kzeBaFzhwvMxIbq7IATlRrnyw5YYL8FTT9S7Vpv
         oNqIak1xIQgyLD/j/uITVBrM5hdmglVhxEiAy8wBhsgdR8fbiFQN9WTBMgdTZiNFY/OY
         Kjk5jYmkMky6+vVI5h2o4dnpVe3bJjGf19NPuOnY6M/OCDJyzd0LzCDccj1WdQylUYLQ
         BjWA==
X-Gm-Message-State: AOAM533ACbdUSF0SzxjrJvuQGXXubxEBrWwWKMXXr7sczjG1OGYzGf1Z
        aSe1n1ldnxXG5QFsP/vC5hfnPA==
X-Google-Smtp-Source: ABdhPJye96ckcveJ7UXsyhlHq5Ov9mDS9m1nxDsZUbMKzKvXPnUoQNtyCq6tJGVlMvslfytTHgq59w==
X-Received: by 2002:adf:80c8:: with SMTP id 66mr21691206wrl.415.1604333689610;
        Mon, 02 Nov 2020 08:14:49 -0800 (PST)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id x18sm24127878wrg.4.2020.11.02.08.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:14:48 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org
Subject: [PATCH v2 0/3] xfrm/compat: syzbot-found fixes
Date:   Mon,  2 Nov 2020 16:14:44 +0000
Message-Id: <20201102161447.1266001-1-dima@arista.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2: Added "Fixes" tags to the patches.

WARN_ON() for XFRMA_UNSPEC translation which likely no-one except
syzkaller uses; properly zerofy tail-padding for 64-bit attribute;
don't use __GFP_ZERO as the memory is initialized during translation.

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Hillf Danton <hdanton@sina.com>
Cc: netdev@vger.kernel.org

Thanks,
         Dmitry

Dmitry Safonov (3):
  xfrm/compat: Translate by copying XFRMA_UNSPEC attribute
  xfrm/compat: memset(0) 64-bit padding at right place
  xfrm/compat: Don't allocate memory with __GFP_ZERO

 net/xfrm/xfrm_compat.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


base-commit: 3cea11cd5e3b00d91caf0b4730194039b45c5891
-- 
2.28.0

