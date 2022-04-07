Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7284F7CE5
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244291AbiDGKdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244293AbiDGKdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:33:14 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F138A6CA;
        Thu,  7 Apr 2022 03:31:11 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id k2so5842990edj.9;
        Thu, 07 Apr 2022 03:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LXuHnml0JyQ7WUWtSyqxCdcrvdOAihH7ECEcB+ac3FQ=;
        b=UO2thwdFQIwezldvMHYU+ye9tZTtvNLlmY23CqaOO92X4B+g3Vio1ebPrFn37X1c0p
         zDbJw8xG5ELmkRDNCHYKPMI6PByu/T+4XKDeTFYfPla4cyhVWpnCRRUdzWrD8r22LLiq
         LYWvm+jsWpIjYe1mJBw+pCIxqKLhlg9b6+hrW5jm8hdd0QcgIywz1NLJf9epRNitoMI3
         rRDr5g2GEjDr5MbV2LR/fi/Y6grbdZtQbvDOP/qP6A1cGNrZczf+/zEAs/8wKBpia+Tc
         5acHVDvHJ+ZyqqccAaCclfK/iv8Ms/hvIG93ImicRaO4ty/nHntQ4MaVGTVRAcKTuwWE
         ZXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LXuHnml0JyQ7WUWtSyqxCdcrvdOAihH7ECEcB+ac3FQ=;
        b=BvZm+NOtnQXiCHa8ZHfUn8pq/OxCBU5OfgBi3bWI2fpSi/d73r9Ox95hC2Lzl8mKj5
         QybHInEBKuehQfDmDYjFhpDi9Gom1J7yxu8y9k6g8MP2LF+N2HDwBuzGR0wzatJshKtA
         SIX3At4+b/IMyLNfAq3VghNYG4gVR2ktz6Cb39BsdfuJOGt7xF1ZsQZMQ/Q5NPvMBAal
         xLoQUhI57PyWiQOnwvZwMH0YVRyPVJtRrHRnAmjfFRDgFdxVFJgQuoAUjNm0RetqXpLi
         QNL0+euc8jUW11fstLFjM0jt6QKIxOKqRYs8+XwKE4hUBka5s1GiOf5DL+zJggbiWPlt
         +Okg==
X-Gm-Message-State: AOAM530uuz7pyUdUsrS7ou3qlPIWaPsmceegNHsfOY4AcZARZpU7h24i
        vwaJ6+PFUSwUPAK2EqHesg8=
X-Google-Smtp-Source: ABdhPJz2+NZqSeirvVVj4bPDnx4stHslOcY9HYpOhyAxlH22T2QC0Dx7b5z5Dgu00nmuL53HkE4z+Q==
X-Received: by 2002:a05:6402:2706:b0:418:fcb2:3a02 with SMTP id y6-20020a056402270600b00418fcb23a02mr13435824edd.111.1649327469766;
        Thu, 07 Apr 2022 03:31:09 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm7413573ejz.57.2022.04.07.03.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 03:31:09 -0700 (PDT)
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
Subject: [PATCH net-next 07/15] qed: Replace usage of found with dedicated list iterator variable
Date:   Thu,  7 Apr 2022 12:28:52 +0200
Message-Id: <20220407102900.3086255-8-jakobkoschel@gmail.com>
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

