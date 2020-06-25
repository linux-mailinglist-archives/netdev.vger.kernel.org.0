Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C87920981E
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 03:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389232AbgFYBPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 21:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388789AbgFYBPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 21:15:32 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB04C061573;
        Wed, 24 Jun 2020 18:15:32 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l12so4262382ejn.10;
        Wed, 24 Jun 2020 18:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9txV8+UtsunFOrtoLHdutZEHp1eFB9eS+2lRDtAa+AQ=;
        b=Ipb/T+/PQOD8iEc2mPWVFz+T7ZJoH0CNlpXb0xtSG+/h26isdhnuwb0MwgLZGL6DIY
         NlQXwWf3+zuFZ4zppV8gATYnGYlJpMM/GB3ohBb7to54kzYfnxFM71vxhBTkqoMceL6O
         A9zU6HmJonH1mBmZuP7ntcT9WekPHvuf3HVV8CkshwdqWY0jTEyGrBGMEBn8VURbqY28
         uyJouK6DKakDtRsYhc2fE7yEYiX87O1RLQsVnWslMgUs3axEjJAge1tH4PxzzGCz2bSt
         I1daD05UtisXQSBP50ERwbMk7anAuJIilbOIKO3nTjYIyQQ/ErSpje1QRSntanpXNvF1
         VKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9txV8+UtsunFOrtoLHdutZEHp1eFB9eS+2lRDtAa+AQ=;
        b=Mku8Y/zoRAjSOScAozZ/kXa4NEiAxoOOu8aCl5xhwh4KiZgFeBtjxgZF//9/XzDPxY
         YeP2UBilUAH2YXiIf6AuOerPEWEoU0twmgRbP5ybstCMcjE4Pu2ECD2PhW8zYjk52DD/
         P90LHUZ9Vp3oOjrRcgrCpGn//EIVOKlPgVRUfLLKZckHbKLg1PHKtTdfTUUoB3A8zWTM
         e3wV6T+BivXAaWIkFsHWZbmtF7ygKOmkMUO7n5YBCAVybksMKYAHOLQ673pHdVzCcmkG
         MwcmBlgQijPTUffDnmd8h3mHyHV1I6nqeBXP4fDvOFuym8Sz+tZnxpHvCjOrjtvs1dpv
         h/LQ==
X-Gm-Message-State: AOAM531TFtAZbskYx7twvjJt7zJhpcwfaBylmzhLgGVHwUDQKVIVfXkc
        Zv6snGZOQR5intCzqNlQ3uQ=
X-Google-Smtp-Source: ABdhPJx4qiBEPc216A9Npbe+ubBeAP7uHhlnHopJwmxpEBMcW14CiRpsucd4l6S8REzPEu7/2XtxLg==
X-Received: by 2002:a17:906:57da:: with SMTP id u26mr10714802ejr.157.1593047730793;
        Wed, 24 Jun 2020 18:15:30 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l24sm16080423ejb.5.2020.06.24.18.15.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jun 2020 18:15:29 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 2/3] net: bcmgenet: use __be16 for htons(ETH_P_IP)
Date:   Wed, 24 Jun 2020 18:14:54 -0700
Message-Id: <1593047695-45803-3-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593047695-45803-1-git-send-email-opendmb@gmail.com>
References: <1593047695-45803-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 16-bit value that holds a short in network byte order should
be declared as a restricted big endian type to allow type checks
to succeed during assignment.

Fixes: 3e370952287c ("net: bcmgenet: add support for ethtool rxnfc flows")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index f1fa11665319..c63f01e2bb03 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -610,8 +610,9 @@ static int bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
 {
 	struct ethtool_rx_flow_spec *fs = &rule->fs;
 	int err = 0, offset = 0, f_length = 0;
-	u16 val_16, mask_16;
 	u8 val_8, mask_8;
+	__be16 val_16;
+	u16 mask_16;
 	size_t size;
 	u32 *f_data;
 
-- 
2.7.4

