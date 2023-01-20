Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658B867554A
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjATNO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjATNO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:14:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E507BD157;
        Fri, 20 Jan 2023 05:14:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEF4EB8280B;
        Fri, 20 Jan 2023 13:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D73C433EF;
        Fri, 20 Jan 2023 13:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674220461;
        bh=y2nkbcWRr5qEayC6d21noEl5u93nkRPbcNffzPJrZBk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=jjERjDD1RN3nq7qoHcU1vnBiVA/xlhinOqGkNB7IoWM/sMqZ6s85DrxZdNuIlvXaE
         N46d2uGkWvk9OldOpX2tbdZfv3Ujc0dkA1YLZ3BAWy/EzM3Z1RfU4FEPwYYmF2sDey
         Z24irxIinp8683wMjX0y9GNkQn9perV1SikxAdrTvO/FLZu7WdTADNlDf2GjWpJtUM
         sqsYXKy9mVOlss0WOwVvpWtV0+OG7VUkGHoMEq38rUl6wOVi0uGCEkPAO2/u0eatve
         ARLZrIoIur/x5zrFvCzJFbUNqblfBzQlG4pzs8G5jTHuQ9Aq5IGEs1nXSgGZ76k6nR
         6cRzghdjaIkRg==
Date:   Fri, 20 Jan 2023 07:14:19 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH 2/9] e1000e: Remove redundant
 pci_enable_pcie_error_reporting()
Message-ID: <20230120131419.GA622602@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119191735.4bc11fd2@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 07:17:35PM -0800, Jakub Kicinski wrote:
> On Wed, 18 Jan 2023 17:46:05 -0600 Bjorn Helgaas wrote:
> > From: Bjorn Helgaas <bhelgaas@google.com>
> > 
> > pci_enable_pcie_error_reporting() enables the device to send ERR_*
> > Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
> > native"), the PCI core does this for all devices during enumeration.
> > 
> > Remove the redundant pci_enable_pcie_error_reporting() call from the
> > driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
> > from the driver .remove() path.
> > 
> > Note that this doesn't control interrupt generation by the Root Port; that
> > is controlled by the AER Root Error Command register, which is managed by
> > the AER service driver.
> > 
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> How would you like to route these? Looks like there's no dependency 
> so we can pick them up?

Right, no dependencies, so you can pick them up.  Sounds like you and
Tony have it worked out.  Thanks!

Bjorn
