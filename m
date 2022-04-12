Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D854FDF1E
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349398AbiDLMFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351592AbiDLMCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:40 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF8F238;
        Tue, 12 Apr 2022 03:59:02 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bg10so36566885ejb.4;
        Tue, 12 Apr 2022 03:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lwv0OP8MEFPtBT1zINZmdonMBn1rL8mDzX3cu0httRY=;
        b=aoDWjjGvs8H8yV45D3QuJ9H1mPo83/jIJGuOj1UpFJ8MPHj2wmJ2oNQyVYGjD9hwgT
         0xZ8dHSNv/Oq9Aba8FmB5PoM8ATn2/vxZDDRV3BMeUZBWLJNX+fDyMt5OScKlN7uMbjA
         JmeAfahBug2GpC5HqsB/JKtqbKu99F75AQXzfj6BX+3A2gO1+1iQduJ1GtTYZeK3TSSW
         bxdDdDXK6vzKPZqYRf9rDKpMV/2PzZvu+MhpG5ge7Z9f7BUmwBeEF7GnWs6EOwRQisIw
         ll4crz3AHeFACf/yUyn4P59IiZ1EwuizU4cEmM00Zz+1Zte2KliFKeVpEiDvdS5g3qeJ
         PIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lwv0OP8MEFPtBT1zINZmdonMBn1rL8mDzX3cu0httRY=;
        b=ishqW/9raCd0aVooOaQxqBgH6a4gbgxhvXvejOnCoa5nkuk71bPun4flclx76xpkhf
         B/lXgdnK5tpt+NiAifxWRFMSZ+Sbjs5aY/DQTCWlZCMGxioX4ETg2heWWrY/sFSW2Plf
         0FrzuxigRuG96uc7epVDVPq55g0mlh8+JL52exKgq9mLEq5ubqGXFmTlC5EX7gZbyegw
         MpEOclU0j5a5dSvgTaL9tyTB1Pe9ibVH02ccLwLpCOcu9bTNGepc2bz58N6U/gz0nMlh
         bek/FuIF1rD8u0T8CCB9bWt8TWdw9eq9yvRRkTwFSbzdunzrjNjLnjDT1pB/MIIoG8Wi
         etrQ==
X-Gm-Message-State: AOAM530jj1SdtkalUJO6IZR5B7j0oUoFuIWkWg0Jq1G3OmFaox11gbxA
        0CHOHaF22D4pWvuCOY/70dU=
X-Google-Smtp-Source: ABdhPJxtM0/vB3PbVqf57ZcvCKz1A36pyt5xGp3an1wFWW0AwFhDleBHHOsnfcPXL2iVSu+R5pyonA==
X-Received: by 2002:a17:907:72c7:b0:6e8:442c:1722 with SMTP id du7-20020a17090772c700b006e8442c1722mr20430201ejc.120.1649761141020;
        Tue, 12 Apr 2022 03:59:01 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:59:00 -0700 (PDT)
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
Subject: [PATCH net-next v2 07/18] net: dsa: Replace usage of found with dedicated list iterator variable
Date:   Tue, 12 Apr 2022 12:58:19 +0200
Message-Id: <20220412105830.3495846-8-jakobkoschel@gmail.com>
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

