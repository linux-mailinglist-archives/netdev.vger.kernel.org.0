Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC6363B655
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbiK2AHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbiK2AGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:06:31 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77633C6EE;
        Mon, 28 Nov 2022 16:06:30 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id q1so11423491pgl.11;
        Mon, 28 Nov 2022 16:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7vyAUtdppYTGbKLq7wMxR0RC/RBu3FQhQnkd54jGiIk=;
        b=ouaCMAvXZkQLxUzVzBDu3CxGFc+rE8uABpckNF7r3O4GgS4Kk9P+TrxtwvlDwTOOwQ
         uRDIqWUliCDxsq5vnkikZBI+VYuFasz5l41t6jAzIn8IqnMwRXsVziBEcdxDCtOX+z5P
         LdiunH5fa9iHrQduvpM1Ff2604a9p7/hvlHprs7waxl9TeqMJ/bg8AgmUoCwPJd22pgN
         8ifI2hpyxohfeCjauf85IlUkFj7YqWpop0Et0bsjCXRmKSHxB2xwxT3c9ZJTCs2t2vEW
         ajokkJL03s8DYT6VXUQ9vh6Ub5obfzykIuzJA+JF+CFcgjY/PgaEcoIQztVZ2ofADwoR
         +tzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7vyAUtdppYTGbKLq7wMxR0RC/RBu3FQhQnkd54jGiIk=;
        b=eVsolXXv56sEDq3aGLDUYz8Xk24W48VOXCxerzOQ5W1k0RQ3foZFL03ClhZHfALA5I
         WB8ett/WylXeNZAJczi5rEkqG20194PvsSkwo36Udqjmnc3BIkgB7vrV3ADksKUC0v8Z
         tdYcn5P43oZ6cRC3uxV78ZivkE+Xmkkt/SpyW4+vbiTdZRlEeZAxpamuedgmdn8vkdYA
         CJtOKpFdLGjnV7ZPeXfASq4my0FeA2Y52u746r94FDsoFV1UAc60OlfCkcQZiAoFoCHo
         cwJkB+bfnNRB4WtEZepPVyf1msYHxY525hkf1d0VicorwN3Ssfj8WAgWPk03N8WQJhPe
         64ww==
X-Gm-Message-State: ANoB5pkFeaDzwLN/DEgNx99ykGQWF6MeqSwnLul+sM6tP36+BDOCugJZ
        YXr3wjd+SpQ4hJuahd1y3Pg=
X-Google-Smtp-Source: AA0mqf7GtdgUmLhwKihDZO7Y/zF/uryy7Dh0AFbLvcd5MUPQdZCJgdMX18fbIZ+ovJnEvMeBUSmp1g==
X-Received: by 2002:aa7:8e54:0:b0:574:fddf:9946 with SMTP id d20-20020aa78e54000000b00574fddf9946mr11911901pfr.79.1669680390161;
        Mon, 28 Nov 2022 16:06:30 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id r2-20020aa79ec2000000b00572198393c2sm8588147pfq.194.2022.11.28.16.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 16:06:29 -0800 (PST)
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
Subject: [PATCH net-next v5 3/4] net: devlink: make the devlink_ops::info_get() callback optional
Date:   Tue, 29 Nov 2022 09:05:49 +0900
Message-Id: <20221129000550.3833570-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
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

