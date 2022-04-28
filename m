Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3725051375D
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348598AbiD1Oyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiD1Oyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:54:50 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9B85C844;
        Thu, 28 Apr 2022 07:51:35 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r13so10083167ejd.5;
        Thu, 28 Apr 2022 07:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=emDG9f3LFc4UN/7AhW/W0+ckar3Ug+oqa5fA2UJ5tjg=;
        b=JndLe74SQfBVIJ2WpPhe5Wbx5xE7RqcorW45jPQ8Q3RK8izOuZ62/BUTNkGDR4Y0cM
         b9/D2ZWzWTr9AZVJnvuVlEc7hv0Anzjx0aYJNeBEsKU9DyLEBwQsudDz22hdve+EBNeS
         9u3K3IBOvAsvYy5l5UEMQ4fzq5BZnaIUIv7vN8HX4fZIZqjAFHxgxDtb3FKLvo92HeLe
         pbpURa1z9zZbU8npF5Ni22aBAo0HCT6kBsfyg5tavA23gelCR0yWrcl2akRSmZv3BTkm
         cATdUwRQAibEt08Rq7JDIHnloAkK6wJ2jGKolJLbZhugt7KFeCilUCLAW7TfW8y5sdCy
         XdCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=emDG9f3LFc4UN/7AhW/W0+ckar3Ug+oqa5fA2UJ5tjg=;
        b=mDKWQekC3nGvOez4uSwq37aFQ08PYNqocCjQEuzDwQnTg+JShfg5RhpOUNipoCWDLm
         DAJULZsAzR/HKEnlgF1hYH+Mdfu8Ufm+iv1q6LdQanEdpo9kobPAXpqF6g/p7EWhXpmx
         9EST2gXH7h3YQLzSqZ/u9h4Dy6NLC4JAKdPQQqbk925DvgieXDBoZZZi+n5W2neqZ8U4
         PiFoZSafOYbJVrcoKdQGsZYJg2oiBAkdOdPesBmfOY1T37pnzeBT/PqEtVLel7kn3CEZ
         QOxPW0vWI3XG9CHCiRtIKwOguUZk6qeCXrNppdQPCQimDdqR3oZEj89UZduP3nBRZglo
         hmjQ==
X-Gm-Message-State: AOAM53124AYlDIpn5kRxnhNT4qPecBzRWhnBlLN5Q0/KDTdO8e6OVZDf
        8Ra2oSibr9Mf1p/PjxPTlU0=
X-Google-Smtp-Source: ABdhPJwHp94hcTTfBsMBV3fZO22PEKNX1A9156t3tyfdZ8cjd1oOUTGNvy8rd3aUXXz+KLsR0mFWfA==
X-Received: by 2002:a17:907:9622:b0:6f3:9797:8eaf with SMTP id gb34-20020a170907962200b006f397978eafmr20337071ejc.96.1651157494095;
        Thu, 28 Apr 2022 07:51:34 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id x18-20020a170906b09200b006e8baac3a09sm61616ejy.157.2022.04.28.07.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:51:33 -0700 (PDT)
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
Subject: [PATCH hyperv-next v2 4/5] Drivers: hv: vmbus: Accept hv_sock offers in isolated guests
Date:   Thu, 28 Apr 2022 16:51:06 +0200
Message-Id: <20220428145107.7878-5-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220428145107.7878-1-parri.andrea@gmail.com>
References: <20220428145107.7878-1-parri.andrea@gmail.com>
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
index 50fea31f019f6..0db1b775e0139 100644
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
index a01c9fd0a3348..b028905d8334e 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1064,10 +1064,14 @@ u64 vmbus_request_addr_match(struct vmbus_channel *channel, u64 trans_id,
 			     u64 rqst_addr);
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

