Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5884E5FBCF0
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 23:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJKV20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 17:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiJKV2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 17:28:04 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDA78A7CC
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 14:27:50 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h10so14435711plb.2
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 14:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fqmmrn+cmRnWxMU7u8muTr0GA15oUIN9xUfPL4ZBnC8=;
        b=F3tRs+6+SxxylS5dYW5aJUHh6vmVBN2fZQ/2DJ8kGfyW7R+HrodPsTfImWqxiXUBSv
         RXDCiNM6NVYc09Srp7I8uDfhjhTpWEy05wbekSgXzj6R41SyDU0+uz9aLHt2B3F2HB6o
         2IUxRKnJjSIyoAEp6of2iJgC6X57ZDL3fz21g4KPlYnENEDxFCFFP9DUX4zmwSbPV0x7
         VwjsUjtRpXbiQgG63HxD5IziaAkCH3eR8UolnsiPgKbz2XQNJbht3p9ac6W0AyHHRBHM
         WDlgWPooOp1Npb4iBiB9IgGrLHsHTYd1Pr/++FTiX9941Rh63KfknAiotQCqcBhTLhD7
         B4ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fqmmrn+cmRnWxMU7u8muTr0GA15oUIN9xUfPL4ZBnC8=;
        b=4gDVrEx/HGNl6XCbwsib2E8TaDTWhHo0huUcCJ0excjm9JnjC36cJVMcrjiTI83tqr
         jb3sumQ0+prSY76MncgZsgNY88VDqNlER0rMoc58t/xegOeDbN6tda7NBKtXLLIcPp6g
         GdeioiyGwsX1s9hUISiuCzlzjKphBc1C4jcSW9Hv0KyW0wv1hb7A/TmmNcGpSkXC3azE
         N232r/0Dx+IGWRM3Y/1iCVDhO04qmSCg53iDB71nEOryPwRFk9C2+oqxRfdRotjdRVem
         1HhP+6Rstf5McZ93PkEkSMEaMTpSQGok+XzAnBMzT8WJeWKDk+ct5OfTFqoSdpd5Mbil
         Vnlg==
X-Gm-Message-State: ACrzQf0DfYoyXeQkeI/ymk5HzQEulMDEWNcL0satAkXQle45HjcuonP5
        +Bt5teC4JmjSYu6mn46TsiA=
X-Google-Smtp-Source: AMsMyM4grjJZ2170snO67vvm8TbynVwsdU4pI3KW3YQkrTt+GHqLs+ks0BvRoTSs7+5DDIDOeRjXrQ==
X-Received: by 2002:a17:902:ca02:b0:17f:762e:2dd2 with SMTP id w2-20020a170902ca0200b0017f762e2dd2mr26270784pld.91.1665523659051;
        Tue, 11 Oct 2022 14:27:39 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:245b:b683:5ec3:7a71])
        by smtp.gmail.com with ESMTPSA id ix21-20020a170902f81500b001750792f20asm936592plb.238.2022.10.11.14.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 14:27:38 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH net 1/2] ipv6: ping: fix wrong checksum for large frames
Date:   Tue, 11 Oct 2022 14:27:28 -0700
Message-Id: <20221011212729.3777710-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20221011212729.3777710-1-eric.dumazet@gmail.com>
References: <20221011212729.3777710-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric Dumazet <edumazet@google.com>

For a given ping datagram, ping_getfrag() is called once
per skb fragment.

A large datagram requiring more than one page fragment
is currently getting the checksum of the last fragment,
instead of the cumulative one.

After this patch, "ping -s 35000 ::1" is working correctly.

Fixes: 6d0bfe226116 ("net: ipv6: Add IPv6 support to the ping socket.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Maciej Żenczykowski <maze@google.com>
---
 net/ipv4/ping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 517042caf6dc10c46f6ddb349d99789e4f072382..705672f319e16645d5fe2f333ed00dbd020e1ea2 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -639,7 +639,7 @@ int ping_getfrag(void *from, char *to,
 	 * wcheck, it will be finalized in ping_v4_push_pending_frames.
 	 */
 	if (pfh->family == AF_INET6) {
-		skb->csum = pfh->wcheck;
+		skb->csum = csum_block_add(skb->csum, pfh->wcheck, odd);
 		skb->ip_summed = CHECKSUM_NONE;
 		pfh->wcheck = 0;
 	}
-- 
2.38.0.rc1.362.ged0d419d3c-goog

