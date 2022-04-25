Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B63050EBBF
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 00:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbiDYWYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 18:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343611AbiDYVpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 17:45:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CFD10C88A;
        Mon, 25 Apr 2022 14:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7163B61480;
        Mon, 25 Apr 2022 21:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C289C385A7;
        Mon, 25 Apr 2022 21:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650922947;
        bh=nreQfjm+N9qOhwr5Z/uFXcKNU+5eXomO6oZib8laKZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyGvmkis4NtIMuPisOOwB6nGpLl1CrkC66uKzbOFYEVssd/6RtOk2FkzUifqRL1zi
         q9+7YfAa38802srg9wLvBixFw9fJUiEIURuTN0UP+VF4zMlkJFGuw9MohFkvxX7xim
         vugpiJywGHPp+gh1s/DK/u/uA9eNbzlPB779kBBELWlq9mRHE/51g+8rTE6u8fhOcg
         7GJZzsfA9k5GZ+//TVujEzlWJsBLvYQwonWDFOs2bTAW9tfDL6/V3NN+rtyNk7oaaM
         wRxXhSLD6vMQYU8OheTOKOBVj9BCADbg/5AjXUyNICyP/MQ1uDclN0AlEIl8kgoe9k
         WR0O9pA75GGAg==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chas Williams <3chas3@gmail.com>
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 1/2] net: wan: atp: remove unused eeprom_delay()
Date:   Mon, 25 Apr 2022 16:26:43 -0500
Message-Id: <20220425212644.1659070-2-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425212644.1659070-1-helgaas@kernel.org>
References: <20220425212644.1659070-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

atp.h is included only by atp.c, which does not use eeprom_delay().  Remove
the unused definition.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/net/ethernet/realtek/atp.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/atp.h b/drivers/net/ethernet/realtek/atp.h
index 63f0d2d0e87b..b202184eddd4 100644
--- a/drivers/net/ethernet/realtek/atp.h
+++ b/drivers/net/ethernet/realtek/atp.h
@@ -255,10 +255,6 @@ static inline void write_word_mode0(short ioaddr, unsigned short value)
 #define EE_DATA_WRITE	0x01	/* EEPROM chip data in. */
 #define EE_DATA_READ	0x08	/* EEPROM chip data out. */
 
-/* Delay between EEPROM clock transitions. */
-#define eeprom_delay(ticks) \
-do { int _i = 40; while (--_i > 0) { __SLOW_DOWN_IO; } } while (0)
-
 /* The EEPROM commands include the alway-set leading bit. */
 #define EE_WRITE_CMD(offset)	(((5 << 6) + (offset)) << 17)
 #define EE_READ(offset)		(((6 << 6) + (offset)) << 17)
-- 
2.25.1

