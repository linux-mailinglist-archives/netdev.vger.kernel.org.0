Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70126E7049
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 02:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjDSALj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 20:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjDSALG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 20:11:06 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D6C118CC;
        Tue, 18 Apr 2023 17:10:51 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id oo30so16978802qvb.12;
        Tue, 18 Apr 2023 17:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681863050; x=1684455050;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e9ELuaxovAZK107S+i/lSGtgzWrNVqegvOgbyEPR6lQ=;
        b=TgDPsyZ1jBiBNae2UNayCnoPatUMqJfdKQIaYymmlbnKkfDWn7HE9FtZXecYXWbvmy
         SQnf87vdKQOotjJz7TvP7+xX0CxpkrcPRr2KjczH43l8fTtM1Hxu+kSBEQIv7nCa8HpS
         9LOzE82ION1FnEzjPGgJ56Y6PfCkbPoHDOiDGgnpA5lQs8RAlFGjlQ1LGyAyCSclQdDM
         UjXmvmNbaBzFgr6dzoHmq9tQrr1GqcAXQp8sa00EnyD4zWpUD3NOw4MzCz4xfVYA3dM7
         YNtWCm2YbSvY7lUCOHADi9FajcLM/l9JPmJoOODkDuk7qpGc2NVo35AZ3HxPLS29MwNO
         2sTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681863050; x=1684455050;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e9ELuaxovAZK107S+i/lSGtgzWrNVqegvOgbyEPR6lQ=;
        b=U0ynOpWRl4dZKeHxlbaVKh9H3ENnT/BEAuonOYY2eq27qMT6b4hLo4RadIGfYZREiR
         QA8lNId9LxeioW9KyUDJylljHnixI1dGwVsQx+oD5EcOYSM2JN9iKaK+On7owbUNd4zY
         /M85CEdWYBS1KLGRe44VGQk9N3mPhN+RBE1c+BkophimhKUfwNMGUlvwQr2tEmYG5FH/
         8hEVDY2C3j/WwsLm3RqzqkVI0FnSvB7+sXp76PF7C2feJyr8vo7Ndt5wdbLc+KVexX9D
         Xigc399ZUANCIE8GI2GeYpSLXRcpc3j5IIneVRvDpykDw2iveLAVbrJFUn0/gW4ywmi3
         JAJw==
X-Gm-Message-State: AAQBX9ciDXwn+fxRxxant6ZU10orKNzE4RiiJCWIcDh/VI+bFV3ZNfnE
        zaJLOJfHjTcjgehtsboXlnrWljHY0MVVDA==
X-Google-Smtp-Source: AKy350YAySwOPYgIwQnF0LF8BMbshq+v1WxcDSvfQk1fGEMDH6OmZSxu8FMKW47JggpKX+oc+lJmWw==
X-Received: by 2002:a05:6214:20a6:b0:56f:796e:c3a5 with SMTP id 6-20020a05621420a600b0056f796ec3a5mr22713215qvd.4.1681863050059;
        Tue, 18 Apr 2023 17:10:50 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d14-20020a37680e000000b0074d1b6a8187sm2639035qkc.130.2023.04.18.17.10.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Apr 2023 17:10:49 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justin.chen@broadcom.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com, Justin Chen <justinpopo6@gmail.com>
Subject: [PATCH net-next 6/6] MAINTAINERS: ASP 2.0 Ethernet driver maintainers
Date:   Tue, 18 Apr 2023 17:10:18 -0700
Message-Id: <1681863018-28006-7-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
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

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
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

