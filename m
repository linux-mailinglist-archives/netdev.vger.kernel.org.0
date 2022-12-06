Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097AB644FA1
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiLFXba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLFXbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:31:24 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51204384D
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 15:31:23 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id k3so2447415qki.13
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 15:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0rll4DxwcXBCHbVSIxpnJnXVQqgF+A4qtdFp6rMMijg=;
        b=FUNeQB69EPIQZlQRzjHTKl7k99O9Yo6XlcLhoMJaLk4uH937Itx1apZebp3Kv/VWrw
         M/XMySqD49TuomQ/aa1N9hGFpB8N25TnJPrBOOh+Tx1C3CZRJm4E1JylcrIes7iJlwf9
         V8ZzRAHXhviKQcIDarFOzzlxuznudxwzKOsgwBktIOFq5amGvT1M2Gi9FWZnVJ7uINbg
         Mg9+rJU/O/YCr2RRz2u3VV1N+qLkCARMgkoGAj2uLaasgGz8//6cm2mqLuuUgVrvin+7
         WlGhQLhRFBL59zfZR7iEz+O0e5GtU7hfmUK/xI/dBzKlPuontK4gRzCm5rk4uMd7t58s
         ArRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0rll4DxwcXBCHbVSIxpnJnXVQqgF+A4qtdFp6rMMijg=;
        b=abUyjE4p3CVPag8w6lcEQUUqOoZTHrD2rOpgNQfYuHgBENqG+IVi9X8hpP7cjKE2Xo
         B8evCbZSb35Qj5BnIfIWO6cZw3Ji5zbp1p393E0jXZcwmykyeUWPBE5Q5dhOX2ziWD6o
         Z63nPeTF2POIivvAg/Cv3wKRsPF0VycfEbT3Salks3rImVY6KHerLBzkdvOwwREtWj26
         MAR8Ga17pzwaMi3MUCrLyaEPcTTuIhFja/EDxVIuiS7ZN4mikLamsGm4QzASYxngNq4R
         GszIOAENh2aLB/5xyYy+UuibrA9G1HLd55CtBf3KgDpQ+73jJXjD43ZxEi6EZrj2wV+A
         9BRQ==
X-Gm-Message-State: ANoB5pmmMYypWOR2qabu2Udi+A6oSkOt9K3Fv8tyQJGWqvHlmhuBkISa
        iaL7zt8LOwnqHLheqwgP//kpTxYLpDcCRQ==
X-Google-Smtp-Source: AA0mqf73/qlXmkyEkMspUUHLDtshd3u1a1+OtppBvVnHFrS23ETuW7KWlrn3CgvJoN9heZr4cCCnOQ==
X-Received: by 2002:a05:620a:15d4:b0:6fc:a7df:5f41 with SMTP id o20-20020a05620a15d400b006fca7df5f41mr21170679qkm.694.1670369482496;
        Tue, 06 Dec 2022 15:31:22 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i21-20020a05620a405500b006f8665f483fsm16590231qko.85.2022.12.06.15.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 15:31:22 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCHv3 net-next 3/5] openvswitch: return NF_DROP when fails to add nat ext in ovs_ct_nat
Date:   Tue,  6 Dec 2022 18:31:14 -0500
Message-Id: <b4da71755f95c4003215b9165e8a0d47da6e2cd5.1670369327.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1670369327.git.lucien.xin@gmail.com>
References: <cover.1670369327.git.lucien.xin@gmail.com>
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

When it fails to allocate nat ext, the packet should be dropped, like
the memory allocation failures in other places in ovs_ct_nat().

This patch changes to return NF_DROP when fails to add nat ext before
doing NAT in ovs_ct_nat(), also it would keep consistent with tc
action ct' processing in tcf_ct_act_nat().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/openvswitch/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 5ea74270da46..58c9f0edc3c4 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -821,7 +821,7 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 
 	/* Add NAT extension if not confirmed yet. */
 	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
-		return NF_ACCEPT;   /* Can't NAT. */
+		return NF_DROP;   /* Can't NAT. */
 
 	/* Determine NAT type.
 	 * Check if the NAT type can be deduced from the tracked connection.
-- 
2.31.1

