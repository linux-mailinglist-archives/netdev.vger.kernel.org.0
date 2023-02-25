Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CEA6A2BF4
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 22:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjBYVsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 16:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjBYVr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 16:47:59 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AE51990
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:49 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id k37so2010740wms.0
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gCW7PNbp1TQ75eLDJ0N6qAwIQwus+fQp1Mf718gWsF0=;
        b=nr2Ya1Ap0RpMwffZiQ582202zYZLI2VBAj+Sbm7R8QRS+wuJcjsJr18r4U/OiYEl4U
         iLHQXyt9O9mjZe9GdPOIaxeXLRAp6oXdvVoNEtxodEnQt9r/uwqnCOPL9T1nbx4rMNOv
         DbgvX5QeJi7mJfmSx2/HO8W/hwqSf/LrFN5JWhIVcaDMCCGQEOVEt9dl5BrZduqUM37E
         Z9dkhMsB4thkoHI55xfk2twXSsKscgAWfnFcBg39BVgBpDweW0Of7EJ4rVn+qEvyEejR
         hcAANsocUgZeQN4ITjlyhqJD9z9pKhni0RBAWreQPAi0U0b4D+tC0/wyO6WPEpqqM/SY
         P2OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gCW7PNbp1TQ75eLDJ0N6qAwIQwus+fQp1Mf718gWsF0=;
        b=xpk8NyK4RT1iuAsZFA0hKysqakOAXxCLs3LfsrfDBs2l5Bk7UqW6dszz3iJa/VnhKS
         VrshgkyZeapm7xa/N2wbqY79k74TCdg3PKnivjYaDdjW3vP8A8KBKUFTZUmoYoB8tSjq
         crZmVoPuycfoHaPWIo1FNklTXTd1CcMy/crK9bRR8q+YKTxIfvPoOzWKWPfk39J/s4vW
         +Y8m+QuEEWBYr8TWHtgMDYoR5rz2jYjs7Mll+SZRkLV3zRgfPmpkkG8MsZ12NQlCgW2b
         eSCSUCuCWCaOIcUX6X57FM86pD6b5DXWYw7QiOsoJLJu3Nr61Qn7TN2oWUsmHsyYNE2q
         OEZA==
X-Gm-Message-State: AO0yUKXHo3LOk359s1a7jJTzi4G9TVIRDDZPCFX8Lo6jiTY37DRFCPPm
        y1JVX1+V5BGv63O2SMfFfQQ=
X-Google-Smtp-Source: AK7set/fDBf9M72qeDAIytb1vPfgrfGZhYW+XV0WMfwC3hqbWABuZK2wVoOfE7Aw5A+xfq8aJramxQ==
X-Received: by 2002:a05:600c:1609:b0:3eb:39e7:35fe with SMTP id m9-20020a05600c160900b003eb39e735femr352922wmn.30.1677361668486;
        Sat, 25 Feb 2023 13:47:48 -0800 (PST)
Received: from ?IPV6:2a01:c22:7715:8b00:51a3:9e62:de37:8c49? (dynamic-2a01-0c22-7715-8b00-51a3-9e62-de37-8c49.c22.pool.telefonica.de. [2a01:c22:7715:8b00:51a3:9e62:de37:8c49])
        by smtp.googlemail.com with ESMTPSA id p13-20020a1c544d000000b003e208cec49bsm13324947wmi.3.2023.02.25.13.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 13:47:48 -0800 (PST)
Message-ID: <2d61ba5a-9a2c-28c3-4a1b-a81a3f34af3d@gmail.com>
Date:   Sat, 25 Feb 2023 22:47:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH RFC 6/6] r8169: remove ASPM restrictions now that ASPM is
 disabled during NAPI poll
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
In-Reply-To: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
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

Now that  ASPM is disabled during NAPI poll, we can remove all ASPM
restrictions. This allows for higher power savings if the network
isn't fully loaded.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 27 +----------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2897b9bf2..6563e4c6a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -620,7 +620,6 @@ struct rtl8169_private {
 	int cfg9346_usage_count;
 
 	unsigned supports_gmii:1;
-	unsigned aspm_manageable:1;
 	dma_addr_t counters_phys_addr;
 	struct rtl8169_counters *counters;
 	struct rtl8169_tc_offsets tc_offset;
@@ -2744,8 +2743,7 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 	if (tp->mac_version < RTL_GIGA_MAC_VER_32)
 		return;
 
-	/* Don't enable ASPM in the chip if OS can't control ASPM */
-	if (enable && tp->aspm_manageable) {
+	if (enable) {
 		rtl_mod_config5(tp, 0, ASPM_en);
 		rtl_mod_config2(tp, 0, ClkReqEn);
 
@@ -5221,16 +5219,6 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 	rtl_rar_set(tp, mac_addr);
 }
 
-/* register is set if system vendor successfully tested ASPM 1.2 */
-static bool rtl_aspm_is_safe(struct rtl8169_private *tp)
-{
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_61 &&
-	    r8168_mac_ocp_read(tp, 0xc0b2) & 0xf)
-		return true;
-
-	return false;
-}
-
 static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct rtl8169_private *tp;
@@ -5302,19 +5290,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	tp->mac_version = chipset;
 
-	/* Disable ASPM L1 as that cause random device stop working
-	 * problems as well as full system hangs for some PCIe devices users.
-	 * Chips from RTL8168h partially have issues with L1.2, but seem
-	 * to work fine with L1 and L1.1.
-	 */
-	if (rtl_aspm_is_safe(tp))
-		rc = 0;
-	else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
-		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
-	else
-		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
-	tp->aspm_manageable = !rc;
-
 	tp->dash_type = rtl_check_dash(tp);
 
 	tp->cp_cmd = RTL_R16(tp, CPlusCmd) & CPCMD_MASK;
-- 
2.39.2


