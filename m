Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1375E60B837
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiJXTms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiJXTlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:41:52 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF32265517;
        Mon, 24 Oct 2022 11:11:32 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n14so2789261wmq.3;
        Mon, 24 Oct 2022 11:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yvPcFlw6lM+Z4kH9nDAFT0Arkjdhr1idqjBqC9Ky3Kw=;
        b=MUZ7iaB3iWtFgeLi5pIjcRc7HXnLWLrBmoA0lvgXcBrQWKK8HBx9ce0VYt9pVrW27H
         09m1rykXg6YUDCQwsmeInLz/OeIdpMJ+cSMG6vx8saDiSbm+rMicQGLKcSSSP3GCrz7O
         8YBZCGfInLxHW5y88EDyPCNxi+Bm9L1RcTLJvNXAKwVKmNQscfxX2sJecaBuHvWsiABK
         Y4XmoJvethqru/stSjFpKykkzAqSBjIOCqnPpYU78TA+j8/zjolYKUMVeh1wXHpU5RNM
         Gxno7Gtm5sUB24yl8zYkEhayBbSG/IgLsjIF4w3XccG4VnXx6FLNeBQAc4Sk3Ty+hNzv
         om5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yvPcFlw6lM+Z4kH9nDAFT0Arkjdhr1idqjBqC9Ky3Kw=;
        b=UzKpPOMgekmk1+Qoq1PQPEz9Tw2Q8aWpXa9tr1IE5v6UAvxZln6fvGtc61U9dB+UiM
         vytr/k959Ktb7UpIwWorYEmVoRFmGtuKT4ke8R0A6goMbuYbrvg8/oGLSMYEPMXQ7qXE
         LtcPB3tEQVOfRHL4QV6yEbmHV8r4e4OPqSDACgff7MozEzuAQW6BuJp/7TTqIO2Be5xD
         gUIHWEGC/aUYE5HSvKB8HpBn2UAhbuMinEuCYvOah9xhK7aHM04xUAIwyBpdUiDY+Sgo
         62advRbcWpLaGLw1icEB6F9KBI3l7JFmeem4l6HGRu7Ca/g1cW5y/GM8qriQmh4cqPYk
         oxaQ==
X-Gm-Message-State: ACrzQf2OTRhDVmExEjqz0ncAxKvqUOEU2yGsa2cIE1RGAVT+OZVGqhbz
        JubRZBusx1j0HLQZ5EIQi/fVYgS0Q0rVm7RH
X-Google-Smtp-Source: AMsMyM5rIEPKlhEcUBOaCv6On9SyEcsFNO7IYk+unK8cRtGodPkeczvInbtItNUIdeGmjuIUXCmz+w==
X-Received: by 2002:a7b:c005:0:b0:3c3:6b2a:33bf with SMTP id c5-20020a7bc005000000b003c36b2a33bfmr22193340wmb.167.1666619448014;
        Mon, 24 Oct 2022 06:50:48 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id bj19-20020a0560001e1300b002238ea5750csm11529340wrb.72.2022.10.24.06.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 06:50:47 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/rds: remove variable total_copied
Date:   Mon, 24 Oct 2022 14:50:46 +0100
Message-Id: <20221024135046.2159523-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable total_copied is just being incremented and it's never used
anywhere else. The variable and the increment are redundant so
remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/rds/message.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 44dbc612ef54..b47e4f0a1639 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -366,7 +366,6 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 	struct scatterlist *sg;
 	int ret = 0;
 	int length = iov_iter_count(from);
-	int total_copied = 0;
 	struct rds_msg_zcopy_info *info;
 
 	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
@@ -404,7 +403,6 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 			ret = -EFAULT;
 			goto err;
 		}
-		total_copied += copied;
 		length -= copied;
 		sg_set_page(sg, pages, copied, start);
 		rm->data.op_nents++;
-- 
2.37.3

