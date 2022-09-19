Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD775BCC90
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiISNGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiISNGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:06:43 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25662BB1E
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:06:42 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id x18so7089556qkn.6
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Oqvo4uDhSkQWLNBMD2xFfnaD5cpRNaE2ynn+Tnfcczs=;
        b=kCIAlXl0oBgjxUyUlFzEb1NzW4JYhY53jpfgqKW0nw8/r037oPeMmOM0PoPS0vkRcR
         tcRNvM33TrRvutFWB1Fdfo+CzXC0Axb/deAzoJUwu9zl+QFofDKrgA+DDTTJ8RFJOawZ
         2Tafal8JF5dUlrizayhv2RwLS5gNqdDvsQHOCFYjuS+WBrerkwjmx1lxSYH75z6GeVI6
         0ReG3kANTGElvRFUOyagx98U3TCaptD/9ZBD0avRE3whXMZ0C+FHGaZWR3bepNgRAXoZ
         Srmgv/d97RNKC+5HrXUtyOLY5Bf4cFyLhG2oRxlUnGBY3zC94eXV1EMMGOULPk9nM/Ds
         hqEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Oqvo4uDhSkQWLNBMD2xFfnaD5cpRNaE2ynn+Tnfcczs=;
        b=jSTZFXm1zvzN1qARz7Cd/MaiPV0m1HXRnD6IvRqFcDU/BLSGIXyPfy6dHuenQKhazm
         UpTud4LpgYDUM6G7WSurFxAFN+nFQZswSL86GujQzdl+mUcIdCJb5LKEAALWRhwYOZvz
         IFRgKvX+2IjlCHlzKC8yx2p/54jhXg3q5qFpHn8Nq9sdUg556DJKrfdb2wTdWSwMQl46
         kUydYhVuB/LpoxVu96cvkB7qlUHQIr6HxhoRqFkLhXHmKu/OBfvRZuWzMZUU8Pl+CIOS
         /O1nFQT22UkbVlpkVtvco35wYmd/WHR1yEJt4K9ft+yhgNvL8FZ64VfyU2uW9+N1yc/I
         iAHw==
X-Gm-Message-State: ACrzQf3pcwLrsHKptEsEdlyRhxBSc//NthxwL6TKOT8EbeUXvXnsqAJa
        J0sNmz3JLTJWjqo1LKlOoG0CTCedM6zOgH2YffI=
X-Google-Smtp-Source: AMsMyM74mmTT5bv6SpjX8VBzJ2KG8Rs1SXTRf/pnZqYg2ySFQNGevI88aKC7TgVSI5qf9gQK4mM2ug==
X-Received: by 2002:ae9:c217:0:b0:6bc:e9a:f50a with SMTP id j23-20020ae9c217000000b006bc0e9af50amr12993358qkg.588.1663592801913;
        Mon, 19 Sep 2022 06:06:41 -0700 (PDT)
Received: from localhost.localdomain (bras-base-kntaon1617w-grc-28-184-148-47-103.dsl.bell.ca. [184.148.47.103])
        by smtp.gmail.com with ESMTPSA id k13-20020a05620a414d00b006c479acd82fsm13733343qko.7.2022.09.19.06.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 06:06:41 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        kernel@mojatatu.com, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 1/1] net: sched: remove unused tcf_result extension
Date:   Mon, 19 Sep 2022 13:06:27 +0000
Message-Id: <20220919130627.3551233-1-jhs@mojatatu.com>
X-Mailer: git-send-email 2.25.1
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

Added by:
commit e5cf1baf92cb ("act_mirred: use TC_ACT_REINSERT when possible")
but no longer useful.

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/sch_generic.h | 5 -----
 net/sched/act_mirred.c    | 3 +--
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 7dc83400bde4..32819299937d 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -326,11 +326,6 @@ struct tcf_result {
 		};
 		const struct tcf_proto *goto_tp;
 
-		/* used in the skb_tc_reinsert function */
-		struct {
-			bool		ingress;
-			struct gnet_stats_queue *qstats;
-		};
 	};
 };
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index f9c14d4188d4..b8ad6ae282c0 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -305,8 +305,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 
 		/* let's the caller reinsert the packet, if possible */
 		if (use_reinsert) {
-			res->ingress = want_ingress;
-			err = tcf_mirred_forward(res->ingress, skb);
+			err = tcf_mirred_forward(want_ingress, skb);
 			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
 			__this_cpu_dec(mirred_rec_level);
-- 
2.25.1

