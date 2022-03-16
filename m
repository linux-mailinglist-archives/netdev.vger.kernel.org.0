Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0284DB4E6
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353887AbiCPPcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbiCPPca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:32:30 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE276CA77
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:31:16 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id w12so4337980lfr.9
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gXcdhieAA47FRGUZv55L0SA+IGD/QOMNOM6xSa40RI4=;
        b=UBy4nH5Y4iPbbkkcXoeKXF5l/64CEjcy6HX+W1VNqmZFznqulqhd9FzFxWcc/exzgp
         37bqrfTdj/0Hx8t3bJ4scRtb8uPxOJ+yvWRwUNUcLVJaG6HYpwYEwYec7qxC5h65CnPS
         TWpjrpMk3p32lSFK2b4SEU0cFvWq98GdsFykp/npXoJUZOhul/HHot7LeiPBV7M5WAMr
         NbaZ7PQ0R6IpTqYnBXIMCCgtNMH+ay0ZWQbeQB/aqGpOdoMX3qFjuSRZRK2lYmfhwd4W
         k/s9uyg+q32PQ+mtWT+htsEN53mobBDWx03PD9KZzfPI3ZblIIzhWd4oNdvHCJ6x4zz8
         2pTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gXcdhieAA47FRGUZv55L0SA+IGD/QOMNOM6xSa40RI4=;
        b=zRSdPdPp4dpfnvRcyLOAvtaaM+N4dRM15ZhnLs//sYzhEQHtemGfwTr7y6gLLtfBqk
         LBUxP48hHeqp+edtdU3LJtMxoZovvTaxTOPEwvIKcBbD5HFAM7Gu1h+G9UdIuN8AcVG9
         /WkfywAXXkVN2F7Ni+MZFqSzj/yl9Y3ir/MEP8TmUSxo+Bvjj+BodHyV2UlnsPwh7XGB
         5oDueP7VV3yKxAFTCH/mw7agupZG07wIpzssdWyfWL1ukL6ugXeUDPp3wq6Nh73qYykL
         cwZibFGfy8G+AameF1Biq+OL8rqOZ1JvxNVn67bJeBe4PCYsN+gt5OUfNP+l2mF7G4Oq
         Fqvg==
X-Gm-Message-State: AOAM530hTUYXS4DFyNLl/M0/kzCChmHjpcBRwma5DZ44PJ/eJ6pl91HJ
        IxouuiocNg2d0m2EbyjE4pTls/i7JvamjmC4
X-Google-Smtp-Source: ABdhPJyopvXmbEHFFWRgG+rfpRaMnhKcl34BmexAD9MG8+Z1jzmr42ojuhmnoPJ8HucUBDV9/ZmoDg==
X-Received: by 2002:ac2:5e2f:0:b0:42f:ca77:c563 with SMTP id o15-20020ac25e2f000000b0042fca77c563mr137918lfg.318.1647444673503;
        Wed, 16 Mar 2022 08:31:13 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id bu9-20020a056512168900b004489c47d241sm205870lfb.32.2022.03.16.08.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:31:12 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
X-Google-Original-From: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: [PATCH v2 net-next 1/5] switchdev: Add local_receive attribute
Date:   Wed, 16 Mar 2022 16:30:55 +0100
Message-Id: <20220316153059.2503153-2-mattias.forsblad+netdev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316153059.2503153-1-mattias.forsblad+netdev@gmail.com>
References: <20220316153059.2503153-1-mattias.forsblad+netdev@gmail.com>
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

This commit adds the local_receive switchdev attribute in preparation
for bridge usage.

Signed-off-by: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
---
 include/net/switchdev.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 3e424d40fae3..f4c1671c2561 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -28,6 +28,7 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
+	SWITCHDEV_ATTR_ID_BRIDGE_FLOOD,
 };
 
 struct switchdev_brport_flags {
-- 
2.25.1

