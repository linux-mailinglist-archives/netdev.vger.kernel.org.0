Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711A05B6342
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 00:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiILWDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 18:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiILWDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 18:03:42 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148FA4DB53;
        Mon, 12 Sep 2022 15:03:41 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t14so17721507wrx.8;
        Mon, 12 Sep 2022 15:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date;
        bh=IzA/mm5gy1Mcgjalg/+lgwNTxZNDUkDpprQYB/NbERI=;
        b=iJnfuB4v9EIvf7JiXKHcycXwcQMkMxk2w/bdqx6VmfMuob9nokiY2rAxBRI7GhUqfU
         8WvfeeqvIYXLeP5bcngSvJSc+HpGM6Fb+/0MBpbjCmghrASoo9SrnYW9zmZ4y67pKi3E
         iSx4Ieus64sowJmdYCR//SHdyAiU/xhNijxLX88jEaL8+N+NR2ge4wl4NBa1wxI1CfQ1
         JCxI+t8cnK67EjFalDp0hEkEAQFT3TTx2hD7IJks9jlRasondo+WPLOu/pnUUL3BJ8O2
         R2S/nTc8wNBcgdFkdwwLRc4v1CPyKjBLMMpEHK7wfaDl0USnKjt04mwILMuzXIz1ymYn
         iotQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=IzA/mm5gy1Mcgjalg/+lgwNTxZNDUkDpprQYB/NbERI=;
        b=2q0CrDfmlZ2al8tO3ltYzMPNapMmuoT7G71Xy3stFT1rz+qmWNQMidl3wz5aCBCOkY
         FqjhiOHpdZK7ftRFhaVqFJuawvPMjPb6jPzg/vUqT4+WtePoepWShJZ/dt4LEs9Q1sqY
         q/7BUmSnFl5iT+cQTRm8HqIQ0IuNUge5j96Ow4CTn7gySdoOeuCan2Et55w6OMPPnmU8
         l8LIIyXdkW+Vk9ztdIOtHsQah1NJwnHSkrQ/spp4KvWpovDkyO1JKC4gDtyeqRDRFGEI
         gNnaWxaSM9uwHNJxUJHywek4L1Pv7zsNdoh83acYDw/cpDlEE/Z6FawDC4VyOY7u3aU9
         tb2g==
X-Gm-Message-State: ACgBeo1GobP82jbIiUHM90s/X+faaxYBduv+umV0M5SNDhHtrWun5fHY
        rnXUVKfWmEMv9YtgeZO6eoR/GWQO2g==
X-Google-Smtp-Source: AA6agR7kzSEf6LBNv9MOkOQq26h6YcedwATS6MawQ3BiYe3K0gBQrXAc+EaL/YJwCC3yBRaIFGyP4A==
X-Received: by 2002:a5d:6543:0:b0:22a:3877:7bc9 with SMTP id z3-20020a5d6543000000b0022a38777bc9mr10845900wrv.142.1663020219447;
        Mon, 12 Sep 2022 15:03:39 -0700 (PDT)
Received: from playground (host-92-29-143-165.as13285.net. [92.29.143.165])
        by smtp.gmail.com with ESMTPSA id bk12-20020a0560001d8c00b0022762b0e2a2sm8762004wrb.6.2022.09.12.15.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 15:03:39 -0700 (PDT)
Date:   Mon, 12 Sep 2022 23:03:27 +0100
From:   Jules Irenge <jbi.octave@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] octeon_ep: Remove useless casting value returned by vzalloc
 to structure
Message-ID: <Yx+sr9o0uylXVcOl@playground>
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

coccinelle reports a warning

WARNING: casting value returned by memory allocation
function to (struct octep_rx_buffer *) is useless.

To fix this the useless cast is removed.

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
index d9ae0937d17a..392d9b0da0d7 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -158,8 +158,7 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
 		goto desc_dma_alloc_err;
 	}
 
-	oq->buff_info = (struct octep_rx_buffer *)
-			vzalloc(oq->max_count * OCTEP_OQ_RECVBUF_SIZE);
+	oq->buff_info = vzalloc(oq->max_count * OCTEP_OQ_RECVBUF_SIZE);
 	if (unlikely(!oq->buff_info)) {
 		dev_err(&oct->pdev->dev,
 			"Failed to allocate buffer info for OQ-%d\n", q_no);
-- 
2.35.1

