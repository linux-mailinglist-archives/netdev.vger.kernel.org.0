Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DB9511DE9
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242284AbiD0QNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242219AbiD0QMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:12:17 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8895F4692FD;
        Wed, 27 Apr 2022 09:08:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id gh6so4451433ejb.0;
        Wed, 27 Apr 2022 09:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yEn2KXl6YaWL8lEsoeTa0NhbbIFQf0W1A7EAGx1tWC4=;
        b=j9VN3560QziYTFS6d7J5Qq58hDCrTHjdmjOyr5NqrbaJEKStDuM4vruZjymlSyiLMc
         Dh8INfUNhWcjaH37Z/xtK+hpI+Reivc925N29H3notA/4MG5STF7Y/S8UULAjLrvAk3x
         tQn1C8WCge5lQNlQTq2kdY8XDgx8f0A9p9ySxSQKzu7jp7FN1JqTunv95UrEld8tjPJ6
         VRtqjtn30d1MvYY4uxLZ1e/4kHIF/t7sayeN4qAuNESeiGnOPggh5aeNzHUApnNASKpY
         U2rFXGyJBscsO38UWjuCkyg5A6HAurFoW4JUoqmcrmYZbpbtGpqoy5En4hTB6XKRCff/
         jCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yEn2KXl6YaWL8lEsoeTa0NhbbIFQf0W1A7EAGx1tWC4=;
        b=bm/IFafEfdyMrLNegEnQV5fKJujnfBVf+IAi1dKmvW8v+zcTyvxMOOyYxpQN7DapcP
         jraYaLDw4tP+Wt8zPpWayrP0+aqDcH2bIuDVBHEY0RB16b6moe/NXe3L0xOQMF+Qf4SV
         ZcVF1EEDWNMyS+tU14OmiU/4hpZZX0cDfQfzeLNviWUj3YloXJ9HFZvbam9OV4shG+QO
         FXqYNpZNQRmo5BiAK4WNm/dP8tbyhCmcpAydWi6YdxywPhUju2it35B1Hp6pOZZIas0L
         7dEFNu63SJTJeMLbi9mHnc/ggEb46xahrz9l0rqXzb4OcEemBV3K79IfATupnlBsffXH
         oyug==
X-Gm-Message-State: AOAM5311hSnP4l7LIRyhgbU+jQmqstUUC8DItuQiz8BkUgFiup+D1TAl
        gKPmXGDs7gJD0dotNPD0m64=
X-Google-Smtp-Source: ABdhPJyMZ+IgV1RXVOMRtwqWm4DRsNx2pj45I590H75mGqMsBCpfqP0l0qRvqSkNr3e05xJ3Sk+wew==
X-Received: by 2002:a17:907:eab:b0:6dd:e8fe:3dc with SMTP id ho43-20020a1709070eab00b006dde8fe03dcmr26843254ejc.165.1651075657398;
        Wed, 27 Apr 2022 09:07:37 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:37 -0700 (PDT)
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
Subject: [PATCH net-next v5 17/18] ipvlan: Remove usage of list iterator variable for the loop body
Date:   Wed, 27 Apr 2022 18:06:34 +0200
Message-Id: <20220427160635.420492-18-jakobkoschel@gmail.com>
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

