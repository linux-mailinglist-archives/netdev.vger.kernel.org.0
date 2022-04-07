Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33C24F7CCB
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244272AbiDGKdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244265AbiDGKdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:33:04 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D202063BEE;
        Thu,  7 Apr 2022 03:31:03 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a6so9996541ejk.0;
        Thu, 07 Apr 2022 03:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cM7cNDbZdzDRR54XOLUdiPP1jrQ7jBG9dEAYVsbcNLE=;
        b=kTFV0s1DjklFKRy0TxWbeuj3zyRHFlGqWxH8nk8PEziPdH89zJ1oEWCvPebSyljT7t
         35la7ZWPkDDKsLVhEAApa9g88yhD63+pyT8BlwBuYAPTEgueqtF1sdFEWR5UcBp65VMx
         HOLWtbTxXIBd2kSmcA4s8II/S+vr3eEeHlitrPYWKGN9NvHT7aQc98MiahddFrObEkRX
         oqgXKsIRyM/+oWEyboW7eQT08MSgJs1f2RKCWSGK2HrAZG1DcfurHSRM8THpWtIME5Ml
         efjWAnlzN/ExmS0f440FnRzvRPuBSY3nLe3+faUuHbLFeXj3B2TITC0/8tWm+brWuhH6
         Gbbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cM7cNDbZdzDRR54XOLUdiPP1jrQ7jBG9dEAYVsbcNLE=;
        b=I0YtiX0nsTXQo8oJvLCoNlHny3X/iQEWFV2dLJUIImQuyoqTbDDOZwQD4Jwyuf3Gu1
         neysuTI8S+/D+KY/I/KHTtxCGYA7Eciwsh+g1lTAVVNwkbCTzLHglh6EsAhiBhnFVj3f
         lKU/IF7rTbFrzmoqsFE2YtGRdI5s2l8Yuj+8+iYP3HYDOQQkIWRnvTvnBLeQwrYtxaxk
         /rTxoqUV1AQxDcbmtH860E7y4WYPPmoLZBXVjktyOX3rc0DihBCUPfHDrt5Oh8kEt/9i
         k86v0Uz5NGKA47MnPNbpgHCHoIMeD54tFoB8W8q4Fcav8DIXhfw+xoZiYvUmttFfh9nl
         LwHA==
X-Gm-Message-State: AOAM530RhxFPpvfVDGS8uk79QCYNQxjvlPahWzjJEnLHmcFOECMFrZ5x
        KaLoDCcXD48xRevUS1QvI4c=
X-Google-Smtp-Source: ABdhPJx0s8F+/Psbc0WRtBOGXMMQgcpVlU8uStqX8d6g32cAFKeTa6M6kXCz4rf1z38mgVMSQlqn+g==
X-Received: by 2002:a17:907:1624:b0:6db:8caa:d71 with SMTP id hb36-20020a170907162400b006db8caa0d71mr12894106ejc.723.1649327462239;
        Thu, 07 Apr 2022 03:31:02 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm7413573ejz.57.2022.04.07.03.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 03:31:01 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next 01/15] connector: Replace usage of found with dedicated list iterator variable
Date:   Thu,  7 Apr 2022 12:28:46 +0200
Message-Id: <20220407102900.3086255-2-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407102900.3086255-1-jakobkoschel@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
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

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/connector/cn_queue.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 996f025eb63c..ed77599b0b25 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -92,20 +92,19 @@ int cn_queue_add_callback(struct cn_queue_dev *dev, const char *name,
 
 void cn_queue_del_callback(struct cn_queue_dev *dev, const struct cb_id *id)
 {
-	struct cn_callback_entry *cbq, *n;
-	int found = 0;
+	struct cn_callback_entry *cbq = NULL, *iter, *n;
 
 	spin_lock_bh(&dev->queue_lock);
-	list_for_each_entry_safe(cbq, n, &dev->queue_list, callback_entry) {
-		if (cn_cb_equal(&cbq->id.id, id)) {
-			list_del(&cbq->callback_entry);
-			found = 1;
+	list_for_each_entry_safe(iter, n, &dev->queue_list, callback_entry) {
+		if (cn_cb_equal(&iter->id.id, id)) {
+			list_del(&iter->callback_entry);
+			cbq = iter;
 			break;
 		}
 	}
 	spin_unlock_bh(&dev->queue_lock);
 
-	if (found)
+	if (cbq)
 		cn_queue_release_callback(cbq);
 }
 
-- 
2.25.1

