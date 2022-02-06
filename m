Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFAA4AB019
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 16:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239481AbiBFPDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 10:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiBFPDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 10:03:05 -0500
X-Greylist: delayed 303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 07:03:04 PST
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A494FC043184
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 07:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644159783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rKATFCi7H9n+MAZn8bO3eBo0n7dtdQd0f24aSeVzaI0=;
        b=ABXLnVMrajyEER8fv6zZnyk41IwF3vbz5n0sbwzi1pp9qhy0TXV4heeJ8O+KM2oL5bV7uw
        2Gi0kOSj9RnMIXsPhuK3zlLBPigIABbgf0bpzQ1ZBSEtcUQQt9jtMk/nEV7D5ZtdX/qTLM
        4LOcAx60sIunIYXsj8H24yuqsMiHcy4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-jhtgN3CUPne8RWcl31KF8A-1; Sun, 06 Feb 2022 09:56:07 -0500
X-MC-Unique: jhtgN3CUPne8RWcl31KF8A-1
Received: by mail-qt1-f200.google.com with SMTP id e28-20020ac8415c000000b002c5e43ca6b7so9095661qtm.9
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 06:56:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rKATFCi7H9n+MAZn8bO3eBo0n7dtdQd0f24aSeVzaI0=;
        b=s7u+OCwUMaWPS48EEi6Nz52IZkQrdZasihIRCz1Swu23LMxHycBr3WFnuc10rKxuBQ
         crEpchnMHqrGRzdjyI1GyFOS+QHnwvI9McVfCoIwqf+ZrCq5zy4tNs2h6qCHzx1ypNoF
         I7YARYXJ7lBJml4jX18QeopB2UJBXjtj1TZBzFzViflWGy2W6nrE8fM+5/LqKLc4FW5y
         U9MT70bsBHc1MfCzIkj8UTbNonfYXyLkw3AxHWCS1hZl76oYHM9zWHNo9GViWOYSVz8x
         5DkUa+vuItucVwaLWua4Jvetx+zJqG/lyfW7X3H7jXGq8Sd0MwG3PH6/elEL/cYnkrGf
         VGfA==
X-Gm-Message-State: AOAM530N3c6VapgusrIH1Vx1lhjjMa7k56E0/IN3NGsLXREJZ6IY45Sn
        SMkKS9pyYH4alYaP7dnVeoTBf2vNEFmLxPjExEF7FdOp8+jHxFfZbCgXd1Ya7uG7CA7nRiL/46h
        a+pHb8njPvzg8w4Bm
X-Received: by 2002:ad4:5dcf:: with SMTP id m15mr7972315qvh.26.1644159367089;
        Sun, 06 Feb 2022 06:56:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTp2kb9P2giYVhQ0IgQPqQwQCfebA5KvNvWTckY4PCBS0uRH4aJxr/ywtTHS2RVG5PxxdQsw==
X-Received: by 2002:ad4:5dcf:: with SMTP id m15mr7972305qvh.26.1644159366953;
        Sun, 06 Feb 2022 06:56:06 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id q12sm4597635qtx.51.2022.02.06.06.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 06:56:06 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, paskripkin@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] caif: cleanup double word in comment
Date:   Sun,  6 Feb 2022 06:55:21 -0800
Message-Id: <20220206145521.2011008-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Replace the second 'so' with 'free'.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/caif/caif_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index 440139706130a..52dd0b6835bc8 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -268,7 +268,7 @@ static int receive(struct sk_buff *skb, struct net_device *dev,
 
 	err = caifd->layer.up->receive(caifd->layer.up, pkt);
 
-	/* For -EILSEQ the packet is not freed so so it now */
+	/* For -EILSEQ the packet is not freed so free it now */
 	if (err == -EILSEQ)
 		cfpkt_destroy(pkt);
 
-- 
2.26.3

