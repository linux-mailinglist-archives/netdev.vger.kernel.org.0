Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345C74DAD25
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 10:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354800AbiCPJE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 05:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354808AbiCPJEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 05:04:24 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6042B3B03E
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:03:10 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id w27so2624882lfa.5
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=t2CRzrgahtfo2iExTmslBzR/8VbBIWJNqdJzNLMxip4=;
        b=aGO2uWolObtYOfnHbgJKroQhQXvKsWdGjxKk4xGA+pI+yJ/kFDDkVqjDV5KBrf00uC
         faUFM45mGFt6ehSMlZKSd9GZRe9REGlKj2xPs0RwAY8F2e5daiWHOZP9fFz58jY1A/oB
         uv0huxhO23V+B2Is1O56obaHXYhlYcr4lrXdRl6j4SMzfQoL8XLwbqKwYMRZAEc2ou7Y
         CEuecMzVOLFpf7gN/nOeIDldxIzCDRRNAojrYbCxrJca5rvcL6t9nLSx93PpCCmbr0Tx
         1PM9gxR4ScymGt/CpOLqJGz8psMC/SLSbJDso5UWL4zw0hQ9vZZVCrNEXQLHyYx6qCbA
         va/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=t2CRzrgahtfo2iExTmslBzR/8VbBIWJNqdJzNLMxip4=;
        b=Cyk3euJU51w7ea9DZi+VZQswe4JPInpqNZY46aSFizJqjImRJj74QVKu6EahyvcF2H
         WMhllQegM/L943cUwPOkHwl/ijoOdS11sGKUtN9SgWA3KEtSvWndUSUYlh5wOTl0mTWu
         n3UKs83ppo0lVF/HIs+G5PelcuJMKtIrFtU3opEWdAnqEnaKUBIJLPxNlXGAgl3v21iz
         NBRwC5e6WnsfnaawmSfmxcI7cZ4Z8SZC/FDcxR9jNmJNc+MrTY9Zqb5ZK1qDIBRlL/Q5
         ZRV7kjYmfu8FzSLQrcTLDMamn9a4PvOdV4bZjmPuVmNfO2HwIv/DLD0LEGRa+CRZW+L6
         frwQ==
X-Gm-Message-State: AOAM531Vi9GSqXBKJbq4DdRFBYUwlk48k8L7k0z8fvwxGw5A30qS+LM4
        S9KXeDIaOeWBXlSF4/vM5QEZpgUgKPDTKg==
X-Google-Smtp-Source: ABdhPJzp53EjR2v8irN7y7CwMwscBJvWdrWCcnnEyICmewURI5ilxqj61o1BVeBwRYixGfjRl5q0NQ==
X-Received: by 2002:a05:6512:3b22:b0:448:1d8f:1bfa with SMTP id f34-20020a0565123b2200b004481d8f1bfamr18930206lfv.247.1647421388076;
        Wed, 16 Mar 2022 02:03:08 -0700 (PDT)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id j17-20020a2e8511000000b00247ee6592cesm124111lji.104.2022.03.16.02.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 02:03:07 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next 2/2] man: bridge: document per-port mcast_router settings
Date:   Wed, 16 Mar 2022 10:02:57 +0100
Message-Id: <20220316090257.3531111-3-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316090257.3531111-1-troglobit@gmail.com>
References: <20220316090257.3531111-1-troglobit@gmail.com>
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

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 man/man8/bridge.8 | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 93852ed8..2fa4f3d6 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -47,6 +47,8 @@ bridge \- show / manipulate bridge addresses and devices
 .BR hwmode " { " vepa " | " veb " } ] [ "
 .BR bcast_flood " { " on " | " off " } ] [ "
 .BR mcast_flood " { " on " | " off " } ] [ "
+.BR mcast_router
+.IR MULTICAST_ROUTER " ] ["
 .BR mcast_to_unicast " { " on " | " off " } ] [ "
 .BR neigh_suppress " { " on " | " off " } ] [ "
 .BR vlan_tunnel " { " on " | " off " } ] [ "
@@ -473,6 +475,19 @@ By default this flag is on.
 Controls whether multicast traffic for which there is no MDB entry will be
 flooded towards this given port. By default this flag is on.
 
+.TP
+.BI mcast_router " MULTICAST_ROUTER "
+This flag is almost the same as the per-VLAN flag, see below, except its
+value can only be set in the range 0-2.  The default is
+.B 1
+where the bridge figures out automatically where an IGMP/MLD querier,
+MRDISC capable device, or PIM router, is located.  Setting this flag to
+.B 2
+is useful in cases where the multicast router does not indicate its
+presence in any meaningful way (e.g. older versions of SMCRoute, or
+mrouted), or when there is a need for forwarding both known and unknown
+IP multicast to a secondary/backup router.
+
 .TP
 .BR "mcast_to_unicast on " or " mcast_to_unicast off "
 Controls whether a given port will replicate packets using unicast
-- 
2.25.1

