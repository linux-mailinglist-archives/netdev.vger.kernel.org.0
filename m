Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4A313899
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 12:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfEDKIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 06:08:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43954 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfEDKIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 06:08:23 -0400
Received: by mail-pg1-f195.google.com with SMTP id t22so3952795pgi.10;
        Sat, 04 May 2019 03:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WtljU9VToTYo8/FnSPzYs4PaGQxXjF45f7gWSItjexo=;
        b=uezVEqpTS7R5exHUJZd+k/vahlPQ/GxwBMvWkTXvH8408RduT9Z9SuEi2+MZ6JuThG
         s+za/oGHOUsOco2Y71Sy64prIH61vmdgArRHXiDVuLsiVghrfcvLt/AZFAnkeEiq/Itv
         x/FFC1nF5f1l+SPVr34F/rZSnPOC/3Xiv8l2SaIiD2BQKSdg8Aay1uuUVt9E3tT5uXLa
         3CAA/GDg1XOYv2Q/qDS+sA32lZNOtez+u8Twz8cb00wCj7Dfo/EuzRcRBpJqzDtz6Or6
         HMi0br1PQ29S3hXehG58adHnvxud/mos0rAaLI8b8Gze9L6mwnhJWb1KxtawBSxE88ss
         AMBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WtljU9VToTYo8/FnSPzYs4PaGQxXjF45f7gWSItjexo=;
        b=I29Fdt5CL6vNhVuieToxkjCdShazT1XM5cVLNLFgi3tXfGwJlQg6FuNlyVgWy6+Txs
         2uI1kTXWFNLHmfRkoro226IGrPx9mMpyU9z8OYHW/s+HtZRfMm53BrxN6SHrE42fN5mS
         c0kcx5Rz8fDLFMg6/6c7gUS3AzCoQv0SadNeLfcOM7urbrbNJNJi6ofKAiojhQoL/Sao
         deMJBgz11W4/HDhnzvq5GVSxM/mg4FKibPoVqZGR/IC8OLlyoWKWLB92ic+Wi7B3ly2L
         Ic1082MUvN71tuUXDKJiKWXX0gESfwprIKL7+8F9qEnKNT/iZyt2Rv2MaYkUizuHqKQq
         3P+Q==
X-Gm-Message-State: APjAAAUeKdI9yC7dLAmFX2SwXeXy1WM15nJrB59mMQKzRwaeRxwxHv+v
        tKuRhom9kZdgN9M20lj2vmY=
X-Google-Smtp-Source: APXvYqyIvw5W7ofeadhPhx5ePsCQ+yCQS3ne3Y/esS26bhFKtz6qSQleAgTLpJ3NwUYfXJUqWr6iGA==
X-Received: by 2002:a63:90c7:: with SMTP id a190mr17995325pge.23.1556964502977;
        Sat, 04 May 2019 03:08:22 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id a26sm4221622pfl.177.2019.05.04.03.08.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 03:08:22 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: wireless: ath9k: Return an error when ath9k_hw_reset() fails
Date:   Sat,  4 May 2019 18:08:15 +0800
Message-Id: <20190504100815.19876-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ath9k_hw_reset() in ath9k_start() can fail, and in this case, 
ath9k_start() should return an error instead of executing the 
subsequent code.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f23cb2f3d296..f78e7c46764d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -681,6 +681,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 			"Unable to reset hardware; reset status %d (freq %u MHz)\n",
 			r, curchan->center_freq);
 		ah->reset_power_on = false;
+		return r;
 	}
 
 	/* Setup our intr mask. */
-- 
2.17.0

