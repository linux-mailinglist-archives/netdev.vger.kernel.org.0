Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B856B7757
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCMMUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjCMMU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:20:29 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1022553DA6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 05:20:23 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso7724432wmo.0
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 05:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678710021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QZZtUYAVm5x5ul3HFxdiupVsQqADHacMtYp1TT721hg=;
        b=ECPCBjFMu50HfktgeuPGUYq6ntQX3vTvdAtpLtlqtytHkjfm7OFckglFUU/k5Q569A
         MER7YX7LzLdZYLW/PpzdG0wuDbDcUGfhfvrQJ330NJadew9CUP+HWEI4iMWPsTGELHyz
         +xEJ7Xy+jw126Yt7ugSESNsa+RrVZuoVpxj8nDBg94Vdp4gE3EPFK+Ik2ei7C32cyv/R
         Zs5yxgE2HVEJ23uvLSMTfdDSMugbuGEx8A611bzF3i1kCwTzAeoghyG+DHJTgtQGI2BX
         6Asv8rUss2XeyQyQOpAuoDByhD7K3YIfyWZoaKiIpFG+XHSFAOxY75E0IRh1WmmPiBTh
         PHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678710021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZZtUYAVm5x5ul3HFxdiupVsQqADHacMtYp1TT721hg=;
        b=ev14b1cD/z4JtrNtNRQKbJe+NhIWNA84jhbos34F30py7KcofWnBlsXylCfP1A9yGb
         Y3Kvbq+HeQZ3CbC3f9yIYemPJSFN32+fB80CkTlBCLIO2U4wniaQD4vipbEM0bB0HFBs
         VxPeuFtrMPDzG7xbj7sd11jhfZ0yPy8Gm6EG8lLz0p6eKLOhUFrDFmKI+dTeqE0G6Mjl
         yY7fO68d29gV7qQe6qN8hlUXgn3ZeSDmdNnl4xoOHyEni4K5iFNcilkKl+OrMBf/t/lN
         hWv241+I5NRE3/7MPGRS0pNSODOlHT/jCy6lfUmM95DQ+Kl6sS0vSbIeQc4uPoK7ZxBu
         BAmg==
X-Gm-Message-State: AO0yUKUK4AxKM7cHpPa8wmQJtk2fnXmOvreTpXp6jiw/MLoZHOba4zam
        9oUHb3YYBVCIXOF32q/T0ZFUE4rgsh+H79q0QKNF5Q==
X-Google-Smtp-Source: AK7set893dUi0mNz/xjUPmsNot0MPUKFzx8jcdYAHf9pjeN1NXS1rRZcNU2AqEo1MGC6QYZfiOuPeg==
X-Received: by 2002:a05:600c:19cf:b0:3eb:2da4:f304 with SMTP id u15-20020a05600c19cf00b003eb2da4f304mr9913319wmq.17.1678710021497;
        Mon, 13 Mar 2023 05:20:21 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u10-20020a7bcb0a000000b003e11ad0750csm8828897wmj.47.2023.03.13.05.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 05:20:20 -0700 (PDT)
Date:   Mon, 13 Mar 2023 13:20:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 0/6] Create common DPLL/clock configuration API
Message-ID: <ZA8VAzAhaXK3hg04@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-1-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:01AM CET, vadfed@meta.com wrote:
>Implement common API for clock/DPLL configuration and status reporting.
>The API utilises netlink interface as transport for commands and event
>notifications. This API aim to extend current pin configuration and
>make it flexible and easy to cover special configurations.

Could you please put here some command line examples to work with this?


>
>v5 -> v6:
> * rework pin part to better fit shared pins use cases
> * add YAML spec to easy generate user-space apps
> * simple implementation in ptp_ocp is back again
>v4 -> v5:
> * fix code issues found during last reviews:
>   - replace cookie with clock id
>	 - follow one naming schema in dpll subsys
>	 - move function comments to dpll_core.c, fix exports
>	 - remove single-use helper functions
>	 - merge device register with alloc
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
>	   "dpll_%s_%d_%d", where:
>       - %s - dev_name(parent) of parent device,
>       - %d (1) - enum value of dpll type,
>       - %d (2) - device index provided by parent device.
>   - new muxed/shared pin registration:
>	   Let the kernel module to register a shared or muxed pin without finding
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
>Vadim Fedorenko (3):
>  dpll: Add DPLL framework base functions
>  dpll: documentation on DPLL subsystem interface
>  ptp_ocp: implement DPLL ops
>
> Documentation/netlink/specs/dpll.yaml         |  514 +++++
> Documentation/networking/dpll.rst             |  347 ++++
> Documentation/networking/index.rst            |    1 +
> MAINTAINERS                                   |    9 +
> drivers/Kconfig                               |    2 +
> drivers/Makefile                              |    1 +
> drivers/dpll/Kconfig                          |    7 +
> drivers/dpll/Makefile                         |   10 +
> drivers/dpll/dpll_core.c                      |  835 ++++++++
> drivers/dpll/dpll_core.h                      |   99 +
> drivers/dpll/dpll_netlink.c                   | 1065 ++++++++++
> drivers/dpll/dpll_netlink.h                   |   30 +
> drivers/dpll/dpll_nl.c                        |  126 ++
> drivers/dpll/dpll_nl.h                        |   42 +
> drivers/net/ethernet/intel/Kconfig            |    1 +
> drivers/net/ethernet/intel/ice/Makefile       |    3 +-
> drivers/net/ethernet/intel/ice/ice.h          |    5 +
> .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  240 ++-
> drivers/net/ethernet/intel/ice/ice_common.c   |  467 +++++
> drivers/net/ethernet/intel/ice/ice_common.h   |   43 +
> drivers/net/ethernet/intel/ice/ice_dpll.c     | 1845 +++++++++++++++++
> drivers/net/ethernet/intel/ice/ice_dpll.h     |   96 +
> drivers/net/ethernet/intel/ice/ice_lib.c      |   17 +-
> drivers/net/ethernet/intel/ice/ice_main.c     |    7 +
> drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  411 ++++
> drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  240 +++
> drivers/net/ethernet/intel/ice/ice_type.h     |    1 +
> drivers/ptp/Kconfig                           |    1 +
> drivers/ptp/ptp_ocp.c                         |  206 +-
> include/linux/dpll.h                          |  284 +++
> include/uapi/linux/dpll.h                     |  196 ++
> 31 files changed, 7135 insertions(+), 16 deletions(-)
> create mode 100644 Documentation/netlink/specs/dpll.yaml
> create mode 100644 Documentation/networking/dpll.rst
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
> create mode 100644 include/linux/dpll.h
> create mode 100644 include/uapi/linux/dpll.h
>
>-- 
>2.34.1
>
