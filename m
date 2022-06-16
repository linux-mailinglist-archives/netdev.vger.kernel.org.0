Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1212C54EA1C
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378343AbiFPT0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349272AbiFPT0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:26:36 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A22E56402
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 12:26:35 -0700 (PDT)
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 571763FC11
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 19:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1655407594;
        bh=mpcbj81gs3lEl2jN5MD+Z1yD+aEBWzf2rIgd59qTTXU=;
        h=From:To:Cc:Subject:MIME-Version:Content-Type:Date:Message-ID;
        b=DFaYzhzAwJiXgHFbDJd6id+tQ3zLx95OfHE1RX3bGrZVnTG+JAn7aUq1jKBAZknc7
         OcChi/sUoRe09ypouoYkpBXYiDkFRSw3FmBNiAnZe+rFYtUxiwGk+C9k4uSB/I3nJh
         yj2NmEtGM3MTMcejcUgevSqLXdA+4ZWkOT6AlfBcjLTWPaVV/6fjQCMV1wQQWeOLpF
         vzxeC2NJEV56Lt9lstVCm/CIsbuS57XbS5jXwh8Zt5Yk1fGMpguTBiAXTP9i9vVNIl
         art1abMEE5l28//z/lporkszJuyS2zMPtc53l+QT8OQldOjqwfVQud+Ox3nWifkifk
         VtwApuYciXhEQ==
Received: by mail-pg1-f199.google.com with SMTP id w70-20020a638249000000b00406e420acfdso1138834pgd.2
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 12:26:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:mime-version:content-id
         :content-transfer-encoding:date:message-id;
        bh=mpcbj81gs3lEl2jN5MD+Z1yD+aEBWzf2rIgd59qTTXU=;
        b=gOV7LgD953TXARzIgOypcZdBlGUe4JCvIHzwbwuh6Nn9LxzPzzP2Z/UmNxflLJq6qx
         Ep0vbxJeZ98eMrVkYmc6YXHAlgEdRJtiHDmKQptapvdpwuS/tp2yLR56wVMJHgmIWVzq
         +ZBFtnAOW18f1SB+3EMUwA451a4+8dyKt3Gz8s7OZ5CPqsCb0+6c0VI5gOEX6BcxMd4W
         AFf82Vk62Rk41wY8NJqg4gZ5VPKGyRWIl9hXKphAcsxie1PSa8J9vSCyKAx8Dr2WbAu+
         rJe5U+2CNkhfpWu526DxkKWS76hvOkYwur/aaE5a3Lng9qHBEBtmZHymjRVX6tkkIftE
         aT9Q==
X-Gm-Message-State: AJIora/nIiSSeumnlNdrl5CjJg4X2LMqStMyBiTq26a4x7P1dI/6vxto
        Zn/FSWMnYlksvsrbL7BeYyEUv/MTeOkdmygtZeqw9Vej35F2q0dJHIASG3kbZ3AjUeGgknxb29/
        fd/KlDEN3U0Gy++UsnYzuGYIYsOAu1nmEJQ==
X-Received: by 2002:a17:90a:e685:b0:1ea:f5c0:7e62 with SMTP id s5-20020a17090ae68500b001eaf5c07e62mr3508044pjy.8.1655407591686;
        Thu, 16 Jun 2022 12:26:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sMXAzLplmpCJzEGjvacTybZhzJg4Oft7kfXXb+Sz0Fz+XqN67ARgbrRw3pTJuvzRiYMFXtwg==
X-Received: by 2002:a17:90a:e685:b0:1ea:f5c0:7e62 with SMTP id s5-20020a17090ae68500b001eaf5c07e62mr3508023pjy.8.1655407591435;
        Thu, 16 Jun 2022 12:26:31 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id s14-20020a63770e000000b003fad46ceb85sm2205137pgc.7.2022.06.16.12.26.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jun 2022 12:26:31 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id B9CDC6093D; Thu, 16 Jun 2022 12:26:30 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id B3003A0B36;
        Thu, 16 Jun 2022 12:26:30 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH net] veth: Add updating of trans_start
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9087.1655407590.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 16 Jun 2022 12:26:30 -0700
Message-ID: <9088.1655407590@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Since commit 21a75f0915dd ("bonding: Fix ARP monitor validation"),
the bonding ARP / ND link monitors depend on the trans_start time to
determine link availability.  NETIF_F_LLTX drivers must update trans_start
directly, which veth does not do.  This prevents use of the ARP or ND link
monitors with veth interfaces in a bond.

	Resolve this by having veth_xmit update the trans_start time.

Reported-by: Jonathan Toppins <jtoppins@redhat.com>
Tested-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Fixes: 21a75f0915dd ("bonding: Fix ARP monitor validation")
Link: https://lore.kernel.org/netdev/b2fd4147-8f50-bebd-963a-1a3e8d1d9715@=
redhat.com/

---
 drivers/net/veth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 466da01ba2e3..2cb833b3006a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -312,6 +312,7 @@ static bool veth_skb_is_eligible_for_gro(const struct =
net_device *dev,
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct veth_priv *rcv_priv, *priv =3D netdev_priv(dev);
+	struct netdev_queue *queue =3D NULL;
 	struct veth_rq *rq =3D NULL;
 	struct net_device *rcv;
 	int length =3D skb->len;
@@ -329,6 +330,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, stru=
ct net_device *dev)
 	rxq =3D skb_get_queue_mapping(skb);
 	if (rxq < rcv->real_num_rx_queues) {
 		rq =3D &rcv_priv->rq[rxq];
+		queue =3D netdev_get_tx_queue(dev, rxq);
 =

 		/* The napi pointer is available when an XDP program is
 		 * attached or when GRO is enabled
@@ -340,6 +342,8 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, stru=
ct net_device *dev)
 =

 	skb_tx_timestamp(skb);
 	if (likely(veth_forward_skb(rcv, skb, rq, use_napi) =3D=3D NET_RX_SUCCES=
S)) {
+		if (queue)
+			txq_trans_cond_update(queue);
 		if (!use_napi)
 			dev_lstats_add(dev, length);
 	} else {
-- =

2.29.GIT


