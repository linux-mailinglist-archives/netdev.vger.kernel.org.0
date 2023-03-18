Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2EC6BFCFB
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 22:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCRVuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 17:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCRVuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 17:50:21 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E3522A38
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 14:50:20 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z21so33294263edb.4
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 14:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679176218;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQ/OuugHaDFUK6x/NpfGU5/ECDnZn1266LSaE4QX2T0=;
        b=M4thue192Nvm+ICFuKIgLkDMnzNGB2xR6AkoidObRdhTeoX5fLlQ2YA11ew9lrqaHt
         /SJ8U5HP6COjR03vsbkUKF8FkZxnvJgpJ0hJYYSLFWQm+2wuEp6OdSG7QS1DU4N+Mf8C
         CGjb40Y6utjpajzdcR83QxhGfqEsdP4oTZd7JClp3zfmN7gyHQkDNKxJ2QfDRwMBqHnq
         GsNIiVoKYq52wavGZp0mLSYZzC1wlbUnTET9tbIE+9FpqaSBN8eRs835FEsIw9DWLZn5
         HWAepGXzKsLYGPD4ZIZi2SiOCjjCRsygCFk8f6mzd/gBxjlkRBN1zGcfr2WW5mMlCl7u
         nXJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679176218;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KQ/OuugHaDFUK6x/NpfGU5/ECDnZn1266LSaE4QX2T0=;
        b=vAfvxTrUax/LVFz8y55vSla56Uf9uzsTI+wKCBCmlCMMLTLbuifhqrbuKdS91ELjrB
         L10zoSK+Rh7KSKO7KuhDzpdkXNUGI46Bsmc0OgVMI/7kco//yJIHIVikB3lZxwuLBi2F
         qmFGhlSHM3AteOUCgTadjCwBKemEuUdiJImzojt4WhcUEfuPXAmgkBh9xlqkLjmYwlP6
         EI7LQN75orCtzNTxSXBoxbbLvDfd46YQf9HSh8vIwoL9IDRzxJVfXgCS/TjtYWMHjJGQ
         YOwCD79qDBCrWu7pK+aKY1tE5r/73ei71pcPrFTbyRq8KjMl5uFsCIgi+9HyzxuFP0AO
         TwSg==
X-Gm-Message-State: AO0yUKXvHoum2xpUC+UANkkE0cXBIASjpNdWsEppw2kDTUUSWcEcjI2l
        Ce9n2Iz1JJ/8X/Hi/g1abok=
X-Google-Smtp-Source: AK7set9GCY28lZQfi+Lafy1BZemj7AOxfY86pplQB5Qu9c8mKa5A2jX2fq48Ca1acIR6Ndc7VSULNA==
X-Received: by 2002:a17:906:f6c6:b0:931:ad32:79ed with SMTP id jo6-20020a170906f6c600b00931ad3279edmr3719406ejb.12.1679176218384;
        Sat, 18 Mar 2023 14:50:18 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c073:a00:b51a:ddab:12c0:b88a? (dynamic-2a01-0c23-c073-0a00-b51a-ddab-12c0-b88a.c23.pool.telefonica.de. [2a01:c23:c073:a00:b51a:ddab:12c0:b88a])
        by smtp.googlemail.com with ESMTPSA id pv15-20020a170907208f00b0091ec885e016sm2569490ejb.54.2023.03.18.14.50.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 14:50:17 -0700 (PDT)
Message-ID: <d9aebd88-6cbb-259e-f9bc-008071f0ad5e@gmail.com>
Date:   Sat, 18 Mar 2023 22:50:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: consolidate disabling ASPM before EPHY access
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that rtl_hw_aspm_clkreq_enable() is a no-op for chip versions < 32,
we can consolidate disabling ASPM before EPHY access in rtl_hw_start().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 42 ++---------------------
 1 file changed, 3 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6563e4c6a..9f8357bbc 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2962,8 +2962,6 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) | PFM_EN);
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | PWM_EN);
 	rtl_mod_config5(tp, Spi_en, 0);
-
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8168f(struct rtl8169_private *tp)
@@ -3054,11 +3052,7 @@ static void rtl_hw_start_8168g_1(struct rtl8169_private *tp)
 	};
 
 	rtl_hw_start_8168g(tp);
-
-	/* disable aspm and clock request before access ephy */
-	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8168g_1);
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8168g_2(struct rtl8169_private *tp)
@@ -3076,9 +3070,6 @@ static void rtl_hw_start_8168g_2(struct rtl8169_private *tp)
 	};
 
 	rtl_hw_start_8168g(tp);
-
-	/* disable aspm and clock request before access ephy */
-	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8168g_2);
 }
 
