Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D30621234
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbiKHNWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbiKHNWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:22:17 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367824FF8C
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:22:17 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso9063636wmo.1
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 05:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+vZgKNjNUIHUVeYYEfpYmZwp75ayqVVVIE8sy93soOs=;
        b=U0KSS4QG7lCHfd8ZdJ6ncM1sdCq19RaOarstgauYyiE4DAj05kU4sXtex7hUxfbqxy
         Lk4EY2snw2BX/eQu2mQvA822Z1OItUChoHocCyJEc+mfaS+3TxHHYGACUr0WpUxrXyV8
         A0UxNicLCLc+zy8c9V8OE/xdiU9vC5KYLsAnwsDjAuJx5SU9gpbcHFDgGZwycYA44LBy
         L8FFl0SQRrdYgzhjzv79MB+fCBpGF50EvyGURQ9RBc/E1pXTTia0guZ7ytG+eZJ8mEo3
         jydsS1mn+D/h9MAdm0+C2DCMIg79v3y4+bC0lEUkjj/vkFytfZsV1ZhCRmpHiFz529lJ
         vDYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+vZgKNjNUIHUVeYYEfpYmZwp75ayqVVVIE8sy93soOs=;
        b=OSFxrfC2v5QNyitjooyvznuRf9welwBbezZ8tYVKFrHj+y2p/PA9v5RguR0fhcEhAk
         sjgPxP0qpbdRMAWvbc6MMiVvOwJWOOonVBWns4kF4EdVorPuO1KNgVNjye0ndGA3AuMM
         zi1DqA7ZzHHbxuVkJ/vLFomrvHQUB5W2/hHYadtafBvJlPYDBkPmIu1FCcWB1O9c7INH
         Ox6jJx+oNfWu7nLOJscbKbE5Y39TpE4ATUh/SZwFjV3AM+lgWOg1bv5fG04uOW/NChTE
         tmBiw3CmYEjKHH+BNwglcTbDm0LulgJCsAlGSuOyWURKRZUkBUU+mF2LEswI3cc5FDQa
         f4Kg==
X-Gm-Message-State: ACrzQf1hu9VO3t5235aJvvt6S6OeiUwrJm1r140Y8hrGSXdqNqgVfcxv
        eOdgSkNMxe442CcxpXkFRhrdAlpi7TZb96J0
X-Google-Smtp-Source: AMsMyM47g1qyIgfDk9hp3zI2ybNN9NYhzxIe1BjaOTZraXNrWF1M8lfi+++ERmdmiAd14nCwfhsqPw==
X-Received: by 2002:a05:600c:4891:b0:3cf:9cd9:a857 with SMTP id j17-20020a05600c489100b003cf9cd9a857mr14041073wmp.44.1667913735745;
        Tue, 08 Nov 2022 05:22:15 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j27-20020a05600c1c1b00b003a8434530bbsm15872497wms.13.2022.11.08.05.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 05:22:15 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, idosch@idosch.org, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: [patch net-next v2 2/3] net: devlink: move netdev notifier block to dest namespace during reload
Date:   Tue,  8 Nov 2022 14:22:07 +0100
Message-Id: <20221108132208.938676-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221108132208.938676-1-jiri@resnulli.us>
References: <20221108132208.938676-1-jiri@resnulli.us>
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
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
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

