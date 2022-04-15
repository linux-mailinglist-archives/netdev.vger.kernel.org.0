Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D07F5029DB
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353518AbiDOMdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353834AbiDOMdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:33:24 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AB42F03F;
        Fri, 15 Apr 2022 05:30:56 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t25so9762359edt.9;
        Fri, 15 Apr 2022 05:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lwv0OP8MEFPtBT1zINZmdonMBn1rL8mDzX3cu0httRY=;
        b=UZTPd5EvZ/7MLeV5SHtB+DQhNN4W/OwqqQD/Vnq8UPU+juZJceoU1tO/nRd+HtUHtS
         lq6v8mlv4GF/XgBIxIfZj5vfqKuVZ7dp9hJALaUjMsaF8ugqEfGR0QrimofHjdEt3nwD
         o8Pib6cIZe0ext5DPaldULt2SsVWuagTkMWim99r9eFk7gTOVkNDTPTJW1KeALsPOk1r
         gtMb7641ZqBcW2ChXiZMCT26tDbMg/2tj2TS99WH3TZE2E0FZXigOBBi2SoAI9muA8Gy
         Ol74QcHNdnx9qALZo5u3z2INkQ/Pfu6J2lTXEIxX6+qMhMAPMTgWDfpQjYWhQxmZa771
         jzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lwv0OP8MEFPtBT1zINZmdonMBn1rL8mDzX3cu0httRY=;
        b=uhEcCBvocXlZ4iZVEJSKSEh6gbcHCxX5ZPJc7OhLWVxv8RbFlfYbkQ33D92wq3lVIw
         jsHov/BR+BvPv4kDEFM14C0bpJdAuY6rwniJOJSMFW30L9vkOgYsLs/9Xx2gA2vXLaOS
         Qf+UwFUcFS84glN/uxM1KtnVqjQEKRrGvkTgmUqW+v8z5pLSc8/Lwwm+VRzZo0iSjGCx
         3sMvX6GvoMWrJUqwMiAdy/GbEvZOxgZoNlYrl00tth6n5Xqtqcr2AaJODuhoeDeRLGFT
         6Nz2gLXQQedw3hpVm+SyHTXVChkBhSBWWALUYfk39C6Bcx8MHYy1bFDsHO8C8D3nL+yT
         sijw==
X-Gm-Message-State: AOAM532EWwPVvSB4MiS0my0q0z0ag/9E/j93URN9wraAp+qUqr0kiAM4
        tk6oUoC11F+l5Wj/MIl6Vzk=
X-Google-Smtp-Source: ABdhPJzLgdqhI8sijV1/WD9R8+gXblB1GSaAAtWi4SuH00opz1OHspvfpMH+wmKhCQg5yv6q6t4gWA==
X-Received: by 2002:a05:6402:2794:b0:419:2ea9:7de3 with SMTP id b20-20020a056402279400b004192ea97de3mr8072353ede.169.1650025855191;
        Fri, 15 Apr 2022 05:30:55 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm1649533ejb.194.2022.04.15.05.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:30:54 -0700 (PDT)
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
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v4 07/18] net: dsa: Replace usage of found with dedicated list iterator variable
Date:   Fri, 15 Apr 2022 14:29:36 +0200
Message-Id: <20220415122947.2754662-8-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415122947.2754662-1-jakobkoschel@gmail.com>
References: <20220415122947.2754662-1-jakobkoschel@gmail.com>
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

