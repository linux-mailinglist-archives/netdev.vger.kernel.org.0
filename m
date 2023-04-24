Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C8F6ED32E
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjDXRJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDXRJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:09:38 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FAC59FD
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:09:37 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-3ef38bea86aso23153261cf.3
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682356176; x=1684948176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yqqIhPpCZwfRJ5UBul5epz4xPcbVhRDVWkoAPPyrcMg=;
        b=HQv0BDUCEKXac/yuNjUV32Ksi7VgYa3hP1zuIntMp33+SYHZwTiK42Tj9+shhBT5jh
         cwVpWjs6140kraDj2gtjoADd4wodtz/ciwana1BohyXqQkrBE5fYjYACT9COtz7T1xj2
         z1PYOwQV517nrzTNHYlGg5ptRsiH81o/zUUMt9S/6V4jZ2ygjhazlrZladplxkD3+l+K
         agNsNO4+w/Hgw9XEi8SGkhPg1UrpnikdWK1o94XwyY243GTrHycfu2BC+vKXeoKsOzf8
         QOJ5/ftG3BgDKDdsRdwjKcyKyy9R/Iu030nFhtN8Iy0NZhM3tigY/uTSkNUv3vSoNTrH
         ex7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682356176; x=1684948176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yqqIhPpCZwfRJ5UBul5epz4xPcbVhRDVWkoAPPyrcMg=;
        b=TC+2N+BuDs4nvmri+a1AL9ygEHVwMH2E32t3diP+qq6MQbl2IKBbYiFUDgguJuSIo5
         KHb0yiW0iQllVy0j9Gs+jzWN7WGUWpVP2eOuL8vi64qJrH6/wYhBcHjFIasMlte5tiyc
         2zecfG2ltDswAcNWWID6Q4Gl18Ku6ndwi3viH3xMVC7xbfOIMBbnyOZa74qZXoP6mGPZ
         WI1wVY62f0uBdhI9YjzBp9iG4wyGhGy1RW+XVsZLB2QmHebpSkEPkpBDEsztIbaUarza
         kfw2e9+YtzCWxhSWEqT6qKu7V4oN67Fqw0uf9yKrpuRhLKvyySrtrUdH94EsJFecqd57
         QIvQ==
X-Gm-Message-State: AAQBX9fJPCZBczfVVpd43CyaH/G/BealyniFeALCH7Sc4pnh5fPyKJn/
        SSJr6B/+B8ektcQH/M/ETg4KqQ==
X-Google-Smtp-Source: AKy350b+uuZiQ+B/iIAUlerUO4HYqpI0MQvlQu0b+IC5kwEAIJ40R7lkM5zckRZuPvcXpnjxCscKTg==
X-Received: by 2002:ac8:5a84:0:b0:3ef:31c4:c8da with SMTP id c4-20020ac85a84000000b003ef31c4c8damr24481752qtc.50.1682356176434;
        Mon, 24 Apr 2023 10:09:36 -0700 (PDT)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-29-174-95-194-35.dsl.bell.ca. [174.95.194.35])
        by smtp.gmail.com with ESMTPSA id r7-20020ac87ee7000000b003edfb5d7637sm3761509qtc.73.2023.04.24.10.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 10:09:35 -0700 (PDT)
From:   Victor Nogueira <victor@mojatatu.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kernel@mojatatu.com,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net v2] net/sched: act_mirred: Add carrier check
Date:   Mon, 24 Apr 2023 17:08:32 +0000
Message-Id: <20230424170832.549298-1-victor@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are cases where the device is adminstratively UP, but operationally 
down. For example, we have a physical device (Nvidia ConnectX-6 Dx, 25Gbps)
who's cable was pulled out, here is its ip link output:

5: ens2f1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether b8:ce:f6:4b:68:35 brd ff:ff:ff:ff:ff:ff
    altname enp179s0f1np1

As you can see, it's administratively UP but operationally down.
In this case, sending a packet to this port caused a nasty kernel hang (so
nasty that we were unable to capture it). Aborting a transmit based on
operational status (in addition to administrative status) fixes the issue.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
---
 net/sched/act_mirred.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index ec43764e92e7..0a711c184c29 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -264,7 +264,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 		goto out;
 	}
 
-	if (unlikely(!(dev->flags & IFF_UP))) {
+	if (unlikely(!(dev->flags & IFF_UP)) || !netif_carrier_ok(dev)) {
 		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
 				       dev->name);
 		goto out;
-- 
2.25.1

