Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1020A267732
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 04:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgILCSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 22:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgILCSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 22:18:16 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0D4C061573;
        Fri, 11 Sep 2020 19:18:16 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id l126so8602567pfd.5;
        Fri, 11 Sep 2020 19:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z5Uuz/LFVVjLTh/BV+QO4gT1Ug22z90Ki0ePNknJqKs=;
        b=XBH6OOrgwhkKMuzCuHd5azknLGUn/13zxIcpw4H0hkdo8eBp0CJQWOWulO5FChmogm
         M6FReqGG+uutVyTTIvTPnA3qnbcD5slhb2VNBS0r/CXSAEEhkpqx017tj4QFXpV2Dpd3
         sj3qOMtt89swe9vQ1xD8XuOlimbD1tbrF+hcpzgSfDoawt/diU8LAI/g5Tw3E7tMdIlX
         Yhh6c6lmgVDZ5/0v3k240H0Ime3wPUoOTPfToVEtFon6nd28QO2NzO+KcfI666Pl5N1d
         GNCwOPAOa91Iegg6PARIssNta5u5CXZM1FyDUR3Fr/g5R3GysYvOCf3akCNu4u8aiG8V
         ZJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z5Uuz/LFVVjLTh/BV+QO4gT1Ug22z90Ki0ePNknJqKs=;
        b=uB0xKn6Sve2S6b5Q+oK5hDk6Comew0xoc1AxVaFjLFf+t1BHsZcR4gTqRQs7KRgkw4
         i0J3/Z9JTt6QaWuNuWdj0E5yRvuNCiSUwVUhHhgperTsiXHU7hcmaOPsx6O1q92pVa96
         /odLez0FuQpMDemNd0UQpDI2cT2XjbLraKZguli7urY3wQWmZqL7uS8lEVsPrUpYlNo0
         179MXXdMYTM3MIq9XXDGwVQ8s0yAJXI4TWqCcXhR00AmtSI7nTLiyAzp31pvTnjRIBWU
         LVsfiAmnUBKe8p4nMbPfa6BTFE3pNqZNhSwAPC1G4HgEJOXZnxGcS28AZRORUhpyeulk
         VTjQ==
X-Gm-Message-State: AOAM531LlAhrR6jbqx4KQ29KPglx3OPe2c9JjKx/g+bo0vsCRahnlgIR
        EANicOnh0AGykvdsNJlEKrHIMsYQFMo=
X-Google-Smtp-Source: ABdhPJw3QfgY0gYKPi50zw/T3NbWJwClKOqNSkNxYyRE3wxswRVL8iEM/lfmmfG1mhyUjwWxI8UrNg==
X-Received: by 2002:a63:d115:: with SMTP id k21mr3603565pgg.272.1599877096046;
        Fri, 11 Sep 2020 19:18:16 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:d0fe:61cf:2e8d:f96])
        by smtp.gmail.com with ESMTPSA id d17sm3096687pgn.56.2020.09.11.19.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 19:18:15 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next] drivers/net/wan/x25_asy: Remove an unnecessary x25_type_trans call
Date:   Fri, 11 Sep 2020 19:18:07 -0700
Message-Id: <20200912021807.365158-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

x25_type_trans only needs to be called before we call netif_rx to pass
the skb to upper layers.

It does not need to be called before lapb_data_received. The LAPB module
does not need the fields that are set by calling it.

In the other two X.25 drivers - lapbether and hdlc_x25. x25_type_trans
is only called before netif_rx and not before lapb_data_received.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/x25_asy.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 5a7cf8bf9d0d..ab56a5e6447a 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -202,8 +202,7 @@ static void x25_asy_bump(struct x25_asy *sl)
 		return;
 	}
 	skb_put_data(skb, sl->rbuff, count);
-	skb->protocol = x25_type_trans(skb, sl->dev);
-	err = lapb_data_received(skb->dev, skb);
+	err = lapb_data_received(sl->dev, skb);
 	if (err != LAPB_OK) {
 		kfree_skb(skb);
 		printk(KERN_DEBUG "x25_asy: data received err - %d\n", err);
-- 
2.25.1

