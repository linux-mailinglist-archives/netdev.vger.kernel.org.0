Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B773852696E
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383364AbiEMSfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383373AbiEMSek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:34:40 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34BC60ABC
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:29 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g184so8264918pgc.1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7utbp4FheijKq1VZGg+nwHoVbS5mlFjYAusJ1g8WaTI=;
        b=VOhLayRQQTCPG1a0tacfwK/WZMccdTaA/hZcWRAuMSHIrvB9TbMzEP09jQzqCm5FJ9
         9o4WEUc7wiy/6tN2E2bmx4MCPpybEQDv9OLk05SrBvAArdUAEKt/oKJPpnbZkHn70/KA
         96MoO6LD+Y7hkpN0k6yZddL50O+J3KAk78kUurZVveJbzrv7uGVcwtyZJpPbVZSWCiBo
         bqvbTmvb6s2+d9pWNx2hpcSYUxj6CeuDgT/cPPzqwT3oI253zrW0agMdJvtJFMlv8MPe
         oH4DkU+GFgnc7Vvn1Ed3YjUrLGTE4v2cD4fjgV0r+cdbMke1UeoKoMWUBYqPeZZr4UDK
         WwGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7utbp4FheijKq1VZGg+nwHoVbS5mlFjYAusJ1g8WaTI=;
        b=kVBj6l5C4YrC7WueY35aAfSCZCKxK3XsHmXVZ3BrH9xvVkO/ZmywLefk2F8HAC+DUK
         sSiEgEcC6DJS7C7EAyPQj1hVPWywUbJj7OMWGVHRXX+qxeE4iV3z1M0vWRcR/3S6J81Y
         XD5kyzss7BJ8ockglupvU3hu2xfGtl2cHLtmN8lWz/haeS3mNqm/+pEwOA9AXRnxXjT+
         MtHWOZyOuqj1qXn2jUhuWmTnrDCcfNQqTAGrJdNOtcNQFVwbL4ez5m1dEQ1Cx9Ohm/gK
         taSo184Ro1fzrNpc0u1Mbb9OwZ/cvRhcJCUXxOHtvcGr4343S92xv1xQCiMT5VxBB2JZ
         LqKw==
X-Gm-Message-State: AOAM5338UqanNP2n1x4/pNVtCrPOQ5HQwMCcMBYlhoUvkBhTdCTJQSDy
        I81g8yAv9q9UU4NeiUbOfBQ=
X-Google-Smtp-Source: ABdhPJxrtTr+K5QCrA6AVg/RVLBX4Zqx0pbJhApe+RpDcLfspu+UPNV+0lfzaQZf2GC6O0gz9eBecA==
X-Received: by 2002:a63:1c1:0:b0:3db:3d7d:fbca with SMTP id 184-20020a6301c1000000b003db3d7dfbcamr4922156pgb.461.1652466869723;
        Fri, 13 May 2022 11:34:29 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0050dc76281cesm2053566pfn.168.2022.05.13.11.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:34:29 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v7 net-next 10/13] net: loopback: enable BIG TCP packets
Date:   Fri, 13 May 2022 11:34:05 -0700
Message-Id: <20220513183408.686447-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513183408.686447-1-eric.dumazet@gmail.com>
References: <20220513183408.686447-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Set the driver limit to GSO_MAX_SIZE (512 KB).

This allows the admin/user to set a GSO limit up to this value.

Tested:

ip link set dev lo gso_max_size 200000
netperf -H ::1 -t TCP_RR -l 100 -- -r 80000,80000 &

tcpdump shows :

18:28:42.962116 IP6 ::1 > ::1: HBH 40051 > 63780: Flags [P.], seq 3626480001:3626560001, ack 3626560001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 80000
18:28:42.962138 IP6 ::1.63780 > ::1.40051: Flags [.], ack 3626560001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 0
18:28:42.962152 IP6 ::1 > ::1: HBH 63780 > 40051: Flags [P.], seq 3626560001:3626640001, ack 3626560001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 80000
18:28:42.962157 IP6 ::1.40051 > ::1.63780: Flags [.], ack 3626640001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 0
18:28:42.962180 IP6 ::1 > ::1: HBH 40051 > 63780: Flags [P.], seq 3626560001:3626640001, ack 3626640001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 80000
18:28:42.962214 IP6 ::1.63780 > ::1.40051: Flags [.], ack 3626640001, win 17743, options [nop,nop,TS val 3771179266 ecr 3771179265], length 0
18:28:42.962228 IP6 ::1 > ::1: HBH 63780 > 40051: Flags [P.], seq 3626640001:3626720001, ack 3626640001, win 17743, options [nop,nop,TS val 3771179266 ecr 3771179265], length 80000
18:28:42.962233 IP6 ::1.40051 > ::1.63780: Flags [.], ack 3626720001, win 17743, options [nop,nop,TS val 3771179266 ecr 3771179266], length 0

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/loopback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 720394c0639b20a2fd6262e4ee9d5813c02802f1..14e8d04cb4347cb7b9171d576156fb8e8ecebbe3 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -191,6 +191,8 @@ static void gen_lo_setup(struct net_device *dev,
 	dev->netdev_ops		= dev_ops;
 	dev->needs_free_netdev	= true;
 	dev->priv_destructor	= dev_destructor;
+
+	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 }
 
 /* The loopback device is special. There is only one instance
-- 
2.36.0.550.gb090851708-goog

