Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C071268774A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbjBBI0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBBI0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:26:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F5BA258;
        Thu,  2 Feb 2023 00:26:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DE0A6185D;
        Thu,  2 Feb 2023 08:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18692C433EF;
        Thu,  2 Feb 2023 08:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675326407;
        bh=JG1JmI9JBW9yaMzdHTJELLOmEsFpnPZMc9mFf3CBdpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gcsmWB/b/avIssocnYYRDoKU3Ybm1EFLFE6S7RasCMgm6+grZQY8q/vRflTOfvLUl
         EUtc3nSazW7FzDUOP9JU+lYE2uP+ooJi2NOA8OrucMjW4LdWZtkkmxQ2zD9ozDsj0z
         CTgxbasjwf5jc9fRnPYQsGMfV0zP0FWymhLHkaxdxYu+q3b2dgUnYg4M1prFPEaR6S
         IQ+fU7byfyEtZhLg0EHCUMgyMYfqzp4iakpnhLPaU184II7gyUla9BaDhbFio+oIFk
         7cTeU7nNGwMx76oGQAtRiXSfrAvUAR/vp4dfbxnXdfnJcW66gItYt0XDZZ+m+n+tcM
         UWgROdZp0hfIw==
Date:   Thu, 2 Feb 2023 10:26:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jianbo Liu <jianbol@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: linux-next: manual merge of the mlx5-next tree with the net-next
 tree
Message-ID: <Y9tzw0o3/Sz3v0bb@unreal>
References: <20230202091433.7fb9d936@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202091433.7fb9d936@canb.auug.org.au>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 09:14:33AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the mlx5-next tree got a conflict in:
> 
>   include/linux/mlx5/driver.h
> 
> between commit:
> 
>   fe298bdf6f65 ("net/mlx5: Prepare for fast crypto key update if hardware supports it")
> 
> from the net-next tree and commit:
> 
>   2fd0e75727a8 ("net/mlx5e: Propagate an internal event in case uplink netdev changes")
> 
> from the mlx5-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc include/linux/mlx5/driver.h
> index 234334194b38,cc48aa308269..000000000000
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@@ -674,7 -675,7 +675,8 @@@ struct mlx5e_resources 
>   	} hw_objs;
>   	struct devlink_port dl_port;
>   	struct net_device *uplink_netdev;
>  +	struct mlx5_crypto_dek_priv *dek_priv;
> + 	struct mutex uplink_netdev_lock;
>   };
>   
>   enum mlx5_sw_icm_type {

LGTM, thanks for the conflict resolution.
