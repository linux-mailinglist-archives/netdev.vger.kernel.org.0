Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4035AF38C
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 20:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiIFSZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 14:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiIFSZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 14:25:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBD08604A
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 11:25:08 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 29so11204488edv.2
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 11:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=D04y5KyF8kDmjryMC0lzu1jlfsVbN+WEejJz+5yiV6Q=;
        b=E4iI3dJ7qDk+4ZtmDImVyOIjdETRuR3/u7z/rJOa9+oNJwUusNTf1TXXu4FnbZvzfe
         ufx2BflMvOSNBV+gITgPHi5ZfsHwiOujLy0u+N6wTANNgDvE/Z3TfW/T5VjdN3aOmyRs
         7ZpEK9x9FRCPToqDOESCZRDHFB+H0XZNL/G9C2UPARLpayk9Dpp7Dx5FbBL2lnaJdue4
         F1tsTK57dFt5Ny5bvkgaghdyKz2BhDLoh+KfJoIZLmEaqRG7P/ZDKOSCe4z+UwfAVrYV
         SyB/um5k4C+/BSX9O6DDhS0l3pdQNglFYdqDCp8t4ov2Lq2f5jLNzjqgnOTd4WLY6bwG
         1qLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=D04y5KyF8kDmjryMC0lzu1jlfsVbN+WEejJz+5yiV6Q=;
        b=FWUhzF8BJNI36veES9sBWoc3xJCToxq8fWD0dpMXmbRRsixJ+Q1+ag7ZdwUxVFAV5i
         VxR63fnoQ0BvcguEJzdcKLSD3qrJY0y82nE2DH1UIxlWsa1hMnx/7RIPpf6C6GFYS8Zr
         bg/RQTrBIdl3uZ+qrOkazggL/Qz6LwuLgVhIfX+pXinvvKwyQqEbM767mZbOAnsrA4Q4
         Nqzb2/hm/PgOZyG0fI+odTZORrtvZ4flcwU6p5IQuytyCE6rExbbPG/jLOECLJIptSfy
         DL59nXRuF1B7VVXa/vw7+2TPaJ3qJ5UXPvICBEnJdqI0phxuvBbsWaHNSexoG+kW8gfN
         US2g==
X-Gm-Message-State: ACgBeo2xBwzAoehA7XlLsfKZ9xnVO8GNoEooawwKVVmEItW55GfcRGUd
        sTeyl97Ww3Qk1w3Owrd28X4=
X-Google-Smtp-Source: AA6agR7Kqp7PiFGHGt4Q22cRbzS8BkcxnNQlY3RzH2Y0udl+M5js8H5z42pvkyeVpT7ha7XD2Q6ARg==
X-Received: by 2002:a05:6402:120f:b0:44e:fe1a:b968 with SMTP id c15-20020a056402120f00b0044efe1ab968mr709633edw.127.1662488707357;
        Tue, 06 Sep 2022 11:25:07 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bd23:a800:187f:c2cb:1804:1a? (dynamic-2a01-0c23-bd23-a800-187f-c2cb-1804-001a.c23.pool.telefonica.de. [2a01:c23:bd23:a800:187f:c2cb:1804:1a])
        by smtp.googlemail.com with ESMTPSA id f22-20020a056402161600b0044e8ecb9d25sm4080316edv.52.2022.09.06.11.25.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 11:25:07 -0700 (PDT)
Message-ID: <2391ada0-eac5-ac43-f061-a7a44b0e7f33@gmail.com>
Date:   Tue, 6 Sep 2022 20:24:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove rtl_wol_shutdown_quirk()
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since f658b90977d2 ("r8169: fix DMA being used after buffer free if WoL is
enabled") it has been redundant to disable PCI bus mastering in
rtl_wol_shutdown_quirk(). And since 120068481405 ("r8169: fix failing WoL")
CmdRxEnb is still enabled when we get here. So we can remove the function.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3763855e4..306c65228 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4842,22 +4842,6 @@ static const struct dev_pm_ops rtl8169_pm_ops = {
 		       rtl8169_runtime_idle)
 };
 
-static void rtl_wol_shutdown_quirk(struct rtl8169_private *tp)
-{
-	/* WoL fails with 8168b when the receiver is disabled. */
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_11:
-	case RTL_GIGA_MAC_VER_17:
-		pci_clear_master(tp->pci_dev);
-
-		RTL_W8(tp, ChipCmd, CmdRxEnb);
-		rtl_pci_commit(tp);
-		break;
-	default:
-		break;
-	}
-}
-
 static void rtl_shutdown(struct pci_dev *pdev)
 {
 	struct rtl8169_private *tp = pci_get_drvdata(pdev);
@@ -4871,9 +4855,6 @@ static void rtl_shutdown(struct pci_dev *pdev)
 
 	if (system_state == SYSTEM_POWER_OFF &&
 	    tp->dash_type == RTL_DASH_NONE) {
-		if (tp->saved_wolopts)
-			rtl_wol_shutdown_quirk(tp);
-
 		pci_wake_from_d3(pdev, tp->saved_wolopts);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
-- 
2.37.3

