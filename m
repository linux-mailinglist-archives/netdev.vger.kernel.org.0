Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1836484F0
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiLIPWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiLIPVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:21:47 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620878D1AE
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 07:21:46 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-40b40ff39f1so18490557b3.10
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 07:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfO5TuGwdyECtXG+osL0YPPNewICtjy/EFZ/kYLs3Ps=;
        b=Ew/tv54pA0xZLNdQL5jzX6UIJ3SuGCE/UY1tQ0XZtIkAc8MVNIXSAH3hD4KAB9Izoy
         ss47+pRtHqal/HdzujIdWGYCOf7L+cqRvTj83NXad6/S3oHcL3BO8xfW2jA6ZYwhFnwS
         5BlDQEdG5mD2eefUsLGhIlHXXfkd7HYMxLXyK8GRGVqDtiAZhLfcMrTwJNN5OEPbIs+P
         KNoUpCrdwJZw+RtV/3FRpW9MpVj/eaKqCJppP1fjwF6GoBX0FPn/gfVxEc/y7x7mbESS
         fftKL6EH/uRVc5DyPyLEIeao7OJJTlyJGROCQSCyquU791qTwe6WI8xtrRILa2LJW2lh
         uL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hfO5TuGwdyECtXG+osL0YPPNewICtjy/EFZ/kYLs3Ps=;
        b=qjhZaqpf4Udc6Yrj8jXZYpqBDqWSKVRQBlQVDCyg9MpwZYdStEaagCO8eP+enVNWNL
         UZ4hjwSy6vBuQfIDWfKrLsf3ZlmBhOtoeADIw1O3Q07gV9W2Q5F83vOMPWWuFRup/SCD
         AnLadrVea6NzGeiBDjHL/EuEvxxwQRPTsHQgVcVPnqBGGeaknLGgbClcgjAIydk5QXQX
         AlgvwwzcwawRUByeIojZlE7x1sAvZzazckQueOQnfVplPCN+YJFMM30wLflP7WZEpLhw
         rLHs5ZkQXzJYnXwB8rrnPm1iE5ipLMfkBNjvNjQCGdscRFdDvDd/TXs1fOqWHfC8N6/G
         3DkQ==
X-Gm-Message-State: ANoB5pkgCxTUmZymheXNnH5crvm47U6BrqUL7p5ZwhAMNHxpBcDlB0yr
        WsWSBHCDk3jaEeFRGw6f04D/agYMJ6COxw==
X-Google-Smtp-Source: AA0mqf74ZcxAuRTqOPxtAfOgI0Ci7aRxBH41xgmhkiLTc5x3wVsAXFvIHFJ/bHNIM6SzroCTsRKPRQ==
X-Received: by 2002:a05:7500:5511:b0:ea:7107:6b67 with SMTP id x17-20020a057500551100b000ea71076b67mr493702gac.45.1670599305119;
        Fri, 09 Dec 2022 07:21:45 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i26-20020a05620a0a1a00b006fbae4a5f59sm39699qka.41.2022.12.09.07.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:21:44 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        LiLiang <liali@redhat.com>
Subject: [PATCH net-next 2/3] net: team: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf
Date:   Fri,  9 Dec 2022 10:21:39 -0500
Message-Id: <fd7877bb52eb02c9023e5793c6b237d5e6405ac3.1670599241.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1670599241.git.lucien.xin@gmail.com>
References: <cover.1670599241.git.lucien.xin@gmail.com>
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

This patch is to use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf
for Team port. This flag will be set in team_port_enter(), which
is called before dev_open(), and cleared in team_port_leave(),
called after dev_close() and the err path in team_port_add().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/team/team.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index d10606f257c4..fcd43d62d86b 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1044,6 +1044,7 @@ static int team_port_enter(struct team *team, struct team_port *port)
 			goto err_port_enter;
 		}
 	}
+	port->dev->priv_flags |= IFF_NO_ADDRCONF;
 
 	return 0;
 
@@ -1057,6 +1058,7 @@ static void team_port_leave(struct team *team, struct team_port *port)
 {
 	if (team->ops.port_leave)
 		team->ops.port_leave(team, port);
+	port->dev->priv_flags &= ~IFF_NO_ADDRCONF;
 	dev_put(team->dev);
 }
 
-- 
2.31.1

