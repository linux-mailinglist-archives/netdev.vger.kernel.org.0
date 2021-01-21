Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950592FE0C9
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbhAUEIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbhAUEGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:06:49 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F045C061757;
        Wed, 20 Jan 2021 20:06:07 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id j12so743427pjy.5;
        Wed, 20 Jan 2021 20:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dEAELiJFMu38K3TYT5cxHaQJx7scLJfJbiIj6L7V5Zs=;
        b=J2+IZgF76UZ5DBBcV6h6lSJME8cHBlKKUErinK4Xvpa/yQpQBeHS59kgVvps8YUp6/
         lijUHqdM1/UQbKT+UNCGJanjJENdmztcSBE6vYAew5bfEShV32hJJc+HSJP+b09JRb33
         4C+AdqzMrIk0EkfbA5APzxz3UkEqyJrABrDRoZfNFXwihVIn397j4yuYJ9ZW12fIWkRI
         0KJdB/8ByS0gAZYSu+WD/xK7MWSnn4BHSMxxt3YBucBHSEZuFdtYolDM6CUMkBkzRen+
         MSfbQ/fJ+vEkYstqFE1q/4AqMVVmr1oTr+RdIkEWsO945USMT6HNY/nhsmMa7KdbvNU7
         BzJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dEAELiJFMu38K3TYT5cxHaQJx7scLJfJbiIj6L7V5Zs=;
        b=K5hTLZ97AgIgr2fNu2INSYMRTH2pfmlHKnPCLzIY1Y6k+h5ywOlOI2dZH5GzEJqow4
         CAKi02Qigl0AJYRcNu5oh6Ph77W+GiZBCpF3ElrKqWuIKpDSFHZ1/i9fWJOw7gpjywfH
         rV+3Vy6Db8VeCRqFaYTPmyLgkBuqzhUgGovEReysRbCgRjk1xegc1mH6qgM9cEgqdDAy
         54Ov0qICg3FaOF2lo2r5O3mu/XuypnbxJK7JnRAOZw5i0M61irwC/l3hkoOqfkMpgsp6
         3PsFXdsFhA4uIMgYBVbC3zBS1NZNAxlB811hvr6JsWe8cXda6+8PVpnWFka/vV5Gfbmp
         yCfQ==
X-Gm-Message-State: AOAM533oB5TNTNC5v70hyWsDvkC5nEsygSrIPILCKyEpMmYMj32NI8Uq
        5zDWhS9KCzSKMU+UaxqNCqQcX7cDKzU=
X-Google-Smtp-Source: ABdhPJyPkkeEXsC/0/2M/kVhpNZCDJofZK6zqz081klTKVJv6+kqvX1gRFSdXLGMb53wJU9/llAGDA==
X-Received: by 2002:a17:90a:b296:: with SMTP id c22mr9336798pjr.91.1611201966578;
        Wed, 20 Jan 2021 20:06:06 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id f24sm3808567pjj.5.2021.01.20.20.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:06:05 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/4] Remove unneeded PHY time stamping option.
Date:   Wed, 20 Jan 2021 20:05:59 -0800
Message-Id: <cover.1611198584.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NETWORK_PHY_TIMESTAMPING configuration option adds additional
checks into the networking hot path, and it is only needed by two
rather esoteric devices, namely the TI DP83640 PHYTER and the ZHAW
InES 1588 IP core.  Very few end users have these devices, and those
that do have them are building specialized embedded systems.

Unfortunately two unrelated drivers depend on this option, and two
defconfigs enable it.  It is probably my fault for not paying enough
attention in reviews.

This series corrects the gratuitous use of NETWORK_PHY_TIMESTAMPING.


Richard Cochran (4):
  net: dsa: mv88e6xxx: Remove bogus Kconfig dependency.
  net: mvpp2: Remove unneeded Kconfig dependency.
  ARM: socfpga_defconfig: Disable PHY time stamping by default.
  ARM: axm55xx_defconfig: Disable PHY time stamping by default.

 arch/arm/configs/axm55xx_defconfig   | 1 -
 arch/arm/configs/socfpga_defconfig   | 6 +-----
 drivers/net/dsa/mv88e6xxx/Kconfig    | 1 -
 drivers/net/ethernet/marvell/Kconfig | 1 -
 4 files changed, 1 insertion(+), 8 deletions(-)

-- 
2.20.1

