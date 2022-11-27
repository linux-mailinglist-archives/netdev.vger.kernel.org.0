Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7D0639ADF
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 14:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiK0NLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 08:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiK0NKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 08:10:49 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD473DFA4;
        Sun, 27 Nov 2022 05:10:26 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so628609pje.5;
        Sun, 27 Nov 2022 05:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OxNviUPHTCGHIw1xqWHS/MPtnV3RpWOBq4yIBMcYMgw=;
        b=aOwF2DGKnJ17bhHDKmrmab4OFrvr6sHKBHX0zow1gGQgrlsbBTABqy+qAAjNeapBBi
         yb0oyPbubMaIJKDGCsx7HqtkWHSdH9ZBdsyB9PZGDUQdbkxyTKkNN+cWCM0v4WrWG1N9
         5GhzU7ErOeK7tsJPw/fx8AMbH6lRhB8iHDer2Ljp0aDgSvQo7qduzkO/0o5BfTfPylbF
         ycN4pZpl0KRyAD8zSld/LV5tUYiMIZCDjyYI1W0yhJyCQQsM4ZheZmsjywOWoFBQ1Xia
         b4mJhjqUjyH4mGJXzWd1IYcfxm5kp8fAjOn7762fKoQJEfY/vocYjmi118FGpgnnXlyd
         ge/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OxNviUPHTCGHIw1xqWHS/MPtnV3RpWOBq4yIBMcYMgw=;
        b=fn0xfGwBPhuWY9od2QZ8+mYXHxLP7Bfy7hbBBjRfVToKT1qD3bU/w1xcl0tKw/bhzu
         Til6X1pHaDfIIXmTLGsZ7AOGWko+Dv75+9DapiOtAPt6jonlh63WyKElUazDFKmw8N8K
         r1udfjZ4wWXBJb3U9tSy0pnbuTXZNVGPs38ecAC6m3qcjoPCDqgMTjrCadWFehY09P6K
         YMyozefl1a8ZS3F7LLzPPfXfAsHXaovwnm6/0kBNYLbr1MpbjZkyUY5Y11ytSrDKSRSU
         olkE0Jiuj2ozfaIxfWYpJU1y+KShc6jUqIrLy5sVshPDZnPk6g2gbQ5Z96//b5MZIacb
         rfNA==
X-Gm-Message-State: ANoB5pkTKAp9FIl8VLK0VqmdH7PxxRQPXgLFtUTAm7dNuG/ll6e7EmN7
        ZE/D9NzLAgGNQDwYMGer2Ho=
X-Google-Smtp-Source: AA0mqf4kR8A7riSdhezb8YYOVkRVEthmKJ6bKxK4dqCAk0UCWiR/wf0G3/1Me0wOdistxQAfpt17yw==
X-Received: by 2002:a17:902:82c3:b0:189:82da:7b63 with SMTP id u3-20020a17090282c300b0018982da7b63mr2667941plz.68.1669554626030;
        Sun, 27 Nov 2022 05:10:26 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q17-20020a170902eb9100b00188a908cbddsm6710225plg.302.2022.11.27.05.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 05:10:25 -0800 (PST)
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
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH net-next v3 4/5] net: devlink: remove devlink_info_driver_name_put()
Date:   Sun, 27 Nov 2022 22:09:18 +0900
Message-Id: <20221127130919.638324-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221127130919.638324-1-mailhol.vincent@wanadoo.fr>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <20221127130919.638324-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

