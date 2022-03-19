Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EEE4DE74E
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 10:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242606AbiCSJg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 05:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242600AbiCSJgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 05:36:25 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547F1275479
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 02:35:05 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id r22so1065336ejs.11
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 02:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OVhFb8O1khOhZ+iAVD33MkTWRcac/2cWGA3XyKCjEj4=;
        b=oN/BkSo7TUyn7xTJowq3OAE3wG50DCHnS80K31C0YXY2m0YlKXJpFh7K9sBdQoRMO5
         4/23qiWgfMyTk85vMvtsfI5y+IvpSwn5lKYZ/ipmeA/OrDn26AClATkgHHXZnwZNOVcG
         gWmlykIvS2hvCMxdHPurv6scJA9+PZRb58aov/w/bOTYLOY7vLpunw670HzHVj9bxmfN
         efam1sQ8/u4X+xyMdq57I7bbskzBNaUNp6BnslhZlLLL/plAIezxN35Km8EmCq4jxBqj
         MfZ3Q4DIQmaeGaAZsV77WRvFlXGhQcf/6N6JgdOA8418Sp4SRcHf+I/0VZtT1kXLz90w
         N99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OVhFb8O1khOhZ+iAVD33MkTWRcac/2cWGA3XyKCjEj4=;
        b=TOfO6e8YuZVy4yZZaQJ/u2zCkcDQPsQz4owyRfm8xkM5zL73dw3VcaLNqLoSP+RbHy
         ee9SviKDGzxWYwxGIkZmAgUSgLaNPS8bIdivsCW7DQVEY5Q3bfesTy3TGCmEyD9xSXER
         HekUW411/5oxoSN+P/NA+wNXuNEPYiB6IwTCZKLFCHJ6D4KViN1qST+jnQI6X1GIie3E
         Fa4IDawHqE+e+ie+CjMlgNlEoeBAxqu9dzg0xBjui9+0b8BpGwp1lsFwBbHvsUAY2Nlv
         PfkD/ljuZD78ZCJ7NT2l+tlc4xZBJrynf5/3aWe4jGvScN3ZsvZu1HRv5jeJgZqrx6Nb
         1AbQ==
X-Gm-Message-State: AOAM533nd4bTLnvevaVzFr1jixp37IMF+EGymPXkmqQdPpvf3A1sbs78
        5MJvNjMfP4q700J3wR8cgPg=
X-Google-Smtp-Source: ABdhPJzu7/CX8b7FYGdveDdKPaHW1pbpwVPkY8P2CZM4A729AYFVbvw0DhkwTMc2JHLBp8B9xs6q2A==
X-Received: by 2002:a17:906:7304:b0:6da:9243:865 with SMTP id di4-20020a170906730400b006da92430865mr12380416ejc.665.1647682503760;
        Sat, 19 Mar 2022 02:35:03 -0700 (PDT)
Received: from jimi.localdomain ([37.142.70.89])
        by smtp.gmail.com with ESMTPSA id ec21-20020a170906b6d500b006d170a3444csm4589840ejb.164.2022.03.19.02.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 02:35:03 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH net-next] net: geneve: add missing netlink policy and size for IFLA_GENEVE_INNER_PROTO_INHERIT
Date:   Sat, 19 Mar 2022 11:34:54 +0200
Message-Id: <20220319093454.1871948-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.32.0
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

Add missing netlink attribute policy and size calculation.

Fixes: 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 drivers/net/geneve.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 8f30660224c5..d5af2ba3d32c 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1275,6 +1275,7 @@ static const struct nla_policy geneve_policy[IFLA_GENEVE_MAX + 1] = {
 	[IFLA_GENEVE_UDP_ZERO_CSUM6_RX]	= { .type = NLA_U8 },
 	[IFLA_GENEVE_TTL_INHERIT]	= { .type = NLA_U8 },
 	[IFLA_GENEVE_DF]		= { .type = NLA_U8 },
+	[IFLA_GENEVE_INNER_PROTO_INHERIT]	= { .type = NLA_FLAG },
 };
 
 static int geneve_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -1780,6 +1781,7 @@ static size_t geneve_get_size(const struct net_device *dev)
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_UDP_ZERO_CSUM6_TX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_UDP_ZERO_CSUM6_RX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_TTL_INHERIT */
+		nla_total_size(0) +	 /* IFLA_GENEVE_INNER_PROTO_INHERIT */
 		0;
 }
 
-- 
2.32.0

