Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE6964C204
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 02:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbiLNBwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 20:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbiLNBwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 20:52:40 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC771A9
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 17:52:36 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d7so1819240pll.9
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 17:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rZGdSlQmdy5GLZOw5t3ZBPVFlE2astpyO7HmGabzmH0=;
        b=3h5KqfcPh+XytqujRm0hiWK/zzu2kEWgUBw/m/bmsZd4ayOoL9xLfj3pVlCXmaRTm5
         UHNHmqhDzaud9cKtKHGoP2RpYT/4sigoWXxvF3+Tzl8DT/0yGSaZA2e6/wvNVI2KY9z+
         WQ56uWdVF2kV6dtMB2gcmY4RoCrMpvCZRlJ9Ps0k1OpWWWJWwKyPAo2idXJYGrW8CD9W
         EB0UbtwG0pPv4Fcj1bCS6qAj9GrApZzEpuzUCEw1hGMLV/CwMjmOONYIyvJ6G4VADBM3
         1O/+6CpvkurmhxHZ7QTqUeKkV7nrbPOD1ZauaYm7kRhkzHHNFLe5K1A5BvZxDZZUBpET
         um0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rZGdSlQmdy5GLZOw5t3ZBPVFlE2astpyO7HmGabzmH0=;
        b=f8a2sxm2pG2hD0P3qoQXuJi+s23BzehzGEdXFN1VP0osqjKh24N7mEUvL8yE33ekZv
         LdtUkWeMYsSIZDeyRY4yUUKYMM6l3Cten7E02Mg6V9kHV4ulbZ29xW+z3WO/zVR5nblc
         yO78gnFcVkoWxyk3k+qR5SrTu/rJr5vxnPd26gkyfOJ0F5rWuoVmZHQRNdMdiN5kVAXR
         gbuo5FNGrqwAgHTAGxl+m++6SLHy/zYx0kBvQwx8ZZvKS+IrhKg9HgdMGEY1/Fh2xoNV
         GgN2R8+PDTtIi3T+jGO83wTOOuoCOAonR9K9ZxTOvJHuNyEUpFXFz+yhxXaP9c9w6HuK
         dsMw==
X-Gm-Message-State: ANoB5pkjg2rOjpLEeKHjJ4CskXxMr6aPeAjmSCpVC9hip88fPleQ6/Af
        ewbRtXQOTQ/Aimb0H1f5TsG+GVe7Rk9SHEcbH7E=
X-Google-Smtp-Source: AA0mqf50oAG2KjtSc5ZCB3XSNin1LkDkId20keZP3NioHFy3kRkBxp73fGOnGfipyrTZNUllO7ddkw==
X-Received: by 2002:a05:6a21:999d:b0:a3:d250:2964 with SMTP id ve29-20020a056a21999d00b000a3d2502964mr34687823pzb.40.1670982755659;
        Tue, 13 Dec 2022 17:52:35 -0800 (PST)
Received: from localhost.localdomain ([165.132.118.52])
        by smtp.gmail.com with ESMTPSA id e10-20020a17090301ca00b00189af02aba4sm569017plh.3.2022.12.13.17.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 17:52:35 -0800 (PST)
From:   Minsuk Kang <linuxlovemin@yonsei.ac.kr>
To:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        linville@tuxdriver.com, dokyungs@yonsei.ac.kr,
        jisoo.jang@yonsei.ac.kr, Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Subject: [PATCH net v3] nfc: pn533: Clear nfc_target before being used
Date:   Wed, 14 Dec 2022 10:51:39 +0900
Message-Id: <20221214015139.119673-1-linuxlovemin@yonsei.ac.kr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a slab-out-of-bounds read that occurs in nla_put() called from
nfc_genl_send_target() when target->sensb_res_len, which is duplicated
from an nfc_target in pn533, is too large as the nfc_target is not
properly initialized and retains garbage values. Clear nfc_targets with
memset() before they are used.

Found by a modified version of syzkaller.

BUG: KASAN: slab-out-of-bounds in nla_put
Call Trace:
 memcpy
 nla_put
 nfc_genl_dump_targets
 genl_lock_dumpit
 netlink_dump
 __netlink_dump_start
 genl_family_rcv_msg_dumpit
 genl_rcv_msg
 netlink_rcv_skb
 genl_rcv
 netlink_unicast
 netlink_sendmsg
 sock_sendmsg
 ____sys_sendmsg
 ___sys_sendmsg
 __sys_sendmsg
 do_syscall_64

Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
Fixes: 361f3cb7f9cf ("NFC: DEP link hook implementation for pn533")
Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
---
v2->v3:
  Remove an inappropriate tag

v1->v2:
  Clear another nfc_target in pn533_in_dep_link_up_complete()
  Fix the commit message

 drivers/nfc/pn533/pn533.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index d9f6367b9993..f0cac1900552 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -1295,6 +1295,8 @@ static int pn533_poll_dep_complete(struct pn533 *dev, void *arg,
 	if (IS_ERR(resp))
 		return PTR_ERR(resp);
 
+	memset(&nfc_target, 0, sizeof(struct nfc_target));
+
 	rsp = (struct pn533_cmd_jump_dep_response *)resp->data;
 
 	rc = rsp->status & PN533_CMD_RET_MASK;
@@ -1926,6 +1928,8 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 
 		dev_dbg(dev->dev, "Creating new target\n");
 
+		memset(&nfc_target, 0, sizeof(struct nfc_target));
+
 		nfc_target.supported_protocols = NFC_PROTO_NFC_DEP_MASK;
 		nfc_target.nfcid1_len = 10;
 		memcpy(nfc_target.nfcid1, rsp->nfcid3t, nfc_target.nfcid1_len);
-- 
2.25.1

