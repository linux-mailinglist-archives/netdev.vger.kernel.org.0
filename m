Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A5C4FE0DC
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346277AbiDLMuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355313AbiDLMsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:48:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEB91117E;
        Tue, 12 Apr 2022 05:16:50 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 21so8908081edv.1;
        Tue, 12 Apr 2022 05:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/A0b7QXPnRxcdjzjvBy95srF3RhPajcOL797uVjW17k=;
        b=pt6ToQjAd663wMrVDbXPdtWrIdem4CnLtP/h4V1zvHQRqD9xToIMziUbeJ9DxzoAYw
         OCLLsufYdt512l71hphYx/hJe8A8CErh5Lt/6NKV0Y7B/1e4oDXd4K1htKuRLHzhXPe9
         jJPNjIX5vQIC6oHGZuC7X+FqdkYdbFS/AmB/sIQDe2hpVZsj7ADmMUveDsreb2wQnwGg
         X7hgHRhuIFXqs8yvxRT5ooTQUI3appVaTVO4cEoVrotN8HpmF8qg9lV7YsPj067SBZOM
         vTV25l1GfMgIGDydkON7gxh+EZ9wbQk7/xyn/YsIPpl1zOZlz2kyMy1ZXpyu+C1yJCtn
         lqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/A0b7QXPnRxcdjzjvBy95srF3RhPajcOL797uVjW17k=;
        b=Xe4tdW08vT/nOLx2E2Qlt4Sb4xV+GGdTLXTnLil1ZiAXFWvYQReJcBjEa78yoAzcdB
         4EqeZm8pNmtV7uzMsxlnI6wM59TCF/Y+vaQ6MixRfFJnM6F+3YEMOZtD+b33+ED2KIOg
         tiA5qjCSBr/ENm/OV7d1n6pzmBOHwV845gFEGlme41joE5doSPbriPH440u2bHfxR8dz
         iUTXtzBOxebM5hfH8XUIdb6GGtbt/7hi3zxXNL46zRQ+Q5r87FO2okEx+9oYLFsS9Ayk
         TfFr75LrNkfj+YhyWTZV7dfYoWwfFw5Qer0mjyeqOq1EAZE7oASluEyZZbB+tKD3z0pz
         Y3Mw==
X-Gm-Message-State: AOAM532mWH46maZoeCK10UDNzJgMbuDIuiBIZVE/zbozTWfaK1fEnLJX
        IRTyQxanXs8TCxJ4PKFd3C0=
X-Google-Smtp-Source: ABdhPJyIMZ/77cMenUjdSyEWMxn67TK1mFZMcR67eDJlbutAdo1BjZ/IBoHT2jh8Jk14zLeMyyEwpA==
X-Received: by 2002:a05:6402:530b:b0:41d:6f3c:d8dc with SMTP id eo11-20020a056402530b00b0041d6f3cd8dcmr15902311edb.291.1649765808937;
        Tue, 12 Apr 2022 05:16:48 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id b5-20020a17090630c500b006e8044fa76bsm8827900ejb.143.2022.04.12.05.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:16:48 -0700 (PDT)
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
        Michael Walle <michael@walle.cc>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v3 18/18] team: Remove use of list iterator variable for list_for_each_entry_from()
Date:   Tue, 12 Apr 2022 14:15:57 +0200
Message-Id: <20220412121557.3553555-19-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412121557.3553555-1-jakobkoschel@gmail.com>
References: <20220412121557.3553555-1-jakobkoschel@gmail.com>
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

