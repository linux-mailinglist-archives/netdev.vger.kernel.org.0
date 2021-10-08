Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18424264A5
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 08:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhJHGeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 02:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhJHGeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 02:34:04 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8472FC061570
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 23:32:09 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r2so2152216pgl.10
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 23:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P1DnOHCSDpEyDCkGXVRNKZjKRqEDdiJtv3khbG068RU=;
        b=Xe0Q1Jck4a5P3tpQxbcqLb1kEMAN5vwQup9vo9mn6sK7brZFB0lJW1FvdcBqPz8CwU
         wKKLp5FuHJHJpSwtgvyHSDIe4i1rAA31GUlqynulJdEldo8RdgSqgnt8+nlmc+3nEIy3
         8GJkv8FHz+LatnDBnb424iVH1ZeG2Ll5on5hRfXgTPcoNl6UvkYE3vcAgEDgKYTPd/Bv
         lToIJCCRlTIypYp6HXuEjVyat40Cw/PzUqCcGicyrPC2Bav2Ap3UaUg+D3dePsFMo4ir
         0nTLsMXgfhpTt0mNrbB7v2PGQxtehdNVDWO7wsCMl81LApd041zujvFHGtWb+OD1RcGo
         A78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P1DnOHCSDpEyDCkGXVRNKZjKRqEDdiJtv3khbG068RU=;
        b=moLLIg+6Yg9OU3UiCHcYrQRjeX1ObCShLWtBN2NCxVdmktH6XR85wd32Pn11GbJwlr
         MTbCiiqgs9VFqs7KnJPFvwXdGfuWrMzLvPFA/P+GVxdYFbp3bmdlSaWrRmLotASUhFXb
         wA4Kt9M3dtr5SLuLiJbJpzCIn/quOWXr9r6ET/0GPt8DUJ2WXO6MzSLLaQibEo2KOi1v
         iI+V7YiInak1KBOPe01B04KzfI+6sBDuqJ3T05MxtR42++qRmUYSH8OCjBDygBYtScoY
         Rzh/EbMQntyRnafW8p5i8OczRjRPa0igrXWqPjNzZyTP6Jl83MDOmx2x1lrgDHNI70KE
         yNxQ==
X-Gm-Message-State: AOAM530Nx1zTQcrB7tKc4Obff0xNG5W7NSUl845ifeamEIRGNujZAXk6
        +W+FotkTXPxVBLVNlkR3ufj4NsX6C3ecDA==
X-Google-Smtp-Source: ABdhPJxJZ3OvFvkxHL2Vpg1RkZO52H483MItQgwUbVu67rL1zxnB4BRyoa26TNUCYm4gnXjg3MYArw==
X-Received: by 2002:a63:fe4f:: with SMTP id x15mr3183020pgj.424.1633674729099;
        Thu, 07 Oct 2021 23:32:09 -0700 (PDT)
Received: from localhost ([23.129.64.143])
        by smtp.gmail.com with ESMTPSA id t13sm1122740pjg.25.2021.10.07.23.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 23:32:08 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc:     prashant@broadcom.com, mchan@broadcom.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: tg3: fix redundant check of true expression
Date:   Fri,  8 Oct 2021 00:31:47 -0600
Message-Id: <20211008063147.1421-1-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Remove the redundant check of (tg3_asic_rev(tp) == ASIC_REV_5705) after
it is checked to be true.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5a50ea75094f..32d486114a6d 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -10273,8 +10273,7 @@ static int tg3_reset_hw(struct tg3 *tp, bool reset_phy)
 
 	if (tg3_asic_rev(tp) == ASIC_REV_5705 &&
 	    tg3_chip_rev_id(tp) != CHIPREV_ID_5705_A0) {
-		if (tg3_flag(tp, TSO_CAPABLE) &&
-		    tg3_asic_rev(tp) == ASIC_REV_5705) {
+		if (tg3_flag(tp, TSO_CAPABLE)) {
 			rdmac_mode |= RDMAC_MODE_FIFO_SIZE_128;
 		} else if (!(tr32(TG3PCI_PCISTATE) & PCISTATE_BUS_SPEED_HIGH) &&
 			   !tg3_flag(tp, IS_5788)) {
