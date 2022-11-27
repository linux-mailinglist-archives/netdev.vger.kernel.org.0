Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BA46399B4
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 09:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiK0ISU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 03:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiK0IRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 03:17:20 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C2513E9A;
        Sun, 27 Nov 2022 00:17:03 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b11so6883632pjp.2;
        Sun, 27 Nov 2022 00:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OxNviUPHTCGHIw1xqWHS/MPtnV3RpWOBq4yIBMcYMgw=;
        b=eetLQF5UODffxdiWFfOUJ5V4jEbJDflupjuyH8LBZdfHVWyl8GtBDfs47imz2/w1Ac
         r66dRHi/VUwY0i1SSYFvVAOgkRQWkWFrNFs2GxutGJ4PtJBCtwSzc91hJaZakzsuSSXr
         kluV/KoBcwQfC+aRTmuQmb0amOmSVvdgKRFspB8LWrihiPvpBBYY8Pebno7RcDphFLwU
         DDONZA1BKxs2jKU5hBMPWHp+Iw19R1aAX416kSVs4ab4Dl/Au17ETkW8cs+CCpJXUmqC
         K11/HcAEWmPB3v8c6Vrh+wtz00n+vr6dIPpL1uniILBFZI0Eus1lKC+4pUdbKNlKDY9S
         s0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OxNviUPHTCGHIw1xqWHS/MPtnV3RpWOBq4yIBMcYMgw=;
        b=TcVb4hWEeGNv7p7fHB6rYyX2sxoFj7rFjRgR0kiMl4y9o5RP/Te/gRCyElgBy6YPV8
         BC++3+vbHlX3EJRESdYsyYeobHBuOpL9ZJxxjCeG43RV5Ds/5zWlRIDOyywGQ7yK6lZk
         YfXkvIBkRzc+TDE/wPJoUl4RqgS7n2cwUcUSUFZ7nIT7ImZ+5I/cHCPbta2NNIbVfrWQ
         qVehHumaq6Zz6buST+YGdtfXLs+5cAr8dUy5Z+ZHKhbytGu4RTTw59tEasTUYSEoOWdR
         /m1fdPrPQisCQiYKSw1EEH4KQE+1lQjRfddOIBN4LB7jU74C4BVrDAY3RO2RNtbHVAdC
         fErQ==
X-Gm-Message-State: ANoB5pm4nBb/o3jXZ7syZBaaiEj5/x93TNx4/gBrj1tOEQN+ABdXzJlx
        2Heg4JQqRV+HypTex58HRNs=
X-Google-Smtp-Source: AA0mqf7yW/3Xp1KFVxoejY9De59xKNtiUSTMbmzKHSVE+Yrxp8I+Rv0xefV1OzueQtEdMCfe8elgLQ==
X-Received: by 2002:a17:902:f80b:b0:188:4e75:7365 with SMTP id ix11-20020a170902f80b00b001884e757365mr28594068plb.102.1669537023058;
        Sun, 27 Nov 2022 00:17:03 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id a3-20020aa794a3000000b00572c12a1e91sm5799915pfl.48.2022.11.27.00.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 00:17:02 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH net-next v2 4/5] net: devlink: remove devlink_info_driver_name_put()
Date:   Sun, 27 Nov 2022 17:16:03 +0900
Message-Id: <20221127081604.5242-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221127081604.5242-1-mailhol.vincent@wanadoo.fr>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <20221127081604.5242-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the core sets the driver name attribute, drivers are not
supposed to call devlink_info_driver_name_put() anymore. Remove it.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/net/devlink.h |  2 --
 net/core/devlink.c    | 11 ++---------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 074a79b8933f..52d5fb67e9b8 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1746,8 +1746,6 @@ int devlink_region_snapshot_create(struct devlink_region *region,
 				   u8 *data, u32 snapshot_id);
 int devlink_info_serial_number_put(struct devlink_info_req *req,
 				   const char *sn);
-int devlink_info_driver_name_put(struct devlink_info_req *req,
-				 const char *name);
 int devlink_info_board_serial_number_put(struct devlink_info_req *req,
 					 const char *bsn);
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6478135d9ba1..3babc16eeb6b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6633,14 +6633,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
-int devlink_info_driver_name_put(struct devlink_info_req *req, const char *name)
-{
-	if (!req->msg)
-		return 0;
-	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_DRIVER_NAME, name);
-}
-EXPORT_SYMBOL_GPL(devlink_info_driver_name_put);
-
 int devlink_info_serial_number_put(struct devlink_info_req *req, const char *sn)
 {
 	if (!req->msg)
@@ -6756,7 +6748,8 @@ static int devlink_nl_driver_info_get(struct device_driver *drv,
 		return 0;
 
 	if (drv->name[0])
-		return devlink_info_driver_name_put(req, drv->name);
+		return nla_put_string(req->msg, DEVLINK_ATTR_INFO_DRIVER_NAME,
+				      drv->name);
 
 	return 0;
 }
-- 
2.37.4

