Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638772A86DA
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbgKETPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:15:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgKETPQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 14:15:16 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 106D020867;
        Thu,  5 Nov 2020 19:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604603714;
        bh=iJUcvyLtqYo46zqJm17UM4SRoIEuiLQJx79iJDMZnt8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qaHgMwqNuEp4+Hm3j2EDnaJFy9WmsTpV46YCHSZTKes3X7r0TRyiY2UGkPKK/fdxX
         gP10JYURyZbL6mQZuuT4u8Cc39KG46kPi6BRHRV855f5jVue3Wu5pIKGP4/UyJHMor
         QOV7dODWb6AEgFZXtqyfWiCqGbGiRrNm3u3gNdUw=
Message-ID: <1dd085b9f7013e9a28057f3080ee7b920bfbc9fc.camel@kernel.org>
Subject: Re: [PATCH v2 net-next 3/3] octeontx2-af: Add devlink health
 reporters for NIX
From:   Saeed Mahameed <saeed@kernel.org>
To:     George Cherian <gcherian@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Date:   Thu, 05 Nov 2020 11:15:12 -0800
In-Reply-To: <BYAPR18MB2679EC3507BD90B93B37A3F8C5EE0@BYAPR18MB2679.namprd18.prod.outlook.com>
References: <BYAPR18MB2679EC3507BD90B93B37A3F8C5EE0@BYAPR18MB2679.namprd18.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-05 at 13:36 +0000, George Cherian wrote:
> Hi Saeed,
> 
> Thanks for the review.
> 
> > -----Original Message-----
> > From: Saeed Mahameed <saeed@kernel.org>
> > Sent: Thursday, November 5, 2020 10:39 AM
> > To: George Cherian <gcherian@marvell.com>; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Jiri Pirko <jiri@nvidia.com>
> > Cc: kuba@kernel.org; davem@davemloft.net; Sunil Kovvuri Goutham
> > <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
> > Geethasowjanya Akula <gakula@marvell.com>; masahiroy@kernel.org;
> > willemdebruijn.kernel@gmail.com
> > Subject: Re: [PATCH v2 net-next 3/3] octeontx2-af: Add devlink
> > health
> > reporters for NIX
> > 
> > On Wed, 2020-11-04 at 17:57 +0530, George Cherian wrote:
> > > Add health reporters for RVU NPA block.
> >                                ^^^ NIX ?
> > 
> Yes, it's NIX.
> 
> > Cc: Jiri
> > 
> > Anyway, could you please spare some words on what is NPA and what
> > is
> > NIX?
> > 
> > Regarding the reporters names, all drivers register well known
> > generic names
> > such as (fw,hw,rx,tx), I don't know if it is a good idea to use
> > vendor specific
> > names, if you are reporting for hw/fw units then just use "hw" or
> > "fw" as the
> > reporter name and append the unit NPA/NIX to the counter/error
> > names.
> Okay. These are hw units, I will rename them as hw_npa/hw_nix.

What i meant is have one reporter named "hw" and inside it report
counters with their unit name appended to the counter name.

./devlink health
  pci/0002:01:00.0:
    reporter hw
      state healthy error 0 recover 0
      
./devlink  health dump show pci/0002:01:00.0 reporter hw
      NIX:
         nix_counter_a: 0
         ...
     NPA: 
         npa_counter_a: 0
         ...



> > > Only reporter dump is supported.
> > > 
> > > Output:
> > >  # ./devlink health
> > >  pci/0002:01:00.0:
> > >    reporter npa
> > >      state healthy error 0 recover 0
> > >    reporter nix
> > >      state healthy error 0 recover 0
> > >  # ./devlink  health dump show pci/0002:01:00.0 reporter nix
> > >   NIX_AF_GENERAL:
> > >          Memory Fault on NIX_AQ_INST_S read: 0
> > >          Memory Fault on NIX_AQ_RES_S write: 0
> > >          AQ Doorbell error: 0
> > >          Rx on unmapped PF_FUNC: 0
> > >          Rx multicast replication error: 0
> > >          Memory fault on NIX_RX_MCE_S read: 0
> > >          Memory fault on multicast WQE read: 0
> > >          Memory fault on mirror WQE read: 0
> > >          Memory fault on mirror pkt write: 0
> > >          Memory fault on multicast pkt write: 0
> > >    NIX_AF_RAS:
> > >          Poisoned data on NIX_AQ_INST_S read: 0
> > >          Poisoned data on NIX_AQ_RES_S write: 0
> > >          Poisoned data on HW context read: 0
> > >          Poisoned data on packet read from mirror buffer: 0
> > >          Poisoned data on packet read from mcast buffer: 0
> > >          Poisoned data on WQE read from mirror buffer: 0
> > >          Poisoned data on WQE read from multicast buffer: 0
> > >          Poisoned data on NIX_RX_MCE_S read: 0
> > >    NIX_AF_RVU:
> > >          Unmap Slot Error: 0
> > > 
> > 
> > Now i am a little bit skeptic here, devlink health reporter
> > infrastructure was
> > never meant to deal with dump op only, the main purpose is to
> > diagnose/dump and recover.
> > 
> > especially in your use case where you only report counters, i don't
> > believe
> > devlink health dump is a proper interface for this.
> These are not counters. These are error interrupts raised by HW
> blocks.
> The count is provided to understand on how frequently the errors are
> seen.
> Error recovery for some of the blocks happen internally. That is the
> reason,
> Currently only dump op is added.

So you are counting these events in driver, sounds like a counter to
me, i really think this shouldn't belong to devlink, unless you really
utilize devlink health ops for actual reporting and recovery.

what's wrong with just dumping these counters to ethtool ?

> > Many of these counters if not most are data path packet based and
> > maybe
> > they should belong to ethtool.
> 
> Regards,
> -George
> 
> 
> 

