Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A714528795F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732038AbgJHP7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732006AbgJHP6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:58:15 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB2BC061755;
        Thu,  8 Oct 2020 08:58:15 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g9so4655596pgh.8;
        Thu, 08 Oct 2020 08:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t8T8i58WQfbeHU8dIRPN7izm8rHgd8f2YkszgDsgMR0=;
        b=bD+fs5ZEG5wlWKtg1qXOk00E5AuZVLgviAE7M9mQ6FjSh0ElMwaEK+wxbEFEXYlEPz
         EHcRGgh+LEYCHtxAygpFx5pp/pK+WHsZ0QrETEiCRhcUGrKVJaFhOcqtuQRJdWq5Pf4u
         QKmC/ORc2xe3pAb+EOfJzGJ77rFlt+KokJfCbleaQI70NJ0mtbqE9eI7t7iTVfptPSb0
         2uR7oQWHwjRrN16MRkUfRuJPSTiB6ChXvJxZ2eNadx3KsHuI2EumrPib/AXskD/+seji
         xGkfLkZsMFKaks+2v8qkQdW69GbmJAKRtZ3HDYOpodP0XadxUCLjryasinuVmowzbWx8
         Dx0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t8T8i58WQfbeHU8dIRPN7izm8rHgd8f2YkszgDsgMR0=;
        b=psQvFkFi2DsyeclTXzidrcFjs3YsyT4Wh7rgPL4pUpd3a89iDu0CkbzQMMKnutxAva
         T/8SNNBXxlDEWDi4o++I2ZZItjmSgbkq9FObWyoLOx4YyeTGdAYmtZT44O5126uhR69D
         8BaJto7ptdx6lF6fEl1rbfKd9sL0ge3C7amEjdZ6zUy1h0xR7iMOvClyKyCH5RQVuBAH
         fLelLekgKT0myZWXycmTmMonbCQosWn+1uO//xr1L3p1I/ioW3KrbQ838wKuC3wHNbjj
         geZwWDtM6UKZjimiHjxJ9bDy7c+/cCGINulj3LhDjnM2FRoYXx0scAmN5UO5stmXOb2S
         HsGQ==
X-Gm-Message-State: AOAM531iTmVRBeTtoK0RSml7nwJ7Slr4JNGr1JKdzT17hXgoPGzc07/c
        +coq5Zcw1gh7n1O/MgPPi/E=
X-Google-Smtp-Source: ABdhPJxqauphbzVm/v5Kps6fYalqWKsQwqxBo5Lq4hOJOmbFwRVoPErK0xynbFNp9k1Pd+5KtPCoIQ==
X-Received: by 2002:a17:90a:6444:: with SMTP id y4mr3865561pjm.203.1602172695273;
        Thu, 08 Oct 2020 08:58:15 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:58:14 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 114/117] Bluetooth: set force_static_address_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:52:06 +0000
Message-Id: <20201008155209.18025-114-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: ac345813c4ac ("Bluetooth: Expose current identity information in debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/hci_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index d162736a5856..6ea692a3d4a8 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -730,6 +730,7 @@ static const struct file_operations force_static_address_fops = {
 	.read		= force_static_address_read,
 	.write		= force_static_address_write,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static int white_list_show(struct seq_file *f, void *ptr)
-- 
2.17.1

