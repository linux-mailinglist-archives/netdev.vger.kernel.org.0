Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004C14BDF09
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346999AbiBUJDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 04:03:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347280AbiBUJBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 04:01:08 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADCB1B797;
        Mon, 21 Feb 2022 00:56:13 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id u16so8185270pfg.12;
        Mon, 21 Feb 2022 00:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WZXrnKErNeL5lMaOc5mdXm+VKeICKiYhtwQ5xG170Xw=;
        b=jU/OVWCH/lwwVb3C6Bp5ADGr8MXWoiP7i+0Kij0V0hacdaZZ8tK00cVt6iZ/1oDgSf
         zLCNBR+499VDg1KPetHCo+UMwdstxG/Wtb/cojSBn4CxSEJ6+B6Kn2sSEKMLa1FhpnkO
         gOfg/cTYpGSln1Uw29rXocHi3cBKSe7DPv5ozIhOeUHwEN6CIvYt5Ra3Si/aWrc6nHOh
         7aJAYpciUQhPZ4GngXgspMO/udtUSVPy9FfWweOkXFjyWaxJte3XNAcV5wQbDu9Bgw6B
         LWwBJa1AeaH1H8LyWa/xijViaL4QCRQOZGKSBn+6X/iN/DMs7UCUWh/T95iDkQZ2eXiU
         6NYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WZXrnKErNeL5lMaOc5mdXm+VKeICKiYhtwQ5xG170Xw=;
        b=8Ao2QHzkLB5cunQm+LHWy3/XEJ1+a9KDh/tknUv2DG3Xsx58pPfKJVaInlL/5YZroY
         YyOjGs77n6kXHxknE4fcO1nOYX2WneXBfHLDyBKgFJrFgdp4qohK5KkI7I02Hh4jqqxk
         JUZeMJLhnUnVC285PBNsl5DrJjS9gCztPgxlOuRXjcHyRxK3K0anni7LfPGZUTiQoEzo
         mC9d4GlcexgL+dtd4+10/+VsTWj7rwcUw+YFDYSIeUj7xBB5oOhC94T9nj8m67hg2lVH
         emCWsFPm2gHnfKNjvlBO8qCItWAGR93PPT7gCQqGzkfGGuZ67PY3Ompsh0jz51jlXtZi
         ldvw==
X-Gm-Message-State: AOAM533B1FrBjBGEobli9PWN3ICsQi54WRofdz+M7FwoVoZQtattK8lq
        ZIWrVdk3j0XLoCP46i6irK8JoGuCEIvePqg7
X-Google-Smtp-Source: ABdhPJxQFKuAvx0FRc1MFgpz68m7KDduM6CKW3pDZQEtnNhhGZJ/kLVbzQcknaO+Ju1xitzuqiXzYg==
X-Received: by 2002:aa7:8d54:0:b0:4e0:bd6:cfb9 with SMTP id s20-20020aa78d54000000b004e00bd6cfb9mr19221126pfe.60.1645433768449;
        Mon, 21 Feb 2022 00:56:08 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.54])
        by smtp.gmail.com with ESMTPSA id h5sm11488325pfc.118.2022.02.21.00.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 00:56:08 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH v3] staging: qlge: add unregister_netdev in qlge_probe
Date:   Mon, 21 Feb 2022 16:55:52 +0800
Message-Id: <20220221085552.93561-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unregister_netdev need to be called when register_netdev succeeds
qlge_health_create_reporters fails.

Fixes: d8827ae8e22b ("staging: qlge: deal with the case that devlink_health_reporter_create fails")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

v3: add a Fixed tag

v2: use goto to fix this bug

 drivers/staging/qlge/qlge_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 9873bb2a9ee4..113a3efd12e9 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4605,14 +4605,12 @@ static int qlge_probe(struct pci_dev *pdev,
 	err = register_netdev(ndev);
 	if (err) {
 		dev_err(&pdev->dev, "net device registration failed.\n");
-		qlge_release_all(pdev);
-		pci_disable_device(pdev);
-		goto netdev_free;
+		goto cleanup_pdev;
 	}
 
 	err = qlge_health_create_reporters(qdev);
 	if (err)
-		goto netdev_free;
+		goto unregister_netdev;
 
 	/* Start up the timer to trigger EEH if
 	 * the bus goes dead
@@ -4626,6 +4624,11 @@ static int qlge_probe(struct pci_dev *pdev,
 	devlink_register(devlink);
 	return 0;
 
+unregister_netdev:
+	unregister_netdev(ndev);
+cleanup_pdev:
+	qlge_release_all(pdev);
+	pci_disable_device(pdev);
 netdev_free:
 	free_netdev(ndev);
 devlink_free:
-- 
2.25.1

