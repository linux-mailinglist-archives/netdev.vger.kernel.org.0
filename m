Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768B2481DC3
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 16:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbhL3PjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 10:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbhL3PjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 10:39:03 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF55CC061574;
        Thu, 30 Dec 2021 07:39:02 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id e5so15438550wmq.1;
        Thu, 30 Dec 2021 07:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I9AZkgxt3oFSjtraDfx1nRfiDkrhrG6Pm0tqqpcNvhc=;
        b=bqflPPc6wCUWpZKMBhJUPA2bKbVNizdp9h9CqGwu1nvA9ojekEPyDZSSjipxZagjKW
         p8tBUpKebeCpx2sr/TH9TFEllj2Urz4QcUSrbtptbXu/FucCajlXEZZDeXnFXiu+CuhU
         riz6tBfZ8qCq87gTQPmmslOujbVrwAwM7p+lf75XVmb0RAAZeCsMElvvUspAW23pQB28
         vE3iiKqls5JrNK0ZHxgEHXRtKW/GW2pMdH9O0utp6stUWlOBR59ffP8f9r0jYRc4PQsv
         qu2ysjxnGCIRL6G25bLzpBR9yA7ZvZmJT0VED+fSu6DgAP2AsXyhSVnPhmEFZX+opzgH
         351A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I9AZkgxt3oFSjtraDfx1nRfiDkrhrG6Pm0tqqpcNvhc=;
        b=WbxJEpqP+ymVnIjP+nKkS/n3HXJrw3+Vm18irG4st0T4f05OdTF/Ieww7HdH0waFLo
         igpAy9ARpjbaG8HN2yL1KRLUL9WqBqZE1KKBLfuogDdP5rfkBVAEWds2WUrRPYehW4iM
         mSsPuuhNjsqrLshVh3Wb94h5hB6Ou4RfDPzU6gah7E6ZfRx4OCcpCScvzcUCYujIBd5Y
         uJwy9CVR5LvCUEIGkw3KjUylTpiMC091S35HBUcA8TRndHrb+K7T6t1iWEhtbyWkjBoy
         rWnO7UGgrJj2J+xaSxeGbh7ie3ygpyoP1GQE6HyyHrozDBikQ+M/pUB/uU5XgekwZix6
         9iwg==
X-Gm-Message-State: AOAM5306409FXcxIp58TlPZ587hXmS/oSjOPUcbFWZLTTpxFi7NOkh9O
        ENgcxZJHtpcq8HpJbmCVAhW01ljKuO6M4IJm
X-Google-Smtp-Source: ABdhPJwqcNkIbynb98xsLnxKmoiJ0xLF5vj/higGzJ5TgPDJZWn7rWwXX/VzeccMBY/5BOugHCIh/w==
X-Received: by 2002:a05:600c:4e11:: with SMTP id b17mr26171361wmq.66.1640878741390;
        Thu, 30 Dec 2021 07:39:01 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id h19sm23297518wmm.13.2021.12.30.07.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 07:39:01 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/smc: remove redundant re-assignment of pointer link
Date:   Thu, 30 Dec 2021 15:39:00 +0000
Message-Id: <20211230153900.274049-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pointer link is being re-assigned the same value that it was
initialized with in the previous declaration statement. The
re-assignment is redundant and can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/smc/smc_clc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 8409ab71a5e4..6be95a2a7b25 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -1021,7 +1021,6 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		struct smc_link *link = conn->lnk;
 
 		/* SMC-R specific settings */
-		link = conn->lnk;
 		memcpy(clc->hdr.eyecatcher, SMC_EYECATCHER,
 		       sizeof(SMC_EYECATCHER));
 		clc->hdr.typev1 = SMC_TYPE_R;
-- 
2.33.1

