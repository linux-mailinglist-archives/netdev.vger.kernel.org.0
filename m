Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A0D5F0D12
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiI3OHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiI3OHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:07:03 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C86616EAA3
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:07:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id h10so1353142plb.2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=compal-corp-partner-google-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=+hT6l0vmVy5od+v5UuxLD9ZYrrtPqYO3JFvSm3Cvcoc=;
        b=7PWn/nPcIjVXw4r8UwlZ0MKfApxufPV4Bg+dJfddx/bevFffF9sBZj27Rs/5QQBbnL
         31wlV27+Mm5xyD5CvSoWfJNp3wN6bnySincwZv4J3LfQ3FZQmiuB1O+vM9xw7odiSGD/
         iYrM0PnnQLZBMTo8ej9nU6nvcHiSh5FSi8b3C0/zViAx3y72bnnSg8+Rb/POyMMuXuXJ
         NbLK4PdgUpQDjZ1P0GoRaDYN4TmlSkTaeMvEMXbkY05c3I2zJdIbp1zZgRFnB47RgjqS
         yB7rip8skWpnttO0OzaBTxKlv/M/Spv9rpdJhGkJSUJ6P6c81hCHbhmYGam4gwBt4DYj
         20Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=+hT6l0vmVy5od+v5UuxLD9ZYrrtPqYO3JFvSm3Cvcoc=;
        b=5mAa53SvLJpazhe5ueWkPP5gkRwhQ3zB5rWIrTyaXN34TGSagJ0l3FAtV1nAHWptVm
         wCNt88Wa/4a0viiWGTFqH+2aGYFqhLIfwFx+6PpfI+9ZJSOa1lhn5wnfTZDOY61V/FNC
         yEBAhO3yMZUQrprt9Q4e8FzqsgCvDATBXbYpvgi01LolWxhVIv4y2BHxGcknpad0Hqhp
         VERI99zGx+vo2CDkKSu7kurWQqiyLn7oXTMJ10urtGRok0gJdVZw3aVAGzXOvEWxJEsE
         dGD54tisBaIr0UAymu8m+2WheTIPqsnoh67p8CzzrPwAqRiR/DeXR53XCxLlUyKUYPrM
         Qi5Q==
X-Gm-Message-State: ACrzQf28z5MaeEp7evVOJYd7bCexcrOAqkhmLDhSAl1/nkWI9/3whq9W
        QCuoJkXLn180tkajdewNjM518Q==
X-Google-Smtp-Source: AMsMyM5SnRCv7+z1Jl9Ftw77yWF2+28jks/ob9Meu6is1z9lC64bJ1drXzcJHfFk8RfZs4Ck+wmRbQ==
X-Received: by 2002:a17:902:6943:b0:178:4751:a76b with SMTP id k3-20020a170902694300b001784751a76bmr8799422plt.37.1664546821243;
        Fri, 30 Sep 2022 07:07:01 -0700 (PDT)
Received: from localhost.localdomain (118-167-215-236.dynamic-ip.hinet.net. [118.167.215.236])
        by smtp.gmail.com with ESMTPSA id p9-20020a1709027ec900b00176ba091cd3sm1897742plb.196.2022.09.30.07.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 07:07:00 -0700 (PDT)
From:   Ajye Huang <ajye_huang@compal.corp-partner.google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ajye Huang <ajye_huang@compal.corp-partner.google.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1] bluetooth: Fix the bluetooth icon status after running hciconfig hci0 up
Date:   Fri, 30 Sep 2022 22:06:55 +0800
Message-Id: <20220930140655.2723164-1-ajye_huang@compal.corp-partner.google.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When "hciconfig hci0 up" command is used to bluetooth ON, but
the bluetooth UI icon in settings still not be turned ON.

Refer to commit 2ff13894cfb8 ("Bluetooth: Perform HCI update for power on synchronously")
Add back mgmt_power_on(hdev, ret) into function hci_dev_do_open(struct hci_dev *hdev)
in hci_core.c

Signed-off-by: Ajye Huang <ajye_huang@compal.corp-partner.google.com>
---
 net/bluetooth/hci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0540555b3704..5061845c8fc2 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -481,6 +481,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 	hci_req_sync_lock(hdev);
 
 	ret = hci_dev_open_sync(hdev);
+	mgmt_power_on(hdev, ret);
 
 	hci_req_sync_unlock(hdev);
 	return ret;
-- 
2.25.1

