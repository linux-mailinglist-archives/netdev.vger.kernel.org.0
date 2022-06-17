Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6E754FA24
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 17:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380506AbiFQPVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 11:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381162AbiFQPVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 11:21:30 -0400
Received: from sym2.noone.org (sym.noone.org [178.63.92.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AD04BB8F
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 08:21:25 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4LPjS174jhzvjfp; Fri, 17 Jun 2022 17:21:21 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] bpf: fix bpf_skc_lookup comment wrt. return type
Date:   Fri, 17 Jun 2022 17:21:21 +0200
Message-Id: <20220617152121.29617-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function no longer returns 'unsigned long' as of commit edbf8c01de5a
("bpf: add skc_lookup_tcp helper").

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 net/core/filter.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5af58eb48587..89cb007b6a09 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6463,8 +6463,6 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 
 /* bpf_skc_lookup performs the core lookup for different types of sockets,
  * taking a reference on the socket if it doesn't have the flag SOCK_RCU_FREE.
- * Returns the socket as an 'unsigned long' to simplify the casting in the
- * callers to satisfy BPF_CALL declarations.
  */
 static struct sock *
 __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
-- 
2.36.1

