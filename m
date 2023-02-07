Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABE668D3B0
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBGKKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbjBGKJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDB72D44
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:09:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51449B81854
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EF2C433D2;
        Tue,  7 Feb 2023 10:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675764575;
        bh=6Y/S95xiqauvOWyVUNMI3d7j6PeUbNvoYOiFUD5pdjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WFVnl6L2Mq4pVw7mk9YBJGVOxy6PbMCCG73WeBVbpukU/phU+qy2I56eoTQC5AMr7
         UI09a8oxt2iyQmwv9OPuBTh2Dj4ILxY+pDbHHgeOEcy4pPtPlndDy0X7vfCGL5EjyE
         UanGPMl6oJ9zSJMghNyGwCyflPl5uqvAVc0HuKbCjcE8aTfztvGqnNft530mAH1U4V
         KOX166N2BSPsozb82K5+3pKzJ3xDw8BPuRbgAajiRXcfwhx0oIY0Ko6bj2ttgd5n8j
         iDppzmA3Ko9aG08oySyOgkiWmtygLjdVXyI/7c7dGOVwfqE/ewA2wh4rduiiCK2gsC
         5BhWT8+d2rq2A==
Date:   Tue, 7 Feb 2023 12:09:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        James Hershaw <james.hershaw@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next] nfp: flower: add check for flower VF netdevs
 for get/set_eeprom
Message-ID: <Y+IjW9F23QT9eu3w@unreal>
References: <20230206154836.2803995-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206154836.2803995-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 04:48:36PM +0100, Simon Horman wrote:
> From: James Hershaw <james.hershaw@corigine.com>
> 
> Move the nfp_net_get_port_mac_by_hwinfo() check to ahead in the
> get/set_eeprom() functions to in order to check for a VF netdev, which
> this function does not support.
> 
> It is debatable if this is a fix or an enhancement, and we have chosen
> to go for the latter. It does address a problem introduced by
> commit 74b4f1739d4e ("nfp: flower: change get/set_eeprom logic and enable for flower reps").
> However, the ethtool->len == 0 check avoids the problem manifesting as a
> run-time bug (NULL pointer dereference of app).
> 
> Signed-off-by: James Hershaw <james.hershaw@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
