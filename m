Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0ADD20CA38
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgF1TzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgF1Txq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:46 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4B3C03E97A;
        Sun, 28 Jun 2020 12:53:45 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w16so14530560ejj.5;
        Sun, 28 Jun 2020 12:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fPjGvKjCW6dK/yqgmCOTvyeAHLhCf44/++vEZ5RXXKU=;
        b=N26PmMbXjO9VvHE1IPZi79DwLxnuHcB5r05bGLEldj5dLdZ8/+uUMXW5UJlY8EKCeo
         ZMmXjyquOspJC5T1GH/7rnVhpHQ6BUzZsgrbjYosAtC09AAaxsisBWvGeYEznNR4rxYa
         AF8F3IQaWucFKA7lsaczsbG6x+rXkXhYP9TFa26Q43ZuAX5IzMydqEA1GZAmYF7KBDRo
         IHQbpFOMygcwpxirsSnfQw3+MBVWkXuOHAHo5B61fBkTb7K0aAVWeVZi9Stqc2jExS/y
         iVrjDtrsc92VYFzBHquc+V5nRs12CRdpNYo+XwNknWk5Lounx4XtwVxRYrNOlGZYFKkY
         Lziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fPjGvKjCW6dK/yqgmCOTvyeAHLhCf44/++vEZ5RXXKU=;
        b=X5jkDFZEEnm0URzOsRvaUrrfhp3WvbQPKUymuXmW8m0HOiD54KJ8DsRYpsL+HMVMtx
         iGT5Jrxx3aqLfxbuEg5nw1tenfjLVhU65RrJIY06HRYt73IvqHsXYUmpTmkfzNBmbta0
         xTjen1WZv7vvumJizW1qrQEVdGzRYKKqyEMMw/j9yndV+wEe/dyWfhCohHPL2LQdPeUZ
         HLGcwN6XqIwCYetEQCpRxOeF6G0bW6vsGOB1afx7M+QPoD+QCDUsWTieWhcwhRdsjO2P
         sp8BTJ7y0e9Ptl4BKRxtCy0mDyG8+3E/w45K5OUcdICTVhVAQOcPWTX+b6rPVcbtZcFi
         Z9Cg==
X-Gm-Message-State: AOAM532Jw31Jt9M/h3qgKKSCQorkww1UK3HRXpp3jolc8c/foVTwZMen
        VLcPty7Cx064AzOtfJWFIfE=
X-Google-Smtp-Source: ABdhPJxxTdHTa56fOOFdq5+yu9QGRGlvURcWLD/3ueZenKrbEQKWCdITdgdnRJDxPaSpQH6u5op/Ng==
X-Received: by 2002:a17:906:6410:: with SMTP id d16mr11845024ejm.376.1593374024492;
        Sun, 28 Jun 2020 12:53:44 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:44 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 02/15] caif: fix caif_xmit()'s return type
Date:   Sun, 28 Jun 2020 21:53:24 +0200
Message-Id: <20200628195337.75889-3-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
References: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/net/caif/caif_serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index d737ceb61203..bcc14c5875bf 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -266,7 +266,7 @@ static int handle_tx(struct ser_device *ser)
 	return tty_wr;
 }
 
-static int caif_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t caif_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ser_device *ser;
 
-- 
2.27.0

