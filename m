Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F89A62B3C7
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 08:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbiKPHLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 02:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiKPHLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 02:11:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4AA1F608;
        Tue, 15 Nov 2022 23:11:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 559CC61A4F;
        Wed, 16 Nov 2022 07:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAD1C433D6;
        Wed, 16 Nov 2022 07:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668582674;
        bh=zJUKF6B5wFDQpbk6RK2X5F8SYhcjLUE/tEWHlFSY8dU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BMV2L/XVq3E4FzYxRA5sBJZqAKYUQbu9BdO1dXl0c8ZCElt4lSimYTB4GO7Z24qjm
         kI0FzTBs+IIAUJeAW6mROyWAOFLoPpc1EIMgx5OGMPTyVsTC4USEQkNBgtLwdrFdaY
         sxe718Vn7b8WWwyaxHU5mxH0JZFk/KczdyXRdpq/0ptjUJoPryOmoT5HXcz76B5iIS
         +yzicr64Ss0txe2dkw+Ikpts9er6Je7q68fj/Yijarx/ht/FBhpzVbeNGbZeRspYFf
         RG6kEQESaVupz3EzjRbND7MDxqS/BBnsO4R/4VvV5O+ihHPe1O4qjcLA4IhhRN74HA
         s4kd5LzGpAgew==
Date:   Wed, 16 Nov 2022 09:11:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 7/7] dma-mapping: reject __GFP_COMP in dma_alloc_attrs
Message-ID: <Y3SNDR7KMJOkTREK@unreal>
References: <20221113163535.884299-1-hch@lst.de>
 <20221113163535.884299-8-hch@lst.de>
 <Y3H4RobK/pmDd3xG@unreal>
 <20221116061106.GA19118@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116061106.GA19118@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 07:11:06AM +0100, Christoph Hellwig wrote:
> On Mon, Nov 14, 2022 at 10:11:50AM +0200, Leon Romanovsky wrote:
> > In RDMA patches, you wrote that GFP_USER is not legal flag either. So it
> > is better to WARN here for everything that is not allowed.
> 
> So __GFP_COMP is actually problematic and changes behavior, and I plan
> to lift an optimization from the arm code to the generic one that
> only rounds up allocations to the next page size instead of the next
> power of two, so I need this check now.  Other flags including
> GFP_USER are pretty bogus to, but I actually need to do a full audit
> before rejecting them, which I've only done for GFP_COMP so far.

ok, let's do it later.

Thanks
