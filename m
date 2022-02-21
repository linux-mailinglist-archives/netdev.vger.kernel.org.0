Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B8A4BD3AC
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 03:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343690AbiBUCYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 21:24:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343610AbiBUCXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 21:23:55 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B723E0F8;
        Sun, 20 Feb 2022 18:23:27 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id v4so13745578pjh.2;
        Sun, 20 Feb 2022 18:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3TqDnGbE814aL5zFFBqZwwXe27yQRSxYJoayRFzKY5I=;
        b=OkZPsDsK+7Hmprv8mVquc5+qvIyMxDGyDnVRtXZR3MFks2a+5Hfvzs6YBrH3HiDmbj
         C1V+lupxb6cPETcoHqxlYfCsiCW4/A/LDYQJ5sI8zSH+dcpiPArkucuwdTbkcQt4LMNy
         eE5tgL1f3w69vURTbL0vZzoxmEkRSCNuOEzFoVjHnYoSUPisp/dGcGeqL/BK8Nus0jJS
         4lurtAz9PrmzWxIVDSmS/hVPXPDBTdhHDNxIUh4Rp18f1tBVmEq5GjEvfsT/SOgl+p8C
         VwqG/Kt6nIQEIKbk15vDmKBHu6fyVPy1w2Mi42gwt5MCJ4wj9ye3a1uccMhXfPZvqgaC
         PqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3TqDnGbE814aL5zFFBqZwwXe27yQRSxYJoayRFzKY5I=;
        b=VnlEwHG0fqfinfnzX7qVHDC7sjZCmhTne/9T0nX4R00aiw2VlPeM1xmEnPQjAkb7b5
         KmGH1K21Pqn1FEcmcwnVmT3FTG15CuzsVes0yXRkc9fPFqXmI/cEqco8ApnTgdCIj5TY
         qRcEFZ3t1ko2jUgOLiMAXvOmx1fwAmeDfIEvEmufByIMRFZjItm96JlDttRdI9nEMYGq
         urRbdBfrQz+SFMh8GhQPkeG3Ag7y2dJqT9iLNRwr1HBR334gqpExlwiUG5JIUvhf4+6u
         LiGl+f7Xz9rvw0jyFhto1kue2t9MQRxquXknqfE8x7Azqrm0fBU5Nu+fez+YxWdLKL80
         LwoA==
X-Gm-Message-State: AOAM532edzQbH++O5KbMMK2yVZLu3fUAbkaYYD4fUzcB+TNFm4cm/mTr
        5NaQw6tE3kQ3kfq4rA0sFV0=
X-Google-Smtp-Source: ABdhPJwyUcNeyLtpe6R0/FHsc1Zv0QeGXVq8gnX6O/nlyYNbQNIf7OtUpJ4i63+eNEIYSgqWJD5gUA==
X-Received: by 2002:a17:90b:1642:b0:1b9:6b34:b68 with SMTP id il2-20020a17090b164200b001b96b340b68mr23490123pjb.99.1645410206903;
        Sun, 20 Feb 2022 18:23:26 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.52])
        by smtp.gmail.com with ESMTPSA id e28sm16603548pgm.23.2022.02.20.18.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 18:23:26 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH v2] staging: qlge: add unregister_netdev in qlge_probe
Date:   Mon, 21 Feb 2022 10:23:12 +0800
Message-Id: <20220221022312.9101-1-hbh25y@gmail.com>
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

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

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

