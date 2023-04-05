Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D4C6D884F
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbjDEU1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbjDEU1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:27:30 -0400
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645E176A9;
        Wed,  5 Apr 2023 13:27:26 -0700 (PDT)
Received: by mail-oi1-f181.google.com with SMTP id bx42so12025182oib.6;
        Wed, 05 Apr 2023 13:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726445;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=amARnlOF1iPOroaq57gvCO3EUIjXtRKKLgV+BAa7GyA=;
        b=oNWBdf+LJQeupNotyx3roKGHF2oYc0YiILjtkYmJvehMr5/wxkeHGosGb0bTzOweuA
         4h8IGp9M7u3BekL8X8G4FUjRKMAcSjxzvZ8fIQiSAantTZmAgubAz4pybtH6B0wVT9FQ
         GBL6s8eNhlYr0Ctr0OHe5BDj0wHD90vKOwsln7BUj7mdxVfAB6pJHrWtftd03uMNox8L
         31feFQEogsD9Nbs6HRHghcdTc9m3FPT4aTtXCPxo/qNZqXYBLnsFcDVolwAOI+5+0CVT
         4nT6nzUuGy0558tTyOvbRsE2zw3WbbY7MbQBC2HUr0c7JkiZxn/CVCfH7JzA4Bb+c+Xi
         O5dw==
X-Gm-Message-State: AAQBX9eZrNhhLYHSF/kMOFlWdWlq+TwT9Ek0wE0TDpmidHb8oeltfidp
        dD7qxUlKiG6/Pf0WgcW1ZQ==
X-Google-Smtp-Source: AKy350ajTaLy0qTbb9yH+lxLfyhHHpsFZm2vXmFygDhy0JelJ9qq76gGsOP0SKY6SaEK7ABF4E+UaA==
X-Received: by 2002:a05:6808:1a09:b0:389:4f05:5fa8 with SMTP id bk9-20020a0568081a0900b003894f055fa8mr1613117oib.9.1680726445531;
        Wed, 05 Apr 2023 13:27:25 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r204-20020acadad5000000b00383eaf88e75sm6759620oig.39.2023.04.05.13.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:27:25 -0700 (PDT)
Received: (nullmailer pid 425898 invoked by uid 1000);
        Wed, 05 Apr 2023 20:27:17 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 05 Apr 2023 15:27:24 -0500
Subject: [PATCH v2 10/10] ACPI: Replace irqdomain.h include with struct
 declarations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v2-10-c902e581923b@kernel.org>
References: <20230329-acpi-header-cleanup-v2-0-c902e581923b@kernel.org>
In-Reply-To: <20230329-acpi-header-cleanup-v2-0-c902e581923b@kernel.org>
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
        devicetree@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jacob Keller <jacob.e.keller@intel.com>
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

of.h also includes mod_devicetable.h which many drivers implicitly
depend on. As acpi.h already includes it, just move it out of the
'#ifdef CONFIG_ACPI'.

Cc: Marc Zyngier <maz@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v2:
 - Move mod_devicetable.h out of #ifdef
---
 include/linux/acpi.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index efff750f326d..96bd672dc336 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -10,12 +10,15 @@
 
 #include <linux/errno.h>
 #include <linux/ioport.h>	/* for struct resource */
-#include <linux/irqdomain.h>
 #include <linux/resource_ext.h>
 #include <linux/device.h>
+#include <linux/mod_devicetable.h>
 #include <linux/property.h>
 #include <linux/uuid.h>
 
+struct irq_domain;
+struct irq_domain_ops;
+
 #ifndef _LINUX
 #define _LINUX
 #endif
@@ -24,7 +27,6 @@
 #ifdef	CONFIG_ACPI
 
 #include <linux/list.h>
-#include <linux/mod_devicetable.h>
 #include <linux/dynamic_debug.h>
 #include <linux/module.h>
 #include <linux/mutex.h>

-- 
2.39.2

