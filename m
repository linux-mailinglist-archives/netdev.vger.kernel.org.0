Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF91A6B8B96
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCNG6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjCNG6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:58:47 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FD466D3C
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:58:46 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h31so8309219pgl.6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678777125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zw+8WyoA7Q9L8lkiC93t2YOeIl7ECdg3SRa0159aYqM=;
        b=iU6hnBjGVZcE1Gh7hMb7pM2U6SdwcwP2lVccos+8U6F04f8iWk98kUhxzyjK103xiD
         mMLOBEddA7XFQ/N2IzFhkET37Mt6mM1+JVdMMlqg3ys7YVYcG0iAtJbXDMyGwx9vWAko
         dEOzhr41UX2AZR3WqroXI/cGicvmcz6brZoUwAJvoNoLRFPL7jnFg7v1hJjSDUpy4kGe
         gaz6GWsqLBhmuMwemp83s/EL26rDm3WrP3PlhGiG4oWSEXKfy0QC3xJZ+HJylJaPJs5i
         vuwfGvFxpHK1TyCFo9AioU7/E2Emp3fBqijBjjb8nmP0qBknYEErMQ353mmDdRLl1wHZ
         ltXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678777125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zw+8WyoA7Q9L8lkiC93t2YOeIl7ECdg3SRa0159aYqM=;
        b=5Lifkz1GDDRg2q0O1//hw3oDAvsCpJ5HPLdTABGOJeX145BznMqsh95xW4DDILwln7
         ebN10HqUddkSROTcF78ewv2cgjnC7iEglEr1JXd5khxNBtPrYgq1Hvoq4pj03VaXuJd8
         5byyywreyDx/JhaHmc3ETXlmkue5fVwmcRN8w2n6uFc1YIztNDdwLl5qjaEEDIX2HCMR
         wefPRvm7YozRrO60+KUc6iaFWGoA0HuWDelR1Ls49LTh0jWV8YkZ3dyDXzkAVtvaFJGX
         sEbmQPYEk+GfEzR4tjOI+SrnTdVVvMZjPJ6T+/iL0b/E2MwryrQAksn9kRSvqOODL2X1
         7GrA==
X-Gm-Message-State: AO0yUKW3I0h8swy75SaVq65jdk54fYb6q3o+I+AW+rIljRcRk6XGWzXP
        kU2ExZffj+LNWtLWtUqe0sxEzL2zq11mz6e3
X-Google-Smtp-Source: AK7set9ZuEVH6yeQjkXN1IN+1soZoGVq3WldtxsJK48uN1XDo+5NsGtwhaHEqNvOQKNg+G50OxjHQQ==
X-Received: by 2002:a62:6242:0:b0:592:de72:4750 with SMTP id w63-20020a626242000000b00592de724750mr25571196pfb.23.1678777125098;
        Mon, 13 Mar 2023 23:58:45 -0700 (PDT)
Received: from localhost.localdomain ([8.218.113.75])
        by smtp.gmail.com with ESMTPSA id j20-20020a62b614000000b005dae7d1b61asm808291pff.154.2023.03.13.23.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 23:58:44 -0700 (PDT)
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
Subject: [PATCH net 1/2] Revert "net/sched: act_api: move TCA_EXT_WARN_MSG to the correct hierarchy"
Date:   Tue, 14 Mar 2023 14:58:01 +0800
Message-Id: <20230314065802.1532741-2-liuhangbin@gmail.com>
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

This reverts commit 923b2e30dc9cd05931da0f64e2e23d040865c035.

This is not a correct fix as TCA_EXT_WARN_MSG is not a hierarchy to
TCA_ACT_TAB. I didn't notice the TC actions use different enum when adding
TCA_EXT_WARN_MSG. To fix the difference I will add a new WARN enum in
TCA_ROOT_MAX as Jamal suggested.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/sched/act_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 34c508675041..fce522886099 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1596,12 +1596,12 @@ static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 	if (tcf_action_dump(skb, actions, bind, ref, false) < 0)
 		goto out_nlmsg_trim;
 
+	nla_nest_end(skb, nest);
+
 	if (extack && extack->_msg &&
 	    nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
 		goto out_nlmsg_trim;
 
-	nla_nest_end(skb, nest);
-
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 
 	return skb->len;
-- 
2.38.1

