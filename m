Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB750C4C9
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiDVXSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiDVXRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:17:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CB21EED7;
        Fri, 22 Apr 2022 15:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACE49B832FD;
        Fri, 22 Apr 2022 22:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB09EC385A0;
        Fri, 22 Apr 2022 22:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650667935;
        bh=LVT7Tuu3YFl0yAkyZDgcl+9CRLIGTAoAZA1x5aWMGbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PAV9pLi04YZXLzLPI8FUh87Bh8iwy70eA+BtHZ+8D/BuUStEqOOBCNVAScWJMYj2c
         VQI8mf++Xz1RFSP6FBLfqJ7HjlVIaDaHOKpV9X9mpzG1U2SrCr4LfI2gZ3cczYEXwe
         OE8NQ+B4IZ3sE2lMqfn4dLllk7XrNv1GyZXM3IhZMmgEqeDeLxTxlVY9BNZlMwhLFE
         GhnDf3bZ1B5IpS4o42KqqSmc0F2pkF1tLXWsmwQGHte4zbWUVg99A20Z55JKj9rcox
         zzO5dZtwSGpYZs1qWLWqIRyWN00Z+bGABwgVxDDJ76SnEKH+5krF0fIENm1VuBY+At
         QAiBqHHMjRVwQ==
Date:   Fri, 22 Apr 2022 15:52:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Daly <jeffd@silicom-usa.com>
Cc:     intel-wired-lan@osuosl.org,
        Stephen Douthit <stephend@silicom-usa.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 1/1] ixgbe: correct SDP0 check of SFP cage for X550
Message-ID: <20220422155213.3b9bf4a9@kernel.org>
In-Reply-To: <20220420205130.23616-1-jeffd@silicom-usa.com>
References: <20220420205130.23616-1-jeffd@silicom-usa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Apr 2022 16:51:30 -0400 Jeff Daly wrote:
> SDP0 for X550 NICs is active low to indicate the presence of an SFP in the
> cage (MOD_ABS#).  Invert the results of the logical AND to set
> sfp_cage_full variable correctly.
> 
> Fixes: aac9e053f104 ("ixgbe: cleanup crosstalk fix")
> 

No new lines between tags, please.

> Suggested-by: Stephen Douthit <stephend@silicom-usa.com>
> Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> index 4c26c4b92f07..26d16bc85c59 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> @@ -3308,8 +3308,8 @@ s32 ixgbe_check_mac_link_generic(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
>  			break;
>  		case ixgbe_mac_X550EM_x:
>  		case ixgbe_mac_x550em_a:
> -			sfp_cage_full = IXGBE_READ_REG(hw, IXGBE_ESDP) &
> -					IXGBE_ESDP_SDP0;
> +			sfp_cage_full = !(IXGBE_READ_REG(hw, IXGBE_ESDP) &
> +					IXGBE_ESDP_SDP0);

nit: you need to adjust the continuation line so that it starts after
the column in which ( is, above. Alternatively you can use ~ on the
result of the register read to avoid the brackets.
