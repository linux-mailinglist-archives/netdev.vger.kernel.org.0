Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1D348B05
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbfFQR7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:59:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43820 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728659AbfFQR7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:59:03 -0400
Received: by mail-pl1-f196.google.com with SMTP id cl9so4384450plb.10
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=98n6ZHrDJ8hHttCLc1inB11JuSkBEgDS0TKJr/PR7Zk=;
        b=UHl6hfVqQlRSbLQZJ9rvEg3kuQ8N4tef3GpJjNmJtM6p3an8g41J0dxWGb8xG2DPrz
         sAjdwqZXvIdhtYJGTlOLwQuE4d+Rvu44G68oMRlSPqWf992mN+rdyePuTRXrON9+waW6
         AuJ82YWMK1XLGqcjLpUujx4vQnw2RvoqNjbO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=98n6ZHrDJ8hHttCLc1inB11JuSkBEgDS0TKJr/PR7Zk=;
        b=Me577sthJtqBo44+b3R7G+vFjSfQZY3mjwSBhpxPTlgvNAR/OBz3EUOftKluaoYsqM
         j1VvhKiQmE3FvKN2zZUPGuwYLSV4bpE8L/PoGv6RVdTvY2qjPpqdnL6WW0m4CwHaF/aO
         T29NEhhg7GdH8hYbQmfTsWf72CUOApUOAN0dQHx+g+HVg5Pcin117LIcP0L1SlMqZm0p
         TpvD7pZQL5EuC0C2P7TkOy9GIV6edPBpcvAxaB+5aTlY4C4fBZaCoW8RBdxPYFp3tIW0
         H76JHiaWebqzQGsQdD/W4JEt3WGLo3aiHzjiZFem7X2A03x1lYOpusrq+TEUaR87+NeG
         00NQ==
X-Gm-Message-State: APjAAAULLh1KO94cuRYKTJiufgpuMeUckF5CZR/ggPVfSRgMFkXwjZEF
        EFH6jgowDzaMtGi81WAtbO1+EQ==
X-Google-Smtp-Source: APXvYqxhK3GXMrgbsgnHN+m3eV/JC6yuo7bBQmIJ3YfzRrEjP9lcqXWS3vYT5HeqNxLLgFp/OooEMw==
X-Received: by 2002:a17:902:8f81:: with SMTP id z1mr42314084plo.290.1560794342357;
        Mon, 17 Jun 2019 10:59:02 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id q1sm15145809pfn.178.2019.06.17.10.58.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 10:58:59 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        linux-wireless@vger.kernel.org,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev@vger.kernel.org, brcm80211-dev-list@cypress.com,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org, Jiong Wu <lohengrin1024@gmail.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Allison Randal <allison@lohutok.net>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Avri Altman <avri.altman@wdc.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v5 2/5] mmc: core: API to temporarily disable retuning for SDIO CRC errors
Date:   Mon, 17 Jun 2019 10:56:50 -0700
Message-Id: <20190617175653.21756-3-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190617175653.21756-1-dianders@chromium.org>
References: <20190617175653.21756-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normally when the MMC core sees an "-EILSEQ" error returned by a host
controller then it will trigger a retuning of the card.  This is
generally a good idea.

However, if a command is expected to sometimes cause transfer errors
then these transfer errors shouldn't cause a re-tuning.  This
re-tuning will be a needless waste of time.  One example case where a
transfer is expected to cause errors is when transitioning between
idle (sometimes referred to as "sleep" in Broadcom code) and active
state on certain Broadcom WiFi SDIO cards.  Specifically if the card
was already transitioning between states when the command was sent it
could cause an error on the SDIO bus.

Let's add an API that the SDIO function drivers can call that will
temporarily disable the auto-tuning functionality.  Then we can add a
call to this in the Broadcom WiFi driver and any other driver that
might have similar needs.

NOTE: this makes the assumption that the card is already tuned well
enough that it's OK to disable the auto-retuning during one of these
error-prone situations.  Presumably the driver code performing the
error-prone transfer knows how to recover / retry from errors.  ...and
after we can get back to a state where transfers are no longer
error-prone then we can enable the auto-retuning again.  If we truly
find ourselves in a case where the card needs to be retuned sometimes
to handle one of these error-prone transfers then we can always try a
few transfers first without auto-retuning and then re-try with
auto-retuning if the first few fail.

Without this change on rk3288-veyron-minnie I periodically see this in
the logs of a machine just sitting there idle:
  dwmmc_rockchip ff0d0000.dwmmc: Successfully tuned phase to XYZ

