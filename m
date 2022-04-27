Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669BB511EF5
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242111AbiD0QMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242146AbiD0QL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:11:57 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC0D49B49A;
        Wed, 27 Apr 2022 09:08:14 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id y3so4325892ejo.12;
        Wed, 27 Apr 2022 09:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F5CWUEv1vjhsP5g+KRR0GTAJ+wUhkJAp7IXSJfTRMkw=;
        b=ktlHSelCUdklQ1hSXzFqDWqmG9X1pagBePVGyp1NoHlyisKtGYRGKxHG0NbsK9ea2F
         bhUDjmLPsJix5VWIrG0R6YVTR0iVf7pKs5UKcBwfinw7buQ2xfs2xgXnxjP5uHwH1Fh5
         031mQadxuy5wGLM7giP9IvPldFIqfXRNx2GcDZTenUfBHGcZUgyT+r+hd3BqcVI4j9t4
         hA70ebcnZB/TVpR0t4sXya7kC/hDNsgNpQN45hCTVEIOJK0tJbe469jj+Ud6VdJnMayZ
         xGRq0JTxwhSO1bgIPan3wYqGsmhT3lH5TWc/hgRLeKyPzXBoXJJeUQtDzj9W3tyroZne
         6WBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F5CWUEv1vjhsP5g+KRR0GTAJ+wUhkJAp7IXSJfTRMkw=;
        b=ts7R7FmsMoV7cfVke5KkzGrk53QxxoCzgOwqLUUWqhLgKqyRfLAxHzE8JZ/iqXoz/C
         6S1EGHTSp27w3xuUvZGElFZh0ZmA8orhQvhCTdn+Yc6qgQ2bAep/V+7aH2sMnySdaORb
         ADEFiQLHRAfMPvx/3kne8YRV2P1zwgdDoJTmO8X4PjTop05UjHlacR/wOOO4vkfhDayT
         YdCdD4tbC4LEIAGH24DWGX1/8w9q4JrVwYykZTgboy/X2NH3sRx3gkL27j1rRjTyI/9R
         8iMsKSRfyYESsBJa6iPKI7SzNnr3AHlGPZTeXozDKLQ99s2w/2PLyCG6JH1eEP3rsCSi
         pbNA==
X-Gm-Message-State: AOAM530JA+3KZE9lvoqveAuBgfgDw7NE+MY1S7oo7R3qDEtFHlxRONZ7
        2+DBA+nRyqnFH7Sw+dFZh3g=
X-Google-Smtp-Source: ABdhPJyurPa9HKBRwXWzgBxCXBgmg7VG+zuYm1075t+N+Dlk6AGeeP2bXD9LJOaRPq4H7qfCukLjOQ==
X-Received: by 2002:a17:907:c1e:b0:6f3:97f3:cb6b with SMTP id ga30-20020a1709070c1e00b006f397f3cb6bmr14922818ejc.80.1651075643582;
        Wed, 27 Apr 2022 09:07:23 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:23 -0700 (PDT)
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
Subject: [PATCH net-next v5 07/18] net: dsa: Replace usage of found with dedicated list iterator variable
Date:   Wed, 27 Apr 2022 18:06:24 +0200
Message-Id: <20220427160635.420492-8-jakobkoschel@gmail.com>
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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

