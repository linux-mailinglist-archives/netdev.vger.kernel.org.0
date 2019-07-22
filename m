Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558BD709E0
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732269AbfGVTlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:41:32 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37684 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732245AbfGVTlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:41:31 -0400
Received: by mail-pg1-f193.google.com with SMTP id i70so7409735pgd.4
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 12:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2ydHyx146Gpo6F/4Mk5APlIfYtwAqU9vRc87LHJBOg=;
        b=AfWp26av7d1R0GVQBZqmVDo36nl/ONdvumK8cBMcUztafl3YzMOQbj4/Ut6lsbwQYy
         2IDNfw3efcHERFPIOzf68rMcvJlkJCPORgBDyZvs+wnOumbE/nmtn788576/X8Nxv7Ms
         Q04HPAwn45lcvNsj0GEKx81i8tmNcG+fCQ1vI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2ydHyx146Gpo6F/4Mk5APlIfYtwAqU9vRc87LHJBOg=;
        b=sSfEaG/xmB58k7faZH3sMjidz72dRGLZSi1rkNeLEn9dzrOSUAA11U7YMbBXasT+q2
         zu38GuMKdaf2y26bLsemyOZU0PBJhh9/Dn/I2ihPW3JotE4voGfGzd1AH5OABQE4ns4u
         AolcXnQnHTpFq+mREDpUHycEAPjxXadcXd4z7gFxLnNmKyVM5YdRtOqGyHDA6QmY06YZ
         uTpQRb9eYS7e9OkDI1YQ+67RdjQOqA0fhrqMikTgZoJGCRoHADiDmkhjKszKnCOPSBoN
         jpw+hLWsO20K1SLXWv2AsCCUG9yGS2YmM+oVPX5eXtex5FBVj5F7RWnxLK7cp2l7AWzx
         pjcw==
X-Gm-Message-State: APjAAAWSRe/v6aeBMCUJhEQajcoCqw5QWP5lkE/kJnGmFKt9Pg4kZQr+
        10oeohhJnVLoHyXjsXrcC2FKpQ==
X-Google-Smtp-Source: APXvYqxRbyCKEUMoA0Ph44+At0UA78EhAjWJ+Hp3Q5G6AQTNXv8xUqU98puubWwzR/JltKnz8oH/pQ==
X-Received: by 2002:a63:1020:: with SMTP id f32mr43080141pgl.203.1563824490156;
        Mon, 22 Jul 2019 12:41:30 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id z4sm29838803pgp.80.2019.07.22.12.41.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 12:41:29 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     Ganapathi Bhat <gbhat@marvell.com>, linux-wireless@vger.kernel.org,
        Andreas Fenkart <afenkart@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        linux-mmc@vger.kernel.org, davem@davemloft.net,
        Xinming Hu <huxinming820@gmail.com>,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>
Subject: [PATCH v2 1/2] mmc: core: Add sdio_trigger_replug() API
Date:   Mon, 22 Jul 2019 12:39:38 -0700
Message-Id: <20190722193939.125578-2-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190722193939.125578-1-dianders@chromium.org>
References: <20190722193939.125578-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using Marvell WiFi SDIO cards, it is not uncommon for Linux WiFi
driver to fully lose the communication channel to the firmware running
on the card.  Presumably the firmware on the card has a bug or two in
it and occasionally crashes.

The Marvell WiFi driver attempts to recover from this problem.
Specifically the driver has the function mwifiex_sdio_card_reset()
which is called when communcation problems are found.  That function
attempts to reset the state of things by utilizing the mmc_hw_reset()
function.

The current solution is a bit complex because the Marvell WiFi driver
needs to manually deinit and reinit the WiFi driver around the reset
call.  This means it's going through a bunch of code paths that aren't
normally tested.  However, complexity isn't our only problem.  The
other (bigger) problem is that Marvell WiFi cards are often combo
WiFi/Bluetooth cards and Bluetooth runs on a second SDIO func.  While
the WiFi driver knows that it should re-init its own state around the
mmc_hw_reset() call there is no good way to inform the Bluetooth
driver.  That means that in Linux today when you reset the Marvell
WiFi driver you lose all Bluetooth communication.  Doh!

One way to fix the above problems is to leverage a more standard way
to reset the Marvell WiFi card where we go through the same code paths
as card unplug and the card plug.  In this patch we introduce a new
API call for doing just that: sdio_trigger_replug().  This API call
will trigger an unplug of the SDIO card followed by a plug of the
card.  As part of this the card will be nicely reset.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
---

Changes in v2:
- s/routnine/routine (Brian Norris, Matthias Kaehlcke).
- s/contining/containing (Matthias Kaehlcke).
- Add Matthias Reviewed-by tag.

 drivers/mmc/core/core.c       | 28 ++++++++++++++++++++++++++--
 drivers/mmc/core/sdio_io.c    | 20 ++++++++++++++++++++
 include/linux/mmc/host.h      | 15 ++++++++++++++-
 include/linux/mmc/sdio_func.h |  2 ++
 4 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 221127324709..5da365b1fdb4 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2161,6 +2161,12 @@ int mmc_sw_reset(struct mmc_host *host)
 }
 EXPORT_SYMBOL(mmc_sw_reset);
 
