Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73114F7CDB
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244373AbiDGKdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244313AbiDGKdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:33:37 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E0263BEE;
        Thu,  7 Apr 2022 03:31:16 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l26so9929098ejx.1;
        Thu, 07 Apr 2022 03:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k+AveRuUfZMS7nrLE2qCYNI1T96Mx5+XYDPrjV8syDQ=;
        b=NcLD8mHaR4qaNPR6BVkLI8cR0N9faisH5bqM+PPDilSapF2TaoYIOm6cL6AzD7IbWj
         CBshM5QiBxeaw54xMXgap91pls2Kb5DPu5mg9Xg/5UAIUU4gW1w0pOZS0KeKNWr/kVJ3
         BrDl1iS2myhrhLtoREcwcpaaioyTRJl8NPRjZxfUF6qzcfXh3RzU4tevnL07WCFfBVV3
         PcqElTxD9nGyEUKAvM6/iFJitBW2/ljIDlNeUUcU2bf2uYx9XQVu+BmitEAqntOci0IY
         KMSBsY+JaFePOA6R2px14qoCJFT2c6j5LEg2gkuS+B04U9JJfAQVgVh381Rebhkj3RMz
         Z+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k+AveRuUfZMS7nrLE2qCYNI1T96Mx5+XYDPrjV8syDQ=;
        b=jvwONzr+OKthjzdM9bFnfv2NWdaq/81WUhEVB5FtkSwzpwDnoIVgTwEginhg4WaEer
         jTen1Mto9n+35LDPESFDnuITIIB/sT16tDJI1llI1N8O2vS95IXxV6a5g7j8ey09qibM
         BlCIVizotjb/N0DfPbmNOCDYS3yGdXhbiuXa6cKWbTvVUX1+uNP3Zw2zX9zFyVa66QSp
         aCu+N6Y12eaVddnUHAOixb/zFBAIRXPsFJZ7KWW2HL0tHODQf/HBrpx3MsTS4c1t/Tmv
         nKg/8l3UIjfNY24IG2nDW9ok8UFMtFWUsJdEWggM2fpt339WQqMuCjNpL7GAKdE3QJ72
         nfHw==
X-Gm-Message-State: AOAM532uumVriExVQMcpLwi2wkwcDUxkRUb8R+JaLYGa6to0qg2wnsGR
        sYHornkIWYXbr4NjMvqrUrs=
X-Google-Smtp-Source: ABdhPJyUMk7P7yhyEFZWum6NOrzRuYQhvq6Vl8oB+OA51dwydUryDEsWaJ7QTxbXBBuOO2+NpgZo8A==
X-Received: by 2002:a17:906:5d14:b0:6e8:3897:9ec2 with SMTP id g20-20020a1709065d1400b006e838979ec2mr2114089ejt.708.1649327474884;
        Thu, 07 Apr 2022 03:31:14 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm7413573ejz.57.2022.04.07.03.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 03:31:14 -0700 (PDT)
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
Subject: [PATCH net-next 11/15] sfc: Remove usage of list iterator for list_add() after the loop body
Date:   Thu,  7 Apr 2022 12:28:56 +0200
Message-Id: <20220407102900.3086255-12-jakobkoschel@gmail.com>
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

In preparation to limit the scope of a list iterator to the list
traversal loop, use a dedicated pointer to point to the found element [1].

Before, the code implicitly used the head when no element was found
when using &pos->list. Since the new variable is only set if an
element was found, the list_add() is performed within the loop
and only done after the loop if it is done on the list head directly.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/ethernet/sfc/rx_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 1b22c7be0088..a8822152ff83 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -563,8 +563,10 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
 
 	/* Search for first gap in the numbering */
 	list_for_each_entry(ctx, head, list) {
-		if (ctx->user_id != id)
+		if (ctx->user_id != id) {
+			head = &ctx->list;
 			break;
+		}
 		id++;
 		/* Check for wrap.  If this happens, we have nearly 2^32
 		 * allocated RSS contexts, which seems unlikely.
@@ -582,7 +584,7 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
 
 	/* Insert the new entry into the gap */
 	new->user_id = id;
-	list_add_tail(&new->list, &ctx->list);
+	list_add_tail(&new->list, head);
 	return new;
 }
 
-- 
2.25.1

