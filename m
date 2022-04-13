Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C10500033
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238694AbiDMUu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237637AbiDMUui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:50:38 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530D87664C;
        Wed, 13 Apr 2022 13:48:10 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id r13so6364938ejd.5;
        Wed, 13 Apr 2022 13:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ERngG/+UkX04UrTeyi1yRhI11saChXCJ4vIv5MaGog8=;
        b=TLhjxCHZNdk3pY77Gef51LCa+6ZR8fEoPlSLGxjBCvnCWZmjnqZKTvfNLy94sqP3pX
         X7C/QWHfSIwPBTmKgpcxbZLp3UUCezCGIbz4vPFKo7u8vPjELC5DRMchF4ZSg7/B768U
         /5u7JmSh09QNZ+/TF+8KQgwlvv3YjHDwgIN20IWYqdB3MiKTVsK6OrQ8ivjb0IpJtY83
         rkAyFYbLpSeUZvThk44Py2+o0LWHCcz3SP8xXbIsl6qGM0AkKkNoVTbTI/6c7Poqok5M
         lXK7AWllhfC9RxFaT7LYP+xB7U+TXsQkktDyIffO0GPvlCgokuKxgwOy+PWCPKNREaOB
         GM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ERngG/+UkX04UrTeyi1yRhI11saChXCJ4vIv5MaGog8=;
        b=3HLrUxZPKnFOvS7zmT6FDEbze4VOc6vW/J5hTTn8b6cP3i4Sm4j1qRXa8IqwHQWABr
         eMDwGlnUKKxlXUYuVBDwAfpTUKTMmpZsqZ7j++bMWburCvc3jk8YzyyRLbMEHV37awmY
         j/CcyNfhjaz1g0adUwwLkkJxgCW6Vcr9x4ZbPtYFyg3XS78RrpHsdSFAkR1pW03hJGLi
         RN8bIjEKVDTywnGUmIFGrPxxt90oM87hlI/QhT7MYBp82FnbydJpPMvJMguCcFNTdxqp
         7Z8KESNhAwMmfwDL1se3BUnub+YW92ZlKvZwTo4h4LpUUHSnn2vGlVb4MjHXHuIpspRf
         hgMg==
X-Gm-Message-State: AOAM532OVhw91uX9GVRvSyJ/n70TBkfra1TFJwRuXg4yRpciKpbIMnVa
        45Ec0zmhq28mt5dUUP77aDE=
X-Google-Smtp-Source: ABdhPJzGPZHll4Do/+ggPuEu9rE4IzOA7R2SMrNiSYNqGF80JAmYhYMXTGAHWAY5oKo/eWNvYRU3lA==
X-Received: by 2002:a17:906:c092:b0:6ce:1018:9f4e with SMTP id f18-20020a170906c09200b006ce10189f4emr40702210ejz.430.1649882888829;
        Wed, 13 Apr 2022 13:48:08 -0700 (PDT)
Received: from anparri.mshome.net (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906408600b006e87d654270sm5021ejj.44.2022.04.13.13.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 13:48:08 -0700 (PDT)
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
Subject: [RFC PATCH 5/6] Drivers: hv: vmbus: Accept hv_sock offers in isolated guests
Date:   Wed, 13 Apr 2022 22:47:41 +0200
Message-Id: <20220413204742.5539-6-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413204742.5539-1-parri.andrea@gmail.com>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
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

So that isolated guests can communicate with the host via hv_sock
channels.

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
---
 drivers/hv/channel_mgmt.c | 9 +++++++--
 include/linux/hyperv.h    | 8 ++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 67be81208a2d9..83d7ab90b7305 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -976,17 +976,22 @@ find_primary_channel_by_offer(const struct vmbus_channel_offer_channel *offer)
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
 	}
+
 	return false;
 }
 
@@ -1004,7 +1009,7 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 
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

