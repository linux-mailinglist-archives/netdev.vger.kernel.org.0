Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD8A5F02D5
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiI3Cem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiI3Cei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:34:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15531BA;
        Thu, 29 Sep 2022 19:34:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3448EB826C8;
        Fri, 30 Sep 2022 02:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498AFC433D7;
        Fri, 30 Sep 2022 02:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664505268;
        bh=THYSe4RrxRWcp2Wlc742Yd/A4pR5D/r9vQGDFvzuFWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfqf8S1AUcvOWyNxNfVU6+KbDa53knG5M3WwV7BGvagIYIo0iF8EMGVVnfrkIlvIi
         qJ5DqV8mv5phut2Ufps/gjwmu1Bdgt8FunWm+jBLS11Ct+mRZO6juikE9Fse5u+3Nh
         xPoGm8XQYRvLliJ0ut+y9cpRkD8H1z7e8atzodtfALli19uXAEQ9Qy2gqklvRxBSzg
         yGujEG1W81f1ztXo+soHxcoFBLDDrXxbQS9zdkT6m/JWloYOwJLgLoLKpDSvDQPMkC
         +ZiqTGwqAzR54epzSDPNwP7K9cW7hKWkcC+nfNp1QLMVgPaYEo8apUmxoaoWHwnW64
         46TtYEInYBclQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net, ecree.xilinx@gmail.com,
        stephen@networkplumber.org, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 6/7] net: fou: rename the source for linking
Date:   Thu, 29 Sep 2022 19:34:17 -0700
Message-Id: <20220930023418.1346263-7-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930023418.1346263-1-kuba@kernel.org>
References: <20220930023418.1346263-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll need to link two objects together to form the fou module.
This means the source can't be called fou, the build system expects
fou.o to be the combined object.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/Makefile              | 1 +
 net/ipv4/{fou.c => fou_core.c} | 0
 2 files changed, 1 insertion(+)
 rename net/ipv4/{fou.c => fou_core.c} (100%)

diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index bbdd9c44f14e..e694a5e5b030 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_IP_MROUTE) += ipmr.o
 obj-$(CONFIG_IP_MROUTE_COMMON) += ipmr_base.o
 obj-$(CONFIG_NET_IPIP) += ipip.o
 gre-y := gre_demux.o
+fou-y := fou_core.o
 obj-$(CONFIG_NET_FOU) += fou.o
 obj-$(CONFIG_NET_IPGRE_DEMUX) += gre.o
 obj-$(CONFIG_NET_IPGRE) += ip_gre.o
diff --git a/net/ipv4/fou.c b/net/ipv4/fou_core.c
similarity index 100%
rename from net/ipv4/fou.c
rename to net/ipv4/fou_core.c
-- 
2.37.3

