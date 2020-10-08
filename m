Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48141287822
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbgJHPwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbgJHPwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:37 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEDBC061755;
        Thu,  8 Oct 2020 08:52:37 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x22so4306806pfo.12;
        Thu, 08 Oct 2020 08:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D07xhSHbZRL9C0+X//rE0fS4TSWm+mUsSqlmLFIh9qk=;
        b=r/v5gYqA0bGuSWM6p1W11QwuVKdV2ylqWjVWPd4+0fwxwRRGb0cKghiDtbIrGYJF5V
         OXfXj3Myg3Dh9649gFL0o/9B0dapmY8nCNwxTc7twac5MBuCA+z49skOwMSlyii76R/F
         z1Ku42YOK8h3RpRTtfoJdU/LgXS/+ngjhcn0CzUZC8eMBNCmmkXZZOG2xzB6bZ9U4Jlo
         CkZh88kUSyqADnJvm04sjDqQvXSxZ0384L9Yv/jRV66GxuAqXupGcGTFYStwC1TAy7Zc
         NnXMJBmjOyiGZqSgwspxl9oVLXGflohDGIxLbxy/bjlBzJqkH6ajunmiOdQ0JDQ8rfvq
         KtBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D07xhSHbZRL9C0+X//rE0fS4TSWm+mUsSqlmLFIh9qk=;
        b=N4SU3KST1CN0oo66NpbHaAn5Wes2b78m1GgDS+lWRAe6ecnMOp0gDH6ovEdM9pdjoz
         ClvVJqhWLkWNwjhB5w7LG4CUHw+pNdiH+pcflBlDjskLbzXcHP+1N8FSh+dC7sW9971d
         ZnLb+cWRtFunAHA/cbzioMeEByaITLxXDeA5rJfFR++q8SLLx/PD8/rHA32byCl980L8
         /4XPPqXWPWFppIfzvk2aJvp9T41oX4JrZ78jay1HyN38DPIEWjr1QIoVw/PR+TrEkFfo
         1oYkQHR6S4Acsn1F0sgh7ZNZ5qnWyiwWUlEPD6uA+vRTwZBsh4uN/mHD82QjGdjKo6Hs
         fY5A==
X-Gm-Message-State: AOAM533r7TYZ7pxTp74mzkyvLvgzmyCVEZBxIObrff0IXWr0lxhzU1rf
        WXMbU5galgNU3gumKwiPqkA=
X-Google-Smtp-Source: ABdhPJwFzlzAQMB/7Vbk2xhUhPxCYzWSuuj1MnM2V6h5WZIs3H49uVQnPCCLxtgmh8CwYkAafY8jsQ==
X-Received: by 2002:a62:7c09:0:b029:152:60c9:43b2 with SMTP id x9-20020a627c090000b029015260c943b2mr8069057pfc.79.1602172356737;
        Thu, 08 Oct 2020 08:52:36 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:35 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 005/117] mac80211: set KEY_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:17 +0000
Message-Id: <20201008155209.18025-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: e9f207f0ff90 ("[MAC80211]: Add debugfs attributes.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs_key.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 98a713475e0f..ea5908465f2e 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -30,6 +30,7 @@ static const struct file_operations key_ ##name## _ops = {		\
 	.read = key_##name##_read,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define KEY_OPS_W(name)							\
-- 
2.17.1

