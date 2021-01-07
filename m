Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765D42ED646
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 19:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbhAGSBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 13:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbhAGSBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 13:01:52 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B21C0612F8
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 10:01:11 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id x20so16558427lfe.12
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 10:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iniSHMwz5ezyvqR1cNjv8cElQ7Ohce9OqSkDTsr2fC4=;
        b=NVaDusuqmrXY4tKTfxBuT4gum6V9i1oxM/MgU22HhZZJWSEGoV5WkIqi/2W+AmBGoP
         fudFb8ipKwQM53aDlC7aNdvUjqwmT96H4i2I63Xp8qEH6XTMM6+CUZRT4te4gNc7Lv+5
         NEsu0+sFxCgDsEFncnuI5DkMqzjdSV+eLeEqrCSV6NbLZGmYZRM5wJU9YKjnyN/k+Rhs
         2I961IH1IRo5j5YkmujJ5X1Txh6XAmLLg8jm09XAHVO4wxOXx8APRERczkxHAld/QUzf
         +zMIcg9Y6sqVKlM5utS7/TPs4z0om/sQgEmueLdAUSwJuf/qIXiDxU2TVGCszq+tlSgD
         Lmyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iniSHMwz5ezyvqR1cNjv8cElQ7Ohce9OqSkDTsr2fC4=;
        b=fPCST1i15F9r/99cZDDKnTd4VAdtqJlZtr3rq35+qWYaDqH4UZS/ooo4xUHR28pd0K
         oEPzIPhvmbomraHyhcX9h/hB9XK5UiHMwcS7CU+BjKTQOft7Wbs3rHuLXsEiGMCna6re
         3phyv6rzPjHa90demSZGXwbHDDu1FORuGZOhQSSWtcSPFj5vfCWVXhkYNtzDTMiz4wLn
         Szmlq6WpViEFP9y7Ni5+SrPy92l4VZ1A6oWHpC0IGr0NXX+WNLSk2aZLsArcFrUVE2Z7
         BNkcYk4M3hRe/0FLV+/mJsc5fw+rSOGnqd9GnpdtWsgcpzGXK/0utqdMbr1Kr5LGtxrt
         1Ytw==
X-Gm-Message-State: AOAM533zbjRDv0thIr4fjgKMCYqRrZrBYsRgb4xAv8GM6StGlWp7nT+W
        0Ehxw9pHG9p8LlEuUOs0FBo=
X-Google-Smtp-Source: ABdhPJw6P5Ljj8aE1MxWQ4LVE5pKyMgSNfURsVoI/JsbzO4fWXZnRPWVASKNFquSCVynlw7Gq9nIXA==
X-Received: by 2002:a19:797:: with SMTP id 145mr4248760lfh.651.1610042469973;
        Thu, 07 Jan 2021 10:01:09 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id c198sm1299065lfg.265.2021.01.07.10.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 10:01:09 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Timur Tabi <timur@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net-next 3/3] MAINTAINERS: add bgmac section entry
Date:   Thu,  7 Jan 2021 19:00:51 +0100
Message-Id: <20210107180051.1542-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107180051.1542-1-zajec5@gmail.com>
References: <20210107180051.1542-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This driver exists for years but was missing its MAINTAINERS entry.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3de86229b17c..00fc1d5a9f18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3659,6 +3659,15 @@ N:	bcm88312
 N:	hr2
 N:	stingray
 
+BROADCOM IPROC GBIT ETHERNET DRIVER
+M:	Rafał Miłecki <rafal@milecki.pl>
+M:	bcm-kernel-feedback-list@broadcom.com
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/brcm,amac.txt
+F:	drivers/net/ethernet/broadcom/bgmac*
+F:	drivers/net/ethernet/broadcom/unimac.h
+
 BROADCOM KONA GPIO DRIVER
 M:	Ray Jui <rjui@broadcom.com>
 L:	bcm-kernel-feedback-list@broadcom.com
-- 
2.26.2

