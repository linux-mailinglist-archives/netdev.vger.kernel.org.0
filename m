Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B0D46F70
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 12:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfFOKJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 06:09:44 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41840 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfFOKJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 06:09:43 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so4962194wrm.8;
        Sat, 15 Jun 2019 03:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wQ/7cnUYQSqiuGdmyeXjvKaUkmct1ono9wLPLG3OrfI=;
        b=dEJNbnbtlA725Ds40u+2L6IvPXX97I2cj+85TIxzwnn6bjCqZSc3PaREK2NSuN/c1b
         SU+BC27Q9RCZpk9pGQWCPbKll+qi0PoaddVqWSnHT1uZglo/rYcblshG+a0fduy+/OjW
         42768ywLGfqMrrUvtSCbN7MaIS5RP/nj46gTmKiPdr96eN6fiKlBqyGwNC4rWYsH0Df2
         SGLT+wdS3pMgXeC+S8HcSkd1sAIvq/JiJRZMqi8IY4BLY2RK6p1LK6eYmA0ultymVVSI
         SzugkySWnGevMmz/NlWPIxTPPXSy5JouG+SStaSzZrRGS+YbTneXuMBycBuRH4vWPecc
         Cc9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wQ/7cnUYQSqiuGdmyeXjvKaUkmct1ono9wLPLG3OrfI=;
        b=quH95xFlH/3t0ZsTlmI3cngTj618EQFuxgqORqRY45FjvlAQIFdXgaO7DwujGHaAYx
         98QxOuxGHgMN+rOZQB6voDgLffnEH9mHK0xuxv+P/w0iwYTOvrqiONhHWy434O6lbivT
         VYYsQp9S4f3/dJNQoR7IHYx1FPW7QHKdVXFMY/cZTjcxJT5k/3qIPLSPLAKgoH0Imlsb
         ZehYL2mfgzmFuG1K0Q9q3ny7S3YVi7cORUJa2gQelOWM5cshBCLv5vGZfRyp7pCuxtPi
         90H4Ff//NPdV3MrqGr5WMevzGvZPI2fuwEiJnqi7BNclCMv6Jaq0r1oYkUp0u/vGDp0b
         Vrmg==
X-Gm-Message-State: APjAAAXYjpZ5CtmBUaLeg9olJJLfAZPEOsyLtLlR8jKIH/w/rbEW0eTG
        poFIAwO+4zeuStAyshBlYz+1rdjGTwU=
X-Google-Smtp-Source: APXvYqwdaH+X0Ee2lmqzRgtTJBEBf2J7LCaaYiBmWtAtwEBuXsuqiJKtSsKBjp4BmTscPm40kULU9Q==
X-Received: by 2002:a5d:46ce:: with SMTP id g14mr10882357wrs.203.1560593381288;
        Sat, 15 Jun 2019 03:09:41 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E00A9A405DFDBBC0790.dip0.t-ipconnect.de. [2003:f1:33c2:e00:a9a4:5df:dbbc:790])
        by smtp.googlemail.com with ESMTPSA id f2sm9270513wrq.48.2019.06.15.03.09.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 03:09:40 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net
Cc:     linus.walleij@linaro.org, andrew@lunn.ch,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next v1 0/5] stmmac: cleanups for stmmac_mdio_reset
Date:   Sat, 15 Jun 2019 12:09:27 +0200
Message-Id: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a successor to my previous series "stmmac: honor the GPIO flags
for the PHY reset GPIO" from [0]. It contains only the "cleanup"
patches from that series plus some additional cleanups on top.

I broke out the actual GPIO flag handling into a separate patch which
is already part of net-next: "net: stmmac: use GPIO descriptors in
stmmac_mdio_reset" from [1]

I have build and runtime tested this on my ARM Meson8b Odroid-C1.


[0] https://patchwork.kernel.org/cover/10983801/
[1] https://patchwork.ozlabs.org/patch/1114798/


Martin Blumenstingl (5):
  net: stmmac: drop redundant check in stmmac_mdio_reset
  net: stmmac: use device_property_read_u32_array to read the reset
    delays
  net: stmmac: drop the reset GPIO from struct stmmac_mdio_bus_data
  net: stmmac: drop the reset delays from struct stmmac_mdio_bus_data
  net: stmmac: drop the phy_reset hook from struct stmmac_mdio_bus_data

 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 52 ++++++-------------
 include/linux/stmmac.h                        |  5 --
 2 files changed, 16 insertions(+), 41 deletions(-)

-- 
2.22.0

