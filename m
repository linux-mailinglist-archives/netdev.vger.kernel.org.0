Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D844F7CE0
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244400AbiDGKd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244307AbiDGKdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:33:39 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCEDDA6E0;
        Thu,  7 Apr 2022 03:31:20 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id k2so5843428edj.9;
        Thu, 07 Apr 2022 03:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y4Pr090XMJdWC/DFcBeDDVj+LNsTMLYKFYstx7+jurs=;
        b=nNuQkSMCzLU1sEOB3kq25UUx35GFYl6QVT99wdmylAxE9TixTKmDmoqMFWdlbqiWZP
         I3kc8fEKcgXlSy83s+c0lRBGVAHJEWI14YpuOLndz3WHyzs7RLvuY/L5jpLgy2VXqiWT
         XQwh6mAxC9rRU/MR6v9XW+wUQVVEOTvTmVXHjIAtQWksNpk44d3f4eaYMV/Ys5xgW0v9
         binB3V+mZmDmJuRNiEbhTx36DO8zxBDOH6jcmiVJLU3GAGr2SdjmTgaIJRTM1VLnwUyN
         HqfyTsMQcIfkBrPyHbBLbFKivOQQn6H7EoI68pLa9qZa4b5aV/5ifQDEIQMvxl8t4KRy
         QpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y4Pr090XMJdWC/DFcBeDDVj+LNsTMLYKFYstx7+jurs=;
        b=fJnnYpkjjAI7urKgGEDoOod70DP7P5/x+M0JTs2T4WtjV9OUuJ7OCyNHeeICjbM6xn
         lEeSkDIQor45OyhrZSU/KhNlw7MWVTtiIkMEiAZ6TYy2XvW2FHEk5H1cyaUUfkg6Mrh6
         l+Dr3YiEFocTNBfc8ONwbhhxEMP8mN4dpsI8XP5VYs8b8yimVeAdCvMhemZq+R5V8m03
         76J3cj9jT7FbuEmFuYyaOum11VyekxG4Q5sMIGoqRAANMSK2MCzEKUzyI8k8X0czghII
         wiUnbCueQriA8EQ6m8sFIoEugiEdGf/LX+R8FGc1SMzK32iNpHgux4WyFZJWWtGkHlFF
         02FQ==
X-Gm-Message-State: AOAM533pX0ZInu7oAPlpRYqa2uLLErNffWlrZRX25Wf3Cnt2T0tiq1id
        fmw9fy7izw/Rme3ChxHOsBs=
X-Google-Smtp-Source: ABdhPJyUVMuPNJKyBCwZCMXkNxTYAyM3gmvop0JowcoIjCJOFNiuXCadO642w0wu8JZyPI+BRtF6cg==
X-Received: by 2002:a05:6402:1111:b0:416:2ac8:b98e with SMTP id u17-20020a056402111100b004162ac8b98emr13450111edv.236.1649327478576;
        Thu, 07 Apr 2022 03:31:18 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm7413573ejz.57.2022.04.07.03.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 03:31:18 -0700 (PDT)
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
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next 14/15] ipvlan: Remove usage of list iterator variable for the loop body
Date:   Thu,  7 Apr 2022 12:28:59 +0200
Message-Id: <20220407102900.3086255-15-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407102900.3086255-1-jakobkoschel@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
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

In preparation to limit the scope of the list iterator variable to the
list traversal loop, use a dedicated pointer to iterate through the
list [1].

Since that variable should not be used past the loop iteration, a
separate variable is used to 'remember the current location within the
loop'.
By avoiding the use of the iterator variable after the loop, we can lower
the scope of it to the list traversal macros in the future.

To either continue iterating from that position or start a new
iteration (if the previous iteration was complete) list_prepare_entry()
is used.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/ipvlan/ipvlan_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 696e245f6d00..063d7c30e944 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -9,7 +9,7 @@
 static int ipvlan_set_port_mode(struct ipvl_port *port, u16 nval,
 				struct netlink_ext_ack *extack)
 {
-	struct ipvl_dev *ipvlan;
+	struct ipvl_dev *ipvlan, *tmp = NULL;
 	unsigned int flags;
 	int err;

@@ -26,8 +26,10 @@ static int ipvlan_set_port_mode(struct ipvl_port *port, u16 nval,
 						       flags & ~IFF_NOARP,
 						       extack);
 			}
-			if (unlikely(err))
+			if (unlikely(err)) {
+				tmp = ipvlan;
 				goto fail;
+			}
 		}
 		if (nval == IPVLAN_MODE_L3S) {
 			/* New mode is L3S */
@@ -43,6 +45,7 @@ static int ipvlan_set_port_mode(struct ipvl_port *port, u16 nval,
 	return 0;

 fail:
+	ipvlan = list_prepare_entry(tmp, &port->ipvlans, pnode);
 	/* Undo the flags changes that have been done so far. */
 	list_for_each_entry_continue_reverse(ipvlan, &port->ipvlans, pnode) {
 		flags = ipvlan->dev->flags;
--
2.25.1

