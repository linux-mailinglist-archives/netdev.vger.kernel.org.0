Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3716C623217
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiKISJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiKISJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:09:37 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2DE24F0F
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:09:35 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ud5so49021345ejc.4
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 10:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fbCTPd6kJ9UGi3QAhvxinrgq+beJGg9acRzTs2s933w=;
        b=HUQLeu6JYR9w877YR9xRNJQwoM09E0eIME20tiO8hsXCX5ET8ydDg08etBrRgy9SwQ
         uZjcwGjfEtriDEcPi7/QgOB1SSyiClmVBXYUAlsGOpT/9y45tydaxcG/X/g6ngUqcN4F
         vjWszS9qkzKGGjeSddxrItRtSsRvieM6YHE835w6QZ4Q93ciPcG47tdEaWNYf3L4px/K
         RMsc3fP6losrzehs5m6tiu4RJSN+xKgbDMAPc8lxMhbRGGTQ319PUvXSWnUciC+JfsHg
         Hb7Cou6NXq7Vq/xjGDwCSLMwFh/ff+Xx5bQ66MPcVt4/+0Rw11iEAPOE1PoVQ5LhXfny
         ot9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fbCTPd6kJ9UGi3QAhvxinrgq+beJGg9acRzTs2s933w=;
        b=CFAtJ+b4LFEF+sPB4Z3TCjCar7O6ogW5CVml9jRFNth0mLA5ouPAC+G2hHj9t2BoSC
         GmOMRa6kiICvpJQftpTRjrbaTkC4g21GdzS7kCXxGI8kz2/b17DwZ64NUMe/sud9Sb2l
         QbLkqlsQa/xExAZ1BYBExXPu/zEiVAS8NHVVSkMSJwGxIL7uXSU+0wq4QSTySyQ45j0H
         4Q4Rikrr/BK4I63SQSr+M/DRetRzTizK+VrARoEC6VEh+iwBzWcEOAFkVnztCpyukWYF
         lF12jUDuUlegsQcNTMkwjHFGqhp6+YdcsCoxlG75g0k51ts4l61RrxfWmJCVzmVzeOZi
         dypg==
X-Gm-Message-State: ACrzQf3YI3R4p8digrlXeScI7pF1wc0nWu9CnPi191zBtq20VHXjX7KH
        gMFcYw7hoo5Q7Yi4tOR2ShE=
X-Google-Smtp-Source: AMsMyM5KW61FeMYJnxPmXZ2YI1bOq/TYLb67Exk/s9h5WlsqFeVBe4BgZxtzuy7HrSuO7tqBOF7baA==
X-Received: by 2002:a17:907:5ce:b0:730:bae0:deb with SMTP id wg14-20020a17090705ce00b00730bae00debmr58555698ejb.181.1668017374254;
        Wed, 09 Nov 2022 10:09:34 -0800 (PST)
Received: from ThinkStation-P340.. (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id rh16-20020a17090720f000b0077016f4c6d4sm6116311ejb.55.2022.11.09.10.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 10:09:34 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next 3/3] net: qualcomm: rmnet: add ethtool support for configuring tx aggregation
Date:   Wed,  9 Nov 2022 19:02:49 +0100
Message-Id: <20221109180249.4721-4-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221109180249.4721-1-dnlplm@gmail.com>
References: <20221109180249.4721-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ETHTOOL_COALESCE_TX_AGGR for configuring the tx
aggregation settings.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 1b2119b1d48a..630cf6737f64 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -210,7 +210,51 @@ static void rmnet_get_ethtool_stats(struct net_device *dev,
 	memcpy(data, st, ARRAY_SIZE(rmnet_gstrings_stats) * sizeof(u64));
 }
 
+static int rmnet_get_coalesce(struct net_device *dev,
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
+{
+	struct rmnet_priv *priv = netdev_priv(dev);
+	struct rmnet_port *port;
+
+	port = rmnet_get_port_rtnl(priv->real_dev);
+
+	memset(kernel_coal, 0, sizeof(*kernel_coal));
+	kernel_coal->tx_max_aggr_size = port->egress_agg_params.agg_size;
+	kernel_coal->tx_max_aggr_frames = port->egress_agg_params.agg_count;
+	kernel_coal->tx_usecs_aggr_time = port->egress_agg_params.agg_time_nsec / NSEC_PER_USEC;
+
+	return 0;
+}
+
+static int rmnet_set_coalesce(struct net_device *dev,
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
+{
+	struct rmnet_priv *priv = netdev_priv(dev);
+	struct rmnet_port *port;
+
+	port = rmnet_get_port_rtnl(priv->real_dev);
+
+	if (kernel_coal->tx_max_aggr_frames <= 1 || kernel_coal->tx_max_aggr_frames > 64)
+		return -EINVAL;
+
+	if (kernel_coal->tx_max_aggr_size > 32768)
+		return -EINVAL;
+
+	rmnet_map_update_ul_agg_config(port, kernel_coal->tx_max_aggr_size,
+				       kernel_coal->tx_max_aggr_frames,
+				       kernel_coal->tx_usecs_aggr_time);
+
+	return 0;
+}
+
 static const struct ethtool_ops rmnet_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_TX_AGGR,
+	.get_coalesce		= rmnet_get_coalesce,
+	.set_coalesce		= rmnet_set_coalesce,
 	.get_ethtool_stats = rmnet_get_ethtool_stats,
 	.get_strings = rmnet_get_strings,
 	.get_sset_count = rmnet_get_sset_count,
-- 
2.37.1

