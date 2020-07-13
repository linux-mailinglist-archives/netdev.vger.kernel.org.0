Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CA521D6FC
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 15:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgGMNZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 09:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbgGMNWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 09:22:54 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9684EC061755;
        Mon, 13 Jul 2020 06:22:53 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ga4so17129006ejb.11;
        Mon, 13 Jul 2020 06:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xIWj0P8al909J+4pBE5o44qtYmVuYzVtW9yKrCNUaw0=;
        b=QT0ftuJUMnvN9L1yGVRJDjEK3qSZdoXJXBN5DYl7jyWso++THIIOuHpbc17F/zrosi
         8AuTgvAPKXfSy6z4977e3BRxPajXTXDMS4RXeyVTILawt6WgXpY//f2djyt/UkJQGRzk
         /gdGnf3M/3rld4z29OqilvjBcL0gyasTI6OnKfGjeReyQglVGg+YQe+xr3g3vN2ZXmuT
         H3K8zDE9spjbeXT5VJ615ifyAxorGrxgxDGJjtr2u9GrRuD3j9OL7Xjkb7TwOPORQmqL
         TfhNmfHAyI3xoFlBuZ/xKOOKE0n/7YMZrCkoDpUABaGXyhlEEpPzVsxCBXEJHjxWIgoV
         ZxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xIWj0P8al909J+4pBE5o44qtYmVuYzVtW9yKrCNUaw0=;
        b=D/offut8vk+96+14HCrsAaIA0wi0HtAAGM/PehE7LImuNEbIi8C8qiZnsXTnfiWStF
         IDcIdvD8/UgUphb3+M/VjP1JEYJhig2m/JGrN0zvhDyIYpkEMc3ywK6unF/nlp9Hg8+t
         eoJiF17w1kA/+SQYSAovK4LFejk3l8mCMv49w39dj+J9CIBZtE9DPJ2G4v7mNLUSOuxj
         eHbohz7Pt7NaevAxtIjObDIa03Wbm8IddLQUHek/RS5V8JVTZygBOSDNIDvo0XtiyvLH
         NZ+PSZjwBO57NIsbKDmWt/QE9DhBvmOqd4DiNpdQ49o9ZMJyjRAO4JY39wzkN3rFItaS
         9MMA==
X-Gm-Message-State: AOAM5334fK8Mml+Ny8lmhc5OXdi36trIR8gSHCkvtqftRpz+Y5AfosB3
        4hBlPYseVhtdvjct21tzseo=
X-Google-Smtp-Source: ABdhPJxAfEv30rbnDL4uWXY7GIMGij0pMiiCWfpa5ktuZKtBwYpOGp8E6A1+3fdVVGoX3cC+gtFk5Q==
X-Received: by 2002:a17:906:f53:: with SMTP id h19mr71418351ejj.491.1594646572377;
        Mon, 13 Jul 2020 06:22:52 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id n9sm11806540edr.46.2020.07.13.06.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 06:22:51 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     helgaas@kernel.org,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 11/35] r8169: Change PCIBIOS_SUCCESSFUL to 0
Date:   Mon, 13 Jul 2020 14:22:23 +0200
Message-Id: <20200713122247.10985-12-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200713122247.10985-1-refactormyself@gmail.com>
References: <20200713122247.10985-1-refactormyself@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In reference to the PCI spec (Chapter 2), PCIBIOS* is an x86 concept.
Their scope should be limited within arch/x86.

Change all PCIBIOS_SUCCESSFUL to 0

Signed-off-by: "Saheed O. Bolarinwa" <refactormyself@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b660ddbe4025..206dac958cb2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2656,7 +2656,7 @@ static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
 	 * first and if it fails fall back to CSI.
 	 */
 	if (pdev->cfg_size > 0x070f &&
-	    pci_write_config_byte(pdev, 0x070f, val) == PCIBIOS_SUCCESSFUL)
+	    pci_write_config_byte(pdev, 0x070f, val) == 0)
 		return;
 
 	netdev_notice_once(tp->dev,
-- 
2.18.2

