Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52223F1E5F
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhHSQxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhHSQxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:53:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF155610A6;
        Thu, 19 Aug 2021 16:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629391962;
        bh=U2BB0iXYilJfgsXxtnw5rv1yO6VLV7B1ozq6wZo/Eh4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CI2o6+3wG/wmr4/o0C1WoFMtOPvmnpgfE5d2S9Dffz3aie0mkSM90wEMrA3qVnYYa
         7fJYyo/NQ4Sz5RcGX5ICngGHpEhWhPem7M6ETiDq4seFsXdyMxNJjcHvVCuo0OQxJV
         1agEkDlFupQbI2LSbiUtf/nWPWVe5lbvipCHlr41SyOpSzt3VkYQve+tHfnwJjV6VK
         LnMt9qZO+B9ucOYBjSpsAHXNUt6De0q/y7x5/TjDl3pKM89d8MwETsNFYYupVDUaY5
         jbJvCZVt/971q7auwU54RdcphYNRJJa6QRvGpVO0cQlTQ/bmkuslUmFiRlZWXpq2Tw
         O9mCmMeZfRMQQ==
Date:   Thu, 19 Aug 2021 09:52:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net 1/1] ice: do not abort devlink info if PBA can't be
 found
Message-ID: <20210819095241.502dac9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210818174659.4140256-1-anthony.l.nguyen@intel.com>
References: <20210818174659.4140256-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Aug 2021 10:46:59 -0700 Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> The devlink dev info command reports version information about the
> device and firmware running on the board. This includes the "board.id"
> field which is supposed to represent an identifier of the board design.
> The ice driver uses the Product Board Assembly identifier for this.
> 
> In some cases, the PBA is not present in the NVM. If this happens,
> devlink dev info will fail with an error. Instead, modify the
> ice_info_pba function to just exit without filling in the context
> buffer. This will cause the board.id field to be skipped. Log a dev_dbg
> message in case someone wants to confirm why board.id is not showing up
> for them.
> 
> While at it, notice that none of the getter/fallback() functions report
> an error anymore. Convert the interface to a void so that it is no
> longer possible to add a version field that is fatal. This makes sense,
> because we should not fail to report other versions just because one of
> the version pieces could not be found.
> 
> Finally, clean up the getter functions line wrapping so that none of
> them take more than 80 columns, as is the usual style for networking
> files.
> 
> Fixes: e961b679fb0b ("ice: add board identifier info to devlink .info_get")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_devlink.c | 137 +++++++------------
>  1 file changed, 53 insertions(+), 84 deletions(-)

This is on the 'long' side, please just fix the bug and leave 
the refactoring for -next.
