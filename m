Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C54516029
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 21:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238997AbiD3Tui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 15:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbiD3Tuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 15:50:37 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9252427FD6
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 12:47:11 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id g6so21244567ejw.1
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 12:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1U8XwMYV+pAx9BodI858uv/uWmiMqcenYxEexOaBL4=;
        b=CgIB206puTlPCqUajW01jlAB1fWkG1ilGwEQmqvctQbMv+92gGW8Zq8n2DjGiCXQq1
         HztIUgxYmzV3sh5ZECdAfenyKM3RD/8EWbMc3W7zW5ZbZeT5pu7MF8ePvh3zJ5hbTJus
         XD6Qofb9k/X8VqTXF+R1UH4iC15niG7mnkfhEPXXtfzvY249eUyXc0IPWshVaW4k9ybP
         T/yvcdXWJcXjkeXzafVJiH+5iS2hVH8bBv3oDMkhpipedc/nu5lYS+BoSf9Abga3Jeem
         CIrVkahgiXyJGQYsI5/4AJMr/hk+pTvcFU2OoUkQtSV4UsologV87gk9Raa0ZeEwFsUF
         DYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1U8XwMYV+pAx9BodI858uv/uWmiMqcenYxEexOaBL4=;
        b=5ucEaPK2D31M/oTL8viR5Veb+4Pzm/I78unFgNuqNTJDyOJv/3uSIsGD79rP4lWzYy
         WKMhX65j6Qkw+2htjIjwz5xcJF6nrEwT3Upie0WJeAL215JCYb6lSh1lX/Rz7eSHe1et
         jjgCVzSSgY09vOCZ76H34ysuCOBB5Wk2TRpDjlSCXyYR8C/uJ3dXclAFTvJCM3OY2Z2j
         GFq0qF/Q11vr4GNG7i10LTQIREwcKZJ1I4d2RtCeUkBP+IsEuyQmgkWZi+/lnLySR8as
         2Tp03lf7757yBzgwY/f07oZgImK0+9qsAFPFdo3DnpOUrY2uaEoc5pkplGH9ait5pyEo
         I2lA==
X-Gm-Message-State: AOAM530gfMqb3gvshYalyRXb3nES+wADuc0QfA533NbdyBUBmEht4tfB
        mgsegmdVGDBh1K5jx50QRqYveIauTTI=
X-Google-Smtp-Source: ABdhPJwL9+5zE8RY9dYMRCkIgNULyOUNbYvJqLJaw9pPI61SFmh6W/Asu7gpFnrdj/2p9+3x5KTGnw==
X-Received: by 2002:a17:907:6ea5:b0:6ef:f593:5cce with SMTP id sh37-20020a1709076ea500b006eff5935ccemr4826437ejc.182.1651348030138;
        Sat, 30 Apr 2022 12:47:10 -0700 (PDT)
Received: from nlaptop.localdomain (178-117-137-225.access.telenet.be. [178.117.137.225])
        by smtp.gmail.com with ESMTPSA id hx18-20020a170906847200b006f3ef214e4dsm1924050ejc.179.2022.04.30.12.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 12:47:09 -0700 (PDT)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Harman Kalra <hkalra@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH net] octeontx2-af: debugfs: fix error return of allocations
Date:   Sat, 30 Apr 2022 21:46:56 +0200
Message-Id: <20220430194656.44357-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
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

Current memory failure code in the debugfs returns -ENOSPC. This is
normally used for indicating that there is no space left on the
device and is not applicable for memory allocation failures.
Replace this with -ENOMEM.

Fixes: 0daa55d033b0 ("octeontx2-af: cn10k: debugfs for dumping LMTST map table")
Fixes: 23205e6d06d4 ("octeontx2-af: Dump current resource provisioning status")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---

I found this issue using static analysis to find inconsistent error
handling regarding kernel APIs. Found on v5.17.5.
As I do not have the necessary hardware, I only managed to compile test
this on x86_64. I wasn't too sure if it belongs in -net-next or -net,
because while it could theoretically affect users and is a bug in
principle, it probably doesn't do much harm.

 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index d1eddb769a41..2ad73b180276 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -248,7 +248,7 @@ static ssize_t rvu_dbg_lmtst_map_table_display(struct file *filp,
 
 	buf = kzalloc(buf_size, GFP_KERNEL);
 	if (!buf)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	tbl_base = rvu_read64(rvu, BLKADDR_APR, APR_AF_LMT_MAP_BASE);
 
@@ -407,7 +407,7 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 
 	buf = kzalloc(buf_size, GFP_KERNEL);
 	if (!buf)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	/* Get the maximum width of a column */
 	lf_str_size = get_max_column_width(rvu);
-- 
2.36.0

