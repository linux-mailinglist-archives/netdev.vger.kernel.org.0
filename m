Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83CE3DC7E2
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 21:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhGaTLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 15:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbhGaTLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 15:11:10 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF954C061799;
        Sat, 31 Jul 2021 12:11:01 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id y200so15576173iof.1;
        Sat, 31 Jul 2021 12:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1M+wifrjKnGWtdnx+ta5aPYGhd+6fvMpaZ2GY9QQ4f0=;
        b=CIquJTrWLvU/Nw+FkwqducdAzBwvUmqqCzPDAoCJn8AWOfubID25PxVVOnUStKCXLb
         LC2etc9lRUupCqJ/wSH2EYfcfS0XslUnD5iT8UICOOnvgTOMMP4owYnkkzNSJlCBJ25q
         3ijdC9KbyRu2xqCLLHYxROTGNQ9dZBjrPUt/YvfvxhXsajFjjS3+VuJ8T6RDT9zL3+LJ
         POk2ldL2EyJ4Xdbg0ZsM37rZtrgkDMTWrzoqMNkCcJvp4Fh6LhsPddUKOcJAleps54/l
         2UvnCyHhKC0WMj71pbt+DXyaw6h7rzY6Gm5bMELSSBqN4dwJmvpOhPh8AANGdKsn5FAx
         lxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1M+wifrjKnGWtdnx+ta5aPYGhd+6fvMpaZ2GY9QQ4f0=;
        b=HFjHH5mmJYY4lX7S7fwfuNPlLYm6+HfCF1XCTtKibH9uuU2xHYMOs/bacPqQLholpk
         zxxV9qDtG8XLw9oQa0Lj0x3pLJVreER1kV6loXEPRijltbDdFVYPmF/EqIggz+5IdJt8
         PCyW5G+6AWRLtnzb6g93YQenxw2H/2mh2mUsz4UbokBN3LqjONlnv/TgS0NtJhUyESjP
         mc+plhrkMe+CXcrQbWgVMFMucR4SswLlH9ORZU4hA9o3PB4bJXQ1Y5Pwmwiat0XwZS9z
         KBeekhUjHgXTi0AMkBrpVpX7FOdqhSwoAbvMFWW1AGpOQRDj8Wl7AA3JDm+lnQWJ+Qd6
         lLDA==
X-Gm-Message-State: AOAM532TXn6yDydGHHAbCUhMlxnU+AdisvQAJ+ohiZ7S15ePQpB06KMX
        LIjroLWUK5XYpWgwI1M1MeM=
X-Google-Smtp-Source: ABdhPJzlnoVF/Ae1KwED8ArpzoVj+uD7GdpzSL8TVE1Sg92joMvx0qB8jVTPkObUL8m2CMEmEFtmxg==
X-Received: by 2002:a5d:89d6:: with SMTP id a22mr4548712iot.178.1627758661364;
        Sat, 31 Jul 2021 12:11:01 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g1sm2837991ilq.13.2021.07.31.12.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 12:11:00 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Eric Woudstra <ericwouds@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: [RFC net-next v2 4/4] Revert "mt7530 mt7530_fdb_write only set ivl bit vid larger than 1"
Date:   Sun,  1 Aug 2021 03:10:22 +0800
Message-Id: <20210731191023.1329446-5-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210731191023.1329446-1-dqfext@gmail.com>
References: <20210731191023.1329446-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 7e777021780e9c373fc0c04d40b8407ce8c3b5d5.

As independent VLAN learning is also used on VID 0 and 1, remove the
special case.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 38d6ce37d692..d72e04011cc5 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -366,8 +366,7 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 	int i;
 
 	reg[1] |= vid & CVID_MASK;
-	if (vid > 1)
-		reg[1] |= ATA2_IVL;
+	reg[1] |= ATA2_IVL;
 	reg[2] |= (aging & AGE_TIMER_MASK) << AGE_TIMER;
 	reg[2] |= (port_mask & PORT_MAP_MASK) << PORT_MAP;
 	/* STATIC_ENT indicate that entry is static wouldn't
-- 
2.25.1

