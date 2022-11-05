Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8828761A6CC
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 03:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiKECFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 22:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKECFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 22:05:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C903F2A70C
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A9A11CE1769
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 02:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B8AC433C1;
        Sat,  5 Nov 2022 02:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667613935;
        bh=QdudNwokCcZQW9NRKgRH6d4Af8A6JHfbtzshhPNLXIg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sK8dPxz+loQWfKIcOivcQqt9D+tb+g8yvFW1TVf+QTT0yZlRjtxeDZ+Cu352g9b1E
         +IjNwsp8F94zwISlI7Uq3Mzhln41R/lCjfs5w+boxk6CZwkhPd/8EAnjVZHEP/aWCs
         cIMsbHhSMoCc1NsRpqCTD8RZQzp9tInhmg4hFIDB3FUtWsNmxGQTHugsXfOh6Yb/Ix
         4C9ixx7n0dVCCm90kJZe9H06RqAy6PF7q96tJCnG9QF/eDV6IaJXJnLl40QUgQtaRo
         6ZSi4PDlf32UE2JDTlyG4ohpXTc/1mfHeaiRkMTbnSH4C97SydYT5p7ZSHCApRb+3L
         642RpmFOfaSPw==
Date:   Fri, 4 Nov 2022 19:05:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        ecree.xilinx@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v9 0/9] Implement devlink-rate API and extend
 it
Message-ID: <20221104190533.266e2926@kernel.org>
In-Reply-To: <20221104143102.1120076-1-michal.wilczynski@intel.com>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Nov 2022 15:30:53 +0100 Michal Wilczynski wrote:
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   4 +-
>  drivers/net/ethernet/intel/ice/ice_common.c   |   7 +-
>  drivers/net/ethernet/intel/ice/ice_dcb.c      |   2 +-
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   4 +
>  drivers/net/ethernet/intel/ice/ice_devlink.c  | 483 ++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_devlink.h  |   2 +
>  drivers/net/ethernet/intel/ice/ice_repr.c     |  13 +
>  drivers/net/ethernet/intel/ice/ice_sched.c    | 101 +++-
>  drivers/net/ethernet/intel/ice/ice_sched.h    |  31 +-
>  drivers/net/ethernet/intel/ice/ice_type.h     |   9 +
>  .../mellanox/mlx5/core/esw/devlink_port.c     |  14 +-
>  drivers/net/netdevsim/dev.c                   |   9 +-
>  include/net/devlink.h                         |  18 +-
>  include/uapi/linux/devlink.h                  |   3 +
>  net/core/devlink.c                            | 133 ++++-

Please provide some documentation.
