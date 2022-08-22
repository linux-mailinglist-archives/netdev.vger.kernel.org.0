Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BD459C15B
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbiHVOII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiHVOIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:08:06 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C49A2BB17
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 07:08:05 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id bq23so6407355lfb.7
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 07:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc;
        bh=NFmp4r2urbPoTlr0LkARXhKrAhHH6AMgDgo8CtXnfZM=;
        b=gmkTjDxuyU8aCWZuUNOJf2gofpsG+rT6jPtW2bkwgsNvFeZ0jfM1qAtyszQMEb3oHY
         GnPEM8XJwxAjdF9SQ9XjkLAzYk1hBZdSrsPiNdVeJ2Ep3PvDIqCCPHvu7eqqakwvwjDg
         VLfF3J3ju06yR+TNTSO7lSsDisroMzuThUCHxKCdJediMOzzmuThQhaizXHsnlo1f4yd
         EX2gETqEAD0Pn7vMzu9AYu31851p3q5TJfYnh4Iy7u/8r8SjhbfhCwtxapaBG/kewLLd
         F6DyXXUdnuUcWuA2N5uMl7huxzcNj8y+Z0LlPRLiXolJJ8rFQrpx3RvVdaLe/yP57rqd
         i6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc;
        bh=NFmp4r2urbPoTlr0LkARXhKrAhHH6AMgDgo8CtXnfZM=;
        b=DzaTuh/AXiyjRA3nKRE+RTSrD2rnnqS9FiWHyQ4+82hBPbv1fihXtksu53OHbC55sw
         zgmaDngFGbIeZ0rbMGeP6GhTcjfrVHXIG93NwQqLrBPifAiHLa4AZygegaZoSFpEhR39
         Ksqh/ef3UQ7kKjv12blc0H9NmghtPfE82Kl+aoOG1NlKsRB3LZkrzkncmsL4hlrBjWXM
         9tesO5OIZmHa6uNvhgo7aP3OBoSV4bwdKGneFwZSApJnFIQW7Q/wYms3uUR5FJcSyp2h
         DEnBZar4rZ+lcnDH2yCAVO4jbgxw2KXkVhC8vvVYvB1A4XUS8gC8wKOQq7jc2V06nSv2
         2vZw==
X-Gm-Message-State: ACgBeo3rBNp7z5aX7iQf5vCR9WtEsJAfotFJMR3GprT1CzKOiaJJDyvw
        Jv7qUE0CSh3EOQHhxv5czdg=
X-Google-Smtp-Source: AA6agR62+dfCbvCqyI+fch9E3+fv/Ehue62+CYnlJbCH599pZBeJE73j1eXpNHyGhrmvlcn10nTq7A==
X-Received: by 2002:a05:6512:2306:b0:48b:2905:21a8 with SMTP id o6-20020a056512230600b0048b290521a8mr7817547lfu.167.1661177283636;
        Mon, 22 Aug 2022 07:08:03 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id o14-20020a05651205ce00b0048bd7136ef3sm1934126lfo.221.2022.08.22.07.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 07:08:03 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/3] ethernet: Add helpers to recognize addresses mapped to IP multicast
Date:   Mon, 22 Aug 2022 16:07:58 +0200
Message-Id: <20220822140800.2651029-2-casper.casan@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220822140800.2651029-1-casper.casan@gmail.com>
References: <20220822140800.2651029-1-casper.casan@gmail.com>
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

IP multicast must sometimes be discriminated from non-IP multicast,
e.g. when determining the forwarding behavior of a given group in the
presence of multicast router ports on an offloaded bridge. Therefore,
provide helpers to identify these groups.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 include/linux/etherdevice.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 92b10e67d5f8..a541f0c4f146 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -428,6 +428,28 @@ static inline bool ether_addr_equal_masked(const u8 *addr1, const u8 *addr2,
 	return true;
 }
 
+static inline bool ether_addr_is_ipv4_mcast(const u8 *addr)
+{
+	u8 base[ETH_ALEN] = { 0x01, 0x00, 0x5e, 0x00, 0x00, 0x00 };
+	u8 mask[ETH_ALEN] = { 0xff, 0xff, 0xff, 0x80, 0x00, 0x00 };
+
+	return ether_addr_equal_masked(addr, base, mask);
+}
+
+static inline bool ether_addr_is_ipv6_mcast(const u8 *addr)
+{
+	u8 base[ETH_ALEN] = { 0x33, 0x33, 0x00, 0x00, 0x00, 0x00 };
+	u8 mask[ETH_ALEN] = { 0xff, 0xff, 0x00, 0x00, 0x00, 0x00 };
+
+	return ether_addr_equal_masked(addr, base, mask);
+}
+
+static inline bool ether_addr_is_ip_mcast(const u8 *addr)
+{
+	return ether_addr_is_ipv4_mcast(addr) ||
+		ether_addr_is_ipv6_mcast(addr);
+}
+
 /**
  * ether_addr_to_u64 - Convert an Ethernet address into a u64 value.
  * @addr: Pointer to a six-byte array containing the Ethernet address
-- 
2.34.1

