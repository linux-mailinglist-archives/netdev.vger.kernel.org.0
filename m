Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093172A9EC6
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgKFU62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:58:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbgKFU62 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 15:58:28 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D521B20B1F;
        Fri,  6 Nov 2020 20:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604696307;
        bh=Qs7s5PkEVmcdFdJtVbfQaSH2HwSKtixNCGABo8gZLzs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=1dqdahWq+6ZNk3JsBrpONfOl6UrsPPEYH3unW+weooG8ff3Jrasf9jFVwDGZPdxlk
         Vnn5VWmgHeGv+JUNIateSldplxtFpDXASFS/9r2imGmFS/0aVeOxtmgBZu6GjreXYd
         HbWzgLebNjS/BHoajFR/rI6ImeVW8eobS9zm4SLY=
Message-ID: <f1266f7f732d5222b69b8c29ec1d8071f9f16b25.camel@kernel.org>
Subject: Re: [PATCH v2 net-next 3/3] octeontx2-af: Add devlink health
 reporters for NIX
From:   Saeed Mahameed <saeed@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     George Cherian <gcherian@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Date:   Fri, 06 Nov 2020 12:58:25 -0800
In-Reply-To: <CA+sq2Cc9-vvF8K_FASca5FGYyFc_53QWqyEtoHAx6xVCs41LiQ@mail.gmail.com>
References: <BYAPR18MB2679EC3507BD90B93B37A3F8C5EE0@BYAPR18MB2679.namprd18.prod.outlook.com>
         <1dd085b9f7013e9a28057f3080ee7b920bfbc9fc.camel@kernel.org>
         <CA+sq2Cc9-vvF8K_FASca5FGYyFc_53QWqyEtoHAx6xVCs41LiQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-06 at 00:59 +0530, Sunil Kovvuri wrote:
> > > > > Output:
> > > > >  # ./devlink health
> > > > >  pci/0002:01:00.0:
> > > > >    reporter npa
> > > > >      state healthy error 0 recover 0
> > > > >    reporter nix
> > > > >      state healthy error 0 recover 0
> > > > >  # ./devlink  health dump show pci/0002:01:00.0 reporter nix
> > > > >   NIX_AF_GENERAL:
> > > > >          Memory Fault on NIX_AQ_INST_S read: 0
> > > > >          Memory Fault on NIX_AQ_RES_S write: 0
> > > > >          AQ Doorbell error: 0
> > > > >          Rx on unmapped PF_FUNC: 0
> > > > >          Rx multicast replication error: 0
> > > > >          Memory fault on NIX_RX_MCE_S read: 0
> > > > >          Memory fault on multicast WQE read: 0
> > > > >          Memory fault on mirror WQE read: 0
> > > > >          Memory fault on mirror pkt write: 0
> > > > >          Memory fault on multicast pkt write: 0
> > > > >    NIX_AF_RAS:
> > > > >          Poisoned data on NIX_AQ_INST_S read: 0
> > > > >          Poisoned data on NIX_AQ_RES_S write: 0
> > > > >          Poisoned data on HW context read: 0
> > > > >          Poisoned data on packet read from mirror buffer: 0
> > > > >          Poisoned data on packet read from mcast buffer: 0
> > > > >          Poisoned data on WQE read from mirror buffer: 0
> > > > >          Poisoned data on WQE read from multicast buffer: 0
> > > > >          Poisoned data on NIX_RX_MCE_S read: 0
> > > > >    NIX_AF_RVU:
> > > > >          Unmap Slot Error: 0
> > > > > 
> > > > 
> > > > Now i am a little bit skeptic here, devlink health reporter
> > > > infrastructure was
> > > > never meant to deal with dump op only, the main purpose is to
> > > > diagnose/dump and recover.
> > > > 
> > > > especially in your use case where you only report counters, i
> > > > don't
> > > > believe
> > > > devlink health dump is a proper interface for this.
> > > These are not counters. These are error interrupts raised by HW
> > > blocks.
> > > The count is provided to understand on how frequently the errors
> > > are
> > > seen.
> > > Error recovery for some of the blocks happen internally. That is
> > > the
> > > reason,
> > > Currently only dump op is added.
> > 
> > So you are counting these events in driver, sounds like a counter
> > to
> > me, i really think this shouldn't belong to devlink, unless you
> > really
> > utilize devlink health ops for actual reporting and recovery.
> > 
> > what's wrong with just dumping these counters to ethtool ?
> 
> This driver is a administrative driver which handles all the
> resources
> in the system and doesn't do any IO.
> NIX and NPA are key co-processor blocks which this driver handles.
> With NIX and NPA, there are pieces
> which gets attached to a PCI device to make it a networking device.
> We
> have netdev drivers registered to this
> networking device. Some more information about the drivers is
> available at
> https://www.kernel.org/doc/html/latest/networking/device_drivers/ethernet/marvell/octeontx2.html
> 
> So we don't have a netdev here to report these co-processor block
> level errors over ethtool.
> 

but AF driver can't be standalone to operate your hw, it must have a
PF/VF with netdev interface to do io, so even if your model is modular,
a common user of this driver will always see a netdev.


