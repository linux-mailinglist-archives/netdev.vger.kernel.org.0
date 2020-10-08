Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B86287877
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgJHPyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729910AbgJHPxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:55 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CE6C0613D5;
        Thu,  8 Oct 2020 08:53:55 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k8so4345987pfk.2;
        Thu, 08 Oct 2020 08:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4L3XND6xoqPBlA6sJuwVFWG/TTno17xP2f+hlXCsbLk=;
        b=Rytm3xZPYFVlK8DKcNpatzMgWnH0Kp9nl0t3LIZj2EO0esAcUO2PBmxorWtiiWhpvZ
         oB/OnlB5z+b0z79/k7ORpaiVKVgfAedUClpCL7MPnk4nE9FURYX9gFW2WQp/1ZRmtUvT
         a1cGChkKFhKkSE85l7C5gdRc6ZrIgslxVMf/L6vQYlogeb7HwuPDXlc76eySqd8N0LCo
         +dqoZAu1n0zfdAou1hMXe8Gw0RXF01IAdkHTK5Eo6T1VvLlcdORjlMF5fyChE2X2TDt9
         MaiR1GUX7VmsjteMtnGKeoqzrU7irzSSHHKLDe/fOD79l5Vn+dpaEVx+17MANdoZKMjP
         +jMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4L3XND6xoqPBlA6sJuwVFWG/TTno17xP2f+hlXCsbLk=;
        b=AjY7gXzkJrU+qIDIv2XLzxKIdsCsypkpc5OUV39rQNDJl49yDX3ZLwVzSczwRZ/TY1
         tetWW76D6nv0Xcpv/mpIs1p6edWf3S3TcpwTuF4I9Rmv4iw6qKNeFUVxoO/NV/8WVGFm
         1FtO1hFmeh6IS51blfZk5UbBjnLPDiZaLY7hrjnkQt04GAWwd60+u1JNnYs6rKrpCclM
         jSuHv1gYdlFVPEKiBKXI58TBGoDtL5w6/MT4Ud9J6KO+j/lEKfKa6HeqPfafhPB/K2ml
         5YlZlyg2ykQ7CI0guJIunDnke8/70CTANedgJknpba1P1p/RnjxjPDFNwJGFvcRkSJSD
         XGcw==
X-Gm-Message-State: AOAM533igfsSCown14kyKegTnvFEkiFHqHS5cIo8AR00ApwZKRaUD62i
        3gLwM24VEOay8nm/4dmAqoc=
X-Google-Smtp-Source: ABdhPJzBFontmhwCx6Uhj4h1axK1OLtAEbY3dpBW0LDzPbTb/RKl5UfUQlqwj1nixGUBngeaeockJw==
X-Received: by 2002:a63:d6:: with SMTP id 205mr7778165pga.309.1602172434615;
        Thu, 08 Oct 2020 08:53:54 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:53 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 030/117] dpaa2-eth: set dpaa2_dbg_fq_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:42 +0000
Message-Id: <20201008155209.18025-30-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 091a19ea6e34 ("dpaa2-eth: add debugfs statistics")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 765577386fc7..df84324efb50 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -124,6 +124,7 @@ static const struct file_operations dpaa2_dbg_fq_ops = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
-- 
2.17.1

