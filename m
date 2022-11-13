Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346DA626E85
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 09:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbiKMIeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 03:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiKMIeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 03:34:19 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96772E0EC;
        Sun, 13 Nov 2022 00:34:18 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso11233807pjg.5;
        Sun, 13 Nov 2022 00:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:sender:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Rh1rcfsF2jelBwTxQVNXFFfPTHy9LFON9Yin67rbwwM=;
        b=bGoFUf6AIiMKEx+ETMtwz9F237JjvBCmBsp6iZBsU6VMaocGgUdpJvVQzOc31QsdxM
         b+wSWpFoQUtPRsuZHtf1G59/D5ue81BMCaGpjMIJEvDGWVIfRNbb2x8Oc2mCdpzMBLMT
         VlBEHnkqnDCDKIomrI0sAEhgNng2fZxndtXCcdBySITB46VEnY7ZwCWUFmub0NA4npn5
         yK5lsMBDjTwN2TML+YOH/+Yo35x2AwvnZxftB1ePxpk+KAOS6Gv3kF5jLVCeHAkBmPHb
         c/Gr1pyJLDuSNtG8iBwnMsvzPjiOaNRcZaLFqg/Gsi+H/FwPUtLobt5HVofDxQlM3P8w
         4oIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:sender:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rh1rcfsF2jelBwTxQVNXFFfPTHy9LFON9Yin67rbwwM=;
        b=RnqdJAGv9l+oQpjoL47AhQyMO/sHsOw9/cnHOkMNHBXvx1lE6/ziGhgC0sxWFjRP+a
         YAWSISdjas4WsBbJYq45cJHdpHX7L/1UF5s7/Q1mOWgLQku8M3Frxf0LcFc4p+WbbcFD
         bnJ+5D4luKlj3OizXko9LRHDcFrgckomcPh04ScXhrI+r/q8JjdDk7F8Kwox0Y9G90j/
         1zNkytjzS+yCgsZKrzkXlywxU0PNyBmafwLI3PcIecbcjgNlf2MQ5YFPcMnJJq46huWe
         vygEalRYsJa7qE4Ff2WrBXUu6wXvHUvKiM6JIW2JmOHbYQYID7J5SCsSvsQCTV9UmCd3
         7SuQ==
X-Gm-Message-State: ANoB5pklAIBOkQ3rINyoR2YHmpRvU68i/Xd7onMH4M4a4zXek8YPTaqB
        SiXWXn7aKJNb3wwAl8cf98w=
X-Google-Smtp-Source: AA0mqf7cqKRdh1qWoQfSFblruo+aoQoKAXq5AXIVXokFSJWm5JAgLhDz1QbMvmF0h8+0MhccP/aIMg==
X-Received: by 2002:a17:90a:ad49:b0:213:3521:f83a with SMTP id w9-20020a17090aad4900b002133521f83amr9035387pjv.84.1668328458038;
        Sun, 13 Nov 2022 00:34:18 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id lt15-20020a17090b354f00b002130c269b6fsm4284366pjb.1.2022.11.13.00.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 00:34:17 -0800 (PST)
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Petr Machata <petrm@nvidia.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@mellanox.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v3] ethtool: doc: clarify what drivers can implement in their get_drvinfo()
Date:   Sun, 13 Nov 2022 17:34:04 +0900
Message-Id: <20221113083404.86983-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
References: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many of the drivers which implement ethtool_ops::get_drvinfo() will
prints the .driver, .version or .bus_info of struct ethtool_drvinfo.
To have a glance of current state, do:

  $ git grep -W "get_drvinfo(struct"

Printing in those three fields is useless because:

  - since [1], the driver version should be the kernel version (at
    least for upstream drivers). Arguably, out of tree drivers might
    still want to set a custom version, but out of tree is not our
    focus.

  - since [2], the core is able to provide default values for .driver
    and .bus_info.

In summary, drivers may provide .fw_version and .erom_version, the
rest is expected to be done by the core. Update the doc to reflect the
facts.

Also update the dummy driver and simply remove the callback in order
not to confuse the newcomers: most of the drivers will not need this
callback function any more.

[1] commit 6a7e25c7fb48 ("net/core: Replace driver version to be
    kernel version")
Link: https://git.kernel.org/torvalds/linux/c/6a7e25c7fb48

[2] commit edaf5df22cb8 ("ethtool: ethtool_get_drvinfo: populate
    drvinfo fields even if callback exits")
Link: https://git.kernel.org/netdev/net-next/c/edaf5df22cb8

Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Arguably, dummy.c is code and not documentation, but for me, it makes
sense to treat it as documentation, thus I am putting everything in
one single patch.

* Changelog *

v2 -> v3:

  * add Reviewed-by: Leon Romanovsky <leonro@nvidia.com> tag.
  * use shorter links.

v1 -> v2:

  * forgot the net-next prefix in the patch subject... Sorry for the
    noise.
---
 drivers/net/dummy.c          | 7 -------
 include/uapi/linux/ethtool.h | 6 +++---
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index aa0fc00faecb..c4b1b0aa438a 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -99,14 +99,7 @@ static const struct net_device_ops dummy_netdev_ops = {
 	.ndo_change_carrier	= dummy_change_carrier,
 };
 
-static void dummy_get_drvinfo(struct net_device *dev,
-			      struct ethtool_drvinfo *info)
-{
-	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
-}
-
 static const struct ethtool_ops dummy_ethtool_ops = {
-	.get_drvinfo            = dummy_get_drvinfo,
 	.get_ts_info		= ethtool_op_get_ts_info,
 };
 
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f341de2ae612..fcee5dbf6c06 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -180,9 +180,9 @@ static inline __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
  * Users can use the %ETHTOOL_GSSET_INFO command to get the number of
  * strings in any string set (from Linux 2.6.34).
  *
- * Drivers should set at most @driver, @version, @fw_version and
- * @bus_info in their get_drvinfo() implementation.  The ethtool
- * core fills in the other fields using other driver operations.
+ * Drivers should set at most @fw_version and @erom_version in their
+ * get_drvinfo() implementation. The ethtool core fills in the other
+ * fields using other driver operations.
  */
 struct ethtool_drvinfo {
 	__u32	cmd;
-- 
2.35.1


