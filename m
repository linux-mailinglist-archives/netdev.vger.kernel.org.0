Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3735EB393
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiIZVuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiIZVuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:50:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54ADEA4856;
        Mon, 26 Sep 2022 14:50:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF6B061470;
        Mon, 26 Sep 2022 21:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD44C433D7;
        Mon, 26 Sep 2022 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664229009;
        bh=l0Dc2OIgK6lDM9BiZQEoOrqzj1XCqlR7nr3AsvHsNAI=;
        h=Date:From:To:Cc:Subject:From;
        b=l5jarwkxEMBNTo7wGZhpGo/oDMGwId6FaZfNamx8do5p5G+EuOLUw80blLhpv/S7S
         +hBOIRjwVEoOvePV14Do9qikJyGZ6ARj/bGv2YeMCRdt8pwLXiFmCX6W63XKKIm5vs
         pDJXisCZM2a8yS814sMGAX9UuEpwC03U/B7W2VTOXBCWGCwdEBjiWb6UYVZfNG48pV
         0wqvAq185oVotTBuCn1T3GBEloYhwgiRUDCnQo7w084FgCiT1bfb1DVj6sU07AxYgm
         JrxazJJrYJhPT/FuXA+ScF7vbtOUxklEBgau8OFzELTpOVTiL4D+DhAgUpvvksTLwp
         FF11Pp95h2GIA==
Date:   Mon, 26 Sep 2022 16:50:03 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: ethernet: rmnet: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <YzIei3tLO1IWtMjs@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length arrays
declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
helper macro.

This helper allows for flexible-array members in unions.

Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/221
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index e5a0b38f7dbe..2b033060fc20 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -19,7 +19,7 @@ struct rmnet_map_control_command {
 			__be16 flow_control_seq_num;
 			__be32 qos_id;
 		} flow_control;
-		u8 data[0];
+		DECLARE_FLEX_ARRAY(u8, data);
 	};
 }  __aligned(1);
 
-- 
2.34.1

