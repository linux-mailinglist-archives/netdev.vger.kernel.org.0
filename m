Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7193545074
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344293AbiFIPR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344039AbiFIPRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:17:22 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E9E4475B;
        Thu,  9 Jun 2022 08:17:19 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id q11so1230532qtn.0;
        Thu, 09 Jun 2022 08:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IYjc+rNFmp3AJxr+2pm0gGrx/IzB3ZsbKxwBjGVt2GU=;
        b=E5UL24uIgQumjQO9JsE9eBxhpgeBN9Xw57u8YEKwa3vIjV155BnR+nKIBrrN5HziCu
         Bj2JlN2n6FPns73hvIaaznD3IHphmh/4DxpzuNaZQOQbha0e2h/Y5VZZA9VkXz5E8uPJ
         B+deIS6f72QPPn3WM9owAJawJYZcWHDcLf61oULINwA/krisV8Ag/8/l9jwDVlSOcgak
         g5YDdZ7HVUupl4Li9b5AQWSfgubgOaUFF79Yl0K7bToaqlQcQdvLm0BjU2jq2v57VQeZ
         x39yfDMdyv5l9oCBB4sHST3BFYL7x91AMGm8k4NiopwVqBKghCce5ahSL1um37I4njuC
         5BkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IYjc+rNFmp3AJxr+2pm0gGrx/IzB3ZsbKxwBjGVt2GU=;
        b=KNS3I1QBlwTensPlal3tYY7UsFczjKcsEQpueN33TQ8ES3OgW6adfsM7vP8Pg2ja2+
         5EnVRvfkjobAbqTb2qirlkrKNDR42qjJtirZj1TAw8G7L0s4V3Mgh197QX48oKaWVxY3
         HxhmQmlT4iIHC4KcZUqlY/6R86XYWLBdtf/uBKE/3HWeiLr3qYifgLWy3j27ZXNYjI4u
         3T/VYbIKxBLA5ipvwgWqKCmlZqIrkv42LRRW39eT4o0GTyFMoAg18VCQUg7GBfqlvypO
         hUa5508lquvItbmASsYYvt1HyUvICWvhLFb7d/AprN4l/UYcjaZqM5y1z8hhG7yFVsRV
         hTHQ==
X-Gm-Message-State: AOAM5338GT5V0dKUb5WSUO6di0CUNMvnxPV1e9R9h0sqG+Tb94nhjmB1
        +Yuj7dSNzWJ2SdSg7eJalZPje3c7W2K2i7Nk
X-Google-Smtp-Source: ABdhPJy4On/33fJVKnGj1dpACVNzJj18nZMDj0ogLWrORpOhK7ivPcuDaaWBPm9Wav0Ai/llyJk4Sg==
X-Received: by 2002:a05:622a:44b:b0:2f9:3af4:d451 with SMTP id o11-20020a05622a044b00b002f93af4d451mr32018850qtx.587.1654787838123;
        Thu, 09 Jun 2022 08:17:18 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id n64-20020a37bd43000000b006a60190ed0fsm18199469qkf.74.2022.06.09.08.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 08:17:17 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCHv2 net 1/3] Documentation: add description for net.sctp.reconf_enable
Date:   Thu,  9 Jun 2022 11:17:13 -0400
Message-Id: <c09cab1e25ab3ad625ff72a3449e3e2149d1b165.1654787716.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1654787716.git.lucien.xin@gmail.com>
References: <cover.1654787716.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe it in networking/ip-sysctl.rst like other SCTP options.

Fixes: c0d8bab6ae51 ("sctp: add get and set sockopt for reconf_enable")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b882d4238581..3abd494053a9 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2930,6 +2930,17 @@ plpmtud_probe_interval - INTEGER
 
 	Default: 0
 
+reconf_enable - BOOLEAN
+        Enable or disable extension of Stream Reconfiguration functionality
+        specified in RFC6525. This extension provides the ability to "reset"
+        a stream, and it includes the Parameters of "Outgoing/Incoming SSN
+        Reset", "SSN/TSN Reset" and "Add Outgoing/Incoming Streams".
+
+	- 1: Enable extension.
+	- 0: Disable extension.
+
+	Default: 0
+
 
 ``/proc/sys/net/core/*``
 ========================
-- 
2.31.1

