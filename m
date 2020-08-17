Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDA22461EC
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgHQJHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgHQJHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:07:18 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A216C061389;
        Mon, 17 Aug 2020 02:07:18 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d188so7916915pfd.2;
        Mon, 17 Aug 2020 02:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=X4dlW5QSrhHLi6L8+0ff6mHexoyAgIeVhfzv0IpcLxs=;
        b=mmgPvUZTBoshrP77oNYRg9mcjEKY0IRDZl+WQQeU/6BI8NhNqS9un6FQPx6+NjEOhm
         Zf199zqYaoA3xR/l44mFRPqg2p3Egn6iqmW4mrj00w24ol9mFL/+SCVHu5RKtembOXsU
         JR4V/FMNr0mFEE9KXLl09nqAhWOfG3j7IT/R3au/vDTAD08AhHHmxGZ52TaJtNfO1MCA
         MEfaR4FhXNV2sGmq/Hj1d4fBylEGdorMX4CTeClH7UZs52sjW3qZ9qwY45JrLpZp4DoY
         gLmFY59C+euF51CdD75yUH0aV81DY9KpQ9cms5gUraik8IBr4yjf22mAybsOj5YQlkaF
         lQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=X4dlW5QSrhHLi6L8+0ff6mHexoyAgIeVhfzv0IpcLxs=;
        b=MYeM8NBc/tVCwKKX9oA8Ck+lJpRx6istMiDmTH5l9G/PYXgyZZI07CAeaxlLEhtJnp
         mCdVc/q6XeFa6omIYOZYPnw68lROGSgAeZo9emIDODUSgPtZyu8/GCH+zZ5mURs29BE5
         RtYA7G0alixTwi6R5bKkJE22DmfGHiXD4H74fEvbPgW+8lQUoMRNVgslfzlbDcpl4vcJ
         uBnGBWh1e1b9DoDcZcRqzojeZlWa2gl41AuV4pGkOnPpMnVl0XKhXy8YCQVNIonVlGNC
         IahU8x0tzmA3VagRFgKf+pbiSu1ltWzIYZr+00k9I11KL/Wr+xayKbsnA8dyVWfnlg+I
         K7Qw==
X-Gm-Message-State: AOAM531OVPxGNh60HEE/uCQt8BZ8vI6TupPkbrBG9twjT5Ku65A1OEBJ
        8DT3Qp9F7sj9dF5phxgyNHo=
X-Google-Smtp-Source: ABdhPJyTsIBRX/YPHm7I4e9LyUWTEAp0viv4KNn9LR6z5UIfTAX4SWkjsOK/b5FMIEM6VkIP8b6U0w==
X-Received: by 2002:a65:6650:: with SMTP id z16mr9856751pgv.161.1597655237848;
        Mon, 17 Aug 2020 02:07:17 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:07:17 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     kvalo@codeaurora.org, kuba@kernel.org, jirislaby@kernel.org,
        mickflemm@gmail.com, mcgrof@kernel.org, chunkeey@googlemail.com,
        Larry.Finger@lwfinger.net, stas.yakovlev@gmail.com,
        helmut.schaa@googlemail.com, pkshih@realtek.com,
        yhchuang@realtek.com, dsd@gentoo.org, kune@deine-taler.de
Cc:     keescook@chromium.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 03/16] wireless: ath: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:24 +0530
Message-Id: <20200817090637.26887-4-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817090637.26887-1-allen.cryptic@gmail.com>
References: <20200817090637.26887-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/wireless/ath/carl9170/usb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index ead79335823a..e4eb666c6eea 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -377,9 +377,9 @@ void carl9170_usb_handle_tx_err(struct ar9170 *ar)
 	}
 }
 
-static void carl9170_usb_tasklet(unsigned long data)
+static void carl9170_usb_tasklet(struct tasklet_struct *t)
 {
-	struct ar9170 *ar = (struct ar9170 *) data;
+	struct ar9170 *ar = from_tasklet(ar, t, usb_tasklet);
 
 	if (!IS_INITIALIZED(ar))
 		return;
@@ -1082,8 +1082,7 @@ static int carl9170_usb_probe(struct usb_interface *intf,
 	init_completion(&ar->cmd_wait);
 	init_completion(&ar->fw_boot_wait);
 	init_completion(&ar->fw_load_wait);
-	tasklet_init(&ar->usb_tasklet, carl9170_usb_tasklet,
-		     (unsigned long)ar);
+	tasklet_setup(&ar->usb_tasklet, carl9170_usb_tasklet);
 
 	atomic_set(&ar->tx_cmd_urbs, 0);
 	atomic_set(&ar->tx_anch_urbs, 0);
-- 
2.17.1

