Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9331C5F7368
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 05:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiJGDmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 23:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJGDmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 23:42:08 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD6742ADE;
        Thu,  6 Oct 2022 20:42:07 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id de14so2413748qvb.5;
        Thu, 06 Oct 2022 20:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iC5L0euxuRisBkUR/6515IKt3GI2uffEHDVxsffOfBg=;
        b=fkuYjA79BKmImZyPPSBktW6F4k89V6B/1AB0Wxlb/nraYWAR29FBwM4g6cdoXck2PB
         zGnRrxoVjsZs9mUCJMY8ISZezsXWcXTGPLYr6hjy5h4XNd+pl0X6bqk4AoZ34bUh/SXp
         Mf2VxGtkgShceazj0tLmvDQC2mcFCPPbr6WnSUVDB2sxGpweT4gahF10/7pNOTSNcXb0
         5MH+Xjh+00rOLN9QYu2Mk35bfubWMTsPXpjm/AHxbQ+J2pXl3q+iWWMdMlQqAyWvgA97
         zfSdt+ayz1lOjhRVCSFby1qt5yUHtD9jKYeH2wablECUc3naDurYxUHqbC372hLLIrsm
         FmiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iC5L0euxuRisBkUR/6515IKt3GI2uffEHDVxsffOfBg=;
        b=EMyWsUKyNO+LMuZgMAYw4gKOmb9rUCmNBnGnUsornm2UWQ9Yfu5l4ygRZTUqa8bSah
         szpTgpFzv+GuDlFGXgIM7YuuRHjXJW8e+pBnlnwJC+aV4Adz5DglHwGKja5vORho7aRs
         5W1Pg4dgf9tjR+rTWPXwJnT7KZUq2dNexr4D1RyD3KkbEpEi/YGH7xe6NE7gzUCjK7hT
         3f84OeZiXmH1e8NGFDqt+hhbA4QZrQB4sg37aZGmQwEEifEE7CipY0XH7FlUSlN5Dn7m
         vd1Mle6aTp2bAuLdCAW7Zpi8JISXQqO3lA+n+lVilbE5puBHzQHIPKa2klDligutYnfp
         CdYA==
X-Gm-Message-State: ACrzQf1fYrAPI0ah9oEQNRg88GSKNM15LFo6kvq44zS59pspiRtvmDmu
        VX75nU3Az/tOivlc6N83byLOtH66LtQ=
X-Google-Smtp-Source: AMsMyM5hnPp2CEJasetQmLXEe/K8g3ubXRyFrKtVcq7DpsOyssynfYk8Q5+6Z2nqDfM2nfj9IMikew==
X-Received: by 2002:a05:6214:234a:b0:474:2318:3f3b with SMTP id hu10-20020a056214234a00b0047423183f3bmr2611176qvb.10.1665114126138;
        Thu, 06 Oct 2022 20:42:06 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l20-20020a05620a28d400b006d1debe2637sm1085596qkp.11.2022.10.06.20.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 20:42:05 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: systemport: Enable all RX descriptors for SYSTEMPORT Lite
Date:   Thu,  6 Oct 2022 20:42:01 -0700
Message-Id: <20221007034201.4126054-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
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

The original commit that added support for the SYSTEMPORT Lite variant
halved the number of RX descriptors due to a confusion between the
number of descriptors and the number of descriptor words. There are 512
descriptor *words* which means 256 descriptors total.

Fixes: 44a4524c54af ("net: systemport: Add support for SYSTEMPORT Lite")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 16b73bb9acc7..5af16e5f9ad0 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -484,7 +484,7 @@ struct bcm_rsb {
 
 /* Number of Receive hardware descriptor words */
 #define SP_NUM_HW_RX_DESC_WORDS		1024
-#define SP_LT_NUM_HW_RX_DESC_WORDS	256
+#define SP_LT_NUM_HW_RX_DESC_WORDS	512
 
 /* Internal linked-list RAM size */
 #define SP_NUM_TX_DESC			1536
-- 
2.25.1

