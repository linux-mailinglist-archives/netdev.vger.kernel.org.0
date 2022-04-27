Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71792511E6E
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242387AbiD0QMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242119AbiD0QMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:12:01 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA7649157E;
        Wed, 27 Apr 2022 09:08:16 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l7so4396791ejn.2;
        Wed, 27 Apr 2022 09:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f1NofSwJuKbiTcVP4Eyds36Vn/5/VoS2zfBkRtVaGBU=;
        b=FMGbpYNN25F29l+OAZ0oU2BSV4UFQJQ8hALv0efMdnT1md03Ok8yKVBi1uKWmXTXYr
         8a9N8bN4djVpu+rhkHyFNvsW7gx582gKpIIKhML+MK8K+3O12xCutoBlK02J44kqEg9p
         FxMeGTrpDvinkZIEnIngkY0Q7JkNGcaS/bxLY5uu2ICywIuSjpgLHl0VL7EiP7CCymSZ
         sSn5E8X+YJyjuSjXYZ8D0DrNxo/9SZLC9+ii96+bsyqSnU7Ed9OH5SSGM/QEiT4TSXyM
         rkSYO4NHWuqn73Ql8mLCthpWscg4aPdcFDI2cCxtAKq7gLV4kgH6rvuF/haYkBEgILrA
         faaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f1NofSwJuKbiTcVP4Eyds36Vn/5/VoS2zfBkRtVaGBU=;
        b=vLmQu351uFc2yN20SCQasvkUopjAO4EZugKjhPomnUcF1C77Z0nVLqhcJtvV5D63o4
         qFLLzdN9exlgPqbXe4KHQFVl4EZyCQXA1RWZPTkAJrXNPyfnRx7QT6dJslZr2jfc7moU
         cNfZOdgQd+ZJ3eIkW9EgoUVq++sqkzD+l9hSCtpJrCXvhtum+reYkXLmmYS+9re13Py8
         g784P+AlWDCrgWiM2H4ng2p5epvak8lp2FcMnpHPOt4XGccf1wi/UbvruE+B1E1CtxR1
         uSPtrJmE4T8K9UYQBj+Exib5QibaMjbTZq+aa1XhnuGzjlwt2hHlWWl9NGtV3mHBm4JZ
         6+IQ==
X-Gm-Message-State: AOAM531nDbWYkE3rZ9+VECT+A8E2CgRjF8Xy5y7kLtFV3d/vJ4mE43+6
        5BC9edJY35p79lpx0nVwsus=
X-Google-Smtp-Source: ABdhPJwIhJiLJw69ilI7ZBKSX+zC1iXAarfAnk0c8Ge8xoFbIVAxNWeUGJZz0HlsPZ83L0cvGrZ8xQ==
X-Received: by 2002:a17:907:c0c:b0:6f3:8667:9be4 with SMTP id ga12-20020a1709070c0c00b006f386679be4mr18859070ejc.325.1651075646215;
        Wed, 27 Apr 2022 09:07:26 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:25 -0700 (PDT)
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
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v5 09/18] qed: Use dedicated list iterator variable
Date:   Wed, 27 Apr 2022 18:06:26 +0200
Message-Id: <20220427160635.420492-10-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220427160635.420492-1-jakobkoschel@gmail.com>
References: <20220427160635.420492-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

