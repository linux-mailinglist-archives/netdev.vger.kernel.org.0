Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9A21E14F8
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 21:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390336AbgEYTyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 15:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388737AbgEYTyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 15:54:10 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0F0C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 12:54:09 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id h4so993225wmb.4
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 12:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Dl89b2V1YP029iNfAfiknwcLec8Xnwf1+FdGZQD1Qmc=;
        b=knolNnmlbjO7nKIvDme9V4bl5FzYPkQpl8ixg+CgbIb1zKzQ4z86aFtpV/RhUraj1k
         x6NQ4bjsPzcQHQM0W5bszKbiSPDv1Rzx9CIJXsU+y7EoB4h3LN+VJy4btNSz6SQ4RmQ+
         Ay5MKfNJ4SzJP6A3pw7eXdlZcljNcPeH0KbhrDUzZbPnFHPh5kvqtUzQmZU8ZhjKHYFZ
         5vzT8clRUJv3+cm5Dynf04zF3bgM0ZwyvsjBw6q2Z3AXLQzQn1LRkZ02F1AETvC8n6G+
         XbUMFGni+9suHb6mS94cWyPRvoQHEPm/pkypF10nkDMijL5vUVWINcpR54VosJL8MLTs
         TO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Dl89b2V1YP029iNfAfiknwcLec8Xnwf1+FdGZQD1Qmc=;
        b=TmxEjZ3lQbetDqSLrsOWW940D1Q6KPFDvIoFXWB7s+T9tF44NtKlMMSCgdyqRD8XzA
         /qBTmpdfOgCZGZCXo2fCYooqgUxlw6N5/3hWsYTUBIKILB3blohha6/tDi6uipFwi0tR
         PpnTIr8AzmWuN03j6LNDvbPJxYvulpUQkesJRI/bN1WVo1WxXEpkq50vxXLOWU3KckkJ
         UNm+r+0jhNT8+6gdcegEfAOTvC6FrTYqi2u57lCKyT4E6baEXnU5rjj37lLdJRMzps72
         a3zzz8AIlCL86R8RB+CTNA6CYy2Ob4MaGbGTBsuuckkQyIv58lGi3F/uWl7VPs8MzPVi
         gGmw==
X-Gm-Message-State: AOAM530ChDraq+s5xzQ4ypPX/in3ki2WSWet5z2kxCjjD8DNqmbV1R1o
        EqCmoFUJiyYQO1ZoYAbC6Ddc32Es
X-Google-Smtp-Source: ABdhPJwbwpStY9lX6I/rJ6KXvA1VpirR5XZJIMhewLwgWeN/5jwxTtMCVuZsr99xX3+R0T9HEPeFEQ==
X-Received: by 2002:a1c:4c16:: with SMTP id z22mr15232810wmf.17.1590436447600;
        Mon, 25 May 2020 12:54:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:fd94:3db4:1774:4731? (p200300ea8f285200fd943db417744731.dip0.t-ipconnect.de. [2003:ea:8f28:5200:fd94:3db4:1774:4731])
        by smtp.googlemail.com with ESMTPSA id n7sm18436988wrj.39.2020.05.25.12.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 12:54:07 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve rtl_remove_one
Message-ID: <13536518-bb67-795a-e385-fe34deec78d1@gmail.com>
Date:   Mon, 25 May 2020 21:54:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't call netif_napi_del() manually, free_netdev() does this for us.
In addition reorder calls to match reverse order of calls in probe().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 17c564457..d672ae77c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4996,17 +4996,15 @@ static void rtl_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	if (r8168_check_dash(tp))
-		rtl8168_driver_stop(tp);
-
-	netif_napi_del(&tp->napi);
+	if (pci_dev_run_wake(pdev))
+		pm_runtime_get_noresume(&pdev->dev);
 
 	unregister_netdev(dev);
 
-	rtl_release_firmware(tp);
+	if (r8168_check_dash(tp))
+		rtl8168_driver_stop(tp);
 
-	if (pci_dev_run_wake(pdev))
-		pm_runtime_get_noresume(&pdev->dev);
+	rtl_release_firmware(tp);
 
 	/* restore original MAC address */
 	rtl_rar_set(tp, dev->perm_addr);
-- 
2.26.2

