Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7800C6253ED
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbiKKGlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbiKKGlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:41:06 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BAEFCF6;
        Thu, 10 Nov 2022 22:41:02 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q1so3678734pgl.11;
        Thu, 10 Nov 2022 22:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FhPVH6iWdYluFW9jEDzBCZDn5Bjmm8bJ6D3+5j2G7JE=;
        b=UTQj+BG8tPE/xeLKC6xcjFodEKLAOSkD5fFTC864q6pPbyYh6Z0TTqXpy8Tz+CBaw3
         +3/cLE6mu8bDON2HLXQaKRDmHZSRudEXh8iL1zrif5MgjStvuWWyQnqeVpi5f/KR8w4L
         ETps+NTJFL12jAoqAJPDDIClTGSJei8KnA++7oknRhipe15rck8bIs0NjkgoBuzjYV50
         KOnyx+R6eLZeKmEHOAEreUrGNvZSEY73smaIXzxoZM7C0EbxwF4Ir5xZKx5jmlU6LpNu
         AdurRR51fU4Rk8EI2972Ug5SsfihQNVCkmXJaJREpUnVJwNrTdN4Tm3gaqYNcTc2dvCJ
         1UAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FhPVH6iWdYluFW9jEDzBCZDn5Bjmm8bJ6D3+5j2G7JE=;
        b=KJpp8CwbXpYfVtK6nqr6lIUVzFOdhjIMuM6mnJGB+N8dGOTZcxmLKWSA2NzSi9lMoL
         uPm1ewwHoh7Am7BuxbRBvfNuiGpGMd5pXEjYTyfYJxezJR/W8DO5awE3OClycspv/K5w
         IHHjQ7cEHWt8Yls4E8ZqKNaraQhgKltQJmEdonfVj3z8KrkW+76PAdx4cT2kLoFX5lpL
         z7gkKXTk/F6rtVURAvtV3+R1ZX2nmrQShzsZ090uSFF2IzY00RLPKl/Kv6qd3YzU24Kr
         XIu8oCgkTvHxJ6GRJEMEogWENrA9BADRu+MX4jOzLdgVS0vfJIjKjep+ZU4IVzvgtOgd
         IE6Q==
X-Gm-Message-State: ANoB5pmu4ND7jSxyR2gc8wqTRwrtUMbgKVr09BrutsD9M0x2DRI/3jfZ
        DSrllcFrRrsFSfQcHrGkX/E=
X-Google-Smtp-Source: AA0mqf6qKVJkzklcVt4pEnhdAZNmeawdzCyWfEcKFlXarNzcjBJjPvn6UvmzBHag6X86WnUmopMb4w==
X-Received: by 2002:a62:3287:0:b0:56c:3a0e:cf13 with SMTP id y129-20020a623287000000b0056c3a0ecf13mr1314666pfy.29.1668148861511;
        Thu, 10 Nov 2022 22:41:01 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id p13-20020a17090b010d00b002009db534d1sm858263pjz.24.2022.11.10.22.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 22:41:01 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
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
        linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH net-next v2] ethtool: doc: clarify what drivers can implement in their get_drvinfo()
Date:   Fri, 11 Nov 2022 15:40:54 +0900
Message-Id: <20221111064054.371965-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
References: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
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

In summary, drivers may provide @fw_version and @erom_version, the
rest is expected to be done by the core. Update the doc to reflect the
facts.

Also update the dummy driver and simply remove the callback in order
not to confuse the newcomers: most of the drivers will not need this
callback function any more.

[1] commit 6a7e25c7fb48 ("net/core: Replace driver version to be
    kernel version")
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6a7e25c7fb482dba3e80fec953f1907bcb24d52c

[2] commit edaf5df22cb8 ("ethtool: ethtool_get_drvinfo: populate
    drvinfo fields even if callback exits")
Link: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=edaf5df22cb8e7e849773ce69fcc9bc20ca92160

CC: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Arguably, dummy.c is code and not documentation, but for me, it makes
sense to treat it as documentation, thus I am putting everything in
one single patch.

* Changelog *

v1 -> v2:

  * Forgot the net-next prefix in the patch subject... Sorry for the
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

