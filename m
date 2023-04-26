Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0451D6EFA7F
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 20:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238917AbjDZSzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 14:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239070AbjDZSzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 14:55:18 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00F37EE7;
        Wed, 26 Apr 2023 11:55:01 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63b51fd2972so5904603b3a.3;
        Wed, 26 Apr 2023 11:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682535301; x=1685127301;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=997wcZsLPXSjxvxtNnVAzBL/b0WavYLyXHx/RJFuEtg=;
        b=aUuvqyNKlA5I0oZy805T2an9GEfL+KC6++nGq27+EUSXq9LK9+jWRy+fdW8XPL2BHV
         2SLcXJEqYVAqbwqb6zBbRN2HtBf9xbb/NFq/KoRNZ/a/jPdc7SySEifL99a7Nkkq8bNz
         fzsU4YXNX9ZJRaPwQm6X7I2sku4I8pis5Dw+gAaUYWb7zlnZ6tm6uRcoeD0zn++ssuZE
         Hon/AWOHYo24U9K5xLPuozBb2Zt/PDDcNSJ3nSuKecJxTLNI8Tc+I3sPf38XSg0o7oz0
         kb1vp0kQ7mgRLACpPno0hxGzV2baCHigl/G4J15x3YWnP+NdD9LfMRYDDFOsj01gQfqR
         YQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682535301; x=1685127301;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=997wcZsLPXSjxvxtNnVAzBL/b0WavYLyXHx/RJFuEtg=;
        b=hBNh4rhAArSHguHxxfzXWIzfNf2CA1hzeexL2KJlTt7g3rJ0+4iKlvyNyjlVqpO4n4
         UZlHatkLrVvpslyCfho60dbjbtk/8xaWlxUNHP7Ghi60D2+LN+mkS2CbS/rSTAegSVl8
         dpmv53bbu5dTrp2rOQwfs23f6S42qujzH0lhvhpQRA0KHAW1U3vUZxlCssseAJ8lGDUz
         f3wCpA8fJvnHCWxxArJBfXvkhIQXsOiIBVgIAFM+3Dns2W2oZoE+f5j0eEcb+f159+AT
         mYJSCwjomU0sz/y4i5cfA0S4CRRT3zcP0QKepFwt3OJXQFxcdSHwjSCFOjsufBhGYSt2
         uX9Q==
X-Gm-Message-State: AAQBX9cJIXZKZNxSTpIoriTLJILjGPf/UhU+rFQImGEJApaFOn6LEFBb
        8KOjiwfgI18NuF6wSfE+B8DOpy6ynGhoVQ==
X-Google-Smtp-Source: AKy350Z0cJXW20DTfOvXiRpjr1pWWqpblVlGo4EGb5Y7ZS1Ssx3KNESQrFJo2MKIsbY+cizfJdt0Mw==
X-Received: by 2002:a05:6a00:17a9:b0:63d:2f13:1f3 with SMTP id s41-20020a056a0017a900b0063d2f1301f3mr34588884pfg.33.1682535300748;
        Wed, 26 Apr 2023 11:55:00 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y72-20020a62644b000000b006372791d708sm11639254pfb.104.2023.04.26.11.54.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Apr 2023 11:55:00 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justinpopo6@gmail.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Subject: [PATCH v2 net-next 6/6] MAINTAINERS: ASP 2.0 Ethernet driver maintainers
Date:   Wed, 26 Apr 2023 11:54:32 -0700
Message-Id: <1682535272-32249-7-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add maintainers entry for ASP 2.0 Ethernet driver.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4fc57dfd5fd0..24cbe1c0fc06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4189,6 +4189,15 @@ F:	drivers/net/mdio/mdio-bcm-unimac.c
 F:	include/linux/platform_data/bcmgenet.h
 F:	include/linux/platform_data/mdio-bcm-unimac.h
 
+BROADCOM ASP 2.0 ETHERNET DRIVER
+M:	Justin Chen <justinpopo6@gmail.com>
+M:	Florian Fainelli <f.fainelli@gmail.com>
+L:	bcm-kernel-feedback-list@broadcom.com
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
+F:	drivers/net/ethernet/broadcom/asp2/
+
 BROADCOM IPROC ARM ARCHITECTURE
 M:	Ray Jui <rjui@broadcom.com>
 M:	Scott Branden <sbranden@broadcom.com>
-- 
2.7.4

