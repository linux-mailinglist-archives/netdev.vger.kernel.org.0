Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E442878E2
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbgJHP4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730884AbgJHP4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:33 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA73C0613D2;
        Thu,  8 Oct 2020 08:56:33 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y20so2950424pll.12;
        Thu, 08 Oct 2020 08:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UJ9tWuaqAx1tPk14IV9WKGBWQcspggcO2FmZq8qWq5A=;
        b=nRSHBfPC10Et90IvUsNGeoZUmBHVLLTqx4kgDxm0z2SuydHUCD1L1qiFCImAY670CX
         z/NfCq+IYV2mMpNnoCNDTPBXNzkLfrO6wCT6BaUjLAoO+yWo6G06iIcpujf7Fdvlrgyy
         14TLo9yH/Hds0UCyn5BcDhK/5VUFJN1ysfD6kwZ2SrI9VCG/1qVAZXfHG7DX1NtPHiLU
         tkKkb8LFFhowPcJ+vpImRKEwpdqUg3O/VpQvSpTo8tiwEFNZgzS/nzPKmTERZfZC7CLJ
         1ObGlGd8Ea7Ox/2IYfN3UVN5wkZP/fsHASo/gz7UeNgvZuMUeZAv8/jFU2MRlzTdoJPq
         a0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UJ9tWuaqAx1tPk14IV9WKGBWQcspggcO2FmZq8qWq5A=;
        b=a05laDFYS7VDen1fN9Yv1vpDZ9AeYBnu2usz0PuNi/OsBV+c8bTrKNXpsN0yHVRrzE
         UwOLnLbtYTbl9a5MSs5Rr6DA6aYf20ROR/6KzQhnmrNFwJnTPrnPuud8sha4h/cjAtwd
         kKEAenvVQB7kqnrB2HRhMMD8eEaBSM/jtWZOHDgoChJtz2NOO0AzXpaG+nCpZdzj5+mv
         RWXJ/q1+S/vF6WhUjkP31H9bnLLVj1Klowv3RX3UvLG3hCULJzniWxDRQBdDyf/6FKEw
         289ZWtt5B1KKLIzrAso2lUWlQCrkw6FixUnWypKbu0WjdHeeKR+MWqfXu8KzAXrTon7o
         /9Mg==
X-Gm-Message-State: AOAM531SamGdski9x5iSOzdOqbWTiDlSQyI3Hsz0P9/Trgec6ORqAXvq
        EGNk1lguIgOofO73MdEkDco=
X-Google-Smtp-Source: ABdhPJw1UH9XxYEQQaoWxsP/7Wlu10WNGdOK/kJVewS+VUQkzxZcHVNi5R2QW4sX1t3u68vS+5HKsQ==
X-Received: by 2002:a17:902:864b:b029:d3:ce46:2829 with SMTP id y11-20020a170902864bb02900d3ce462829mr8640528plt.16.1602172593075;
        Thu, 08 Oct 2020 08:56:33 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:32 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 081/117] wil6210: set fops_pmcring.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:33 +0000
Message-Id: <20201008155209.18025-81-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 977c45ab5f41 ("wil6210: add debugfs to show PMC ring content")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 6f1603304d52..4891cb7aaea4 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -965,6 +965,7 @@ static const struct file_operations fops_pmcring = {
 	.release	= single_release,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 /*---tx_mgmt---*/
-- 
2.17.1

