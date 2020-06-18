Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A531FE9A6
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgFRDxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgFRDxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:53:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21545C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a188so5046739ybg.20
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B9ST2pcwYRlVFiUwvCnycs4QvccZohHW4codKg/MZAw=;
        b=LfDenv0oTiYzR+gn0Zbx8AH2X2n/QS7LSoLMXV5uQjDYE12JeaCQu3B/3aw/ulygzW
         0UuNsHo+Ozipfs9Bd74lVZiCeYAS15Yt3CqD/OJpRI8iRfGmkEm5zSWi7jItW+6/THSg
         ug61F3BJVNQZxixVR+69ThXD52+2bKHdFvtrzFrhFQInVFLLZhJ8nhcx+DJQVCP40w9d
         qF+NjoITB94JKIBXtVkyOyo1ApmGgESJrKrnqqOwBcb04utkEpJ+kTZxKY+1u9G0aElu
         SM9zBA3MVKoVbiJC15TqjhZrpMJpUl9+T5aYI2/3TJsSlMDfU49XvTiLjg4M5DYHpexW
         jvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B9ST2pcwYRlVFiUwvCnycs4QvccZohHW4codKg/MZAw=;
        b=YCAMUrlJQkvT0YJXpWJDiDz5KcM18n8nFiqxFJff58KY1dezKj9Cte2mrMQAUI8x61
         vQjJbXoqBsgwQknXXn23zVSHTxTFYsSTAJENu1oc2vcKigjaNrWNBM8is+MX3kEH1rGx
         gBBuONPegJKvSY2C3JJhiIVzL2uoX4+3hQs6JP1YDvBkxR4zdTvlO2OyHlKt3GlXsB06
         zi04bHgd9dEUtcBjucS18GyToiQIUb+33P/CKrJH3ZyfQd2+u8UpsLAKWBuaVImEzVxh
         DEmyw0/p9G5swCQRJEXUZz8NLyaG+bS6wnysnwEp4eKsoWmdA/95+w0pemO+NFvvVB46
         1eMA==
X-Gm-Message-State: AOAM530ZVNrb65g5fdhwvXKMb9Siw1PI9MqSKyhP5n/i+7Rg9V5v+6Un
        ALng2wAfc5GFTLJ9szKkFKloITVKLBd3pw==
X-Google-Smtp-Source: ABdhPJwg481d7JhKkf0bN7lBdY0ukxVlBXW0EH65Vb7PbuloX8jjP82RbgXmHYadiIfXkLCc9SKKn9OEV3b/xQ==
X-Received: by 2002:a25:3d01:: with SMTP id k1mr3354806yba.510.1592452412212;
 Wed, 17 Jun 2020 20:53:32 -0700 (PDT)
Date:   Wed, 17 Jun 2020 20:53:21 -0700
In-Reply-To: <20200618035326.39686-1-edumazet@google.com>
Message-Id: <20200618035326.39686-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200618035326.39686-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH v2 net-next 1/6] octeontx2-af: change (struct qmem)->entry_sz
 from u8 to u16
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to increase TSO_HEADER_SIZE from 128 to 256.

Since otx2_sq_init() calls qmem_alloc() with TSO_HEADER_SIZE,
we need to change (struct qmem)->entry_sz to avoid truncation to 0.

Fixes: 7a37245ef23f ("octeontx2-af: NPA block admin queue init")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index cd33c2e6ca5fc25e16ec3b3f036df799471d88d5..f48eb66ed021b052b94d09684008cdb4e6356cd0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -43,7 +43,7 @@ struct qmem {
 	void            *base;
 	dma_addr_t	iova;
 	int		alloc_sz;
-	u8		entry_sz;
+	u16		entry_sz;
 	u8		align;
 	u32		qsize;
 };
-- 
2.27.0.290.gba653c62da-goog

