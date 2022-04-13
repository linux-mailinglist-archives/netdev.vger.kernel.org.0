Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7BA50006B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiDMU7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiDMU7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:59:20 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415AB76656
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 13:56:58 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id i24-20020a17090adc1800b001cd5529465aso2672979pjv.0
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 13:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EFYkcrblbX08CDDipSctf1YXsgsUzN7BdZZfPye7l6Y=;
        b=Ioah5tPj1VoVYF2FHSWtEFCrJQFFyU3kifLxdvztCh4TUu4rUj2v1CTmckDbg+FRUy
         cmv+CVgybzuwUTmqjvFpeFUSnA8LCO8BHJK0DlFrio8GVVcrJe04lTmytoRSnnAxq/5q
         hdCk3qhtn0bWjMOD5U9j0k9l5+BaLhTR6VyQp/R96d5/E3pzNBBNJA7IG30kwxnKq8mi
         SiicswMb5MzwQ6snDJocTZ59i+WqJVoPsUMXSK+9SKXaUai9hFaKuuuvaXThCI/Xi7WE
         BJjHOCexNfPzX4ECDkAX8F0/sMRW6WEzBiu0XPchAGjA8UumDyocHRWw4AaLH2sJ4Hh5
         TiPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EFYkcrblbX08CDDipSctf1YXsgsUzN7BdZZfPye7l6Y=;
        b=FkQF8BDHzhP38tb3Olsp3uosOpjUJkevjq82OMYX0ZwO3hw5CvsjqAkrvRjM0UOpfN
         z63O1ljvkfUG4plboUq/jVJcFHLQldm81o0YuyF4bEx2Yfx6XB/yHhIr1UAK3hu8HFhs
         hsKYtLGYcfJV6pkG6IugmILlwtQ5jPYjOj+0bVgCn90PgiUozXI+uHZGa99fmYIm7MAC
         dBblv7RMeLswSLW8rfqi9Eb+jxb4Rtp8nKeNNRE0Cx1+Pt+PU1mRDkdHVIouUpcxQxIr
         kp18wZXo47aG1xUm5tvOr7INwm0UTPG7BkGeTmnNBGjsaRMDlgs/2hTcghy35i+MDnDE
         HHRQ==
X-Gm-Message-State: AOAM532iMpFnf/NmSlYpbHrhW2ROrNfbGi1mWkXgv07SFxXIaUpFBmLI
        lJ0qsvuMrvMN+SxqGtjJcYM=
X-Google-Smtp-Source: ABdhPJzBdhj9enSFZ0XiiI1QYSuqbKMrzDjDjSt+9a2TgDz7tXP24rCADYwmPlDmd0Z1t4i17FSwww==
X-Received: by 2002:a17:902:dace:b0:158:6fba:4e91 with SMTP id q14-20020a170902dace00b001586fba4e91mr14780527plx.20.1649883417763;
        Wed, 13 Apr 2022 13:56:57 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d72c:6411:a3d0:eca9])
        by smtp.gmail.com with ESMTPSA id c64-20020a624e43000000b005081ec7d679sm1513185pfb.1.2022.04.13.13.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 13:56:57 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next] ipv6: fix NULL deref in ip6_rcv_core()
Date:   Wed, 13 Apr 2022 13:56:53 -0700
Message-Id: <20220413205653.1178458-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
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

idev can be NULL, as the surrounding code suggests.

Fixes: 4daf841a2ef3 ("net: ipv6: add skb drop reasons to ip6_rcv_core()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Menglong Dong <imagedong@tencent.com>
Cc: Jiang Biao <benbjiang@tencent.com>
Cc: Hao Peng <flyingpeng@tencent.com>
---
 net/ipv6/ip6_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 126ae3aa67e1dc579bc0eecd21416e9d89dcbf08..0322cc86b84eaaed7529a4b65fdfba4c97a38375 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -166,7 +166,7 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
 	    !idev || unlikely(idev->cnf.disable_ipv6)) {
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
-		if (unlikely(idev->cnf.disable_ipv6))
+		if (idev && unlikely(idev->cnf.disable_ipv6))
 			SKB_DR_SET(reason, IPV6DISABLED);
 		goto drop;
 	}
-- 
2.35.1.1178.g4f1659d476-goog

