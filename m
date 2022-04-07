Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FC04F754B
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 07:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240867AbiDGFZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 01:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbiDGFZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 01:25:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E44127580
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 22:23:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EC5F61CB6
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 05:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75407C385A4;
        Thu,  7 Apr 2022 05:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649309009;
        bh=+w1a8dt1fV5qlA7rILm+6yNokb4b4CK6colJr3pghe8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L6GfYE9rDrMHLwpV2u5w9TaktO1KU/tPOuXpZBj7C2rtjpUAvcl7wliDTLnXoC709
         r/zIIXRMrJCh6H4thP/85Ui02awnVIFaNmsMUUWYXyBGeB7X8yZgn5N4PoB47vSVMb
         2ka/a59xNfTsxc+wMC+s07QLG6MVtiybP3TwlYGE=
Date:   Thu, 7 Apr 2022 07:23:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH net] net: mdio: don't defer probe forever if PHY IRQ
 provider is missing
Message-ID: <Yk51TIeGfFmfusQL@kroah.com>
References: <20220406202323.3390405-1-vladimir.oltean@nxp.com>
 <20220406153443.51ad52f8@kernel.org>
 <20220406231956.nwe6kb6vgli2chln@skbuf>
 <20220406172550.6408c990@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406172550.6408c990@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 05:25:50PM -0700, Jakub Kicinski wrote:
> On Wed, 6 Apr 2022 23:19:57 +0000 Vladimir Oltean wrote:
> > On Wed, Apr 06, 2022 at 03:34:43PM -0700, Jakub Kicinski wrote:
> > > > +	if (rc == -EPROBE_DEFER)
> > > > +		rc = driver_deferred_probe_check_state(&phy->mdio.dev);
> > > This one's not exported, allmodconfig build fails.  
> > 
> > Oops, I didn't realize that all its callers except for FWNODE_MDIO are built-in.
> > 
> > Do you prefer me exporting the symbol as part of the same patch or a different one?
> 
> I presume single patch is fine, but driver_deferred_probe_check_state()
> lives in Greg's realm, so let's add Greg in case he prefers a separate
> patch or more.

separate patch that I can NAK as I do not understand why this is needed
at all :)

thanks,

greg k-h
