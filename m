Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184F561F6A0
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 15:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbiKGOw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 09:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiKGOwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 09:52:25 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A4C1D672
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 06:52:20 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id d26so30726149eje.10
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 06:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iAujj76bykyvH+bji6ZjnSHmJ3Li9t3F5P/gaWvPRW8=;
        b=aGpLZc6eNKPnzb7Bl6bL9KR4+KACNIQZ4yk2NfecaJgofLZRBVprjL8R3lyUaw4BfM
         KIFXcFz+UirEkbDL1Ikqro0QA1ClMKBhrs7XAsyzcU7oCEzKqKcNuTqeuU5I3EhR16GO
         7y1rBft6TimmtxbumIsh/8Zei7Vj7xXJagYdjzl7G7vW0eq7vcYMztx2m20oC8SrntkS
         9RMuV7KTIPaKyjWxXyexe2UNlNldr4Y6bpVWmw/rZP3fh2bG4hWR6Eh+lujvrghxa/f2
         BAmO4qXTnC7knlEsa+Qg+5Y1QRCIuLKSOs9tEwTy/nQZMq+GeKUZY0GVgSE/bKGeMJkY
         55nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iAujj76bykyvH+bji6ZjnSHmJ3Li9t3F5P/gaWvPRW8=;
        b=OXtsocoTIoCnU7A5MNaOr7lt5croGOYSEAOGhZ+Xvb4a1T1l1jQziQ0hvdS2v+4W20
         bqY9cDvOEoWIlxao9hWiSCN4R9myxF2rDZbVkElrdVEGjeNTlesZrvlcrEvimucNXmwM
         BWLCBclmIH28FBou8/Vwz60ZOTZz+CUqh6ow9pUhgD4Ac08oDTgjs7HFNg3c09OO1/m3
         Ws0LaPRjhoX8L34tbPvuxLsAqYJOOZAHxTpqtq3MToRGxjaBKFAn5eoKTu6DzC63W/2q
         xG2c499Lrjsa6zhW5Rx2zvCOqhrCTxtE962aVjQm1r1XLGcqvpOp77011Uqreo1SrNCl
         nNFw==
X-Gm-Message-State: ACrzQf3dNA60/XAOu7PN+QJvrVbNld+/zK48c3ukqswpeclL4wVMKE/k
        xrpo6h66JA5WOHxdkbZkOff25UWAergSob4S8hM=
X-Google-Smtp-Source: AMsMyM5VDH9oZxhnrsybz+yjoMBOjUrTqU4nAxzACYcHQWY7j9IcQmQltuZd2vB868lNTA9z38ErGg==
X-Received: by 2002:a17:907:608f:b0:78e:1b60:60e2 with SMTP id ht15-20020a170907608f00b0078e1b6060e2mr49073291ejc.382.1667832739257;
        Mon, 07 Nov 2022 06:52:19 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u18-20020a509512000000b004611c230bd0sm4376743eda.37.2022.11.07.06.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 06:52:18 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, idosch@idosch.org, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: [patch net-next 2/2] net: devlink: move netdev notifier block to dest namespace during reload
Date:   Mon,  7 Nov 2022 15:52:13 +0100
Message-Id: <20221107145213.913178-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221107145213.913178-1-jiri@resnulli.us>
References: <20221107145213.913178-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The notifier block tracking netdev changes in devlink is registered
during devlink_alloc() per-net, it is then unregistered
in devlink_free(). When devlink moves from net namespace to another one,
the notifier block needs to move along.

Fix this by adding forgotten call to move the block.

Reported-by: Ido Schimmel <idosch@idosch.org>
Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 40fcdded57e6..ea0b319385fc 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4502,8 +4502,11 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 	if (err)
 		return err;
 
-	if (dest_net && !net_eq(dest_net, curr_net))
+	if (dest_net && !net_eq(dest_net, curr_net)) {
+		move_netdevice_notifier_net(curr_net, dest_net,
+					    &devlink->netdevice_nb);
 		write_pnet(&devlink->_net, dest_net);
+	}
 
 	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
 	devlink_reload_failed_set(devlink, !!err);
-- 
2.37.3

