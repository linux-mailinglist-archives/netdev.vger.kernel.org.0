Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3062F38CE61
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 21:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbhEUTvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 15:51:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233470AbhEUTvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 15:51:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621626626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GPfnJGzP4OqGD0+wu1euBp+ahcfCCZpRemrfs0fPKWg=;
        b=P9gm/jvbiXwqPVL0AGUTkMgHmzzaV/rdDm04AJUAnxWsCvhRoxzJwxaR/M0gQYKpLNqtCE
        4CPsF+x4My8RwRG3oT0lXjItm1kqIoEC1PGrGWhmymOqWuIW20lNMZ39gN4aWR8LLOC/jC
        yu1R0CwOwjpsKN7ulSnYP7CGRLKKN/w=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-hv_22iYXNler2nA8g2fLTA-1; Fri, 21 May 2021 15:50:24 -0400
X-MC-Unique: hv_22iYXNler2nA8g2fLTA-1
Received: by mail-oo1-f70.google.com with SMTP id z6-20020a4ad1a60000b029020e858bcefbso10518517oor.17
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 12:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GPfnJGzP4OqGD0+wu1euBp+ahcfCCZpRemrfs0fPKWg=;
        b=HnDHVimB7y5bqwfy6cuamJ4qUwUrEdn9YEsK23jI75kebrerUiyQz+X9ODCIiT9WQB
         7qiDDtH7KI+HD5enkVxu90crJ28Db0VuQQDwKuaK5RRc6jpUHyOdbdzRG04q9Ci3TiFQ
         AOKvd+TZr5jH2fHFUSpZR3y/kwyyDN8V7fQ/Rsi4dBxPGV36OqawFpFjZO9S/z+9zOMX
         jDAMVs08PMu7/V7KskAvfqsVfhUlZUw1q42jSboJFVe83ufuefDF20ysEgEFoxyXLoOt
         RnYH2Hf935b2zUtwgojgMZjv61Avn/zpxQDT+L5qiLMs2oSRjmJ4BF3AN+je8MBwt0/a
         9yMw==
X-Gm-Message-State: AOAM53331AWoPXUcrHSisCgolvcT4kEXGBiBb+oq3kshFmcySDdewXv+
        IBwtsAHsRjsx4R/m38mNX3PYNyFTYopKKwVZoC5hnLvfc6QTrj556kNToPTNUdnM7UQuaWAiicQ
        jrulbAitU3CRbHsXg
X-Received: by 2002:a9d:69c2:: with SMTP id v2mr9675696oto.186.1621626623968;
        Fri, 21 May 2021 12:50:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrhDz8hYcbq+CC3R6HOECEW0ZHmOtKTJgEQEzXiMKV0b8sWqr7I+euvwLLW/m5M5RWdTM3Rg==
X-Received: by 2002:a9d:69c2:: with SMTP id v2mr9675685oto.186.1621626623820;
        Fri, 21 May 2021 12:50:23 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id w4sm1549740otl.21.2021.05.21.12.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 12:50:23 -0700 (PDT)
From:   trix@redhat.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, jeffrey.t.kirsher@intel.com,
        sasha.neftin@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] igc: change default return of igc_read_phy_reg()
Date:   Fri, 21 May 2021 12:50:19 -0700
Message-Id: <20210521195019.2078661-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Static analysis reports this problem

igc_main.c:4944:20: warning: The left operand of '&'
  is a garbage value
    if (!(phy_data & SR_1000T_REMOTE_RX_STATUS) &&
          ~~~~~~~~ ^

pyy_data is set by the call to igc_read_phy_reg() only if
there is a read_reg() op, else it is unset and a 0 is
returned.  Change the return to -EOPNOTSUPP.

Fixes: 208983f099d9 ("igc: Add watchdog")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index b6d3277c6f520..71100ee7afbee 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -577,7 +577,7 @@ static inline s32 igc_read_phy_reg(struct igc_hw *hw, u32 offset, u16 *data)
 	if (hw->phy.ops.read_reg)
 		return hw->phy.ops.read_reg(hw, offset, data);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 void igc_reinit_locked(struct igc_adapter *);
-- 
2.26.3

