Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F33668AA49
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbjBDNhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbjBDNgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:36:51 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A99DE07C;
        Sat,  4 Feb 2023 05:36:45 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id m2so7898624plg.4;
        Sat, 04 Feb 2023 05:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lV+jIwfpIfjlKMz7MBn8qE6oOOJOfnotd/kmF+jUhhM=;
        b=YMsRv2WzJABVcHWfB8CthUOP1a1+ON3dEke2uXaOnLUc5PxwEBjlYxxUOhUbMBv4/w
         MoIXr4LmyB0eW0YOrUDdpTz3uJIkcHcZCC33DA2Uc4y7YA4oGcJANHOjWGUi2x5y4LCf
         Qpdpgr0j1rufoSGJKF95bdhpEZA4Zc1GyZ+34QVVXG1uMllzmZiPmrBF449GeBU02JqY
         1KsSq0OCVS+T0Cjhe/gVfgq2rKNYjbqk7uZDQJE4r9fqvsuPuO12NB945wFoNomj5gq3
         9/056OPoMhJXdty2jtW0CEJeRPqBIzln/7Xejjk7Cm8zr2Pi1TURmlYe7/Sg+xwUEVpn
         64Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lV+jIwfpIfjlKMz7MBn8qE6oOOJOfnotd/kmF+jUhhM=;
        b=tSxn2o1DJ1f8IKnfinNLCS0T5yAJExLjvkF5CPDJ0mowDo4BD9gb5u9CTx5IU49WHU
         Df5uG9TwN7uQImYJg+OI0q+dilOV+z+QYKP/AJCATigZQIs8XADVEYN3MjX9wXKVUmuo
         dUurt4c5gnzBPbN2RN6lCaOVbnG3DA4secQGxh09hwOFygjrn1VgHXI0+Gm8DV2r4iOG
         nxR2LYIjmh448R0OKIzII9zJM6d4HILAyKn0MqTZSUiEhBTk2/Grs1mjhiN8XzNPt91G
         BH+aC7PVCQfoVZleAOpQRINZgYVlBwxhRtV3Nt+KGCC8jTOV7+xVCVUOtAAzw7gSXil3
         2aaA==
X-Gm-Message-State: AO0yUKXTu62Zb0rktEPE+Giq1lqpY1cAOfRDwcxFlCxBAGwegrBQ9Bw0
        8JNZlOtVeAqySL58Su3frgIiAIYIa6KyNZwi
X-Google-Smtp-Source: AK7set/9hEnfAU/wUiFJkKlogYqRqEH5TU8hHEUI8KzdRglUpSEDpc8oVQlWd81BxyL5jGimaAn0qg==
X-Received: by 2002:a17:902:f243:b0:198:eaac:464a with SMTP id j3-20020a170902f24300b00198eaac464amr2858741plc.42.1675517804585;
        Sat, 04 Feb 2023 05:36:44 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([114.253.32.172])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c25500b0019605a51d50sm3463575plg.61.2023.02.04.05.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 05:36:44 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net 2/3] i40e: add double of VLAN header when computing the max MTU
Date:   Sat,  4 Feb 2023 21:35:34 +0800
Message-Id: <20230204133535.99921-3-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230204133535.99921-1-kerneljasonxing@gmail.com>
References: <20230204133535.99921-1-kerneljasonxing@gmail.com>
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

Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 2 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 60e351665c70..e03853d3c706 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -107,6 +107,8 @@
 #define I40E_BW_MBPS_DIVISOR		125000 /* rate / (1000000 / 8) Mbps */
 #define I40E_MAX_BW_INACTIVE_ACCUM	4 /* accumulate 4 credits max */
 
+#define I40E_PACKET_HDR_PAD (ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+
 /* driver state flags */
 enum i40e_state_t {
 	__I40E_TESTING,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 53d0083e35da..d039928f3646 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2921,7 +2921,7 @@ static int i40e_change_mtu(struct net_device *netdev, int new_mtu)
 	struct i40e_pf *pf = vsi->back;
 
 	if (i40e_enabled_xdp_vsi(vsi)) {
-		int frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+		int frame_size = new_mtu + I40E_PACKET_HDR_PAD;
 
 		if (frame_size > i40e_max_xdp_frame_size(vsi))
 			return -EINVAL;
-- 
2.37.3

