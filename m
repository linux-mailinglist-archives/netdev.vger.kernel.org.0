Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E816399A3
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 09:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiK0IQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 03:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiK0IQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 03:16:31 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417A2F598;
        Sun, 27 Nov 2022 00:16:30 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id w23so7485702ply.12;
        Sun, 27 Nov 2022 00:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtFXWEJ1f4pp6qiyXKj5arMcKw9TkHekZMlzR/UCnY4=;
        b=A85/oNogWnVHeGFDcwnBsCBzVg6EgoXg2fl7K2Y4LWxkT5hu0+sQAS9UC6D2YFRGj/
         B8NK1gr/KBZeTPQNSoKFdeCRAiru+jO71sox5JO7qXStGpCaesPOHHDgqlFrfUNOZSFE
         jcWWXJm4LHm8lxGdWyWDLFzFmmrbaercTYyaThYaYhJ/XZ4R/IMASvEKymKu3RcKhHRl
         uV8+ApBTEmWL3wypN7BpatPMiJ7MoE4QC/faAXPleW0bwkdTfDzeWDlAQgf2XglOw1PM
         h5/kqnhknOYQ6qYtVbfsKvzkqNNI3v9tkIg+bndLjOysIXsLnl0YiSs6GkQoctSZrcPc
         u/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jtFXWEJ1f4pp6qiyXKj5arMcKw9TkHekZMlzR/UCnY4=;
        b=Xv4FnG/8MKnxlT+8tfWjMrZvNXlu+443rMMdjbbjZ6MeG4SiBXyIOpw4VlxoYoY1Ch
         crf+5eBA6lPW/OVCuNmCrH1niFPrPa6iq8BuyhDrp5y9+OPt680VGuvRMV8N3PyUbhLO
         dR//nBV9gHxVEK19/EETPhVmOiS0gJD7sKrElsSLmnXB/1f49JdtA/wulgw08f1+uKZ8
         fAHMDt3AmDDJx1nm7xCWcN1MotjY6eYzSDYRR7acjlvt0hDBSC1zl8BU/6YM1ZZWReVL
         YtOdpaCRUx03N5yMYtrQ1K5Ui+wN60FtIEE2kyUCvAf4pSeSZNkjvNUD7b6t8pFugKMe
         bZtw==
X-Gm-Message-State: ANoB5pkV+TQWlFeCdHhnIMe3RjKHoeQikssXUXjQl3n1inY/PzZyN+iE
        +IXaUK0akzd4l0pDA3r/Bwc=
X-Google-Smtp-Source: AA0mqf7E33SagQ9eCqtOUMPlG3tjkVYgrg25yhdp/y54PDogJWizI4UPgacnqj4NzSjZynYVWcB90Q==
X-Received: by 2002:a17:90a:9313:b0:213:2168:1c78 with SMTP id p19-20020a17090a931300b0021321681c78mr49467293pjo.72.1669536989682;
        Sun, 27 Nov 2022 00:16:29 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id a3-20020aa794a3000000b00572c12a1e91sm5799915pfl.48.2022.11.27.00.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 00:16:29 -0800 (PST)
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
Subject: [PATCH net-next v2 0/5] net: devlink: return the driver name in devlink_nl_info_fill
Date:   Sun, 27 Nov 2022 17:15:59 +0900
Message-Id: <20221127081604.5242-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
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

The driver name is available in device_driver::name. Right now,
drivers still have to report this piece of information themselves in
their devlink_ops::info_get callback function.

The goal of this series is to have the devlink core to report this
information instead of the drivers.

The first two patches clean up the mlxsw driver for both the ethtool
and the devlink (both are supposed to return the same information so
the ethtool got included as well). This is split in two patches
because of the different Fixes tag.

The third patch fulfills the actual goal of this series: modify
devlink core to report the driver name and clean-up all drivers. Both
as to be done in an atomic change to avoid attribute duplication.

The fourth patch removes the devlink_info_driver_name_put() function
to prevent future drivers from reporting the driver name themselves.

Finally, the fifth and last patch allows the core to call
devlink_nl_info_fill() even if the devlink_ops::info_get() callback is
NULL. This allows to do further more clean up in the drivers.
---
* Changelog *

RFC v1 -> v2

  * drop the RFC tag

  * big rework following the discussion on RFC:
    https://lore.kernel.org/netdev/20221122154934.13937-1-mailhol.vincent@wanadoo.fr/
    Went from one patch to a series of five patches:

  * drop the idea to report the USB serial number following Greg's
    comment:
    https://lore.kernel.org/linux-usb/Y3+VfNdt%2FK7UtRcw@kroah.com/

Vincent Mailhol (5):
  mlxsw: minimal: fix mlxsw_m_module_get_drvinfo() to correctly report
    driver name
  mlxsw: core: fix mlxsw_devlink_info_get() to correctly report driver
    name
  net: devlink: let the core report the driver name instead of the
    drivers
  net: devlink: remove devlink_info_driver_name_put()
  net: devlink: make the devlink_ops::info_get() callback optional

 .../marvell/octeontx2/otx2_cpt_devlink.c      |  4 ---
 drivers/net/dsa/hirschmann/hellcreek.c        |  5 ---
 drivers/net/dsa/mv88e6xxx/devlink.c           |  5 ---
 drivers/net/dsa/sja1105/sja1105_devlink.c     | 12 ++-----
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  4 ---
 .../freescale/dpaa2/dpaa2-eth-devlink.c       | 11 +-----
 .../ethernet/fungible/funeth/funeth_devlink.c |  7 ----
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  5 ---
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  5 ---
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  6 ----
 .../marvell/octeontx2/af/rvu_devlink.c        |  7 ----
 .../marvell/octeontx2/nic/otx2_devlink.c      | 15 --------
 .../marvell/prestera/prestera_devlink.c       |  5 ---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  4 ---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  3 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  2 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  4 ---
 .../ethernet/pensando/ionic/ionic_devlink.c   |  4 ---
 drivers/net/ethernet/qlogic/qed/qed_devlink.c |  4 ---
 drivers/net/netdevsim/dev.c                   |  3 --
 drivers/ptp/ptp_ocp.c                         |  4 ---
 include/net/devlink.h                         |  2 --
 net/core/devlink.c                            | 35 ++++++++++++-------
 23 files changed, 29 insertions(+), 127 deletions(-)

-- 
2.37.4

