Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1C46454D2
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 08:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiLGHrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 02:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiLGHrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 02:47:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68123B3
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 23:47:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35D10B803F2
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569EEC433C1;
        Wed,  7 Dec 2022 07:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670399217;
        bh=+iqWEq0hyiHrQWJnPPzxH2fSBooGMExmt8vA/1oY3jY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BAVrx/+IgfHegQBrpaSyvfyAqYxbvkESj/zvkQh6mcGitmx0eN/jPVI+TMb/cbiei
         SDZ/YtrEzbEhjjr9vmMKBylmGu710rOeLkdln506/TteMimC6vSXy1HckNccRXMqxG
         uAkKA2JlV50WfP5j/5286It4zKvqcN95B2FvhWqfZac/VAKV4NB0D47aaeRKetSPXL
         Gx7jdCZFBU0cEBuykWgDAUlSW9rts/R8f3oz+JhUcfM3B3TcmEByNye47pCWpU2uuK
         gVtjBizu+r9SLGjIXPaWNJtpOccgOUa5CkobE5jPTLoC5+C50nWYjfz6KjLhCKB0Oh
         fLZXGwMDvOmkA==
Date:   Wed, 7 Dec 2022 09:46:53 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        sasha.neftin@intel.com, muhammad.husaini.zulkifli@intel.com
Subject: Re: [PATCH net-next 0/8][pull request] Intel Wired LAN Driver
 Updates 2022-12-05 (igc)
Message-ID: <Y5BE7f9sSzjqiHf2@unreal>
References: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 01:24:06PM -0800, Tony Nguyen wrote:
> Muhammad Husaini Zulkifli says:
> 
> This patch series improves the Time-Sensitive Networking(TSN) Qbv Scheduling
> features. I225 stepping had some hardware restrictions; I226 enables us to
> further enhance the driver code and offer more Qbv capabilities.

<...>

> Muhammad Husaini Zulkifli (2):
>   igc: remove I226 Qbv BaseTime restriction
>   igc: Add checking for basetime less than zero
> 
> Tan Tee Min (4):
>   igc: allow BaseTime 0 enrollment for Qbv
>   igc: recalculate Qbv end_time by considering cycle time
>   igc: enable Qbv configuration for 2nd GCL
>   igc: Set Qbv start_time and end_time to end_time if not being
>     configured in GCL
> 
> Vinicius Costa Gomes (2):
>   igc: Use strict cycles for Qbv scheduling
>   igc: Enhance Qbv scheduling by using first flag bit
> 
>  drivers/net/ethernet/intel/igc/igc.h         |   3 +
>  drivers/net/ethernet/intel/igc/igc_base.c    |  29 +++
>  drivers/net/ethernet/intel/igc/igc_base.h    |   2 +
>  drivers/net/ethernet/intel/igc/igc_defines.h |   3 +
>  drivers/net/ethernet/intel/igc/igc_main.c    | 224 ++++++++++++++++---
>  drivers/net/ethernet/intel/igc/igc_tsn.c     |  66 +++---
>  drivers/net/ethernet/intel/igc/igc_tsn.h     |   2 +-
>  7 files changed, 266 insertions(+), 63 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
