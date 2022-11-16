Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F3362B0F0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 03:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiKPCAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 21:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiKPB76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 20:59:58 -0500
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A8B2A97C
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 17:59:51 -0800 (PST)
X-QQ-mid: bizesmtp73t1668563983tly43l9x
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 16 Nov 2022 09:59:33 +0800 (CST)
X-QQ-SSF: 01400000000000H0W000000A0000000
X-QQ-FEAT: Gq6/1HjPYVWnCBgfKLrD1glblj7p5aEzEzYS2LdMGpifoTkR5l8v/6VZcej6s
        chooZaT9STSfvIktkdGvhtqx3FrpgntWjwBgEtFDaMsZihbud8wEGNNkTPYdKU7wH/GvNN9
        1UyeIkKV62wIaoXgWxu0l7lJJzj0JucTJssck8/G7CWm8OM+1sW8iTUx9ztSVf/rhTEVJkU
        DVVQRDHw9WWTZVIh8TbYcjagzTg5fBcPcSIFXfPKUYvDV2DUjdCYKsNf6jS9RCRRtRUrWEz
        K3N9HFF+q6Ks3BG7xVaRy8UZ1UgnVn1AKDo6MJuknXGVR85exzoKaKzTWLo9znQJWJeTrtw
        1fa2eBZLEu0CLAUBdBZJPEwbGpdgsTkRmJzw4EkT/cNbKO+qLM=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next] net: libwx: Fix dead code for duplicate check
Date:   Wed, 16 Nov 2022 09:58:35 +0800
Message-Id: <20221116015835.1187783-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix duplicate check on polling timeout.

Fixes: 1efa9bfe58c5 ("net: libwx: Implement interaction with firmware")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 1eb7388f1dd5..c57dc3238b3f 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -203,8 +203,6 @@ int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
 
 	status = read_poll_timeout(rd32, hicr, hicr & WX_MNG_MBOX_CTL_FWRDY, 1000,
 				   timeout * 1000, false, wxhw, WX_MNG_MBOX_CTL);
-	if (status)
-		goto rel_out;
 
 	/* Check command completion */
 	if (status) {
-- 
2.27.0

