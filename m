Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9CA564D6C
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 07:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiGDFqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 01:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiGDFnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 01:43:46 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D875EAE7D
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 22:42:12 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D658E320016F;
        Mon,  4 Jul 2022 01:42:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 Jul 2022 01:42:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=traverse.com.au;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1656913331; x=
        1656999731; bh=AmIhgc/Yn+34cRT1IRVu+7PqJcuBq+IRtLr0G33qgPo=; b=D
        IEME3B+xHrDjfvrF5kRLsLdOPYxIVGCHuETicu/OVlhUGvrGiri3oqO/KqKApIKp
        6/TrKUJIqPsrRbEp5lnCOPiDn1GFy2iePXcdVRN7bJUxb5LWHUwWcuj1NphKNC++
        1xEX3z6wLyWd5ljMpspGTf6R/RceiN6YudUMyTm5NYQ+PDOZFKFE/JM6Od7aJL/H
        d8sV+Zx9t902VWzRBSxNyq3QtlpZK+GLcInO6WIRJ9tpU9kclj8mTC7tv/IqsLWi
        JuTeKZ8fzR2+h+aqVQKIECPwPxcAmLbnP5FKkvaUhkix4Ua/SqVMEr7KwWCfnIBo
        TSYzrtXpv8UkqlK+8vaEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1656913331; x=1656999731; bh=AmIhgc/Yn+34c
        RT1IRVu+7PqJcuBq+IRtLr0G33qgPo=; b=rIfGLsqHpcZelG2RqhxqRnWi8ExDH
        cAgJo5CutVsgrAf87liaargsey72tHZOLraOdLNDwqp7Iy0zC56oHCYdcowI8KbL
        mYMXqRfyVHwatqiL1PNRf1mn73fC7tEoQalCGM9trKhxp+JJNqPm7POfbm+CpbIo
        Nw34wGRU8hhH0ZFJrGTng2HU9zzDsnnx9OmwgiPDco3mp6GHoSyQPDjqF4ngkHVV
        d0j2oC9v+FUeLiEgKIcFnQf/1UDY6DjQtPPrvPkxMRaXVhvOUp3Vd43oKk/iJZSc
        JfW2QZbkjoDiIvzFtrX9kLIfQNLKaabXarRzIMrjrpp/iLqITcJ2qIahw==
X-ME-Sender: <xms:s33CYnRMN1NK27kvzqyYoQAMrdUrRUBQEf0ooQW2zLq8UMtnej8f3w>
    <xme:s33CYozhIXjauheHEB8bsxfOtlPBwnyZT4n9rNijZi6VaZoopmdLjrrra0on7NIB2
    9wr-9ooW7pcHZJ-3sA>
X-ME-Received: <xmr:s33CYs0ogeN5vU_MxmXZTOIFML8FBKnK-OiVjUSb7X5vygt9mGL4QWU2G05xxh3Z0EGMchXuYuvaKLXaNeCRE2pIWIHcs5O5H3Cwl4f2R8esX8mw5gqCxJnQYtEXIE4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehkedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepofgrthhh
    vgifucfotgeurhhiuggvuceomhgrthhtsehtrhgrvhgvrhhsvgdrtghomhdrrghuqeenuc
    ggtffrrghtthgvrhhnpeeiieefheeiieeuledufefgtdevfeejffetgedvveduffffleeh
    jedtjeegleelgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehmrghtthesthhrrghvvghrshgvrdgtohhmrdgruh
X-ME-Proxy: <xmx:s33CYnD5hZBx6nHmMo8e-bxSCYRgpUTP1_rJsYv9pyNI_aKWYHz_UA>
    <xmx:s33CYgiZqTb8SzGLgKn7e2UIqvJXsz1wBottsaYlu-smJT19IUvnYg>
    <xmx:s33CYrr0-Smd0y0919HR3T-dr4PK9TCLmtgjCxpZaLNk23TUE1yT1w>
    <xmx:s33CYsbCuI-5BnpBZX2MGU2f5tq8rR_1r4p8XGBCvV-zKd1DNLKtCw>
Feedback-ID: i426947f3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Jul 2022 01:42:09 -0400 (EDT)
From:   Mathew McBride <matt@traverse.com.au>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Mathew McBride <matt@traverse.com.au>
Subject: [PATCH ethtool 2/2] ethtool: remove restriction on ioctl commands having JSON output
Date:   Mon,  4 Jul 2022 05:41:14 +0000
Message-Id: <20220704054114.22582-3-matt@traverse.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20220704054114.22582-1-matt@traverse.com.au>
References: <20220704054114.22582-1-matt@traverse.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The module-info/dump eeprom (-m/--module-info) is one such command
which is now able to produce JSON.

Signed-off-by: Mathew McBride <matt@traverse.com.au>
---
 ethtool.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 83bbde8..ece4ac0 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6409,9 +6409,6 @@ int main(int argc, char **argp)
 	ctx.argp = argp;
 	netlink_run_handler(&ctx, args[k].nlchk, args[k].nlfunc, !args[k].func);
 
-	if (ctx.json) /* no IOCTL command supports JSON output */
-		exit_bad_args();
-
 	ret = ioctl_init(&ctx, args[k].no_dev);
 	if (ret)
 		return ret;
-- 
2.30.1

