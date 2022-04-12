Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415884FDEEB
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345931AbiDLMFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351775AbiDLMCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:43 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B30653E0F;
        Tue, 12 Apr 2022 03:59:10 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id d10so21937179edj.0;
        Tue, 12 Apr 2022 03:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fIZenjsGtzoZOCvRY/8dIr7NFNGibTLVVWT+oNYuIJo=;
        b=O+BdGb0v7IyCBRQtf3EZKDW/fxwuFivAq1K1m8aSR/ytFEwq46qecATmSDqqsoJYRK
         Y/MwY/ukhLjhxOkctLHbr7I4ckDi+C2PoR4izz8aAHHuQvSrf7Hh57Aufl+a+Hw+mZwr
         MaSrmhvityUftJvqYYObK31mfpHkKhm8Qax7fB4QZHucg5MBhdGgAJmsHbY1MgPwUhN4
         +njMvCDSfbXqNTHqnZgM8Km2KzKAuvYsx8cNL34U0iaaw73aC482LJD5MlBvoU22NJzF
         WXeO/fGRt9/1u+k6LWTzxKFXC33QPJRaHNQ54Bfh+n+aVJMr5rLXCmQPFnNAdGIiCNW3
         mg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fIZenjsGtzoZOCvRY/8dIr7NFNGibTLVVWT+oNYuIJo=;
        b=DsEBmo2Kpzc4OlnHMY+rTTboKxxLkzUGfKlw15NjrGcljD+ffJKcZKNjFD3GB7Nl8r
         esr8R723AIhaerN8F2iUO6Zs5voBr0EQLNkFXWYeWiuAYjwcB4SZ5655Zp8OBJmpw5eI
         4c0WmQpj0ehP8gl+bOpG2e7DsczMOalfgRNK3imjDxJOCIFWkGCVWvmYPPHN4LPNTj6x
         AJwLB4ve5wl0jrAgIgyjxxMNfHO4NPtg5x78qtSbqpN0Nz8lF7q41L3ahsNDnngnvdnV
         p9gtnWgwaUFXF9FxAqFhv9kg2WX4z6lapTMki44XxhH4+9redVU/utt36LM152Ls4Xke
         tKMA==
X-Gm-Message-State: AOAM530sR0RezBoPMi4WvIuaz6xcL5zYaMKjpz8xlpA7FxsUG0Eaxqy4
        9PvnCeVfulPJ6SFZKnBuKak=
X-Google-Smtp-Source: ABdhPJxBdd4nYfNJLAMB/gvCpT9MR5g2MN/g0AMD5E0/fevu9Z0Vl/VApU+6pED4uixMBmcAxsu+dg==
X-Received: by 2002:aa7:d602:0:b0:41d:78e2:655d with SMTP id c2-20020aa7d602000000b0041d78e2655dmr11490685edr.388.1649761148688;
        Tue, 12 Apr 2022 03:59:08 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:59:08 -0700 (PDT)
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
Subject: [PATCH net-next v2 13/18] net: qede: Remove check of list iterator against head past the loop body
Date:   Tue, 12 Apr 2022 12:58:25 +0200
Message-Id: <20220412105830.3495846-14-jakobkoschel@gmail.com>
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

When list_for_each_entry() completes the iteration over the whole list
without breaking the loop, the iterator value will be a bogus pointer
computed based on the head element.

While it is safe to use the pointer to determine if it was computed
based on the head element, either with list_entry_is_head() or
&pos->member == head, using the iterator variable after the loop should
be avoided.

In preparation to limit the scope of a list iterator to the list
traversal loop, use a dedicated pointer to point to the found element [1].

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 3010833ddde3..3d167e37e654 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -829,18 +829,21 @@ int qede_configure_vlan_filters(struct qede_dev *edev)
 int qede_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 {
 	struct qede_dev *edev = netdev_priv(dev);
-	struct qede_vlan *vlan;
+	struct qede_vlan *vlan = NULL;
+	struct qede_vlan *iter;
 	int rc = 0;
 
 	DP_VERBOSE(edev, NETIF_MSG_IFDOWN, "Removing vlan 0x%04x\n", vid);
 
 	/* Find whether entry exists */
 	__qede_lock(edev);
-	list_for_each_entry(vlan, &edev->vlan_list, list)
-		if (vlan->vid == vid)
+	list_for_each_entry(iter, &edev->vlan_list, list)
+		if (iter->vid == vid) {
+			vlan = iter;
 			break;
+		}
 
-	if (list_entry_is_head(vlan, &edev->vlan_list, list)) {
+	if (!vlan) {
 		DP_VERBOSE(edev, (NETIF_MSG_IFUP | NETIF_MSG_IFDOWN),
 			   "Vlan isn't configured\n");
 		goto out;
-- 
2.25.1

