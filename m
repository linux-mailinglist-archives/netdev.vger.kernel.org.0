Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD1B53B4E0
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 10:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiFBITx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 04:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiFBITw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 04:19:52 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E6DC15;
        Thu,  2 Jun 2022 01:19:51 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id g25so4436474ljm.2;
        Thu, 02 Jun 2022 01:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wgIZR7dvI9d7yKsWI61xGA/OPJcvvRD4X0FBHSe3Sfk=;
        b=Pg54oRUAqhJdc4T3bRYGpCzdjKqgEqDn2MLsyuNCWVEPwaewweQz4mmy5Qg9NhGEPe
         SSJ2IJ8ZgzhsL8EegHcWGTuLM0jKcnY4WCne3PDWRmjiZ9TJ6oLpWL3P4JiG8UzbxgRm
         kBylYcazGJeuVDIEojcf/na17ZGtmFyGxqOoaa3ZawreuAMkS/kTJeMi5qtWPaEeGPen
         678L0uzIOVPJ8CFOOeJqr70oFzxq1k23mBCn8zL/VFtZOfsS0fJadqB4nESw4FPWuhp5
         OzFBcZFItn+K7xcPMQzhm3qVjWlq0v5VJJ0eWAJJu5ZNbnftykcK0plzyTi/4FzZyHG5
         kEww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wgIZR7dvI9d7yKsWI61xGA/OPJcvvRD4X0FBHSe3Sfk=;
        b=QSftVSTZMn8zMTDhZTH33CdW+Fg5l3qrbfInPU26ugWCiQlCZW8NvwUwdb7LIm6rgD
         YjX9QHiuxutAAEq2CXLLbPdqoEAvUlNmOArdniSU3h/a9IJqFXS/Qo9sOXMttXR+nHaO
         eKUDzW9eHj6i4QPTcvtiNDPWyGQ5dEcQjMuf737idcDNuoKPyL6YFn0rXcAqiQAEcTOJ
         inFd5FNM9TkzHY808QNQ7Ifz9j+DvO5FJrvMZ/1uxeOTlhQTHP6j1g/pvAvBlKoBo/B9
         nR+5u35vUQfbJxKRSdxmkk7OckzmCg7N4vQrA0IZhvXsR+uc51G5QyR1DZO4O96v9guc
         50Dg==
X-Gm-Message-State: AOAM532UY30JT4zllFCCviCXRfT+Do9ZAxGgXIMQeRRbaMC/m/UHPd+y
        bGFLi+HF7hCVupxrmsaq7ck=
X-Google-Smtp-Source: ABdhPJwDGAb+Zq72WAJKKAG6b45ubLRipgsdl7M5Xhp3ys/FBwq/sVTMIncqljv7PvZaoIyeNrkq2g==
X-Received: by 2002:a2e:bc13:0:b0:253:e72a:aa2f with SMTP id b19-20020a2ebc13000000b00253e72aaa2fmr32550928ljf.390.1654157989975;
        Thu, 02 Jun 2022 01:19:49 -0700 (PDT)
Received: from PC-752.milrem.lan (87-119-163-145.tll.elisa.ee. [87.119.163.145])
        by smtp.gmail.com with ESMTPSA id y2-20020a056512044200b0047255d2117csm896132lfk.171.2022.06.02.01.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 01:19:49 -0700 (PDT)
From:   =?UTF-8?q?Kaarel=20P=C3=A4rtel?= <kaarelp2rtel@gmail.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Kaarel=20P=C3=A4rtel?= <kaarelp2rtel@gmail.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: add operstate for vcan and dummy
Date:   Thu,  2 Jun 2022 11:19:29 +0300
Message-Id: <20220602081929.21929-1-kaarelp2rtel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The idea here is simple. The vcan and the dummy network devices
currently do not set the operational state of the interface.
The result is that the interface state will be UNKNOWN.

The kernel considers the unknown state to be the same as up:
https://elixir.bootlin.com/linux/latest/source/include/linux/netdevice.h#L4125

However for users this creates confusion:
https://serverfault.com/questions/629676/dummy-network-interface-in-linux

The change in this patch is very simple. When the interface is set up, the
operational state is set to IF_OPER_UP.

Signed-off-by: Kaarel Pärtel <kaarelp2rtel@gmail.com>
---
 drivers/net/can/vcan.c | 1 +
 drivers/net/dummy.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/can/vcan.c b/drivers/net/can/vcan.c
index a15619d883ec..79768f9d4294 100644
--- a/drivers/net/can/vcan.c
+++ b/drivers/net/can/vcan.c
@@ -162,6 +162,7 @@ static void vcan_setup(struct net_device *dev)
 
 	dev->netdev_ops		= &vcan_netdev_ops;
 	dev->needs_free_netdev	= true;
+	dev->operstate = IF_OPER_UP;
 }
 
 static struct rtnl_link_ops vcan_link_ops __read_mostly = {
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index f82ad7419508..ab128f66de00 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -133,6 +133,7 @@ static void dummy_setup(struct net_device *dev)
 
 	dev->min_mtu = 0;
 	dev->max_mtu = 0;
+	dev->operstate = IF_OPER_UP;
 }
 
 static int dummy_validate(struct nlattr *tb[], struct nlattr *data[],
-- 
2.25.1

