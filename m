Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAB552B35F
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 09:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiERHS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 03:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiERHS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 03:18:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F24ED7AA;
        Wed, 18 May 2022 00:18:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8CC0621B07;
        Wed, 18 May 2022 07:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652858334; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a12qY+sPuxs2cWzp1uE0NRguEiWR66+TeprLZ3z/42M=;
        b=y5CkAmqEURf6tbAXLxZImR9md35Mqe2TrmGYTWbzWpXOSSE1zJFdJYGfzFAydhjYEvABl8
        Fwf7no+A0zLDdX6gdf4kqG4CRYR8j9mMMGSA6aebGp9UhU6C7Rear/1CCeGDX2Kdaprrdv
        uomZz+hEh0usMCSNnnQedbqwvhmJoG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652858334;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a12qY+sPuxs2cWzp1uE0NRguEiWR66+TeprLZ3z/42M=;
        b=+hBZirRiOLIhDfieYUv9yDrFJQ3+SyFh1pSv8IPBNhHByP5VVxm8siMkF41FCjMwK5h4Ly
        HenVKb1LduOtMlDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4B8DC133F5;
        Wed, 18 May 2022 07:18:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oPTCD96dhGJdSgAAMHmgww
        (envelope-from <mliska@suse.cz>); Wed, 18 May 2022 07:18:54 +0000
Message-ID: <e3cf25ce-740a-c9eb-0d30-41230672b67c@suse.cz>
Date:   Wed, 18 May 2022 09:18:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   =?UTF-8?Q?Martin_Li=c5=a1ka?= <mliska@suse.cz>
Subject: [PATCH v2] eth: sun: cassini: remove dead code
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, mliska@suse.cz,
        netdev@vger.kernel.org, pabeni@redhat.com
References: <20220517185035.4ee3dd8e@kernel.org>
Content-Language: en-US
In-Reply-To: <20220517185035.4ee3dd8e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following GCC warning:

drivers/net/ethernet/sun/cassini.c:1316:29: error: comparison between two arrays [-Werror=array-compare]
drivers/net/ethernet/sun/cassini.c:3783:34: error: comparison between two arrays [-Werror=array-compare]

Note that 2 arrays should be compared by comparing of their addresses:
note: use ‘&cas_prog_workaroundtab[0] == &cas_prog_null[0]’ to compare the addresses

Signed-off-by: Martin Liska <mliska@suse.cz>
---
 drivers/net/ethernet/sun/cassini.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index b04a6a7bf566..435dc00d04e5 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -1313,7 +1313,7 @@ static void cas_init_rx_dma(struct cas *cp)
 	writel(val, cp->regs + REG_RX_PAGE_SIZE);
 
 	/* enable the header parser if desired */
-	if (CAS_HP_FIRMWARE == cas_prog_null)
+	if (&CAS_HP_FIRMWARE[0] == &cas_prog_null[0])
 		return;
 
 	val = CAS_BASE(HP_CFG_NUM_CPU, CAS_NCPUS > 63 ? 0 : CAS_NCPUS);
@@ -3780,7 +3780,7 @@ static void cas_reset(struct cas *cp, int blkflag)
 
 	/* program header parser */
 	if ((cp->cas_flags & CAS_FLAG_TARGET_ABORT) ||
-	    (CAS_HP_ALT_FIRMWARE == cas_prog_null)) {
+	    (&CAS_HP_ALT_FIRMWARE[0] == &cas_prog_null[0])) {
 		cas_load_firmware(cp, CAS_HP_FIRMWARE);
 	} else {
 		cas_load_firmware(cp, CAS_HP_ALT_FIRMWARE);
-- 
2.36.1

