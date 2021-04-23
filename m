Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB7A368C83
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240786AbhDWFWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240550AbhDWFWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:22:01 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B81C06174A;
        Thu, 22 Apr 2021 22:21:25 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s20so8835927plr.13;
        Thu, 22 Apr 2021 22:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gg/rWc1cINoL2FH5CJEjCow0QyQU7jLI6ek3affIyww=;
        b=mVfonw9+g2aQXAAo6MdpHMUX05//o0mlrwM168LRxmOEU7Hj5nBFXMbwlFeS+XBWGG
         a6v3Qh91kRjJHP+9SKYN9FlBcqINPt+2vnqZlU27MJ4cLtIs17lYtUTptCoZtSdUFVRF
         A+wyQ2omVIrFTfBRjHgWXQbmG3+RSnBjjQIkVkekW8qoMIaTyw9KzKIF3ILq/kfBoz35
         w3XphpbYiImmn2aEKJNlEg1cgzrtaXtFnkUsClO4Fq3uGv922YCYuLz0UNzLwxBeeVVg
         M0GslZ8/22jMbuz46w6tt1NVYRhQ0e/t7tObcDBeN2J/QYvULdb8cSsDoqvhFn4ur203
         0TBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gg/rWc1cINoL2FH5CJEjCow0QyQU7jLI6ek3affIyww=;
        b=mEyoqEq5663PLV+n6PbqGK0bslFoYoqIhvS98YNO4Jck//a+AhM5xjPeVC1jjXHrWj
         GV3npnfLah9FY5bYkwbvyNvgKY/VDSQ+Y4kA8Uf+tHXuWFaXfyp9w2U/0hkypMg2ha/5
         Rp6ZFo7PoQ6QHbLy7dGczFtPu8QLzvy/iNF1K+YPL349PYvu88wCsjJ7KopENn5anFVj
         uW/IWPMHr+x6cqLP/j9yagdt0wYHQ8Ld51S6rp2S99q6EU3T7TrnP0YjKzyxNWvBhayc
         V1ZpopXaZqRwXRILwYy1RhY5nlzo9Gcy8NNHWy537Cng/BYdIA5W2Ka/abQNzybcY65j
         Ux6A==
X-Gm-Message-State: AOAM531UaPBSOnzdLrkxR2EVq6vdInMOvoKSgCkcOEKeWj3tWWfQjqQs
        jWzvllw5Z1zMOx2y/ghtx1I=
X-Google-Smtp-Source: ABdhPJxAVghnaX081IZtbsM8hmJXe+URl3wx1vFIBP0POUNj0vLcd2sYlm6nrYC/A+GuYl8TXNLOyA==
X-Received: by 2002:a17:902:109:b029:ec:9f64:c53d with SMTP id 9-20020a1709020109b02900ec9f64c53dmr2003503plb.83.1619155285132;
        Thu, 22 Apr 2021 22:21:25 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:24 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next v2 08/15] net: ethernet: mtk_eth_soc: increase DMA ring sizes
Date:   Thu, 22 Apr 2021 22:21:01 -0700
Message-Id: <20210423052108.423853-9-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

256 descriptors is not enough for multi-gigabit traffic under load on
MT7622. Bump it to 512 to improve performance.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 83883d86b881..540a5771b7bf 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -22,7 +22,7 @@
 #define MTK_MAX_RX_LENGTH	1536
 #define MTK_MAX_RX_LENGTH_2K	2048
 #define MTK_TX_DMA_BUF_LEN	0x3fff
-#define MTK_DMA_SIZE		256
+#define MTK_DMA_SIZE		512
 #define MTK_NAPI_WEIGHT		64
 #define MTK_MAC_COUNT		2
 #define MTK_RX_ETH_HLEN		(ETH_HLEN + ETH_FCS_LEN)
-- 
2.31.1

