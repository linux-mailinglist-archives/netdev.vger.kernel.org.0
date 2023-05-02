Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A1E6F3FA7
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 10:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbjEBIzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 04:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbjEBIzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 04:55:15 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5FD1BD8
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 01:55:13 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4efeea05936so4103178e87.2
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 01:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683017711; x=1685609711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6KAOCXN0Bjiv2/am6tzP5opdR60WhoCZzyQYuV095Po=;
        b=wgyDO4WoIZx/It75e6I8TCsFFQdnH8LdCgCZhPgFDy5ihl6KK64cMmdxVvarmn8GjP
         o8Ig+eEeRy+6wpklqNWrktMqMRnz7JLwxDbQNoekf0FWz/SkAXX5ok6wHyDgWQFnozKS
         Ch7aVv7ludwU1YI3hR9t6dGxEf76qQiCLaCnZhwrc500ZWGeR1XCvRNnac8Ga8QzRdIG
         f37V3UKz4gtuh6zIQMlvSaFP6u0JuEAIagHzs4IQg2GeQQbXidJJFZBQRFbXdvaOu1+e
         nNI94EMR4YEkx9ksezU4+4L2d3OZIF3JZZAyP7hXbF5fbfa4nESNOvz8Km2CU1/FIkST
         WUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683017711; x=1685609711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6KAOCXN0Bjiv2/am6tzP5opdR60WhoCZzyQYuV095Po=;
        b=DnwbVkbr2esh+eJFjT7e4M4hk7Hq6Hma6bKTZj0V03IIARUm1mfU+kMylCNQCLD7o3
         fRiYuhOfu9vYajl5Dv998+wBmQKX1GYGZ2oeeXZ9EN5ddATNn46sXzBH4Rirjo9WZSeU
         YOA/i2NqISRPRZaVgb+b4nF21FBytROsBRBQ2pvZfy5VQnUGjn0TscYzizSvyS59e3Kz
         CBy/3kSAPpB1arSVxRdV//daPNg5324/mRn4jOlgQyN4n4IiNwBgWWU6v3uxWH77X1wn
         T9N/OA7eSOPfrHT3Mp++Z3eSEgJe7WadP/wA7RqvmBKq2CcOnZ1Xiyf14pjobsDDNS3t
         wlBA==
X-Gm-Message-State: AC+VfDx013XFZDZp2ssi0S20nq9vBylgEfpE95mwp6ma1ParotxQbiVy
        KG9DJtZMPEZqCPLu8GA+1U+uFA==
X-Google-Smtp-Source: ACHHUZ7v3evF05SJzw6RKcHifKinUdxWIjmkm/fvqm2KnR/AHLSlpfu8PR1U/chUv9IKte3vPZtrsQ==
X-Received: by 2002:a19:ae0b:0:b0:4e9:5f90:748 with SMTP id f11-20020a19ae0b000000b004e95f900748mr4092307lfc.9.1683017711356;
        Tue, 02 May 2023 01:55:11 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 8-20020ac24828000000b004ecad67a925sm5205014lft.66.2023.05.02.01.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 01:55:10 -0700 (PDT)
Date:   Tue, 2 May 2023 10:55:09 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v7 0/8] Create common DPLL configuration API
Message-ID: <ZFDP7SA7qaSFQh/l@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428002009.2948020-1-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Apr 28, 2023 at 02:20:01AM CEST, vadfed@meta.com wrote:
>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>
>Implement common API for clock/DPLL configuration and status reporting.
>The API utilises netlink interface as transport for commands and event
>notifications. This API aim to extend current pin configuration and
>make it flexible and easy to cover special configurations.

Vadim, I guess you forgot, could you please add some example commands
here? Please keep them in for the next V.

Thanks!


