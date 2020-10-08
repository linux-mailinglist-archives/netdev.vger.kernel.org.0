Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86901287827
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbgJHPwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbgJHPwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:44 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C15DC061755;
        Thu,  8 Oct 2020 08:52:43 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o25so4672024pgm.0;
        Thu, 08 Oct 2020 08:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OiqcYn8C690f/neGDt4mRrF3Bc386zYmtSC6n8vND08=;
        b=LsdKc4++rY9KdzG2eQMffwjpcL3jE/TVR+tKr25HBcSVaZT9ZNEycN7W0/MPPng6X3
         iDDvoGHUIevFl+EuCUDc6bkRcfpADd1KNyNxrh0ul0FXmL7iLQq5Uoy68iFOrEHHxZhK
         AgY9pylM0D7u3TkK9So4+kUqy/nI6QOkYiD6E2zrmZ4ORzBFMHS00vLqZKoufeCPjyC+
         FwApGVCJQ0BEflMWC1G90r3bVeLUiTa6bSSM+S+ZZHmE5UE7nY0clYY0yeoCQ7oGKsVI
         RYp0zoNLDV75MdgUhe97qlQ2tCfCZ/4lCtOW+nJbJS+2bKNfCKrtOadIRdyl+Q1HZMd5
         gHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OiqcYn8C690f/neGDt4mRrF3Bc386zYmtSC6n8vND08=;
        b=dy5+ngvC/vLAmgKBjJ9DllbiSV7jR40kTHehDGbssM08UN6iE/Ud3+YAroTmNHsEKu
         DShtTCRp6RStsyvlxDVG/IB2XxK7aXt4yOoWQNDzGwMIh26/YlHizwIAjN9AxP2mbGzT
         MwohJ4de3eLMCXm9xyng8wcjAr1V1xARCG0c9D7dMPtvoXzvWBKhqqsLzfDyenpNnFCL
         Yb4D3Ld6dtMfCRk75HCW47xrdcfoeFEP5VXYMuF54dR31xtNWC7a4cMlhJf/xYYcauXJ
         2IpGnFI3+kCBLolQKZpPWy0WO9ehnGjEqxF8Gk+2eHiBfQhgAFenR1MLbPnLtTrVMzct
         vKMQ==
X-Gm-Message-State: AOAM530TltV2/LtjzFU3wVRaucOXQIUtOIXCwXQtiGE0W4cJKtV9c5Et
        cHzz0fjwnkVbWet+jz+6R/7TGG+syG8=
X-Google-Smtp-Source: ABdhPJyy4XfywKmvZelf/Uewqka1VPy7GC7vP1JJFp7yuxPdV+lTGIns3HgMHlflxZ/fzAX9+kVjWA==
X-Received: by 2002:a17:90b:8c:: with SMTP id bb12mr5432411pjb.48.1602172362974;
        Thu, 08 Oct 2020 08:52:42 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:42 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 007/117] mac80211: set KEY_CONF_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:19 +0000
Message-Id: <20201008155209.18025-7-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 8f20fc24986a ("[MAC80211]: embed key conf in key, fix driver interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs_key.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index b5fe68b683e7..d7c0c28045ef 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -55,6 +55,7 @@ static const struct file_operations key_ ##name## _ops = {		\
 	.read = key_conf_##name##_read,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define KEY_CONF_FILE(name, format)					\
-- 
2.17.1

