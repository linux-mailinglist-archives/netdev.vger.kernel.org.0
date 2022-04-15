Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F328502F16
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 21:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348393AbiDOTLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 15:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348303AbiDOTLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 15:11:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2B8DAFFD;
        Fri, 15 Apr 2022 12:08:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF6C161AD1;
        Fri, 15 Apr 2022 19:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BFFC385A4;
        Fri, 15 Apr 2022 19:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650049712;
        bh=nreQfjm+N9qOhwr5Z/uFXcKNU+5eXomO6oZib8laKZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uy7wm2dbW0KsrkPVWxh3QI7TRGnVyhSSco7+9aVi5fskwyqNsDWtS+q/SXS0bNcDO
         CYltjjk3xL9ZG6NwBehx/ojBF5VY7YIGy3NLngmpDUfuDXDgriKqzMRePSTVMnGAdD
         R+rqHc1skZ92pOdAFuoa4otdVxaZew8vigWMLMntEk6IdaYxNKGjrYB8+Mfk1d5bD5
         WiKK6lwF3+vqPJl7B0VQDyrm5GpW3KJLj91M175TJmwtb2bQWMafnrh0awZTyXc+yi
         n1+OadUZmi73lelEAcmJo9wdqSiDxF2HbLYakkwcJVG5pomoGx33bln+IKhygSvfk/
         n/ZpSUlcUTW0Q==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Chas Williams <3chas3@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 1/7] net: wan: atp: remove unused eeprom_delay()
Date:   Fri, 15 Apr 2022 14:08:11 -0500
Message-Id: <20220415190817.842864-2-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415190817.842864-1-helgaas@kernel.org>
References: <20220415190817.842864-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

