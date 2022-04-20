Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EA8509125
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382069AbiDTUKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382043AbiDTUKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:10:40 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E9947047;
        Wed, 20 Apr 2022 13:07:50 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ks6so5827811ejb.1;
        Wed, 20 Apr 2022 13:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gqny/vtMMTZYJnMuIZbRZTkwYXwooOfkrPfqMnie+pg=;
        b=RoRN/H4aK8ddwxHumTI6VWwDp2gXNMIkho/pNo6w8BIqPI5pub97EksV82dB1yjqAe
         wgGIHXgAVdiaBZyuWjdqSRoh8GB5+2J6ID/gp0SSudXi3aXki53J2khC+IeiEzz7OdBy
         oOitUxPNa9i5Zg/RAoQd0wwxDSy8OhP8kxBRUemC6g7lNRjcnhYoQHGNwXIsHJd0uymm
         Eq2SlCWgeiHI6oiBhIP99UP+tyYBwJMnzXELixpPQY2+UsStIVw8qVHPEsmnyXXuZ32w
         eBtVUu1huG85Y10uGoKF1/ImvP6cxJQGx28HZw5CMxltNaBsw+CD41n30Md41zFbZHEE
         OU0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gqny/vtMMTZYJnMuIZbRZTkwYXwooOfkrPfqMnie+pg=;
        b=wx3hqV8C3mj5KZ8ziV/RsmCpBBJMKEjHyUZ/mk2nJrIsBLCpwn1l/pbg6Cb3zPbxSk
         5pWx/jQdxi9/efT7gOH+jEp4qcEIuH99bjn1QkaIucOCvkDFzAMN+PYj+xqHcwNWYyNY
         NRx6EPNwC+3/flbBqC0R+9ylnkMhFaqR1a6Mz3BsEpcmsvxspUU9/onxAK7CrCNlK+fk
         aQHxQratJjchTAg7c1kCP7wcrHTcQ++i1cz5Q/0sjMcQSgqqtqzFp/ZKr4NL7GYR8ftJ
         tASISkAw8zRMsGjPP1CflQkO3fiH3GotxFn8QKtZZZ3AwAxsrEuoP1IScRpc//Rw+mOi
         Dl/Q==
X-Gm-Message-State: AOAM530c6URuHZfZio8LZzT7bzj/qHT1w2yB30mrclE4tQg0J140Ib4F
        uBxSOLK76RDC1iQZwdvqsXk=
X-Google-Smtp-Source: ABdhPJyZkdpK/O7qghqShfdT23WGzRmhcv73TTRaVeeq0UBB1njFxL6qqyF7N5cv3558WjxMZZlcLw==
X-Received: by 2002:a17:907:168a:b0:6df:ad44:3009 with SMTP id hc10-20020a170907168a00b006dfad443009mr20298321ejc.176.1650485268654;
        Wed, 20 Apr 2022 13:07:48 -0700 (PDT)
Received: from anparri.mshome.net (host-82-53-3-95.retail.telecomitalia.it. [82.53.3.95])
        by smtp.gmail.com with ESMTPSA id gy10-20020a170906f24a00b006e894144707sm7126853ejb.53.2022.04.20.13.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 13:07:48 -0700 (PDT)
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
Subject: [PATCH 4/5] Drivers: hv: vmbus: Accept hv_sock offers in isolated guests
Date:   Wed, 20 Apr 2022 22:07:19 +0200
Message-Id: <20220420200720.434717-5-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220420200720.434717-1-parri.andrea@gmail.com>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
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