+void mmc_trigger_replug(struct mmc_host *host)
+{
+	host->trigger_replug_state = MMC_REPLUG_STATE_UNPLUG;
+	_mmc_detect_change(host, 0, false);
+}
+
 static int mmc_rescan_try_freq(struct mmc_host *host, unsigned freq)
 {
 	host->f_init = freq;
@@ -2214,6 +2220,11 @@ int _mmc_detect_card_removed(struct mmc_host *host)
 	if (!host->card || mmc_card_removed(host->card))
 		return 1;
 
+	if (host->trigger_replug_state == MMC_REPLUG_STATE_UNPLUG) {
+		mmc_card_set_removed(host->card);
+		return 1;
+	}
+
 	ret = host->bus_ops->alive(host);
 
 	/*
@@ -2326,8 +2337,21 @@ void mmc_rescan(struct work_struct *work)
 	mmc_bus_put(host);
 
 	mmc_claim_host(host);
-	if (mmc_card_is_removable(host) && host->ops->get_cd &&
-			host->ops->get_cd(host) == 0) {
+
+	/*
+	 * Move through the state machine if we're triggering an unplug
+	 * followed by a re-plug.
+	 */
+	if (host->trigger_replug_state == MMC_REPLUG_STATE_UNPLUG) {
+		host->trigger_replug_state = MMC_REPLUG_STATE_PLUG;
+		_mmc_detect_change(host, 0, false);
+	} else if (host->trigger_replug_state == MMC_REPLUG_STATE_PLUG) {
+		host->trigger_replug_state = MMC_REPLUG_STATE_NONE;
+	}
+
+	if (host->trigger_replug_state == MMC_REPLUG_STATE_PLUG ||
+	    (mmc_card_is_removable(host) && host->ops->get_cd &&
+			host->ops->get_cd(host) == 0)) {
 		mmc_power_off(host);
 		mmc_release_host(host);
 		goto out;
diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 2ba00acf64e6..9b96267ac855 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -811,3 +811,23 @@ void sdio_retune_release(struct sdio_func *func)
 	mmc_retune_release(func->card->host);
 }
 EXPORT_SYMBOL_GPL(sdio_retune_release);
+
+/**
+ *	sdio_trigger_replug - trigger an "unplug" + "plug" of the card
+ *	@func: SDIO function attached to host
+ *
+ *	When you call this function we will schedule events that will
+ *	make it look like the card containing the given SDIO func was
+ *	unplugged and then re-plugged-in.  This is as close as possible
+ *	to a full reset of the card that can be achieved.
+ *
+ *	NOTE: routine will temporarily make the card look as if it is
+ *	removable even if it is marked non-removable.
+ *
+ *	This function should be called while the host is claimed.
+ */
+void sdio_trigger_replug(struct sdio_func *func)
+{
+	mmc_trigger_replug(func->card->host);
+}
+EXPORT_SYMBOL(sdio_trigger_replug);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 4a351cb7f20f..40f21b3e6aaf 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -407,6 +407,12 @@ struct mmc_host {
 
 	bool			trigger_card_event; /* card_event necessary */
 
+	/* state machine for triggering unplug/replug */
+#define MMC_REPLUG_STATE_NONE	0		/* not doing unplug/replug */
+#define MMC_REPLUG_STATE_UNPLUG	1		/* do unplug next */
+#define MMC_REPLUG_STATE_PLUG	2		/* do plug next */
+	u8			trigger_replug_state;
+
 	struct mmc_card		*card;		/* device attached to this host */
 
 	wait_queue_head_t	wq;
@@ -527,7 +533,12 @@ int mmc_regulator_get_supply(struct mmc_host *mmc);
 
 static inline int mmc_card_is_removable(struct mmc_host *host)
 {
-	return !(host->caps & MMC_CAP_NONREMOVABLE);
+	/*
+	 * A non-removable card briefly looks removable if code has forced
+	 * a re-plug of the card.
+	 */
+	return host->trigger_replug_state != MMC_REPLUG_STATE_NONE ||
+		!(host->caps & MMC_CAP_NONREMOVABLE);
 }
 
 static inline int mmc_card_keep_power(struct mmc_host *host)
@@ -580,4 +591,6 @@ static inline enum dma_data_direction mmc_get_dma_dir(struct mmc_data *data)
 int mmc_send_tuning(struct mmc_host *host, u32 opcode, int *cmd_error);
 int mmc_abort_tuning(struct mmc_host *host, u32 opcode);
 
+void mmc_trigger_replug(struct mmc_host *host);
+
 #endif /* LINUX_MMC_HOST_H */
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index 5a177f7a83c3..0d6c73768ae3 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -173,4 +173,6 @@ extern void sdio_retune_crc_enable(struct sdio_func *func);
 extern void sdio_retune_hold_now(struct sdio_func *func);
 extern void sdio_retune_release(struct sdio_func *func);
 
+extern void sdio_trigger_replug(struct sdio_func *func);
+
 #endif /* LINUX_MMC_SDIO_FUNC_H */
-- 
2.22.0.657.g960e92d24f-goog

