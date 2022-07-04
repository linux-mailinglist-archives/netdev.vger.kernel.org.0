Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8BCA56582A
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 16:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbiGDOBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 10:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGDOBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 10:01:37 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E297AB1D7;
        Mon,  4 Jul 2022 07:01:36 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v14so13641190wra.5;
        Mon, 04 Jul 2022 07:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0RwqG+scDxa5sBRqSdCikrVrH/DlHuQpNG6BogojNcw=;
        b=odnnTUp/LoUmKOUyIJo7vEDZ9yAuctYKOVpNuGmulrP9ucSUIzulweZaGGyx5FAYjS
         pKtpKxi4+NqK+MuIKSu9ZSW3m5/J4CZD6x12SiuRNc6W268Bu7bBLJedQSHalLOH3Dni
         /gb6Juv9w3rHsvJs7EYOlL7HBPp+qP8HHhDiIWrqC70++0qmzhrOY0dZd8xJqIFFTi1d
         GkOERF7j+9cILgoS2NHfS5QT0eU6lR/yhdvYRtMYRy9tXXaOcBsHeHsQacSPAJubQ+Jv
         Z0JebS6MOLja+VT6KCC3MFDQkpbg2heGJIdBA1Pl7CUgL5ungJ1Q1Ed3BEzeIHHWe9AU
         NvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0RwqG+scDxa5sBRqSdCikrVrH/DlHuQpNG6BogojNcw=;
        b=ySMs09g5awH0MPHsCyP36pwzglULLh4DOOujaX7Jl88UwUmtAceI7ocrP1oJKv6utN
         DgUyUEHCFWurgIcq9xqudsafXB4CeXLR5jVPvW79nd8qV6fAqDNWX0o+mHs2fK2zJLoL
         A6/wFyuM+ksw4A8MBQrOKSsSts090GXoBoegEZPZKMMIj8zwrZj9G8G4a53UEMENwtCw
         ryPOUabJO8U5A3FCM7UtgOVCMxZqvVnm3LcyYplOyw1ik3iCvISk/rkHtr6o8ytz8GE1
         5QJERkkwZQ08M/c0ApcYvasj4+SOLsno2Dg+XnLiDJ0kiMloRTsCyooMlgz+ZQmmHkcG
         AmEA==
X-Gm-Message-State: AJIora+bYKnOt5tbF8QiqK7ppqYuyNlzb2ih87uLLYi48ZsxMGUqW9eZ
        KD7K6VFkta8b9mqQEywoPYU=
X-Google-Smtp-Source: AGRyM1smRSj3Ife5KLTAkAievRyKaIgwIO/zIdO2R0orYgNnwofMXGR9OfYzMd2s/lnJBQ5AknUp2w==
X-Received: by 2002:a05:6000:1887:b0:21d:33c1:efd6 with SMTP id a7-20020a056000188700b0021d33c1efd6mr23299338wri.134.1656943295318;
        Mon, 04 Jul 2022 07:01:35 -0700 (PDT)
Received: from localhost.localdomain (host-79-53-109-127.retail.telecomitalia.it. [79.53.109.127])
        by smtp.gmail.com with ESMTPSA id f7-20020a0560001b0700b0021d68e1fd42sm3963147wrz.89.2022.07.04.07.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 07:01:33 -0700 (PDT)
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
        Ira Weiny <ira.weiny@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH] ixgbe: Don't call kmap() on page allocated with GFP_ATOMIC
Date:   Mon,  4 Jul 2022 16:01:29 +0200
Message-Id: <20220704140129.6463-1-fmdefrancesco@gmail.com>
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

Pages allocated with GFP_ATOMIC cannot come from Highmem. This is why
there is no need to call kmap() on them.

Therefore, don't call kmap() on rx_buffer->page() and instead use a
plain page_address() to get the kernel address.

Suggested-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 628d0eb0599f..71196fd92f81 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1966,15 +1966,13 @@ static bool ixgbe_check_lbtest_frame(struct ixgbe_rx_buffer *rx_buffer,
 
 	frame_size >>= 1;
 
-	data = kmap(rx_buffer->page) + rx_buffer->page_offset;
+	data = page_address(rx_buffer->page) + rx_buffer->page_offset;
 
 	if (data[3] != 0xFF ||
 	    data[frame_size + 10] != 0xBE ||
 	    data[frame_size + 12] != 0xAF)
 		match = false;
 
-	kunmap(rx_buffer->page);
-
 	return match;
 }
 
-- 
2.36.1

