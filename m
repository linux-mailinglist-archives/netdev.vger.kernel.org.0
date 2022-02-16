Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EC54B9171
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiBPTkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:40:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238113AbiBPTkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:40:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52F128B636;
        Wed, 16 Feb 2022 11:40:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FAE66185F;
        Wed, 16 Feb 2022 19:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AC4C004E1;
        Wed, 16 Feb 2022 19:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645040427;
        bh=AujISKMm3XyoLDMIk3p5HcFU3+0xU5+dA8Sed0Hwfw4=;
        h=Date:From:To:Cc:Subject:From;
        b=DpvHL5oep/tbOSM43uv3wRPdV5n/OJQ1B54+iJliGGdBY8yE/VMr6HdLqbb07ao0c
         bdLaAtj6s4O5Yxc936mJ8AnfBV3ZXbCfsuto2JVwSO+lhuPTeNZrSh3OdChv+vzknM
         nQDxWR9ZljvdQ0SGs8Oru2UUxZmJ0MtpavUPPTr7NIeOnIJCgLJ0KUWeLvy3XXeZyw
         L4h2s+bEO239hNdhpjjniVbl3f+4gbfToAwaIx3Q/GutKHZULCrOYSxVncGnfvul3r
         ECJtOkpiYUSxN+u8WRALtHetDwxfX0CJTOE5ZHxJBR+zemFB2mTNfKnbxTojURbeVg
         9up2hYvs90PNQ==
Date:   Wed, 16 Feb 2022 13:48:07 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ath10k: Replace zero-length array with flexible-array
 member
Message-ID: <20220216194807.GA904008@embeddedor>
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
 drivers/net/wireless/ath/ath10k/swap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/swap.h b/drivers/net/wireless/ath/ath10k/swap.h
index 25e0ad36ddb1..b4733b5ded34 100644
--- a/drivers/net/wireless/ath/ath10k/swap.h
+++ b/drivers/net/wireless/ath/ath10k/swap.h
@@ -17,7 +17,7 @@ struct ath10k_fw_file;
 struct ath10k_swap_code_seg_tlv {
 	__le32 address;
 	__le32 length;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct ath10k_swap_code_seg_tail {
-- 
2.27.0

