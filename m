Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1ADA63A069
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 05:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiK1EQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 23:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiK1EQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 23:16:04 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4261A185;
        Sun, 27 Nov 2022 20:16:01 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id w23so8987337ply.12;
        Sun, 27 Nov 2022 20:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fftJz4AB+rFDwIMwIlKqAAN7H0L4lfd82kzQzOVU4Gg=;
        b=OiUcbYE7eSGDuCBF/80zSFenq+kBVmjsl2Yg5JZ+Pp6tiF5N78hJXPnTNs7AVh9j5N
         gjqHsL9ezu7FdIbVhHPZ56PW7Tp31ho8YcU0DNkqFTQYxVM8uqQJ4SzrvvBzeHiXFHQm
         Ud70Zes85hJ+borYwZnXzyrlYz4UCHpteTkwNkkBeYWkSN0X2vRr/oX/xRtAVvdFWIoK
         D/8tBS418Nvkioi3IZhz46WRQiwBPSShJgeaWV6qpGB7Ti7LC9yDBbCqF+/vS12Lyn4+
         8izeF6ysCcgaK2uCRieclRJvKLx3lYRR3hCSN1VrIsBqe6C6+jIQKlssVVHNfSsG2/T8
         LMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fftJz4AB+rFDwIMwIlKqAAN7H0L4lfd82kzQzOVU4Gg=;
        b=hoD4r1IDIGXNpIpRUxidrq0Jaw05g5zl8dkhEFzNxaqP8xdW2nPi598meZB8UwJiuA
         hjnfqQAHtGjeCEu5fJQimJbxsscB2NGnNVRONSk/V05w7oObJVPSWDjqBBgoW/LFHQm6
         zz+dgmstBdA4YJ4OpjK9iqnaGdZg/7ecGhovci+k1YStgbEZiA7K0oqk+INDirthcpSX
         7zFeoiOvL2QMfmKaeCwHZ/YhtTDXXrzFLmpS129lBCaquWzUM92Ljk1i7R3ZanYVCXK1
         VgltsCLtMresOHXPi+kysRgkqRPqwWzvWOzCh2vc+8znXKyUf+CiG+c+HvaRqsyuqT+F
         T0VQ==
X-Gm-Message-State: ANoB5pnYpOnPfcjNviO9DUZ6lhgrIlvqt2lukyTkHREvnah2wxz6WNrn
        xi9B2YLobenwJ2xO4ag3Jfo=
X-Google-Smtp-Source: AA0mqf4ciOZDTvidLPv1soaNH75grQPJ6cjfMpmq5sf8Q0v0sGYGoZlfFiaAPKvlgjSYeKj7BHNUpw==
X-Received: by 2002:a17:902:bb84:b0:184:e4db:e3e with SMTP id m4-20020a170902bb8400b00184e4db0e3emr33849618pls.47.1669608961120;
        Sun, 27 Nov 2022 20:16:01 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id z5-20020aa79f85000000b0056bbebbcafbsm6927107pfr.100.2022.11.27.20.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 20:16:00 -0800 (PST)
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
Subject: [PATCH net-next v4 0/3] net: devlink: return the driver name in devlink_nl_info_fill
Date:   Mon, 28 Nov 2022 13:15:42 +0900
Message-Id: <20221128041545.3170897-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
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
have to be done in an atomic change to avoid attribute duplication.

The second patch removes the devlink_info_driver_name_put() function
to prevent future drivers from reporting the driver name themselves.

Finally, the third and last patch allows the core to call
devlink_nl_info_fill() even if the devlink_ops::info_get() callback is
NULL. This allows to do further more clean up in the drivers.
---
* Changelog *

v3 -> v4

  * Ido pointed out that the mlxsw did not need to be fixed:
    https://lore.kernel.org/netdev/Y4ONgD4dAj8yU2%2F+@shredder/
    Remove the first two patches from the series.

v2 -> v3

  * [PATCH 3/5] remove the call to devlink_info_driver_name_put() in
    mlxsw driver as well (this was missing in v2, making the build
    fail... sorry for the noise).

  * add additional people in CC as pointed by netdev patchwork CI:
    https://patchwork.kernel.org/project/netdevbpf/list/?series=699451

  * use the "Link:" prefix before URL to silence checkpatch's line
    length warning.


RFC v1 -> v2

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

