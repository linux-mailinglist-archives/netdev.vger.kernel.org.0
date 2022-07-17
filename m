Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40DD577663
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 15:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiGQNiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 09:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGQNiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 09:38:15 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA64613CCF;
        Sun, 17 Jul 2022 06:38:14 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y15so2197434plp.10;
        Sun, 17 Jul 2022 06:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pjCptrwTCqzyeOFeqcjeBA84+aupixrF+Oo0LbeI1pA=;
        b=D8MVRPT8Eb3HOVIq+fyV26qLXpi3Zy/EAKcQbh9oVpIobBFwBWKecS4bDBRio8cg6N
         V3vDXu80PjakXJM12wXxipbS+T2rgwnHcRzrFmj/vfp0FRPM/TZcUd2j6ai6ztPl/dla
         /xNGAUEQktbnjz6pwVLz5SFgmdOmnxEInGv2Lg2zscmDls6wgtqAmMSs8c4QdDBHHwSu
         hyukifsrUsJdewr5wIYSIezsSkTM6FTN8GYfTXVYlTtmbtBNC5jrdjZjhtCazWkF2E58
         h6lO1qA4uOs6p6pyxafaO5xnFBXCryWdUHwfaqQVGGQGNwwloGqweU7c0AJrRTyWlE6l
         WpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pjCptrwTCqzyeOFeqcjeBA84+aupixrF+Oo0LbeI1pA=;
        b=2ZvTfxR3/fjFkG57xB0wssCfXKpszzik4r+TSYi8aHUEEScncKkJgC6NFFbGTMbeig
         eoMSEBWTtUlmJ6el2VU+8cp1l2KRftEYBYRaQQvlxASm40lspt9LzseAIXz0gLZa8Q/k
         xEyfqx4UYMTus+lpLuGq+c7FU4UfefF6B3wPXVDH3LHnL/EBKG1CE8CjShPGpWoej3Oi
         xj7cm/dCS+js4H2TIivqPO/nfUSi8tZFPwjX6ju/VWknMmnLX1uqbgPc1I17Ev8R2Bmy
         GfBML+iCFPkFlF03BUEFfEUUN9O7Pv8AdRlFjsM1VFMnIw4tOV1Q4e/DXjekBuDXJCcK
         r6vQ==
X-Gm-Message-State: AJIora+TbSN0VALeNoo2/lmSCP83CnoUqqa6Tm/9uOuLU6Ev3Ld5xgBs
        aOM1/dKogJsVhijeZ+Dxuno=
X-Google-Smtp-Source: AGRyM1u3D5EsZy5ThFn9Gz06wyR2U7uyzcynnndletJOt8PrBO5LQm0fCb7NVZ1yb/88RWcymkKJIw==
X-Received: by 2002:a17:90b:3807:b0:1f0:a86:6875 with SMTP id mq7-20020a17090b380700b001f00a866875mr33281553pjb.103.1658065094159;
        Sun, 17 Jul 2022 06:38:14 -0700 (PDT)
Received: from fedora.. ([103.159.189.134])
        by smtp.gmail.com with ESMTPSA id r16-20020aa79890000000b005254e44b748sm7279166pfl.84.2022.07.17.06.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 06:38:13 -0700 (PDT)
From:   Khalid Masum <khalid.masum.92@gmail.com>
To:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Khalid Masum <khalid.masum.92@gmail.com>
Subject: [PATCH] Bluetooth: hci_core: Use ERR_PTR instead of NULL
Date:   Sun, 17 Jul 2022 19:37:58 +0600
Message-Id: <20220717133759.8479-1-khalid.masum.92@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Failure of kzalloc to allocate memory is not reported. Return Error
pointer to ENOMEM if memory allocation fails. This will increase
readability and will make the function easier to use in future.

Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
---
 drivers/bluetooth/btusb.c | 4 ++--
 net/bluetooth/hci_core.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index e25fcd49db70..3407762b3b15 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3692,8 +3692,8 @@ static int btusb_probe(struct usb_interface *intf,
 	data->recv_acl = hci_recv_frame;
 
 	hdev = hci_alloc_dev_priv(priv_size);
-	if (!hdev)
-		return -ENOMEM;
+	if (IS_ERR(hdev))
+		return PTR_ERR(hdev);
 
 	hdev->bus = HCI_USB;
 	hci_set_drvdata(hdev, data);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index a0f99baafd35..ea50767e02bf 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2419,7 +2419,7 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
 
 	hdev = kzalloc(alloc_size, GFP_KERNEL);
 	if (!hdev)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	hdev->pkt_type  = (HCI_DM1 | HCI_DH1 | HCI_HV1);
 	hdev->esco_type = (ESCO_HV1);
-- 
2.36.1

