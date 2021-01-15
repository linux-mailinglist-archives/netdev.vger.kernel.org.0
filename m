Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A504F2F7188
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 05:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732940AbhAOEPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 23:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731104AbhAOEPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 23:15:39 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DD7C061575;
        Thu, 14 Jan 2021 20:14:58 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id g15so161099pjd.2;
        Thu, 14 Jan 2021 20:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ER/AuN2pwX5jM+mT2AgamyAnX49kSRncObWB1UI1qIk=;
        b=FKZ2CTtP8dwwwjHjx2p+kUO+RsUdcVcg2SORLKjBiTwK21AKpedlLEhXggwGZv+xkq
         yjdtkaxPx+3piqUQpIaZoBJ5+0nwRrECGWGiq17T53hDsVKdVQVoNsNKPRwdKpxiIg7x
         +KXBCUa8WHWKRV7A89Rqy7x0BQOTB8nmHw/kFXuz9tIiqxDZinz3lNoPY21nT7NeKUls
         hFUzscgNgfCMnwGU2hYVlVEFxQSZXn48TqQRR+3y1LN1eyKblWZ+zstBKk62ZdaHBPIK
         aca1exR7DyDJxa1lAk20C0zWmkxD4OU/xbaq4UAXbNYDsLorzoDZZWV901Wn8NU5zuYS
         Id4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ER/AuN2pwX5jM+mT2AgamyAnX49kSRncObWB1UI1qIk=;
        b=bnKOxszUOZ51CpwyBElIf9rvcyBdOR5JF2ZC3mSgk5ZHw7t7T2Q9mkDH8EBaFLDAXl
         DPuFS3ezJTkW5x12DiU9Ljq1TeXOQ0fBKQeRnkVped+0jZ/jU9St0Vc93pUUq/P2A/2o
         By6SuOSpX+rgnHNZw+CalsS6789v0Tb9xWxoYsUpMA13TgU7a0eCT0UzbbACk1IqE9xI
         NWYVwiYh7ABzQ+UPjJz2AqIxw0qRfkEKaq0RHkcwx8iKWLJFaNEIKzc/EwcI4TwbX9Xk
         //m0rTrpPkIZHFjqYLJEAsMpvH/0JnhK0D2EUEtQ/NuQ9U2N2Cv4eeznzeYCN7AwZ5kb
         d17g==
X-Gm-Message-State: AOAM532kw0XxlMRT+Mn1zwil9CEK1I8A3/6WYPzf00Tdukx/OuFHvtrA
        GB9nV7whYE2L0LlEBO21sa+idtCnSCaH1Nho
X-Google-Smtp-Source: ABdhPJwvnzKF20YXh9XLPBtSSqRxD2fl7DRcbE9sJkDUe89y+gbua/zZVNgz/uCuiZtdNYC20Qa6+Q==
X-Received: by 2002:a17:90a:4dcd:: with SMTP id r13mr8525821pjl.74.1610684098481;
        Thu, 14 Jan 2021 20:14:58 -0800 (PST)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id 193sm6746592pfz.36.2021.01.14.20.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 20:14:57 -0800 (PST)
From:   Geliang Tang <geliangtang@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] nfc: netlink: use &w->w in nfc_genl_rcv_nl_event
Date:   Fri, 15 Jan 2021 12:14:53 +0800
Message-Id: <f0ed86d6d54ac0834bd2e161d172bf7bb5647cf7.1610683862.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the struct member w of the struct urelease_work directly instead of
casting it.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/nfc/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 573b38ad2f8e..640906359c22 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1819,9 +1819,9 @@ static int nfc_genl_rcv_nl_event(struct notifier_block *this,
 
 	w = kmalloc(sizeof(*w), GFP_ATOMIC);
 	if (w) {
-		INIT_WORK((struct work_struct *) w, nfc_urelease_event_work);
+		INIT_WORK(&w->w, nfc_urelease_event_work);
 		w->portid = n->portid;
-		schedule_work((struct work_struct *) w);
+		schedule_work(&w->w);
 	}
 
 out:
-- 
2.29.2

