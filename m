Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F6E686334
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjBAJzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjBAJzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:55:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3BF28D03
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 01:55:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2DFFB820FE
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9D3C433EF;
        Wed,  1 Feb 2023 09:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675245332;
        bh=zmgPCLCZHu9sxFZ4Y5/r21oBmOcWbibQbWtVuxgw06E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TcANfXwXWKABjePQIArtM51XgqgRGtav/4w0F2nsKW5vRZDXVbYg/4WdFNf5Tcbdj
         +8mh8kvVGxPXiRtql37U9bs7pjZAFM+QESdmv90opPMNioyzmTvWpoc2IpsmiDMqci
         Hl7uQVPXyFHPo/Hh8JfTte8x85viD6e7PdcyA3VRXDre/660/fkFUHD3/tOxJW1W1U
         nwVAft/Njel3ne/uh0SRRwWTfZl0csxguXrj1Beu0zGqabITk3HHgyR21eYQ2gziv/
         pxFnNhSj5LB3yd3CQ1gOh9xC+C2j6tOIc1t/kQugA0syqS2sGswu+BPzOfYpDMpKEP
         PLP5vGHCXB7cw==
Date:   Wed, 1 Feb 2023 11:55:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Zhang Changzhong <zhangchangzhong@huawei.com>,
        netdev@vger.kernel.org,
        Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Subject: Re: [PATCH net 6/6] ice: switch: fix potential memleak in
 ice_add_adv_recipe()
Message-ID: <Y9o3EHjrO7S+mXRW@unreal>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
 <20230131213703.1347761-7-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131213703.1347761-7-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 01:37:03PM -0800, Tony Nguyen wrote:
> From: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> When ice_add_special_words() fails, the 'rm' is not released, which will
> lead to a memory leak. Fix this up by going to 'err_unroll' label.
> 
> Compile tested only.
> 
> Fixes: 8b032a55c1bd ("ice: low level support for tunnels")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_switch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
