Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABC1642B98
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiLEP0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbiLEPZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:25:52 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9ED1F2FF
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:23:00 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id td2so28598999ejc.5
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 07:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=20NnQXfQ6xH/6rPBdmFO/uzZlwozCEZtbv9LHnEth3s=;
        b=sXP0M6IxT4yUO/RdRAgcvUoiAeRMIl2b4b/GUE7zGSB5g+hKqXURVUjOpmIAC6MJ2k
         0ni+uB2jkGeCIzaNHS05eywTWV7xOqRz2j2jE2aMzHGwE+76iAwRckuObPJhi9S7jNSx
         OcwkRExtKYippXSK9Gc/tV7UfA4xTwh2l9Hj0QFfToqzi4cE7GHOObRp5KOG0AWQTrla
         khDrCmVXvN/+njSC2nJMwFzfHgTpvcBCyNnG2nwI1uyqjIeuP7G0wClvQgoRVB+hT1Dt
         Gg/e3XQRqU2CDw4N1AsU1HhHhw/TMa2S0aWf7Y8znqchbhbgYU4x51vb2DAEHgwLrMTY
         RHvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=20NnQXfQ6xH/6rPBdmFO/uzZlwozCEZtbv9LHnEth3s=;
        b=OIAjI+4aruzwEa2A+UMteqgMvh/iGzxa/P58HZAOJ4Dj/AVX/AeRUIIWCCQjAzXM1/
         r4NRMIHxqdPF9jf/ym3ftYDxjR+wESZiIwtcjLyxh2V+98irxVPXaXYsR5Fi/sDH4Fv2
         1o2Q1/VHbwvTfqDtBmYLMDrc0SBdEFA+9ZPvoVUbpWmDJqvprOi3GiYgG8G5qmI4mwK4
         eJfKzaR0xERPv0p68PerQH8M9UciJuDEGbnenoXHdYItUwc/95CdF/4S8dknD+1ymwoy
         JYnyFJ75sF039O4Musva20kJyytCn3jMY/YbGRJA75dsAI1Ok8zr8Moqjjaf09Nl4ovI
         oCTQ==
X-Gm-Message-State: ANoB5pluZhfuxuf1kjit8dDIsJ1PErLrCJ4syKc+b9tVgAfXe3awEk87
        u3q7L9dH4148/Kkp/OfazyN48s69jqBsJ39t43eS0g==
X-Google-Smtp-Source: AA0mqf7MCMSdrcLpdhLxl6jlMBePQVdtTBy3p8JJhk0utkJhxf1qXT6+bV7hEiuH4R3WQ3NYKkw14Q==
X-Received: by 2002:a17:906:bcda:b0:7c0:80b0:7f67 with SMTP id lw26-20020a170906bcda00b007c080b07f67mr27641806ejb.462.1670253779335;
        Mon, 05 Dec 2022 07:22:59 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u2-20020a1709061da200b007b8a8fc6674sm6326201ejh.12.2022.12.05.07.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:22:58 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: [patch net-next 0/8] devlink: make sure devlink port registers/unregisters only for registered instance
Date:   Mon,  5 Dec 2022 16:22:49 +0100
Message-Id: <20221205152257.454610-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Currently, the devlink_register() is called as the last thing during
driver init phase. For devlink objects, this is fine as the
notifications of objects creations are withheld to be send only after
devlink instance is registered. Until devlink is registered it is not
visible to userspace.

But if a  netdev is registered before, user gets a notification with
a link to devlink, which is not visible to the user yet.
This is the event order user sees:
 * new netdev event over RT netlink
 * new devlink event over devlink netlink
 * new devlink_port event over devlink netlink

Also, this is not consistent with devlink port split or devlink reload
flows, where user gets notifications in following order:
 * new devlink event over devlink netlink
and then during port split or reload operation:
 * new devlink_port event over devlink netlink
 * new netdev event over RT netlink

In this case, devlink port and related netdev are registered on already
registered devlink instance.

Purpose of this patchset is to fix the drivers init flow so devlink port
gets registered only after devlink instance is registered.

Jiri Pirko (8):
  devlink: call devlink_port_register/unregister() on registered
    instance
  netdevsim: call devl_port_register/unregister() on registered instance
  mlxsw: call devl_port_register/unregister() on registered instance
  nfp: call devl_port_register/unregister() on registered instance
  mlx4: call devl_port_register/unregister() on registered instance
  mlx5: call devl_port_register/unregister() on registered instance
  devlink: assert if devl_port_register/unregister() is called on
    unregistered devlink instance
  devlink: remove port notifications from devlink_register/unregister()

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 29 +++++----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  7 ++-
 .../ethernet/fungible/funeth/funeth_main.c    | 17 ++++--
 drivers/net/ethernet/intel/ice/ice_main.c     | 21 ++++---
 .../ethernet/marvell/prestera/prestera_main.c |  6 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     | 60 ++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 10 +++-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 17 +++---
 .../mellanox/mlx5/core/sf/dev/driver.c        |  9 +++
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 24 ++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 38 +++++++++---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 10 ++--
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 22 +++++--
 .../ethernet/pensando/ionic/ionic_devlink.c   |  6 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  7 ++-
 drivers/net/netdevsim/dev.c                   | 31 ++++++++--
 net/core/devlink.c                            |  7 +--
 18 files changed, 218 insertions(+), 105 deletions(-)

-- 
2.37.3

