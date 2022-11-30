Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB3463E371
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiK3W2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiK3W2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:28:33 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E97C87CB4
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:28:32 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bx10so17333568wrb.0
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IGscC1rUWwmTgf/GwAQgW38qphQwkOXIg/FIfZskjKg=;
        b=bI85drhItddLA/cWnjA3uahNVT2RhEpp184gQT7URXkGtwERm12ABXi0Nkvfd9kOO5
         gzHfpT0TDaQV9FsgP5/s0g/DbFg+4mCU+efW4ODFv1IMDnwzKcbkt8ZPP6wfx//CMVde
         WK+xzyfrWzWShiMk6YX39AcQciAz0OQa6BirTV9b2PoqL4O733QSgDZM5vMOM0BLBeY2
         3MDAGkeyq/2yCeolnbSwO4QagnG7MXPFcnSpz5gb2LJSVpQtaC0CBhchjfBayt6UHPB2
         NHzVg9DbFvx4Ra5GrqSAyKGmdnFmcbG2vV8S/Q342hlavw0CdOeQRmp0TelYEX9dm3VL
         dYbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IGscC1rUWwmTgf/GwAQgW38qphQwkOXIg/FIfZskjKg=;
        b=gsOv1JHypC1Mpi4YVF73i8dWBF1E33rJNbWsA9nRGgfPX2pXyWk19UffgJU1UI1iTB
         BFO78C1fHBZPBM52B3fUPPnBd9bqPcpIyTc94RfIP8fN2WtQPgTGTJWqW9l82xUP0pAz
         LxRUKMw+1D80WtzaaumzgAjx/nTdhZTLmxyDM4ZJSf4cKO148o2cBYTWNL6xhjP3tpDb
         MOkE6yUwraKbvYp5clHjDOWBp4QHNq9Mwxn7axvNt13iJ7XSt3SStBgWrOS7CcbHdujI
         8ngoW/aLl0s2caztY4YZjCBhGDxMrP1QhcARUPGDFAE4CaWzvQCUqIu43tc7Gu9DyKu7
         htbQ==
X-Gm-Message-State: ANoB5pnPr+vQhVLZin2hSNhTIDtnfXuyE1x4jQ9lf83CpFvWf75QhKrM
        TtB/D82piDcYZpcYiU6W312N8+50J0k=
X-Google-Smtp-Source: AA0mqf5qZrp53WjcZeeLi0V11okdCWPA92CIu/frcEok9YvWRFzhMcfrUn6sPXvhz+C6hoUNQgviQw==
X-Received: by 2002:a5d:4301:0:b0:242:2572:cd98 with SMTP id h1-20020a5d4301000000b002422572cd98mr5626813wrq.522.1669847310249;
        Wed, 30 Nov 2022 14:28:30 -0800 (PST)
Received: from ?IPV6:2a01:c22:77d6:e700:1465:fbc6:a2a6:9b65? (dynamic-2a01-0c22-77d6-e700-1465-fbc6-a2a6-9b65.c22.pool.telefonica.de. [2a01:c22:77d6:e700:1465:fbc6:a2a6:9b65])
        by smtp.googlemail.com with ESMTPSA id y5-20020a056000108500b00241d544c9b1sm3094533wrw.90.2022.11.30.14.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 14:28:29 -0800 (PST)
Message-ID: <783fca17-450f-c69f-46dc-8ed7394be03d@gmail.com>
Date:   Wed, 30 Nov 2022 23:28:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: [PATCH net-next 1/2] net: add netdev_sw_irq_coalesce_default_on()
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e4d1cc88-2064-caa0-c786-41f8720869a4@gmail.com>
In-Reply-To: <e4d1cc88-2064-caa0-c786-41f8720869a4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper for drivers wanting to set SW IRQ coalescing
by default. The related sysfs attributes can be used to
override the default values.

Follow Jakub's suggestion and put this functionality into
net core so that drivers wanting to use software interrupt
coalescing per default don't have to open-code it.

Note that this function needs to be called before the
netdevice is registered.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 02a2318da..5be4b6a3b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -78,6 +78,7 @@ struct xdp_buff;
 void synchronize_net(void);
 void netdev_set_default_ethtool_ops(struct net_device *dev,
 				    const struct ethtool_ops *ops);
+void netdev_sw_irq_coalesce_default_on(struct net_device *dev);
 
 /* Backlog congestion levels */
 #define NET_RX_SUCCESS		0	/* keep 'em coming, baby */
diff --git a/net/core/dev.c b/net/core/dev.c
index 117e830ca..cc6bbc0a3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10537,6 +10537,22 @@ void netdev_set_default_ethtool_ops(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(netdev_set_default_ethtool_ops);
 
+/**
+ * netdev_sw_irq_coalesce_default_on() - enable SW IRQ coalescing by default
+ * @dev: netdev to enable the IRQ coalescing on
+ *
+ * Sets a conservative default for SW IRQ coalescing. Users can use
+ * sysfs attributes to override the default values.
+ */
+void netdev_sw_irq_coalesce_default_on(struct net_device *dev)
+{
+	WARN_ON(dev->reg_state == NETREG_REGISTERED);
+
+	dev->gro_flush_timeout = 20000;
+	dev->napi_defer_hard_irqs = 1;
+}
+EXPORT_SYMBOL_GPL(netdev_sw_irq_coalesce_default_on);
+
 void netdev_freemem(struct net_device *dev)
 {
 	char *addr = (char *)dev - dev->padded;
-- 
2.38.1


