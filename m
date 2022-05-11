Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1EF522A49
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241635AbiEKDSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241648AbiEKDSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:18:05 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7FA3F31D;
        Tue, 10 May 2022 20:18:02 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x88so1006771pjj.1;
        Tue, 10 May 2022 20:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkPAEUnHh7Y0bdSGpqGG+aLbXq8froR3lc8V+dt6Zuw=;
        b=SM6lbVK58t1fqvAwFCr3mmiRvCOFLHW5z5G8fHKAX+llkTY64ooK8hRcTJn/yQBKTA
         JofYIh1IeQAotV8Ejbo/tKlj+clgsRQYv3BDMpxaaW8lFwR8lyw8M6nkFXWwX0KbqSPl
         NGyy6dVKSWV67r0hi9+TwCL0jMpZuKpiXAjZHWMLIxK615RNrqbhE7qO7CNhsMmAhzVt
         dcxuGd379JRz5wFZd4Iy1BMGB8tgRZRUuhG3LQYTV4G9XbhcXgOZ1+udjKQGar9AwiSE
         m0lzbE+Q4YowLKH1yzEKudgjWYhz4X1VdjhykrfKZjP5ZAYVokakSs3A+StTLZNS2s4i
         M8Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkPAEUnHh7Y0bdSGpqGG+aLbXq8froR3lc8V+dt6Zuw=;
        b=6Xz6acOImBEZcz8flmzo6nG1X+VB/fqDO6/xdPLXst7/aOV8xVh9N37OFjrH+/tv8m
         ZEaTgzZzvDz7gj6Izm1aphK6r3Dn1xDzzVX1QObsSwAfdx7wVnN2RRH7a6hzZwCqg17I
         CRAtFPP/y35ccyKFWhcuKKg3AJZlUh3tOS98DNO0WDlT4JoLoOdcZb1/dA9R2hOJ8hMv
         2/c3hzqMXv0cwUhE+hcaTkSpT4G0ZHAOJWMWPxiWwVqf14GcrYnoqCs7bdJuLqrmqIHm
         h5PR37HcxNJbbcXmm+ss49qhODTV1yEbS+ym+ngAdE9xH8Swvvu3PMwEg3QXIZtl5Lb1
         tenw==
X-Gm-Message-State: AOAM530/JaPQTTwsfrGctSR/38oMwtqPdB23iFogWn9TsV63ZMMZTPgk
        n4EYmw7CFr0mPy05KY0ETK+H1ZjB/uM=
X-Google-Smtp-Source: ABdhPJwCJx4VHDxjiMgign5KJxva+2gCozAnmA20wWDayp2UwgPunLc0y3+t2fWcnWYMOOL3rceIlQ==
X-Received: by 2002:a17:902:9349:b0:158:a6f7:e280 with SMTP id g9-20020a170902934900b00158a6f7e280mr23130107plp.155.1652239082046;
        Tue, 10 May 2022 20:18:02 -0700 (PDT)
Received: from localhost.localdomain (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 23-20020aa79157000000b0050dc76281cbsm297465pfi.165.2022.05.10.20.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 20:18:01 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Stefan Wahren <wahrenst@gmx.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: bcmgenet: Check for Wake-on-LAN interrupt probe deferral
Date:   Tue, 10 May 2022 20:17:51 -0700
Message-Id: <20220511031752.2245566-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
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

The interrupt controller supplying the Wake-on-LAN interrupt line maybe
modular on some platforms (irq-bcm7038-l1.c) and might be probed at a
later time than the GENET driver. We need to specifically check for
-EPROBE_DEFER and propagate that error to ensure that we eventually
fetch the interrupt descriptor.

Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
Fixes: 5b1f0e62941b ("net: bcmgenet: Avoid touching non-existent interrupt")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index bf1ec8fdc2ad..e87e46c47387 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3999,6 +3999,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		goto err;
 	}
 	priv->wol_irq = platform_get_irq_optional(pdev, 2);
+	if (priv->wol_irq == -EPROBE_DEFER) {
+		err = priv->wol_irq;
+		goto err;
+	}
 
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
-- 
2.25.1