>
>v6 -> v7:
> * YAML spec:
>   - remove nested 'pin' attribute
>   - clean up definitions on top of the latest changes
> * pin object:
>   - pin xarray uses id provided by the driver
>   - remove usage of PIN_IDX_INVALID in set function
>   - source_pin_get() returns object instead of idx
>   - fixes in frequency support API
> * device and pin operations are const now
> * small fixes in naming in Makefile and in the functions
> * single mutex for the subsystem to avoid possible ABBA locks
> * no special *_priv() helpers anymore, private data is passed as void*
> * no netlink filters by name anymore, only index is supported
> * update ptp_ocp and ice drivers to follow new API version
> * add mlx5e driver as a new customer of the subsystem
>v5 -> v6:
> * rework pin part to better fit shared pins use cases
> * add YAML spec to easy generate user-space apps
> * simple implementation in ptp_ocp is back again
>v4 -> v5:
> * fix code issues found during last reviews:
>   - replace cookie with clock id
>   - follow one naming schema in dpll subsys
>   - move function comments to dpll_core.c, fix exports
>   - remove single-use helper functions
>   - merge device register with alloc
>   - lock and unlock mutex on dpll device release
>   - move dpll_type to uapi header
>   - rename DPLLA_DUMP_FILTER to DPLLA_FILTER
>   - rename dpll_pin_state to dpll_pin_mode
>   - rename DPLL_MODE_FORCED to DPLL_MODE_MANUAL
>   - remove DPLL_CHANGE_PIN_TYPE enum value
> * rewrite framework once again (Arkadiusz)
>   - add clock class:
>     Provide userspace with clock class value of DPLL with dpll device dump
>     netlink request. Clock class is assigned by driver allocating a dpll
>     device. Clock class values are defined as specified in:
>     ITU-T G.8273.2/Y.1368.2 recommendation.
>   - dpll device naming schema use new pattern:
>     "dpll_%s_%d_%d", where:
>       - %s - dev_name(parent) of parent device,
>       - %d (1) - enum value of dpll type,
>       - %d (2) - device index provided by parent device.
>   - new muxed/shared pin registration:
>     Let the kernel module to register a shared or muxed pin without finding
>     it or its parent. Instead use a parent/shared pin description to find
>     correct pin internally in dpll_core, simplifing a dpll API
> * Implement complex DPLL design in ice driver (Arkadiusz)
> * Remove ptp_ocp driver from the series for now
>v3 -> v4:
> * redesign framework to make pins dynamically allocated (Arkadiusz)
> * implement shared pins (Arkadiusz)
>v2 -> v3:
> * implement source select mode (Arkadiusz)
> * add documentation
> * implementation improvements (Jakub)
>v1 -> v2:
> * implement returning supported input/output types
> * ptp_ocp: follow suggestions from Jonathan
> * add linux-clk mailing list
>v0 -> v1:
> * fix code style and errors
> * add linux-arm mailing list
>
>Arkadiusz Kubalewski (3):
>  dpll: spec: Add Netlink spec in YAML
>  ice: add admin commands to access cgu configuration
>  ice: implement dpll interface to control cgu
>
>Jiri Pirko (2):
>  netdev: expose DPLL pin handle for netdevice
>  mlx5: Implement SyncE support using DPLL infrastructure
>
>Vadim Fedorenko (3):
>  dpll: Add DPLL framework base functions
>  dpll: documentation on DPLL subsystem interface
>  ptp_ocp: implement DPLL ops
>
> Documentation/dpll.rst                        |  408 ++++
> Documentation/netlink/specs/dpll.yaml         |  472 ++++
> Documentation/networking/index.rst            |    1 +
> MAINTAINERS                                   |    8 +
> drivers/Kconfig                               |    2 +
> drivers/Makefile                              |    1 +
> drivers/dpll/Kconfig                          |    7 +
> drivers/dpll/Makefile                         |   10 +
> drivers/dpll/dpll_core.c                      |  939 ++++++++
> drivers/dpll/dpll_core.h                      |  113 +
> drivers/dpll/dpll_netlink.c                   |  991 +++++++++
> drivers/dpll/dpll_netlink.h                   |   27 +
> drivers/dpll/dpll_nl.c                        |  126 ++
> drivers/dpll/dpll_nl.h                        |   42 +
> drivers/net/ethernet/intel/Kconfig            |    1 +
> drivers/net/ethernet/intel/ice/Makefile       |    3 +-
> drivers/net/ethernet/intel/ice/ice.h          |    5 +
> .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  240 +-
> drivers/net/ethernet/intel/ice/ice_common.c   |  467 ++++
> drivers/net/ethernet/intel/ice/ice_common.h   |   43 +
> drivers/net/ethernet/intel/ice/ice_dpll.c     | 1929 +++++++++++++++++
> drivers/net/ethernet/intel/ice/ice_dpll.h     |  101 +
> drivers/net/ethernet/intel/ice/ice_lib.c      |   17 +-
> drivers/net/ethernet/intel/ice/ice_main.c     |    7 +
> drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  414 ++++
> drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  230 ++
> drivers/net/ethernet/intel/ice/ice_type.h     |    1 +
> .../net/ethernet/mellanox/mlx5/core/Kconfig   |    8 +
> .../net/ethernet/mellanox/mlx5/core/Makefile  |    3 +
> drivers/net/ethernet/mellanox/mlx5/core/dev.c |   17 +
> .../net/ethernet/mellanox/mlx5/core/dpll.c    |  438 ++++
> drivers/ptp/Kconfig                           |    1 +
> drivers/ptp/ptp_ocp.c                         |  327 ++-
> include/linux/dpll.h                          |  294 +++
> include/linux/mlx5/driver.h                   |    2 +
> include/linux/mlx5/mlx5_ifc.h                 |   59 +-
> include/linux/netdevice.h                     |    7 +
> include/uapi/linux/dpll.h                     |  204 ++
> include/uapi/linux/if_link.h                  |    2 +
> net/core/dev.c                                |   20 +
> net/core/rtnetlink.c                          |   38 +
> 41 files changed, 7966 insertions(+), 59 deletions(-)
> create mode 100644 Documentation/dpll.rst
> create mode 100644 Documentation/netlink/specs/dpll.yaml
> create mode 100644 drivers/dpll/Kconfig
> create mode 100644 drivers/dpll/Makefile
> create mode 100644 drivers/dpll/dpll_core.c
> create mode 100644 drivers/dpll/dpll_core.h
> create mode 100644 drivers/dpll/dpll_netlink.c
> create mode 100644 drivers/dpll/dpll_netlink.h
> create mode 100644 drivers/dpll/dpll_nl.c
> create mode 100644 drivers/dpll/dpll_nl.h
> create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.c
> create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.h
> create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/dpll.c
> create mode 100644 include/linux/dpll.h
> create mode 100644 include/uapi/linux/dpll.h
>
>-- 
>2.34.1
>
