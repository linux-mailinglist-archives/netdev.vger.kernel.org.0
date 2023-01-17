Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC3366E72B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 20:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjAQTkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 14:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbjAQThi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 14:37:38 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9CC4B77C
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:42:29 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id u20so5910963qvq.4
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w5U3RxGI80qVmCdGm0Q9iVxT+fyyIddpqD0erPx5HFE=;
        b=HlCFJMqD4i1gvOeBehGcZhjCxEFb11tSkyYJoOW+bUtNhbfg5rslIJCtBQEqYME4gU
         bpDcFJ9Jao3FQcDRQ2Q2hFx4x6FwtJY2uwyCrQw8qOtpi2PgSXq23JixnY+ykHiOVzI/
         k723HAWW4/txdT4yzBK+cuqi/LoH5zo23NHeYA+4R2V8xdkb0Yo/bJvkOrmUpB6xzF2x
         n7zQCL+/rBZ6BWDKXDEhhMf0w2DebWamo/FWAXstSdaKJ3j8eORAZb0uQemE9OtQvsB+
         3xMTrVSOaY614iNBidaORbvPhm4jTN5xJD1bscaZPtKfQJoTa3YO0aL7JPGWvuhRY45Q
         /6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w5U3RxGI80qVmCdGm0Q9iVxT+fyyIddpqD0erPx5HFE=;
        b=RnoOIr3Ipfsa4VTMQDPpkR37HfS8ju2cyVKZEc2sMpomW/hqjFMBnJN4OoUDpxXNj3
         4WuSiFztL8Oe09UnSAnMqV1OhtlsRLNJfmfGQqWhgMLCdGiVaHbcwLrplhmwniz0pDs4
         7URDfElEPKlAOVA4PyijIQVhOhDsd06WVt0r8HyGO4J0pbChSoHRVSEyp3TzESIQTbyV
         drE0z91sPwJ/eYbNJAYIv4yqfQGtCu5PWfERuFgDbJWWfvU/I/mnmHWitadjAgnVxiKD
         AYcVQ8ft/WFlLNY3ZcGwEPVUO9qeWLxZWZIM0ZStTCPB1xvwNX480K+UDzyohQOEH/aM
         tzhQ==
X-Gm-Message-State: AFqh2konGmonXF2OlfSWn3N7gjh89fxAVvvNOkDxLjOK0IEJlJ+tFaN2
        AWxpABfGFolMEDzl0BGyCpyYpLV/ifPZtQ==
X-Google-Smtp-Source: AMrXdXtYkJysTCQJbLkXk+yguJIykrUnfmUac9DqO8xzBSyStNNpmkDWy2O0AGfipm/AC3kHakB6Qg==
X-Received: by 2002:ad4:4501:0:b0:531:bb84:b9ef with SMTP id k1-20020ad44501000000b00531bb84b9efmr34384269qvu.46.1673980933530;
        Tue, 17 Jan 2023 10:42:13 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id m4-20020a05620a290400b007069fde14a6sm1491886qkp.25.2023.01.17.10.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 10:42:13 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net] Revert "net: team: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf"
Date:   Tue, 17 Jan 2023 13:42:12 -0500
Message-Id: <63e09531fc47963d2e4eff376653d3db21b97058.1673980932.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

This reverts commit 0aa64df30b382fc71d4fb1827d528e0eb3eff854.

Currently IFF_NO_ADDRCONF is used to prevent all ipv6 addrconf for the
slave ports of team, bonding and failover devices and it means no ipv6
packets can be sent out through these slave ports. However, for team
device, "nsna_ping" link_watch requires ipv6 addrconf. Otherwise, the
link will be marked failure. This patch removes the IFF_NO_ADDRCONF
flag set for team port, and we will fix the original issue in another
patch, as Jakub suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/team/team.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index fcd43d62d86b..d10606f257c4 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1044,7 +1044,6 @@ static int team_port_enter(struct team *team, struct team_port *port)
 			goto err_port_enter;
 		}
 	}
-	port->dev->priv_flags |= IFF_NO_ADDRCONF;
 
 	return 0;
 
@@ -1058,7 +1057,6 @@ static void team_port_leave(struct team *team, struct team_port *port)
 {
 	if (team->ops.port_leave)
 		team->ops.port_leave(team, port);
-	port->dev->priv_flags &= ~IFF_NO_ADDRCONF;
 	dev_put(team->dev);
 }
 
-- 
2.31.1

