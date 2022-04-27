Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F006511DC1
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242265AbiD0QNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242274AbiD0QMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:12:03 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C789496D7D;
        Wed, 27 Apr 2022 09:08:20 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z19so2483305edx.9;
        Wed, 27 Apr 2022 09:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fIZenjsGtzoZOCvRY/8dIr7NFNGibTLVVWT+oNYuIJo=;
        b=Loswq8nvbzRxDR73WmbwfNXIJGBqOC3T+Wyo24t48yxcjf//w0mo3l9Ym0uXu/cZ9A
         Y22QBny9+t/M8zNI4cf7TfXze/2AggxqotMTFurZBhCPTYEO2+h9g9aiR/eJVXoKwegL
         cjrR3bUQtRNgySrtOaBt9/Kf1FfoMlTT01nygxeQrimJB/zoCEAs2Emyt1RSc7c51bGm
         Z7yuYGjT5B3iX0wv12wvEt2tcr2W+BQbB3Xp5mHBBe4BLBGoJ0tFH7b5ACm6jH9qYL7M
         OSkvFVGEotQRL9Ne9eyhT7HWSsrS8qbM4eeLpI4OETGfcXP84f0qR8TqMxbhiHkvmY2B
         jEhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fIZenjsGtzoZOCvRY/8dIr7NFNGibTLVVWT+oNYuIJo=;
        b=IJuIbpAr+mIUS6528lkzWOoUp6xQDmgd/tQINQJKN9T8gN/IaSw+b7b2AWutSTRhmC
         S6uuRPuJwpoKXzBuA8LjsuMHWf9GxdUrPJY3rQyMXH3ApC5g91zuXuoP+AZYtbgRnJRR
         iLM4y5imgGPfPuZCoMgTRQshavBfHoWl8XOwmPmHvc4GHVMaswCUXv/sXeoxPo7TX8Cb
         J0Sy/PBXiSWCUKAMIktNfo8WlJYxz9PsWY23OEohYwH1p/UcvYvUHqmm7tgPRxcomYEa
         7CVGAxoH007pMafB+qkqTKmSf0WxOjDH+0fr5xDDxfUIygspJAPwq6hS3AR7WKpVzwBv
         QDSg==
X-Gm-Message-State: AOAM533NFCjLtC0yYjhomFAilB7/8rmaqHyEErknogwVDxTKm56aLhX1
        JX0IYalbPtry6SymB/jz0bQ=
X-Google-Smtp-Source: ABdhPJycm/m7LkEc21AKXttuikHx7Z81DgO8aTXJSz0bAgx9hTWZ3Wde84ZzMxbdpyXArZqhFoaUAA==
X-Received: by 2002:aa7:d393:0:b0:425:a8f8:663a with SMTP id x19-20020aa7d393000000b00425a8f8663amr30810362edq.323.1651075651612;
        Wed, 27 Apr 2022 09:07:31 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:31 -0700 (PDT)
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
Subject: [PATCH net-next v5 13/18] net: qede: Remove check of list iterator against head past the loop body
Date:   Wed, 27 Apr 2022 18:06:30 +0200
Message-Id: <20220427160635.420492-14-jakobkoschel@gmail.com>
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

