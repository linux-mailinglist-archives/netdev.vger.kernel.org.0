Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88FD530FE2
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbiEWKnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbiEWKnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:24 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC31245A7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:12 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id m20so27841795ejj.10
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=icSnCHuOPlD4V5+tswNuOL7gl86u5U7QFKaufHVUslg=;
        b=QgAO1M+XVOzLeIe9o1Qi0pLPfPLV+5+7mgrIp8C3XgFXRjmXU3lLaRgNyS9pZorrFo
         HmWrRP9AIVRW8/WKbU5kgE/z2U/1LylgMzR+uMruUPaMSZExsmsw7IR9Bbe97tE5Y5bk
         yjsAuTBBx/QCFzPg4WmOZX7VVh0fUY5agQFfUbfeCL7fn7qsTQpNUdv4VGlSjCcR1M6K
         xeNbPFoaUyT85h6kDCB6zubq7ZDp0B89iBfDpPaAHG/euId9L1gJKsZJ2WtcAr1w5ODS
         WZdPuNKI2BCX9CjDD6ZhMNYuj5Vv0FtKaeXWBDj4esVWY6pOVJh/ZD06V35kdgW1s0Hu
         CWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=icSnCHuOPlD4V5+tswNuOL7gl86u5U7QFKaufHVUslg=;
        b=1T+4ZEJ+waOxYtJ3VDIaJzmIpJlTSXFoj7UCoJfcFYvhcErhqIe1b+zf+LdhwqUGDW
         yoe+Nf/FnWyZQ+i/lsJYbq3d3m0lIy2sJKs4WFbzR6PHUdf+mCt/QIghhzkHifapnm/0
         2aR94vlkbygTj8BtVf1SipSxTlM9zwgI6WNtHQSGvzoGzK4ezcgoN5S6CYpOAHXPD/St
         YyW/fPb07W6m0xxNedyJkvnan8jvngBes2UWu2S3/zYU8XlRez2c23Y1829CCBE8cMsr
         dVXgzIIwsklkHVmtQwYxzoLZvWpC6vaZgyv7L0te0NuBkL7aBWjmLC0/htJ8EIrvlsbu
         HdLw==
X-Gm-Message-State: AOAM530oD2hVL+Udy6NwDN7lSY4trEkXGgGqk68VK+xL5wfTs3ctu3ff
        EeDRbHQG0eUYLPKnWKv2hptOeaI9e5w=
X-Google-Smtp-Source: ABdhPJyf9EqB4KV/W3UYWxqrgeamy1EqOk1XUWRra2baxk8eTR2h6Dy69M2dpTTLD7tdm20rqjkRFg==
X-Received: by 2002:a17:907:9490:b0:6fe:a4bc:b71e with SMTP id dm16-20020a170907949000b006fea4bcb71emr14120492ejc.39.1653302590862;
        Mon, 23 May 2022 03:43:10 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:10 -0700 (PDT)
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
Subject: [RFC PATCH net-next 05/12] net: dsa: existing DSA masters cannot join upper interfaces
Date:   Mon, 23 May 2022 13:42:49 +0300
Message-Id: <20220523104256.3556016-6-olteanv@gmail.com>
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

All the traffic to/from a DSA master is supposed to be distributed among
its DSA switch upper interfaces, so we should not allow other upper
device kinds.

An exception to this is DSA_TAG_PROTO_NONE (switches with no DSA tags),
and in that case it is actually expected to create e.g. VLAN interfaces
on the master. But for those, netdev_uses_dsa(master) returns false, so
the restriction doesn't apply.

The motivation for this change is to allow LAG interfaces of DSA masters
to be DSA masters themselves. We want to restrict the user's degrees of
freedom by 1: the LAG should already have all DSA masters as lowers, and
while lower ports of the LAG can be removed, none can be added after the
fact.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 309d8dde0179..0455fb3cf03d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2674,6 +2674,35 @@ dsa_slave_prechangeupper_sanity_check(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+static int
+dsa_master_prechangeupper_sanity_check(struct net_device *master,
+				       struct netdev_notifier_changeupper_info *info)
+{
+	struct netlink_ext_ack *extack;
+
+	if (!netdev_uses_dsa(master))
+		return NOTIFY_DONE;
+
+	if (!info->linking)
+		return NOTIFY_DONE;
+
+	/* Allow DSA switch uppers */
+	if (dsa_slave_dev_check(info->upper_dev))
+		return NOTIFY_DONE;
+
+	/* Allow bridge uppers of DSA masters, subject to further
+	 * restrictions in dsa_bridge_prechangelower_sanity_check()
+	 */
+	if (netif_is_bridge_master(info->upper_dev))
+		return NOTIFY_DONE;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	NL_SET_ERR_MSG_MOD(extack,
+			   "DSA master cannot join unknown upper interfaces");
+	return notifier_from_errno(-EBUSY);
+}
+
 /* Don't allow bridging of DSA masters, since the bridge layer rx_handler
  * prevents the DSA fake ethertype handler to be invoked, so we don't get the
  * chance to strip off and parse the DSA switch tag protocol header (the bridge
@@ -2728,6 +2757,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_master_prechangeupper_sanity_check(dev, info);
+		if (notifier_to_errno(err))
+			return err;
+
 		err = dsa_bridge_prechangelower_sanity_check(dev, info);
 		if (notifier_to_errno(err))
 			return err;
-- 
2.25.1

