Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545AB5983A7
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244193AbiHRNAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244856AbiHRNAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:00:47 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01ED9647D8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:00:45 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id c39so1821816edf.0
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=p81NHj5bjQp+JZ6X8YX7pMc38lX8Av8vguDYWp+Zb4A=;
        b=rUmPeBr0DZb6plXcsU3Ztbr6nTDZAwYCLW5wKVm1aTS51J2+Tu+D/zk053dHubxf6I
         yLm/4LYOX3ug6Uc7AuzKXdTzccNWbZLuvKVjipf8shzcW/IsiWeg3EZ5xI/EnPuzckHa
         J9Q0UDb0lv0qyK1dxEaqYdzEvzkIoD1SEP6M7it3b8jGoF2KfQsnnNQqdHMoA53bGl6B
         C0sRpCrInfTd2w6ICzdhMBrTJ+HwVQQvplh1JUSau4DkTyYpr5OxVjVE/IGod2cGkGH5
         Wy/GibZfsq003uIWZW3SxWs/IHkbjooBGN7TOZMm+BpNo+gVth/fKiFkoUD+ZZ81lMVf
         6gZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=p81NHj5bjQp+JZ6X8YX7pMc38lX8Av8vguDYWp+Zb4A=;
        b=mAr2XPfS8Zv5zOH/7Pg6uZU82RVn9lh6NyfYHYSQUu1jnAtTmwx9NcFR1EJ1H02AWv
         PLZ+wVgzmfBN+oXEOZCY6cVfp0nZ0arpTGa5d6z+rKXBPOKwgqd8UYfTkLlDXiMMe4+m
         Y1Db65B4aZktt6b7Cz9SMVuNicCAPWmr7kpGAQIqJYztbFFnisFUHoiK6lFHjr9s6qce
         ApknqVhaeDD0NdMQgwsSFJzns46yts66VxQZsIaejw2WhEiNWKXb6NJvRankKMT3n8/j
         d5mhgZmie5+DIZ3QdrnRHFbN2UFMbG2HRe03HAqbAcWrjuQI4YIOYHQHxK1+jQrLX9Sc
         M4Aw==
X-Gm-Message-State: ACgBeo0WCCBSr17wi6iax5ssPC+hKi+MeB3IZi01lPtjzG3LmOk5YImJ
        4eyDP++uFvq6ScrZBUDyY91BQhxPwuShanRd
X-Google-Smtp-Source: AA6agR4y24zEcAYl7l98vjNK6drAUDRF/HIM9u6NVH1kjMqLIdb/4cZM/T5KyP8XFkan3Ze0utg2tA==
X-Received: by 2002:aa7:cc06:0:b0:440:7258:ad16 with SMTP id q6-20020aa7cc06000000b004407258ad16mr2166469edt.74.1660827643571;
        Thu, 18 Aug 2022 06:00:43 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id sd26-20020a170906ce3a00b0072aac7446easm802849ejb.47.2022.08.18.06.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 06:00:43 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next 0/4] net: devlink: sync flash and dev info commands
Date:   Thu, 18 Aug 2022 15:00:38 +0200
Message-Id: <20220818130042.535762-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Purpose of this patchset is to introduce consistency between two devlink
commands:
  devlink dev info
    Shows versions of running default flash target and components.
  devlink dev flash
    Flashes default flash target or component name (if specified
    on cmdline).

Currently it is up to the driver what versions to expose and what flash
update component names to accept. This is inconsistent. Thankfully, only
netdevsim is currently using components, so it is a good time
to sanitize this.

This patchset makes sure, that devlink.c calls into driver for
component flash update only in case the driver exposes the same version
name.

Also there are two flags exposed to the use over netlink for versions:

1) if driver considers the version represents flashable component,
   DEVLINK_ATTR_INFO_VERSION_IS_COMPONENT is set.
   This provides a list of component names for the user.

2) if driver considers the version represents default flash target (w/o
   component name specified)
   DEVLINK_ATTR_INFO_VERSION_IS_FLASH_UPDATE_DEFAULT is set.
   This tells the user which version is going to be affected by flash
   command when no component name is passed.

Example:
$ devlink dev info
netdevsim/netdevsim10:
  driver netdevsim
  versions:
      running:
        fw.mgmt 10.20.30
        fw 11.22.33
      flash_components:
        fw.mgmt
    flash_update_default fw
$ devlink dev flash netdevsim/netdevsim10 file somefile.bin
[fw.mgmt] Preparing to flash
[fw.mgmt] Flashing 100%
[fw.mgmt] Flash select
[fw.mgmt] Flashing done
$ devlink dev flash netdevsim/netdevsim10 file somefile.bin component fw.mgmt
[fw.mgmt] Preparing to flash
[fw.mgmt] Flashing 100%
[fw.mgmt] Flash select
[fw.mgmt] Flashing done
$ devlink dev flash netdevsim/netdevsim10 file somefile.bin component dummy
Error: selected component is not supported by this device.

Jiri Pirko (4):
  net: devlink: extend info_get() version put to indicate a flash
    component
  net: devlink: expose the info about version representing a component
  netdevsim: expose version of default flash target
  net: devlink: expose default flash update target

 drivers/net/netdevsim/dev.c  |  17 +++-
 include/net/devlink.h        |  18 ++++-
 include/uapi/linux/devlink.h |   3 +
 net/core/devlink.c           | 145 ++++++++++++++++++++++++++++++-----
 4 files changed, 157 insertions(+), 26 deletions(-)

-- 
2.37.1

