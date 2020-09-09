Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E7D262CCC
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 12:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgIIKEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 06:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgIIKEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 06:04:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1E4C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 03:04:34 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o5so2225127wrn.13
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 03:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9ysUs71WouaVkJedeq5NazsdGgkQ92HpN1i7esV79aQ=;
        b=dBkGX1DvKC1uMyOv3ZnHbfhJLx/aWrAeyF0TsENIJgZyvged57GzUDfEh2hSnZ6XZv
         P17Fo8P/+IpOmfOl6fUodkI6gs6wLlTsOHY/+nfhOPnBnAmvADhOOgPREOmHQLRfYbNj
         iipbCPlPqRmRvWxCM4ofAWkAS7NaCl0eevBeo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9ysUs71WouaVkJedeq5NazsdGgkQ92HpN1i7esV79aQ=;
        b=Xfqn0HFR+cKYzoCIXzBevZIyjlN10/TZWKjbPU2qn/YrRakxu9G7cAqb0ax10wAPH0
         /CAOlyO+3L4NJt2Wkl//ente9U8Io+YgpwkaGF+tJz5ToNehAlU5cRKRacOuL9r2NyPm
         GFqsBS1Uta+eWHqLKvtFOdxcZx8kTSh4HESFV7iqfIqDshF1rxnIU2Wirpfqhey0pRZt
         a6hys2FQFO7q3eGJ5Qxh3An/ShGZFLSO+F2SUX9voQfWnYm9Tzhg02CDaWespYUvVQLX
         pFodd8/jS5YLaOS8eS0ZuIsIARsvqqiguTv3UY6lTglOfGxw1032xkTjDy+3rM4kgH4/
         Bvow==
X-Gm-Message-State: AOAM533gZlKYFqH6ZkYIjuookLukc/4j/BGZR/t0VgU69sd1ALIldsjL
        /DUHmc6vFlfjG+V0phtj2/a5BA==
X-Google-Smtp-Source: ABdhPJw2bzBZpKHJW8EA7VKDTVtvq3+h4BJrKRl/PByI2rmDPV0QUgEru9qlo/rF58zSo8If8TTdTw==
X-Received: by 2002:adf:cf01:: with SMTP id o1mr3054804wrj.421.1599645873149;
        Wed, 09 Sep 2020 03:04:33 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id l16sm3828237wrb.70.2020.09.09.03.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 03:04:32 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH v3 0/4] ksz9477 dsa switch driver improvements
Date:   Wed,  9 Sep 2020 11:04:13 +0100
Message-Id: <20200909100417.380011-1-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These changes were made while debugging the ksz9477 driver for use on a
custom board which uses the ksz9893 switch supported by this driver. The
patches have been runtime tested on top of Linux 5.8.4, I couldn't
runtime test them on top of 5.9-rc3 due to unrelated issues. They have
been build tested on top of net-next.

These changes can also be pulled from:

  https://gitlab.com/pbarker.dev/staging/linux.git
  tag: for-net-next/ksz-v3_2020-09-09

Changes from v2:

  * Fixed incorrect type in assignment error.
    Reported-by: kernel test robot <lkp@intel.com>

Changes from v1:

  * Rebased onto net-next.

  * Dropped unnecessary `#include <linux/printk.h>`.

  * Instead of printing the phy mode in `ksz9477_port_setup()`, modify
    the existing print in `ksz9477_config_cpu_port()` to always produce
    output and to be more clear.

Paul Barker (4):
  net: dsa: microchip: Make switch detection more informative
  net: dsa: microchip: Improve phy mode message
  net: dsa: microchip: Disable RGMII in-band status on KSZ9893
  net: dsa: microchip: Implement recommended reset timing

 drivers/net/dsa/microchip/ksz9477.c    | 25 ++++++++++++++++++++-----
 drivers/net/dsa/microchip/ksz_common.c |  3 ++-
 2 files changed, 22 insertions(+), 6 deletions(-)

-- 
2.28.0


Paul Barker (4):
  net: dsa: microchip: Make switch detection more informative
  net: dsa: microchip: Improve phy mode message
  net: dsa: microchip: Disable RGMII in-band status on KSZ9893
  net: dsa: microchip: Implement recommended reset timing

 drivers/net/dsa/microchip/ksz9477.c    | 26 +++++++++++++++++++++-----
 drivers/net/dsa/microchip/ksz_common.c |  3 ++-
 2 files changed, 23 insertions(+), 6 deletions(-)


base-commit: f5499c67477eb640e794428da0502c5e4c723119
-- 
2.28.0

