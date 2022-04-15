Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89AF5029E8
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353606AbiDOMeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353434AbiDOMdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:33:39 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93F252E4C;
        Fri, 15 Apr 2022 05:31:10 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z12so9795415edl.2;
        Fri, 15 Apr 2022 05:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yEn2KXl6YaWL8lEsoeTa0NhbbIFQf0W1A7EAGx1tWC4=;
        b=b3hc5PlQNJwnipmFgPKwKobkYuBqu+VhbGWKUONdb7h8D0d0QpzlgKH51PWjk95WTj
         ADJ4mluAmAow9uamrXzOVaO9sedPih8JXQg90Vp3D1U92O6F899Tf10rxWd7mAQjHEQA
         Szl5d9kjQph2s2n7ZeS5O3MZOHbMGtfCwoSSDSjugBjqNC9T4FwaS+WJ27MLXp8aIGVs
         DStAyL1wpAzpwElDS8FsoZW3S0OtwFzTPi8FKiZu1nwZMkCYJFTcEzRuXgZEBCkvC2DF
         h85SkTuD2SDpZQrDmEoOr3Eq95jeyRza5A0Porbl8XGQU+vuJ1UPBCPW5+GyonbvM5KD
         kwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yEn2KXl6YaWL8lEsoeTa0NhbbIFQf0W1A7EAGx1tWC4=;
        b=EB6YUtloTLDhzvM8XkR4JBQwYonwdMtBFVdzYA+6WqIeUT4YsyLIlh3po/h9e4cEu3
         qPbD7hfnNXsDDLCO/i+sfpBlQdwllMyJvRQIxEGMHw2AhbNyQVQWxt8dJRDS2WeHVt+P
         5HtZp+dCqPMdBr6P5IF4H288nXvoMTeYPOTngpX0BKmS7LcaKlJIm9ssOMWv/Hj/+mks
         eEKG2hcCppjJWDgZ4FjeV0lRdJAts4Qc6akBs5cIBususpFDoNiJIdiuMZ6jocuWvGQi
         4DE+5btg9243WqSg4LZVloY1lf2kO4Km6n61Ej0cIX9PEjetrkdrLHUabVI9MOhXZ9Vy
         GQSg==
X-Gm-Message-State: AOAM532cHyo1Rd24+JoWd0uTv0QrFDVmqN7kVchxI5GmydY9io56wDqV
        tE/j/QSgGlqTx4F0SS0+yok=
X-Google-Smtp-Source: ABdhPJxFA6/82EYIOUmoGfM6Rwv35qSZg1kJewtxaRvXjq59AYMYC+/ozksdzIoDL0AQZRXVthp7Cw==
X-Received: by 2002:a50:d613:0:b0:41d:71bb:4af3 with SMTP id x19-20020a50d613000000b0041d71bb4af3mr8166908edi.99.1650025869469;
        Fri, 15 Apr 2022 05:31:09 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm1649533ejb.194.2022.04.15.05.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:31:08 -0700 (PDT)
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
Subject: [PATCH net-next v4 17/18] ipvlan: Remove usage of list iterator variable for the loop body
Date:   Fri, 15 Apr 2022 14:29:46 +0200
Message-Id: <20220415122947.2754662-18-jakobkoschel@gmail.com>
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

In preparation to limit the scope of the list iterator variable to the
list traversal loop, use a dedicated pointer to iterate through the
list [1].

Since that variable should not be used past the loop iteration, a
separate variable is used to 'remember the current location within the
loop'.

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

