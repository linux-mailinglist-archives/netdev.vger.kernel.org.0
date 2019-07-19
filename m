Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4676E324
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 11:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfGSJHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 05:07:38 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41071 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfGSJHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 05:07:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so13907827pff.8;
        Fri, 19 Jul 2019 02:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVW3vUyQIGlttxB7d4coQNzCIFhrIEtf8tciYiOHfMM=;
        b=kSJour3PB25SjVK+zTOUmCSVJJMU+pBRgmBaNXOp4U2TLYeO899DuO4rmrR0V8c8Tx
         8SRLDCDqcc/z3pdAT2ITifncdNMk1q131CqOUMdUFTE3oso5CqWpEv6sXOfK4HV/l8P0
         SDASWajXB4cmXRFtwZbK7Ci0Hd84CRuP7dg/3Y5mRi8R0uzWmo68dOVpKytCmrzuaKwU
         +DSgmOykXwmdm4MIuNlrxsY9wHAwzhE4oynOg+DKa7zSGn6mAOmfBr1Doa1J4PKZgWnn
         I//Tsuj40cNKYCtqC6vk4YcGO9p+Rw9mBsgEu006hQNLRn3qIEER6q9pMUk4yS8/NvNO
         lXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVW3vUyQIGlttxB7d4coQNzCIFhrIEtf8tciYiOHfMM=;
        b=nJMesKNyTEuXHbddf2Qf3RGjcTKZtuMUBcvbumvrQnE02JtvJhYLNvDVn1gDLmNqJr
         qvsmf+9c/BZ4e/gsWjJNnaNfE66apvSyGVy2RThQxWHxGLqFVtlJTPKJrI9qdy513iex
         V/mmKaZXt/972yIxfJYAT0whMZ+HIfEhvNytzy2+rHwW9ED9PNZZQk5HFUVd15B9jBL+
         YxuCiWrMfS+7g59RMf+GGpHAtTiqP4rvWVBz9F0QSumXWc4SE8io38dUtjWbCaQk5E6h
         EzxYW5P1KVXRWsdMdJ5UjI5bkZ17azDPziVh+/kmaOIo5oqVtMm7b/CXWjPiNG7v4x38
         JfyA==
X-Gm-Message-State: APjAAAWTad4L8qV0S/fYOTbI8fuznv0fcJZbQXID4R1Sbrcenct4cJ0R
        GEKRkk6WLA7lCCZr7JfTAWg=
X-Google-Smtp-Source: APXvYqyjSDLx5lH9egeR88KsrwSkCirIGl9HHEdsM3Nz+aKE8lyMEY5RzKoWTbu1soMFSage/QWrEQ==
X-Received: by 2002:a63:db45:: with SMTP id x5mr40825943pgi.293.1563527256835;
        Fri, 19 Jul 2019 02:07:36 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id d2sm27223139pjs.21.2019.07.19.02.07.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 02:07:36 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] ax88179_178a: Merge memcpy + le32_to_cpus to get_unaligned_le32
Date:   Fri, 19 Jul 2019 17:07:15 +0800
Message-Id: <20190719090714.19037-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge the combo use of memcpy and le32_to_cpus.
Use get_unaligned_le32 instead.
This simplifies the code.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/usb/ax88179_178a.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 0bc457ba8574..72d165114b67 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1366,8 +1366,7 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		return 0;
 
 	skb_trim(skb, skb->len - 4);
-	memcpy(&rx_hdr, skb_tail_pointer(skb), 4);
-	le32_to_cpus(&rx_hdr);
+	rx_hdr = get_unaligned_le32(skb_tail_pointer(skb));
 
 	pkt_cnt = (u16)rx_hdr;
 	hdr_off = (u16)(rx_hdr >> 16);
-- 
2.20.1

