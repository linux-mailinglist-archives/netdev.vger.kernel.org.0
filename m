Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A367645644
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiLGJQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiLGJPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:15:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051BC1057B
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 01:14:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A02560EF6
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 09:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27824C433D6;
        Wed,  7 Dec 2022 09:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670404488;
        bh=Q2nlY4DhQIvrAVkliKtldVbnw1b0c1cgP9F7qRRC5J0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nKM3Sl8uveabsilbviZeEqlVpLBozTtfmd1entAligYhGie/zSiIKK2xEr/hEnmDo
         uPagpAv4Q2gIgMGeuzEeCngofPjmKEJCDtbXehRAfGHNK9UIxO7WhSuXJAoIkZLTkO
         ckQUYANpjSKO7XuiVxaa2cRFHhqQon9CZyXXQLPecha3C9Jd+5GRm0bxYzYwdlQ0G5
         8L4O3vg2UQUE8+cCptGy4g8L8wQVdeLbE5jP2hdVQmkGf78+oa9ScOWXcWJS/bdLvT
         +6wYzV7lGF/DX3ibC2IVbUr8drtGzXAVsWCmNkrG+lXnvXxTSamZ5vldswIb3SC+Aa
         7FXYFdVIbDA6A==
Date:   Wed, 7 Dec 2022 11:14:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yuan Can <yuancan@huawei.com>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        rajesh.borundia@qlogic.com, sucheta.chakraborty@qlogic.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] drivers: net: qlcnic: Fix potential memory leak
 in qlcnic_sriov_init()
Message-ID: <Y5BZg4kEl8X05tD2@unreal>
References: <20221207085410.123938-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207085410.123938-1-yuancan@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 08:54:10AM +0000, Yuan Can wrote:
> If vp alloc failed in qlcnic_sriov_init(), all previously allocated vp
> needs to be freed.
> 
> Fixes: f197a7aa6288 ("qlcnic: VF-PF communication channel implementation")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
> Changes in v2:
> - free all vp before destroy_workqueue(bc->bc_trans_wq)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
