Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8084755B64F
	for <lists+netdev@lfdr.de>; Mon, 27 Jun 2022 06:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiF0Exj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 00:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiF0Exi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 00:53:38 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F262706;
        Sun, 26 Jun 2022 21:53:37 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d5so7092995plo.12;
        Sun, 26 Jun 2022 21:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=RDbyHGYjDokBQdeoYhSc2JkFFRAgTdHRAPgldnlL0S4=;
        b=FHLaGUQwXROdnyRwDj37Ca8eClSuuuR/przUhLT8dSMVIocqg79HUmX4pZlEyf4k3i
         tx8XMNhqMiwI8pzmkUoXMCp7AwUrKRsU3Ubn8YjD0bpR28msTTmMbx8Fg2evaHlCWZma
         OGTg+bAyqjTg+VliswfpA5djq8OvfBI34nCKpGKsEWvO2UhvCb+GuhAPDV0xHO/+kYHq
         TrhMCxYdDmq3Aoawb6hQoEwTVrhzU1GrAftTFsLNhAKiwiwKyB1iDCGSXRVJPKS44GT6
         MdlKxSChSXuy95pvPSf7mt6ziZmERzkJXWqqmo6CD56eYoXqMXKJu17S/6xIUyrhgY/f
         +tuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=RDbyHGYjDokBQdeoYhSc2JkFFRAgTdHRAPgldnlL0S4=;
        b=1/FGg4yf2jqwmCHbdN1c3fw3U4C0B1DXIDOtSgRtipW2AENhB9DeEhBTHKHreLemCr
         NlBX98qDEWSrCF2dos3R6BHx2BqPBJ7a7daejiG0SX4w9s0XQ/95zn8C6AGE4IgrgvLk
         4hMA0fcb12uRSlx9rI8IITwB4ZE8LjlmKqCTptdXFalDp1PuPqJg4ZZDeMUGjyHrYjK2
         vCIIKTvPON1vnJzzW218FewTn4tcwWLXiSmI9X0f3nKlCd66/t++QpuhcvioVcs4TKDQ
         M0nuRztRG3SPd1wpCXN33pQxgJyUTx1VEcFWH2bEMSds7rDtwsmTT7l6AFIb15eDB4Cm
         xOTg==
X-Gm-Message-State: AJIora/m34uNs8FOL+FOvSC9Yyih8cltw+yNqPi4I84HlZ8Qg9xZVXI4
        TtndlewJnWnYyvvEPvhwVyW/o4VishhTnIW/
X-Google-Smtp-Source: AGRyM1twkxnyrHdtAeNElq/Rz/ecdCtRlTLDjGHRMfKicL+6R4BCUy6pBvR3XZ/Y52HZE79+ZbfftA==
X-Received: by 2002:a17:903:2448:b0:16a:37de:89b3 with SMTP id l8-20020a170903244800b0016a37de89b3mr12889465pls.68.1656305616817;
        Sun, 26 Jun 2022 21:53:36 -0700 (PDT)
Received: from sug (cpe-23-241-9-246.socal.res.rr.com. [23.241.9.246])
        by smtp.gmail.com with ESMTPSA id u27-20020a62d45b000000b0050dc7628148sm6051397pfl.34.2022.06.26.21.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 21:53:36 -0700 (PDT)
Date:   Sun, 26 Jun 2022 21:53:33 -0700
From:   Arun Vijayshankar <arunvijayshankar@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: replace msleep with usleep_range
Message-ID: <Yrk3zeyzSJ0424Aa@sug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qlge_close uses msleep for 1ms, in which case (1 - 20ms) it is preferable
to use usleep_range in non-atomic contexts, as documented in
Documentation/timers/timers-howto.rst. A range of 1 - 1.05ms is
specified here, in case the device takes slightly longer than 1ms to recover from
reset.

Signed-off-by: Arun Vijayshankar <arunvijayshankar@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 689a87d58f27..3cc4f1902c80 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3886,7 +3886,7 @@ static int qlge_close(struct net_device *ndev)
 	 * (Rarely happens, but possible.)
 	 */
 	while (!test_bit(QL_ADAPTER_UP, &qdev->flags))
-		msleep(1);
+		usleep_range(1000, 1050);
 
 	/* Make sure refill_work doesn't re-enable napi */
 	for (i = 0; i < qdev->rss_ring_count; i++)
-- 
2.34.1

