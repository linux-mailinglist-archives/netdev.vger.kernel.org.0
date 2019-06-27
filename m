Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B072A58914
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfF0RpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:45:17 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34453 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfF0RpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:45:17 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so1602875pfc.1;
        Thu, 27 Jun 2019 10:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hxMgtavB7S8gabxvnnNNlNWX6F2+mPVwhXteyMBjhrA=;
        b=rb3fd0t2hOOR57taJZWGYrf13s+2iR3laAQcIDfOtc1q6BVsHf6hq3ZjJ5COeWK+iA
         o0lqIb1IXfKiSIIw18fuE6jIDSsr6be8kvOJi96uF3UgO75FTnOIP6+nFNk1hCewZCJN
         yWvU9bnGOnMtvJp0gyh8QmvrM/tCYa1be4PSLV/B5hqAO90MirimsV3QhthzNRyE5KuZ
         Rv8NWqKa9xZ9jOImgJlUc279ThCwx69s2YnMDdwBLeTOVp/aj5eBTp8ZP1l2NYavsiec
         Gr3CAlwEzIVGueiaTrxjBSUxdgHWvypBEie92ko0hwpf4w3uQBm/RmrzAZ/3whJIO4iZ
         csXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hxMgtavB7S8gabxvnnNNlNWX6F2+mPVwhXteyMBjhrA=;
        b=Jq5QoUnjtaUesJ4xkGyehaegjeO0aHrs/5lu4OQGnBUvZfhPu99+Owy4HonA/MLX88
         1Mb7R0shpw/2SoFeqoGAshG6IZwz4V8uI/rGZvAmn5HvTE4FRlnEwd9fsHlVWoRyc7r2
         3fUXUp1xVYP2CJYB7Hc1dDpLpJuMR5MXzsw5pJ1KCQCg6YFAfF+SoDOWKP+uxjXWPmN5
         PXX9Ex+quG2Af1cv7ZAlj/Qs5x06s2ftDtIYTJ7NvYLaTmKCPYRDZN36lKZrXcj60D6j
         p7Wf0QCQX0Qo1GMM36/jWbTzUCpoSgQhCT1fMU/SfDCg74BPugF+qT5/K5JWS89i1goF
         8eig==
X-Gm-Message-State: APjAAAWKoz9TkCSUqnK3pWmSOPKolz+6LmqvIdu+kv/ja2ZkKvoA+1JR
        kE4y6wmxfN6+4UJkstL7MHI=
X-Google-Smtp-Source: APXvYqyaxpW2Ka9NxwAxlz7h0LGAVgejDtcVcsIyVJUcTHorn0WjUkLeupp1FE1M0OA2dosEixmW1g==
X-Received: by 2002:a17:90a:3544:: with SMTP id q62mr7556342pjb.53.1561657516575;
        Thu, 27 Jun 2019 10:45:16 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id y22sm3968437pfo.39.2019.06.27.10.45.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:45:16 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 79/87] net: vmxnet3: remove memset after dma_alloc_coherent
Date:   Fri, 28 Jun 2019 01:45:09 +0800
Message-Id: <20190627174509.5829-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 89984fcab01e..a5ba7ed07e9c 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3429,7 +3429,6 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 			err = -ENOMEM;
 			goto err_ver;
 		}
-		memset(adapter->coal_conf, 0, sizeof(*adapter->coal_conf));
 		adapter->coal_conf->coalMode = VMXNET3_COALESCE_DISABLED;
 		adapter->default_coal_mode = true;
 	}
-- 
2.11.0

