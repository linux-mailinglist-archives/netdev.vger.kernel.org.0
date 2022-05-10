Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6814C520B96
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbiEJDB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiEJDB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:01:58 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6241C12EA
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 19:58:02 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id x12so13546782pgj.7
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 19:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=NZZ82RuTuLU0y4qSq6oZ1tvwJHTTQ/f+mHzydS1us5Y=;
        b=mRBr+CyEVHK15AsW4cOz4ozfjZAmFjblYgAmkKCw15ZhQpmKaiKVCASBFC5bK7Qh4A
         6vRNTMVYUfNKgMRGnuMwTuCivv58jRMd0Ev19tdiOpXz1BYmLJM54e6r3wav82IXAQhM
         3cLgM1G/3/R5cs5RuZfX75Ymu07slccwTyPF/hEg1SP7t7zEpz9UhY5Kic2XdXK83Hhp
         Ql6le4gX+TB+PyEDdKP3Q/xaBTUuaJEf5whflNXSsuYRIBEFuqwP39hDeEPVPf4CZdYW
         3BGcmVe+vQstmiua5QzDqfcAzrxl6WKdU1Lx7qK+mcDVYuwm7wX6TcHYCU5Kmg6PzXrK
         tS0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NZZ82RuTuLU0y4qSq6oZ1tvwJHTTQ/f+mHzydS1us5Y=;
        b=ISxoKh3nxLJ6i4nlJus0Wsydsgj+McPkq2fLL9DMxAvXeaO+X8vsxcC6FzCdcifzGG
         VyR95tTXqA/dkN+nfsohcxrLaoVgJ0w0YXELCLRHxcgIaiOuWODOhPg6+YJL81c9ePSK
         lo1bo7vUUWNwQkOZVvG/78wVerBddTFFvFj5x7XGU9K9SIay9a0+nwbxPUlBk5f3VMxq
         gCJM2RDTJyf1Tblh3WkctGKxWGEIvmp6TX/f1AmCUW74SJFUUB8JIBAXabmSXoWmjdcI
         GlcILFhX8dVWgZ3mRk3wbUqcwVS9KshZp7hCHfHUlyVXlqB8d+zuSwYsZwvp8UfvyxDL
         SsYQ==
X-Gm-Message-State: AOAM5302/HFlqmsXYA/IAgigd8+oF59NlbeJhmvFr0Pstufs4XpYZAgS
        bYbjLnOUQ5oKpLH+vcw0Q6M=
X-Google-Smtp-Source: ABdhPJzYihZv7mlkMJA7ZbDkWql/wlgvhE+WWQ0e8yZEgpgkYD522wD0F5eOKp0JK2pDnAIe1sUWfg==
X-Received: by 2002:a63:2002:0:b0:3c6:ae77:1869 with SMTP id g2-20020a632002000000b003c6ae771869mr7242455pgg.71.1652151482419;
        Mon, 09 May 2022 19:58:02 -0700 (PDT)
Received: from localhost.localdomain ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id a206-20020a621ad7000000b0050dc762813dsm9356304pfa.23.2022.05.09.19.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 19:58:02 -0700 (PDT)
From:   xiaolinkui <xiaolinkui@gmail.com>
X-Google-Original-From: xiaolinkui <xiaolinkui@kylinos.cn>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH] igb: Convert a series of if statements to switch case
Date:   Tue, 10 May 2022 10:57:55 +0800
Message-Id: <20220510025755.19047-1-xiaolinkui@kylinos.cn>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linkui Xiao<xiaolinkui@kylinos.cn>

Convert a series of if statements that handle different events to
a switch case statement to simplify the code.

Signed-off-by: Linkui Xiao<xiaolinkui@kylinos.cn>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 34b33b21e0dc..4ce0718eeff6 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4588,13 +4588,17 @@ static inline void igb_set_vf_vlan_strip(struct igb_adapter *adapter,
 	struct e1000_hw *hw = &adapter->hw;
 	u32 val, reg;
 
-	if (hw->mac.type < e1000_82576)
+	switch (hw->mac.type) {
+	case e1000_undefined:
+	case e1000_82575:
 		return;
-
-	if (hw->mac.type == e1000_i350)
+	case e1000_i350:
 		reg = E1000_DVMOLR(vfn);
-	else
+		break;
+	default:
 		reg = E1000_VMOLR(vfn);
+		break;
+	}
 
 	val = rd32(reg);
 	if (enable)
-- 
2.17.1

