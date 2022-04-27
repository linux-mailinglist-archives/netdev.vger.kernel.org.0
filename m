Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41106511952
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbiD0NRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbiD0NQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:16:53 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6980C13FB45;
        Wed, 27 Apr 2022 06:13:05 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id y3so3279448ejo.12;
        Wed, 27 Apr 2022 06:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NlU/QONh+3OgEOo0j9vDfo6n41G6nPiPw+elliblf1o=;
        b=IrpaxUeVWmf72Fxb1R/vcMFJjfRT1Nm5/qWGMo1x0oSbKvHuSi0fqf/ssfVBgfXSLh
         du/v1zhvw/bkeIeXKqpkq6Ex64ikXq1MvIIMJ0DbSHxrkdp/lUFW3qtJWTlAPuveEbr5
         FFAHo2SvbRGLGY0tmBRykZFahCavBW+bEgUlGA1IMw7NMeccXI6kXUAy4Vi6Hvw65CvA
         4n7ks3K4l7GicQqyYUz/uHKhiRhdNiiB+pdlejk5HnOX5WQc54n+80gRiVbZOKDphSK0
         48NoM4TfAY8jB0jdI2eBankAPSAzaQSgbafRGjaCPI9nX+1xtYLYhC5Oxb/UoAWsXTmx
         AbDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NlU/QONh+3OgEOo0j9vDfo6n41G6nPiPw+elliblf1o=;
        b=rSfzVnCd8bGXHNT8GKaZv5a18XrW2LihSXj2tqiuWXJn9xQuh+9LnVJCHkRA7XKk+2
         Nsnj4WZG/PU+4KbLvRI/xDpSIBJx5QnI312mZD+OhJhYdx/7Uqvb+RSYLo+hzyVxKawA
         isnxE/PpE/Xgeqv5Fjnus8/DeiY9V3jPBDx9OMzSBFbdzALDG1r30Fflq9IcrpDI2Uze
         wLdGrHDY8pNsjpb6dV82SQ0Dc2PBuUR1sXXyfyIlgfqjLSY32FZQ+5rf1VBgSMyB0Lw1
         azFz17a7US8g+3ksJduhNDJAhGU1nkU00cHnbsSsd46SzsfWnoikfZRKvF0ywNWYq2DK
         A4Jw==
X-Gm-Message-State: AOAM532LjaP3yKYxG67DYT9VRw1/BUccVFiw9Hoznytt2u71rFdSYCUI
        0a/L3US5bIrFGZIbO4TSYEk=
X-Google-Smtp-Source: ABdhPJx0hsr1/pmn3ZMOX1wfDXWyCzpRGltR2zMpVZ8TjoccGHja3Z+esSWJWHC5mnI+g4CnnXpsdg==
X-Received: by 2002:a17:907:6ea4:b0:6f3:87c8:21cc with SMTP id sh36-20020a1709076ea400b006f387c821ccmr17717258ejc.490.1651065183932;
        Wed, 27 Apr 2022 06:13:03 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906124600b006e843964f9asm6668987eja.55.2022.04.27.06.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 06:13:03 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [PATCH v2 4/5] Drivers: hv: vmbus: Accept hv_sock offers in isolated guests
Date:   Wed, 27 Apr 2022 15:12:24 +0200
Message-Id: <20220427131225.3785-5-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220427131225.3785-1-parri.andrea@gmail.com>
References: <20220427131225.3785-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So that isolated guests can communicate with the host via hv_sock
channels.

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/hv/channel_mgmt.c | 8 ++++++--
 include/linux/hyperv.h    | 8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 67be81208a2d9..d800220ee54f4 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -976,13 +976,17 @@ find_primary_channel_by_offer(const struct vmbus_channel_offer_channel *offer)
 	return channel;
 }
 
-static bool vmbus_is_valid_device(const guid_t *guid)
+static bool vmbus_is_valid_offer(const struct vmbus_channel_offer_channel *offer)
 {
+	const guid_t *guid = &offer->offer.if_type;
 	u16 i;
 
 	if (!hv_is_isolation_supported())
 		return true;
 
+	if (is_hvsock_offer(offer))
+		return true;
+
 	for (i = 0; i < ARRAY_SIZE(vmbus_devs); i++) {
 		if (guid_equal(guid, &vmbus_devs[i].guid))
 			return vmbus_devs[i].allowed_in_isolated;
@@ -1004,7 +1008,7 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 
 	trace_vmbus_onoffer(offer);
 
-	if (!vmbus_is_valid_device(&offer->offer.if_type)) {
+	if (!vmbus_is_valid_offer(offer)) {
 		pr_err_ratelimited("Invalid offer %d from the host supporting isolation\n",
 				   offer->child_relid);
 		atomic_dec(&vmbus_connection.offer_in_progress);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 55478a6810b60..1112c5cf894e6 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1044,10 +1044,14 @@ struct vmbus_channel {
 u64 vmbus_next_request_id(struct vmbus_channel *channel, u64 rqst_addr);
 u64 vmbus_request_addr(struct vmbus_channel *channel, u64 trans_id);
 
+static inline bool is_hvsock_offer(const struct vmbus_channel_offer_channel *o)
+{
+	return !!(o->offer.chn_flags & VMBUS_CHANNEL_TLNPI_PROVIDER_OFFER);
+}
+
 static inline bool is_hvsock_channel(const struct vmbus_channel *c)
 {
-	return !!(c->offermsg.offer.chn_flags &
-		  VMBUS_CHANNEL_TLNPI_PROVIDER_OFFER);
+	return is_hvsock_offer(&c->offermsg);
 }
 
 static inline bool is_sub_channel(const struct vmbus_channel *c)
-- 
2.25.1

