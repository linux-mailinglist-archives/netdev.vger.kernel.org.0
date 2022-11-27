Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D548D6399A7
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 09:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiK0IQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 03:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiK0IQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 03:16:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7C910063;
        Sun, 27 Nov 2022 00:16:38 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id mv18so6905458pjb.0;
        Sun, 27 Nov 2022 00:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O3+WXaZIvwYScbYyJSTwVsoviigX0ePJBx5g3Z25JEw=;
        b=SzYATP/WvbrMPMeCmP13X7/vxMj9pdZXQOcaUDB61TKbTZD2j/3L/fcK89A5FdCNDB
         beyDVDaBw/Orpqr9oVtEOHrXHffe1lMYorIUUfNX5wisADjYBwBjvKLDRWltJ3iM7hGt
         j6Ur3plBe2qiKKzLGyyDNF+6c69LNJtw7woa6EkXwcKvuIrhq7Y4ppByK3LgaRHtOElv
         bhvswFat/v3oISyh03365opnwQRRkaFlOyEuoXaVpXik0GGSz4BDtvTVsiq4VpaIJhnp
         lwY7CoBZ/q3hW/AwPaE6a+gzbEea+cRSlAljPpT4rOCTjblu21Mg12GI2G+XlzIforVh
         Ya3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O3+WXaZIvwYScbYyJSTwVsoviigX0ePJBx5g3Z25JEw=;
        b=JaQRNdoRDHX9YVF/fr2WYwtOFYjttsd8viXfZu3lbI5V1FEE0gOfL/mTWgfm4Dy788
         GRwDsgJPkEbuN/H4/TZfSft+6OVmtt4NtgqwgeSvoMzCTPxmzXMo33bmmNiakHw48gGR
         v9VHyZeO4nVF1XoQ+w2V+x/svSjERK6XOtjfKwozTZEgOv59CcfpnZJMf4ZTCHD4Qsc2
         K2rWaDZAQDMJXFaLi0vfXyEjcQl+1Y/hbSuUon5PVCLXvnygfIz2KrviC5B4fhmNGyLG
         o9LRSm5H6jr9kvQ6ENR2V6vDhMwsPjvl0akn/avcKoF1TzNRYS4g41e37RFxhV4jm4Uh
         Vj0w==
X-Gm-Message-State: ANoB5pltArZasdi7IVBgooZOXU/oiRedPso7B0P8osUWhDQACAlXNcIf
        bBV6zsJSwPxXpCrompALhL8=
X-Google-Smtp-Source: AA0mqf72PtiKgQCQ5U/TWFIjiYeil/wnUg9CH++1HBOr4Nodobp5EzgkVDru4n4Du1IhGRoQuwhBwQ==
X-Received: by 2002:a17:902:a601:b0:189:8001:b54f with SMTP id u1-20020a170902a60100b001898001b54fmr3122555plq.37.1669536998039;
        Sun, 27 Nov 2022 00:16:38 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id a3-20020aa794a3000000b00572c12a1e91sm5799915pfl.48.2022.11.27.00.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 00:16:37 -0800 (PST)
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
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 1/5] mlxsw: minimal: fix mlxsw_m_module_get_drvinfo() to correctly report driver name
Date:   Sun, 27 Nov 2022 17:16:00 +0900
Message-Id: <20221127081604.5242-2-mailhol.vincent@wanadoo.fr>
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

Currently, mlxsw_m_module_get_drvinfo() reports the device_kind. The
device_kind is not necessarily the same as the device_name. For
example, the mlxsw_i2c implementation sets up the device_kind as
ic2_client::name in [1] which indicates the type of the device
(e.g. chip name), not the actual driver name.

Fix it so that it correctly reports the driver name.

[1] https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/i2c.c#L714

Fixes: 9bbd7efbc055 ("mlxsw: i2c: Extend initialization with querying firmware info")
CC: Shalom Toledo <shalomt@mellanox.com>
CC: Ido Schimmel <idosch@mellanox.com>
CC: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 6b56eadd736e..9b37ddbe0cba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -92,7 +92,7 @@ static void mlxsw_m_module_get_drvinfo(struct net_device *dev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
 	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
 
-	strscpy(drvinfo->driver, mlxsw_m->bus_info->device_kind,
+	strscpy(drvinfo->driver, dev_driver_string(dev->dev.parent),
 		sizeof(drvinfo->driver));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%d",
-- 
2.37.4

