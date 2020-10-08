Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30BD287982
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbgJHQAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730491AbgJHPzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:31 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF8AC0613D3;
        Thu,  8 Oct 2020 08:55:31 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x16so4670398pgj.3;
        Thu, 08 Oct 2020 08:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bo14ePskj/WMnlv8VJyYTmnPSClJHgwJt2g6ezvG6q0=;
        b=jkCn4OvcqfO4p8OwCRKzL/uoeZNvyT+zCoYhcWCk6+ZELy746LHzyMlnLK10y2PVNY
         3Z4wpUk/fZQ9pTEaeDUBK3GZ8ap1g6rve91bphqbiDHKBgG22wGFwjR7fczcn+kHLxlp
         d6GbFGGuip7HXmL197Kyxn1GNpkgMHuD5r7qx7d7duH5DFebD3PDm+9X3KNmzdjNLBV9
         JflenVregldnSattjMloLBa8552Pc7IQ7FhU4jlIO9qGQfg+WA6/WxS7ECaq2e96ijOl
         A6lbb+c/kVsjF55daw/JT02Ia4AdtYXigcg61UQoLx4iaGXO9sB7m8DC3vCxwVuLfTKE
         tOng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bo14ePskj/WMnlv8VJyYTmnPSClJHgwJt2g6ezvG6q0=;
        b=lJ01iTAyfNbNAfmnJSUFWSXgbkKlMtq2C/8iPX73D4dOyqjJSj9WHeFfr3s14Axlxi
         QiEBxURx96PY6Ky/B+8rQW5j14WCqGqqTC366HT5Y9c1ldYxVae/1qTgPa8GMDPWdwZ8
         VnWzR/vWUJaP02sXwOfbUlOg/Mr+txDdKzbkVnbRaBLS1W04NfwzHgFyMfOrp8GRDCNB
         ffXdF6FUfJjXGiHf3csiif7qs2bKMH/FcAzl1aQvg63PkWRNbq1IR9bo1nqkyO5wiC+E
         0Wvu/9Su4kTD3CcN9P+LQgXaqWdB/ylb26fPSEy0I2ouB6cdJ4soXm9Tv7s1N8kS1+G7
         s5Cw==
X-Gm-Message-State: AOAM530GIlJBvy3ZYN90LkcIt4Tb+5IDnaSjj9o1VT0OpCotTohqDKQH
        6O5KfK0zvKElLUu1k5E+gnk=
X-Google-Smtp-Source: ABdhPJzKZqbR+KvuT/ap0FpnbN0bvzNbUbTrbtYfupwZyoHWeEJVElXxIhGFVR+zRBPKeNLxCo+BxQ==
X-Received: by 2002:a62:e706:0:b029:152:5364:f5e4 with SMTP id s6-20020a62e7060000b02901525364f5e4mr8017086pfh.71.1602172530757;
        Thu, 08 Oct 2020 08:55:30 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:30 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 061/117] iwlagn: set DEBUGFS_WRITE_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:13 +0000
Message-Id: <20201008155209.18025-61-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 16db88ba51d6 ("iwlagn: move dump_csr and dump_fh to transport layer")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e408a381c82b..7c13184fc8e7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2513,6 +2513,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_READ_WRITE_FILE_OPS(name)				\
-- 
2.17.1

