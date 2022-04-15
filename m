Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6525029E4
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353465AbiDOMeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344832AbiDOMdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:33:33 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE0B329A7;
        Fri, 15 Apr 2022 05:31:05 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id t11so15102319eju.13;
        Fri, 15 Apr 2022 05:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fIZenjsGtzoZOCvRY/8dIr7NFNGibTLVVWT+oNYuIJo=;
        b=PnprkJEp2AV/psDSMmNlNJR5/A6mm1H16/LpjoBjEuaix47jUPTOMi1cgCdR7PBn7X
         C7rCT7JJgTLtc33gKay7RC67B1NsptkBmDPqwCfInz0WENgKBqsDW4vFVMaOIC8dUclS
         /+oxUFIQWxH39M6uE0HzXos2C62iWdBQRjtYmp8K6IUVZdo+53+bkuwEuUfCd+sDo4xA
         qLoVbtxYwjSiBQ7jVpMwDObcu2HkSJrmHfv4hfHl0ktbZEtJhUgUwuSRnBnm+TRC9ETz
         v6/00UdmF6bhJopm36jbohFJEyRDAneLSE2ubDYHLeBKhXYUbTEdLuksjgw+vPlJZpub
         fCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fIZenjsGtzoZOCvRY/8dIr7NFNGibTLVVWT+oNYuIJo=;
        b=WdsCBZvsAjnZdX5MOAgE+3s8x40TQKoF7HZsBFOfecdmctJprl0dKxkABpneJ0pfhX
         jvl9IXhEgF6w5APT99t+KFVqM97aRlTFsmlsas9KlLUMdZXd0/mhCYzD8/2QFs+ZcUjX
         48+NZXzBpvBhVvhkSHC44Y96gSdgAMQgzqC3x5/Hm7xLrPhcCQ61JgIU4cMUWksKbLhI
         wZVnHOyrLZQW7qIyUtA3klhjRGNMBlNhs635AmvjhnvWe2CiZr/0kVHzeQvoSbefEcc8
         VWop9E8+TBSq6NKxofcQcuPIRXKjdCGzqQSZCtizjNmSoez5hPilc+FQpbosSKblbrzy
         OopA==
X-Gm-Message-State: AOAM532gB0xgGZeJ8bY0GUF40LZWN85iM2COPdzQPfOJeIQSGfGuFZGF
        TRJYtSPbgsmrWNg4ShL0gVE=
X-Google-Smtp-Source: ABdhPJwFa9wLSTj1xXt1QbiRiyGVhuHtT/dlA0VG6MIkcwtzByCOypTj1XZMjZyXz+s9p8S4pamS0g==
X-Received: by 2002:a17:907:da7:b0:6df:9ff4:10c7 with SMTP id go39-20020a1709070da700b006df9ff410c7mr5945711ejc.106.1650025863925;
        Fri, 15 Apr 2022 05:31:03 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm1649533ejb.194.2022.04.15.05.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:31:03 -0700 (PDT)
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
Subject: [PATCH net-next v4 13/18] net: qede: Remove check of list iterator against head past the loop body
Date:   Fri, 15 Apr 2022 14:29:42 +0200
Message-Id: <20220415122947.2754662-14-jakobkoschel@gmail.com>
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

