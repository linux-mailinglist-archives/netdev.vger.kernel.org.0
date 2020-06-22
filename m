Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE04D202E4A
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 04:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgFVCYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 22:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgFVCYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 22:24:41 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5599C061794;
        Sun, 21 Jun 2020 19:24:40 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id u8so205725qvj.12;
        Sun, 21 Jun 2020 19:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=JDCu02ES2xY+6Ui/7D1CftDRvkxf7o4qfF9n1RmWCHE=;
        b=GXUb1t/Thdqn+it/vNeGVClH3AHRoVR/oQnuNOd2PtbSjTh67VqC45AUp6MH591oqi
         ssZQQYTUJnklP3Pt5tq6FsBnwrmIKcjJV/2tJ8PWEUuSk60ZYuLsSIiC/v7iKmZL/WPE
         ZodzjlRJ0jJeFFQr79y/eMVwFQBwPJi4aDGf6j7eYMcoOrzmGE+dk+rCOe81Als/H3VA
         uW1ezRVeDfSHvUe/2JoJlG3xpj6KkZNmaxFdpLCGMmuVj9RgwBey68/CmqTfDNg0Pbsl
         ZqtYlCZKDl9uo8AX/6idsqBGyN/pKQr2HTWeYJhpCPRk/bxKXw3DL1jtd6eT7BUb2kTP
         9JlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=JDCu02ES2xY+6Ui/7D1CftDRvkxf7o4qfF9n1RmWCHE=;
        b=Xq4Aq9Rh65Bz311OO5zeeinLgHTy63aS9nPtMA7knkXmq/bqRudgSF64YV5MFYrxU1
         OnsOCd4X8SQ01pip8s11ICrcvfc9pw4mFR1RyQp/DI5S3rXNoIh/T3DKp5lJwwq21qtf
         vBlP6Vo/Z1pug6as07i+51DooFbFbxB7WcziO0v+ipw31bf4Rwi6GUiUztY69O+NLGaz
         KUOJ+z4paMeG2DjhdZVRZkjHo4W9L/l9kPD488+Av8oy7WYihVvUKKCZMHXcy+AxWVR0
         dFi/iLPiJKgTSvBWC4yQLemOxCqXEFPZNJm2nuJBXQ6l7gi2EUOSK8ITbMyLTf8PjmhF
         meUQ==
X-Gm-Message-State: AOAM531ZrvfwO4f5sqBScKF756MHjE+iZVP5/XNi96SjReH5ZLsJVtsO
        rB79D3BPWsdb0Q8EuqCNh84=
X-Google-Smtp-Source: ABdhPJw+lQ8IwgzYlu7GOBpNGQZkHVEOBCsQ9yRBf1zU10wQf2woU16A87+ZIxbIL8Hkl61Vh85fHg==
X-Received: by 2002:ad4:4868:: with SMTP id u8mr19927909qvy.34.1592792679996;
        Sun, 21 Jun 2020 19:24:39 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:c0e3:b26:d2d0:5003])
        by smtp.googlemail.com with ESMTPSA id w45sm6648608qtj.51.2020.06.21.19.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 19:24:39 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:TC subsystem),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/sched] tcindex_change: Remove redundant null check
Date:   Sun, 21 Jun 2020 22:24:30 -0400
Message-Id: <20200622022430.18608-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

arg cannot be NULL since its already being dereferenced
before. Remove the redundant NULL check.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/sched/cls_tcindex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 61e95029c18f..78bec347b8b6 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -533,7 +533,7 @@ tcindex_change(struct net *net, struct sk_buff *in_skb,
 
 	pr_debug("tcindex_change(tp %p,handle 0x%08x,tca %p,arg %p),opt %p,"
 	    "p %p,r %p,*arg %p\n",
-	    tp, handle, tca, arg, opt, p, r, arg ? *arg : NULL);
+	    tp, handle, tca, arg, opt, p, r, *arg);
 
 	if (!opt)
 		return 0;
-- 
2.17.1

