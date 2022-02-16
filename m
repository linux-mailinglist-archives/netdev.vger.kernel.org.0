Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3184B918B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbiBPTmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:42:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238219AbiBPTmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:42:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20800119430;
        Wed, 16 Feb 2022 11:42:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B57ACE288B;
        Wed, 16 Feb 2022 19:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378C6C004E1;
        Wed, 16 Feb 2022 19:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645040536;
        bh=KKLApG7P3ypXXyd/K5DQGOQFYrfkFH7qZ/Cc03GkFUQ=;
        h=Date:From:To:Cc:Subject:From;
        b=GSkIcvtQ1RiRnrOgSHaEqjADs9BDE1MYkBg1YzNxEkb3jkI36mHm3QFXOEPAUhW76
         t9WMYkL3bmw/EYcvfg7/Hx8/cLDtydj+rHVW2XUNCKF55IUc687o79pQyp5s3V7CAW
         eGVLYFXdmh7xg2tuHV+COr1ii9Ob4UzQXi03Dwv75CMwcvUEiBoP0dMOuRt+Y5Oj+t
         HHsGI+isXAYhJ9LZwwKTJLmy3/XXDHQYTcpzbOLAfKjd2LCuDGTCJS4KTYsc07lK/C
         pkp5VEIAxJnDkXR7+nNgSAGcZFT7P3OUh5+iheiBcf2IXrmrPBppWgKZwmc9gT3+Km
         RBh/MvafSO6LA==
Date:   Wed, 16 Feb 2022 13:49:55 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] carl9170: Replace zero-length arrays with
 flexible-array members
Message-ID: <20220216194955.GA904126@embeddedor>
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
 drivers/net/wireless/ath/carl9170/fwdesc.h | 2 +-
 drivers/net/wireless/ath/carl9170/wlan.h   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fwdesc.h b/drivers/net/wireless/ath/carl9170/fwdesc.h
index 503b21abbba5..10acb6ad30d0 100644
--- a/drivers/net/wireless/ath/carl9170/fwdesc.h
+++ b/drivers/net/wireless/ath/carl9170/fwdesc.h
@@ -149,7 +149,7 @@ struct carl9170fw_fix_entry {
 
 struct carl9170fw_fix_desc {
 	struct carl9170fw_desc_head head;
-	struct carl9170fw_fix_entry data[0];
+	struct carl9170fw_fix_entry data[];
 } __packed;
 #define CARL9170FW_FIX_DESC_SIZE			\
 	(sizeof(struct carl9170fw_fix_desc))
diff --git a/drivers/net/wireless/ath/carl9170/wlan.h b/drivers/net/wireless/ath/carl9170/wlan.h
index bb73553fd7c2..0a4e42e806b9 100644
--- a/drivers/net/wireless/ath/carl9170/wlan.h
+++ b/drivers/net/wireless/ath/carl9170/wlan.h
@@ -327,7 +327,7 @@ struct _carl9170_tx_superdesc {
 struct _carl9170_tx_superframe {
 	struct _carl9170_tx_superdesc s;
 	struct _ar9170_tx_hwdesc f;
-	u8 frame_data[0];
+	u8 frame_data[];
 } __packed __aligned(4);
 
 #define	CARL9170_TX_SUPERDESC_LEN		24
-- 
2.27.0

