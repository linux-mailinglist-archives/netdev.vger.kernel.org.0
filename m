Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB0055FB2C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiF2I6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiF2I6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:58:49 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404781C91B;
        Wed, 29 Jun 2022 01:58:43 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id fd6so21218664edb.5;
        Wed, 29 Jun 2022 01:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r++121sbLgXWyC87t6HhBYGjFC1OZo7m/Al81TbSLAc=;
        b=QRckV6V4u2oiBdEL0UBUoDQqliBh7zDWCo7k1wV03x1E23P11wbDeU1C05lwfZlo7U
         LS+eADyHaw9InWhCnF/7orpv+hOmwZAOR6FUSY7KN9zvf8S+nx0qNzodpfbGArqJzex6
         BmGLDdZrXozYghL4CSdujGNIKFF5x3xfGQarw24QAtndrBGt/4CyrPusRrD5cGMnV82R
         Ctr1zok0+gHGhnUpNKHnXamxIHOcNfsMC758001icFlfMLfMm+jhN2k4Kyx2QCybyWWG
         r2bc3KP926tzQLNJZS3tETF5L4vlpvYabcqn2Ez5OkrjqnoV4tJwPSodC5ynDlKv3ERf
         l45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r++121sbLgXWyC87t6HhBYGjFC1OZo7m/Al81TbSLAc=;
        b=7Po6aogJcZlnLkXxpDwkC2Gd1TEKZpJCDSfHwEydGCzDkXlt6+5s3xmvjjMtAFHqbl
         YBACdYJpCBecHIAF5QBuvCJDokR2t0V1XUycFoaoSdCvRWOaUtfk0NZT9pTnOONnd2BL
         juqvLNaBuQSkaP0XeTJtqFLWkWZahjMkejhD3cVOtXitsRA/Q8gOpDj66bt2YgsFwiOt
         96LkbsTgaDIpT6ebAwY4lRynWrYiE2HMY2sSDmi5W5c9Idw2O36peOQICR0tCfjU6qbm
         W73GT+CWFxVtIdfcHKpvUuzeKlIaIUzrWNSGX89EAa1MQiD/ePSbcjAebin/ie4beasr
         LcDg==
X-Gm-Message-State: AJIora8r+AOLdeIU7h928vVIgo9h7QwDnBZM/DHBzld4+lTLedejsx2T
        bVQfgr27C2Sf5NNJ+oiG5hI=
X-Google-Smtp-Source: AGRyM1tAyTjbfqt55MKCcHD0WymqazhAWk4ybuv3YQ8j6WxGsH0iTFjyiTpmDaLtRbAiv1DK0y0lbQ==
X-Received: by 2002:a05:6402:4387:b0:435:94c6:716d with SMTP id o7-20020a056402438700b0043594c6716dmr2837654edc.298.1656493121725;
        Wed, 29 Jun 2022 01:58:41 -0700 (PDT)
Received: from localhost.localdomain (host-87-6-98-182.retail.telecomitalia.it. [87.6.98.182])
        by smtp.gmail.com with ESMTPSA id a18-20020a170906671200b00718e4e64b7bsm7489740ejp.79.2022.06.29.01.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 01:58:39 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
Date:   Wed, 29 Jun 2022 10:58:36 +0200
Message-Id: <20220629085836.18042-1-fmdefrancesco@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

The use of kmap() is being deprecated in favor of kmap_local_page().

With kmap_local_page(), the mapping is per thread, CPU local and not
globally visible. Furthermore, the mapping can be acquired from any context
(including interrupts).

Therefore, use kmap_local_page() in ixgbe_check_lbtest_frame() because
this mapping is per thread, CPU local, and not globally visible.

Suggested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 628d0eb0599f..e64d40482bfd 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1966,14 +1966,14 @@ static bool ixgbe_check_lbtest_frame(struct ixgbe_rx_buffer *rx_buffer,
 
 	frame_size >>= 1;
 
-	data = kmap(rx_buffer->page) + rx_buffer->page_offset;
+	data = kmap_local_page(rx_buffer->page) + rx_buffer->page_offset;
 
 	if (data[3] != 0xFF ||
 	    data[frame_size + 10] != 0xBE ||
 	    data[frame_size + 12] != 0xAF)
 		match = false;
 
-	kunmap(rx_buffer->page);
+	kunmap_local(data);
 
 	return match;
 }
-- 
2.36.1

