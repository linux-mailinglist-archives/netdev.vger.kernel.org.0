Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4014458638A
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 06:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbiHAEaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 00:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239436AbiHAE3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 00:29:49 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F0F140AF
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:29:25 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l11-20020a170902f68b00b0016ee1c2c0deso1889872plg.2
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1bQbst9icU8PzrBH3x9FY5YwDFo9gdkmYY4v3XzOPoA=;
        b=nYIVllHuj+lpycvPE1ZOmapJ6S2uOuZKeWAnIWJ6qQAOjzjH9xA8vufIqCpd7WmsYW
         aqr5H5NaGqbORFkq8pjFnX1t/6Lrf61FQWVYB5hC9xmIbTxLGVgPcGrTBVBGM5b4KdV9
         LD4sEp8DHaroGU/12I8AkN2LL/GmRIl+TpZYoTtU5OuloiTMdhJO4qCSfUUrQYsmUbJG
         0Mw+ysIvTcstsH1ObeEVLdT99vp+Gq4JNAzg34iML8fQg0BqRR8DrlCj+ahOwoVXtMnG
         VPmwdWQUBts65He+v+CjFIX9Vy3ted1U5e+gYH9/j2sJ/EPV+UpgFi49XSpCbX6epsSK
         DXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1bQbst9icU8PzrBH3x9FY5YwDFo9gdkmYY4v3XzOPoA=;
        b=66CGM+/CszIrJ3G0XW5LO6IRicrvYO7J4xTq/8OYlWGMIkH77m/lJ5xe2sXCOAmrwt
         0QT5SHnjKPASXMN397s94eLXhR3jdjp3mGBnfYtlA1V38Kef2I62TEkYoWFq3s97Bkh9
         +RnXaCrvWyGZxYvmXVW56sO4Ymigjryl1n49f/uLPOTM5uJsskkSFopkVPPr3HCaEb41
         xTBNksGQnS4nmXQcwAzDhcUCult6S5ng/QSMQqo3gDMf0jcHgtd79a4cKBSY4gqtkk1T
         x59rsfvamCgIAUKSiWQy/xJlThi0E6aXiNH4mKEhvkTSEeUsa4af2Xipndc0qOjAiILv
         MZJw==
X-Gm-Message-State: ACgBeo0/GsXGDCLEylxczue07ZOxJyNiz13v1l6jZAPPvfohZ4rp9LTm
        PPofiUfw9OxM6E//Ml27vu3oUZhxYks3
X-Google-Smtp-Source: AA6agR6/PQNxetyTw87QGRgI8/orhOO6IHB2AfZi0+8Sb9nacfASDTQusW/A7OtYG6QbLMmlsxbIIZ5mnXRY
X-Received: from ezekiel.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:108e])
 (user=shraash job=sendgmr) by 2002:a17:90a:df03:b0:1f3:396c:dd94 with SMTP id
 gp3-20020a17090adf0300b001f3396cdd94mr626688pjb.1.1659328164765; Sun, 31 Jul
 2022 21:29:24 -0700 (PDT)
Date:   Mon,  1 Aug 2022 09:59:18 +0530
Message-Id: <20220801042918.292541-1-shraash@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH] Bluetooth: Replace IS_ERR_OR_NULL with IS_ERR
From:   Aashish Sharma <shraash@google.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, groeck@chromium.org,
        mfaltesek@google.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aashish Sharma <shraash@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since bt_skb_sendmsg never returns NULL, replace IS_ERR_OR_NULL
with IS_ERR.

Signed-off-by: Aashish Sharma <shraash@google.com>
---
 include/net/bluetooth/bluetooth.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 6b48d9e2aab9..a8b52175af05 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -494,7 +494,7 @@ static inline struct sk_buff *bt_skb_sendmmsg(struct sock *sk,
 	struct sk_buff *skb, **frag;
 
 	skb = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
-	if (IS_ERR_OR_NULL(skb))
+	if (IS_ERR(skb))
 		return skb;
 
 	len -= skb->len;
-- 
2.37.1.455.g008518b4e5-goog

