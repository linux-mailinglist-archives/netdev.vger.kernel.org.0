Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8202962CAA3
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiKPUUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiKPUU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:20:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF98391EA
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:20:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E654B81B92
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 20:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F0BC433D6;
        Wed, 16 Nov 2022 20:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668630025;
        bh=XdyjoXR8luiMRvnyi45h3tL4MewegJVoPlTvCD/WybM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gs2dlI/7GKbZshWDx9BZ7TevPFTxTgs/FJRSezPJ4drThzSDv6U0eIdoN2vIjUJV3
         dfHdaZqYArzjvuAWHH6Bjjd0cKrfn1/ZhlqUXO5M+o/M1M5Kfq/AgVfiIyJP4RZZpH
         MhCwpo5KQaHmshZY2luiq0xQL9FkoX4GH9I+Aa8hVvWM/PG46F/APYAz+GYH7uHT5j
         hKINB45L1lHk4YnfroDTKEG9ERFfrM5EMvghsHEUXRk6UTf70/FnAbPOXkZVk8IFKg
         BcIVbkVLnA8XZunMQRZqVAa2+jtFB1v3j/wpyVv0Lsi+td8UnX43nDTbmv0YdhPEb/
         6xu0d5PHm2RIA==
Date:   Wed, 16 Nov 2022 12:20:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH net-next] mlxsw: update adjfine to use
 adjust_by_scaled_ppm
Message-ID: <20221116122023.170981ff@kernel.org>
In-Reply-To: <Y3SYzkIJYjBpViNn@shredder>
References: <20221114213701.815132-1-jacob.e.keller@intel.com>
        <Y3SYzkIJYjBpViNn@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Nov 2022 10:01:18 +0200 Ido Schimmel wrote:
> On Mon, Nov 14, 2022 at 01:37:01PM -0800, Jacob Keller wrote:
> > The mlxsw adjfine implementation in the spectrum_ptp.c file converts
> > scaled_ppm into ppb before updating a cyclecounter multiplier using the
> > standard "base * ppb / 1billion" calculation.
> > 
> > This can be re-written to use adjust_by_scaled_ppm, directly using the
> > scaled parts per million and reducing the amount of code required to
> > express this calculation.
> > 
> > We still calculate the parts per billion for passing into
> > mlxsw_sp_ptp_phc_adjfreq because this function requires the input to be in
> > parts per billion.
> > 
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>  
> 
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>

FTR this patch got marked as 'not applicable' in pw but I'm not sure
why, so applying...
