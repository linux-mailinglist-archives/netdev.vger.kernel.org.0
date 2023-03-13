Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE426B7D5D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjCMQXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjCMQW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:22:59 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2FE79B03
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:22:53 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id f11so11862330wrv.8
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678724572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7P3VS2A1i6ziJIQ/rzXVpBzkHyvp4+HO/V3iiV/b3CU=;
        b=qlu+6RXhRBl4jQ3o/DJd9ewQKmzw635c29G/RcENl9m+zvYIPQBTBBL5PtDnFoWXi4
         mNE06pwGDUiyk5uVfgX3BimCcuFHbvHn9RYB4rXjWOD8xoRx6DSkcs53gWSgm7zWjQDg
         rvx2BjMgoPJR4jCr7KsTAkVm/p5ZHOpCmVt/AxMsrfOUWaSBngV0KJ019VTsZkVnSy0u
         6zTB2K0+qAvngafMxd9z6C7kO4SfNyHQ1t2J10kqbDtc1Av6Rer26D0okFglRUbGevDb
         OcAKBVM4z2/TMSJz1nVHtepXZrQKUXetRGjpBuLjhH7undeGPa/rf5FP8ZQ190QXN/tR
         ZfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678724572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7P3VS2A1i6ziJIQ/rzXVpBzkHyvp4+HO/V3iiV/b3CU=;
        b=mtDH4KOxRxOhn0/GlyDPzAk6RrZdHRyyjisKj5q+FNJwXDLu+S1BcgBpHa+Kdk8ytt
         CaDdWgs1i175mIZPsM0t+PlJ82UjlyiTaDCZXt4+hzC9dEdRN4d1fhrNCzN4/xr5wyUw
         7tTUA/+ikEXH3YajKv3unlb/TQGf2fj2i196S5GnFkIzw3yu3e/pHbHninwh2qI+7WAY
         J4aWd6ghmaYWlo3enCgoX/8Hrdi32IMCS3zVf9grhqiJaF3cCIFL8P5rkBIhg2gZSPBF
         P9qXnGiVxiPUpfWwKpRYetn4uHfN0e1FZnl4KitSjMazWntMmDgp9sxfdTifbCGzyz/4
         8Ilg==
X-Gm-Message-State: AO0yUKWTlCKLNMT7VZykpnhn42sv48E6o4YXGjBeoPBgrAG472oCZ9sE
        pS/rBNyu9DjrYr91HkE2p7evMg==
X-Google-Smtp-Source: AK7set9OIx8WCliVsZaETOcw9ihLjt8ooLm2yIXt3+fMmDLVWpW/TfZ/kPAhlIecsvOUqqXkZmJPSQ==
X-Received: by 2002:adf:fcc6:0:b0:2cf:170f:912a with SMTP id f6-20020adffcc6000000b002cf170f912amr2590869wrs.20.1678724571964;
        Mon, 13 Mar 2023 09:22:51 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g16-20020adfe410000000b002cfe0ab1246sm2750986wrm.20.2023.03.13.09.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 09:22:51 -0700 (PDT)
Date:   Mon, 13 Mar 2023 17:22:49 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 0/6] Create common DPLL/clock configuration API
Message-ID: <ZA9N2W35/7hH0wd2@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <ZA8VAzAhaXK3hg04@nanopsycho>
 <eb738303-b95c-408c-448d-0ebf983df01f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb738303-b95c-408c-448d-0ebf983df01f@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 13, 2023 at 04:33:13PM CET, vadim.fedorenko@linux.dev wrote:
>On 13/03/2023 12:20, Jiri Pirko wrote:
>> Sun, Mar 12, 2023 at 03:28:01AM CET, vadfed@meta.com wrote:
>> > Implement common API for clock/DPLL configuration and status reporting.
>> > The API utilises netlink interface as transport for commands and event
>> > notifications. This API aim to extend current pin configuration and
>> > make it flexible and easy to cover special configurations.
>> 
>> Could you please put here some command line examples to work with this?
>
>We don't have open-source tools ready right now for specific hardware, but
>with YAML spec published you can use in-kernel tool to manipulate the values,
>i.e.:
>
>./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --dump
>device-get
>./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do
>device-get --json '{"id": 0}'
>./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --dump
>pin-get
>./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do
>pin-get --json '{"id": 0, "pin-idx":1}'
>./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do
>pin-set --json '{"id":0, "pin-idx":1, "pin-frequency":1}'

Yep, that is exactly what I was asking for. Thanks.
Please try to extend it a bit and add to the cover letter. Gives people
better understanding of how this works.


