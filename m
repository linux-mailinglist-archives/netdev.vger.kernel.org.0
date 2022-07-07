Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FC556A74C
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 17:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiGGPzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 11:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiGGPzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 11:55:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B9B1F621;
        Thu,  7 Jul 2022 08:55:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FD57623AC;
        Thu,  7 Jul 2022 15:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDC9C3411E;
        Thu,  7 Jul 2022 15:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657209302;
        bh=MH13anBIQAlg7iuL9TMZMMak6LuWoaKYU6GCL/VxllM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=TklWbEmb0IG0ubepaaNE7fPRnsa3sXenPkN5azIZI5FwLByDHwIJw9Gw0B6IvR8iI
         IFr/icbokCzhR8gBu7/n5IawiMNB3Gcqqb3gcAyO623fiPgsp3KBxtfxsN3E+fUWuP
         agvAELktyYfZrNrV69aOtjG9kzl7SoEZlQPZK6v3fP0J6kz9xpfpoKyW9Z499c6euC
         kJNZPdnP92xFzXj1a/p81ciX64dCN9mzkONdbdDQu4pNKM8iehrKOdu6J34WlCdZlt
         05oe5NdKYsdR7KaKWMOtcu607eY/VZWOjkP0qKTbWFd089sahetVAcaL0XdSIUWUI6
         6Hk1cTmu26Frw==
Date:   Thu, 7 Jul 2022 10:55:00 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/2] sfc: Add EF100 BAR config support
Message-ID: <20220707155500.GA305857@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165719918216.28149.7678451615870416505.stgit@palantir17.mph.net>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 02:07:07PM +0100, Martin Habets wrote:
> The EF100 NICs allow for different register layouts of a PCI memory BAR.
> This series provides the framework to switch this layout at runtime.
> 
> Subsequent patch series will use this to add support for vDPA.

Normally drivers rely on the PCI Vendor and Device ID to learn the
number of BARs and their layouts.  I guess this series implies that
doesn't work on this device?  And the user needs to manually specify
what kind of device this is?

I'm confused about how this is supposed to work.  What if the driver
is built-in and claims a device before the user can specify the
register layout?  What if the user specifies the wrong layout and the
driver writes to the wrong registers?

> ---
> 
> Martin Habets (2):
>       sfc: Add EF100 BAR config support
>       sfc: Implement change of BAR configuration
> 
> 
>  drivers/net/ethernet/sfc/ef100_nic.c |   80 ++++++++++++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/ef100_nic.h |    6 +++
>  2 files changed, 86 insertions(+)
> 
> --
> Martin Habets <habetsm.xilinx@gmail.com>
> 
> 
