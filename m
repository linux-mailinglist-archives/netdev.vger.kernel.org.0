Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999492878AA
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbgJHPzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731648AbgJHPzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:04 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5904C0613D3;
        Thu,  8 Oct 2020 08:55:03 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o25so4677748pgm.0;
        Thu, 08 Oct 2020 08:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ca7kCfByCTJZS86pIaQXnoWI1vjQEzd90v0zOCj5y78=;
        b=eGf2tbX7VuwVzfsGOOfc2HwDBFFpYfg7e4BdXwCIZdtzN3zDwKeSkkiiItygNJs/PM
         g0x+/9l+sqnyAGnUuAlt9l0e8SiV1x2/lbT+QchRGM2+BgZKLG81H+IeCYGoW/8nn7z5
         3fhFagK0Dg5V53sDYKWAzDmQlBlOVfREH/RwwdLU65QgSBT1gFuRPAkrTN2L8498apLU
         VeqgMW4UG+SsE47/LJ0FGRhDXQ5jdrg9TiULOFxL/yhwDFs0WvLfTEWKBMHPVas8Ialc
         jzmCpkDxkANtQmAepH52JwpJ2/XayxjdVD5EwBoWx56/mB2bPrKtBwfTCE1XLoaUABYI
         mxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ca7kCfByCTJZS86pIaQXnoWI1vjQEzd90v0zOCj5y78=;
        b=MxgzWfsauDvAhaH6d2wm6XHXgLLIZxL94kU2C8cOi4c1flg054gRzizXsENjkRsPqG
         qA+o2/zLwMWiqCpYKOfL77sa4THZ+mRnGitNzHf/l0j1X7iap4LzySVx72PxOPJtlvFn
         HFFImkE7HaYLuC3egdjCvtRruX2y/dWYJR/NGFkrdXkgwaOcIbtrtLyN0rFZ+Mi+GhjL
         XsZpFou99cG+hMManhpSjdacnJREUWqvA6XyfRxaeinLTmcMlFvfk9iEtlhdEBJ8knku
         GvyiHG/nRSmGgMuGM/1iNr2PXlOkPlB7gF9LsarNi3ugSnKCN6RkA54PXN+TWYR59BnD
         IdiA==
X-Gm-Message-State: AOAM5306VgRv39bClO79rkLzv4hhLcdiNVlepqgPvnnshFYLq1vptw1f
        vqF0hB/BzrRxUX564oGd6RA=
X-Google-Smtp-Source: ABdhPJwmsiqnxFE3xKHM4Z67usj8nyWJL9n2is6V3XD5i9QKKAnUf0Cs1F1Np0QwbMzMgmGKBw86ag==
X-Received: by 2002:a17:90b:118a:: with SMTP id gk10mr8418460pjb.218.1602172503445;
        Thu, 08 Oct 2020 08:55:03 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:02 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 052/117] iwlwifi: set DEBUGFS_READ_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:04 +0000
Message-Id: <20201008155209.18025-52-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: be663ab67077 ("iwlwifi: split the drivers for agn and legacy devices 3945/4965")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index 4f741b305d96..03571066f580 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -136,6 +136,7 @@ static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.read = il_dbgfs_##name##_read,				\
 	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
+	.owner = THIS_MODULE,					\
 };
 
 #define DEBUGFS_WRITE_FILE_OPS(name)				\
-- 
2.17.1

