Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E58E65E75A
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbjAEJHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjAEJHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:07:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0EBCE3
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:07:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3422A6192B
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF86C433D2;
        Thu,  5 Jan 2023 09:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672909629;
        bh=IQsi9XGp5phzNwZ1a7loRAoJAsVmfe8u/E8sEwub9Gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eF987s8P76VVEly2MCzh5WL+2kxIDxih1brry0TKhXNDRF0frJE++IyRbJlFaosyb
         t5isuPEKvfLEXxtO9srv6Wn9J+K3daKXsnqtmKrlx97ZW5ZR4H2wbCPVqqHSSFHAxH
         zrj0s94Yai4l/rAxbf5zpAVKo7qoSFagJE8amK89aW7OmZU/QJ5dXQmOnrDGXtuIM1
         v3hpqSnOi1vaR78sj8XJv8lyYnvfN/QVSfTV4/aHcRbCAQ/IfvaseCROF47xOQXC05
         BSd8yQYBrjlBkpdLi8Fmy2vyP+3Bh8i5zDflaTZx1JU+rJMriT8IMmG1qw7moY0Ir4
         jAjXI1qEsxjNg==
Date:   Thu, 5 Jan 2023 11:07:05 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com
Subject: Re: [PATCH v2 net-next 1/3] net: ethernet: enetc: unlock
 XDP_REDIRECT for XDP non-linear buffers
Message-ID: <Y7aTOXfVK9KNXlVS@unreal>
References: <cover.1672840490.git.lorenzo@kernel.org>
 <4aa99c4ef0e9929fff82d694baa9d79b7ab85986.1672840490.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aa99c4ef0e9929fff82d694baa9d79b7ab85986.1672840490.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 02:57:10PM +0100, Lorenzo Bianconi wrote:
> Even if full XDP_REDIRECT is not supported yet for non-linear XDP buffers
> since we allow redirecting just into CPUMAPs, unlock XDP_REDIRECT for
> S/G XDP buffer and rely on XDP stack to properly take care of the
> frames.
> 
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c | 24 ++++++++------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
