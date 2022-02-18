Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C834BBC8B
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbiBRPxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:53:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbiBRPxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:53:30 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB01F2B4D80;
        Fri, 18 Feb 2022 07:53:09 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id bu29so6386249lfb.0;
        Fri, 18 Feb 2022 07:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=xsR/hKbVC0DUFloHcPTPuu9npcAFNkMVex8QVbhOYjs=;
        b=PgVAF2CFxXClr7XtfIleyOCx+Gi9xnzlboqeOO6fOXSA4GfJD2Ha0fAgYXYPdDHteC
         vVpqeRpulaJTSnmFzPLBnW61aOBN8o/IHCO1jXT5f+Dl4hdm0GITuRs6lSQLQoK2PC/g
         pIIRO1x/od0SMlwA9qsptKJvUIuTiHb5ffM7Q3KwGC6EpDsKd5SmiSTUCqfUN4cKVXzD
         CyL3Zbh+2JNub0wD9nXiGQtIYWWRQmbJfNpp/OfwYI9X8R6GLysRgcKKwAGrzcDbNCib
         eD0KcsEZSDdTLX5/zZb+U2TCtTLJz+1//jTSo2e7/4HBAK9JuKLsqvps2AB9GiceJPNl
         Ekjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=xsR/hKbVC0DUFloHcPTPuu9npcAFNkMVex8QVbhOYjs=;
        b=JoMdjTMCyBsHuoQbgb8hpKXCOKY+V3Scgg2idV/vhfWK3++0msMwTOWAgt6ut2SBIE
         BTdt3wfI5WGVDZyLXi+WPNWrz8hs/6QsdSdZ078mTK1UXi4Yv0urWch28lbSvJlWSfL1
         flbgvt/ZxfnoEElITyDnzHVv3uWHgBhxux9eg+dgAc5bZgsUjA8vCljeYzOD+zsoVWRU
         o9TI8O5ZS2OloN36xvG92g8uQWN/WXwtzpUHZc53nDmBEJthWAJbKAu+y/VPZMSWXCEL
         TUmtJmX9X3Qvjs1LYeE74bA/4C67Kr7N1ReFfFkI9qm8nsKmnXU/S5y6UFp7wmyYyyZv
         gH+g==
X-Gm-Message-State: AOAM530J50PL1eEIIFJSTrlOkh8Fph/LgxP5MKqvzM3Lt+FTCZjShJ5l
        rT1U4tDdCx/+5ffIXyHo8GA=
X-Google-Smtp-Source: ABdhPJxf1VgdE9FjUrG2Oi4IAPd+jiHT04vxuDLYzDhWK7uJvLNPkAjxOe6PtwjlzS+9t2RKS3e9vQ==
X-Received: by 2002:a19:7605:0:b0:443:1126:3756 with SMTP id c5-20020a197605000000b0044311263756mr5774248lff.641.1645199588095;
        Fri, 18 Feb 2022 07:53:08 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id v11sm295453lfr.3.2022.02.18.07.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 07:53:07 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v3 3/5] net: dsa: Add support for offloaded locked port flag
Date:   Fri, 18 Feb 2022 16:51:46 +0100
Message-Id: <20220218155148.2329797-4-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
References: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Among the switchcores that support this feature is the Marvell
mv88e6xxx family.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 net/dsa/port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index bd78192e0e47..01ed22ed74a1 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -176,7 +176,7 @@ static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
 					 struct netlink_ext_ack *extack)
 {
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD;
+				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	int flag, err;
 
@@ -200,7 +200,7 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp)
 {
 	const unsigned long val = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD;
+				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
 	int flag, err;
 
 	for_each_set_bit(flag, &mask, 32) {
-- 
2.30.2

