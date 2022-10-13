Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F285FE5EF
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 01:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJMXn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 19:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJMXny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 19:43:54 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF1D18C420;
        Thu, 13 Oct 2022 16:43:53 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id i9so2334046qvo.0;
        Thu, 13 Oct 2022 16:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQAqY2iBEAF+eHjrg4p1Q7JBNhxxMmTUjqoLxsrSWas=;
        b=aznCgpDPTh35a7GcoUgO1SyOcJ08mbe2AMMouLB+ymCrGnO2LK3l8RLG3Jne2HwKem
         1/EH6fj8XeH6BqxSWclUUusYc5WaTd5wmEuEM49rJn7XVnpdRilUcejawkOQjCNmnZHz
         9KC7VTcXx5o+tBja51juWpavfI1qptDviM/Ou73nCyTX0hCjyB6feboCr+cpJoMcAhkz
         qQORGbNEF+sHddZd+7+JBDHLZqIa5KcWJbX6sx4oEwnaG1u9xQfWRYy4ksKQojazOoNj
         Wx5RQpVA8NEPqY3DCghc4Gvo/gBVUv6dqDy3kcptztvxORbtJxF8yuS5bSjBeWaAh09e
         rrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQAqY2iBEAF+eHjrg4p1Q7JBNhxxMmTUjqoLxsrSWas=;
        b=RvICdhfPbh78lYX0FoHuvPV9aqrSyxpSCnPnyvnGPMYKAV3fUF45/XlUAxuq+X8r2e
         7IJ93s2AWuyNeinT37v9vXOz5fVjZkGu/0SCkTRu/2rx9HVEj6HRJ3+pHuYNvSo+0sjX
         bxcl+IwbFN1i/UMMLcy9aTnVV4u+RTraQ51Cawr9h7yxFC5ALM2ag0+jrNNkyUdPSHWo
         azYjYa2gHtYZBwmLVP3SZWSx1++3t6dVVsxxweNlK7NGcPPSONtpxeCBwDGf7HSnjE9n
         6D8u18Uork4T+WAAFN7czIsT/Qt77310v9e/cVMozBcE0cL0X4sTF+fqrU2GAKZ5q760
         7F3w==
X-Gm-Message-State: ACrzQf35CinxiFQbCXQeivHeyiD1grORRMUHlBv5aBbeooUSf/rP6l2m
        H8kD0N+RPbiIDztDCYOjk2y9M9N4RNI=
X-Google-Smtp-Source: AMsMyM5d0WGLq0eD43VmHqzvR93znPmQAN53P+QMH2r28rkhP4ZajzhlpCUfzcCBQUyeg2enRskVzw==
X-Received: by 2002:a05:6214:1c47:b0:4b1:8ee7:9fb0 with SMTP id if7-20020a0562141c4700b004b18ee79fb0mr2228838qvb.42.1665704632492;
        Thu, 13 Oct 2022 16:43:52 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:ec49:7545:4026:a70a])
        by smtp.gmail.com with ESMTPSA id y11-20020ac8524b000000b0039bde72b14asm876687qtn.92.2022.10.13.16.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 16:43:52 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] net: merge XPS_CPU_DEV_MAPS_SIZE and XPS_RXQ_DEV_MAPS_SIZE macros
Date:   Thu, 13 Oct 2022 16:43:46 -0700
Message-Id: <20221013234349.1165689-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221013234349.1165689-1-yury.norov@gmail.com>
References: <20221013234349.1165689-1-yury.norov@gmail.com>
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

The macros are used in a single place, and merging them
would simplify the code.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/netdevice.h | 7 ++-----
 net/core/dev.c            | 3 +--
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a36edb0ec199..53d738f66159 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -825,11 +825,8 @@ struct xps_dev_maps {
 	struct xps_map __rcu *attr_map[]; /* Either CPUs map or RXQs map */
 };
 
-#define XPS_CPU_DEV_MAPS_SIZE(_tcs) (sizeof(struct xps_dev_maps) +	\
-	(nr_cpu_ids * (_tcs) * sizeof(struct xps_map *)))
-
-#define XPS_RXQ_DEV_MAPS_SIZE(_tcs, _rxqs) (sizeof(struct xps_dev_maps) +\
-	(_rxqs * (_tcs) * sizeof(struct xps_map *)))
+#define XPS_DEV_MAPS_SIZE(_tcs, nr) (sizeof(struct xps_dev_maps) +\
+	((nr) * (_tcs) * sizeof(struct xps_map *)))
 
 #endif /* CONFIG_XPS */
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 70fa12c6551c..9dc6fcb0d48a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2564,15 +2564,14 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	}
 
 	if (type == XPS_RXQS) {
-		maps_sz = XPS_RXQ_DEV_MAPS_SIZE(num_tc, dev->num_rx_queues);
 		nr_ids = dev->num_rx_queues;
 	} else {
-		maps_sz = XPS_CPU_DEV_MAPS_SIZE(num_tc);
 		if (num_possible_cpus() > 1)
 			online_mask = cpumask_bits(cpu_online_mask);
 		nr_ids = nr_cpu_ids;
 	}
 
+	maps_sz = XPS_DEV_MAPS_SIZE(num_tc, nr_ids);
 	if (maps_sz < L1_CACHE_BYTES)
 		maps_sz = L1_CACHE_BYTES;
 
-- 
2.34.1

