Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7D26B3ED9
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 13:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjCJMME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 07:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjCJMLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 07:11:47 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECBDF9EF2;
        Fri, 10 Mar 2023 04:11:06 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bx12so4807270wrb.11;
        Fri, 10 Mar 2023 04:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678450264;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rlBeRbSvFIrZXSgMo0k6lv6ditnNPYMt98nq+fqCams=;
        b=Qk7rWQ9Jc/uVlT41FlTDG2bqsywBJPY43r20sJrLQPkTulwpBHZ06Ec7DpJ+Uo/+NG
         yvu5zWX1pi66zi5trrmf0k3ABW2Zwyf9nyAq9C6xQSfT+uVtt2cdCXc7rX7QjyKvRzOt
         rsV4IFdxoZK7ZcGbZoNghn7Bnofm5AoVhrGcD7IX7llWE6sfZnwnLJ9qqrvuHUgUdJ14
         iSzVYmTl63e174/K785ADYAydKaBT8c0MRfb9RsYT+h5wGV3oZMlt956VV5LvGI2p8f8
         bF4J5l7xYnP6s3t+oXGmCQIqdn/F31UGTGUldkhuURlXgKkHWqxmvrnQ4PiJq4YvWfwo
         alNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678450264;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rlBeRbSvFIrZXSgMo0k6lv6ditnNPYMt98nq+fqCams=;
        b=sdmhWioXJ2vCo41skUcFSmDiqFcMfSQ9knD60mJMGdox4OOCnpxeO1/AZClK0Raxg7
         qrbJUyISK5SHIlmq73nx2aLRKJav4EpfGThxrBumiOFYi6aBRhk9maI8ToTRGONvm/nW
         EzhrKZcZ2oSaw1hlcbdGwVbFf7kqwc3UTLOgznJrtJc39/vmeVydswCM9rubkEGlHbUe
         4Rxv5FVYy2ROyr3wlnqQtdTdxrHwjFNTB24rzO9d6lQZzhPKlrAHhF9hzn8dPnxoKHzL
         MXQY5b9FWZoHNl1Uo8WBDSHFXy4yHXvB8bu2DJt4JXqEJe8JMgnkHNXmRP3pxvW2jfid
         gpJg==
X-Gm-Message-State: AO0yUKV4gi7ybl/rb5VhwdQ7v8AGJDdGinziRF3/VyQipgeQaCrh8Kjv
        lq4ABWolvhVLf1cLFYXr03s=
X-Google-Smtp-Source: AK7set/aYzm+ywlxjxmDFOlQLxb0vdqvAVhyfDahFxWjRUfayMsOT/Y6SVoIn7NIRHJitKbIQ7o+Rg==
X-Received: by 2002:a5d:5232:0:b0:2c8:4bca:7fc2 with SMTP id i18-20020a5d5232000000b002c84bca7fc2mr19225235wra.4.1678450264347;
        Fri, 10 Mar 2023 04:11:04 -0800 (PST)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id f1-20020a1c6a01000000b003b47b80cec3sm2727289wmc.42.2023.03.10.04.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 04:11:03 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH] net: dsa: b53: mmap: fix device tree support
Date:   Fri, 10 Mar 2023 13:10:59 +0100
Message-Id: <20230310121059.4498-1-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

B53_CPU_PORT should also be enabled in order to get a working switch.

Fixes: a5538a777b73 ("net: dsa: b53: mmap: Add device tree support")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/b53_mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index e968322dfbf0..24ea2e19dfa6 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -263,7 +263,7 @@ static int b53_mmap_probe_of(struct platform_device *pdev,
 		if (of_property_read_u32(of_port, "reg", &reg))
 			continue;
 
-		if (reg < B53_CPU_PORT)
+		if (reg <= B53_CPU_PORT)
 			pdata->enabled_ports |= BIT(reg);
 	}
 
-- 
2.30.2

