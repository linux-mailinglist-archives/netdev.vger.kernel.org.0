Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2408B4FE0A1
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353777AbiDLMqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353904AbiDLMpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:45:53 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524997C150;
        Tue, 12 Apr 2022 05:10:12 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id bg10so36925093ejb.4;
        Tue, 12 Apr 2022 05:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rq9lR94HUSwFCQZMw7bg3ocQXJ+m1X8SURhYPub1cJc=;
        b=HdmVvFiWFm5FuLOzxIGZw8PYTX2AkLfWmgtmdMqk3e41zt0SS/amriqzLdBoEhiBVY
         flJD/cwGV/iOGXd/P8hJQvKbnvXGBXwckMPofJsy+Cfxdvz7h5R5R2JYzxmnHI49oQVz
         iKxLvvtWOWkKNk6nSvWZUXfLtF+Rnw2x8LnJlzVqP/KB8imACgWjQykUgTVrBNGszmJS
         P6w4IoTt65gvQnUAZMh5bUrTQitCHY7inTg+D5aLGVxd8wC/YcIv7rD+kDE0dx5tRIp8
         89MvNTFX2vEC8YPLPQHiS9WGDTSCBixkSFs7KBzlYRx/Gtyh9BT8Ke6M1+gN5dwn1b36
         PJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rq9lR94HUSwFCQZMw7bg3ocQXJ+m1X8SURhYPub1cJc=;
        b=TiJnck0N3h2KfV+tvmLPuPE7FHlkxJnJTzsLuqcdo3g1CgxAJvpKRc8QvE4ApA17yD
         bxTRYwvJcog7fD3a3aRvkSIYIrz0FpTG/bERQBLvxjaCU/Sqnqzkn6QbYhAvQqmf6XIW
         FyoluGhJYHwnZ1NBsqR9n6YzVubJ5NuEm1IYte8VuZ4jW8lwn3xUgQpwXaMKq2uSgH9g
         nAQNpkFEI5lUFufPJ6fD9Te4axcVbeQfLugwz0tWi45Ler4tmZY6wjHFMaPgbzgBNj+x
         3N7DW2fGKoOyKx1rWVeu9gPntqwqloFJLUVAoqA48sgT7Y6CxH4vmz7thoXU0GcrIsGy
         0wUg==
X-Gm-Message-State: AOAM5304HIFMx4ZmDlFavpx4OB7jRNB1uLIZTGL1EgEJUiF2+j0Hdc2M
        bOMfwr0JuWzlNsiYQ/x0DFXdAro/t7iL2g==
X-Google-Smtp-Source: ABdhPJwTAZSruMAB8r/F0xAtfgsPaDIaToqXknRPt2MxMzHNFsXtX+F967xZn+NIgBI/JAMB6MCaug==
X-Received: by 2002:a17:907:6e17:b0:6da:83a3:c27a with SMTP id sd23-20020a1709076e1700b006da83a3c27amr33351767ejc.415.1649765409959;
        Tue, 12 Apr 2022 05:10:09 -0700 (PDT)
Received: from localhost.localdomain ([213.174.17.16])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b006e8789e8cedsm3709174ejn.204.2022.04.12.05.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:10:09 -0700 (PDT)
From:   Vasyl Vavrychuk <vvavrychuk@gmail.com>
X-Google-Original-From: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Subject: [RFC PATCH] Bluetooth: core: Allow bind HCI socket user channel when HCI is UP.
Date:   Tue, 12 Apr 2022 15:09:45 +0300
Message-Id: <20220412120945.28862-1-vasyl.vavrychuk@opensynergy.com>
X-Mailer: git-send-email 2.30.2
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

This is needed for user-space to ensure that HCI init scheduled from
hci_register_dev is completed.

Function hci_register_dev queues power_on workqueue which will run
hci_power_on > hci_dev_do_open. Function hci_dev_do_open sets HCI_INIT
for some time.

It is not allowed to bind to HCI socket user channel when HCI_INIT is
set. As result, bind might fail when user-space program is run early
enough during boot.

Now, user-space program can first issue HCIDEVUP ioctl to ensure HCI
init scheduled at hci_register_dev was completed.

Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
---
 net/bluetooth/hci_sock.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 33b3c0ffc339..c98de809f856 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1194,9 +1194,7 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
 
 		if (test_bit(HCI_INIT, &hdev->flags) ||
 		    hci_dev_test_flag(hdev, HCI_SETUP) ||
-		    hci_dev_test_flag(hdev, HCI_CONFIG) ||
-		    (!hci_dev_test_flag(hdev, HCI_AUTO_OFF) &&
-		     test_bit(HCI_UP, &hdev->flags))) {
+		    hci_dev_test_flag(hdev, HCI_CONFIG)) {
 			err = -EBUSY;
 			hci_dev_put(hdev);
 			goto done;
-- 
2.30.2

