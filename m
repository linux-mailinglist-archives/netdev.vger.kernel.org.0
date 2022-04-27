Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04C8511E60
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242425AbiD0QNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242021AbiD0QMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:12:17 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF033ECC97;
        Wed, 27 Apr 2022 09:08:32 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l7so4398045ejn.2;
        Wed, 27 Apr 2022 09:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/A0b7QXPnRxcdjzjvBy95srF3RhPajcOL797uVjW17k=;
        b=djNzVmRevWSY+hIiC1/H30PkHbSU6xqUomoS6vNxNxSsA2vgIsDJmjFdrGiJt1K8MS
         XvJVUBQenTNDmnRY1OxwRpXMU6eq8+3j9NKMg8A0/fSUm/OXLuHTuvFMOxq1tfiv5/lo
         PETw/pty71e5r7Z5xql/U9OyQrFDpphWq0AKn82ZX5A9j9EvNXqncx1kGerazGaEhlhW
         BtwUHrzoVQidChJdfESgX4ChoMs1jqCIz+LCsesKzeGmJ4AwqLUMeAhlcZ0ui7hA1ca6
         FYrGCeBuXiEVcQ+uN5Ej2ozdZDqA9mtVVLC0RLXFL7lInO3enpCUsINJFZgSSzcJVwCF
         jf8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/A0b7QXPnRxcdjzjvBy95srF3RhPajcOL797uVjW17k=;
        b=ax4xdyuB4aYs1fiKzYaHSXT5IzIHn9Iu8zyMFLMGhJlFd6k3qtX19JN+N+rZanY8kc
         giD4qTQlh+Te94peFoTHxnXafnAWKQiVglB2kWWebFUzX1Zbs2T+SGkYwbEhi7sapiMc
         9htSuSD8i/SxQEWeBHal56l5OOep7kTc9EbotTdwwDEdwKbXyUKxD775zUQkLkKjFa+i
         FjGpVGRG6yhKBivdGrzoDlNS4IEDJ6+p2PynGOFXIKT3lC3ThZisk8d8pchlpTIu5Kw3
         InfoMkH9p871xmAUr9WKpvG7heYa2IUAp3KURkXSIwIicoBPpdfIJq0VuNicso3/xeK2
         YNiQ==
X-Gm-Message-State: AOAM532boLg2Ni0TXEbSMKVR1+mco7wB8z1GkIfrVzUwEQwJRLGqqkIn
        ROtB2BUaPQfLrWTxNdlm7n4=
X-Google-Smtp-Source: ABdhPJzZ9GK5JMKIlGUFt2skqXUpBcMIDshg75p8eWcFCf8XLqwMsnXkioKQLmTu+ChB5hH1wuiIcQ==
X-Received: by 2002:a17:907:98eb:b0:6f3:ce56:c1a2 with SMTP id ke11-20020a17090798eb00b006f3ce56c1a2mr2984393ejc.173.1651075659037;
        Wed, 27 Apr 2022 09:07:39 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:38 -0700 (PDT)
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
Subject: [PATCH net-next v5 18/18] team: Remove use of list iterator variable for list_for_each_entry_from()
Date:   Wed, 27 Apr 2022 18:06:35 +0200
Message-Id: <20220427160635.420492-19-jakobkoschel@gmail.com>
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

To either continue iterating from that position or skip the iteration
(if the previous iteration was complete) list_prepare_entry() is used.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/team/team.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index b07dde6f0abf..688c4393f099 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2425,17 +2425,17 @@ static int team_nl_send_options_get(struct team *team, u32 portid, u32 seq,
 				    int flags, team_nl_send_func_t *send_func,
 				    struct list_head *sel_opt_inst_list)
 {
+	struct team_option_inst *opt_inst, *tmp = NULL;
 	struct nlattr *option_list;
 	struct nlmsghdr *nlh;
 	void *hdr;
-	struct team_option_inst *opt_inst;
 	int err;
 	struct sk_buff *skb = NULL;
 	bool incomplete;
 	int i;
 
-	opt_inst = list_first_entry(sel_opt_inst_list,
-				    struct team_option_inst, tmp_list);
+	tmp = list_first_entry(sel_opt_inst_list,
+			       struct team_option_inst, tmp_list);
 
 start_again:
 	err = __send_and_alloc_skb(&skb, team, portid, send_func);
@@ -2456,7 +2456,9 @@ static int team_nl_send_options_get(struct team *team, u32 portid, u32 seq,
 		goto nla_put_failure;
 
 	i = 0;
+	opt_inst = list_prepare_entry(tmp, sel_opt_inst_list, tmp_list);
 	incomplete = false;
+	tmp = NULL;
 	list_for_each_entry_from(opt_inst, sel_opt_inst_list, tmp_list) {
 		err = team_nl_fill_one_option_get(skb, team, opt_inst);
 		if (err) {
@@ -2464,6 +2466,7 @@ static int team_nl_send_options_get(struct team *team, u32 portid, u32 seq,
 				if (!i)
 					goto errout;
 				incomplete = true;
+				tmp = opt_inst;
 				break;
 			}
 			goto errout;
@@ -2707,14 +2710,14 @@ static int team_nl_send_port_list_get(struct team *team, u32 portid, u32 seq,
 	struct nlattr *port_list;
 	struct nlmsghdr *nlh;
 	void *hdr;
-	struct team_port *port;
+	struct team_port *port, *tmp = NULL;
 	int err;
 	struct sk_buff *skb = NULL;
 	bool incomplete;
 	int i;
 
-	port = list_first_entry_or_null(&team->port_list,
-					struct team_port, list);
+	tmp = list_first_entry_or_null(&team->port_list,
+				       struct team_port, list);
 
 start_again:
 	err = __send_and_alloc_skb(&skb, team, portid, send_func);
@@ -2744,7 +2747,9 @@ static int team_nl_send_port_list_get(struct team *team, u32 portid, u32 seq,
 		err = team_nl_fill_one_port_get(skb, one_port);
 		if (err)
 			goto errout;
-	} else if (port) {
+	} else {
+		port = list_prepare_entry(tmp, &team->port_list, list);
+		tmp = NULL;
 		list_for_each_entry_from(port, &team->port_list, list) {
 			err = team_nl_fill_one_port_get(skb, port);
 			if (err) {
@@ -2752,6 +2757,7 @@ static int team_nl_send_port_list_get(struct team *team, u32 portid, u32 seq,
 					if (!i)
 						goto errout;
 					incomplete = true;
+					tmp = port;
 					break;
 				}
 				goto errout;
-- 
2.25.1

