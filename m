Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D2D4C44F4
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240754AbiBYMxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240751AbiBYMxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:53:15 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2A616AA43;
        Fri, 25 Feb 2022 04:52:43 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o62-20020a1ca541000000b00380e3cc26b7so1666183wme.0;
        Fri, 25 Feb 2022 04:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=oWC0YbmclU1/rupUD32FXFHq6eElAXM2xq7gQcBXak0=;
        b=ZBbh+Q/xIlciESMD0GrmlN7WswAz2h4ORJHQgFeNhyFVSRDu7C0zlV+k4Ah8oeGGzZ
         bIdvFnHnMDAg7ujH6gc6zb+jFMGR28blPonpfYee/GJu0jQqN+dntWTobfMndQNXi7Pr
         b0XEc9sFSz41izSWUO7Z2NISBIB+MKBoh9BPSb/Er8iTbrVstwbnpzsRTk5ayLbM2lQP
         aFaEmRulRdGTynm4NEo6+bzOtx2h9zz1maMOimDON6MVzWaJPl0P0QB2S+kuCfnDnhxC
         XSxTTC1N+1dCgw8ZYVVNkDvF4EqoAu1v8QbZwKBq9aUtR7seHdmPFowFi6W3E0liL/jC
         HUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oWC0YbmclU1/rupUD32FXFHq6eElAXM2xq7gQcBXak0=;
        b=tQSaT88f74etuhwj+/qDLtnLJi8NB587S+xPDnwOXoks86mco5CYr2QYOUDJymj8ca
         W1r2Nd7oHvWjvowoXRgKuENw4z/ZiPuIvBWX9rMZRrUyGQzgVEwVbOSyiYPTCjFvDjBn
         KPwsNr7SVsE3rjrY1DJBHQSKLLDcH4K5524JuzwbGLq7T0Xl+0sjgueAmwI6/M3RftXT
         mPwFb5QPmUhKydJt64dN24/ZKiRe2wO0hIzWvYqTB3yAs0GdZwlBL9eG1a77V+oYCxrp
         gDsvqT/fgx6VjQCfGia4Scq8JuJovlfKxwEFqBKFVRILQhjk88IzbcXN+1NNWqBFf2Vn
         DwXw==
X-Gm-Message-State: AOAM533ztiZNbGiTylk01t5bI2E6bwiONdI/fuetcE4QLiI0Hpck/3E2
        tc5uLU3NxPKvuhaz4BbxsdfqqTVI9g6wuQ==
X-Google-Smtp-Source: ABdhPJxC56iBIkZNIpZl+UpjBQOMRnaxmMhkcz7Atp4KHK8CYiIsSv/nPy1fjD4h4B236iksMyYC3Q==
X-Received: by 2002:a05:600c:1c8d:b0:37b:fb3b:adf3 with SMTP id k13-20020a05600c1c8d00b0037bfb3badf3mr2642601wms.64.1645793561858;
        Fri, 25 Feb 2022 04:52:41 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.58])
        by smtp.gmail.com with ESMTPSA id x1-20020a05600c420100b003811fb95734sm3167713wmh.37.2022.02.25.04.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 04:52:41 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] atm: firestream: check the return value of ioremap() in fs_init()
Date:   Fri, 25 Feb 2022 04:52:30 -0800
Message-Id: <20220225125230.26707-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function ioremap() in fs_init() can fail, so its return value should
be checked.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/atm/firestream.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 3bc3c314a467..4f67404fe64c 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1676,6 +1676,8 @@ static int fs_init(struct fs_dev *dev)
 	dev->hw_base = pci_resource_start(pci_dev, 0);
 
 	dev->base = ioremap(dev->hw_base, 0x1000);
+	if (!dev->base)
+		return 1;
 
 	reset_chip (dev);
   
-- 
2.17.1

