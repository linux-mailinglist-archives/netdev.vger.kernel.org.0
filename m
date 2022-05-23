Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C7A5310CF
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbiEWKne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234225AbiEWKnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:24 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1CCFC7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:14 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id rs12so16136186ejb.13
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9b8E4PRx8BrnW1sgEjVk4LHh4D9piAhyes9wV5gbLT4=;
        b=ITmwBszaldoMBsXIkHaKjCYbI4aP3VzacNm61DWwP+w+VkM3fMDGk9tgFPe7zfj4/M
         dMrXza430//ZsnWf4/jgUL7DNMSQ7hnkMUtRpltgaA3j216Pw76L3VYxQPCRTdMRPn8E
         L96rKV4aN4r+lA5TWTqRgPQvAg9Rpl+hotLbbK8dD+wVDrmTKmPRjgA/GUgKMMmwg+jg
         ZzOAx47rd4B77Y5h906GKtaGyb+HAMztWjrn/lP5ri/Z5v/wbtO9q7fJXEWHT6uXRTgJ
         lYda7E1uoGRTVpjvOZIEWFkHW2+u5vWrWnE36J14GbAZDnso8BwgntybDJvA3GrcI4nK
         iXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9b8E4PRx8BrnW1sgEjVk4LHh4D9piAhyes9wV5gbLT4=;
        b=dUnKDsHVL8e9xJYEOWfZL8WWvSPxVjFk+ZwS0MxXUOeUngEZ4fsGXrFHRHiLxcHP2c
         k9wg2VyjBi+dpkOk739BxbZo5bzruWMFQTRBXWXkiQORSYLK5FcLrcMUy17F/C2qJ2FB
         +nQFNCPQvb7gzce7QGj2CZSu/mDKQMl0hcjCindZiUmKNP/IEaJwibTWvjDu0lMkpphn
         cw4lUi4ArJeEXOE20Zzq5Iq5/8hynUX7ZDMTwPqOd1MnZI+K/pw4LoWfSUPN2/WKbvZZ
         Ejfcsu7+p1jz3F8rFjwi4OYC8IQLq9QwAsoqHWf4REcseL8dpu8CHo3aMBC83shWv960
         xZ9Q==
X-Gm-Message-State: AOAM532PgUrj/zp+qWjDTgfRIFZbaLQjLNGsHZWMGk+MdlhgqjUktkY3
        8lZVTpKrZaOqERLVIgA3BQDkxcF3Amg=
X-Google-Smtp-Source: ABdhPJyorbpDeYvxLfO1inJDQwxtC9mUgtncwQMjN6MSnX3rv9pgZ9zytBwDTyE6JMJQNTQvwvBtyA==
X-Received: by 2002:a17:906:4b55:b0:6fe:c52c:68c9 with SMTP id j21-20020a1709064b5500b006fec52c68c9mr7274113ejv.491.1653302592700;
        Mon, 23 May 2022 03:43:12 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 06/12] net: dsa: only bring down user ports assigned to a given DSA master
Date:   Mon, 23 May 2022 13:42:50 +0300
Message-Id: <20220523104256.3556016-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is an adaptation of commit c0a8a9c27493 ("net: dsa: automatically
bring user ports down when master goes down") for multiple DSA masters.
When a DSA master goes down, only the user ports under its control
should go down too, the others can still send/receive traffic.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 0455fb3cf03d..c0be747c66ac 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2848,6 +2848,9 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 			if (!dsa_port_is_user(dp))
 				continue;
 
+			if (dp->cpu_dp != cpu_dp)
+				continue;
+
 			list_add(&dp->slave->close_list, &close_list);
 		}
 
-- 
2.25.1

