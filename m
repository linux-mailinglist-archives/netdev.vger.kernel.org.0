Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75D768FD44
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjBICpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjBICof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:44:35 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C2D305E5;
        Wed,  8 Feb 2023 18:42:30 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 78so693087pgb.8;
        Wed, 08 Feb 2023 18:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YwyVoI4Z6gSEgdiik3NvZJTmr5o1kD+IT2yiCTwHCu4=;
        b=dD+5Wo8qKJ+aYIFvRi2FocY3k8H1Y47OfiqwD3r8eJ1Kzc5icSgAMNxDdaFnA4Qegl
         wIpncp6VGKKL7/uiI/T93YnnO41JK1FC2LWZ54liJhZPe11aGXMydfgMQyD+UKCelUzM
         cci0afAQSaUOFGiSEz6rga66CznxgWZXb+OJ/ugK9cXCJUmkednXa3meKnhGsh4hNaxP
         60LP+y6Um0vNYThUDyoK6HBp9nvzJ7UyLU6nPd3MdoLFoFhYrFjus8EbbtMxKTCq8etg
         qUzTeOrg8B+kxFXaOnv2l1e0VmCAkEp3WyDwjmjzvCo+4gIPatuy7L7HW4GJ8FREV/CZ
         17Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YwyVoI4Z6gSEgdiik3NvZJTmr5o1kD+IT2yiCTwHCu4=;
        b=y+ixJinolDsWhDexdw8Uc4LqzjoMMtkQUNIzZbwHwsWHyqdCRQZn12zPLBC9MT+s9b
         IPXg3QNlTX+7gGSQxkXpovxykkQnvGKx+kc0jJdcUW6coaEK3JlPy8fMPF2pS7shvPWX
         2gz556aV1FtlJWBd0EKJIeqA/Sbdo5RjKOLiHufzBxgCNfGJyzIWy76HWnaDg3zRo7Ch
         osPw3/SsMgoc1O8ftmdhM/lHbBYOhAugw3tZLtyK5DzYecYTN5bg+bv2m+9Gjo9xbk6B
         mu3ZeZgVSFpZTT038UM3K0cl0CYgnqnd4OF3j3UgWxblhM0qH0jsLqaficLU04EHHoe5
         GCLA==
X-Gm-Message-State: AO0yUKV3frPT6BL56os2JNMhtvCaTSmc0ukO+Uz14wATHA5FWhW9AbWG
        mVnx1ceEKF4I1t7zqoBvgC4=
X-Google-Smtp-Source: AK7set9DUTP8YMTdiY3P82E80fZ2YE4bBm5y04IAl6FhAq6TRgHtyLSB+KIbFsz0H7dafUNupr3/nA==
X-Received: by 2002:aa7:8bdd:0:b0:5a8:5424:d12f with SMTP id s29-20020aa78bdd000000b005a85424d12fmr646119pfd.21.1675910539477;
        Wed, 08 Feb 2023 18:42:19 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id f15-20020aa782cf000000b005a84de344a6sm165538pfn.14.2023.02.08.18.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 18:42:19 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     alexander.duyck@gmail.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net v2 3/3] ixgbe: add double of VLAN header when computing the max MTU
Date:   Thu,  9 Feb 2023 10:41:28 +0800
Message-Id: <20230209024128.4695-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Include the second VLAN HLEN into account when computing the maximum
MTU size as other drivers do.

Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
v2: add reviewed-by label.
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index bc68b8f2176d..8736ca4b2628 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -73,6 +73,8 @@
 #define IXGBE_RXBUFFER_4K    4096
 #define IXGBE_MAX_RXBUFFER  16384  /* largest size for a single descriptor */
 
+#define IXGBE_PKT_HDR_PAD   (ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+
 /* Attempt to maximize the headroom available for incoming frames.  We
  * use a 2K buffer for receives and need 1536/1534 to store the data for
  * the frame.  This leaves us with 512 bytes of room.  From that we need
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 25ca329f7d3c..4507fba8747a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6801,8 +6801,7 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	if (ixgbe_enabled_xdp_adapter(adapter)) {
-		int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
-				     VLAN_HLEN;
+		int new_frame_size = new_mtu + IXGBE_PKT_HDR_PAD;
 
 		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
 			e_warn(probe, "Requested MTU size is not supported with XDP\n");
-- 
2.37.3

