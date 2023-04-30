Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85916F2B73
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 00:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjD3Wvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 18:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjD3Wvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 18:51:43 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D92E47
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 15:51:41 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 6a1803df08f44-5ef59b5a1d2so9958156d6.1
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 15:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682895100; x=1685487100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kVDBaqqAZLL0GsOg3OJsWfrZz25CexQkyy0ISxDZqU=;
        b=gVoNSgZ5h3du0pxhXQ/NjcOHGh6u0/sdXAmypKFg4aIa2sQMA1qGYyrMRt/7cxe0En
         j8IQ0ZHg1Xy3YTw1j5r7zpIuvky8sNAiZuGeZrWYFLKZeTTQvO+A3a+/0TXus91dWo8v
         KDEJiNANHqQp2SRvZHT+GxEaUw3ph90unuNh3dJSy+Lj7TqNzcU9uybM9rDNzoIvjM1Y
         Tjuu6ikrxXFehdomaC7v9GotR82yBpJ7lR1CntpWNJPGlQnsadjNwVw0PAnK6TTTmWni
         NbfBHXk/V2zvtBVMCKj3MqzGfcmBwxGFmLWH+sbwPcqfhu8hVfbrTD3nIAa40+0co0py
         R5Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682895100; x=1685487100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0kVDBaqqAZLL0GsOg3OJsWfrZz25CexQkyy0ISxDZqU=;
        b=cTpnRYZWAykANETcmfHUSovKKxAH7/epFYrP6LXwgMc6J8h+q7TJ7X+WbhjiCK89OF
         KJCK5Iv9bZZcs6IMnh2Vvyg5AEfuCgfmOO2gXKpgWMh3wyIJa4ss9XGO0XKDbOIq9JyF
         9tU2mHua0TZk35nOipoo/BrrtRvgNCICUCKTkZHAAxXQ+qyUweVTDtNcBtSss5PIIJEV
         bXazEizV0Rzp/XNdZD9pVTZtupRLLuU51uUUQuRiUJozsjNv2ZfYtSOtI4WlPMYnoOQ5
         1Spfu/wJ/2ruiQlhSca4bmUoDX9TMqhusKTQ88T4Jyf/jkoCX8Aa4S/aVfbGXHoswJhC
         A9Kg==
X-Gm-Message-State: AC+VfDy4drI0jzlJJ/ddHbL7sZbo8a8gaxm3fQPXKr7mfN9nl59mL7cE
        k0y4v1WfiEKACfMd7CLinzM=
X-Google-Smtp-Source: ACHHUZ79h1yxjWjP4A6cyRXEKEhT5amub5BSmT98J2S0LtXLXOsbCgJt8/R0Lubk0dDzEtlTSS0abg==
X-Received: by 2002:ad4:4ee9:0:b0:5f1:5cf1:b4c8 with SMTP id dv9-20020ad44ee9000000b005f15cf1b4c8mr19292002qvb.35.1682895100415;
        Sun, 30 Apr 2023 15:51:40 -0700 (PDT)
Received: from localhost.localdomain ([2602:47:d92c:4400:e747:e271:3de5:4c78])
        by smtp.googlemail.com with ESMTPSA id i5-20020a0cf105000000b0061b5a3d1d54sm189310qvl.87.2023.04.30.15.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 15:51:39 -0700 (PDT)
From:   Nicholas Vinson <nvinson234@gmail.com>
To:     mkubecek@suse.cz
Cc:     Nicholas Vinson <nvinson234@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH ethtool 1/3] Update FAM syntax to conform to std C.
Date:   Sun, 30 Apr 2023 18:50:50 -0400
Message-Id: <d654f084797a5ce4f7b51b273acd6d288a2b98be.1682894692.git.nvinson234@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1682894692.git.nvinson234@gmail.com>
References: <cover.1682894692.git.nvinson234@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Found via gcc -fanalyzer. When using the non-standard FAM syntax:

    uint32_t req_mask[0];

gcc-13 with the -fanalyzer flag generates an internal compiler error.
Updating the syntax to use the standard C syntax:

    uint32_t req_mask[];

works around the gcc bug.

Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>
---
 netlink/features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/features.c b/netlink/features.c
index a4dae8f..a93f3e7 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -266,7 +266,7 @@ int nl_gfeatures(struct cmd_context *ctx)
 
 struct sfeatures_context {
 	bool			nothing_changed;
-	uint32_t		req_mask[0];
+	uint32_t		req_mask[];
 };
 
 static int find_feature(const char *name,
-- 
2.40.1

