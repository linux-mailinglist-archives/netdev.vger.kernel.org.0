Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393AE4FDF33
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350557AbiDLMGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351230AbiDLMCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:36 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51903652F6;
        Tue, 12 Apr 2022 03:58:54 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ks6so11907313ejb.1;
        Tue, 12 Apr 2022 03:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cM7cNDbZdzDRR54XOLUdiPP1jrQ7jBG9dEAYVsbcNLE=;
        b=Dq5bCJRtJE/e5zpt/g8uhjtXlNwlyc03WzbQtD9O5T08zaWWGjT/Ag4jl2RIuRXgby
         Qwp1u9x/IB/Ce8Tr45SP1TAHER+/BcDWmUe1rY27Gvh6LjoodLltMn89thpgVkWeCzNg
         rqa57oY9y6kks3VOOo5Bt/lyTCqXhUw7SHfUjEfDpc0MOnBo7ayHkNlFz/W0nSRwnPSM
         CrrAOtLgT3H8lrbkk5yFPrIkAf058eIaUNe+Jx7oKA0AvzHA9Qvgw8EjkcuX4nXj1tRe
         jVAH1HjMl1CSS9c8ic4HOkcYXj/hvp8Ub278a1c0JTZmcJDOxO79xPUVK1J8PTb2H7wl
         0mEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cM7cNDbZdzDRR54XOLUdiPP1jrQ7jBG9dEAYVsbcNLE=;
        b=XX/ekewCcxjpLoxFokyRvMs9vwd42qVwDFSugNGa2/9oqI2HBAe5meFPM70IVPldY2
         FHD9YcKxPi8GGc0g/IWchO4gPezlkYE06NknZ1BqTK/y5K3LXrrtYTMiSOJ9uMDOBZOj
         6XBLGX+3DnIfYIg6g6V1MfLSCGFf52CGVx8dxhgDagS2r8qtfePiNIhqlR/MbfNWBS+d
         HgSgy/tmzt7B4WV5Tqe/cY8f2Ebj1mVUSigLKNJODp3mITdBPaWnH7kII2i4WHbQvgUg
         TK7/Xz08/z0EPpHswCPBqWF4k3yKisKj4vh2i5JO1pQVpCloOFLT3G3tMn/tl4Rpzpkd
         98xA==
X-Gm-Message-State: AOAM530cc5agXRMN4/Mr2oXS6Qtp/PcBawtnKWKLDIVWOgQaYyZFnQ85
        NDVdqsC5zMvjDqnaeBShmVM=
X-Google-Smtp-Source: ABdhPJz2dP0+jVOhmUNMBFBvhf2MPq5UcEvXEVs7zWdsz4lY7uM09/gGpZn4TgywcRiwfvine1dbHw==
X-Received: by 2002:a17:907:3f86:b0:6df:ad43:583 with SMTP id hr6-20020a1709073f8600b006dfad430583mr34406710ejc.535.1649761132855;
        Tue, 12 Apr 2022 03:58:52 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:58:52 -0700 (PDT)
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
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v2 01/18] connector: Replace usage of found with dedicated list iterator variable
Date:   Tue, 12 Apr 2022 12:58:13 +0200
Message-Id: <20220412105830.3495846-2-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412105830.3495846-1-jakobkoschel@gmail.com>
References: <20220412105830.3495846-1-jakobkoschel@gmail.com>
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

