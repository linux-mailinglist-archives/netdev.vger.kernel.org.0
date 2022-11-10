Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C242D624C5F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiKJVDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiKJVDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:03:39 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F987679
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 13:03:35 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id a13so5101353edj.0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 13:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r9gMkdtFnyPxEjPFLz48iTcMLciEjOZhiZGD96W3iMM=;
        b=ATJQLi5RugV0cN3jDGazFMfONPdUrk1C9bVryqgqSVz1fZKI1O/LDhlgHyqXAJN0i4
         xEsgcc1KvzZG38fzdEGPSLXucFtk2sWYa34xnjLxz0P7Z+hszuJvAii9+tyJiZYF7k9K
         utfDU5RS89QcS5gCTOdJwKfZN6jvOKJoDJV2vb3zpGhfpYuTn5FR/Z5fZEYmAUvX5Sx7
         LDFchMdBSrYlIYRfbKaL/AZiDdxyQz0hvj6ggdYTeodyqaVMxDoY+uZzICtX1iVzQjhf
         Ezq257w+1Io+VRVbcD1hch1fCXzawffofeLb6P7x5MXFFXzqv6+ZC91ypFK6Ww+3R/GU
         yBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r9gMkdtFnyPxEjPFLz48iTcMLciEjOZhiZGD96W3iMM=;
        b=GhHEhG4VKZDz3eHQdv3KQyanCk/Q6OwJKgCmO8Zx9MWkHmdseeQ9CVnc6wNHfv+HfK
         pGfY82Iwf2x7IQUk5Rv2zAJKxNtNuVTxTkQ3fvCYmp8/MXolzFbZruLfeEVkNanF0FS7
         QEyp38gUcbZRNR9xBtpDE6Rvbm70qGO/aOjzbA9rz0fh8NbeO/LVaE8Sqlxbinwwo7n8
         lhHFXl8z953y7gmQX++gFeNLei2z/NubHCL0UlgDzWQLP/0laa5Nj0S2wJUUfb2I6LJp
         hZu5xc3dxcoC9WyHyJ4ieA+N8FEbY8i9IQg1QYx4Iw/aJS1Im9ZJmEu4qe4777Skc56V
         T+Sg==
X-Gm-Message-State: ACrzQf2IKEs0PZV/wdRkAETvt0yvdZn3jeORgKW5c8lYfX750tl3xGDL
        fwpE/PYH8JMJmgtEfoGR2M5Ys/FjDwo=
X-Google-Smtp-Source: AMsMyM4aULE3QvAPA+IgTxRb5NJjEoyxfLotLo9J/MK5h+0q9aBj2uZu6xgiTwtuqBZyprGjokjyPQ==
X-Received: by 2002:a05:6402:1544:b0:459:3c89:53d3 with SMTP id p4-20020a056402154400b004593c8953d3mr3576523edx.25.1668114213818;
        Thu, 10 Nov 2022 13:03:33 -0800 (PST)
Received: from [192.168.169.11] ([82.197.179.206])
        by smtp.gmail.com with ESMTPSA id b25-20020a17090630d900b0078d38cda2b1sm103651ejb.202.2022.11.10.13.03.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:03:33 -0800 (PST)
Message-ID: <8c3c6939-ec3d-012d-f686-ddcf5812c21b@gmail.com>
Date:   Thu, 10 Nov 2022 22:03:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     netdev@vger.kernel.org
From:   Thomas Kupper <thomas.kupper@gmail.com>
Subject: [PATCH net 1/1] amd-xgbe: fix active cable determination
Content-Type: text/plain; charset=UTF-8; format=flowed
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

When determine the type of SFP, active cables were not handled.

Add the check for active cables as an extension to the passive cable
check.

Signed-off-by: Thomas Kupper <thomas.kupper@gmail.com>
---
  drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c 
b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 4064c3e3dd49..1ba550d5c52d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1158,8 +1158,9 @@ static void xgbe_phy_sfp_parse_eeprom(struct 
xgbe_prv_data *pdata)
      }

      /* Determine the type of SFP */
-    if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
-        xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
+    if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE ||
+         phy_data->sfp_cable == XGBE_SFP_CABLE_ACTIVE) &&
+         xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
          phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
      else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
          phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;

--
2.34.1

