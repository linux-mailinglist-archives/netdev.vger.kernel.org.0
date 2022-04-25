Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D868250D74C
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240514AbiDYDEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiDYDEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:04:10 -0400
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7B61B7BD;
        Sun, 24 Apr 2022 20:01:06 -0700 (PDT)
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 6E6E2C13B4;
        Mon, 25 Apr 2022 03:01:05 +0000 (UTC)
Received: from pdx1-sub0-mail-a217.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 98D18C15B2;
        Mon, 25 Apr 2022 03:01:04 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1650855664; a=rsa-sha256;
        cv=none;
        b=H9YMoe/idniQ4oRp9Q6cTnJUHzUf0nEAmLqRz2/zJNVBcVjQc9fxBRsxt3XyEVjIpUykph
        Xj2yFner+wwkb+0WOAOeg7gk9L5h4VA6J5boQEulI8eu0TA7iX8KGJKVqLnzsorqNq+rug
        rCRG9ZbQ5eG/n2DNmBnPPUXkHY/oHAhg5LawAAUg2lYfbGNgjhQ4XvDg4pUyRR4OPzYYIn
        Crb+SuSn7dT/pvYYF9dSiaOvLcnpv3n6ZG0lQyqVolnXSKQcm+3wVbUJ1sAc0rAcmyLgA9
        Dr75+tGuzymOuOnyU2wnUHdjNWVoqB8TEYI4akknfAMTQO2ussSSNF1OriAoAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1650855664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:dkim-signature;
        bh=FnZ8llSJWkl2FqoEfQdnZQWLmuu+j68/tH7/8sZn3UY=;
        b=TGbEm/JiTeLA8E2OINRL3m+y2CBEOvCQON2tx/bLEzyDbnXed+rFINuJto6L/S1IQ6Z68w
        ke8TbjiObgPLkx6mLshRa4O4JSlzhREvJePtRtd8A42Ii04TjDc10tMB7+T2L0KT95Xx02
        OXALCw0CWNkSgZ3szMyf3EzXzUP2nC/qogAgsqqusDbZiG/tYqejf+YM47chcfF247N+ug
        d1UBtB8hWGRAulLVROZkkp8VT7QOZBAZ7xgaFQu9+PH2H7fM/vPPDbNodTb0l/65x1ObMa
        PNvrsbbxTk1zkwz67BmxCyNwF6Oeb07cP932woFb1vhDjlbKWSzLa/Hwx2oDkA==
ARC-Authentication-Results: i=1;
        rspamd-6dfbdcb948-4k72z;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=ian@linux.cowan.aero
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|ian@linux.cowan.aero
X-MailChannels-Auth-Id: dreamhost
X-Bottle-Arch: 39d2fbac15c5e251_1650855665044_2609463641
X-MC-Loop-Signature: 1650855665043:2074948883
X-MC-Ingress-Time: 1650855665043
Received: from pdx1-sub0-mail-a217.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.116.106.102 (trex/6.7.1);
        Mon, 25 Apr 2022 03:01:05 +0000
Received: from localhost.localdomain (unknown [69.12.38.97])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: ian@linux.cowan.aero)
        by pdx1-sub0-mail-a217.dreamhost.com (Postfix) with ESMTPSA id 4KmqXH3M74z2n;
        Sun, 24 Apr 2022 20:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.cowan.aero;
        s=dreamhost; t=1650855664;
        bh=FnZ8llSJWkl2FqoEfQdnZQWLmuu+j68/tH7/8sZn3UY=;
        h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
        b=siVSzLaEaaqZT/RAhNBylm4r5vV8JuOFCeG1sURL8AdbRiCzRrK+19KSq7aL2ienI
         3a+BxU0wc2KXC6txjBN5UmMk4ot26YrxYU4EL6oytvRs1fWsMvrB171iaHD9q+aPcA
         +Q/IdORkxLg8eufTGAuLMx/fc875DeZ+NJswTiZtbgAG+jba5bvXl6CVZgsor1QOzt
         SPQHNV+e6q0i2gCyQi7FTnDZ5icniPzYtPMo7c15BVZMAgPTp6NhnFiocbiMPe+Sp6
         5y63n74rjw1vH7P3Ii8W71f6xBaRXJyF17Uzi7OVKLuQHoS7FROATvetQUueOeKyAz
         SLU7UvPGcJlVg==
From:   Ian Cowan <ian@linux.cowan.aero>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ian Cowan <ian@linux.cowan.aero>
Subject: [PATCH] drivers: net: bluetooth: centralize function exit and print error
Date:   Sun, 24 Apr 2022 23:00:53 -0400
Message-Id: <20220425030053.517168-1-ian@linux.cowan.aero>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Centralize the return for this one function, and this will add the error
being printed if it occurs earlier in the function. The same thing will
be returned with the logic, so the only thing that will differ is an
extra debugging output for an error.

Signed-off-by: Ian Cowan <ian@linux.cowan.aero>
---
 net/bluetooth/6lowpan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 215af9b3b589..15928e9ce088 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -516,7 +516,7 @@ static netdev_tx_t bt_xmit(struct sk_buff *skb, struct net_device *netdev)
 	err = setup_header(skb, netdev, &addr, &addr_type);
 	if (err < 0) {
 		kfree_skb(skb);
-		return NET_XMIT_DROP;
+		goto output_error_ret;
 	}
 
 	if (err) {
@@ -537,6 +537,7 @@ static netdev_tx_t bt_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	dev_kfree_skb(skb);
 
+output_error_ret:
 	if (err)
 		BT_DBG("ERROR: xmit failed (%d)", err);
 
-- 
2.35.1

