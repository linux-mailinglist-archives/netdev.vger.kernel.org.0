Return-Path: <netdev+bounces-1135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C862D6FC50F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A6E1281205
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5073217ADE;
	Tue,  9 May 2023 11:35:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4234A17ADD
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:35:23 +0000 (UTC)
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF9330D2;
	Tue,  9 May 2023 04:35:21 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f122ff663eso6445703e87.2;
        Tue, 09 May 2023 04:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683632119; x=1686224119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rbkI5NmwcrpI7Tje+0YGtVpuM20p51DDt0R9mEUMkGo=;
        b=iw0rSsRolEB5fcb1p+xNJhOEdDLAJa+ATnHCa0O+77TWWDGr1x5ufaNs08BChkoQ7K
         udgVvcX8F+R0B4ebCJ7cW/focSGQS71wUJnkipeT1bX/Dmec/pE8n0UazwgSEHM9ZRif
         omj3c0fwoBOb5oGvNVMACVBpWIpW8j29jEsHka/8ortL4cXCwl7tMrKTbVfE6brnBu4L
         2AVxfipHGS57Q9OXuuUOxMIbmiMiB8c0zGTtsvi1CQTxVdNjaaWn0mU9LaGURYcMa/yA
         EK25ji2YBaZSGG27mArhQGyHIxXX0yl53DIFefFZee1flg6Rp9MMHLKUwiWBW8OczDvN
         THTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683632119; x=1686224119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rbkI5NmwcrpI7Tje+0YGtVpuM20p51DDt0R9mEUMkGo=;
        b=ejF7s/AZQV2ROIT6D/3l8uI8UzbcEv9J5zZCyOMNbghpw6Bbr46ju84aExLzfVS9a8
         /2o5fAY/+4CseOwIEGNaLdiqXUzkcXYoMp1pN/zOMsJiajQP2n//ERddCejR0myBJKyg
         r7J1UW9r+89Bul/vr7hscVDs7USRaKefkjooBpzplRI2Gp/W5fxhWXRvBW+6Etn0eDe2
         jvZJim+wMuysV0agSrfx8HbKfC8b3ePKbW1uipT+too2i3cMoLDQwSpEtmHdiLLkBjgc
         n88swoZrqn9YEjRk6h6bL57Y852UI7V1+42rzFVZYhPKwUTIsDIkv2Krguif5tkbwwGD
         n3Kw==
X-Gm-Message-State: AC+VfDw0J6N2VoOzWog3aZWNvP/YSd9Iwl37BzuXhtwwnn6CqDc7bzn+
	kyiOg9l4dWb/gcrGD3971hQ=
X-Google-Smtp-Source: ACHHUZ7SGF4LClRs/QE8T9m+zaDb2DYiF6XKALpXn5c53WZ7SBsib2YNkQAZnuDJ6RG/0PZqo56rdg==
X-Received: by 2002:ac2:562f:0:b0:4f1:3d6c:d89b with SMTP id b15-20020ac2562f000000b004f13d6cd89bmr607190lff.42.1683632119511;
        Tue, 09 May 2023 04:35:19 -0700 (PDT)
Received: from localhost.localdomain (93-80-66-133.broadband.corbina.ru. [93.80.66.133])
        by smtp.googlemail.com with ESMTPSA id k16-20020ac24570000000b004f25ccac240sm108940lfm.74.2023.05.09.04.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 04:35:18 -0700 (PDT)
From: Ivan Mikhaylov <fr0st61te@gmail.com>
To: Samuel Mendoza-Jonas <sam@mendozajonas.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	openbmc@lists.ozlabs.org,
	Ivan Mikhaylov <fr0st61te@gmail.com>,
	Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH v2 2/5] net/ncsi: change from ndo_set_mac_address to dev_set_mac_address
Date: Tue,  9 May 2023 14:35:01 +0000
Message-Id: <20230509143504.30382-3-fr0st61te@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230509143504.30382-1-fr0st61te@gmail.com>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Change ndo_set_mac_address to dev_set_mac_address because
dev_set_mac_address provides a way to notify network layer about MAC
change. In other case, services may not aware about MAC change and keep
using old one which set from network adapter driver.

As example, DHCP client from systemd do not update MAC address without
notification from net subsystem which leads to the problem with acquiring
the right address from DHCP server.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
---
 net/ncsi/ncsi-rsp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 91c42253a711..069c2659074b 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -616,7 +616,6 @@ static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
 {
 	struct ncsi_dev_priv *ndp = nr->ndp;
 	struct net_device *ndev = ndp->ndev.dev;
-	const struct net_device_ops *ops = ndev->netdev_ops;
 	struct ncsi_rsp_oem_pkt *rsp;
 	struct sockaddr saddr;
 	u32 mac_addr_off = 0;
@@ -643,7 +642,9 @@ static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
 	/* Set the flag for GMA command which should only be called once */
 	ndp->gma_flag = 1;
 
-	ret = ops->ndo_set_mac_address(ndev, &saddr);
+	rtnl_lock();
+	ret = dev_set_mac_address(ndev, &saddr, NULL);
+	rtnl_unlock();
 	if (ret < 0)
 		netdev_warn(ndev, "NCSI: 'Writing mac address to device failed\n");
 
-- 
2.40.1


