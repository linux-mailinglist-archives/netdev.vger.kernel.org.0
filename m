Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951616749EE
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 04:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjATDRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 22:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjATDRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 22:17:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CF6B1ECB;
        Thu, 19 Jan 2023 19:17:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F181961DF5;
        Fri, 20 Jan 2023 03:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EE5C433F1;
        Fri, 20 Jan 2023 03:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674184656;
        bh=uU3oYI54L8VUNcIszGsQrFwwcTkBniJmQ4MJV8jgxeU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X3IJSsoJlyArYgPxfFji8JJ141V1EnCDTsHj9ob0eTDDZV0plBOD289ABFprkPp2B
         AOPSuN8cf9XjiRx2B7m0rbBnfdY1zVSBAqImK4HcrYZ3nD71tMO7/IrjZwt1foHMH9
         XT35k/MAw3kgcM6jQUZDW628l8GyrtxPY4FuURpp1+ovx2k6bqF4494bpV8kqeeZ3n
         qKFT9XD6KolBzJJtZM1Qoq+JU8bVOddZRgFb0n8FoLX1vKj9D6qWG7+HEA/mc05KIt
         x4ICHCaEUBvtbM5KHlVNRXvETKVMJBbac76tNDpJW5seXBx3XyqF30XgS2MvFct1rx
         ZQjWWK3/GmIpw==
Date:   Thu, 19 Jan 2023 19:17:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/9] e1000e: Remove redundant
 pci_enable_pcie_error_reporting()
Message-ID: <20230119191735.4bc11fd2@kernel.org>
In-Reply-To: <20230118234612.272916-3-helgaas@kernel.org>
References: <20230118234612.272916-1-helgaas@kernel.org>
        <20230118234612.272916-3-helgaas@kernel.org>
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

On Wed, 18 Jan 2023 17:46:05 -0600 Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> pci_enable_pcie_error_reporting() enables the device to send ERR_*
> Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
> native"), the PCI core does this for all devices during enumeration.
> 
> Remove the redundant pci_enable_pcie_error_reporting() call from the
> driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
> from the driver .remove() path.
> 
> Note that this doesn't control interrupt generation by the Root Port; that
> is controlled by the AER Root Error Command register, which is managed by
> the AER service driver.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

How would you like to route these? Looks like there's no dependency 
so we can pick them up?
