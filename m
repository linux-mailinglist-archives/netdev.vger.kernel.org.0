Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BFA2FE0D3
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbhAUEf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbhAUEHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:07:32 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39301C061794;
        Wed, 20 Jan 2021 20:06:15 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id y12so763237pji.1;
        Wed, 20 Jan 2021 20:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T1lR9J6QgLZahbnNwIjHLkVhPfyi5cP1iF5z5/zhv44=;
        b=WShgxGiqKKgRX/tsaAWZQuXtMDaIZg+6mX51WXozVo+F3mGn4fn9KSKrzM2nIG36b+
         jC2CcR8fCSoKjOq+S5pwSQoU8j2ABHbrk07/Hpe6YIDA2DmUbHsdl/M6J+B3mvY/aWO7
         CBPcUkZSOqPfzKNg2IpQ9hKWQW1j6UO9I0MmnOzwOehv2ZnLTHHo0ZCkeDpfCMLwFeMV
         /s+Sngv8KHInN+L6TDgIDVhWc5i0icfDNjA2H+cgxyaD+lVL51aitHmljkIDuyU0NfBa
         NAb6Fs/yNKNAvplJ62eEq0sBcBXu8TeH+2KFabRTcqzQjnpUVTGuNNrVeCt4V5es9TXO
         H6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T1lR9J6QgLZahbnNwIjHLkVhPfyi5cP1iF5z5/zhv44=;
        b=KGLL/yEw7Nt++yP4FxpevwmTQxtvSBuRK7rbuHHO631rGoRJeecwZR7K+KIgBaOs5/
         dBzPoB+P6JRVpr8t+C317iBtL4+xFTQLOq8Ga1VF5ohRzvvdt/2b7+Gp1wIKg1kZ5vT2
         d4iT/h/E6btq2WuhlVh886utbvwR778kfl5cu8fy3IafhjlE9TWTQIsjVaU70fI98Ck+
         2f1RAOy/WAhZFJYktl6LEkxelyblps6p2Fvjn676KnXVRaBYPLCMKbCQ1I0nfd4Rr8J9
         DQgxGLxYOCDvEi4sp0thBe09sQJOyYOCf5cjPz+YXuOGvHWwi2B5LVGyAEnQqxGeDwU0
         gQTQ==
X-Gm-Message-State: AOAM533nOaWNqva1WcLddRDR8s4Ocqn/JqOnTweMk6iD2NSyXf0y9VUl
        oPz8s7aZVi0OnBTs/9jE4aLGidDGkY4=
X-Google-Smtp-Source: ABdhPJxrBCNPQBSj+7f1m9h/3zgOky2M6hR+CS5mldmQKBb2jI9OFYySmwnnBpDynFQiItrBu4PSyw==
X-Received: by 2002:a17:902:c509:b029:de:c3c7:9433 with SMTP id o9-20020a170902c509b02900dec3c79433mr12657230plx.71.1611201974488;
        Wed, 20 Jan 2021 20:06:14 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id f24sm3808567pjj.5.2021.01.20.20.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:06:13 -0800 (PST)
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
Subject: [PATCH net 4/4] ARM: axm55xx_defconfig: Disable PHY time stamping by default.
Date:   Wed, 20 Jan 2021 20:06:03 -0800
Message-Id: <ffccb79afa227b0c61f4588a30b04dae21561434.1611198584.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1611198584.git.richardcochran@gmail.com>
References: <cover.1611198584.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NETWORK_PHY_TIMESTAMPING configuration option adds overhead into
the networking stack.  When enabled, all transmitted and received
frames are subjected to extra tests to determine whether they just
might be PTP frames to be presented to esoteric PHY time stamping
drivers.

However, no System on Chip, least ways not the axm55xx SoC, includes
such a PHY time stamping device.  Disable the unneeded option by
default.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 arch/arm/configs/axm55xx_defconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/configs/axm55xx_defconfig b/arch/arm/configs/axm55xx_defconfig
index 46075216ee6d..2d1a45066649 100644
--- a/arch/arm/configs/axm55xx_defconfig
+++ b/arch/arm/configs/axm55xx_defconfig
@@ -73,7 +73,6 @@ CONFIG_INET_AH=y
 CONFIG_INET_ESP=y
 CONFIG_INET_IPCOMP=y
 # CONFIG_IPV6 is not set
-CONFIG_NETWORK_PHY_TIMESTAMPING=y
 CONFIG_BRIDGE=y
 # CONFIG_WIRELESS is not set
 CONFIG_DEVTMPFS=y
-- 
2.20.1

