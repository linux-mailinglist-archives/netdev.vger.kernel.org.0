Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9120363D604
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbiK3MxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbiK3MxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:53:19 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3695431F8F
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:53:18 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id vv4so41116118ejc.2
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8arER4SCpRhUeAWIzQvVc+hSndhnyg5vUHS+iCW4tM=;
        b=qtdwO188IMfLWxv91WqrUf3g7vRsX3Xm9dLiyT/JTh1JZGq6vvZCfB0nGsGyWXL7kJ
         zeqWapOfR/D+FSd52DPl8MYL4ia21yN4ZdSCy3R7zsgiHxmAUQycNP8Fp6G2ZZ6n/MFP
         2YShLhpwj0lKFXnSAnoIsy2YX5t32nxWkSIe5hnRKgDWxFqT+N+ES3SNNhLzVDC12l26
         nD6x5XF3F7Wr4AY1v1ahgUGW8s1jwymWdy6V4wf34hFfQskMJN1l7CDM1eA/9TUDA7cZ
         IZga9yxdF9OZzcBuLI1eu+S1QwWK194Q5GFBzkEr0Rtov32uy+XNxUYBdTBx8VAHA5Z/
         CEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8arER4SCpRhUeAWIzQvVc+hSndhnyg5vUHS+iCW4tM=;
        b=ur1v8hBajGVE97twolheF6SCuaVj5EJokqS0U2eiPupIafSP5F9aYjmuIsdHAJE/7j
         tInp9KOyIT+9mULzhv9d90Q+f6CJI0y1PwEVhA5iLLd1RIDkiwRQwtzO0kE0ZoIudoLL
         vtOc8ophgQhbYj7SufPDuTl/+v+5o71nC0omBnfUcwa0dKT2iqAe8FKo4zuCPwogC/rc
         SEUu3vdH+zHLUtHxdf2SI00Vsaj3BNslZP6VdfS0xAVpDPyinyB2NI1gVCDawkbzX9fq
         DUYx80pNsFgH5ISut9YoFVPHQM+oclxfRk6tJ2NXPWT+WjK5yGnJHh67V9sSUvqS/Ypt
         pBrA==
X-Gm-Message-State: ANoB5pn0SYdPADSpSkVb9Vo7TuLSeiMCBHXCGqPZFSgNPNExTcb7vt28
        Mkogt4U9nWUYkFvol+sa/m4=
X-Google-Smtp-Source: AA0mqf7CzXZZatDBma8PUK6f5L/aoKNx5N67+aVfPT2x5kBJ1CTxLh5P7HmBMxjaUUzdN3JwZIVO0g==
X-Received: by 2002:a17:906:f13:b0:78d:8e08:76de with SMTP id z19-20020a1709060f1300b0078d8e0876demr51818328eji.12.1669812796694;
        Wed, 30 Nov 2022 04:53:16 -0800 (PST)
Received: from ThinkStation-P340.. (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id v1-20020a1709063bc100b007ad84cf1346sm608426ejf.110.2022.11.30.04.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 04:53:16 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v2 3/3] net: qualcomm: rmnet: add ethtool support for configuring tx aggregation
Date:   Wed, 30 Nov 2022 13:46:16 +0100
Message-Id: <20221130124616.1500643-4-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221130124616.1500643-1-dnlplm@gmail.com>
References: <20221130124616.1500643-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
v2
- Fixed undefined reference to `__aeabi_uldivmod' issue with arm, reported-by: kernel test robot
---
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 6d8b8fdb9d03..046b5f7d8e7c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -215,7 +215,52 @@ static void rmnet_get_ethtool_stats(struct net_device *dev,
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
+	kernel_coal->tx_aggr_max_bytes = port->egress_agg_params.bytes;
+	kernel_coal->tx_aggr_max_frames = port->egress_agg_params.count;
+	kernel_coal->tx_aggr_time_usecs = div_u64(port->egress_agg_params.time_nsec,
+						  NSEC_PER_USEC);
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
+	if (kernel_coal->tx_aggr_max_frames < 1 || kernel_coal->tx_aggr_max_frames > 64)
+		return -EINVAL;
+
+	if (kernel_coal->tx_aggr_max_bytes > 32768)
+		return -EINVAL;
+
+	rmnet_map_update_ul_agg_config(port, kernel_coal->tx_aggr_max_bytes,
+				       kernel_coal->tx_aggr_max_frames,
+				       kernel_coal->tx_aggr_time_usecs);
+
+	return 0;
+}
+
 static const struct ethtool_ops rmnet_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_TX_AGGR,
+	.get_coalesce = rmnet_get_coalesce,
+	.set_coalesce = rmnet_set_coalesce,
 	.get_ethtool_stats = rmnet_get_ethtool_stats,
 	.get_strings = rmnet_get_strings,
 	.get_sset_count = rmnet_get_sset_count,
-- 
2.37.1

