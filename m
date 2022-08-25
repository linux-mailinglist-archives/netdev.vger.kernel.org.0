Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCDF5A0BD7
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbiHYIuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiHYIt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:49:59 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A28258B54
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:49:58 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id m3so21620775lfg.10
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc;
        bh=Tx7FdpjytekYC2f6qH5xA3rC3v2ZcgkDieJXzV8JXko=;
        b=bObiL7moe65RHlDdQe6ZeNN2eVyBUssSBYjrg/WFX72aNv/WKTUsxtb+OwXLjnnOgv
         +h06ag+b9NdacrgbTsCa0rnq31QDrDKzBvHOYy3/XOO7FIhHSNQ4GpLrr8m0D9Dt5CrE
         P24GKSS0YKlWQgqRHwjo6t660CNo+RRvjeEGxpjMmB+6fRFTk5y+BaCt9OCas4tPxYQP
         HgX0IVR2+nD/h0bV+tLtvbM9oJfcKRZqG0NiNx3P9AzoNMPAZ3gCFkajInuDvRZIWKVd
         CM7g3hvpzA0CEsDIky5sMfShV3T3G/h8aSL2raPoNXu2GX6cZNQkFLBbclf9NU4ZsELe
         15Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Tx7FdpjytekYC2f6qH5xA3rC3v2ZcgkDieJXzV8JXko=;
        b=TKFvTKsVWsq9Ph3L+tOwHLnl5MfAfemA98CWPoRW6gVThnAghWeIXG+zxYwYmXdJmB
         EJ+dtpAWn1CkCGAKiBpRtwMWuj6q2oqLpu2igIk1CjuQ2beSyY5ZarL6ThPU6yFHuauj
         Tlj+lN3t4/UVVqbWwvR4ficlI/QngQi8aWccdv3pTSUMacAfI22PQstCmhS9a2cQp6eb
         cxvrFaq51WcME0vt8Yt23pN20uc55jFpRNwQsp88LvOOPmkvpUuJ7kXWxxgX8H4kGw2H
         niF04aNhKZEm3E5kRbgdktGLomYwY4bRpmHLiZ7NSr/6ljqnCpLDVILdoxM9dYAQaj0i
         0bKQ==
X-Gm-Message-State: ACgBeo2a8YYBtfUYDOBWkzHWT1S5qbvtSNcRV+SnEooTy5JRU0Et3ihW
        voVJXAYEw8AgzeiKIHfvXxhmUvwUx1o=
X-Google-Smtp-Source: AA6agR7ny54MJZzJcn0iEM3eyuBGBT24X4G0vt4KTFh21+WPYXVoKd0s2Chv9lWz+3YeT5Z0cOEE2A==
X-Received: by 2002:a05:6512:31d3:b0:492:d019:b292 with SMTP id j19-20020a05651231d300b00492d019b292mr784757lfe.181.1661417396683;
        Thu, 25 Aug 2022 01:49:56 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id i1-20020a2ea221000000b00261c30d71e5sm405518ljm.67.2022.08.25.01.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 01:49:56 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org
Subject: [PATCH net] net: sparx5: fix handling uneven length packets in manual extraction
Date:   Thu, 25 Aug 2022 10:49:55 +0200
Message-Id: <20220825084955.684637-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Packets that are not of length divisible by 4 (e.g. 77, 78, 79) would
have the checksum included up to next multiple of 4 (a 77 bytes packet
would have 3 bytes of ethernet checksum included). The check for the
value expects it in host (Little) endian.

Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 304f84aadc36..21844beba72d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -113,6 +113,8 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 			/* This assumes STATUS_WORD_POS == 1, Status
 			 * just after last data
 			 */
+			if (!byte_swap)
+				val = ntohl((__force __be32)val);
 			byte_cnt -= (4 - XTR_VALID_BYTES(val));
 			eof_flag = true;
 			break;
-- 
2.34.1

