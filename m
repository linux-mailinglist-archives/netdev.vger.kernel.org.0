Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038431C1B9E
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 19:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgEAR0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 13:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728972AbgEAR0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 13:26:35 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEA2C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 10:26:34 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so7147362wra.7
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 10:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ru6FC8FdFcixgDEj9CxDCxaHWfysbK6DyM9A+vmycX0=;
        b=s41MF3DnODCEs1P5D4hzoIUgGzl0uZ/9elHGwJUl0xAEbOpnM/LoBHpHSZ/Iy6Xi+t
         1y1vlFo9+j8Vm9gtvdRdyaDtBZ7bzoOiMMj2bWXrEfcQDECvC8xWJfG3cPyQB8UPsOzq
         ttHQTZ1n6TsGGGOO8161LrDq/dcbxNC+Buvm9A+hSicefyd6IPSdU+rigzjxrnH4W7sT
         45sjDjy7Meij/1UbzMFg8P/GWDG41IPsd/F8rq1FTQTnBgfNpuipyoSHZvhlpEhkMpu0
         /VhmsLyh3gmtaQESMOwC5cwiT4LnGoJANUH1qMRkxq3ForiU06drwTc6WYdWSHTDKIWS
         s8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ru6FC8FdFcixgDEj9CxDCxaHWfysbK6DyM9A+vmycX0=;
        b=AdD5D/FY1398Y3zTgv4Ec8igRhfyinjx18AKmz9W2Dcdsu/AZSdvqxZSzup24IANZn
         6lbBryuc2o7El5Vi+Y5Zs4u6EmyIMQxZb/xoB7UZr5vZfrQVLFC8wM9y5AUQ4MXmAPMk
         EGvSkx77A8Z7OqWDx8Dbm/ynYYmoEWRUsSZ4SFZwmvDYQpO7F0dmmPLbh9J6oDNRWlwV
         irbMD+d3+iAxuBw2t6y0yOoVBtb6E8LWKOs6IWqBcxALOjcLe3ZNHLbpp5EkSjIMSO8O
         E3d8QV5PhO32H4SQ7PpZDbcouIf7YsdjyqDFQ4jUfjbscpbVKUrjfmt1gJpozwAFl8jv
         ahRg==
X-Gm-Message-State: AGi0PuY9+d9JUG0W5vRWxo6QskCzRJAUQkCl30o1sjeG8kAsmyayi1Qt
        B1ov02x0nmKMNDGNAwj1tqttRc5d
X-Google-Smtp-Source: APiQypLvHCr+nVwj4ZtOWiiOCV8hjFAkZTSTRLLETUBpuYvlaMck+tgEBhcOKr6j3NvmzJcp3h0MrQ==
X-Received: by 2002:adf:fc43:: with SMTP id e3mr4930525wrs.234.1588353992438;
        Fri, 01 May 2020 10:26:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f06:ee00:54e4:3086:385e:b03b? (p200300EA8F06EE0054E43086385EB03B.dip0.t-ipconnect.de. [2003:ea:8f06:ee00:54e4:3086:385e:b03b])
        by smtp.googlemail.com with ESMTPSA id w18sm5052370wrn.55.2020.05.01.10.26.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 10:26:32 -0700 (PDT)
Subject: [PATCH net-next 1/4] r8169: remove redundant driver message when
 entering promiscuous mode
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0e2ab257-5564-f16a-92f9-d0635e140837@gmail.com>
Message-ID: <9852ebb8-b651-01b6-ab9a-815cff2f8dcd@gmail.com>
Date:   Fri, 1 May 2020 19:22:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0e2ab257-5564-f16a-92f9-d0635e140837@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Net core -  __dev_set_promiscuity - prints a message already when
promiscuous mode in entered/left, therefore we don't have to do this
in the driver too. Also the driver message would be misleading
(would be because "link" message level is disabled per default)
because it would print "promisc mode enabled" even if it's being
left. Reason is that __dev_change_flags() calls dev_set_rx_mode()
before touching the promisc flag.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0f869a761..bfa199b36 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2634,8 +2634,6 @@ static void rtl_set_rx_mode(struct net_device *dev)
 	u32 tmp;
 
 	if (dev->flags & IFF_PROMISC) {
-		/* Unconditionally log net taps. */
-		netif_notice(tp, link, dev, "Promiscuous mode enabled\n");
 		rx_mode |= AcceptAllPhys;
 	} else if (netdev_mc_count(dev) > MC_FILTER_LIMIT ||
 		   dev->flags & IFF_ALLMULTI ||
-- 
2.26.2


