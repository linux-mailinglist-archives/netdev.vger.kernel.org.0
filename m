Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99F84347DE
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhJTJ15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:27:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhJTJ14 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 05:27:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3E4D610EA;
        Wed, 20 Oct 2021 09:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634721941;
        bh=5j2NUaDRml2UEYq1ijWuh7CqRu3+GudwsIOWQ4VzLyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hGXYa09GMpEFO+0V+wzM56y0glURH5WykLAzqaSiH/vYTat3DP/1E6o7W0MyPj2Dr
         q3HfSWs4S6RKl6iEgkS2qhK9tcnC3PmdA184xjidGEvgQcNbM6QNHRNA3zeWjTDfqP
         zoBBqxZYlZL8di8HK9oPNeSbwOocApVR3kwefJPsJkVKiwuTQ77kADaRdLBfcCFCBa
         N//j7+Wwv8LDg6CZWdh7DWGubrae25NaYaQ6nXYdEE6P05tAlbMl7L+yiLuku1brAT
         XL19oHLrKXnZYBa6I9QWqQUI758681DOV1wjuc7ZWslWAArSXlT9knK8y+043+G492
         YzDDkmS2zcfLQ==
Date:   Wed, 20 Oct 2021 11:25:37 +0200
From:   Simon Horman <horms@kernel.org>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] e1000: Remove redundant statement
Message-ID: <20211020092537.GF3935@kernel.org>
References: <20211018085305.853996-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018085305.853996-1-luo.penghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 08:53:05AM +0000, luo penghao wrote:

nit: s/linux-next/net-next/ in subject

> This statement is redundant in the context, because there will be
> an identical statement next. otherwise, the variable initialization
> is actually unnecessary.
> 
> The clang_analyzer complains as follows:
> 
> drivers/net/ethernet/intel/e1000/e1000_ethtool.c:1218:2 warning:
> 
> Value stored to 'ctrl_reg' is never read.

I agree this does seem to be the case.

> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: luo penghao <luo.penghao@zte.com.cn>

Reviewed-by: Simon Horman <horms@kernel.org>

> ---
>  drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
> index 0a57172..8951f2a 100644
> --- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
> +++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
> @@ -1215,8 +1215,6 @@ static int e1000_integrated_phy_loopback(struct e1000_adapter *adapter)
>  		e1000_write_phy_reg(hw, PHY_CTRL, 0x8140);
>  	}
>  
> -	ctrl_reg = er32(CTRL);
> -
>  	/* force 1000, set loopback */
>  	e1000_write_phy_reg(hw, PHY_CTRL, 0x4140);
>  
> -- 
> 2.15.2
> 
> 
