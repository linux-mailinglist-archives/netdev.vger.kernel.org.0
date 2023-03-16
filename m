Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B9B6BC4FA
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjCPDxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCPDxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:53:05 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6419A2F790
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:53:04 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so290649pjt.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678938783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sy3GnLeg1f9ESa+bJT9WD8iP0VWI4Mmd6mvhOwvaHOU=;
        b=I5+PHHtrao2GTvR8MVY7smlGBkz+aklLyCZmRXBfgiUAOzoBGMGZyoNjLx7PHQntJY
         DMcOwsXUEwknybu8nzv6VOaTwFA8J8ZlqiYRlwTaKfwfYJ5oreh3v0cy+6OKu1nwyMRk
         TzSW2sG/9qM31lAzJ4TmskPteHmWp5nFjZqSDkcmXPf7/5Y9nYSsjEk/LMZ/mmf+yYO9
         gsLMs0OjunyggJzjm/iz2YwKPXsQN680kZSnsuBDIzcE+PwvXzUzhngEwHXf1hhD8+X6
         ohZBUC6Wtvmef8OxpjHozZsJrSqmwSXROY6KIardjjC/wPQmsrhHcZu/ShISf/0kYFA/
         l1Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678938783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sy3GnLeg1f9ESa+bJT9WD8iP0VWI4Mmd6mvhOwvaHOU=;
        b=RY1Lel+f9E43CKOIjtFkPenoG1w4MYZTmDyIpuCbHMR9bTO3cHYO7TdVxd43m8cSMH
         NsVjzsKAUHPaAtaVwJ5PywUhu8VPZzLqMfbpC0WJLRVcRmBPPy2euzRVGlWY0Oo9QdIQ
         tqk/zTNiAtZF9UL4u0MyYKzok4GgUPbhXb8Wke2ICuVvpNOy9qp19l/5w4tMEgUwYqiP
         dbxOM4vMhRTqK98TgtjkWUwdpwYxIPRJPTteTuALnvKzX+TpzAcZroib4rRRPdYzixp6
         BYsai1em+h7yVI0EmwjTnF/4+LQbASfB6Vp6EIRy9fomFhNIRyTLRt0kneP81KsACO/+
         fDMQ==
X-Gm-Message-State: AO0yUKXUo76px+7kUcfTsJJBZnokZwGeIN/Xz30/9Mqe/ImNQIJVo195
        qfaFluuoml7+BSNBdvruvAg1XN1JYq4XP3Kd
X-Google-Smtp-Source: AK7set+aY3gAxfkqYUL/+Nl35c7D9eFOEiLtTSZE4mls0w75pM6Yi6/ZZDRag8jgL1nXx4efo7L59A==
X-Received: by 2002:a17:903:41cb:b0:1a0:69e6:bb32 with SMTP id u11-20020a17090341cb00b001a069e6bb32mr2025414ple.54.1678938783324;
        Wed, 15 Mar 2023 20:53:03 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id kb14-20020a170903338e00b001990028c0c9sm4393923plb.68.2023.03.15.20.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:53:02 -0700 (PDT)
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
        Hangbin Liu <liuhangbin@gmail.com>,
        Andrea Claudi <aclaudi@redhat.com>
Subject: [PATCHv2 iproute2 1/2] Revert "tc: m_action: fix parsing of TCA_EXT_WARN_MSG"
Date:   Thu, 16 Mar 2023 11:52:41 +0800
Message-Id: <20230316035242.2321915-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230316035242.2321915-1-liuhangbin@gmail.com>
References: <20230316035242.2321915-1-liuhangbin@gmail.com>
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

Reviewed-by: Andrea Claudi <aclaudi@redhat.com>
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

