Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193EE511D26
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242006AbiD0QNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242278AbiD0QMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:12:03 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F93496526;
        Wed, 27 Apr 2022 09:08:20 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id y3so4326522ejo.12;
        Wed, 27 Apr 2022 09:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0WZ3VKnVxGM80qdLHkweZkrBfRptzeVUXSKm7/OGDn8=;
        b=iYefV4x4cS2P5G6zvG61cBj8T2py/pIo/pjs0Q9iTwQdWI8zdKVZ+iw8xHm0OF578N
         Uzt26JvfjZUW2E1xhbuyxsNYSzvthUBdnuF7xbo5yMRhTPUU4f4qkkZKiTb7iQaf/WhB
         /NVvWxQ9VRsNlqNb2A8Lm2FeT/6uTp7jNqoJFVbdG6i7s68Fxz+UPfFnm2U+cuBS/lO0
         YzSgsu0XtaWbRV9GWi9ix5UU4FqVq6EGD6xZu53Wc6vh7oEaiIDzsI1ZtAezpWGlAJ6Y
         gdmp7zSN6Cik+iMJNUTOlzUx56lUG//1VO4MJDNdjOhY5M5juk1C594Gn81ZHlvaE9IO
         Zppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0WZ3VKnVxGM80qdLHkweZkrBfRptzeVUXSKm7/OGDn8=;
        b=vYqw6vIApgx/em1jll91Zsa6v9Iw5EKbYSEwwh//fjxPi7kfBKbIoAQHGm59Rue0xc
         mQXLocxRD4vSpyy8upWanhlq/1Q3dzDJqZM9kS/PjCxuGO2J+jD9JUyJc9elSWmpqDez
         YkK1YkSZQZTYj2gk6aMBMZxruMN/zXpSHjEm8c7GxT8yAi2637TJoBzgGIp8mwHMBH3/
         gifWp8uzhlmjN203EhEIiyNGw2fdHtB7qVMlkt5XFWdYySOp2BfNuZrSiPo9kfYLnAaA
         eirzcf8897hM/iNjt4/omAEoP5rOl6HSkMV8fE/hVYvmERIRIhomvufNCgFlhfOCmCk0
         2Qmw==
X-Gm-Message-State: AOAM532nSoZhLm/S4jREZKfyCwHBM7axzAxgThyuzoOY6URiYjdG20He
        jXjucBhhvRtAdaGe1PRiVB4=
X-Google-Smtp-Source: ABdhPJzxkWZJssycANRkME55YZz1X8TDc5voDlGllps54WeGD9LALQXZ3eiyQ26eO0/xVC/EDO0p3g==
X-Received: by 2002:a17:907:7ba3:b0:6ef:f9ca:f2da with SMTP id ne35-20020a1709077ba300b006eff9caf2damr16508279ejc.634.1651075650148;
        Wed, 27 Apr 2022 09:07:30 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:29 -0700 (PDT)
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
Subject: [PATCH net-next v5 12/18] net: qede: Replace usage of found with dedicated list iterator variable
Date:   Wed, 27 Apr 2022 18:06:29 +0200
Message-Id: <20220427160635.420492-13-jakobkoschel@gmail.com>
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
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/ethernet/qlogic/qede/qede_rdma.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_rdma.c b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
index 6304514a6f2c..2eb03ffe2484 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_rdma.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
@@ -246,18 +246,17 @@ static void qede_rdma_change_mtu(struct qede_dev *edev)
 static struct qede_rdma_event_work *
 qede_rdma_get_free_event_node(struct qede_dev *edev)
 {
-	struct qede_rdma_event_work *event_node = NULL;
-	bool found = false;
+	struct qede_rdma_event_work *event_node = NULL, *iter;
 
-	list_for_each_entry(event_node, &edev->rdma_info.rdma_event_list,
+	list_for_each_entry(iter, &edev->rdma_info.rdma_event_list,
 			    list) {
-		if (!work_pending(&event_node->work)) {
-			found = true;
+		if (!work_pending(&iter->work)) {
+			event_node = iter;
 			break;
 		}
 	}
 
-	if (!found) {
+	if (!event_node) {
 		event_node = kzalloc(sizeof(*event_node), GFP_ATOMIC);
 		if (!event_node) {
 			DP_NOTICE(edev,
-- 
2.25.1

