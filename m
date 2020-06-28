Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263EE20CA29
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgF1Tyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbgF1Txx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:53 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6556C03E979;
        Sun, 28 Jun 2020 12:53:52 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a1so14493018ejg.12;
        Sun, 28 Jun 2020 12:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qtOiIEBPt4SkK7LL8W0wYi5N7Dg5qkNU6840uKUEEm4=;
        b=A9erurEDtx3Izd4yjqKUT2sBp4YjmOLAX9WD0HsySrEbAcCR2AwWh3WkpY24KszSGN
         eIgg1wHmHUUkISV7uen/EM4Q2e+qZCIi2yRVM08K5y/EUJJ4Tr+b2aMfybURblT2LypH
         c+I59zjHnRYCLx+FhX9EQFyZ4dsR+9muLtMvv3OsgH/drf9i5zbSNXkRtPEr4rKYUXY8
         y8T8oRqgy/Pm+T80+wPsBNa504Xsj/sUubxcjH+ZNAgvI4aC1njYu0uNiVx/5gSIaDFN
         gXZK5QMo5eG7G7Ug5IClRYA7PbosJTZxmMx6U7lpNVonhseF8PFZWnqO1l7p1pxNwuQ9
         DFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qtOiIEBPt4SkK7LL8W0wYi5N7Dg5qkNU6840uKUEEm4=;
        b=iTlqk25AMXdkP5Fpt81jyfJ1xwKqytK6ysAmjm7eCABTxo3JTgnCxIazBLwzxEMM7l
         2cxj+dYRSzI4FVZ+ZjP1F2FpIRmLb8iefszsCGgfBTQG8llxV5fxs2biBXOgkN2Slu9n
         YU0BJgNzeCxjxtPSlJLqeqO5rrwHBVWmbQBXQFpHUGqm5w1teDOY6nUhLG8fIrqwIm+m
         UFl78Y5AgXZPlfCcmA+uHmJIyFwitHNvdexbaoT9U37TpJawTEVRubyT5ANh1P4wU+na
         D7Hb1U2tJuwdNYgEGMbf+9OvMAsQt5g/vdNEhRvnO3ElLDcrbTfMKifBXLw2sJQvqd+X
         jdhg==
X-Gm-Message-State: AOAM532HwzVkIXmk2QkcKkdTxvfHftSlWP5eBv9pbfOM6wTBldtpDMfP
        XjBVmHbnZMVxHljFoIdWkfc=
X-Google-Smtp-Source: ABdhPJx4fdMhx9d4maG/HXB+0DSLpVO6tt8V+9KbfZdFYn7d/6aQBr75kaorsK/y6gPWufzRTlIyyA==
X-Received: by 2002:a17:906:90c1:: with SMTP id v1mr11026636ejw.481.1593374031509;
        Sun, 28 Jun 2020 12:53:51 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:51 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 08/15] net: nfp: fix nfp_net_tx()'s return type
Date:   Sun, 28 Jun 2020 21:53:30 +0200
Message-Id: <20200628195337.75889-9-luc.vanoostenryck@gmail.com>
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
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 0e0cc3d58bdc..83ff18140bfe 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -974,7 +974,7 @@ static int nfp_net_prep_tx_meta(struct sk_buff *skb, u64 tls_handle)
  *
  * Return: NETDEV_TX_OK on success.
  */
-static int nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 	const skb_frag_t *frag;
-- 
2.27.0

