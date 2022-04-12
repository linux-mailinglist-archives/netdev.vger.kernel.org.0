Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E514FE0FA
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354163AbiDLMtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355280AbiDLMsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:48:09 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F371226E1;
        Tue, 12 Apr 2022 05:16:33 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z99so13494631ede.5;
        Tue, 12 Apr 2022 05:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lwv0OP8MEFPtBT1zINZmdonMBn1rL8mDzX3cu0httRY=;
        b=Nrx9PppmSSTaBksft/090SSleOxLNQ168KaZqdPde5zNNfnOffkWaVzLw6BMxacwbR
         UAjGFEhao5GDH+VGb8yYgE4lNujVITlt7DTYSjj3eV+fO6PK3uewLodumM8NSppQDVUc
         /OMz+Ndyg/JrNrymjRUj2fFE7XHmGj/xHdcQWi0Il9jHquCtkY9fxrpR3af35rOiFnlZ
         5rH6MDhHkXKgviLz10C9htS5M5Z2rRSNE+ej1J8UvcwG8f5+8xM9rrsWJKlIlYWZRxgD
         LE1E3FWCn7bLljRsUimHqjvI0RKAaKiz6iHw0LRoifpwzxwreEYLobLHKiR/cRS9ydGl
         4KZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lwv0OP8MEFPtBT1zINZmdonMBn1rL8mDzX3cu0httRY=;
        b=plWT1lpVeOlgQF0fNnKTZ/2UnedN5hMjk3eSDprU6bvvVnpPsHLbIKVMAZ+NyNWjz+
         +X0ZF4h1S09c3DwWgozz0VTgBaYsxpuQLrOQtaPnAxrPaS56QHSwT6IgN8TQ5jnUYXIq
         stuM7ddClW7BE4HVTJpAcOG+zg+HfOH7Ee0BNvju+U+loH+sciib56jWQ/5sEETuVC+U
         c51HI76Vg1uwNTEqKMdWPwI9hF6OwiT5PIypgFJ2hJkHK+trPM57XjdYKqwUOK5/fOWR
         id4/3tHLGv0qiboyAgmmxuSDzUM7gxBWAjP5DtXnSkjYraSNmU27NjDI2fcrLaboE4eh
         8Bnw==
X-Gm-Message-State: AOAM533pWmCdcAGFZEA1TXG5KST4Jl4EQvA8U7jKGXKAFiSC1vhow00+
        6Lv98+4aO75/oZO/DF8k05k=
X-Google-Smtp-Source: ABdhPJzY2ezbuKR/noX2ghuCmN5SBYP3Gx6pBGYKXHCtWqGnOQkVdyu/LlA9QKxQZv/DPvFNVlz3zA==
X-Received: by 2002:a05:6402:2682:b0:41d:2f74:7269 with SMTP id w2-20020a056402268200b0041d2f747269mr21742861edd.255.1649765792395;
        Tue, 12 Apr 2022 05:16:32 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id b5-20020a17090630c500b006e8044fa76bsm8827900ejb.143.2022.04.12.05.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:16:32 -0700 (PDT)
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
Subject: [PATCH net-next v3 07/18] net: dsa: Replace usage of found with dedicated list iterator variable
Date:   Tue, 12 Apr 2022 14:15:46 +0200
Message-Id: <20220412121557.3553555-8-jakobkoschel@gmail.com>
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
 net/dsa/dsa.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 89c6c86e746f..645522c4dd4a 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -112,22 +112,21 @@ const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
 
 const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol)
 {
-	struct dsa_tag_driver *dsa_tag_driver;
+	struct dsa_tag_driver *dsa_tag_driver = NULL, *iter;
 	const struct dsa_device_ops *ops;
-	bool found = false;
 
 	request_module("%s%d", DSA_TAG_DRIVER_ALIAS, tag_protocol);
 
 	mutex_lock(&dsa_tag_drivers_lock);
-	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
-		ops = dsa_tag_driver->ops;
+	list_for_each_entry(iter, &dsa_tag_drivers_list, list) {
+		ops = iter->ops;
 		if (ops->proto == tag_protocol) {
-			found = true;
+			dsa_tag_driver = iter;
 			break;
 		}
 	}
 
-	if (found) {
+	if (dsa_tag_driver) {
 		if (!try_module_get(dsa_tag_driver->owner))
 			ops = ERR_PTR(-ENOPROTOOPT);
 	} else {
-- 
2.25.1

