Return-Path: <netdev+bounces-1689-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C47F56FED27
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:52:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA8921C20ECD
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B17E1B8FC;
	Thu, 11 May 2023 07:52:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB84371
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:52:48 +0000 (UTC)
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CA63A98
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:52:45 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f1411e8111so9211777e87.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683791563; x=1686383563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b6DFRF7liSPTRBWUgV4zRPvf0XPmI7i6mOr3sUG/Pww=;
        b=RcJOhHOIWUSQ93TYOfy2VN4gk4UjljRzsAC5LdPYalMUiOutpW4ENNVRrfIEb3usTd
         y8WPbazXzHH7723saBdE+DdKrZJIZSpwfRmepmPHrVK+DZWKOAsBV1xuPy8qke0QY0zA
         3BlzNmgIDfRKLdxSykvKXs6WOi1ijfBQg6FHLg452hr7C+hdOIByZ1C8AKRjrktFSjBd
         AQ8j/4zKZAI3g03EFng0UFnmwWJ7zULsnLu9iyW6Bv1MYAxn5KXE7boJa2ZQnqGroLM7
         iBGhRmIiVMfvWdmTPAEQLeDgEaQjUyO9RzJHTXh4KVx/14Rd82c51DZA3h+Kv4kCUnCp
         GezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683791563; x=1686383563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6DFRF7liSPTRBWUgV4zRPvf0XPmI7i6mOr3sUG/Pww=;
        b=OXJiD4YGX/JqkhKUPPijsmWBFV2IFKakDO8usGORtz1onoJXy0TiPHKd7PC0AkeyfC
         6KuAzmZSHOb4HlHUXS6724NHYsZ73h0/Un+PuOkqvciAu0RHczFfOjAYdsx20Rsr62QG
         fCaTgg6FkSonthDtR7/VEETqd5Y7w64omLk+Zoa3knzR+jMs32BNtwk2ucBRCnCRi519
         f/F5jJMAGaxy4OFr5EOlRN+FamIiQXnpxKSULjUTfpZ8dNBIC2BKFtF7i4eDC9hc+k7u
         sZNPYg3CIi4JQ4gZjIS15aMVYUd8bHR4eXx7CSk5Uy2VL8rF/aCjXeiiG5AsVQdTiIQ/
         nimg==
X-Gm-Message-State: AC+VfDxhqHy2MyRmJphMwep86Jpv/adRuBEWBRP6w4uTwRWRGASZNcWy
	LwCJTOrPxOwvg38lnmy2OSN16w==
X-Google-Smtp-Source: ACHHUZ6n5iHMqIe9ArVMmr5wpO4iz3LXFjcDxnbz9cB9wVHSPQHJaKcI4AgGn9KMUxzvWa7az03qhg==
X-Received: by 2002:ac2:4555:0:b0:4dd:cb1d:b3cc with SMTP id j21-20020ac24555000000b004ddcb1db3ccmr2413412lfm.11.1683791563299;
        Thu, 11 May 2023 00:52:43 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f1-20020ac25321000000b004eff3050e24sm1029272lfh.125.2023.05.11.00.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 00:52:42 -0700 (PDT)
Date: Thu, 11 May 2023 09:52:41 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <ZFyeydHS6iTECqiA@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428002009.2948020-1-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Apr 28, 2023 at 02:20:01AM CEST, vadfed@meta.com wrote:
>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>
>Implement common API for clock/DPLL configuration and status reporting.
>The API utilises netlink interface as transport for commands and event
>notifications. This API aim to extend current pin configuration and
>make it flexible and easy to cover special configurations.
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

Vadim, did you try ynl monitor? I think there might be something wrong
with the yaml spec:
# ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --subscribe monitor --sleep 10
Unexpected msg id done while checking for ntf nl_len = 92 (76) nl_flags = 0x0 nl_type = 19



