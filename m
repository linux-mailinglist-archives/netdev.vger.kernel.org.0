Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F63462F8DF
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbiKRPIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbiKRPIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:08:00 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754FC7664;
        Fri, 18 Nov 2022 07:07:59 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id r126-20020a1c4484000000b003cffd336e24so3031726wma.4;
        Fri, 18 Nov 2022 07:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f3qmb/xCdppcLHvH7Noas5o6A2YaR3J5UTNpRohIPTQ=;
        b=BkN8dmCNc8eLVRI4CRW5aBpLiZG4RsQkboGFyxjY1gxkZR0tbKpnUZ5wZDk8+PFSW3
         qKnhIwZ+97Z2xoOkM7+x+pkKdLz4dh/QYjk47FwPXEY86Ga4Ddsw3MuNk42cxn2FoYaf
         pwKnDTD8tDxrQptg8yEKrRD5UQt7FTdgqG+4nkyrlCTOLVs+Z3q7W3uInB7xIXsWgKEZ
         pAQX/byy7K6Vxbu0Nt1iwoKrds046oo/QwRONouYhBD/pWlRSttD3S5YjIjHsHZro56r
         NcAutVcdtK8yTBFJFzcDxTSg7wDCaWqnph1tkuVzojstL0MdKmR9TxjvGUyqKzz1YiMx
         yMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f3qmb/xCdppcLHvH7Noas5o6A2YaR3J5UTNpRohIPTQ=;
        b=r7QzMbNXZkUR61E44rk9X5ASR2oBtH+U8zZ1eeTLHF8i3vjuVETtKnrOoK8KcjF1Yi
         7E+nDZoIudsoqEyDPUe1ZavB1ISg9yK4kGXOQlZ0XhelF1tIt61x03BjsmGYofl2NEMH
         L6akLXNGv8nUyMmLRAaQoLZv0WE5Q97jXrYmpqrlUb1xd0xfkrJEd4kmqjU+xnFqcgYJ
         sWJMzlsATsaek16IQgY05n2Wvl+Qet8eGM+So01egLSrlSRB7lfvdN11f9d1HiIrBs6w
         vhlZq1DvRYJJh5r+f1togUBzJhvB/sy0ArVOwUVL3BOGJUltzcNGZbc/BlcQHScJ+rz3
         e5qw==
X-Gm-Message-State: ANoB5pkzs3fgBp+mF5HIQaOZyzlwQ2UoVjfldaegdtNXuWBON3hjDFPn
        t3WEj2dvpsT5XbHTowrDZSM=
X-Google-Smtp-Source: AA0mqf57YYjgvrafNnpaRJGZC4yua85S1t01+JnKaeeYZkvEDeXKHfZlf4ewP6oU/4gG9y1pJHujmQ==
X-Received: by 2002:a7b:c84a:0:b0:3cf:5d41:b74b with SMTP id c10-20020a7bc84a000000b003cf5d41b74bmr8429440wml.184.1668784078075;
        Fri, 18 Nov 2022 07:07:58 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id l32-20020a05600c1d2000b003cfbbd54178sm15130201wms.2.2022.11.18.07.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 07:07:57 -0800 (PST)
Date:   Fri, 18 Nov 2022 18:07:54 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Cc:     Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vamsi Attunuru <vattunuru@marvell.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] octeontx2-af: cn10k: mcs: Fix copy and paste bug in
 mcs_bbe_intr_handler()
Message-ID: <Y3efyh1HjbToppbN@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code accidentally uses the RX macro twice instead of the RX and TX.

Fixes: 6c635f78c474 ("octeontx2-af: cn10k: mcs: Handle MCS block interrupts")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Applies to net.

 drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index 4a343f853b28..c0bedf402da9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -951,7 +951,7 @@ static void mcs_bbe_intr_handler(struct mcs *mcs, u64 intr, enum mcs_direction d
 		else
 			event.intr_mask = (dir == MCS_RX) ?
 					  MCS_BBE_RX_PLFIFO_OVERFLOW_INT :
-					  MCS_BBE_RX_PLFIFO_OVERFLOW_INT;
+					  MCS_BBE_TX_PLFIFO_OVERFLOW_INT;
 
 		/* Notify the lmac_id info which ran into BBE fatal error */
 		event.lmac_id = i & 0x3ULL;
-- 
2.35.1

