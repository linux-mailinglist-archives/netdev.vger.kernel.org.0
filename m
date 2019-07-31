Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353D67CC4B
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 20:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbfGaSvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 14:51:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55337 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfGaSvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 14:51:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so61905703wmj.5;
        Wed, 31 Jul 2019 11:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TIq//3WBvHqO99YVQvLeZ50v6iDly2l9GsQRTcXr4CU=;
        b=CyPRLG609W1sq1ut05WWPgwwnrpx5iSeNBPqSvSTfJC3S3DV3HR/nGphe0hFxcmafO
         q6PF7zrIUDkRNJe4QUG4g6zy4YP4AVJN5XfzOvrw7m30iD1SCzYLLgqtwYa9e58hWNft
         CDtLXu8HdzDldZDDzg/o9ph644TnThNpEFgKKbQMmAj8pJDFhGVRO2XLbW3MBjZSIMsi
         8Szyv/SfbREdsF2ljJZlhhukLPfRhBWHhfmww+A5teEhiJoKdtpPVOilfeEjyiw0jbuT
         A6v2yhigJjWZiRXEF74HPMG8D67KaG/i7srTfs8yiT7x6pvNF5I+zqD0PeFySEexWQpl
         g5FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TIq//3WBvHqO99YVQvLeZ50v6iDly2l9GsQRTcXr4CU=;
        b=Ksat5yvpTJQQVKMKs9S/eyIy7WbtfuA4/wVJWRY2bCrAKIBe7anjoY9b33vlv2WUz2
         MtsMgkmkQGPD+vwXwxl2+2QtKEWP7ZwlGujlZtdzaRcHWOXhrwq+JbBtoM0oPOgJaY8c
         gLeA6LmKajk1Fi570zkJ1oSMzoRUZVxfbKuR9BVT2rU8K/LFKUiSqNDgFlUzhu+F5X59
         KbV8gNcablxdgvl6htjlXqyPd6Qv1yczu01Op/PRS4jJPpli1dmo8YXnDmnNK+rldABM
         4kqCavDxqCycR2vHefkZveNx+hW83KqgNGuMNDVRZt2GKNAcdlRuA/kAtKDC52jCpp1P
         Hk0Q==
X-Gm-Message-State: APjAAAX2xlDA+U7V5Knq4mn3tuYBA067olRxPge8neLGB78HZ5xTNRPH
        zKTbnQzrU3VWyT00y9urS4o=
X-Google-Smtp-Source: APXvYqwT3vvKCphGwPAkg3s6juYAFATCs84O8st2n9NhxyeSzVKnAtJ+JFmzCZMNEF2070f4dGarbQ==
X-Received: by 2002:a1c:cb0a:: with SMTP id b10mr110648132wmg.41.1564599065059;
        Wed, 31 Jul 2019 11:51:05 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id o20sm174722993wrh.8.2019.07.31.11.51.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 11:51:04 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, broonie@kernel.org, devel@driverdev.osuosl.org,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        hkallweit1@gmail.com, kernel-build-reports@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        natechancellor@gmail.com, netdev@vger.kernel.org,
        willy@infradead.org, kbuild test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] net: mdio-octeon: Fix build error and Kconfig warning
Date:   Wed, 31 Jul 2019 11:50:24 -0700
Message-Id: <20190731185023.20954-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731.094150.851749535529247096.davem@davemloft.net>
References: <20190731.094150.851749535529247096.davem@davemloft.net>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

arm allyesconfig warns:

WARNING: unmet direct dependencies detected for MDIO_OCTEON
  Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=y] && MDIO_BUS [=y]
&& 64BIT && HAS_IOMEM [=y] && OF_MDIO [=y]
  Selected by [y]:
  - OCTEON_ETHERNET [=y] && STAGING [=y] && (CAVIUM_OCTEON_SOC &&
NETDEVICES [=y] || COMPILE_TEST [=y])

and errors:

In file included from ../drivers/net/phy/mdio-octeon.c:14:
../drivers/net/phy/mdio-octeon.c: In function 'octeon_mdiobus_probe':
../drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of
function 'writeq'; did you mean 'writeb'?
[-Werror=implicit-function-declaration]
  111 | #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
      |                                    ^~~~~~
../drivers/net/phy/mdio-octeon.c:56:2: note: in expansion of macro
'oct_mdio_writeq'
   56 |  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
      |  ^~~~~~~~~~~~~~~
cc1: some warnings being treated as errors

This allows MDIO_OCTEON to be built with COMPILE_TEST as well and
includes the proper header for readq/writeq. This does not address
the several -Wint-to-pointer-cast and -Wpointer-to-int-cast warnings
that appeared as a result of commit 171a9bae68c7 ("staging/octeon:
Allow test build on !MIPS") in these files.

Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Mark Brown <broonie@kernel.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/phy/Kconfig       | 2 +-
 drivers/net/phy/mdio-cavium.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 20f14c5fbb7e..ed2edf4b5b0e 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -159,7 +159,7 @@ config MDIO_MSCC_MIIM
 
 config MDIO_OCTEON
 	tristate "Octeon and some ThunderX SOCs MDIO buses"
-	depends on 64BIT
+	depends on 64BIT || COMPILE_TEST
 	depends on HAS_IOMEM && OF_MDIO
 	select MDIO_CAVIUM
 	help
diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/phy/mdio-cavium.h
index ed5f9bb5448d..b7f89ad27465 100644
--- a/drivers/net/phy/mdio-cavium.h
+++ b/drivers/net/phy/mdio-cavium.h
@@ -108,6 +108,8 @@ static inline u64 oct_mdio_readq(u64 addr)
 	return cvmx_read_csr(addr);
 }
 #else
+#include <linux/io-64-nonatomic-lo-hi.h>
+
 #define oct_mdio_writeq(val, addr)	writeq(val, (void *)addr)
 #define oct_mdio_readq(addr)		readq((void *)addr)
 #endif
-- 
2.22.0