Commit notes:
Patches #2 - #5 will go through Ulf's tree.
END

Fixes: bd11e8bd03ca ("mmc: core: Flag re-tuning is needed on CRC errors")
Cc: stable@vger.kernel.org
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
---

Changes in v5:
- Add missing sdio_retune_crc_enable() in comments (Ulf).
- /s/reneable/re-enable (Ulf).
- Remove leftover prototypes: mmc_expect_errors_begin() / end() (Ulf).

Changes in v4:
- Moved to SDIO API only (Adrian, Ulf).
- Renamed to make it less generic, now retune_crc_disable (Ulf).
- Function header makes it clear host must be claimed (Ulf).
- No more WARN_ON (Ulf).

Changes in v3:
- Took out the spinlock since I believe this is all in one context.

Changes in v2:
- Updated commit message to clarify based on discussion of v1.

 drivers/mmc/core/core.c       |  5 +++--
 drivers/mmc/core/sdio_io.c    | 37 +++++++++++++++++++++++++++++++++++
 include/linux/mmc/host.h      |  1 +
 include/linux/mmc/sdio_func.h |  3 +++
 4 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6db36dc870b5..9020cb2490f7 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -144,8 +144,9 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 	int err = cmd->error;
 
 	/* Flag re-tuning needed on CRC errors */
-	if ((cmd->opcode != MMC_SEND_TUNING_BLOCK &&
-	    cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200) &&
+	if (cmd->opcode != MMC_SEND_TUNING_BLOCK &&
+	    cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200 &&
+	    !host->retune_crc_disable &&
 	    (err == -EILSEQ || (mrq->sbc && mrq->sbc->error == -EILSEQ) ||
 	    (mrq->data && mrq->data->error == -EILSEQ) ||
 	    (mrq->stop && mrq->stop->error == -EILSEQ)))
diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index f79f0b0caab8..0acb1a29c968 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -734,3 +734,40 @@ int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sdio_set_host_pm_flags);
+
+/**
+ *	sdio_retune_crc_disable - temporarily disable retuning on CRC errors
+ *	@func: SDIO function attached to host
+ *
+ *	If the SDIO card is known to be in a state where it might produce
+ *	CRC errors on the bus in response to commands (like if we know it is
+ *	transitioning between power states), an SDIO function driver can
+ *	call this function to temporarily disable the SD/MMC core behavior of
+ *	triggering an automatic retuning.
+ *
+ *	This function should be called while the host is claimed and the host
+ *	should remain claimed until sdio_retune_crc_enable() is called.
+ *	Specifically, the expected sequence of calls is:
+ *	- sdio_claim_host()
+ *	- sdio_retune_crc_disable()
+ *	- some number of calls like sdio_writeb() and sdio_readb()
+ *	- sdio_retune_crc_enable()
+ *	- sdio_release_host()
+ */
+void sdio_retune_crc_disable(struct sdio_func *func)
+{
+	func->card->host->retune_crc_disable = true;
+}
+EXPORT_SYMBOL_GPL(sdio_retune_crc_disable);
+
+/**
+ *	sdio_retune_crc_enable - re-enable retuning on CRC errors
+ *	@func: SDIO function attached to host
+ *
+ *	This is the compement to sdio_retune_crc_disable().
+ */
+void sdio_retune_crc_enable(struct sdio_func *func)
+{
+	func->card->host->retune_crc_disable = false;
+}
+EXPORT_SYMBOL_GPL(sdio_retune_crc_enable);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 43d0f0c496f6..ecb7972e2423 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -398,6 +398,7 @@ struct mmc_host {
 	unsigned int		retune_now:1;	/* do re-tuning at next req */
 	unsigned int		retune_paused:1; /* re-tuning is temporarily disabled */
 	unsigned int		use_blk_mq:1;	/* use blk-mq */
+	unsigned int		retune_crc_disable:1; /* don't trigger retune upon crc */
 
 	int			rescan_disable;	/* disable card detection */
 	int			rescan_entered;	/* used with nonremovable devices */
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index e9dfdd501cd1..4820e6d09dac 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -167,4 +167,7 @@ extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
 extern mmc_pm_flag_t sdio_get_host_pm_caps(struct sdio_func *func);
 extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
 
+extern void sdio_retune_crc_disable(struct sdio_func *func);
+extern void sdio_retune_crc_enable(struct sdio_func *func);
+
 #endif /* LINUX_MMC_SDIO_FUNC_H */
-- 
2.22.0.410.gd8fdbe21b5-goog