@@ -3099,8 +3090,6 @@ static void rtl_hw_start_8411_2(struct rtl8169_private *tp)
 
 	rtl_hw_start_8168g(tp);
 
-	/* disable aspm and clock request before access ephy */
-	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8411_2);
 
 	/* The following Realtek-provided magic fixes an issue with the RX unit
@@ -3238,8 +3227,6 @@ static void rtl_hw_start_8411_2(struct rtl8169_private *tp)
 	r8168_mac_ocp_write(tp, 0xFC32, 0x0C25);
 	r8168_mac_ocp_write(tp, 0xFC34, 0x00A9);
 	r8168_mac_ocp_write(tp, 0xFC36, 0x012D);
-
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
@@ -3254,8 +3241,6 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 	};
 	int rg_saw_cnt;
 
-	/* disable aspm and clock request before access ephy */
-	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8168h_1);
 
 	rtl_set_fifo_size(tp, 0x08, 0x10, 0x02, 0x06);
@@ -3303,8 +3288,6 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 	r8168_mac_ocp_write(tp, 0xe63e, 0x0000);
 	r8168_mac_ocp_write(tp, 0xc094, 0x0000);
 	r8168_mac_ocp_write(tp, 0xc09e, 0x0000);
-
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
@@ -3343,8 +3326,6 @@ static void rtl_hw_start_8168ep_3(struct rtl8169_private *tp)
 		{ 0x1e, 0x0000,	0x2000 },
 	};
 
-	/* disable aspm and clock request before access ephy */
-	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8168ep_3);
 
 	rtl_hw_start_8168ep(tp);
@@ -3355,8 +3336,6 @@ static void rtl_hw_start_8168ep_3(struct rtl8169_private *tp)
 	r8168_mac_ocp_modify(tp, 0xd3e2, 0x0fff, 0x0271);
 	r8168_mac_ocp_modify(tp, 0xd3e4, 0x00ff, 0x0000);
 	r8168_mac_ocp_modify(tp, 0xe860, 0x0000, 0x0080);
-
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8117(struct rtl8169_private *tp)
@@ -3368,9 +3347,6 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
 	int rg_saw_cnt;
 
 	rtl8168ep_stop_cmac(tp);
-
-	/* disable aspm and clock request before access ephy */
-	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8117);
 
 	rtl_set_fifo_size(tp, 0x08, 0x10, 0x02, 0x06);
@@ -3420,8 +3396,6 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
 
 	/* firmware is for MAC only */
 	r8169_apply_firmware(tp);
-
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8102e_1(struct rtl8169_private *tp)
@@ -3544,8 +3518,6 @@ static void rtl_hw_start_8402(struct rtl8169_private *tp)
 
 static void rtl_hw_start_8106(struct rtl8169_private *tp)
 {
-	rtl_hw_aspm_clkreq_enable(tp, false);
-
 	/* Force LAN exit from ASPM if Rx/Tx are not idle */
 	RTL_W32(tp, FuncEvent, RTL_R32(tp, FuncEvent) | 0x002800);
 
@@ -3562,7 +3534,6 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 
 	rtl_pcie_state_l2l3_disable(tp);
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 DECLARE_RTL_COND(rtl_mac_ocp_e00e_cond)
@@ -3650,13 +3621,8 @@ static void rtl_hw_start_8125a_2(struct rtl8169_private *tp)
 	};
 
 	rtl_set_def_aspm_entry_latency(tp);
-
-	/* disable aspm and clock request before access ephy */
-	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8125a_2);
-
 	rtl_hw_start_8125_common(tp);
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8125b(struct rtl8169_private *tp)
@@ -3671,12 +3637,8 @@ static void rtl_hw_start_8125b(struct rtl8169_private *tp)
 	};
 
 	rtl_set_def_aspm_entry_latency(tp);
-	rtl_hw_aspm_clkreq_enable(tp, false);
-
 	rtl_ephy_init(tp, e_info_8125b);
 	rtl_hw_start_8125_common(tp);
-
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_config(struct rtl8169_private *tp)
@@ -3772,7 +3734,8 @@ static void rtl_hw_start_8169(struct rtl8169_private *tp)
 static void rtl_hw_start(struct  rtl8169_private *tp)
 {
 	rtl_unlock_config_regs(tp);
-
+	/* disable aspm and clock request before ephy access */
+	rtl_hw_aspm_clkreq_enable(tp, false);
 	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 
 	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
@@ -3783,6 +3746,7 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 		rtl_hw_start_8168(tp);
 
 	rtl_enable_exit_l1(tp);
+	rtl_hw_aspm_clkreq_enable(tp, true);
 	rtl_set_rx_max_size(tp);
 	rtl_set_rx_tx_desc_registers(tp);
 	rtl_lock_config_regs(tp);
-- 
2.39.2

