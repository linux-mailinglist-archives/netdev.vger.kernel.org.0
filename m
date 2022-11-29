Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325CC63BD55
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiK2JxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiK2Jwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:52:51 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359BCDEBA;
        Tue, 29 Nov 2022 01:52:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so8544725pjm.2;
        Tue, 29 Nov 2022 01:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q+HcPAfOXUEhgB8t67wP/cjouMyhjRZQn2uzLIUxtrM=;
        b=J6WKtTXnQV8Zq71pPB0zFZTPxvL6UGEHTzjmMv3xN5MdjdEeV+BVL0xkN+cTUImBbc
         xEuh14jXCXMW/vxptpV8xn5uTAN24mkhL3e00X7OZOHFHOklnIlTi7FSH4CDbQKN562L
         L/HY799r3W7BrlGIF5dysbYYYQddrtfWUkjgt8hWScl7T9NbiiFMLeHNP/bSEcVYmMGv
         a2RxTPOr1PC859By7i+Xyb7gShL7lGKM5b4Ks7h6se7EK+MyqaazlL0Exy1klJkW7Nr5
         d7/qxZQ2XlvtIPaVH35oJfZmayG1gyKAAUV2ArzX8yLz8S4NbxX8ZUWhCivaDF0MpmSp
         +HjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q+HcPAfOXUEhgB8t67wP/cjouMyhjRZQn2uzLIUxtrM=;
        b=BuCLnsUT56Sku/8BB64FP32bSm0qM3r/6w1eqvJPhMc2jsrItW7yyIY6kPaCCes+zp
         gI6gB4bLnpvke6hp427Bi72Z94MbXi3KXbN9Kfg0YSGHR8WR73kIaGfBNQD0xkwudUDw
         1lVJROSMvJgSC9sPtdRqzuXccD23UWAAWsj2TOBu/W4+XktgyoIUpR5nDeQmO6WDq/1C
         28nolLlpvE4tva9eH72+gyI3IwfRjgVhleuNbEXmYmYJvP/7lPF/LOUtyGBRRosClR2W
         RaA6p9xnUX7GQ86tcL8NVnj88Wo1+JzIluzqtec46Lc6ZQ7z7RxjKJTmgWb4JQfISAIP
         dVLw==
X-Gm-Message-State: ANoB5pn0QYBO2OnE8O55v0x14L/kQyVQASh73lwWbt8irnYJy3sIr2bC
        0y8uVjjz+phNu8Wa+fmAXbw=
X-Google-Smtp-Source: AA0mqf4Lw/qQGGFmSQRFNytTLBUGv/AQ65WV04fGbUW4eia7yU4P2vgjBbDaOFgMNltEoNBsP5lZEg==
X-Received: by 2002:a17:903:2683:b0:186:6f1e:5087 with SMTP id jf3-20020a170903268300b001866f1e5087mr37426289plb.119.1669715564331;
        Tue, 29 Nov 2022 01:52:44 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id mv15-20020a17090b198f00b0021937b2118bsm941346pjb.54.2022.11.29.01.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 01:52:44 -0800 (PST)
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
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next v6 2/3] net: devlink: make the devlink_ops::info_get() callback optional
Date:   Tue, 29 Nov 2022 18:51:39 +0900
Message-Id: <20221129095140.3913303-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221129095140.3913303-1-mailhol.vincent@wanadoo.fr>
References: <20221129095140.3913303-1-mailhol.vincent@wanadoo.fr>
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

Some drivers only reported the driver name in their
devlink_ops::info_get() callback. Now that the core provides this
information, the callback became empty. For such drivers, just
removing the callback would prevent the core from executing
devlink_nl_info_fill() meaning that "devlink dev info" would not
return anything.

Make the callback function optional by executing
devlink_nl_info_fill() even if devlink_ops::info_get() is NULL.

N.B.: the drivers with devlink support which previously did not
implement devlink_ops::info_get() will now also be able to report
the driver name.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Jacob Keller  <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3babc16eeb6b..817d978bb729 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6773,9 +6773,11 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 		goto err_cancel_msg;
 
 	req.msg = msg;
-	err = devlink->ops->info_get(devlink, &req, extack);
-	if (err)
-		goto err_cancel_msg;
+	if (devlink->ops->info_get) {
+		err = devlink->ops->info_get(devlink, &req, extack);
+		if (err)
+			goto err_cancel_msg;
+	}
 
 	err = devlink_nl_driver_info_get(dev->driver, &req);
 	if (err)
@@ -6796,9 +6798,6 @@ static int devlink_nl_cmd_info_get_doit(struct sk_buff *skb,
 	struct sk_buff *msg;
 	int err;
 
-	if (!devlink->ops->info_get)
-		return -EOPNOTSUPP;
-
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
@@ -6824,7 +6823,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
-		if (idx < start || !devlink->ops->info_get)
+		if (idx < start)
 			goto inc;
 
 		devl_lock(devlink);
-- 
2.25.1

