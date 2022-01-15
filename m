Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9335648F88A
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 18:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiAORth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 12:49:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232128AbiAORtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 12:49:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642268975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5Ub1hbMwAGMv83XYOlhCXiwUBfOTPfG3vBCU3vhpmD4=;
        b=bcQiEvYtgQRLWOgOqSvqtKaNu5prUQInnJLlYC0mb7dgS0hLPwO8WtC8lVEkw/7l6+GN25
        ql54LDYV6xJVcQA8gBSSnYTFfcITHaXF0tRptPN1l1HTvyQp9gzpp1rVOOHCrE/tvJB+g7
        uj6TdLGBq+ntb+GJb02ojMTYu4pDfs8=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-G-wzdqq3MdGBi3ZXQ7YAVQ-1; Sat, 15 Jan 2022 12:49:33 -0500
X-MC-Unique: G-wzdqq3MdGBi3ZXQ7YAVQ-1
Received: by mail-oi1-f199.google.com with SMTP id k64-20020acaba43000000b002c8994ca6a3so8572018oif.15
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 09:49:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Ub1hbMwAGMv83XYOlhCXiwUBfOTPfG3vBCU3vhpmD4=;
        b=D49geYMqd1iPSP5kSAQCLUVr2fMrockQ9Cawjvv9RyX4aRxNXSjf4eYG2LJspWcjXo
         sphjNGeykFcOuXeI+9i384pZ64Ggdax/sRh6CxyST5HR72TbNZ427ierB7pNEUX0s1vM
         bwy37zY8Z3bvnIcz1txOvvpkpYcnHTEJdb1aHOz1N/TBQdZCuc9D80CVKMNpEBxUkSF6
         f6Au1M06SNUy3ETcgTOPLSvVA7LMlTzNREY9Hs3ItGo/gASCabjR5Bcc9vg59KIMavSy
         M7hGV/nF1MxIhnrboKpidxD9Ews5Lruwtobo/nKtwAmA8SJ5dYczm4jRtHob1YEqUFix
         zEwQ==
X-Gm-Message-State: AOAM532M+oq3JPnEQAiJnKvmypjCJGe2JtNOchPu7c7m2wug8WyrInKb
        IBWQbok0Y4hJ3A9G6V+q4Vwc1qK0w4MnJlvK3Hzl15ji0vUXGx44Slt92FQ1Oucj6TUqlDkVD23
        7+ZQO0+A4fVifMk0r
X-Received: by 2002:a9d:6d90:: with SMTP id x16mr10349768otp.104.1642268973023;
        Sat, 15 Jan 2022 09:49:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxR+KmHmEAcU1CSZCeT7bkPUleD6/z8y+Ucc7A0A1vb7OVK0PdYFegZBJKcQW1fj3jjvlhqdQ==
X-Received: by 2002:a9d:6d90:: with SMTP id x16mr10349749otp.104.1642268972841;
        Sat, 15 Jan 2022 09:49:32 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id w20sm3239438oti.69.2022.01.15.09.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 09:49:32 -0800 (PST)
From:   trix@redhat.com
To:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, nathan@kernel.org, ndesaulniers@google.com,
        opensource@vdorst.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] net: ethernet: mtk_eth_soc: fix error checking in mtk_mac_config()
Date:   Sat, 15 Jan 2022 09:49:18 -0800
Message-Id: <20220115174918.297002-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this problem
mtk_eth_soc.c:394:7: warning: Branch condition evaluates
  to a garbage value
                if (err)
                    ^~~

err is not initialized and only conditionally set.
So intitialize err.

Fixes: 7e538372694b ("net: ethernet: mediatek: Re-add support SGMII")
Signed-off-by: Tom Rix <trix@redhat.com>
---
v2: change to initializing

drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b67b4323cff08..f02d07ec5ccbf 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -267,7 +267,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 					   phylink_config);
 	struct mtk_eth *eth = mac->hw;
 	u32 mcr_cur, mcr_new, sid, i;
-	int val, ge_mode, err;
+	int val, ge_mode, err = 0;
 
 	/* MT76x8 has no hardware settings between for the MAC */
 	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&
-- 
2.26.3

