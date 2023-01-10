Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C416636B9
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 02:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjAJBhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 20:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjAJBht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 20:37:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94212200A;
        Mon,  9 Jan 2023 17:37:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 495E8B810C3;
        Tue, 10 Jan 2023 01:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87324C433D2;
        Tue, 10 Jan 2023 01:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673314666;
        bh=TVslpPBIR8MuKlhIXlT+VUj5823H7/tO3yYzmKXgFEA=;
        h=Date:From:To:Cc:Subject:From;
        b=rGhM1W7KtwevREfbvXh7z3X0wYmbJRJyuefm+/4jWa1Mzg/jfQRCoZWF7NHURVXey
         rdPfb/Hey4eV1r1tcYjl0Gc2RJOU6YadJ6MuEzzeNUBLUezA/EWbIICvQTeiHA/KIS
         FGmLwrCJDHLdYsfLL55xeuWOkfyyQNBBjVrAaw5KrhOd9OoKwRvU/ng7JR32Uw6ZRB
         SQN4UwZwR1b1DYgWeV8SCAv2U8EyKhrPUZLX9CPrfMCZ9c2/SMUaf9IqiORrALavnB
         9u540tntexY3G359O4qyhF7KZRlky9dxfFPsmNdvrj6iih7uc9zM5mR6efx8B1+vG4
         bRrmd1dDK4lUQ==
Date:   Mon, 9 Jan 2023 19:37:52 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] Bluetooth: HCI: Replace zero-length arrays with
 flexible-array members
Message-ID: <Y7zBcCkkuIIS4ueP@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated[1] and we are moving towards
adopting C99 flexible-array members instead. So, replace zero-length
arrays in a couple of structures with flex-array members.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [2].

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays [1]
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [2]
Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/net/bluetooth/hci.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 8d773b042c85..400f8a7d0c3f 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2156,7 +2156,7 @@ struct hci_cp_le_big_create_sync {
 	__u8    mse;
 	__le16  timeout;
 	__u8    num_bis;
-	__u8    bis[0];
+	__u8    bis[];
 } __packed;
 
 #define HCI_OP_LE_BIG_TERM_SYNC			0x206c
@@ -2174,7 +2174,7 @@ struct hci_cp_le_setup_iso_path {
 	__le16  codec_vid;
 	__u8    delay[3];
 	__u8    codec_cfg_len;
-	__u8    codec_cfg[0];
+	__u8    codec_cfg[];
 } __packed;
 
 struct hci_rp_le_setup_iso_path {
-- 
2.34.1

