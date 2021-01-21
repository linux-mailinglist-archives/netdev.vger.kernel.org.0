Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEA22FE062
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbhAUEHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbhAUEGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:06:50 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAB4C0613ED;
        Wed, 20 Jan 2021 20:06:09 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 11so734644pfu.4;
        Wed, 20 Jan 2021 20:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EGNpPEaAZpjchbtN5ftgX7ECKSLHxDYAbQnFlmBO7DQ=;
        b=pRLpnkc4pCp6AUbIuLnk/e6ZgTkOMu9hiOPtGua5lQx75J73QaspjkAu1+BM/Ec4FH
         bUn1o+w5/N9HXPERSsgORFBPkw1l8dq/EvST3SD1T1AqBEovxkI10wH58qHRV55DvpeZ
         LAB15ulXkvMPmsUnJ93E9nHkBXwxjBU+QhCnLOF2nzQvQntKZgVMKY3SZtOmtDvYB1br
         LLRb3dX7TAuA2qO52ptTeaS8TZgKd1TPxHI6Eo838qeBOhHEUqnLGF5qM7ohWFQUrlvP
         aQ7YCYEmK1GUY0oj+wRVoIJU80OTG2+2scnj5r5PZrfXF3TTiXAVjhk5II4f7PgpbBwV
         y4MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EGNpPEaAZpjchbtN5ftgX7ECKSLHxDYAbQnFlmBO7DQ=;
        b=ks0VSNh4u+x0zJx1OOD5TwKN4alftlxWEiCl9YMECh585wKUACTfsxpC77sIj5cY2D
         o/DmkEveYLoxr8NRuJ+QsOxNiLRhFNv8O+L+sSPeuoOU6bhKC3s7ZZv7Zp8ft0cEGtAB
         LkmVjwRaiDZdimAQe+eaUglC3jKcMR24480YuYfjxlnTI3PHbTXlbZCTsW9T8sBn2kEv
         t8qe5FdPWNxhambh0FvWFqr0WiUeT7rkGoedDTvXOQwF5wWOYjMjh2tD3BZOKg+EEQcK
         qXH5IraEWmmrkZCCBZW1/qqFxc9RY4PlE+7wV9bS7KWAu1iPFy83Ih4u13LQimeTk1YZ
         Gm7g==
X-Gm-Message-State: AOAM531U+NKSMKAgjoFiJyOif+skHXUt5i3HVQ6dyPYueTlAqRJL3dpS
        +s3UjlHFi21AyciAfY038U/JdLpEMLI=
X-Google-Smtp-Source: ABdhPJyQgPx5ZJ6Di8EYfs8mILdeTZuCwz0GgsxYtOZnz/I17TifScmq0qOlOYux9x+b572n1c5JRw==
X-Received: by 2002:a62:35c6:0:b029:1ba:e795:d20e with SMTP id c189-20020a6235c60000b02901bae795d20emr5774210pfa.37.1611201968564;
        Wed, 20 Jan 2021 20:06:08 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id f24sm3808567pjj.5.2021.01.20.20.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:06:07 -0800 (PST)
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
Subject: [PATCH net 1/4] net: dsa: mv88e6xxx: Remove bogus Kconfig dependency.
Date:   Wed, 20 Jan 2021 20:06:00 -0800
Message-Id: <ad52391dba15c5365e197aea54781037a1c223c7.1611198584.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1611198584.git.richardcochran@gmail.com>
References: <cover.1611198584.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6xxx is a DSA driver, and it implements DSA style time
stamping of PTP frames.  It has no need of the expensive option to
enable PHY time stamping.  Remove the bogus dependency.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Fixes: 2fa8d3af4bad ("net: dsa: mv88e6xxx: expose switch time as a PTP hardware clock")
---
 drivers/net/dsa/mv88e6xxx/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index 51185e4d7d15..b17540926c11 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -25,7 +25,6 @@ config NET_DSA_MV88E6XXX_PTP
 	default n
 	depends on NET_DSA_MV88E6XXX_GLOBAL2
 	depends on PTP_1588_CLOCK
-	imply NETWORK_PHY_TIMESTAMPING
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
 	  chips that support it.
-- 
2.20.1

