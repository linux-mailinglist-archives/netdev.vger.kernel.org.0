Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315BD53D165
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347177AbiFCS1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347175AbiFCS1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:27:05 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1F5562D9;
        Fri,  3 Jun 2022 11:09:32 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id a184so3042741qkg.5;
        Fri, 03 Jun 2022 11:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Ee0cU/5frKXnfZeYsbhINP1OFIPN9yEZZMW3gUKSoE=;
        b=pg3/+cnQ5m2bHMRYR6k39tpeZn+sR0DqykNRuxSbuFHilq1JohNyNZ70sQ1kQ9q/VK
         mRuEMudSfWyN8WYi0TSQ9uVYo0JHv6e2CZKssTXIZkmRVN0YzLnntsouBd2N8MBqizYm
         WfKndSFCbPcs2bdf16oskT1tGtIofuAb1yzwD+nyL8hFpFw2FYvgs4Xde5lobUmxtN5E
         1dq/XfTAt9iNz3SOrFXh/NGIoIh39/gOsbSu0AWBISKUp1C8xKcJ6GiVikK2OE+eDJAN
         xofujf9uexyCb5ml3uPdQExc27ML59oL49XUnqYLm7JjOe0N2hJrkAOcam0uOTZSfWrR
         g/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Ee0cU/5frKXnfZeYsbhINP1OFIPN9yEZZMW3gUKSoE=;
        b=Ctm8PZG0oWD9YBfyItEb6w1T/1kBkMKopbV4FhNlbSQt8sR/fLxNHx4D38VDQu3s+M
         DVgwUUoKoEkCyxhoWASfLKPOqpl287OAqXPPr7IwhWHo8XVuODQ0bRHWZ9og2c6ZWWgu
         Hf1Ou4cWKdDNO5EkNOu/y1vQM4jd19D4gcw5gQfNKd91pyd/jaH8TwHlm/RtL+AjGavn
         O6rjb/v4jh3mg4xjIznPUqCInztW4lFmVdGBSPOKjVi9LaXEFapHxwSLqGgrU9nQHGRc
         vx2VNFBkSz4O0OFT0SrZMh4BJpQYQ+1Vz+rTH4WnudQLe+ozthE9jzdDR/rDS7iTKUy+
         mZHw==
X-Gm-Message-State: AOAM531f+8FktU0wIM0pDCxlFHFaDnfvSijwIi1Ft6bo69aE+gTnuvyl
        tvW1OU7PP3LTKsNlxZi8awcI7vlvHIdpByFu
X-Google-Smtp-Source: ABdhPJxPhnQ5/pS+Fp1/oyLGqSADdM55pBJYve8R3LzXZXjEQtK/zdDcnzFoKJxjS7IlOqx1dEr+oQ==
X-Received: by 2002:a37:87c7:0:b0:6a6:31b2:b13d with SMTP id j190-20020a3787c7000000b006a631b2b13dmr7730800qkd.364.1654279768419;
        Fri, 03 Jun 2022 11:09:28 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f4-20020a05620a20c400b006a659ce9821sm5187589qka.63.2022.06.03.11.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:09:28 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net 2/3] Documentation: add description for net.sctp.intl_enable
Date:   Fri,  3 Jun 2022 14:09:24 -0400
Message-Id: <1fc59e854d7b9c66f4ab681dbe2a9eb91219f3a4.1654279751.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1654279751.git.lucien.xin@gmail.com>
References: <cover.1654279751.git.lucien.xin@gmail.com>
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
We need to document this especailly as when using the feature
of User Message Interleaving, some socket options also needs
to be set.

Fixes: 463118c34a35 ("sctp: support sysctl to allow users to use stream interleave")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 3abd494053a9..b67f2f83ff32 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2941,6 +2941,20 @@ reconf_enable - BOOLEAN
 
 	Default: 0
 
+intl_enable - BOOLEAN
+        Enable or disable extension of User Message Interleaving functionality
+        specified in RFC8260. This extension allow the interleaving of user
+        messages sent on different streams. With this feature enabled, I-DATA
+        chunk will replace DATA chunk to carry user messages. Note that to use
+        this feature, with this option set to 1, we also need socket options
+        SCTP_FRAGMENT_INTERLEAVE set to 2 and SCTP_INTERLEAVING_SUPPORTED set
+        to 1.
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

