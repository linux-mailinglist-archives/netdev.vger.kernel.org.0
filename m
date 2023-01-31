Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33ED2682653
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 09:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjAaI02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 03:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjAaI00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 03:26:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3311D42DE5
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 00:26:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96E90613B3
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E857C433D2;
        Tue, 31 Jan 2023 08:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675153579;
        bh=Rr06LWBaEnl40tq45B+s1i72rCZJEuZ9ofFa4YVr9G4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NSBwnZRZ/XOgqr3kULdTtD4KhKdBXnwcTArRIIAkDvcJRk1oa7vtU3RNIzvsenML2
         kJPqoOa6J2WCR0AyuJpgIpDIGDHBRcMF+rSvRA5kT4cwdvIo00Su94IBE3xuETjD+y
         Gse2wPvrcygRfH9yvMJUDonIGy3ZApx38DK5/EAKfT/pYEinOYXl782ZsJCbSiqt2X
         SCmcNLQfNtazxecHDKTKkQRLTIGlJm7+B0uj4AXcNaSzkTKMc/aArINi8+RA50cx61
         MJPCCbuHCqaR3IpHuTRsOT9C4A2wJ7srHeCq1PoeltK0/J/qjSaEYNrSKSu4xXVwjK
         mOYqhB7TSOFhw==
Date:   Tue, 31 Jan 2023 10:26:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH net-next 0/8][pull request] Intel Wired LAN: Remove
 redundant Device Control Error Reporting Enable
Message-ID: <Y9jQpjLPkRR/emeH@unreal>
References: <20230130192519.686446-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230130192519.686446-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:25:11AM -0800, Tony Nguyen wrote:
> Bjorn Helgaas says:
> 
> Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native"),
> the PCI core sets the Device Control bits that enable error reporting for
> PCIe devices.
> 
> This series removes redundant calls to pci_enable_pcie_error_reporting()
> that do the same thing from several NIC drivers.
> 
> There are several more drivers where this should be removed; I started with
> just the Intel drivers here.
> ---
> TN: Removed mention of AER driver as this was taken through PCI tree [1]
> and fixed a typo.
> 
> [1] https://lore.kernel.org/all/20230126231527.GA1322015@bhelgaas/
> 
> The following are changes since commit 90e8ca0abb05ada6c1e2710eaa21688dafca26f2:
>   Merge branch 'devlink-next'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE
> 
> Bjorn Helgaas (8):
>   e1000e: Remove redundant pci_enable_pcie_error_reporting()
>   fm10k: Remove redundant pci_enable_pcie_error_reporting()
>   i40e: Remove redundant pci_enable_pcie_error_reporting()
>   iavf: Remove redundant pci_enable_pcie_error_reporting()
>   ice: Remove redundant pci_enable_pcie_error_reporting()
>   igb: Remove redundant pci_enable_pcie_error_reporting()
>   igc: Remove redundant pci_enable_pcie_error_reporting()
>   ixgbe: Remove redundant pci_enable_pcie_error_reporting()
> 
>  drivers/net/ethernet/intel/e1000e/netdev.c    | 7 -------
>  drivers/net/ethernet/intel/fm10k/fm10k_pci.c  | 5 -----
>  drivers/net/ethernet/intel/i40e/i40e_main.c   | 4 ----
>  drivers/net/ethernet/intel/iavf/iavf_main.c   | 5 -----
>  drivers/net/ethernet/intel/ice/ice_main.c     | 3 ---
>  drivers/net/ethernet/intel/igb/igb_main.c     | 5 -----
>  drivers/net/ethernet/intel/igc/igc_main.c     | 5 -----
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 -----
>  8 files changed, 39 deletions(-)

I see that you didn't touch any other places except drivers/net/ethernet/intel/.
Are you planning to remove other occurrences too?

➜  kernel git:(rdma-next) git grep pci_enable_pcie_error_reporting -- drivers/infiniband/
drivers/infiniband/hw/hfi1/pcie.c:      (void)pci_enable_pcie_error_reporting(pdev);
drivers/infiniband/hw/qib/qib_pcie.c:   ret = pci_enable_pcie_error_reporting(pdev);

Thanks

> 
> -- 
> 2.38.1
> 
