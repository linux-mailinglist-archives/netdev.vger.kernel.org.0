Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429EA67C920
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbjAZKvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236186AbjAZKvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:51:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D213B45F45
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:50:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E227B81D50
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1387BC433EF;
        Thu, 26 Jan 2023 10:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674730236;
        bh=1+akg2XoFTdY8fUEzKJn7cnTUsywlutRSPrqeISYlX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VWfAenzhCGLbGsrJxfvaMvmqq7ZiRq+sQpeWx316YaGUrOHwS0QMzQ85Airc02w+C
         rD++av9pxiurPCM4MccwQzHOtAp1Axjz5e4xs7i3rQBCsZ960DdxdKyyXYhyTiYHuu
         ToshAajLFPZo1dk4yZM3CwK7Olk3LI1AcRhOAcSPeSBSTGYkEnxzqO+YIotV3h9YnB
         XzCBPPjZq6ZOnNahZmqo7lwxEIFChDUru0aO4rb+fMITB92qHONve7gshCvfIQOqHl
         Liwa91TY4G2A8ZehT2oyg4+/cHAiwjUEegmO9buzCBkmCrAkMKTYJb+SgXmKll8KpF
         2BkZoB4LY8JFA==
Date:   Thu, 26 Jan 2023 12:50:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 1/3] igc: Add qbv_config_change_errors counter
Message-ID: <Y9Ja+EcGcUYMnTFg@unreal>
References: <20230125212702.4030240-1-anthony.l.nguyen@intel.com>
 <20230125212702.4030240-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125212702.4030240-2-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 01:27:00PM -0800, Tony Nguyen wrote:
> From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> 
> Add ConfigChangeError(qbv_config_change_errors) when user try to set the
> AdminBaseTime to past value while the current GCL is still running.
> 
> The ConfigChangeError counter should not be increased when a gate control
> list is scheduled into the future.
> 
> User can use "ethtool -S <interface> | grep qbv_config_change_errors"
> command to check the counter values.
> 
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc.h         | 1 +
>  drivers/net/ethernet/intel/igc/igc_ethtool.c | 1 +
>  drivers/net/ethernet/intel/igc/igc_main.c    | 1 +
>  drivers/net/ethernet/intel/igc/igc_tsn.c     | 6 ++++++
>  4 files changed, 9 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
