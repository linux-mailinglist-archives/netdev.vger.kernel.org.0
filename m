Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529E351DC32
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379604AbiEFPgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442986AbiEFPf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:35:29 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A0E6E8D6
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:31:21 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n18so7776403plg.5
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V+KJgJWC/mZzQ1xI2xAF94ZgqLkHsDJA4L2W1AotAhQ=;
        b=EEDm61/uLum5dW3PKEQD+dtsH7CvHTMJEVpZi4tdMofKeQHSOU4qazS+I0NhqqA5bX
         VENF7gjSm9t79yNHnuDAuh1qTwvufH1B4XVSkLU1YwCYx5acj5y2C7ga5Zz11iXVbm1p
         Q+bCWnRhZdJnd3s25KCM/Bh8f/KgaWjbkgmnhDTHESKkTMQpssbsPBDkzROiAnMgovKe
         KV63dOmjFS0VL+MKiOllSq2r0zPocpgZYhzTyx8M3TcqspqC4KbR0v2tOAUl1k1GhjUu
         m9QY4Cxt1ihd+aw8FhuDf2XamR1OWeJ7yGT4Y7mjUjoYquxClajnsvFRh3BxNAB7GX5N
         /0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V+KJgJWC/mZzQ1xI2xAF94ZgqLkHsDJA4L2W1AotAhQ=;
        b=AEkHyNLEstm1aJZ62jjE9XmB/yyZekbVMDfBQRERu+rYqQ0CvBIUO1pfgjZxwXniXT
         dTlsiGuENSbR8EnQoVThQVHLxRywY+sGEYkPfqA8ZhtTGamKhh/D4e4XKfEIaOPdeVw6
         /vD44DO0eu4pXZo+LkCp/+SRapJHaE1k3Yqhl/Ap3Zyu/Xi0ZrAvQi8Dry9seUdFVhR0
         vIt5DQVoIUi57YECa6JtMSpGHlIr4HONSgv8tVcJ/5TjmOBs0PzQCts/P7rFpxzXT4l4
         AVjDjmrVdPQ5+DVRO1GeGxloK7yTQwYjfRPH/sZvJRfmyeSYz9xRhKz6Dzc/MBbS8FM3
         SscA==
X-Gm-Message-State: AOAM530sRWgnFb67HmpfG1mrSGgsPpxDtdhztszlQS+9myxqXt94/ZDY
        R2Xt3sn2PA1RpIG5Qjpz0KqAhBgGeAM=
X-Google-Smtp-Source: ABdhPJzB159EEAJZ+RXe8VhZdIg/qhI/qnbzccMKPkAuwNmFuiorUIOip30U6Cy5pTxrAtflcaP+kg==
X-Received: by 2002:a17:902:b78c:b0:15d:2431:a806 with SMTP id e12-20020a170902b78c00b0015d2431a806mr4210960pls.77.1651851080826;
        Fri, 06 May 2022 08:31:20 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b0015e8d4eb1bfsm1918612ply.9.2022.05.06.08.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:31:20 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 09/12] net: loopback: enable BIG TCP packets
Date:   Fri,  6 May 2022 08:30:45 -0700
Message-Id: <20220506153048.3695721-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220506153048.3695721-1-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
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

Set the driver limit to 512 KB per TSO ipv6 packet.

This allows the admin/user to set a GSO ipv6 limit up to this value.

Tested:

ip link set dev lo gso_ipv6_max_size 200000
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
---
 drivers/net/loopback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 720394c0639b20a2fd6262e4ee9d5813c02802f1..f504dd0817092d63f0e929500ec49cfdda562c4b 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -191,6 +191,8 @@ static void gen_lo_setup(struct net_device *dev,
 	dev->netdev_ops		= dev_ops;
 	dev->needs_free_netdev	= true;
 	dev->priv_destructor	= dev_destructor;
+
+	netif_set_tso_max_size(dev, 512 * 1024);
 }
 
 /* The loopback device is special. There is only one instance
-- 
2.36.0.512.ge40c2bad7a-goog

