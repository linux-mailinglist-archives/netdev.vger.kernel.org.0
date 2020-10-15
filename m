Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97FB28F633
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389887AbgJOPvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389852AbgJOPve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 11:51:34 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6481C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:51:32 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id md26so4307442ejb.10
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vAR035LoWI6oVGxH2cka+EBnHGrsQFbXd6TPtqudK28=;
        b=uF9g4Ud3NUWZbXqZq0g6hZ8ZmODxs9kjULYfFouB1a90R7LUxfa1cAAlRI5COKzxg5
         sFBk3bvsgk9htCwzTsoNNXav5MGQOO+S0+jq3gD71mjCk80b4nX3ySiBkcooDqCQ9Rh0
         cUNPaxuKu2NhboDA6Pa5YzuBfq6sE2p0OJUNjqfsaeeg7Nvf6pkDCXRSQPEjMhxtnyED
         Y9rVWPc51hYOPZbILwNeVhpC90KlYgi2hp8ZkhlTc1D/xps0l14gyUFph0sTGZuI0rHc
         7fYPHcsn7QdB+cuhe6hxCxom9kVFPzb5PTkIEYqvzzRS/zokk9cMTmRRDkCphBQU+3rz
         Larg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vAR035LoWI6oVGxH2cka+EBnHGrsQFbXd6TPtqudK28=;
        b=cXJ37nN/cXc8cDoWg02atpuKYoyZotjkUMFCT70+GpwHmCzufWZzE6IbX2C3JpKuSI
         oUjBmkBEwpzA7OTuTJsZFrnvh9YFrK2VOX9BS8lnAhM7seLENSj9M59PhlBV3l+LeYhx
         a/yqQsSFiFb/fXQDB2mQKnAKKHjQL7jsSfQqh0G6tQdeuC4hlUcIk8tLjhSDUhhvz2kC
         9q9QoLoIrwvozCSrQvfg+NeLb1jWvE0hnt8qDAcqTCKSiFnJlFwPl3kcIk27qIW5GZhF
         9Az+FruU0oh4o9tJdBjDq4TbIF5D5V+l2wS+5h+l03jZpdK66M8AlQKGhdnS/sqMybfv
         YQBQ==
X-Gm-Message-State: AOAM531JUThi+HU4nZPRhdaXVzQJuP3bT/NXTaBctxFSPYhRinWRPXrz
        7x4xiWKvE8cRTE0QEtCixEQVz/rJVAM=
X-Google-Smtp-Source: ABdhPJxpooECDK7H9bFbJAWDHZZxkQ6TypGji3r99STHSyot6+uyOtEThOlRxAw+WUvpXU+oDBjkSQ==
X-Received: by 2002:a17:906:6805:: with SMTP id k5mr5348403ejr.79.1602777091362;
        Thu, 15 Oct 2020 08:51:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:c92:1571:ee2d:f2ef? (p200300ea8f2328000c921571ee2df2ef.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c92:1571:ee2d:f2ef])
        by smtp.googlemail.com with ESMTPSA id d7sm1850465edu.46.2020.10.15.08.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 08:51:30 -0700 (PDT)
Subject: [PATCH net-next 2/4] net: core: add devm_netdev_alloc_pcpu_stats
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e25761cc-60c2-92fe-f7df-b8c55cf12ec7@gmail.com>
Message-ID: <1c618e2d-049c-7dfa-0f82-5f32fa4e9322@gmail.com>
Date:   Thu, 15 Oct 2020 17:49:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <e25761cc-60c2-92fe-f7df-b8c55cf12ec7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a managed version of netdev_alloc_pcpu_stats, e.g. for allocating
the per-cpu stats in the probe() callback of a driver. It needs to be
a macro for dealing properly with the type argument.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/netdevice.h | 15 +++++++++++++++
 net/devres.c              |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 568fab708..f5f41c160 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2596,6 +2596,21 @@ static inline void dev_lstats_add(struct net_device *dev, unsigned int len)
 #define netdev_alloc_pcpu_stats(type)					\
 	__netdev_alloc_pcpu_stats(type, GFP_KERNEL)
 
+void devm_free_pcpu_stats(void *data);
+
+#define devm_netdev_alloc_pcpu_stats(dev, type)				\
+({									\
+	typeof(type) __percpu *pcpu_stats = netdev_alloc_pcpu_stats(type); \
+	if (pcpu_stats) {						\
+		int rc = devm_add_action_or_reset(dev,			\
+					devm_free_pcpu_stats,		\
+					(__force void *)pcpu_stats);	\
+		if (rc)							\
+			pcpu_stats = NULL;				\
+	}								\
+	pcpu_stats;							\
+})
+
 enum netdev_lag_tx_type {
 	NETDEV_LAG_TX_TYPE_UNKNOWN,
 	NETDEV_LAG_TX_TYPE_RANDOM,
diff --git a/net/devres.c b/net/devres.c
index 1f9be2133..0d6545946 100644
--- a/net/devres.c
+++ b/net/devres.c
@@ -93,3 +93,9 @@ int devm_register_netdev(struct device *dev, struct net_device *ndev)
 	return 0;
 }
 EXPORT_SYMBOL(devm_register_netdev);
+
+void devm_free_pcpu_stats(void *data)
+{
+	free_percpu((__force void __percpu *)data);
+}
+EXPORT_SYMBOL_GPL(devm_free_pcpu_stats);
-- 
2.28.0


