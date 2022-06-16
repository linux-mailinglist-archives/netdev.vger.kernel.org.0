Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6127C54EB2C
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 22:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378675AbiFPU3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 16:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378669AbiFPU3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 16:29:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B675C76B
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 13:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B017C61DF1
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 20:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09847C34114;
        Thu, 16 Jun 2022 20:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655411349;
        bh=4o/AkFEVN4CjF7uvMhQxgPGkENzdJzD2lcDZb7ueP9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MYkyqK+ieYXIJ6aLeeFilFRXvBOqgp8tVRY0lBXPeFUN3Sb73DHxyT2WR7yE/cDvj
         6F5yZxmYBi1F5uoG0q1D6pFjizW2WhpZTclHEQoqs/3xTIKn4DbPvHxLohxF3Bhvi1
         I/VZ/1XT8suoUXVveDudaTgapHwIkH36vGtjaa9ZoH6LAGIrzQn4wkm7hP0MFt06wA
         KVU9wrXlwA7LucfVk/VAkmJ8EQyVs09XX7Xd6NbQZqxArP+mTYu+ASVg0toaozc7jP
         C33IMAEsJWeI8IOIjzD7Vi9anrV/3ZMBCkpOsfGaU1y/VCGWy/mRIB8Y1Y3GIX+gL4
         pnh3IKKRX77KQ==
Date:   Thu, 16 Jun 2022 13:29:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: txgbe: Add build support for txgbe
Message-ID: <20220616132908.789b9be4@kernel.org>
In-Reply-To: <YquDYCltyKfEjA93@lunn.ch>
References: <20220616095308.470320-1-jiawenwu@trustnetic.com>
        <YquDYCltyKfEjA93@lunn.ch>
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

On Thu, 16 Jun 2022 21:24:16 +0200 Andrew Lunn wrote:
> > +err_ioremap:
> > +err_alloc_etherdev:
> > +	pci_release_selected_regions(pdev,
> > +				     pci_select_bars(pdev, IORESOURCE_MEM));
> > +err_pci_reg:
> > +err_dma:
> > +	pci_disable_device(pdev);
> > +	return err;
> > +}  
> 
> It is unusual to have a label without any code. I would suggest you
> remove err_ioramp and err_pce_reg.

IMO it's easier to read the code when the label is named after what it
points to, not where it comes from. The were it comes from information
is rather meaningless. One has to always check both source and
destination to check that the code is correct.

If the label is named after what it jumps to it's possible to validate
that the code is jumping to the correct unroll stage without looking at
the actual error path.
