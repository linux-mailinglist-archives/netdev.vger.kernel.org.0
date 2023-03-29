Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7B76CF526
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 23:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjC2VVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 17:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2VVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 17:21:43 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2343F1711;
        Wed, 29 Mar 2023 14:21:42 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-17683b570b8so17659270fac.13;
        Wed, 29 Mar 2023 14:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680124901;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c5JObOnJhn7Qa3BJtOdllaC7YuPWVzUh4uR8zZIj5qw=;
        b=UIMWJFisKjBZbJG8KhqaOmyLuuUtyjz8jPVeNiOlU57ccMw+ibuLsl2TBGsRh/kLPC
         g1AjoF1BpfCRBQgo3LNO8y83kB3vh9uyEqjrIWrRKcA+2WC1HQhFkjH9Phy7cHKq2OJ9
         pCb+5JIOiBi80T4pzxR4mkoia+J1WjZGzGnfyvq09Zd4uMk4DkFe1d19K1C/h/QUulpt
         lYaEKARCs5UVUhTGhCK7fUdcXlXSeRMjUDuEiphQUXumoUn9RGgR7CnoBSKWZBirpDJz
         V0IXorir+CWkm7uJaXM2e3rwEVyev4d4G39KaeaokfCRfII6PSmjnI/W16weU7slwvcf
         RoYQ==
X-Gm-Message-State: AAQBX9dnl+6X/WcZxAmL5mxG8hyBcG5PA1TO9LNR//DRtp7XA4P4bwVB
        Jd165V53Ft3MrxCwOfSfUFR45FrRWA==
X-Google-Smtp-Source: AK7set/kayRJ98J+4lkqmTCrvYqUbSg+NPKMc5ZxUa6OI9imoPRJExO5faQF3fCKQ5rShmnmkvcw7Q==
X-Received: by 2002:a05:6870:899c:b0:17b:1a4f:adfe with SMTP id f28-20020a056870899c00b0017b1a4fadfemr11592033oaq.10.1680124901366;
        Wed, 29 Mar 2023 14:21:41 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id tk6-20020a05687189c600b0017703cd8ff6sm12167748oab.7.2023.03.29.14.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:21:40 -0700 (PDT)
Received: (nullmailer pid 86888 invoked by uid 1000);
        Wed, 29 Mar 2023 21:21:39 -0000
From:   Rob Herring <robh@kernel.org>
Subject: [PATCH 0/5] Remove acpi.h implicit include of of.h
Date:   Wed, 29 Mar 2023 16:20:41 -0500
Message-Id: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKmrJGQC/x2N0QrCMAwAf2Xk2cDWaJn+iviQddEGSi0pE2Hs3
 w0+3sFxO3QxlQ63YQeTj3Z9V4fpNEDKXF+CujpDGAONFK7IqSlm4VUMUxGuW8MYL0TTHOYzRfB
 y4S64GNeUva1bKS6byVO//9X9cRw/n6ivRnoAAAA=
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
X-Spam-Status: No, score=0.7 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the process of cleaning up DT includes, I found that some drivers 
using DT functions could build without any explicit DT include. I traced 
the include to be coming from acpi.h via irqdomain.h.

I was pleasantly surprised that there were not 100s or even 10s of 
warnings when breaking the include chain. So here's the resulting 
series.

I'd suggest Rafael take the whole series. Alternatively,the fixes can be 
applied in 6.4 and then the last patch either after rc1 or the 
following cycle.

Signed-off-by: Rob Herring <robh@kernel.org>
---
Rob Herring (5):
      iio: adc: ad7292: Add explicit include for of.h
      staging: iio: resolver: ad2s1210: Add explicit include for of.h
      net: rfkill-gpio: Add explicit include for of.h
      serial: 8250_tegra: Add explicit include for of.h
      ACPI: Replace irqdomain.h include with struct declarations

 drivers/iio/adc/ad7292.c                | 1 +
 drivers/staging/iio/resolver/ad2s1210.c | 1 +
 drivers/tty/serial/8250/8250_tegra.c    | 1 +
 include/linux/acpi.h                    | 4 +++-
 net/rfkill/rfkill-gpio.c                | 1 +
 5 files changed, 7 insertions(+), 1 deletion(-)
---
base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
change-id: 20230329-acpi-header-cleanup-665331828436

Best regards,
-- 
Rob Herring <robh@kernel.org>

