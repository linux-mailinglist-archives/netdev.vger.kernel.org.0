Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC014F7CDA
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244394AbiDGKdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244292AbiDGKdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:33:14 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1730383B14;
        Thu,  7 Apr 2022 03:31:09 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x24so891331edl.2;
        Thu, 07 Apr 2022 03:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f1NofSwJuKbiTcVP4Eyds36Vn/5/VoS2zfBkRtVaGBU=;
        b=mPVBrjNDRSKFnXBMjokClolP1gEqY1f/xNBXpmGUphbGpB86gSOCxQ36CB3FM/eiSJ
         wS6Oq6p6OOEp2onWQFVvJfzHdDVgU5bhd0XCuop5GfAiPYRGakMDZECfd+gruNOQC1Ge
         PxxACeDIhJvtKRA5qdzwIpJlPWLC0H5MfHABv80edUIN+HSDRJfOwMzzCqgZvCnYSelJ
         xRQdIckbsBzYUjsESqCIR7w5Q9oT+83Xgd0J+1FEZ2pj0LeKzxs/lR2wx9wVfizJCkbB
         VUvsxW7NV6nZ4ER1ZxSao5e/dZhFrAZTVjRRP5Gv4ON3wQrlZ6XfoyO4+bnzr9NNzzOX
         DSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f1NofSwJuKbiTcVP4Eyds36Vn/5/VoS2zfBkRtVaGBU=;
        b=bE36+upsQFsAh0I6Tx6/kLtC5jf/Tb3qSmoWgnbmTMq261CmVA/mK1MsMiYlyrHCq6
         saZxMyi5zIXISMLuh4JN4P6A7cPBwg+Z3Nz8ZGuM7un1lChG2MRaYIy/Cb05lnkDe5iG
         3SOZ1zhjj5IEUUBqfJgsfbxd3b6hHpVeYNTgF2M2LkIWvcOJM8UOFLJbe7n9jRGNAB0T
         j9eTEfD4C9wG7lxwzaKttnNb8U56DX/8gY7RpkEc8yWD6sG3SgaMhp9C58+jNYMWjZlZ
         rz4tbTNbHWf0WxwoyDbDgL6zGqLKXr9yNQppF//3rdC7esiDRhmNh7yUTAiauBu0hP4J
         he7A==
X-Gm-Message-State: AOAM533vUb/lWj8i/iz6BOluONsOB7ywU8CrOR3GHPbJ/HbCyZXDVjr7
        3XkxZgHZsUrwOqwl5rsdw2Y=
X-Google-Smtp-Source: ABdhPJxhyOLOUaA05vo+Xl63Y34SMUPml4tHedyJPbBGpSZT1vRmx0YR+uDsfyLsMnlqwc+LyQPpyw==
X-Received: by 2002:a05:6402:350d:b0:419:547f:134a with SMTP id b13-20020a056402350d00b00419547f134amr13733726edd.405.1649327468259;
        Thu, 07 Apr 2022 03:31:08 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm7413573ejz.57.2022.04.07.03.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 03:31:07 -0700 (PDT)
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
Subject: [PATCH net-next 06/15] qed: Use dedicated list iterator variable
Date:   Thu,  7 Apr 2022 12:28:51 +0200
Message-Id: <20220407102900.3086255-7-jakobkoschel@gmail.com>
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
concluded to use a separate iterator variable [1].

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 672480c9d195..e920e7dcf66a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -174,7 +174,7 @@ int qed_db_recovery_add(struct qed_dev *cdev,
 int qed_db_recovery_del(struct qed_dev *cdev,
 			void __iomem *db_addr, void *db_data)
 {
-	struct qed_db_recovery_entry *db_entry = NULL;
+	struct qed_db_recovery_entry *db_entry = NULL, *iter;
 	struct qed_hwfn *p_hwfn;
 	int rc = -EINVAL;
 
@@ -190,12 +190,13 @@ int qed_db_recovery_del(struct qed_dev *cdev,
 
 	/* Protect the list */
 	spin_lock_bh(&p_hwfn->db_recovery_info.lock);
-	list_for_each_entry(db_entry,
+	list_for_each_entry(iter,
 			    &p_hwfn->db_recovery_info.list, list_entry) {
 		/* search according to db_data addr since db_addr is not unique (roce) */
-		if (db_entry->db_data == db_data) {
-			qed_db_recovery_dp_entry(p_hwfn, db_entry, "Deleting");
-			list_del(&db_entry->list_entry);
+		if (iter->db_data == db_data) {
+			qed_db_recovery_dp_entry(p_hwfn, iter, "Deleting");
+			list_del(&iter->list_entry);
+			db_entry = iter;
 			rc = 0;
 			break;
 		}
-- 
2.25.1

