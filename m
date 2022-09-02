Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0125AB9F7
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiIBVRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiIBVRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:17:00 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A9D13FB4
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 14:16:59 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id e18so4266380edj.3
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 14:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=i2/rHYqnhU/qM3JtGrYL/kgeX0+zBL6HBgkIMZudoEE=;
        b=Ik50ZxZzp2DVCVdRhfjJFZqkwv3Z9IZw8ZTZehRPhBE9pzTdtr9LSV7M4JZnvBhPvN
         v/wx8XXng650AxOwc97N+BCToKkJEhdL858VDlpHm7lXgr88VYqaFqyPfi7+UGepJouu
         FWpjjkv/ovaQaqBKEkdMYH9n9lhvcUjgJWTV1hSYafdQjKWTSJr/Y5tgsw7VMerBqltH
         Z48isOEdIwW+6ycD9bsiY85swgK1k0NDft+MHJEuh37p1OOfvHqhGu7I8dIeuvLm6E5F
         HSF2jICNPsoDHHrmyxQcvger/IvhLE5ild1rQiPRmH9nvXtt0oyildmfYm2BKTfKhmun
         oiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=i2/rHYqnhU/qM3JtGrYL/kgeX0+zBL6HBgkIMZudoEE=;
        b=muwlVVERexmCFiiBQDLv+wayCqLXM40h3LADGVbbhPb/DBKhgGP29R7h7h8sxh/0oQ
         pLyQf87oDI8siSxHASaFKF1pZ8c0en30w3nMX+7z+FsJEtQ8sTeAQ3jREsV5JLS+TAzb
         4k1CGjEiKbHlAst0kNAKSwfmbXDkkFbKj07gme1atMBmqczwyjoZlt3DDvuydslsu1Rr
         qlHTUtGg5Ggi2yVNYrPNyJkHYuj6pyjz1O7y4XwJLkjhEHWlWdfmfkswTf8V8iXIcP+N
         G0PdqXd2xA23tAgm13Wqu7kap6bz05mTDKmJ7ZFOvH1/aHiT8LQ/6EwJWGLT3/5wB2U6
         K46A==
X-Gm-Message-State: ACgBeo3IXDbikjJJ8a87hogu3cvNyGP1+YObiqA0bYYMkctCDG6H9SH0
        fQAoneLSfOkYRwrhRH1SgBM=
X-Google-Smtp-Source: AA6agR6mEdwPSGHDlkedIYTC9mphy2orwdRCuJwfxBjMm6YrDWBnIHxUhmPoFiD7dP9LmE5y4YhGlg==
X-Received: by 2002:a05:6402:5384:b0:431:6d84:b451 with SMTP id ew4-20020a056402538400b004316d84b451mr34119321edb.46.1662153417778;
        Fri, 02 Sep 2022 14:16:57 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c4c2:4e00:f4b8:68d8:d295:8a3b? (dynamic-2a01-0c23-c4c2-4e00-f4b8-68d8-d295-8a3b.c23.pool.telefonica.de. [2a01:c23:c4c2:4e00:f4b8:68d8:d295:8a3b])
        by smtp.googlemail.com with ESMTPSA id c14-20020aa7df0e000000b00447bf35685csm2025181edy.60.2022.09.02.14.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 14:16:57 -0700 (PDT)
Message-ID: <5739775a-a5d7-cd72-469c-d1ded3347a77@gmail.com>
Date:   Fri, 2 Sep 2022 23:16:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove useless PCI region size check
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's trust the hardware here and remove this useless check.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e6fb6f223..1d571af4d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5206,12 +5206,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
-	/* check for weird/broken PCI region reporting */
-	if (pci_resource_len(pdev, region) < R8169_REGS_SIZE) {
-		dev_err(&pdev->dev, "Invalid PCI region size(s), aborting\n");
-		return -ENODEV;
-	}
-
 	rc = pcim_iomap_regions(pdev, BIT(region), KBUILD_MODNAME);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "cannot remap MMIO, aborting\n");
-- 
2.37.3

