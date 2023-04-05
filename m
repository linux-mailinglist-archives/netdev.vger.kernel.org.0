Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7BA6D883B
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbjDEU1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDEU1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:27:20 -0400
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77C14C31;
        Wed,  5 Apr 2023 13:27:19 -0700 (PDT)
Received: by mail-ot1-f50.google.com with SMTP id cm7-20020a056830650700b006a11f365d13so18377957otb.0;
        Wed, 05 Apr 2023 13:27:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726439;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jhywZUom6FVbbnxuIEEwYSdDwpixbUY1lehHpDBSgWw=;
        b=5pNzdKM5+3J7NdFyI3ogXXEVkfTncpWchTsVGkAav5LKsJu28NHmPnneFHfX6N5CCf
         msI7zdmn4NCtQegC3tlH0/1XImQ92vBZBaY8Y3tGQac9Cn7BL15HoauI6EFcFqbLe88w
         /YASGBI7JEj5xK9R7fu1t7DzVkZTcQmGOM/448k2TkNblccIsAEQsRURth7Uc3AaTfG0
         /XU2XeJR5fO7JLkiAJEVJtofDdOdbExnB0wC5kyaMRAo/8vqBE4CYmryDNwpgbbLZdf2
         FoXKWapPHdTerBFSLMsybNf9ZYIoX7z8EEXmXOOnHAsCS+FhJIxwqOyW7V/RJrLCs389
         BoKg==
X-Gm-Message-State: AAQBX9eL5suZAC1issydy/PT24GSbh+SDtMVrGRTH2VKfFCH6vi12ls+
        7QDHkiGVv+5w2KtTXIE49A==
X-Google-Smtp-Source: AKy350Y6PkxJ1TeFc3rYqzBfJAZxJAKrftIpgaCSmMTQOsLNxNqW3HlLQ0Djx2CJiGesOvR3DIQFAA==
X-Received: by 2002:a9d:4f16:0:b0:697:3da3:e404 with SMTP id d22-20020a9d4f16000000b006973da3e404mr3621048otl.38.1680726439129;
        Wed, 05 Apr 2023 13:27:19 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w3-20020a9d6383000000b006a11c15a097sm7271960otk.4.2023.04.05.13.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:27:18 -0700 (PDT)
Received: (nullmailer pid 425877 invoked by uid 1000);
        Wed, 05 Apr 2023 20:27:17 -0000
From:   Rob Herring <robh@kernel.org>
Subject: [PATCH v2 00/10] Remove acpi.h implicit include of of.h
Date:   Wed, 05 Apr 2023 15:27:14 -0500
Message-Id: <20230329-acpi-header-cleanup-v2-0-c902e581923b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKLZLWQC/32NSwrCMBQAryJZ+yQfG6or7yFdpC/PJhjS8mKLU
 np3Yw/gcgaGWUUhjlTE9bAKpiWWOOYK+ngQGFweCKKvLLTURhp9AYdThEDOEwMmcnmewNrGGNX
 q9mysqGXvCkHPLmOobZ5TqnJiesT3vrp3lUMsr5E/+3lRP/t/siiQ0Hps0Bu0StLtSZwpnUYeR
 Ldt2xfkJNhrzAAAAA==
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
        Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
X-Mailer: b4 0.13-dev
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
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

Compile tested on x86 and powerpc allmodconfig and arm64 allmodconfig 
minus CONFIG_ACPI.

Signed-off-by: Rob Herring <robh@kernel.org>
---
Changes in v2:
- More explicit include fixes reported by Stephen
- Link to v1: https://lore.kernel.org/r/20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org

---
Rob Herring (10):
      iio: adc: ad7292: Add explicit include for of.h
      staging: iio: resolver: ad2s1210: Add explicit include for of.h
      net: rfkill-gpio: Add explicit include for of.h
      serial: 8250_tegra: Add explicit include for of.h
      ata: pata_macio: Add explicit include of irqdomain.h
      pata: ixp4xx: Add explicit include for of.h
      virtio-mmio: Add explicit include for of.h
      tpm: atmel: Add explicit include for of.h
      fpga: lattice-sysconfig-spi: Add explicit include for of.h
      ACPI: Replace irqdomain.h include with struct declarations

 drivers/ata/pata_ixp4xx_cf.c            | 1 +
 drivers/ata/pata_macio.c                | 1 +
 drivers/char/tpm/tpm_atmel.h            | 2 +-
 drivers/fpga/lattice-sysconfig-spi.c    | 1 +
 drivers/iio/adc/ad7292.c                | 1 +
 drivers/staging/iio/resolver/ad2s1210.c | 1 +
 drivers/tty/serial/8250/8250_tegra.c    | 1 +
 drivers/virtio/virtio_mmio.c            | 1 +
 include/linux/acpi.h                    | 6 ++++--
 net/rfkill/rfkill-gpio.c                | 1 +
 10 files changed, 13 insertions(+), 3 deletions(-)
---
base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
change-id: 20230329-acpi-header-cleanup-665331828436

Best regards,
-- 
Rob Herring <robh@kernel.org>

