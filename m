Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DA36B8BB2
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 08:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjCNHHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 03:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjCNHHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 03:07:12 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A822F96F18
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 00:07:05 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x11so15565684pln.12
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 00:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678777625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vExNc8g71d82saHsLNTC/ZuLhHw9aer0Uxf0bHr7Ykk=;
        b=qtZm1Iqnj1tl17uVQuA1hUR/B0Da5i1Sz6WS7Hh5NftKFt39r9xsY7ZAp4CM32f0wN
         TpMPxfjPfVBP1sTd30TYZLLRiLXTrNqmhQ1ZiVufZPgG/D8n8p0eXMWyJTZm3Wyh0zKH
         43l+pviAKlBHpM2dvZdOn5WZuC57nm0D+PrgGtDgzX8/fLo/gjTzXtTMJojMPEiaNS4Y
         U1EtgR+xwhXBN1jSIG/wpie1tf9LAKgSaZKFzvDsSqqYtVkPMEykvcqTgefedePVVsN4
         NAuhI4z9lsYU9icoQtNJYPkMy0qcBVosWKRBiXnX+QQPUWqnIB6xXFJOKldNd7vUXrWw
         yLbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678777625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vExNc8g71d82saHsLNTC/ZuLhHw9aer0Uxf0bHr7Ykk=;
        b=ch6EmbWHUrdyVwvAN5qGKptH52qYN3JtSbd6jFIn8/UgWhGNoL9b0QbHdSW1cyIcGT
         218aQps+SxNrSVu3/Gy6CLQLOE8WIyd3TSkjXd5uw1McDH+Isxm3NNCuVD6jtxyaCl0F
         zyCKWS7aMzZ5emDesFLMI5ZWyWDbwadlIJZrXBJuva33V1chVcR9qfbTnAXTM1XUth4/
         RcB8Z2Tz1eLO/fe0b0QovVnFqpuq7gSWCfda76JLkBmuCdwXnoqVn6334DopCnro6CkN
         XDsJOl/9mMfUcwCdON7zXPgKBWtIZ47XUMm1tOV8FJn1e/f1aVc14qku5/5HdQEABN7z
         TdvQ==
X-Gm-Message-State: AO0yUKUPih6oZNELxFAytGnhub6bhXN+UWK1VsY52/Wnyz2ETK9zmrlq
        Hvve42elI9mX3EgZbFgdz5xSN0aAP4uKuQzR
X-Google-Smtp-Source: AK7set+59aS4OIGm6Nysp/r3VVPdI9NyPctlJFJ1czV5/wMVpbB068UrXxNSzdzYvzbF9UlNFh2Tew==
X-Received: by 2002:a17:903:2290:b0:19c:dbce:dce8 with SMTP id b16-20020a170903229000b0019cdbcedce8mr46903171plh.15.1678777624795;
        Tue, 14 Mar 2023 00:07:04 -0700 (PDT)
Received: from localhost.localdomain ([8.218.113.75])
        by smtp.gmail.com with ESMTPSA id l13-20020a170903244d00b001992fc0a8eesm966562pls.174.2023.03.14.00.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 00:07:04 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2 1/2] Revert "tc: m_action: fix parsing of TCA_EXT_WARN_MSG"
Date:   Tue, 14 Mar 2023 15:04:49 +0800
Message-Id: <20230314070449.1533298-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230314065802.1532741-1-liuhangbin@gmail.com>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 70b9ebae63ce7e6f9911bdfbcf47a6d18f24159a.

The TCA_EXT_WARN_MSG is not sit within the TCA_ACT_TAB hierarchy. It's
belong to the TCA_MAX namespace. I will fix the issue in another patch.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tc/m_action.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/m_action.c b/tc/m_action.c
index 6c91af2c..0400132c 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -586,7 +586,7 @@ int print_action(struct nlmsghdr *n, void *arg)
 
 	open_json_object(NULL);
 	tc_dump_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0, false);
-	print_ext_msg(&tb[TCA_ACT_TAB]);
+	print_ext_msg(tb);
 	close_json_object();
 
 	return 0;
-- 
2.38.1

