Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DBE6AD04B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCFV3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjCFV2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:28:54 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A694E37F05
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:28:33 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso6025171wms.5
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 13:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678138112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DGfzjjoiQHuMjP01DyQVjuhjLdCZBikcH33VI7IxHdY=;
        b=ENPDQJSvRFgkk2v72WVohnmhBqI/M6OvGhETbv58yPG5S5bniWhe7ZQO0Rt57KVtyi
         +ynd7ycsF8kWebIx2/S3jTNrNJfn5Tq9S+vWyzE8mscCYRfKfrOY4a173liyFykgkSqq
         lAj2jfK+EdMeJ+cPYex+61s7ftI78FQ7qdpKJiL7ryDaPJXmi2jl9/at9SvibmrZuWiL
         Gu7HRl1yaauY7QJk13yBJiqp/X93de8mfSa8pX/OYAOlYSUkvz0daC2vcXyIRV6JaIlV
         c9/1Y8u/QyqVH8ecO4DkGLD5/+MUXR5S1ebYRKXmOWPOxKZtM4mW3VE0gO+MFiOAv+uO
         uzWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678138112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DGfzjjoiQHuMjP01DyQVjuhjLdCZBikcH33VI7IxHdY=;
        b=fB7ycmF72z+teFUfXyYih1PjKskfToUgjmgVOC3GF2c89JJgsYk+UlNddZ6piTXcrd
         cLzW+V1QIqWKRh/Hs1ans+iIDlmXZ5MZEAcAbZqtdrO+zae2FzBFibVxYiDUo24+TWss
         XwJwi2xH9K8ctCHMPYNJoDNfrskFEHAKHdJ+6Zw0aqYaNrWepMHaQoS00vOdxQE3KHo4
         umXsWqAZGm7vRj0giERpa3/EmGHVsdGOM1glkC3ip4X5NUif4sNGEZG8W581TMwZV11z
         ESFwyrGDkDzQjGDoUOwewuL8cAlqhW9ZVDGg0SEX6/kj+wPyN3esIrPMEDpiTQFnaTJr
         edtA==
X-Gm-Message-State: AO0yUKW2LSAyIc0Ojy76nHZNT5YtPfNOTrnDT3rX9XfqWku4a4akcL0w
        CtEoQuL/G3fZslUo/JtEtQ8=
X-Google-Smtp-Source: AK7set9HE2vMkBFZrWGb5wjW3FlKKos72kh3CIiD7WdtXNPEIWWlwr4p/W0RS749iQyOHeENZl+eFg==
X-Received: by 2002:a05:600c:548e:b0:3df:db20:b0ae with SMTP id iv14-20020a05600c548e00b003dfdb20b0aemr8765331wmb.17.1678138112033;
        Mon, 06 Mar 2023 13:28:32 -0800 (PST)
Received: from ?IPV6:2a01:c22:7bf4:7d00:9590:4142:18ea:aa32? (dynamic-2a01-0c22-7bf4-7d00-9590-4142-18ea-aa32.c22.pool.telefonica.de. [2a01:c22:7bf4:7d00:9590:4142:18ea:aa32])
        by smtp.googlemail.com with ESMTPSA id x8-20020a1c7c08000000b003eb2e33f327sm21485042wmc.2.2023.03.06.13.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 13:28:31 -0800 (PST)
Message-ID: <a3d4b8fb-d949-35f2-1746-c50814330ac9@gmail.com>
Date:   Mon, 6 Mar 2023 22:28:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH net-next 6/6] r8169: remove ASPM restrictions now that ASPM is
 disabled during NAPI poll
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
References: <b434a0ce-9a76-e227-3267-ee26497ec446@gmail.com>
In-Reply-To: <b434a0ce-9a76-e227-3267-ee26497ec446@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
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



