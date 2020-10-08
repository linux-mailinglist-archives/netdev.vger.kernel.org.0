Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A96E287897
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgJHPzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731648AbgJHPy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:57 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5C8C061755;
        Thu,  8 Oct 2020 08:54:57 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a200so4325757pfa.10;
        Thu, 08 Oct 2020 08:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uFx8Moi4i7WVgdUfl/NrupmbpWugcIJs+bvy0ZBk4bs=;
        b=UdXkihanuIU5WhI0tdDk7eOZpPfBcKw9VB8hBv+xe/XTCU6FoHte6AXLpz0Gu1tFtG
         0v8GxestCC9Lts4khBW/a3qWwbH/rc1pBiPJUq4/oEIAFXOATSyGKNv9oj78Q4YnOziS
         T2QaVL+HwkRuuIEZm7kQ+NN8RtGJ9foNChZ6wC2UYAN05mhg1AOJPD6DxNywWqxFeFDC
         mzfWT99gSBWPyV75nQ82HyZWHfkXnKipG1RmXClGcranN9dwGeHNN95xcY+EOYixQBN0
         pSpd/I2FYC4BzBPg7ceaFFVPtfPlMddY4zBQIY9p7RHBfmcNydDEuROmm4tYYbAJdsmN
         q2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uFx8Moi4i7WVgdUfl/NrupmbpWugcIJs+bvy0ZBk4bs=;
        b=S7nXVmcB/2m7M+Sim1T00q3tTM1Jy3FHOJmNy3JJd2OxbQrvZw9WsGwfaKDoxQPVmT
         MwX0Ebixx3ywZWUqGZ34CaRj9NORGXRCrpntzqYMPubKz2OV0H4oL5u5MmKrPdtNH06w
         B+onPW//7T/UDNXTRhOmDOAETzDPH4oD/a2nwvoo+5gm4UQ2KfL4SdJAJVOW3fiAhCnc
         P6OHDDQKJFc39Xcanodf7ifyWN+3oDqjT4TODGd4+fjZ55kWqk1lqo1pDHlQPE11KiBC
         RRdmXzcFVo9F4dgZ33AT4Hg9j1XvAbdezoZUX4pFtzplE9bf6YbZBMVU2IbRh0lgMI9e
         NXdw==
X-Gm-Message-State: AOAM531m+9/sO+4bcMKevEzXQuwRvTwfty78Dg1vMRYINqb0LGIvsH9r
        v16+g1xyu/2pJsfg2VFiAsg=
X-Google-Smtp-Source: ABdhPJy8G0mYcOAWPJqE77rng+1IcMUDZQ2ACQPy0IA8RSAACUsu4zIiK7kV9fkOAibsdtlz0ZcxGw==
X-Received: by 2002:a17:90a:1702:: with SMTP id z2mr8979835pjd.88.1602172497430;
        Thu, 08 Oct 2020 08:54:57 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:56 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 050/117] iwlwifi: runtime: set _FWRT_DEBUGFS_READ_WRITE_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:02 +0000
Message-Id: <20201008155209.18025-50-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 93b167c13a3a ("iwlwifi: runtime: sync FW and host clocks for logs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index c0edf6fb3760..d99ed6b2f781 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -151,6 +151,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.open = _iwl_dbgfs_##name##_open,				\
 	.llseek = generic_file_llseek,					\
 	.release = _iwl_dbgfs_release,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define _FWRT_DEBUGFS_WRITE_FILE_OPS(name, buflen, argtype)		\
-- 
2.17.1

