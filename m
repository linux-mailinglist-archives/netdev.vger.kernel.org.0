Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B055351B6A9
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241615AbiEEDtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiEEDtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:49:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB61F13F7F
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90F10B82A87
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1AEC385AC;
        Thu,  5 May 2022 03:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651722333;
        bh=idpdgTSCO7bbUIbFgd2mTno4B1Sq6cgiHn0HywdSuEE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m3ITfFRE0wsA6xae3UE9iidnYQHEcUjus8dhpOU3HigcYZHM0rBJ5On04d+wo0Px0
         XPRpPsGb34C15v9nD6Wu3vongLGxZ7GKwKE/LsLrWNXHWxNXHvC85/bzwdDQtGL6rF
         HkgSVYwdR4iixKTpK0aqpvKaNp+Cpg0bYM4ONxKcx8qBw/hriMhJtVtv1J60ytAJSC
         lRkipEiwjWkpjNBZpwiMJvkGfk9wlFuTJEuBhWe6URVlRcwtgPHtj9j4qkAYWYyvD2
         o0jnoDIocsKapZr+CAAtl4gz6HlVnujF4rrr11jobt0Y8/iF7aDf0Afst6wh8c9ldA
         aTJWBud9pMe/g==
Date:   Wed, 4 May 2022 20:45:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     edumazet@google.com, pabeni@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v3 00/13]: Move Siena into a separate
 subdirectory
Message-ID: <20220504204531.5294ed21@kernel.org>
In-Reply-To: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
References: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 May 2022 08:49:41 +0100 Martin Habets wrote:
> The Siena NICs (SFN5000 and SFN6000 series) went EOL in November 2021.
> Most of these adapters have been remove from our test labs, and testing
> has been reduced to a minimum.
> 
> This patch series creates a separate kernel module for the Siena architecture,
> analogous to what was done for Falcon some years ago.
> This reduces our maintenance for the sfc.ko module, and allows us to
> enhance the EF10 and EF100 drivers without the risk of breaking Siena NICs.
> 
> After this series further enhancements are needed to differentiate the
> new kernel module from sfc.ko, and the Siena code can be removed from sfc.ko.
> Thes will be posted as a small follow-up series.
> The Siena module is not built by default, but can be enabled
> using Kconfig option SFC_SIENA. This will create module sfc-siena.ko.
> 
> 	Patches
> 
> Patch 1 disables the Siena code in the sfc.ko module.
> Patches 2-6 establish the code base for the Siena driver.
> Patches 7-12 ensure the allyesconfig build succeeds.
> Patch 13 adds the basic Siena module.
> 
> I do not expect patch 2 through 5 to be reviewed, they are FYI only.
> No checkpatch issues were resolved as part of these, but they
> were fixed in the subsequent patches.

Still funky:

$ git pw series apply 638179
Applying: sfc: Disable Siena support
Using index info to reconstruct a base tree...
M	drivers/net/ethernet/sfc/Kconfig
M	drivers/net/ethernet/sfc/Makefile
M	drivers/net/ethernet/sfc/efx.c
M	drivers/net/ethernet/sfc/nic.h
Falling back to patching base and 3-way merge...
No changes -- Patch already applied.
Applying: sfc: Move Siena specific files
Applying: sfc: Copy shared files needed for Siena (part 1)
Applying: sfc: Copy shared files needed for Siena (part 2)
Applying: sfc: Copy a subset of mcdi_pcol.h to siena
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
No changes -- Patch already applied.
Applying: sfc/siena: Remove build references to missing functionality
Applying: sfc/siena: Rename functions in efx headers to avoid conflicts with sfc
Applying: sfc/siena: Rename RX/TX functions to avoid conflicts with sfc
Applying: sfc/siena: Rename peripheral functions to avoid conflicts with sfc
Applying: sfc/siena: Rename functions in mcdi headers to avoid conflicts with sfc
Applying: sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
Applying: sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
Applying: sfc: Add a basic Siena module
