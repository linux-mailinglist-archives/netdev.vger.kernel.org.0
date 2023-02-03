Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894F2688C97
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 02:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjBCBdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 20:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBCBdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 20:33:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568F4841A0;
        Thu,  2 Feb 2023 17:33:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E965261D4B;
        Fri,  3 Feb 2023 01:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6580C433D2;
        Fri,  3 Feb 2023 01:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675388029;
        bh=bjDwmYYIor+YSh/XeUJiaj8ABWRiVuYnCU4UAHUmbfY=;
        h=Date:From:To:Cc:Subject:From;
        b=agtOjEulK8eS408HbFj/8bKSMzpQ4Rpa/cpGLvmeZCCI8WR83tO+WPeQeblDK65IP
         gvFFTeVERlV00bWOyzltUr8n9Pzdfce1qaLgc5k0DYSfY+qjLXMLvL7W65kZd6S5Qd
         gO3D+WwOtRVwUl/EZaK1RqBISr8jp0ERvWh3hZ3rt+Kp76uPXco3SwikAwNinJHib7
         tJXiDGyq4kZDi+LFTHQOnzyC0EyAsgKWC5ptdJTr6WbnfsXGIli7Oxry/GYtKnQ3gE
         E7hbKwDonueSDqNIPvyKibYfBxmJmXWdnBfGBsqafGxxrNeR8UdyUyD1MWEbeDAo9w
         QRwhbuZ5MCTMg==
Date:   Thu, 2 Feb 2023 19:34:05 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] wifi: mwifiex: Replace one-element array with
 flexible-array member
Message-ID: <Y9xkjXeElSEQ0FPY@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One-element arrays are deprecated, and we are replacing them with flexible
array members instead. So, replace one-element array with flexible-array
member in struct mwifiex_ie_types_rates_param_set.

These are the only binary differences I see after the change:

mwifiex.o
_@@ -50154,7 +50154,7 @@
                        23514: R_X86_64_32S     kmalloc_caches+0x50
    23518:      call   2351d <mwifiex_scan_networks+0x11d>
                        23519: R_X86_64_PLT32   __tsan_read8-0x4
-   2351d:      mov    $0x225,%edx
+   2351d:      mov    $0x224,%edx
    23522:      mov    $0xdc0,%esi
    23527:      mov    0x0(%rip),%rdi        # 2352e <mwifiex_scan_networks+0x12e>
                        2352a: R_X86_64_PC32    kmalloc_caches+0x4c
scan.o
_@@ -5582,7 +5582,7 @@
                        4394: R_X86_64_32S      kmalloc_caches+0x50
     4398:      call   439d <mwifiex_scan_networks+0x11d>
                        4399: R_X86_64_PLT32    __tsan_read8-0x4
-    439d:      mov    $0x225,%edx
+    439d:      mov    $0x224,%edx
     43a2:      mov    $0xdc0,%esi
     43a7:      mov    0x0(%rip),%rdi        # 43ae <mwifiex_scan_networks+0x12e>
                        43aa: R_X86_64_PC32     kmalloc_caches+0x4c

and the reason for that is the following line:

drivers/net/wireless/marvell/mwifiex/scan.c:
1517         scan_cfg_out = kzalloc(sizeof(union mwifiex_scan_cmd_config_tlv),
1518                                GFP_KERNEL);

sizeof(union mwifiex_scan_cmd_config_tlv) is now one-byte smaller due to the
flex-array transformation:

  46 union mwifiex_scan_cmd_config_tlv {
  47         /* Scan configuration (variable length) */
  48         struct mwifiex_scan_cmd_config config;
  49         /* Max allocated block */
  50         u8 config_alloc_buf[MAX_SCAN_CFG_ALLOC];
  51 };

Notice that MAX_SCAN_CFG_ALLOC is defined in terms of
sizeof(struct mwifiex_ie_types_rates_param_set), see:

  26 /* Memory needed to store supported rate */
  27 #define RATE_TLV_MAX_SIZE   (sizeof(struct mwifiex_ie_types_rates_param_set) \
  28                                 + HOSTCMD_SUPPORTED_RATES)

  37 /* Maximum memory needed for a mwifiex_scan_cmd_config with all TLVs at max */
  38 #define MAX_SCAN_CFG_ALLOC (sizeof(struct mwifiex_scan_cmd_config)        \
  39                                 + sizeof(struct mwifiex_ie_types_num_probes)   \
  40                                 + sizeof(struct mwifiex_ie_types_htcap)       \
  41                                 + CHAN_TLV_MAX_SIZE                 \
  42                                 + RATE_TLV_MAX_SIZE                 \
  43                                 + WILDCARD_SSID_TLV_MAX_SIZE)

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/252
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/fw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 9616bd8b49f1..8c7c744683bc 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -794,7 +794,7 @@ struct mwifiex_ie_types_chan_band_list_param_set {
 
 struct mwifiex_ie_types_rates_param_set {
 	struct mwifiex_ie_types_header header;
-	u8 rates[1];
+	u8 rates[];
 } __packed;
 
 struct mwifiex_ie_types_ssid_param_set {
-- 
2.34.1

