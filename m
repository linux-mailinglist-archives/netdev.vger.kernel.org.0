Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C15440D53
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 07:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhJaG1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 02:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhJaG13 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 02:27:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92C7D603E8;
        Sun, 31 Oct 2021 06:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635661498;
        bh=G4FtmIqe2P2lyDTQ7EfJy97VjN3Xze+yYUe0ehD9UQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LqUnOznDBZjQbN7U/kz6Lt2nMuoQZRT4oKk0Xcu+nvXhCrcX2UwzMiLrORIsX7u1V
         ROctaSaezYkVtn+rol5+NwOPsadyrzMCwbTmTLNncXxVeX/OtVOmzsdK/Du/RXnmB9
         zhAlDfmukdhJQLSzkxVR5kc32GfyNupoWds1eXEXqLobbGoWgHaY1KB1Aa6PgD9fEN
         ghc6RtZT7A9tv1enfTxwcE7djyIpcik0UrtI00lLTPyaCX3HURNGNTatTUL2WEPJxl
         uYiFzamut8NHSFDOS1URpvklziWd3+jlmhRhld2a/soDZmFvmsK8DLW9NlVAq/656n
         WgL0pIlQPt+qQ==
Date:   Sun, 31 Oct 2021 08:24:54 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v2 2/4] ethtool: handle info/flash data copying
 outside rtnl_lock
Message-ID: <YX42tjF+ceidxUFh@unreal>
References: <20211030171851.1822583-1-kuba@kernel.org>
 <20211030171851.1822583-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030171851.1822583-3-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 30, 2021 at 10:18:49AM -0700, Jakub Kicinski wrote:
> We need to increase the lifetime of the data for .get_info
> and .flash_update beyond their handlers inside rtnl_lock.
> 
> Allocate a union on the heap and use it instead.
> 
> Note that we now copy the ethcmd before we lookup dev,
> hopefully there is no crazy user space depending on error
> codes.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ethtool/ioctl.c | 110 +++++++++++++++++++++++++++-----------------
>  1 file changed, 69 insertions(+), 41 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
