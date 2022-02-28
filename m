Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CA24C69AC
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbiB1LKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbiB1LJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:09:41 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E266C900;
        Mon, 28 Feb 2022 03:09:00 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id a8so23987854ejc.8;
        Mon, 28 Feb 2022 03:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NwvvEiJPPM0SG7ZI4yc03tHRsjcGU4DYrm0+p7QW2+g=;
        b=XoHp2vZs5sXnnQm8jTsL06JwdjgH4Z1Am+qeboNHSyU/csHp7G8mKHTnYwT7vMJf3q
         1zZobpdX4BxBQ2erAJx74EzSCDXfVaAB33jAX9ZekfWtpz9xLL4KIzz7DciQBlIBY9DK
         vi6LJyw6u5UaEjT8CWPzRGPwv8GzX6oWgjgvygChKW8zu7PwVtsUQz/kuHu5rW/3vaBt
         P3mcu2gbh7uG62xQrliOtXiVl+brL2WoHfh7VHyAXnwazE3NNCXTKdQujGPQMoLCoB+H
         4TwL3ENhlSsI5tK0hgbUY+rfbxgFEyt/dohDr5V+g2PZ9mAGfyjh/75qZVaBOXbUEFp6
         QPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NwvvEiJPPM0SG7ZI4yc03tHRsjcGU4DYrm0+p7QW2+g=;
        b=2DYBv+XgrZiq8vdIB8XOJuShRv3BWJZy4qyNQvH19+SasqcIFAlU3BJiIuuV3A5uif
         ImNJUHWL44mUn/Rdrt/XZbWio1u5ffkWH1hvCC1Mmy4cSeBkhycCgovBzVtWye3h66Iq
         Tp3pqHtd4zkHZxwkrXiiAChkh7bqlUj7fZZU9RsV/5el4k8AKeQItmXaUxA7hDav/I/V
         RQuPL5+GHULGPpEk2vPk0qZ8HafSmQD/8aY1xXqSJzZnWftIgYCKGkCjO9TssYrYJHrK
         LEWWWhACFbBsl/n67CqmoKDZP+h8CHIDj+2hdjRmC6X1OicY1G7cnNnSkaMbxthGB5Hg
         Socw==
X-Gm-Message-State: AOAM531yeQkOI0e3hSuKLnvH02s/zKbGofneMFOTX8CPRKefvItXt3vL
        3LNKEgJ1BIzsX4BxtzP+yow=
X-Google-Smtp-Source: ABdhPJwx6JZK1Sd067eYUFaKDGIuHgaxlGXhzFGfLUQYCLtFq3NCzAqvSFrK3I6DGGTf6F+6FgXuew==
X-Received: by 2002:a17:906:2608:b0:6c9:b248:4dcf with SMTP id h8-20020a170906260800b006c9b2484dcfmr14572317ejc.320.1646046539415;
        Mon, 28 Feb 2022 03:08:59 -0800 (PST)
Received: from localhost.localdomain (dhcp-077-250-038-153.chello.nl. [77.250.38.153])
        by smtp.googlemail.com with ESMTPSA id z22-20020a17090655d600b006d229436793sm4209049ejp.223.2022.02.28.03.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 03:08:59 -0800 (PST)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakob Koschel <jakobkoschel@gmail.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd@arndb.de>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sgx@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        bcm-kernel-feedback-list@broadcom.com, linux-tegra@vger.kernel.org,
        linux-mediatek@lists.infradead.org, kvm@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        v9fs-developer@lists.sourceforge.net,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Subject: [PATCH 4/6] drivers: remove unnecessary use of list iterator variable
Date:   Mon, 28 Feb 2022 12:08:20 +0100
Message-Id: <20220228110822.491923-5-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228110822.491923-1-jakobkoschel@gmail.com>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When list_for_each_entry() completes the iteration over the whole list
without breaking the loop, the iterator value will *always* be a bogus
pointer computed based on the head element.

To avoid type confusion use the actual list head directly instead of last
iterator value.

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/dma/dw-edma/dw-edma-core.c             | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 3 ++-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c     | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index 468d1097a1ec..7883c4831857 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -136,7 +136,7 @@ static void dw_edma_free_burst(struct dw_edma_chunk *chunk)
 	}

 	/* Remove the list head */
-	kfree(child);
+	kfree(chunk->burst);
 	chunk->burst = NULL;
 }

@@ -156,7 +156,7 @@ static void dw_edma_free_chunk(struct dw_edma_desc *desc)
 	}

 	/* Remove the list head */
-	kfree(child);
+	kfree(desc->chunk);
 	desc->chunk = NULL;
 }

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 091f36adbbe1..c0ea9dbc4ff6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -3963,7 +3963,8 @@ static void __i40e_reprogram_flex_pit(struct i40e_pf *pf,
 	 * correctly, the hardware will disable flexible field parsing.
 	 */
 	if (!list_empty(flex_pit_list))
-		last_offset = list_prev_entry(entry, list)->src_offset + 1;
+		last_offset = list_entry(flex_pit_list->prev,
+					 struct i40e_flex_pit, list)->src_offset + 1;

 	for (; i < 3; i++, last_offset++) {
 		i40e_write_rx_ctl(&pf->hw,
diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index e3874421c4c0..cf5b05860799 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -104,7 +104,7 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 	 * it use list_for_each_entry_reverse to walk around the whole ep list.
 	 * Therefore assign this lowestpri_ep_dist after walk around the ep_list
 	 */
-	cred_info->lowestpri_ep_dist = cur_ep_dist->list;
+	cred_info->lowestpri_ep_dist = *ep_list;

 	WARN_ON(cred_info->cur_free_credits <= 0);

--
2.25.1

