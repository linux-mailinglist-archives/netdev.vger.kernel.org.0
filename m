Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0533E40A9
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 09:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhHIHFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 03:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbhHIHFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 03:05:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE5DC0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 00:05:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j1so26431223pjv.3
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 00:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qg/DpY4zJ9R2R2FQ48yMPXIH6TcGv7xQWXXpBBP6aGI=;
        b=BKOHVcYLiiWlWusxwfOWDfKZS0D3O6wNksdZcFVjgNM2D98NZYNLtBKk+THCuUQyDd
         +HS1pwRO+4sRBdmcZFIDuqnZkISXrXSlieexDUz4WURgYutu+ntoOndaLrCarEnzwP5s
         xQudR3rr72XgPOviD7bKgdm/TmMXKvNZZuz+/moDs2vngHuWwYckKy80mo04LNJeC/EQ
         cRJ98RHuZq/xLI7xYp0oRBDFCFQZKqk56E4654642N9SIImSMCoAY95ZJzDBa84XRmF0
         f/KZpgrpPRbve9BsRZCC5y61G3xdocYPJUTjnoaKhma9FiWnYcvHZ2UL7R/KODAD2Mue
         yjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qg/DpY4zJ9R2R2FQ48yMPXIH6TcGv7xQWXXpBBP6aGI=;
        b=IBNo4R1A3+oLycOhVo6EhCuxTuetxT7nI4EUZUBc1Buna4i1cIx9unhsJm4byH1D7a
         VAUcQy3t8nx4CYnHBRViUikKuWE+vmXqwQhhMganRVVeMqSAF2SOQfdDTyLMc904fFwi
         ManhG1U7tr+3vST/WOjNR194sYgBcvDg5kOtC9lzKx8nwbw5doh5wfJlUt9pTxEHXTQd
         Bwx1TupbtmYwbiXegYiNbTmHb+QDEruMxXA1wWG7+tPDb95z/P/F/t+qczg/Jeu3n24g
         xCfsXgE6fOdSIwAPeMMMkAxkjygNCgxM56wv0i7744H6fm9pNP3IBgOs/XO+yGk/Cc9c
         ATyg==
X-Gm-Message-State: AOAM531uG5dolPG9UOh2kF147cD9oDUYt+PmLe1QLrNb5KJOm0Cg5IQo
        3rQ11bQoPh0ErFB+EjPgeNl+BHyLtbY=
X-Google-Smtp-Source: ABdhPJxoWpFHcYTnBgzbUMAFnZpbS2e3+mqLuBBTcd9mkHPr70CuSwHjtlO4+IJ0LTfH19iiIUMbjg==
X-Received: by 2002:aa7:9984:0:b029:3ca:3234:e5f with SMTP id k4-20020aa799840000b02903ca32340e5fmr8470283pfh.38.1628492711545;
        Mon, 09 Aug 2021 00:05:11 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j19sm18266982pfr.82.2021.08.09.00.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 00:05:11 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Alaa Hleihel <ahleihel@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net] net: sched: act_mirred: Reset ct info when mirror/redirect skb
Date:   Mon,  9 Aug 2021 15:04:55 +0800
Message-Id: <20210809070455.21051-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mirror/redirect a skb to a different port, the ct info should be reset
for reclassification. Or the pkts will match unexpected rules. For example,
with following topology and commands:

    -----------
              |
       veth0 -+-------
              |
       veth1 -+-------
              |
   ------------

 tc qdisc add dev veth0 clsact
 # The same with "action mirred egress mirror dev veth1" or "action mirred ingress redirect dev veth1"
 tc filter add dev veth0 egress chain 1 protocol ip flower ct_state +trk action mirred ingress mirror dev veth1
 tc filter add dev veth0 egress chain 0 protocol ip flower ct_state -inv action ct commit action goto chain 1
 tc qdisc add dev veth1 clsact
 tc filter add dev veth1 ingress chain 0 protocol ip flower ct_state +trk action drop

 ping <remove ip via veth0> &
 tc -s filter show dev veth1 ingress

With command 'tc -s filter show', we can find the pkts were dropped on
veth1.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/sched/act_mirred.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 7153c67f641e..2ef4cd2c848b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -273,6 +273,9 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			goto out;
 	}
 
+	/* All mirred/redirected skbs should clear previous ct info */
+	nf_reset_ct(skb2);
+
 	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
 
 	expects_nh = want_ingress || !m_mac_header_xmit;
-- 
2.31.1

