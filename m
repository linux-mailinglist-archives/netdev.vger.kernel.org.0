Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1ED24B917E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238188AbiBPTlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:41:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237789AbiBPTlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:41:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAE815A3D;
        Wed, 16 Feb 2022 11:41:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D55056185A;
        Wed, 16 Feb 2022 19:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F560C004E1;
        Wed, 16 Feb 2022 19:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645040495;
        bh=kehotYmjeujCHApxl69MP1JNJIRXwFHOlF7rBNyRfaY=;
        h=Date:From:To:Cc:Subject:From;
        b=t8YWuJkNOtGY2bo1h6XlXPm7wSf9R9FKNjH3l2wCjM++U+h43Be+QKRqq7qYuF/j9
         yAvj3FV5G7ZtVSeFsQSTzdMg/p9q0bQr5o/ELPqmuJclkWk2mn1rUfkmL5YZ5QGCEw
         mEnH88aRVuxrWFuxERh44oYeqrMpnAWwmf+7+81m20DDdOyIf6q1p5Urt8EXT42Omj
         N1rmfhffK3kFs/TKjATvrKlXIhaOg36YWG/tFv+RZYFlKMGJMgDIa7/Zb4hswn9mfP
         N/Uipac+7izk+hLnpXKyoGstnrcDBqLosk/yhmoDsNe4zdjIeYiC1woYKn/bvXDvGr
         6zxEADlSYITsg==
Date:   Wed, 16 Feb 2022 13:49:15 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ath: Replace zero-length arrays with flexible-array
 members
Message-ID: <20220216194915.GA904081@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare
having a dynamically sized set of trailing elements in a structure.
Kernel code should always use “flexible array members”[1] for these
cases. The older style of one-element or zero-length arrays should
no longer be used[2].

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/spectral_common.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/spectral_common.h b/drivers/net/wireless/ath/spectral_common.h
index e14f374f97d4..fe187c1fbeb0 100644
--- a/drivers/net/wireless/ath/spectral_common.h
+++ b/drivers/net/wireless/ath/spectral_common.h
@@ -108,7 +108,7 @@ struct fft_sample_ath10k {
 	u8 avgpwr_db;
 	u8 max_exp;
 
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct fft_sample_ath11k {
@@ -123,7 +123,7 @@ struct fft_sample_ath11k {
 	__be32 tsf;
 	__be32 noise;
 
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #endif /* SPECTRAL_COMMON_H */
-- 
2.27.0

