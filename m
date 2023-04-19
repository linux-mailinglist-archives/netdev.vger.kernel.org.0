Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5513A6E70B0
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 03:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjDSBQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 21:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjDSBQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 21:16:29 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39819E4D;
        Tue, 18 Apr 2023 18:16:28 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b5c48ea09so2346223b3a.1;
        Tue, 18 Apr 2023 18:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681866988; x=1684458988;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l7KcAK1S7DUZq/Db3Jz+q+bCAF609VatxfLnf+LJlvo=;
        b=UImrKatqY1FwR0yQweibDR4DseukfyBwClwOPcMSYL3LBowh0aaBzIJSwFoWoMpZRx
         ZSWprAGqMtPABENmu6U6o5rsAqL42xljbObDCdLi6RpQtW6TLxizruD/9K06SRsgLK6s
         BJvj3ltjBCwGMLO9bjQbpfHPQH8UFr9M1+kbeiylIgLuLpOhWZ5MBOUTSyLFfy6HlYqz
         IwCO5OogzV7U5Yvaa31THa8mXH0Kj8DLkBLG1CGBXLWDKruXECOmGTkpVZ7gSzycuTCJ
         9gDXKcTm3dKfe6Ss4wV4g7/JEMCV1dM7fPygD/70/S4oMNXqIrZ0VMD9WKinPLiZSpCH
         m14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681866988; x=1684458988;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l7KcAK1S7DUZq/Db3Jz+q+bCAF609VatxfLnf+LJlvo=;
        b=eaHxFzCmtI5NFLwRlo8k7o1qW0ToznYDrr7xnOBJSswcmttbrE3vQWbciXRLXHfo5p
         B+P/gMeQ/GnXigSwU53iZQ+luRtDgMsZ+WZY6DJw5fkiELrfp+kxeXGR4ogGjvg939f0
         j30u5YwplorxInXrhJtz+Mv89Wy6QTIS7bn9YzOAXhTLEgWOSIXliNWBvZqwxqMwKeh+
         /5fsUWpnTTlva5gbFVxFXTvewrWdzGbfgmWN0+FhazaLvx9fPnvsZDzmXui+NV6QXJwE
         pjl6KRDUMDxsnijh31XvIrHnOrXFyu7yLa/SAt2jVWX925yCfZURdUfxs4TWKv/Ovedk
         Z+dQ==
X-Gm-Message-State: AAQBX9eD5/cvMp0CEKAfi9paA28KZkBpiiZF33D+HxBKrDA0DFQxxGtO
        1qlnGOv87asW1ya5PE6e6oitzFK9Wt/gkNxh
X-Google-Smtp-Source: AKy350YjcaDx5WmdZkF9f2yyCEe57eKJTE93TCYPqXHAZDDTX2kvT5q/9JN9Nvf4osvomTvKY0qU6A==
X-Received: by 2002:a05:6a00:1493:b0:63b:19e5:a9ec with SMTP id v19-20020a056a00149300b0063b19e5a9ecmr2033968pfu.33.1681866987601;
        Tue, 18 Apr 2023 18:16:27 -0700 (PDT)
Received: from yoga ([2400:1f00:13:d56c:e810:608c:4286:179f])
        by smtp.gmail.com with ESMTPSA id q25-20020a62ae19000000b0063b89300316sm5232157pff.14.2023.04.18.18.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 18:16:27 -0700 (PDT)
Date:   Wed, 19 Apr 2023 06:46:20 +0530
From:   Anup Sharma <anupnewsmail@gmail.com>
To:     krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linma@zju.edu.cn, dvyukov@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: nfc: nci: fix for UBSAN: shift-out-of-bounds in
 nci_activate_target
Message-ID: <ZD9A5Krm+ZoFEFWZ@yoga>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found  UBSAN: shift-out-of-bounds in nci_activate_target [1],
when nci_target->supported_protocols is bigger than UNIT_MAX,
where supported_protocols is unsigned 32-bit interger type.

32 is the maximum allowed for supported_protocols. Added a check
for it. 

[1] UBSAN: shift-out-of-bounds in net/nfc/nci/core.c:912:45
shift exponent 4294967071 is too large for 32-bit type 'int'
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x136/0x150 lib/dump_stack.c:106
 ubsan_epilogue lib/ubsan.c:217 [inline]
 __ubsan_handle_shift_out_of_bounds+0x221/0x5a0 lib/ubsan.c:387
 nci_activate_target.cold+0x1a/0x1f net/nfc/nci/core.c:912
 nfc_activate_target+0x1f8/0x4c0 net/nfc/core.c:420
 nfc_genl_activate_target+0x1f3/0x290 net/nfc/netlink.c:900
 genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]

Reported-by: syzbot+0839b78e119aae1fec78@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=19cf2724120ef8c51c8d2566df0cc34617188433

Signed-off-by: anupsharma <anupnewsmail@gmail.com>
---
 net/nfc/nci/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index fff755dde30d..e9d968bd1cd9 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -908,6 +908,11 @@ static int nci_activate_target(struct nfc_dev *nfc_dev,
 		pr_err("unable to find the selected target\n");
 		return -EINVAL;
 	}
+	
+	if (nci_target->supported_protocols >= 32) {
+		pr_err("Too many supported protocol by the device\n");
+		return -EINVAL;
+	}
 
 	if (!(nci_target->supported_protocols & (1 << protocol))) {
 		pr_err("target does not support the requested protocol 0x%x\n",
-- 
2.34.1

