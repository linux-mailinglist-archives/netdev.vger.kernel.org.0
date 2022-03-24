Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513784E5F35
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 08:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245396AbiCXHSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 03:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348519AbiCXHSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 03:18:08 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDD6954AD;
        Thu, 24 Mar 2022 00:16:37 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id yy13so7310454ejb.2;
        Thu, 24 Mar 2022 00:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MjZ7HvtJn0jvqa5H0zlDW3Y7iSlxhCjOY8oHXdcrUYY=;
        b=F41bzl2swTdF6dLdVQGhpaPPpq7TMFjm+LdYTsOCON2Rbf1errMyc97q3NHm4ruEoM
         JBHJm2kgz8C+akix5xEpV101HRQFXxjrd0hqYGEw5HMcZ4+tRLq6PHFAp5eKaEUoYHdF
         3nSFrN/jsOgdx7+uMmbLbSh7WW/9V/fHnZm8rGUogxy2k9VM27B8IWUW4XIzbvSlDLqu
         tRm/maMx5XS+PiT2CdMmSWg0s0rkyjQZdcl8cMd/9cF8XKdQJ5LdZ3lDX6y2rDvujoUY
         TXUGWKNDEHg4WAXiK9fcE4AmjxaI7n8pjo8hR2Vfmnn/AV0fic77GGETQulNqop2bz5y
         3vsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MjZ7HvtJn0jvqa5H0zlDW3Y7iSlxhCjOY8oHXdcrUYY=;
        b=H5pb+C36VO2xxoKgO8hc1exzYYs/XuayLOXr/Bfs5NRFi8YRp11xqafthtfRYDg230
         zIdkyU5q+oSJmIQI4erVYBq3NbdNnzSurAHV7Dir0WeSvkEEDfSGmJpr2DNRaUGPE/UF
         VkmdH3tOlcyQynzQ1V0bS7iD1NessC2FT5bNgHP6IBMOQR0HLUbxUa39YBUIIrdEZJlD
         Ko7jUwfGSxCfvYrKXo1YQhKubul3NypsfTcYRVMwMrrboLnNEcyvcdCK9jmBSGMK2m4s
         4tq+gBJV8SR7lc8XASfHloSPMHahOjzVnz+FLoO0Q28Rc3Q+97YOqQiHZvk3I0nBORVp
         JK6g==
X-Gm-Message-State: AOAM531qrtESxlpL7HbA+vhITNM4PJAHfKgYXLJzxuKKAcGVqAMNMm5l
        Ar/D9zMDObdRhMg+ZslY6e2Zg2d8ekLi1/fu
X-Google-Smtp-Source: ABdhPJz5LmWDNYfnvVtaXA2B323Tzg8hE1RKruckeW65TFfuz4G1GOlUBgQlPwvjP6kxcZPF8axCsg==
X-Received: by 2002:a17:906:9b95:b0:6e0:6f6b:997 with SMTP id dd21-20020a1709069b9500b006e06f6b0997mr4042423ejc.367.1648106195704;
        Thu, 24 Mar 2022 00:16:35 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id q16-20020a170906145000b006bdaf981589sm766647ejc.81.2022.03.24.00.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 00:16:35 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH] octeontx2-pf: replace usage of found with dedicated list iterator variable
Date:   Thu, 24 Mar 2022 08:16:07 +0100
Message-Id: <20220324071607.60976-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_flows.c   | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 77a13fb555fb..e47a7588f6d3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -1115,9 +1115,8 @@ static int otx2_remove_flow_msg(struct otx2_nic *pfvf, u16 entry, bool all)
 
 static void otx2_update_rem_pfmac(struct otx2_nic *pfvf, int req)
 {
-	struct otx2_flow *iter;
+	struct otx2_flow *flow = NULL, *iter;
 	struct ethhdr *eth_hdr;
-	bool found = false;
 
 	list_for_each_entry(iter, &pfvf->flow_cfg->flow_list, list) {
 		if (iter->dmac_filter && iter->entry == 0) {
@@ -1126,7 +1125,7 @@ static void otx2_update_rem_pfmac(struct otx2_nic *pfvf, int req)
 				otx2_dmacflt_remove(pfvf, eth_hdr->h_dest,
 						    0);
 				clear_bit(0, &pfvf->flow_cfg->dmacflt_bmap);
-				found = true;
+				flow = iter;
 			} else {
 				ether_addr_copy(eth_hdr->h_dest,
 						pfvf->netdev->dev_addr);
@@ -1136,9 +1135,9 @@ static void otx2_update_rem_pfmac(struct otx2_nic *pfvf, int req)
 		}
 	}
 
-	if (found) {
-		list_del(&iter->list);
-		kfree(iter);
+	if (flow) {
+		list_del(&flow->list);
+		kfree(flow);
 		pfvf->flow_cfg->nr_flows--;
 	}
 }

base-commit: f443e374ae131c168a065ea1748feac6b2e76613
-- 
2.25.1

