Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446554B9181
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbiBPTmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:42:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238195AbiBPTmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:42:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C7BCB905;
        Wed, 16 Feb 2022 11:41:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C7AD5CE288B;
        Wed, 16 Feb 2022 19:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0176C004E1;
        Wed, 16 Feb 2022 19:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645040516;
        bh=nz/9I2zddTR157wwb50ivThq1Ru0izLuRo74wIxlESo=;
        h=Date:From:To:Cc:Subject:From;
        b=mp7yb1cpNCbOeL04bAt4W8vgPFJitBZZu2Ud1rEHtt74JKahuz/JA4PcKPc+weDxn
         13Rlqh5Gi3hHg+fTyUQSqwV5FLZ2j5xntv9VUoqFw0tlIQ9OOl5815MaTV7UQhDXMI
         o38y1AmaDyFaVOvPTFPd0TGDclHB2pp8cdRlp0KVDPOjPGfLHJOn75A1AcLFnA8lOd
         DeD+UrfLS2OsYjpyhF4VZvXQt7sUOKid8HhI5ka7PuAoZ6utwJ8/2LfevwXf6wPFZQ
         BHlwcBkwPDrRU0/uQW7oifp6nvCi0T31w0SVH/4H2FrB24pIQs90rN1OmWlMVTfxWR
         lH9ntx3kf6rbw==
Date:   Wed, 16 Feb 2022 13:49:35 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] brcmfmac: Replace zero-length arrays with
 flexible-array members
Message-ID: <20220216194935.GA904103@embeddedor>
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
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.h       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index e69d1e56996f..c87b829adb0d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -1068,7 +1068,7 @@ struct brcmf_mkeep_alive_pkt_le {
 	__le32  period_msec;
 	__le16  len_bytes;
 	u8   keep_alive_id;
-	u8   data[0];
+	u8   data[];
 } __packed;
 
 #endif /* FWIL_TYPES_H_ */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.h
index e1930ce1b642..b2c7ae8966a1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.h
@@ -15,7 +15,7 @@
 struct brcmf_xtlv {
 	u16 id;
 	u16 len;
-	u8 data[0];
+	u8 data[];
 };
 
 enum brcmf_xtlv_option {
-- 
2.27.0

