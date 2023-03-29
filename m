Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B726CD926
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjC2MJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjC2MJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:09:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D1E1736
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:09:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D055DB822E4
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 12:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA7EC4339C;
        Wed, 29 Mar 2023 12:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680091766;
        bh=vsvIF1dha99wCHbqgLxdsHioqdyFW4N338pDu/Tp3/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=okUFsPNruKyWl4dgl3O7I6C7fRUm9xAe+vmQAaD4h/gnIIkOQ/HHH5XuLG3D9Ufth
         xOS0dfh/9uDsdyFEBlR1WJZRyD9XZbniRLvOueYBRLvpo9Jw/AWV3j3RxqX1Z1F7oV
         MbMItkVE5zOumdBobNPMZ3h8tzcfK7+veKpJnp7VAslqDeiWXe+QcTxz7JD94MdjMw
         L3iGNtikurDS0xsJv38VrYUumdG+ufYoivNhZQfgwWI4nKvlE+qauxD41ajxXGS9zj
         TrpyH0bFt+Gu8TSltDhBpIMx0Zb4FB9tG9M1O0vjuY8Ejt7IXs/9ZQTQPV8lCXMdJd
         n12fDo55+nApw==
Date:   Wed, 29 Mar 2023 15:09:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Radoslaw Tyl <radoslawx.tyl@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Arpana Arland <arpanax.arland@intel.com>
Subject: Re: [PATCH net 1/1] i40e: fix registers dump after run ethtool
 adapter self test
Message-ID: <20230329120922.GT831478@unreal>
References: <20230328172659.3906413-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328172659.3906413-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 10:26:59AM -0700, Tony Nguyen wrote:
> From: Radoslaw Tyl <radoslawx.tyl@intel.com>
> 
> Fix invalid registers dump from ethtool -d ethX after adapter self test
> by ethtool -t ethY. It causes invalid data display.
> 
> The problem was caused by overwriting i40e_reg_list[].elements
> which is common for ethtool self test and dump.
> 
> Fixes: 22dd9ae8afcc ("i40e: Rework register diagnostic")
> Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_diag.c | 11 ++++++-----
>  drivers/net/ethernet/intel/i40e/i40e_diag.h |  2 +-
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
