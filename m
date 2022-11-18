Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8808062F905
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242348AbiKRPNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242244AbiKRPND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:13:03 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8102D3120A;
        Fri, 18 Nov 2022 07:13:02 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id j15so9031841wrq.3;
        Fri, 18 Nov 2022 07:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RBu6ZO+1FiLFyP3QbWuC4gA1lMk94ckwWc0IZKeuNxM=;
        b=IlNQILsvhOTrBMZRldCQgd/g0Ibcf7lIYqkJKKHGSOuuytLtPYQar7KOrf/E9czZgB
         ssNm0c5jB488Aqe2gZcke4eU7FzNWEjoh0OjtqfNKYorVbwGMzsn3D3b5t4ITMGvy0A2
         pctA04IRg9BRvVqMWQ3oHRucyx/MvjarjwLgcRRUgkntwHA+yuytezYWzsp+fEV7CqGn
         UsCHqqzYqc6dENW7wS+ItttjEg4V504jutac/qejkSFTAdUFmhMqVEPLZVoG/3JES3US
         NLwa9PEWVt7hj0MY6HaW9W28+kZbZxvEQB1pEg2vdthIZ/izZk0smlOePekPUdlJplC/
         DLNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RBu6ZO+1FiLFyP3QbWuC4gA1lMk94ckwWc0IZKeuNxM=;
        b=itON++eGWIXwghyOP4ukyzO9bJ+5amESWRZS6dHxLxf2fCy1K1fXvJ7tKiY+oaTukW
         +HqS8Q+hVKPvsYE1CiQz9yTf1sbNuI+5fZwUiPJfJJYYeD7YdD1j6u6gWZB3tfG0auXO
         WqOtBfVMRgp0HeAFs1PJ90oXOA/Pfl2RAGDUbDez6Vu+j/MnJNTHsx/VVK65YTzLXkqw
         rC+ypeZY9bBWqi9ZqyFFspVmyZC7KOjAb47f30hr4g2bFtQpE5hBDOIfMVw0gAX0uchL
         Hw0Xy4ZPgeQKugDxfNYAQZ8xFrE40VKed+8UD2kWA/GpLIcJM/pgc86LwYfFk0QQjLv3
         OnFQ==
X-Gm-Message-State: ANoB5pmbS8nLJffFf2YOcpDx/TJXmkCmWvv3FpBX5rblqCly7KcYHt8z
        YvaTv6xE9YRjKobgfE0OWdk=
X-Google-Smtp-Source: AA0mqf47gtjGxXnD6K/2zYyQqGHg8iCiEhbq37b6wmEosMtfiHwlnpqPm0VXzSNtZc5icFffJy6KXQ==
X-Received: by 2002:a5d:6551:0:b0:236:8fa1:47cf with SMTP id z17-20020a5d6551000000b002368fa147cfmr4815179wrv.50.1668784381085;
        Fri, 18 Nov 2022 07:13:01 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id c2-20020a05600c0a4200b003cfd4cf0761sm10266842wmq.1.2022.11.18.07.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 07:13:00 -0800 (PST)
Date:   Fri, 18 Nov 2022 18:12:52 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Casper Andersson <casper.casan@gmail.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: microchip: sparx5: fix uninitialized variables
Message-ID: <Y3eg9Ml/LmLR3L3C@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains that "err" can be uninitialized on these paths.  Also
it's just nicer to "return 0;" instead of "return err;"

Fixes: 3a344f99bb55 ("net: microchip: sparx5: Add support for TC flower ARP dissector")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index a48baeacc1d2..aab7507cf568 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -341,7 +341,7 @@ sparx5_tc_flower_handler_vlan_usage(struct sparx5_tc_flower_parse_usage *st)
 
 	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_VLAN);
 
-	return err;
+	return 0;
 out:
 	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "vlan parse error");
 	return err;
@@ -452,8 +452,10 @@ sparx5_tc_flower_handler_arp_usage(struct sparx5_tc_flower_parse_usage *st)
 
 	/* The IS2 ARP keyset does not support ARP hardware addresses */
 	if (!is_zero_ether_addr(mt.mask->sha) ||
-	    !is_zero_ether_addr(mt.mask->tha))
+	    !is_zero_ether_addr(mt.mask->tha)) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	if (mt.mask->sip) {
 		ipval = be32_to_cpu((__force __be32)mt.key->sip);
@@ -477,7 +479,7 @@ sparx5_tc_flower_handler_arp_usage(struct sparx5_tc_flower_parse_usage *st)
 
 	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_ARP);
 
-	return err;
+	return 0;
 
 out:
 	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "arp parse error");
-- 
2.35.1

