Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12220287871
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731581AbgJHPyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730398AbgJHPyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:04 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71333C061755;
        Thu,  8 Oct 2020 08:54:04 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o25so4675432pgm.0;
        Thu, 08 Oct 2020 08:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RcPVobIBGLdE5Ssa/2D1gELvSd5HcpPZzXr83NOombI=;
        b=doP3v7RA0BL6AZ4CWqRq4lssx5fvxz0ArdbJGOY/HOE2AVHQWyttx/Afmz6HRsCexk
         AzxlNZQ4gi9bjoEQPgd7+jN3L4mVeV4bmy5DFQ8MCIiA2I8ELljG0iUoGL9hvlzeZGd9
         3JFbWNISr7Ayljyvl7AVH/nxr/zZfJ42DGOr8pD9bz4KU2gtwAyla9HsUWYbXJYDiiGu
         GYXogpldgR1S1mELw4IgIWN1ZgGFH6RnQ+ywN8/4A6EptzjCWvHzsFg0+9s9N90lTy+L
         T0tkGQXZpU2cljmBu02+yqNw/TqLRP681C7lGQGF2Byfnimn7Km+oGallRzQBpU1ykF4
         oJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RcPVobIBGLdE5Ssa/2D1gELvSd5HcpPZzXr83NOombI=;
        b=G9bOAgTlH+Evjcfsb9MKhlzcoqZ4k5Vc8s1qO7mfeROH1dCJvFyoZWjM6v55JXPASq
         Ktw5/ThqfL1QD6C77nedwhE4zAo96skCSKBzMUsmBtyRK/YTFzbKLmdNPNjBvKIO2RXh
         tzOTL0m6L1mPeR2rwyB51MKzBOHr5aeOD0tEZ43GeKqWRoKpJaCJmwan3PI5bOqziWzN
         3ws3I3kVoj2URl+0FvBW+aE48+rjDFR0ka74vn63YDU73fZ/9H6Zs11QNMgaSXbTDuU/
         QH7PciHZPyshztIIdK7VEGDzO5C/xL58Bc19gwwq75gB8KbbJOSz8Xn7zqeXrdaVYHxD
         nuaw==
X-Gm-Message-State: AOAM530KvfCd7/SLKknxjipYkcEJWxkGIKgiqqBZQysjDSIc0RvhEzbX
        AfW0QXiQ7XjJmM8A+MFV4oY=
X-Google-Smtp-Source: ABdhPJxqbTQAqO8N4iV4KGhy/r46l8tOZ8veqsq9+0sueVuWWLRPtvguiXJ2E8oRKlGARV/LCSo3HA==
X-Received: by 2002:a17:90a:d596:: with SMTP id v22mr9301768pju.146.1602172444033;
        Thu, 08 Oct 2020 08:54:04 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:03 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 033/117] wl1271: set DEBUGFS_FWSTATS_FILE.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:45 +0000
Message-Id: <20201008155209.18025-33-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: f5fc0f86b02a ("wl1271: add wl1271 driver files")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index 9cc2dee42f51..681dead95e0c 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -69,6 +69,7 @@ static const struct file_operations sub## _ ##name## _ops = {		\
 	.read = sub## _ ##name## _read,					\
 	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_FWSTATS_FILE_ARRAY(sub, name, len, struct_type)		\
-- 
2.17.1

