Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3160A5B9B18
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 14:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiIOMlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 08:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiIOMlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 08:41:46 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43816BE8;
        Thu, 15 Sep 2022 05:41:45 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bj12so41771271ejb.13;
        Thu, 15 Sep 2022 05:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=tzmtfB02Kll9bwoDnqvoio0j7mPs1ux70CIafG7WcfU=;
        b=atzRGS0IEVvnd6WXWC1rlccaFpBQ2yFXqBqZ0xtSuNwYZbyh6YLVXuYzo5VlCf3iMP
         BXWfOqj/F/1zmWoyB2Ve1b4rG8wV4V0nXNPRF2ttYQZHs5S+vgVt5aY8tk9kzZEKkCGp
         99SPE2OCnrsp7ChpLRX6eFj/7iiUngJWcWymqH8Vf3Qh5/8epbpknxNhTWsZD+pPH0kl
         8q57dvY2+qmbkMehptiFXjeo8CWidirKYdwZ1kovxRZGLbsHsxjaOqqcaSrGOvJCGK+R
         RYD31Gyww66Ch62fGeb1WerCHHiTxFWaTjfIwREbvvYEBrsMvYShWfKyvxogNPSQVbAY
         U1LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=tzmtfB02Kll9bwoDnqvoio0j7mPs1ux70CIafG7WcfU=;
        b=EpH8uQyQN5mFFxV3qACj/16IvD18Q/SDl0XbLhwwDUm/qcxszHX985oAGWqtLCGava
         VXOLU8lXvxqFg70DLabKcpG8YHZ2XgTvMsvwATJDZKsXK1AUm+uNO3D/PjKJwYNtCJgH
         3To0GreZT5yI+xEQe7BJpiNerhMSapEiqrLJFD/1weuiloPs12k1B8m5dCuaYBrAkacL
         Ci3SaWA2uZ2Tvsk0TSPu7LAqWdVGfr2T6eoirayqVGRIBZO2JJeZGneGE9oN91nMhX8w
         s03iixLhiXqPhyBBwZj7KmJBYQZl1ZAKtFJ2HMpnQv9PFI7mqZEz1+V5DYmSgE0C61IM
         Ijag==
X-Gm-Message-State: ACgBeo3txzsJrCfP+aP6f1zM7QWvphCjRbFAVBz1exKMJKTTMnAJgWbt
        3sBWTfhy3rCB2m/zGXg88GI=
X-Google-Smtp-Source: AA6agR6OETBFpaXizZkBzwGuLb/nSX3ng6zwpvWStvpMjub1lzTuDLEeGZHPr04IhJAIRKoFkOF22g==
X-Received: by 2002:a17:906:8c7:b0:730:c1a9:e187 with SMTP id o7-20020a17090608c700b00730c1a9e187mr29400332eje.55.1663245703722;
        Thu, 15 Sep 2022 05:41:43 -0700 (PDT)
Received: from localhost.localdomain (host-95-251-45-225.retail.telecomitalia.it. [95.251.45.225])
        by smtp.gmail.com with ESMTPSA id b18-20020a1709063cb200b007778c9b7629sm9056305ejh.34.2022.09.15.05.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 05:41:42 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-hwmon@vger.kernel.org
Cc:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [RESEND PATCH] ixgbe: Don't call kmap() on page allocated with GFP_ATOMIC
Date:   Thu, 15 Sep 2022 14:40:12 +0200
Message-Id: <20220915124012.28811-1-fmdefrancesco@gmail.com>
X-Mailer: git-send-email 2.37.3
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

Pages allocated with GFP_ATOMIC cannot come from Highmem. This is why
there is no need to call kmap() on them.

Therefore, don't call kmap() on rx_buffer->page() and instead use a
plain page_address() to get the kernel address.

Suggested-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Alexander Duyck <alexander.duyck@gmail.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
---

I send again this patch because it was submitted more than two months ago,
Monday 4th July 2022, but for one or more (good?) reasons it has not yet
reached Linus' tree. In the meantime I am also forwarding two "Reviewed-by"
and one "Tested-by" tags (thanks a lot to Ira, Alexander, Gurucharan).
Obviously I have not made any changes to the code.

 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 04f453eabef6..cb5c707538a5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1964,15 +1964,13 @@ static bool ixgbe_check_lbtest_frame(struct ixgbe_rx_buffer *rx_buffer,
 
 	frame_size >>= 1;
 
-	data = kmap(rx_buffer->page) + rx_buffer->page_offset;
+	data = page_address(rx_buffer->page) + rx_buffer->page_offset;
 
 	if (data[3] != 0xFF ||
 	    data[frame_size + 10] != 0xBE ||
 	    data[frame_size + 12] != 0xAF)
 		match = false;
 
-	kunmap(rx_buffer->page);
-
 	return match;
 }
 
-- 
2.37.2

