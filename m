Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1216443BD
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiLFM7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiLFM7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:59:01 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E383885
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 04:58:43 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id n205so16801244oib.1
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 04:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fmE6o7d7fvntn++wwu1tqKlh3U35UkULWAbCQ1sRGz0=;
        b=spwtUItkSjvd7Vhg5FJqLWUqfxvEPmNQ4PBuqBBu8R3YtDVJm3EvQ3Ms5mw9FYsBHi
         7Vts5AIG6PoMm1ztM/25GeTUCx7is+KXAZItjG1kNFvl9NFqE1Cc7rVYKGLDsKlLZYTn
         CGobmUoGjFEcFMSpl3vFtUR3Gq382wWHpbqWaWg0NS1DZ+aj2TTdXbbSp3ulykMPu3Tn
         /OwlzYr+fUHlV4r1AP/L3D6GPHzPoBmF8aqXLYHugZGzpfW5MNoBi5qyKVUF9GvWs7Ix
         KIcLYE6Ev7wBooUN/wW9SziY5z5l+cpL9apSPocenuf7XzdPo8qyNlNEUEQ18LrEU5za
         ayNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fmE6o7d7fvntn++wwu1tqKlh3U35UkULWAbCQ1sRGz0=;
        b=Rt1H+dGT29riZ7hBoR9eBdYIuZykOxR/aJpuPOtOdCV68YwQX7cgAoRdrI3z6DTLrJ
         sa/W9EKEBNbuod/FDV76S4MuETo3YRPnABfQm6FwHATJXfKnz9pkWIgIXC29TYmOfJx+
         UJN+mMiPZpjgzeUcsxL5tH8oi3WTwQveyFlR2e1l3ThkiajckXPr6pgAjH2tME0KzyOi
         ylXYCUiQTRly4nC7WA3XWSOytPT6+aOcLvtHqNcth2bVP5guUBCyb+lFKCDZZmOEWVYl
         B9lWhyG3VCgD152yoSFso177VA/HwMOG4tcZGNGjUC5tj+lG3Eohp4/Acq80D7c2e49l
         I/XA==
X-Gm-Message-State: ANoB5plJ5nGjFmqK1bLdp30O99qiIdrs76t4NOIt7WRruLQZLZC48oie
        GvhC6rlltBx3e/hKspqh2MKyY0JNNJA/np6x
X-Google-Smtp-Source: AA0mqf5xSiwbgYYkp6Zwz5yCkxLtoBg0EkdMOHxUAybwgh4tzMF1akBDuUBsd411oPOEpREOU2118g==
X-Received: by 2002:aca:a815:0:b0:35c:dee:db96 with SMTP id r21-20020acaa815000000b0035c0deedb96mr6680102oie.235.1670331522856;
        Tue, 06 Dec 2022 04:58:42 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:6544:c4a9:5a4c:3545])
        by smtp.gmail.com with ESMTPSA id cm5-20020a056830650500b0066b9a6bf3bcsm8944770otb.12.2022.12.06.04.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 04:58:42 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net-next v5 1/4] net/sched: move struct action_ops definition out of ifdef
Date:   Tue,  6 Dec 2022 09:58:24 -0300
Message-Id: <20221206125827.1832477-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206125827.1832477-1-pctammela@mojatatu.com>
References: <20221206125827.1832477-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type definition should be visible even in configurations not using
CONFIG_NET_CLS_ACT.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
---
 include/net/act_api.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index c94ea1a306e0..2a6f443f0ef6 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -101,11 +101,6 @@ static inline enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-#ifdef CONFIG_NET_CLS_ACT
-
-#define ACT_P_CREATED 1
-#define ACT_P_DELETED 1
-
 typedef void (*tc_action_priv_destructor)(void *priv);
 
 struct tc_action_ops {
@@ -140,6 +135,11 @@ struct tc_action_ops {
 				     struct netlink_ext_ack *extack);
 };
 
+#ifdef CONFIG_NET_CLS_ACT
+
+#define ACT_P_CREATED 1
+#define ACT_P_DELETED 1
+
 struct tc_action_net {
 	struct tcf_idrinfo *idrinfo;
 	const struct tc_action_ops *ops;
-- 
2.34.1

