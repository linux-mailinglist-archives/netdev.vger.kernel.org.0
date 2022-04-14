Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514F550037D
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 03:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbiDNBOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 21:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiDNBON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 21:14:13 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22509286FD
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 18:11:49 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s137so3384233pgs.5
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 18:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sCPYkAGkrQ344k0+KnNmiZKERcwmGdBzjSFnh3ypgIw=;
        b=BppDjYKpYgTEaUw5Uebntvsfz0QTZgz2Jw6mtRChJwJ0lt8ptEuu0KnHJgystWt3ss
         Bim8KbKDcPwNQQq6YyFeEE6z40FXKmJloXx01fM/NK/2ti2j8z6kPfbkrE3m72k42mii
         tiBHpqdE8o1fJkoXCK6kNeAvzNoAGbm/Foeo9I0MoPlKAzU7UqYNatlLHMDeGfm2riGs
         hP2d968mxrTbNKhehXOpW7SsX4FHAvpBa+5oUc4yIFREGwef3To7Y6qBPBsuPq46kyDu
         Av+oYPX4sILJJXvwwH6mIZQgUMfCkWjeKAmsZbxwBnYu6vgVwyr4keffcLKM6lfqMl86
         P3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sCPYkAGkrQ344k0+KnNmiZKERcwmGdBzjSFnh3ypgIw=;
        b=I5fQivNewD1lyW1c3TglXpjR4T08bu2H+yzehxRzBCaC51vzzH/i/Msi7TlQmbWHMC
         BU2LH/Zbv9Wv+CxIXSMcc9YN7vHNSek9lNbXpqncTd/1G3qU2rgPnvdnQ8pwNONFCVoa
         TFQR2Mw1jMuSCivjgC0+Wt0AqDRBB7ppamIAkXZ/dzRD0u9YNc3N7AI+pD6xYNFJdOgp
         uydGwGZkuZlgHFKjJTFcTkbigY8IQ7u+BJ8XSMfAHknPmHd/pXTykXJ0EViWfLAWtd3b
         kI5VD4EumbI9wwEcEZ39b6qfkI+OMCzHdZIpXOW8QpmDFVH7+74cAixQCqu7wwx7N/jU
         t0hQ==
X-Gm-Message-State: AOAM533kwFb0/H+iAcLGnXyWsp7VYAUfyYI9hysXItwoq3cWwkLGDw1j
        Z+n/hcR81tOPbtlHojM+xJw=
X-Google-Smtp-Source: ABdhPJzwMYQw7ql6uJKm+rzQBlr6oEPJdEmy8ASqjD0IGc2u7cdVIoA3VJMSIRRLlm4+NvQpdvzjkQ==
X-Received: by 2002:a05:6a00:2992:b0:505:cf4b:baef with SMTP id cj18-20020a056a00299200b00505cf4bbaefmr1457960pfb.61.1649898708585;
        Wed, 13 Apr 2022 18:11:48 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d72c:6411:a3d0:eca9])
        by smtp.gmail.com with ESMTPSA id d16-20020a17090ad99000b001bcbc4247a0sm242421pjv.57.2022.04.13.18.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 18:11:47 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net_sched: make qdisc_reset() smaller
Date:   Wed, 13 Apr 2022 18:10:04 -0700
Message-Id: <20220414011004.2378350-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
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

From: Eric Dumazet <edumazet@google.com>

For some unknown reason qdisc_reset() is using
a convoluted way of freeing two lists of skbs.

Use __skb_queue_purge() instead.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_generic.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 5bab9f8b8f453526185c3b6df57065450b1e3d89..dba0b3e24af5e84f7116ae9b6fdb6f66b01a896c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1019,22 +1019,14 @@ EXPORT_SYMBOL(qdisc_create_dflt);
 void qdisc_reset(struct Qdisc *qdisc)
 {
 	const struct Qdisc_ops *ops = qdisc->ops;
-	struct sk_buff *skb, *tmp;
 
 	trace_qdisc_reset(qdisc);
 
 	if (ops->reset)
 		ops->reset(qdisc);
 
-	skb_queue_walk_safe(&qdisc->gso_skb, skb, tmp) {
-		__skb_unlink(skb, &qdisc->gso_skb);
-		kfree_skb_list(skb);
-	}
-
-	skb_queue_walk_safe(&qdisc->skb_bad_txq, skb, tmp) {
-		__skb_unlink(skb, &qdisc->skb_bad_txq);
-		kfree_skb_list(skb);
-	}
+	__skb_queue_purge(&qdisc->gso_skb);
+	__skb_queue_purge(&qdisc->skb_bad_txq);
 
 	qdisc->q.qlen = 0;
 	qdisc->qstats.backlog = 0;
-- 
2.35.1.1178.g4f1659d476-goog

