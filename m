Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E39255421A
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356672AbiFVFNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356622AbiFVFNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:07 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03AF3467F
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:06 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31797057755so85871327b3.16
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2CUsOTdK8JALIGsuTPLTtiAjA4wcVESU0aO5OJ+gE5o=;
        b=obNtajvdIrRaOSJaHNvQQdojvtUhS+yWQ4Q111NpNYKksDIAUG2dWAubGgLtczYXP8
         incdinEv6YVHSRldNQO/58vE3oGRKEDWhTA0waE701AAZMLUAYK6q7v619dIkWz7XQrb
         Y2LowSrrsb3bJu/j0dtS++Plbqyque7E5avDp9p+g4rhOD3cgsPNNRC2I3KDdfW5Fv97
         EsFytQkbSQSSDR8aYghxn4zzSK53ldnGfnnxWH/Y/MqbMKzeUNc3CsckWO+uje/I7Ewk
         7/+s805Kg4t6ix/p5JuXyJbNm8rpGBZSB8r+/1bAGpfJ/bSqYml9dh5SS8P7pdYsyeK+
         aANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2CUsOTdK8JALIGsuTPLTtiAjA4wcVESU0aO5OJ+gE5o=;
        b=vGtzlS85dagzMXKBFeBu2cNfCCFQ8LwMRvvVA+H7C8ijIpaJuJPggMRwweA+rEtXeM
         r9sCw/94NbXEPDpqAXp/I2WYa5Vr4zFkNi/9fKAfAW/5krvN7bdQ42I+ICTm9bGLmNI0
         TKLxBPvU2xGeSBo+5DWCGm85dAiq9043mUPw/Z02zKKR75SA2Kr8mWWV/ThVpxYSofDq
         +mr2INpvp8WVk+MXOayHgrBBu6bm58HSKGzBXqN56JC1/vhPeJ7eavbUgxvjYPPNL4WP
         2pDsGmBdVw0IchrDLLyYRMCKhW4WLlxo6gAShzvuSxtqB7dzTZb+fOYWqtS9eZHeFAJM
         AVRg==
X-Gm-Message-State: AJIora82LN75eEF3v0fHAYWZYuYXBhQ2hBXLOQyYyB9CmomC2nel09X+
        /6PvSvryPm4Mz5cKRiLAMNPu7V4Dico1GA==
X-Google-Smtp-Source: AGRyM1tVR+qVuidEpvZgd9gYeBVqmQEJgYSfYjNcPkq898MExM+fmg/ORsBFynFiipK7QkE2/zOr1bDopJsL6w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:cf43:0:b0:669:3851:6dc0 with SMTP id
 f64-20020a25cf43000000b0066938516dc0mr1762986ybg.279.1655874786143; Tue, 21
 Jun 2022 22:13:06 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:39 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-4-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 03/19] ipmr: change igmpmsg_netlink_event() prototype
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

igmpmsg_netlink_event() first argument can be marked const.

igmpmsg_netlink_event() reads mrt->net and mrt->id,
both being set once in mr_table_alloc().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ipmr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 10371a9e78fc41e8562fa8d81222a8ae24e2fbb6..6710324497cae3bbc2fcdd12d6e1d44eed5215b3 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -110,7 +110,7 @@ static int ipmr_cache_report(struct mr_table *mrt,
 			     struct sk_buff *pkt, vifi_t vifi, int assert);
 static void mroute_netlink_event(struct mr_table *mrt, struct mfc_cache *mfc,
 				 int cmd);
-static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt);
+static void igmpmsg_netlink_event(const struct mr_table *mrt, struct sk_buff *pkt);
 static void mroute_clean_tables(struct mr_table *mrt, int flags);
 static void ipmr_expire_process(struct timer_list *t);
 
@@ -2410,7 +2410,7 @@ static size_t igmpmsg_netlink_msgsize(size_t payloadlen)
 	return len;
 }
 
-static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt)
+static void igmpmsg_netlink_event(const struct mr_table *mrt, struct sk_buff *pkt)
 {
 	struct net *net = read_pnet(&mrt->net);
 	struct nlmsghdr *nlh;
-- 
2.37.0.rc0.104.g0611611a94-goog

