Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A229E63BD4C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiK2Jw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiK2Jw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:52:27 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C333E096;
        Tue, 29 Nov 2022 01:52:25 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id ns17so5334093pjb.1;
        Tue, 29 Nov 2022 01:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=DoHQzm8iYHF80spHwuizizw7dl9whlXqQdx1rDh9IHE=;
        b=bejrZVaKDSalOuYZ2B4bydrehFoiPv/luw7eftEZ+420oFiz0yNbZcsJH8YBOGTZXg
         ilG/oS/g5sxPYVPM66IwLJCszDO5hSQ2qmfZ2Y9C4JMNz1lesIZmB+AqeBRAOjz2qVR8
         GALd0VrCWA3+gVysZ39W69HIeyJn/a0BB7c+L5aKweukPU4JFJtJ2mPw3l+g37QAXQ2n
         gVbMCJUdxXADPF+br8E1KmW/piaBj36Foy3ymKF5n8lpic5jofeUkMRPy8D+RYzyPxrX
         4rtvUENtwE49BpPwayakeJbKCxXYuifofz0eCmo4EIAOm0UgbmPTJayYwmslpQdoUugN
         QOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DoHQzm8iYHF80spHwuizizw7dl9whlXqQdx1rDh9IHE=;
        b=LMI3A+zm28ZrhOcZmmzkfffjmolK9l3OEIqcQWxAa9aevhY/aJ+5f3T/lpKvVyj5Ob
         25IJqlGinBpGkMcTpUGS3wwChzkVlEdkBvpjeRZWkrJYVylkefTbKrZo20DeePqRCWgG
         gJMlfTlbWBImRVHEtSMtw6LWs7tnJjoevkkmSfESfiexAPf6NN1pquVSSU+8LxiPefq0
         CgH/gy22+EeRkUtKOqWOtVm7KwM3/aruD8UlAoh36sRfWHo9o6qwTQGJYyzg1LsQOV1t
         T6jOUzJoSKEJx2uyZHn3RLX/yMw39khcIFpGN4KaY+tIW3Vy8CA4I2qW1JRAoNPYOXRr
         SCBg==
X-Gm-Message-State: ANoB5pm4WdfHDCn5aK09JnwUc5rt1Q9aOS4yjWlgzVGp2/WStad/ISpf
        HVh/LeZyJg0W2wY3ViGgmyQ=
X-Google-Smtp-Source: AA0mqf63NvlKwgOFBgeDyFi/Klb4ymtSS/HrjV70mCgba2uIa+LJ+++Eg3CUtocEiNZqs+qoOIBw2w==
X-Received: by 2002:a17:90b:3944:b0:214:1df0:fe53 with SMTP id oe4-20020a17090b394400b002141df0fe53mr63738466pjb.214.1669715545345;
        Tue, 29 Nov 2022 01:52:25 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id mv15-20020a17090b198f00b0021937b2118bsm941346pjb.54.2022.11.29.01.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 01:52:25 -0800 (PST)
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
Subject: [PATCH net-next v6 0/3] net: devlink: return the driver name in devlink_nl_info_fill
Date:   Tue, 29 Nov 2022 18:51:37 +0900
Message-Id: <20221129095140.3913303-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
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

The driver name is available in device_driver::name. Right now,
drivers still have to report this piece of information themselves in
their devlink_ops::info_get callback function.

The goal of this series is to have the devlink core to report this
information instead of the drivers.

The first patch fulfills the actual goal of this series: modify
devlink core to report the driver name and clean-up all drivers. Both
have to be done in an atomic change to avoid attribute
duplication. This same patch also removes the
devlink_info_driver_name_put() function to prevent future drivers from
reporting the driver name themselves.

The second patch allows the core to call devlink_nl_info_fill() even
if the devlink_ops::info_get() callback is NULL. This leads to the
third and final patch which cleans up the drivers which have an empty
info_get().
---
* Changelog *

v5 -> v6:

  * No change in code.

  * add Reviewed-by: Jacob Keller tag.

  * add Reviewed-by: Jiri Pirko tag.

  * squash patches 1 and 2 together.

  * [PATCH 1/3]: remove the paragraph explaining why attributes get
    duplicated if nla_put() is called twice.

v4 -> v5:

  * No change in code.

  * [PATCH 1/4] add Tested-by: Ido Schimmel tag.

  * split patch 3/3 in two patches.

v3 -> v4:

  * Ido pointed out that the mlxsw did not need to be fixed:
    https://lore.kernel.org/netdev/Y4ONgD4dAj8yU2%2F+@shredder/
    Remove the first two patches from the series.

v2 -> v3:

  * [PATCH 3/5] remove the call to devlink_info_driver_name_put() in
    mlxsw driver as well (this was missing in v2, making the build
    fail... sorry for the noise).

  * add additional people in CC as pointed by netdev patchwork CI:
    https://patchwork.kernel.org/project/netdevbpf/list/?series=699451

  * use the "Link:" prefix before URL to silence checkpatch's line
    length warning.


RFC v1 -> v2:

  * drop the RFC tag

  * big rework following the discussion on RFC:
    https://lore.kernel.org/netdev/20221122154934.13937-1-mailhol.vincent@wanadoo.fr/
    Went from one patch to a series of five patches:

  * drop the idea to report the USB serial number following Greg's
    comment:
    https://lore.kernel.org/linux-usb/Y3+VfNdt%2FK7UtRcw@kroah.com/

Vincent Mailhol (3):
  net: devlink: let the core report the driver name instead of the
    drivers
  net: devlink: make the devlink_ops::info_get() callback optional
  net: devlink: clean-up empty devlink_ops::info_get()

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
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  5 ---
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  4 ---
 .../ethernet/pensando/ionic/ionic_devlink.c   |  4 ---
 drivers/net/ethernet/qlogic/qed/qed_devlink.c |  4 ---
 drivers/net/netdevsim/dev.c                   |  3 --
 drivers/ptp/ptp_ocp.c                         |  4 ---
 include/net/devlink.h                         |  2 --
 net/core/devlink.c                            | 35 ++++++++++++-------
 22 files changed, 26 insertions(+), 130 deletions(-)

-- 
2.25.1

