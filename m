Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1BD5A0C9F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbiHYJ3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239801AbiHYJ2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:28:46 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DC1AA361
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:28:41 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id q7so23741473lfu.5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc;
        bh=NFmp4r2urbPoTlr0LkARXhKrAhHH6AMgDgo8CtXnfZM=;
        b=o/cXCQ12PHnTt+UxltHztdLwkJ6jRPr84Yv/tHn24Ts8r4+CrE6Ohkqq8y1udOg6KU
         yAU9EypWnKL/eRi7q7U1un6TkIOXnqZK8H2JUgL75ziuCbbkQPf8NERlixHtUOsRHgvC
         xiNo0QK6hkGge84dsZi6reoBS+l1mI0m24p1PCjv2Z9DRGbj3qTb/ptusy1IGG9Mb6Od
         wbWz1NzSXPZMdrIJM6TdvGYc84I/Imm9L2u1jLuE3QVAn04xhiz3JBz5PWHNNQ43TZdd
         1tzwN5Ns9QyxaijyJqfI5iyOzvyUHs8z62tfeTB9DrHzCNvCmRLdxrOzlZHuKaab34Lt
         zERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc;
        bh=NFmp4r2urbPoTlr0LkARXhKrAhHH6AMgDgo8CtXnfZM=;
        b=X8t4+H5vPrLHJ921x4NP5hdkjKdPeh7IFvLiK6uF4iLW1MHvgzKCk7t66vqO8xPuQf
         f/TBcSm8Joctbz5yEqj1mC3G841r1PsHhWe+dt8xZF/1J8OcC11XS/wa69hsFbUmQpZ9
         /7XZm42Mni+m3Xq5DxsmRAZk07/l9ZrcIR/FXjMr6/b46LupSnb8CMQp39733kkfNNZp
         2m2dqiFNTWoTFlQrFpa6blVs+jUeLmi58vVfDOu5K8wSfSXXmFoKyWuTkDlSO1Lu31Tt
         x+EHOEx5bKQiMxMVezC5BJEx3900aJzm8nHY+GEpZkpBL7VZ6WRjWM6zeUQtt+pZRzFj
         z6TQ==
X-Gm-Message-State: ACgBeo02WIdydlbkcXef28VJq2cjMLoVrWyIVkIU8htZ0BwR1QqBbgUv
        XaymxKNq5bzTmMce9KBX/EQ=
X-Google-Smtp-Source: AA6agR7QdkyIJTDLquJis+XO37O0MxVOiRVPs7SSGVbpPP3nTOiC/t4kfE2EiETSYA0GkimQ65duAg==
X-Received: by 2002:a05:6512:31d0:b0:492:fe2e:7695 with SMTP id j16-20020a05651231d000b00492fe2e7695mr974847lfe.392.1661419720335;
        Thu, 25 Aug 2022 02:28:40 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g16-20020a19e050000000b00492c4d2fcbfsm398988lfj.115.2022.08.25.02.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 02:28:39 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 1/3] ethernet: Add helpers to recognize addresses mapped to IP multicast
Date:   Thu, 25 Aug 2022 11:28:35 +0200
Message-Id: <20220825092837.907135-2-casper.casan@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825092837.907135-1-casper.casan@gmail.com>
References: <20220825092837.907135-1-casper.casan@gmail.com>
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

