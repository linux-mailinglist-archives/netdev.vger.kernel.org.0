Return-Path: <netdev+bounces-8049-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25CCD722907
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F0DB1C20B96
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3639015493;
	Mon,  5 Jun 2023 14:40:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D8510FB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:40:48 +0000 (UTC)
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E478A6
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:40:47 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-75d4a4cf24aso207520385a.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 07:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685976046; x=1688568046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y+t8G4/22STWDr4DlWibh01N6l71AUExQgwBLIvfIqY=;
        b=YZ11M3PCVVjiFaBi3snZyYkWtoYRP/dvzyXM5uUOMcMN3Y1tJlVlULcxN4n+fj8Zg+
         YreS0Xz7mzCdNUXGgp2qQcMnHdgqTX6gQgVpO3FVvQXlMSsrDjWOK9KYX+NlxJ1bnZsM
         H14YxwDLnPRTGLBNwfvnNttbGiRPVPWb4/Es9kak67ZBTsuwpMzI1h8F3JE8F6KFiZ8d
         otw/KLrjW0xbfZ+53Mr2JnuwUKxn5q3ta9eSN8xxTPdzq+vi0MLYBKu6Nnc3kVqrPu7/
         Mk6+GRFQPkzQ3kjWCyLv22HmvIJAgDEtqxgasdroewfG/xKq0dkWoFJzyuauNoz2/6AZ
         4lsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685976046; x=1688568046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y+t8G4/22STWDr4DlWibh01N6l71AUExQgwBLIvfIqY=;
        b=fyWWGYAE8NGcdB3+FrRw0KUvfIBgqbh61NhdU1r4GMgpQ65lvIwwvH/8siB35VLo5f
         QaGsJ+R2SUYxeaFCO2FYXZdI6aewBplelcGaRP9JjuFdphWy+IvsAFZRZtp8n8SN2xVg
         3oxlBXSwXgxKIylM8Zwq7y5O2yMa/zEHuewRnPR/nc0wdN95YqWYtciP4WNMRCaaz51m
         o33P+c25mtirrR5iSkTbQUoOWYe37kbU/EjrJ9joYDAPELO2cEhCcX8XGR8FTIPH1Cp6
         HEfJG56qdUQZfeJoErgXAqy8fLxqJ7xUtayaD0odiyBmeJWtfR8BYtghnLEytf/TLqvL
         mNrQ==
X-Gm-Message-State: AC+VfDzbaQqVEWv3zYCzUDY9/1kE/tdSG+kqjUEKum8XedjxGL6129mg
	Ko+3L6vQUWLD94xVpm0PXlIusRw5MJg=
X-Google-Smtp-Source: ACHHUZ7ZXo5zkv5LuLtv3805gCSXFFvSC3ln0i3u4mhb45Zc3wA1m2zpp6054+uPtvOh5coNh3/97w==
X-Received: by 2002:a05:620a:25c7:b0:75b:23a0:d9b8 with SMTP id y7-20020a05620a25c700b0075b23a0d9b8mr23201170qko.14.1685976046395;
        Mon, 05 Jun 2023 07:40:46 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x24-20020a05620a14b800b0075cce14b51esm4229093qkj.42.2023.06.05.07.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:40:45 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	tipc-discussion@lists.sourceforge.net
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>
Subject: [PATCH net-next] tipc: replace open-code bearer rcu_dereference access in bearer.c
Date: Mon,  5 Jun 2023 10:40:44 -0400
Message-Id: <1072588a8691f970bda950c7e2834d1f2983f58e.1685976044.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace these open-code bearer rcu_dereference access with bearer_get(),
like other places in bearer.c. While at it, also use tipc_net() instead
of net_generic(net, tipc_net_id) to get "tn" in bearer.c.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/bearer.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 114140c49108..1d5d3677bdaf 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -176,7 +176,7 @@ static int bearer_name_validate(const char *name,
  */
 struct tipc_bearer *tipc_bearer_find(struct net *net, const char *name)
 {
-	struct tipc_net *tn = net_generic(net, tipc_net_id);
+	struct tipc_net *tn = tipc_net(net);
 	struct tipc_bearer *b;
 	u32 i;
 
@@ -211,11 +211,10 @@ int tipc_bearer_get_name(struct net *net, char *name, u32 bearer_id)
 
 void tipc_bearer_add_dest(struct net *net, u32 bearer_id, u32 dest)
 {
-	struct tipc_net *tn = net_generic(net, tipc_net_id);
 	struct tipc_bearer *b;
 
 	rcu_read_lock();
-	b = rcu_dereference(tn->bearer_list[bearer_id]);
+	b = bearer_get(net, bearer_id);
 	if (b)
 		tipc_disc_add_dest(b->disc);
 	rcu_read_unlock();
@@ -223,11 +222,10 @@ void tipc_bearer_add_dest(struct net *net, u32 bearer_id, u32 dest)
 
 void tipc_bearer_remove_dest(struct net *net, u32 bearer_id, u32 dest)
 {
-	struct tipc_net *tn = net_generic(net, tipc_net_id);
 	struct tipc_bearer *b;
 
 	rcu_read_lock();
-	b = rcu_dereference(tn->bearer_list[bearer_id]);
+	b = bearer_get(net, bearer_id);
 	if (b)
 		tipc_disc_remove_dest(b->disc);
 	rcu_read_unlock();
@@ -534,7 +532,7 @@ int tipc_bearer_mtu(struct net *net, u32 bearer_id)
 	struct tipc_bearer *b;
 
 	rcu_read_lock();
-	b = rcu_dereference(tipc_net(net)->bearer_list[bearer_id]);
+	b = bearer_get(net, bearer_id);
 	if (b)
 		mtu = b->mtu;
 	rcu_read_unlock();
@@ -745,7 +743,7 @@ void tipc_bearer_cleanup(void)
 
 void tipc_bearer_stop(struct net *net)
 {
-	struct tipc_net *tn = net_generic(net, tipc_net_id);
+	struct tipc_net *tn = tipc_net(net);
 	struct tipc_bearer *b;
 	u32 i;
 
@@ -881,7 +879,7 @@ int tipc_nl_bearer_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	struct tipc_bearer *bearer;
 	struct tipc_nl_msg msg;
 	struct net *net = sock_net(skb->sk);
-	struct tipc_net *tn = net_generic(net, tipc_net_id);
+	struct tipc_net *tn = tipc_net(net);
 
 	if (i == MAX_BEARERS)
 		return 0;
-- 
2.39.1


