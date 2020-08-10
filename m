Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A9E2412D6
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 00:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgHJWJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 18:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgHJWJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 18:09:05 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72359C06174A;
        Mon, 10 Aug 2020 15:09:05 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n129so4275028qkd.6;
        Mon, 10 Aug 2020 15:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3ZbMbahrrNkhzXHol1Zr0zVJbIcJ6vrUXkY246I6Gww=;
        b=elE8gXGFCgxGb+WPV22Nwena1f+CuNWdGDIMre+3IYPlJ/dgFxnsv/Nif8jf/9So9g
         Jfq6u/NSq38DCrgFyDUCnVrtGGmwME440my9SPaB2eKBvqacSCkWOroSb302H/A+6/NC
         aFFqf3hnQoBHQs4bfAIRRTwhGKzSgh+tqHkZiR1s4ZRMDUflziWLspPza1JmWtc5x5BH
         hu4Tzumv1CTdCpFez/JNDr9TK5nh5chZTSr0bzMdsoAMlEO6Hm717BFu50YmP2Huc7uT
         O71KhjXh8z3c2xG1Y5UMQPdQCh0Jh59+6yuOQHl1iV7kGHoV8J8a70s1YKxmLmGKTxYf
         aS6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3ZbMbahrrNkhzXHol1Zr0zVJbIcJ6vrUXkY246I6Gww=;
        b=OcvAAcLl0mlJOdi1rKzwVqmE7GxWv8GsQ/Q+Qkx8NWsCOB7Y1Jh3JhQ39jHc4vok+H
         2llg+c07Q8zbOrQX7HmAe1vVZbtY85+SVu3mUyMnfqTBHw4fZkCKd8CN6kyPMpIgu7oa
         t5iAJOISHQEE+ibJM6guczLk7dKawTaQC81uCNZeBUWt0AeMwS8IrIdlRh7OFxqbx2jn
         nu26/Zh7BWBEkNaSBsaQySKeO1mRW6q5gqATvH+AySZYBpEQx0QdxXHCH9RaQZ72TNhp
         klepKpiq0neJDTheQ40o3RTziTQEjcz+j+LXxcCfD0dAdzBRIhdjUi09NVacssmiG7bL
         WsJA==
X-Gm-Message-State: AOAM533uIH4dDj6v3KkEgI7hVWLN70PsiybUjAZ2ANU+jTFJGcyH4Ld2
        4J1lyvLxEUgffp3kf1HwlA==
X-Google-Smtp-Source: ABdhPJwB2LGr4Sy6Pe9wMfFj8Jm3p4RuM27hgGOAJBeSaFB5Lh3TbuSGIbsqy+oIYf6RDWfJ0KnCgg==
X-Received: by 2002:a37:bd46:: with SMTP id n67mr29206337qkf.190.1597097343411;
        Mon, 10 Aug 2020 15:09:03 -0700 (PDT)
Received: from localhost.localdomain (146-115-88-66.s3894.c3-0.sbo-ubr1.sbo.ma.cable.rcncustomer.com. [146.115.88.66])
        by smtp.gmail.com with ESMTPSA id w12sm14192544qkj.116.2020.08.10.15.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 15:09:02 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net] ipvs: Fix uninit-value in do_ip_vs_set_ctl()
Date:   Mon, 10 Aug 2020 18:07:03 -0400
Message-Id: <20200810220703.796718-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

do_ip_vs_set_ctl() is referencing uninitialized stack value when `len` is
zero. Fix it.

Reported-and-tested-by: syzbot+23b5f9e7caf61d9a3898@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=46ebfb92a8a812621a001ef04d90dfa459520fe2
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 412656c34f20..c050b6a42786 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2418,7 +2418,7 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 {
 	struct net *net = sock_net(sk);
 	int ret;
-	unsigned char arg[MAX_SET_ARGLEN];
+	unsigned char arg[MAX_SET_ARGLEN] = {};
 	struct ip_vs_service_user *usvc_compat;
 	struct ip_vs_service_user_kern usvc;
 	struct ip_vs_service *svc;
-- 
2.25.1

