Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1438B4FE106
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352683AbiDLMuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355267AbiDLMsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:48:09 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DB122293;
        Tue, 12 Apr 2022 05:16:23 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bg10so36959822ejb.4;
        Tue, 12 Apr 2022 05:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cM7cNDbZdzDRR54XOLUdiPP1jrQ7jBG9dEAYVsbcNLE=;
        b=dLGG+W1QjtHthDDhe+f38oZpmGxVOt8eok0rdcZmZGotUR9zQdPegeYKMvVVn6hhN8
         qALqEdKKNFIGUH/HxVhE21OebCrqrKHMzIYGsTB5yEGRljbDOMsMTyLG9yR0dWwY86qh
         zMJf4D5teJhK+o/3/TSV9rVZ6vpMgLcWjBGrVwtkw/9kEVxy6uZo+dM1QTZhM5/zPIG6
         ZiUdEbTmhE4U8OEgTBt6TEp+l0s0P1gPVwHjLBwdpt+N/HFRxSQyJ1LPJZv7nCJlarU6
         V4JNB5zawviACWFRP45EzqRiDHEUyVoR6F2/OjAOoeLW8M1Bf3abkJu4gBUNbFDMvZRg
         KhPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cM7cNDbZdzDRR54XOLUdiPP1jrQ7jBG9dEAYVsbcNLE=;
        b=2o6qBFN+z2yQWiNrJULDWWeNGx0X9YpgFjJAmMqI/PCW3NcYbq1OQeClK0+hTSCiXk
         B55DUgwehXrKwMqAYl55lY1nv0JEGguIOEv8k++yUBReo+uySVbGbYti+ooXY/K3HAhL
         41xIH9iD6SnFgw78aMbOPROlrPyhvZwcN3g8SUtjXJUYbaEM1coP+Y83nqZwCFitoZZF
         3er7kpP4xE89YT7GcZBXz2eZwXDWYg4ZBnrqMlfyXIDOE9WUkxExhYxzVEmemce/ERyH
         iiBGrLVOBygGDR3rLFnHQ/El111iI5K5CtyCtSHHNfyzSuLB7QoN3OBMcljPa03SJJRJ
         ZUHQ==
X-Gm-Message-State: AOAM532d88gweg/SflrfVcl2DXjS9ENJETCIWKuPNwBk3rKkOoA1Wc1S
        7xY6ss1BM3u2vXBYUYXeQ+g=
X-Google-Smtp-Source: ABdhPJwejWWXRfowCT/3hbJoVTDowE3vdhCQyrWd8hoMymr7vWLuQRkkwpkVy1n7H0R1bspGUXNqjg==
X-Received: by 2002:a17:907:6e0d:b0:6e0:59ae:21f1 with SMTP id sd13-20020a1709076e0d00b006e059ae21f1mr35335459ejc.362.1649765782495;
        Tue, 12 Apr 2022 05:16:22 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id b5-20020a17090630c500b006e8044fa76bsm8827900ejb.143.2022.04.12.05.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:16:22 -0700 (PDT)
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
Subject: [PATCH net-next v3 01/18] connector: Replace usage of found with dedicated list iterator variable
Date:   Tue, 12 Apr 2022 14:15:40 +0200
Message-Id: <20220412121557.3553555-2-jakobkoschel@gmail.com>
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

