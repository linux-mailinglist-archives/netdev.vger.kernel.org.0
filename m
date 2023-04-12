Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FBD6E00C5
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjDLVZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjDLVZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:25:14 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039DE8E
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 14:25:14 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l26-20020a05600c1d1a00b003edd24054e0so8860418wms.4
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 14:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681334712; x=1683926712;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2q0HQIUhPWAzcQCkg0eTFX++gXWvkSpk9XcUgGpc4nU=;
        b=o7oQoN7pWJs7xNWpaAWSyDe5C3K/r5c+wn3JT5zK+g4AWnKf/GixuIf4kolYxlMJDx
         4A9LnZiL0jitZe52zOak1fmTtSLTgrR5Tyg503yC7ZIzAgz3GqMYSPHcSBSPOLybp25n
         +F6Aq5yvZiMv9ZWAiiIiyCx+ycW0D/Ym0yk6d5PBewLpWQmxDDwgsnqfDmZPPn1Bhab5
         JSqVp2vRjE9O7qGBCITe6i8+zr9YpCShrI6ZtpZbW73jkMvBj0w0n91s4kzB0UP7JFC+
         t4CuVSVKXNo4swNV4C4Ro1Rb/hq9H38M9wFB5INDEIkSMNdQzOcXZP83n3eVPUJ3UWty
         izrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681334712; x=1683926712;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2q0HQIUhPWAzcQCkg0eTFX++gXWvkSpk9XcUgGpc4nU=;
        b=FFjbTeD4ICoYeBxu1F65zTy/mvnfj5/GqyyPPE3TR9GsYcm6revKrGu1BqsvUYn10C
         HDiUzYI/QWLB0u2pwPcJc4E2VhM6vYXIElfHKYivMqpciUg1UsdD4rUXKps8n6z68CxJ
         MnN9mOui1QGwbY5kBisFOrZB3OSvJXkN6fXpW5bKTmwe9Vv2cb5QAxVxLAMxhy2Ax8FE
         Tn8VIubnm7eb0YCfY4RMYdwVBin/xxVu98F1NmMgvf3cQtdW93jgetBn7fRd9raYQsJ1
         cusBUMd3v5VrUndkFpGvFkNuGWpN7K51shmq6YOAOXRxp26EtBUqY4KqT705L659qWEA
         upng==
X-Gm-Message-State: AAQBX9dFcYH8U/0ah4SQfas14CYqVMP1QLWomr9BQQFm2eHwzK9gYdXo
        4xjOAtt55N1+mcTOB4z2VFs=
X-Google-Smtp-Source: AKy350YnJQcQZG/u9ef6UzGNgBp2kblsrfA3aIgkTKKgsBU+C5Rx1rVk6/C3U1zuGmOxTELbsbaF2g==
X-Received: by 2002:a05:600c:3784:b0:3f0:4428:9432 with SMTP id o4-20020a05600c378400b003f044289432mr86744wmr.26.1681334712292;
        Wed, 12 Apr 2023 14:25:12 -0700 (PDT)
Received: from ?IPV6:2a02:3100:903d:3d00:b0e7:6bd7:f613:784b? (dynamic-2a02-3100-903d-3d00-b0e7-6bd7-f613-784b.310.pool.telefonica.de. [2a02:3100:903d:3d00:b0e7:6bd7:f613:784b])
        by smtp.googlemail.com with ESMTPSA id m13-20020a056000180d00b002efac42ff35sm15905798wrh.37.2023.04.12.14.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 14:25:11 -0700 (PDT)
Message-ID: <61877868-4fb7-4b9a-fd0d-41da1d9149b4@gmail.com>
Date:   Wed, 12 Apr 2023 23:25:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: add macro netif_subqueue_completed_wake
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

Add netif_subqueue_completed_wake, complementing the subqueue versions
netif_subqueue_try_stop and netif_subqueue_maybe_stop.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/net/netdev_queues.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index b26fdb441..d68b0a483 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -160,4 +160,14 @@ netdev_txq_completed_mb(struct netdev_queue *dev_queue,
 		netif_txq_maybe_stop(txq, get_desc, stop_thrs, start_thrs); \
 	})
 
+#define netif_subqueue_completed_wake(dev, idx, pkts, bytes,		\
+				      get_desc, start_thrs)		\
+	({								\
+		struct netdev_queue *txq;				\
+									\
+		txq = netdev_get_tx_queue(dev, idx);			\
+		netif_txq_completed_wake(txq, pkts, bytes,		\
+					 get_desc, start_thrs);		\
+	})
+
 #endif
-- 
2.40.0

