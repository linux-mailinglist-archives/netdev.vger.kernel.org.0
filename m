Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99274D9163
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343845AbiCOA1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343821AbiCOA1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:27:44 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC5D41338
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:30 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id u7so24280093ljk.13
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=A06tchB5P3xNuM8C6LfTzO8n4EM355S64hg7ZjA31l8=;
        b=J3HeoXTX/1HQ/6fEPZfupMGyBSjjAVjNhAIGypTRot8ER1tjFtwitWetTcMFZbo3db
         ZXGnrTNHS0d6QE9+6OgLCBbBRQdzmB9Y85dGdKi8loVMxwA0oqiqO9BZz3DwriPCitKK
         /oditpPfg9L2HtXrJVdMGLHXqNxJljj9EeyskVNqaDpyMcT7KrFWcyB6Rp3fe6ZCAIEJ
         Q1wPxEMqIJ/mzrINSlk5CHpneIQZ7ein7mVmhxZzqQMY6NZU+8vdBchc6EKzRfZj0fJQ
         RjoHORQCr0Pr+olXPepADfK/fb8fGqR7liG8OYsmXYSt5jALOHXh+w0wz39ZshDJolI1
         cc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=A06tchB5P3xNuM8C6LfTzO8n4EM355S64hg7ZjA31l8=;
        b=LAsGQN4oCxpV08pr88qEwHCp/bNqpxsAyHVE5Fo56H6x0c1/zq40vscaqTs8WgNVz6
         38rR8IFyEWHp/dfPN5HS50DDhqAQLtxJ3/zxBk7DgxyTXTQx95YUwFDv9RWLrVgOrHIi
         TJpujZbhKWDoNOzlCTkNhUrXzQHx/OxrNCkYaWXxMyVwrU1PDcr8SGSPSgzNTJ0GM+5S
         yHJUUbfwrLPrk3q4AZ12VbzU7JiRZXNHiN3hiTtpqCVV0VLZzTaWmfQfsnpWxcy5lnDd
         +8Rr69XVrwiHD4S3T3ONUFsDAlBEzPUAJsfnGcQnHv7WLOh38lY2QfEkPmDoOHGzlWxM
         MCeQ==
X-Gm-Message-State: AOAM532pt9i2WfXE9Tqhy2EzZ/QDcA6/jcy19dIUNCHRFM5o0wF8UKbK
        9r5VzEwXbsKMvC/So5o90rw+Ag==
X-Google-Smtp-Source: ABdhPJwHgx5nacsEPfqdj4toKXeV2VENcrFf4XQMCjyLQ+xZkaf1T0gCIjySj7UK+aDfvm48DLdCkw==
X-Received: by 2002:a2e:b7d4:0:b0:249:2321:1521 with SMTP id p20-20020a2eb7d4000000b0024923211521mr9698436ljo.223.1647303989294;
        Mon, 14 Mar 2022 17:26:29 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y14-20020a2e544e000000b0024800f8286bsm4219923ljd.78.2022.03.14.17.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:26:28 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH v4 net-next 09/15] net: dsa: Never offload FDB entries on standalone ports
Date:   Tue, 15 Mar 2022 01:25:37 +0100
Message-Id: <20220315002543.190587-10-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220315002543.190587-1-tobias@waldekranz.com>
References: <20220315002543.190587-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a port joins a bridge that it can't offload, it will fallback to
standalone mode and software bridging. In this case, we never want to
offload any FDB entries to hardware either.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a61a7c54af20..647adee97f7f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2624,6 +2624,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	if (ctx && ctx != dp)
 		return 0;
 
+	if (!dp->bridge)
+		return 0;
+
 	if (switchdev_fdb_is_dynamically_learned(fdb_info)) {
 		if (dsa_port_offloads_bridge_port(dp, orig_dev))
 			return 0;
-- 
2.25.1

