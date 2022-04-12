Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF714FE0D7
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353872AbiDLMt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355291AbiDLMsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:48:09 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA69F2AC7;
        Tue, 12 Apr 2022 05:16:36 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id lc2so16362168ejb.12;
        Tue, 12 Apr 2022 05:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f1NofSwJuKbiTcVP4Eyds36Vn/5/VoS2zfBkRtVaGBU=;
        b=JY2M2qyYMNvlIFgXmys3XY0z12J+fL1720nfDwyxDRVA9EXHvDxx+VbsFgYy7KXlXd
         JjT89tBtcK6CsGsLvA677XhaUYsPtodteSbo31yrgiXwi1FUAe5X+uYl6RrLm+NPrK32
         W/v7FaBhvVpO++0e5C4oa3XUf4MHQ0R7Qq0K+x7ujqkziBO9ePeML+g0DAvwlPBy9uuO
         OquPnOeYkjvyvrVHvXX8Mcwg1txh4XfQ2bxKOMp8L4b++TDyEOM5iGoeVW9xZccJmQtb
         HlVcifuFVKT+/lheVnRDMZAf+jMrnIb2IuSeJQsMMnmpyc8MZU0EiEzPSlVdtdusLb+t
         gFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f1NofSwJuKbiTcVP4Eyds36Vn/5/VoS2zfBkRtVaGBU=;
        b=S4gfrJE1yxd8ZIhbYPZIpMl14OuluhSDxcmcL1LgwZY+MA2VsjxAXKmqmWQ+wkLNMC
         RjMUgdzi+AU6JHbFxm5BaCUeBnXWUCi1RkZE4pW5/5T3NUTGWFbV6CLlRNFkJS1FWaN0
         RqaDQQ3opQwZVAbLdawyMZoEMta/ex1aOWTvAeWrD1tpRwt+uhQ+YyU5Qfeffe2+mksr
         pkmOx5ocp4rzJnKFfR8O+/Oc4MZomzDik0Z3X4Ih5jzcyteFtdUPAWjtqcd3t2Q9NGjA
         NiYG8dC9bGxjrlvscdIUA4nSZBWZ/7GQEnNbRfJ+4NKnPCxhLmLh3utIww1iVMG72pNs
         ew+Q==
X-Gm-Message-State: AOAM530NGx96j7B4u0DJpUa4sJyBmArffS8k6w3cY4295lbkrXyglOmv
        aNNp44TD9j0mIMMKQgDPWdp0udxVF6kvgA==
X-Google-Smtp-Source: ABdhPJx9M2U5f+VWrOuC6VqrvwzsR4p8wVKeyNiGyD4oU2HW5aTF7KLjuk3d0VHU15agYYhPiBGLow==
X-Received: by 2002:a17:906:31c2:b0:6e8:6e8b:cbe4 with SMTP id f2-20020a17090631c200b006e86e8bcbe4mr10312040ejf.293.1649765795398;
        Tue, 12 Apr 2022 05:16:35 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id b5-20020a17090630c500b006e8044fa76bsm8827900ejb.143.2022.04.12.05.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:16:35 -0700 (PDT)
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
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Michael Walle <michael@walle.cc>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v3 09/18] qed: Use dedicated list iterator variable
Date:   Tue, 12 Apr 2022 14:15:48 +0200
Message-Id: <20220412121557.3553555-10-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412121557.3553555-1-jakobkoschel@gmail.com>
References: <20220412121557.3553555-1-jakobkoschel@gmail.com>
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

