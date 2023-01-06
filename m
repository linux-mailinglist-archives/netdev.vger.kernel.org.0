Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4280D65FBE7
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 08:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjAFH2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 02:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjAFH2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 02:28:05 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3568B6ECBD
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 23:28:04 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3922E244F0;
        Fri,  6 Jan 2023 07:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672990082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=qcHUiVAjJO3DMY5+VXRQErLJFnEpu+52N7JyRTTtab8=;
        b=Obnz0JTZbqZVSRu5rHlgGY7Yld96w/YO9gpnshQBxWPxVzcBSGZn0HYGLtbSnYlqH5JBin
        PwpyF/Wnx/FAL6sYxVRzp78ORRdQfTZyQ7uMO7uerv+zCesMaG1mDu8SWK6YtylZa2Ykqx
        rQYra1Xo7uoBaiVbwzfK57281Dxf/TM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672990082;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=qcHUiVAjJO3DMY5+VXRQErLJFnEpu+52N7JyRTTtab8=;
        b=0n5SWdt2T2a2g8v/Cm3hugx00Bfu6ro6SXuTprzvpAu/F9VDwejNc8vPScqNx6W8QlGW7j
        ASgXtMZN9+iokUCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 14E5A13596;
        Fri,  6 Jan 2023 07:28:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Gg2+BILNt2OMMwAAMHmgww
        (envelope-from <iivanov@suse.de>); Fri, 06 Jan 2023 07:28:02 +0000
From:   "Ivan T. Ivanov" <iivanov@suse.de>
To:     aspriel@gmail.com, marcan@marcan.st
Cc:     franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        rmk+kernel@armlinux.org.uk, kvalo@kernel.org, davem@davemloft.net,
        devicetree@vger.kernel.org, edumazet@google.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        "Ivan T. Ivanov" <iivanov@suse.de>
Subject: [PATCH] brcmfmac: of: Use board compatible string for board type
Date:   Fri,  6 Jan 2023 09:27:46 +0200
Message-Id: <20230106072746.29516-1-iivanov@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When "brcm,board-type" is not explicitly set in devicetree
fallback to board compatible string for board type.

Some of the existing devices rely on the most compatible device
string to find best firmware files, including Raspberry PI's[1].

Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")

[1] https://bugzilla.opensuse.org/show_bug.cgi?id=1206697#c13

Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index a83699de01ec..fdd0c9abc1a1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -79,7 +79,8 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	/* Apple ARM64 platforms have their own idea of board type, passed in
 	 * via the device tree. They also have an antenna SKU parameter
 	 */
-	if (!of_property_read_string(np, "brcm,board-type", &prop))
+	err = of_property_read_string(np, "brcm,board-type", &prop);
+	if (!err)
 		settings->board_type = prop;
 
 	if (!of_property_read_string(np, "apple,antenna-sku", &prop))
@@ -87,7 +88,7 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 
 	/* Set board-type to the first string of the machine compatible prop */
 	root = of_find_node_by_path("/");
-	if (root && !settings->board_type) {
+	if (root && err) {
 		char *board_type;
 		const char *tmp;
 
-- 
2.35.3

