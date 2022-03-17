Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766594DBFA5
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiCQGwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiCQGv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:51:59 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B226A27F6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:42 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id w7so7424443lfd.6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JxLEWNkta/vpkDsBY4QhLGrjAG0PeNah3cTWg60yylY=;
        b=YrHkU0Efk0AYtMhnCoG4+fkfUX2I0R2SKa7BQ8u0POuqwo7y/1T3Lb0VQv21MtM5e/
         caqe7h9scKM4qsGEafiZLda2263AH6iur+DsyIZZYewP6Xo21/KhCWyElFXRjpGk0QlT
         4stqB/eY/XRVFJ6GvWluM7xs8lCpQJwvCwbEC2UYtRq7Mktm8U8OhwqdDJkMLrWAIkvv
         zY11LFVhZ+wsE0oZGLouPIjGyXP13e6FPrnDngHhnBqARbHjdc6kBPWObZXEbjVrAKvI
         m1QR5MQP4v2BGOMfvO7kOo+DEDyY5CpfMe5O6zyQ0MlbkyagXEMluIQSDdN3u3aC3ZfW
         Ua9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JxLEWNkta/vpkDsBY4QhLGrjAG0PeNah3cTWg60yylY=;
        b=Cq1bpMvEY798ClBfVegVxqbSPYsvbTAP131XrwtyfWZKpVmQ4Tjk2JSp6t70eFuT9v
         jwiOOmPwkgd2Jdnw9/y6SbK/jAGAo/xag9s+puOpM4IszYEg/8JBM6Iay7FQfIa5BVXS
         uL9D7ls1tFSaf4DrjYhLMEGdXlbrbbnY6DD0mXEGTgAMh6aF11mtu4ppBFPBdwO4S2jt
         pjna0+jj+oETepHMtqfPlJKqP3FQLDpMFFHdADwgxMx2FM+z90R7yqG20t3L4nTJjo5V
         IJDJxg9S3Lsx2uQ8wwM0uWNC2mZIk6bThF26EdVvd7lgV7jCFIFPiWGDH4g6ngVsjpwc
         EyAA==
X-Gm-Message-State: AOAM5318MpPIvwOodmBZfPhMeu2HhGSopnOOFeDGFITvjFpNQvU0XixE
        obcVWRi31/78Qhcz5QMfah2etsVK4LoFFQV5
X-Google-Smtp-Source: ABdhPJyM6nEHQTuLK7fl/d3Sj0hdJEzf1R6P7h0zS3xo+PJZI1IZfZhlwm7KLVa1jQU4yv7gzsh+zw==
X-Received: by 2002:a05:6512:2308:b0:449:f7eb:cc2f with SMTP id o8-20020a056512230800b00449f7ebcc2fmr831113lfu.37.1647499840633;
        Wed, 16 Mar 2022 23:50:40 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id l25-20020ac25559000000b0044825a2539csm362215lfk.59.2022.03.16.23.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 23:50:39 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH 1/5] switchdev: Add local_receive attribute
Date:   Thu, 17 Mar 2022 07:50:27 +0100
Message-Id: <20220317065031.3830481-2-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
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

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
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

