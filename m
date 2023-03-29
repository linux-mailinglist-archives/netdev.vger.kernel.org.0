Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567816CF543
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 23:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjC2VWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 17:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjC2VVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 17:21:48 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0344EC3;
        Wed, 29 Mar 2023 14:21:46 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id bj20so12708121oib.3;
        Wed, 29 Mar 2023 14:21:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680124906;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ztuu6Fsug8mRxKnYsfiismCx0sBKyfeU96HhnyE0Bjs=;
        b=I6qA/D75s2omWMVeBi8J+UQ29cUBMOLzxP6dBJuK37jMGRnHzNRYGWX+zaoOh5VTHa
         +Rxa3EyvEus4Ymt06XyEG9+Y/NtRGaJSLYnK4PTTEZ00jyPEHloHJ1o7OdaMlTeqfUAT
         cQIXXYyeNLojp+pcmrAmhAJRI+c7iRfwBPHozM38Gbfr9wApqN6pfpgQmz5qkcEe3M3T
         R2pohJZMMsHg6uYB5i8srzu12qzxC6PKZF32akNZ9hwLKt92KRJzXLzd7OyIfXxh1D/b
         mlyTPcwcJ59MeH9QZ+OEo3auXds7+zXdq4nHSXQl29f9AKtgy6b7AHPXnm/WzArdg7LX
         W43w==
X-Gm-Message-State: AO0yUKXEaaD+7GAE0FrpkpMcYPnxX5Agfluv43vqFjfsCeQWo6oTJgyt
        9+Vypy5VT5aHh0em4pe57A==
X-Google-Smtp-Source: AK7set8ebntw2ESdGB7l5PdDO6NsIvCSiIc8J8/t/ipIkwSdCjkA74SknOyxYwAjPu2eirZsztFa4A==
X-Received: by 2002:a05:6808:7cf:b0:35e:d787:ec7f with SMTP id f15-20020a05680807cf00b0035ed787ec7fmr8881054oij.50.1680124905841;
        Wed, 29 Mar 2023 14:21:45 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r184-20020a4a4ec1000000b005251e3f92ecsm14394555ooa.47.2023.03.29.14.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:21:45 -0700 (PDT)
Received: (nullmailer pid 86899 invoked by uid 1000);
        Wed, 29 Mar 2023 21:21:39 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 29 Mar 2023 16:20:46 -0500
Subject: [PATCH 5/5] ACPI: Replace irqdomain.h include with struct
 declarations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v1-5-8dc5cd3c610e@kernel.org>
References: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
In-Reply-To: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
X-Mailer: b4 0.13-dev
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

linux/acpi.h includes irqdomain.h which includes of.h. Break the include
chain by replacing the irqdomain include with forward declarations for
struct irq_domain and irq_domain_ops which is sufficient for acpi.h.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
 include/linux/acpi.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index efff750f326d..169c17c0b0dc 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -10,12 +10,14 @@
 
 #include <linux/errno.h>
 #include <linux/ioport.h>	/* for struct resource */
-#include <linux/irqdomain.h>
 #include <linux/resource_ext.h>
 #include <linux/device.h>
 #include <linux/property.h>
 #include <linux/uuid.h>
 
+struct irq_domain;
+struct irq_domain_ops;
+
 #ifndef _LINUX
 #define _LINUX
 #endif

-- 
2.39.2

