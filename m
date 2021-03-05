Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A296632DF6F
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 03:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCECHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 21:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCECHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 21:07:01 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147C0C061574;
        Thu,  4 Mar 2021 18:07:00 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l18so952737pji.3;
        Thu, 04 Mar 2021 18:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/usniTDLiZiY8Exv4EpG2GjU878KlAu6Su7ozkPE5fc=;
        b=e0aRU/TZORIsKilI2TQU8KUuzpMAjooSQyA9BAsirKE7H83ltJDp1PkAEOvLPg4a+d
         VV0vnhyp+c4a0Hh1HL7AJazFVaQvTFX5WHoEwY1YD/UhaaKYRzQINMzA73bCgen4FgUy
         vopD4PYed12SVSFBeBy2fsFRopnm9CEbUtTXoF6h2Z0HZT14AzeIxm1uIwMYdEXweLZe
         7+ORYmxKJ8NY/xggGGfviDBJVmovmxEbY62/yAx/AQWEvKS6AwAwQQDOpNXtoRbRTr+R
         /NmTO8CKNjqYwRUOcUermD1entHfXnUOk+dK1wcfR/RpJH38qaUtxa8mB0VmHDZ9VAI2
         a4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/usniTDLiZiY8Exv4EpG2GjU878KlAu6Su7ozkPE5fc=;
        b=SAOyA+UFqcktB3RbdCxN34mXBf74Qw5EEj3Ve4qt1NO64rhTY8GqLvcGAqJ6fy22Si
         QMf3GQC384mW/9fbDN+uCxYJbomYIQ6Iy4F8HXzWirS3XKnIV4xLh9PXRc9nE2XKg9FH
         MkJhMQXYX5RozvGG2CmwQYVx2UVcjx/MecRDQDic7d3e93Sct7LCVmRvo6LBKwPgtN+w
         ngWeTI6Dxo4OLrw6xCWnW4+Lpy7MKTYBWQNnT8/DF/nK8RcqV4ZWdXSZY+zlLEe6ICZ5
         xIWMOEW2jg3/qDiIv1h/aMKJLcIYupZRMVeJJ5buB0cCVR5UNPl2DToleLahpc/Hq5up
         XaJw==
X-Gm-Message-State: AOAM531u+umpsvC0LZzEsTFVpkjqKzW4Ikj3HS+BtKxgNzUDmmzjxCb3
        mIRihhAQ/NG1VwdwYKh0Wew=
X-Google-Smtp-Source: ABdhPJwMvt6h8jHR6WGGPI/ATAmWsG/FC6M72R2MjK437fW8DrVyjKiZG+s/2T8zKic4Xoq9iZujPA==
X-Received: by 2002:a17:90a:8c08:: with SMTP id a8mr7730178pjo.136.1614910019577;
        Thu, 04 Mar 2021 18:06:59 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.46])
        by smtp.gmail.com with ESMTPSA id gm9sm461117pjb.13.2021.03.04.18.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 18:06:59 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: tehuti: fix error return code in bdx_probe()
Date:   Thu,  4 Mar 2021 18:06:48 -0800
Message-Id: <20210305020648.3202-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When bdx_read_mac() fails, no error return code of bdx_probe() 
is assigned.
To fix this bug, err is assigned with -EFAULT as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/ethernet/tehuti/tehuti.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index b8f4f419173f..d054c6e83b1c 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2044,6 +2044,7 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/*bdx_hw_reset(priv); */
 		if (bdx_read_mac(priv)) {
 			pr_err("load MAC address failed\n");
+			err = -EFAULT;
 			goto err_out_iomap;
 		}
 		SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
2.17.1

