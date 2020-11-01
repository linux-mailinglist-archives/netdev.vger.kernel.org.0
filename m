Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD132A2232
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 23:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgKAWaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 17:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgKAWaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 17:30:52 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3412C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 14:30:51 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id l24so12445402edj.8
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 14:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=T+cpjV/KX9R+fbpwvxt2QgajOEAMbJ7jZ/4yqLe5zM0=;
        b=anZV2MW+DNBAq+vtqdRVsPstUkzBE7P9T5L2JsnvSX7G5eTmZ9hhzUZo7YSBDSFfZ1
         Ik1zi9TBBjVEZ3+cB9f+6OqNQOY8x6BUtTVQf7X83dygWXPW391Jkxaeu/2tA5Z/axIb
         IXWEfRxDPAXNG0XTAbhPo5W77cBSEtHRyul4ur+SIs2h1N9rIqCS23kZ9hxvox3pKEJ6
         oaMfFtQBFnh69uOjLb0IJT3pCpXQfzW5Xhsq5CD5odVFvMaiobXhJEzY66YWJuS9ol0d
         yCWaUI94UgqzE1jkYaRlZABUWeIqGYRdpU4d/Dfp9l5DBjCDxrQGS1eSGBjkDBA03XxV
         Bpew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=T+cpjV/KX9R+fbpwvxt2QgajOEAMbJ7jZ/4yqLe5zM0=;
        b=h0x046jBaVxtPcO+dxR/Uh9/98fzI8yz/sOXnbSivA2vWSH7lhOIoMl1TkiDg7HZ9b
         hZdyuf4Y89avzKLiDn8CQa7l0eOBl6j3awmWlLvQEZ9qQ3R8C9CKxhCAg/avA7FQUAqI
         K92NYTPyp775B3PZH9SAoJc4FdrpCvhemXp8GKrYN7HnLEQ/+IQnL4Z6/PyC7zr2K9Eb
         R0NKP9DDJca7Ph9nLkEV4vmhjS6mw/WBZwjYBNUPkL9/sq6YemSeofXOt4OhG7QQvZqz
         fO+q0qb5F1g7cxpjUpzJg6IIIxmKnuUr6n8sSAJ7CdP5ihT5rpjmj++eGDsQEClqnv0v
         VEGw==
X-Gm-Message-State: AOAM531ptYauMyqXTdUl2eDlygmB+8aa4YNOdrlFsugWGZow3QlpexIB
        tsN6q4kaTO+1LkOLG36nfh9L65wcm+I=
X-Google-Smtp-Source: ABdhPJzEnHIC6Qe5rYoiPSSbdR+1D4A2iY3dmFsLsgZtdZjGbPEYQuqWygTuKPQo8Dk3iR3y/nm5Yg==
X-Received: by 2002:aa7:d7ce:: with SMTP id e14mr14377712eds.258.1604269849996;
        Sun, 01 Nov 2020 14:30:49 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:3050:ca03:432d:4900? (p200300ea8f2328003050ca03432d4900.dip0.t-ipconnect.de. [2003:ea:8f23:2800:3050:ca03:432d:4900])
        by smtp.googlemail.com with ESMTPSA id i14sm8351939ejp.2.2020.11.01.14.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 14:30:49 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: align number of tx descriptors with vendor
 driver
Message-ID: <a52a6de4-f792-5038-ae2f-240d3b7860eb@gmail.com>
Date:   Sun, 1 Nov 2020 23:23:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lowest number of tx descriptors used in the vendor drivers is 256 in
r8169. r8101/r8168/r8125 use 1024 what seems to be the hw limit. Stay
on the safe side and go with 256, same as number of rx descriptors.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ecdc0c36c..a426eed78 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -67,7 +67,7 @@
 
 #define R8169_REGS_SIZE		256
 #define R8169_RX_BUF_SIZE	(SZ_16K - 1)
-#define NUM_TX_DESC	64	/* Number of Tx descriptor registers */
+#define NUM_TX_DESC	256	/* Number of Tx descriptor registers */
 #define NUM_RX_DESC	256U	/* Number of Rx descriptor registers */
 #define R8169_TX_RING_BYTES	(NUM_TX_DESC * sizeof(struct TxDesc))
 #define R8169_RX_RING_BYTES	(NUM_RX_DESC * sizeof(struct RxDesc))
-- 
2.29.2

