Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364F268EE4C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjBHLx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBHLxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:53:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A0B3FF28
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:53:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 046A561645
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 11:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979DCC433EF;
        Wed,  8 Feb 2023 11:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675857233;
        bh=rpmQdY7JoJlyrDvEnmPfVpVEPc6Fxz7By1saEeoFgeE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gMOA5wo0pF8Jxx/5yhcXFoBSQi/6IovbBtNEgFiUf+u0SHVyR8diIOCE87AaJGDuR
         OdzUXKKyPwCLMF2Te6kPAM3set51OuUfA+irCGLkZCnVmQJui3uKHvoSgGUQDPq0qW
         Rqas5XBMzAaQZ/J6tVrlT532ZulhJJw3AwFzNvGMQLzstUQcC2bFvHgU/hS0JXVmHh
         2KcODpJdiVX6wDqiY2CimvCKCdW8jlzwk+x6nqhUNcmJGDw7OSgN2+5VSw9OaDZaGK
         Ceeug64MXtXR+9LnkBGfGnmO2LMmaRt36tMHgESmgUqzgnsQ17PaKyvXtdCF6wXyF0
         wqbG06X33pnXg==
Date:   Wed, 8 Feb 2023 13:53:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+ONTC6q0pqZl3/I@unreal>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org>
 <Y+OFspnA69XxCnpI@unreal>
 <Y+OJVW8f/vL9redb@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+OJVW8f/vL9redb@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 12:36:53PM +0100, Simon Horman wrote:
> On Wed, Feb 08, 2023 at 01:21:22PM +0200, Leon Romanovsky wrote:
> > On Mon, Feb 06, 2023 at 06:42:27PM -0800, Jakub Kicinski wrote:
> > > On Mon,  6 Feb 2023 16:36:02 +0100 Simon Horman wrote:
> > > > +VF assignment setup
> > > > +---------------------------
> > > > +In some cases, NICs could have multiple physical ports per PF. Users can assign VFs to
> > > > +different ports.
> > > 
> > > Please make sure you run make htmldocs when changing docs,
> > > this will warn.
> > > 
> > > > +- Get count of VFs assigned to physical port::
> > > > +
> > > > +    $ devlink port show pci/0000:82:00.0/0
> > > > +    pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical port 0 splittable true lanes 4
> > > 
> > > Physical port has VFs? My knee jerk reaction is that allocating
> > > resources via devlink is fine but this seems to lean a bit into
> > > forwarding. How do other vendors do it? What's the mapping of VFs
> > > to ports?
> > 
> > I don't understand the meaning of VFs here. If we are talking about PCI
> > VFs, other vendors follow PCI spec "9.3.3.3.1 VF Enable" section, which
> > talks about having one bit to enable all VFs at once. All these VFs will
> > have separate netdevs.
> 
> Yes, that is the case here too (before and after).
> 
> What we are talking about is the association of VFs to physical ports
> (in the case where a NIC has more than one physical port).

We have devices with multiple ports too, but don't have such issues.
So it will help if you can provide more context here.

I'm failing to see connection between physical ports and physical VFs.

Are you saying that physical ports are actual PCI VFs, which spans L2 VFs,
which you want to assign to another port (PF)?

Thanks
