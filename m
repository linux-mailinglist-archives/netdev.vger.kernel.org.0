Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55B26E441E
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjDQJjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjDQJjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:39:42 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DB26580
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:38:53 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-5050491cb04so3246822a12.0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681724332; x=1684316332;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+VAYy4x1VW7GQjpcDHqlJKO18XulsfdzrpJC5dPxENk=;
        b=LjVjCt2gIN1rmNUD/vSXgbPSctlygwjrGweJ37AJDnSFttvyNhHuwRi5DbJvWqocXi
         N37qEQn1VKexTWKEgQyC0o2epxzHVHnPfcSdjy43cWOApW1ahIDselKosxroyRdmF7di
         MlXy7wIwt34u9zgV9RKSJK5A/TqBjKBPW1i+kikEwFiRYWZK6AAWzrQGSC9eZpcgt7+v
         m8ThIuv7rbWgfb1yOsPV/H8srZ0TtXwnBcppD4chKTYyFx5jSlmNPzrZRkWnlYBOTK/P
         56hW7qI4J90HfvkcJTYVvltOIfZmcXi94mWu1+gW3vzJR5JYVeaMZttC5RuNyavQAWx1
         m2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681724332; x=1684316332;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+VAYy4x1VW7GQjpcDHqlJKO18XulsfdzrpJC5dPxENk=;
        b=XKhT3g3oLu8v+PHRW+XNB+Lc64QGtOjw/qgisxqEUQTbS5eESrbnNkyelrUlLGYobc
         i5s/waIDOJBhT5SYSt8wwNuT6qT7RaPsUT7ovk1d5hhCcMhnjQ82HOEN8Q537z1a8uy8
         BWCND65fDQrFFQxlZgVvqjnUvc3ZLn+R0K0ockJ0GDxOhjcgvwu0/bSsoCPmgIh13N9x
         Manzx1UvoMx6SL7zRtmRyW5pGH7ajA9x1i1/ubdpOoLg1LzBO8g+CCet96qG/zUYoMvY
         VPJeu/XXJOTTdF7HmHa1mmtOYYQnsoL59zDqC0DGoSRCRkvBZ0vV5DHjfUXtDW2i0UEZ
         +1Eg==
X-Gm-Message-State: AAQBX9cNg9xRqbEpElyUK/UjW3Tuvr4lxZBsm7PwYAB6AgOxj9w9qnID
        t97tutBN/osNvo0ieHmLpHA=
X-Google-Smtp-Source: AKy350bRFnwFpsvymQ2Qxke4LZ6yvhQRbtWbU0uJgqEyF/6glZL9ROnID6wU+iXGN1KyuVSVEJ/B+Q==
X-Received: by 2002:aa7:d593:0:b0:506:9984:9239 with SMTP id r19-20020aa7d593000000b0050699849239mr4033113edq.26.1681724331455;
        Mon, 17 Apr 2023 02:38:51 -0700 (PDT)
Received: from ?IPV6:2a01:c22:770d:1c00:59f1:1548:39fc:ccd5? (dynamic-2a01-0c22-770d-1c00-59f1-1548-39fc-ccd5.c22.pool.telefonica.de. [2a01:c22:770d:1c00:59f1:1548:39fc:ccd5])
        by smtp.googlemail.com with ESMTPSA id r12-20020a170906c28c00b0094f2f0c9ed9sm2956423ejz.167.2023.04.17.02.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 02:38:51 -0700 (PDT)
Message-ID: <0e7ad48c-d745-2b23-d529-79866702b6f9@gmail.com>
Date:   Mon, 17 Apr 2023 11:36:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH net-next v3 1/3] net: add macro netif_subqueue_completed_wake
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7147a001-3d9c-a48d-d398-a94c666aa65b@gmail.com>
In-Reply-To: <7147a001-3d9c-a48d-d398-a94c666aa65b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add netif_subqueue_completed_wake, complementing the subqueue versions
netif_subqueue_try_stop and netif_subqueue_maybe_stop.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
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