>
>> 
>> > 
>> > v5 -> v6:
>> > * rework pin part to better fit shared pins use cases
>> > * add YAML spec to easy generate user-space apps
>> > * simple implementation in ptp_ocp is back again
>> > v4 -> v5:
>> > * fix code issues found during last reviews:
>> >    - replace cookie with clock id
>> > 	 - follow one naming schema in dpll subsys
>> > 	 - move function comments to dpll_core.c, fix exports
>> > 	 - remove single-use helper functions
>> > 	 - merge device register with alloc
>> >    - lock and unlock mutex on dpll device release
>> >    - move dpll_type to uapi header
>> >    - rename DPLLA_DUMP_FILTER to DPLLA_FILTER
>> >    - rename dpll_pin_state to dpll_pin_mode
>> >    - rename DPLL_MODE_FORCED to DPLL_MODE_MANUAL
>> >    - remove DPLL_CHANGE_PIN_TYPE enum value
>> > * rewrite framework once again (Arkadiusz)
>> >    - add clock class:
>> >      Provide userspace with clock class value of DPLL with dpll device dump
>> >      netlink request. Clock class is assigned by driver allocating a dpll
>> >      device. Clock class values are defined as specified in:
>> >      ITU-T G.8273.2/Y.1368.2 recommendation.
>> >    - dpll device naming schema use new pattern:
>> > 	   "dpll_%s_%d_%d", where:
>> >        - %s - dev_name(parent) of parent device,
>> >        - %d (1) - enum value of dpll type,
>> >        - %d (2) - device index provided by parent device.
>> >    - new muxed/shared pin registration:
>> > 	   Let the kernel module to register a shared or muxed pin without finding
>> >      it or its parent. Instead use a parent/shared pin description to find
>> >      correct pin internally in dpll_core, simplifing a dpll API
>> > * Implement complex DPLL design in ice driver (Arkadiusz)
>> > * Remove ptp_ocp driver from the series for now
>> > v3 -> v4:
>> > * redesign framework to make pins dynamically allocated (Arkadiusz)
>> > * implement shared pins (Arkadiusz)
>> > v2 -> v3:
>> > * implement source select mode (Arkadiusz)
>> > * add documentation
>> > * implementation improvements (Jakub)
>> > v1 -> v2:
>> > * implement returning supported input/output types
>> > * ptp_ocp: follow suggestions from Jonathan
>> > * add linux-clk mailing list
>> > v0 -> v1:
>> > * fix code style and errors
>> > * add linux-arm mailing list
>> > 
>> > Arkadiusz Kubalewski (3):
>> >   dpll: spec: Add Netlink spec in YAML
>> >   ice: add admin commands to access cgu configuration
>> >   ice: implement dpll interface to control cgu
>> > 
>> > Vadim Fedorenko (3):
>> >   dpll: Add DPLL framework base functions
>> >   dpll: documentation on DPLL subsystem interface
>> >   ptp_ocp: implement DPLL ops
>> > 
>> > Documentation/netlink/specs/dpll.yaml         |  514 +++++
>> > Documentation/networking/dpll.rst             |  347 ++++
>> > Documentation/networking/index.rst            |    1 +
>> > MAINTAINERS                                   |    9 +
>> > drivers/Kconfig                               |    2 +
>> > drivers/Makefile                              |    1 +
>> > drivers/dpll/Kconfig                          |    7 +
>> > drivers/dpll/Makefile                         |   10 +
>> > drivers/dpll/dpll_core.c                      |  835 ++++++++
>> > drivers/dpll/dpll_core.h                      |   99 +
>> > drivers/dpll/dpll_netlink.c                   | 1065 ++++++++++
>> > drivers/dpll/dpll_netlink.h                   |   30 +
>> > drivers/dpll/dpll_nl.c                        |  126 ++
>> > drivers/dpll/dpll_nl.h                        |   42 +
>> > drivers/net/ethernet/intel/Kconfig            |    1 +
>> > drivers/net/ethernet/intel/ice/Makefile       |    3 +-
>> > drivers/net/ethernet/intel/ice/ice.h          |    5 +
>> > .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  240 ++-
>> > drivers/net/ethernet/intel/ice/ice_common.c   |  467 +++++
>> > drivers/net/ethernet/intel/ice/ice_common.h   |   43 +
>> > drivers/net/ethernet/intel/ice/ice_dpll.c     | 1845 +++++++++++++++++
>> > drivers/net/ethernet/intel/ice/ice_dpll.h     |   96 +
>> > drivers/net/ethernet/intel/ice/ice_lib.c      |   17 +-
>> > drivers/net/ethernet/intel/ice/ice_main.c     |    7 +
>> > drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  411 ++++
>> > drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  240 +++
>> > drivers/net/ethernet/intel/ice/ice_type.h     |    1 +
>> > drivers/ptp/Kconfig                           |    1 +
>> > drivers/ptp/ptp_ocp.c                         |  206 +-
>> > include/linux/dpll.h                          |  284 +++
>> > include/uapi/linux/dpll.h                     |  196 ++
>> > 31 files changed, 7135 insertions(+), 16 deletions(-)
>> > create mode 100644 Documentation/netlink/specs/dpll.yaml
>> > create mode 100644 Documentation/networking/dpll.rst
>> > create mode 100644 drivers/dpll/Kconfig
>> > create mode 100644 drivers/dpll/Makefile
>> > create mode 100644 drivers/dpll/dpll_core.c
>> > create mode 100644 drivers/dpll/dpll_core.h
>> > create mode 100644 drivers/dpll/dpll_netlink.c
>> > create mode 100644 drivers/dpll/dpll_netlink.h
>> > create mode 100644 drivers/dpll/dpll_nl.c
>> > create mode 100644 drivers/dpll/dpll_nl.h
>> > create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.c
>> > create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.h
>> > create mode 100644 include/linux/dpll.h
>> > create mode 100644 include/uapi/linux/dpll.h
>> > 
>> > -- 
>> > 2.34.1
>> > 
>
