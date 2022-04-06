Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19A14F5F1E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiDFNRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiDFNRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:17:11 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7287B4E7D9B
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 02:54:59 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso1256515wmz.4
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 02:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CbfdQljtBRI4AGprJG6OXl+Pjrib6fd5ZiwjaoJH3k8=;
        b=N3beteOEDJUgzS9pWNKTRH2D8hPb1AtSqhDoPaK//YpEKGsJF11BrcbaWzNV0T3QNk
         Qw00M5NkenwHDDCtDwXaZcXPnOyS4NDvQBF/Y/3B/rnBo7wl8EWXJqBPcvpkTIdMOLej
         L43D+QP8cILvtvYk9SDbakLUXlxD+0BsMnp3dfRfuQ3p6JgewrcDLF7vVnMcLYTKfTdS
         56W6TGMoG2dBSrrCyzesLmbMNKZd6y7W69zjORvYUrbCTwaDHP1ucvOLkV+8yKHtFqzj
         RvpBFAchG0DK3T1tRWu0us72RzCgVyKRpxVw1w93MgcVEjMcKHR7daKZCgmGtsRZqJwS
         0ptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CbfdQljtBRI4AGprJG6OXl+Pjrib6fd5ZiwjaoJH3k8=;
        b=CTwKCfy8MpnFimoQRcKcH3nJqDwc3/7vPFfm9LtjucBYiVhg2/TU2MiU8cCTXm724t
         e1qoyUcHeC32bkCtW1e5xrKpGT9XViCmxG+KsW5s3EgpLVROc1GQdHBQ4UnzC7X0UIUy
         B4VEjiQWTwFcJZR2nE1FpQWFGRtxTJz/ys+95c+PI2U5LgoaxNnUALd+x0yALwq+qk0H
         gCARAyfR6d0z+KvLQJG6YqOPCwbK/tUUYxbpXoV5sXvgUwKib0OtGMwmggOZvcAXjbB4
         Ww3ebZ7p5rG2FI7UZGS0KSQIpR0m+5sr150YPZ9R44hBLzO0uDaKXM5FHPrJjzfGTC7P
         FCtA==
X-Gm-Message-State: AOAM532WkcShTZO/FOyFXB3NhtvyRo7vL7CtVYEkAGKZP41AE2osdHWH
        g7RIvixcKYnZ8ZabTVzrf3mW41Pb4bwCSg==
X-Google-Smtp-Source: ABdhPJyg4GFvvKaZUuYg6NHacYIMtyXIZQs+fapgADEwIpunDFphR+V/dhl3Iy98tvvyEvifI0syDw==
X-Received: by 2002:a05:600c:6004:b0:38c:6c00:4316 with SMTP id az4-20020a05600c600400b0038c6c004316mr6866048wmb.6.1649238783065;
        Wed, 06 Apr 2022 02:53:03 -0700 (PDT)
Received: from gojira.dev.6wind.com ([185.13.181.2])
        by smtp.gmail.com with ESMTPSA id f18-20020a5d6652000000b001e669ebd528sm13874604wrw.91.2022.04.06.02.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 02:53:02 -0700 (PDT)
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, intel-wired-lan@osuosl.org,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net v2 1/2] ixgbe: fix bcast packets Rx on VF after promisc removal
Date:   Wed,  6 Apr 2022 11:52:51 +0200
Message-Id: <20220406095252.22338-2-olivier.matz@6wind.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406095252.22338-1-olivier.matz@6wind.com>
References: <20220406095252.22338-1-olivier.matz@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a VF requested to remove the promiscuous flag on an interface, the
broadcast packets are not received anymore. This breaks some protocols
like ARP.

In ixgbe_update_vf_xcast_mode(), we should keep the IXGBE_VMOLR_BAM
bit (Broadcast Accept) on promiscuous removal.

This flag is already set by default in ixgbe_set_vmolr() on VF reset.

Fixes: 8443c1a4b192 ("ixgbe, ixgbevf: Add new mbox API xcast mode")
Cc: stable@vger.kernel.org
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 7f11c0a8e7a9..8d108a78941b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1184,9 +1184,9 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 
 	switch (xcast_mode) {
 	case IXGBEVF_XCAST_MODE_NONE:
-		disable = IXGBE_VMOLR_BAM | IXGBE_VMOLR_ROMPE |
+		disable = IXGBE_VMOLR_ROMPE |
 			  IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
-		enable = 0;
+		enable = IXGBE_VMOLR_BAM;
 		break;
 	case IXGBEVF_XCAST_MODE_MULTI:
 		disable = IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
-- 
2.30.2

