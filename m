Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86C5612534
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 22:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJ2UZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 16:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJ2UZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 16:25:38 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC23C57243;
        Sat, 29 Oct 2022 13:25:36 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r186-20020a1c44c3000000b003cf4d389c41so5740761wma.3;
        Sat, 29 Oct 2022 13:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ttJXl1O+WtGx7HGaN4lclnmsd+5ceFEvGkEFkbx8+Bg=;
        b=S5ev+8KYexDR21YSvjFuTbFqFoLhAzp4acF55yz/DyT3/zJItlWRBUCJouTTXQ3c5e
         +iPdXuL+fXkutX1otneI1k9DNnGLXDuss991glHnnzilvhGgSGg5rY9Ti00WE9XktYvO
         TYPac1sIubtrkzxsoBlOF/ejnfLPHj7N+SCdxqBCAeG+MGPEQ6sVkxmiXQkacQWeC7NF
         E5FTdz5qKcLz/Iu3bMtSYscwXrGf6NsKwzf4rnlo2CekPJ9YsdEUMDiSHjd/dM68GilO
         Q9mptq/kHb+notb2YbL097efyVKkotyEbUGFnc6SIVYg6ixBYpQyA0ahMPb0LB5gGTPF
         yOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ttJXl1O+WtGx7HGaN4lclnmsd+5ceFEvGkEFkbx8+Bg=;
        b=InUI+MjlcMEvIZpSzrZQYhrBIXPueF/y8Ey+EZiPHSWF4mRu+oCNff4ttuOOdYCsli
         N4+uUDiyQUZwnsHQQ1RhIYNjDcntjW5lTv56vjTsPPO1mT6tdwWAz+SuO8Fj+8FyB7E7
         Zgxdpp0vq/blbiV4sZxNHyQYv6XZDj3Lyr+qO14WYj441roAqRIDRGqO+0uml1ghkd0K
         DBEbmEWc54FROsU2ur5YXeihW1JC21vtGRIXTtbC2YTa8tthLxLLULz4tMzAnThxbqZi
         ZJF9S0EaTjmK7vkl8oY8SskPkCLS7BnEt1RyEUABHmAF/pRplSYcBmtw6xlYD+1/O7/b
         QGJg==
X-Gm-Message-State: ACrzQf2+H6p/+GZezWmzNGcAA5LhIa85PcGMAb2x+mLrN+7eVW/Ge1sB
        svcCt34r0Lp/U6qj17P2QUU=
X-Google-Smtp-Source: AMsMyM59PmNZzddxif1j3GhaZPqaseoUlf3Wcm+iZPXUrZtDnxEHhl2R7W/89U31IldScmgUvS2www==
X-Received: by 2002:a05:600c:310c:b0:3c6:f7c6:c7b6 with SMTP id g12-20020a05600c310c00b003c6f7c6c7b6mr3211079wmo.81.1667075135355;
        Sat, 29 Oct 2022 13:25:35 -0700 (PDT)
Received: from osgiliath.lan (201.ip-51-68-45.eu. [51.68.45.201])
        by smtp.gmail.com with ESMTPSA id k3-20020a05600c1c8300b003c6b7f5567csm16654829wms.0.2022.10.29.13.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 13:25:34 -0700 (PDT)
From:   Ismael Ferreras Morezuelas <swyterzone@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        luiz.von.dentz@intel.com, quic_zijuhu@quicinc.com,
        hdegoede@redhat.com, swyterzone@gmail.com
Cc:     linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/3] Bluetooth: btusb: Add a setup message for CSR dongles showing the Read Local Information values
Date:   Sat, 29 Oct 2022 22:24:53 +0200
Message-Id: <20221029202454.25651-2-swyterzone@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221029202454.25651-1-swyterzone@gmail.com>
References: <20221029202454.25651-1-swyterzone@gmail.com>
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

The rationale of showing this is that it's potentially critical information to diagnose
and find more CSR compatibility bugs in the future and it will save a lot of headaches.

We can't ask normal people to run btmon, but infinitely more users already post their dmesg.
Because in many cases the device doesn't go up, most of the tools won't show these either.

Given that clones come from a wide array of vendors (some are actually Barrot,
some are something else) and these numbers are what let us find differences between
actual and fake ones, it will be immensely helpful to scour the Internet looking
for this pattern and building an actual database to find correlations and
improve the checks. I can't buy a sack of clones and do it myself.

Cc: stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
---
 drivers/bluetooth/btusb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1360b2163ec5..8f34bf195bae 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2112,6 +2112,11 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 
 	rp = (struct hci_rp_read_local_version *)skb->data;
 
+	bt_dev_info(hdev, "CSR: Setting up dongle with HCI ver=%u rev=%04x; LMP ver=%u subver=%04x; manufacturer=%u",
+		le16_to_cpu(rp->hci_ver), le16_to_cpu(rp->hci_rev),
+		le16_to_cpu(rp->lmp_ver), le16_to_cpu(rp->lmp_subver),
+		le16_to_cpu(rp->manufacturer));
+
 	/* Detect a wide host of Chinese controllers that aren't CSR.
 	 *
 	 * Known fake bcdDevices: 0x0100, 0x0134, 0x1915, 0x2520, 0x7558, 0x8891
-- 
2.38.1

