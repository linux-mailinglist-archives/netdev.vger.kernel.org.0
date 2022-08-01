Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2E6586339
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 06:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238784AbiHAEH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 00:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiHAEHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 00:07:55 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE22B9FFC;
        Sun, 31 Jul 2022 21:07:54 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y9so9473499pff.12;
        Sun, 31 Jul 2022 21:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=D5xZ1wA9YMWNc7m+u2IYw0DSviXwIj4h7eOK18n1eYs=;
        b=GfKljv8hcq5q4iUSIdBscKbli1GsXA8bPWzxSM8XrOp4+PrW5u7MJh8Sdg9ZQAlgqr
         hJc1G5rg2e/ac4iQxaB12Dl9eFdGUsobKqbGssrZh8eGUujScmhkqBUxmTQX6/fIsJ2i
         e4RoiZCnv/+U+3cPhJx5eytXoBTgyFvkQWGdkuIBwRxz4/rVIpkd14T0DpoMU/sjvBJM
         lPxcJp2+akI2G9Fv6DDQWZNgzJ1JwWnpm7adJodHrlCxXB7bX3UlJjRBg8yx5cQYOxsx
         1XZOdQSnd/sqjYWzIxJ8sNlIEnkPac6kRdyIZEM895CfgHGZOtNlvpO7/kD/B3JmTG2C
         EeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=D5xZ1wA9YMWNc7m+u2IYw0DSviXwIj4h7eOK18n1eYs=;
        b=T5MC4GbVGUBJN5sPm7iRYSH+79Fv1XrqDlfi5vQCu9NK2586eaKS/r73NqeDB6lR/D
         etAALIIEZXULCga/5gpXYoZP0kUZS/8dnTxRFogJ7hm/cj960/dR1gE7wxC6COtDLbTz
         8mQIiThHuX+NU8PpD0w90l3Z1QSiPzBkxEXnkno7fqUW0Cpih1tfLzTAExhdI3NA4cPc
         4n7paxc6TULQ2m65GNILsfTshCEev66JT6hWXk+JxYOEiIFGLOcwigIZRpGtXop+fdVt
         L9q3g3wRBuucWErw7AzoLvlGMoOIosS6RAZ1dEGlQAlwTMX4Iip5F5uEXAtfS3ZDINXn
         tbUA==
X-Gm-Message-State: ACgBeo3S36UbVSIwX7KTtJFVnwTEAC3JRcEiToxY8Fp3GMuhrLmaeGb2
        GUivyy6SoDK+vPutCOhlo9Qa21v7Q1wMn3PS
X-Google-Smtp-Source: AA6agR5EEBqUEt9CW24CTZjGK6neQ+jVB5lxgXICf87zrn/b6N86Xtlpc9Tk97/T3D9NpCzV2fiEbw==
X-Received: by 2002:a62:be09:0:b0:52d:1c83:dfc with SMTP id l9-20020a62be09000000b0052d1c830dfcmr8271227pff.63.1659326874117;
        Sun, 31 Jul 2022 21:07:54 -0700 (PDT)
Received: from sebin-inspiron.bbrouter ([103.165.167.183])
        by smtp.gmail.com with ESMTPSA id p1-20020a654901000000b0041ab5647a0dsm6561698pgs.41.2022.07.31.21.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 21:07:53 -0700 (PDT)
From:   Sebin Sebastian <mailmesebin00@gmail.com>
Cc:     mailmesebin00@gmail.com, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] net: marvell: prestera: remove reduntant code
Date:   Mon,  1 Aug 2022 09:37:31 +0530
Message-Id: <20220801040731.34741-1-mailmesebin00@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the coverity warning 'EVALUATION_ORDER' violation. port is written
twice with the same value.

Fixes: Coverity CID 1519056 (Incorrect expression)
Signed-off-by: Sebin Sebastian <mailmesebin00@gmail.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index c267ca1ccdba..0df904455d76 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -290,7 +290,7 @@ static int prestera_pcs_config(struct phylink_pcs *pcs,
 			       const unsigned long *advertising,
 			       bool permit_pause_to_mac)
 {
-	struct prestera_port *port = port = prestera_pcs_to_port(pcs);
+	struct prestera_port *port = prestera_pcs_to_port(pcs);
 	struct prestera_port_mac_config cfg_mac;
 	int err;
 
-- 
2.34.1

