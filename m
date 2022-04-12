Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D934FE0D3
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353083AbiDLMto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355293AbiDLMsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:48:09 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518F45F45;
        Tue, 12 Apr 2022 05:16:38 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bh17so36918688ejb.8;
        Tue, 12 Apr 2022 05:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LXuHnml0JyQ7WUWtSyqxCdcrvdOAihH7ECEcB+ac3FQ=;
        b=M+2Q/55ImUNO2WPmUemvwrDQVJ6b3qx60DyU6K3kHps52GjVORJwZyDaKNbLFeERof
         92+kRsFwWXMNlMEQGJrIQJ/JEc7gwtc9lj3lNPy476NV85Swle/tJmzqXcomttvIYniX
         I16StuBQxsXTy9TNXpP9f/h33ZL6nDvRR2ldRIXa96rWlK6VroMZpzS0YnVkMF2Oeuml
         Sqtb3AGJMU2x+uuPwVgXgb8e5U/EBEwSMD+nQUGZfbFDVKAq7e3linokGpWnhXpCoUjU
         kIGN96Y0xvo1tEz3FGUsN609MJurjnqQkBIT0l2vH0N6qX/9Yk8SRoyEQiH+GP9y+8X4
         nS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LXuHnml0JyQ7WUWtSyqxCdcrvdOAihH7ECEcB+ac3FQ=;
        b=KIj8F+hv96QBPK19tC5PzCss/GmTCXY2uk9h9r7aqQZv7YcH6dia9XwMjPS+ZtbZUI
         /pAFtJDagvwFlTzf0+nF4nC3H+Kj/lXVa76/fCGMbbQYoRQMr5EjMbfwm+DV7VSlUkZr
         iAjeSTaVcvJ+zx39E4KIB1zKrro/DkYoRgkpI5arc81VeGuV/ElPPU/tC4yv62qb5A1Q
         8QRDIoT0tdA94ULHhUvR9qIGv7wEH55D9Ma99eSj3GGYzIW9aZl8YgLnVDTIvhJDceO9
         HVGdgPpoxgy8Mq4tyJxEXPwqK68WrMDJwsZgqoolLWtxzrWGktB/QBcDKvZ3ghzVgkVC
         jwew==
X-Gm-Message-State: AOAM5317suYyTCGe2XIcXJu1b3vNM3VQ1BQa9wajkyPTPGByeihh2UGw
        5SEWFr2+7VLUaHJIKcfhQwA=
X-Google-Smtp-Source: ABdhPJzOkuvH/rglfcYYBBG42ORiAUqsc5aWeu8BROj0rJGynBWX8b6rgSgl0HKkSGptpY/QjnSsuA==
X-Received: by 2002:a17:906:a08b:b0:6cf:65bc:e7de with SMTP id q11-20020a170906a08b00b006cf65bce7demr35119993ejy.220.1649765796899;
        Tue, 12 Apr 2022 05:16:36 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id b5-20020a17090630c500b006e8044fa76bsm8827900ejb.143.2022.04.12.05.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:16:36 -0700 (PDT)
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
Subject: [PATCH net-next v3 10/18] qed: Replace usage of found with dedicated list iterator variable
Date:   Tue, 12 Apr 2022 14:15:49 +0200
Message-Id: <20220412121557.3553555-11-jakobkoschel@gmail.com>
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
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 26 ++++++++++-----------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 1d1d4caad680..198c9321bf51 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -1630,38 +1630,36 @@ static struct qed_iwarp_listener *
 qed_iwarp_get_listener(struct qed_hwfn *p_hwfn,
 		       struct qed_iwarp_cm_info *cm_info)
 {
-	struct qed_iwarp_listener *listener = NULL;
+	struct qed_iwarp_listener *listener = NULL, *iter;
 	static const u32 ip_zero[4] = { 0, 0, 0, 0 };
-	bool found = false;
 
-	list_for_each_entry(listener,
+	list_for_each_entry(iter,
 			    &p_hwfn->p_rdma_info->iwarp.listen_list,
 			    list_entry) {
-		if (listener->port == cm_info->local_port) {
-			if (!memcmp(listener->ip_addr,
+		if (iter->port == cm_info->local_port) {
+			if (!memcmp(iter->ip_addr,
 				    ip_zero, sizeof(ip_zero))) {
-				found = true;
+				listener = iter;
 				break;
 			}
 
-			if (!memcmp(listener->ip_addr,
+			if (!memcmp(iter->ip_addr,
 				    cm_info->local_ip,
 				    sizeof(cm_info->local_ip)) &&
-			    (listener->vlan == cm_info->vlan)) {
-				found = true;
+			    iter->vlan == cm_info->vlan) {
+				listener = iter;
 				break;
 			}
 		}
 	}
 
-	if (found) {
+	if (listener)
 		DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "listener found = %p\n",
 			   listener);
-		return listener;
-	}
+	else
+		DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "listener not found\n");
 
-	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "listener not found\n");
-	return NULL;
+	return listener;
 }
 
 static int
-- 
2.25.1

