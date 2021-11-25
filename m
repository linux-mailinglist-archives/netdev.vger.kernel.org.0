Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E982245DE2C
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356317AbhKYQCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 11:02:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356173AbhKYQAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 11:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72543610E8;
        Thu, 25 Nov 2021 15:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637855822;
        bh=gEVDxltRAxYiIRklpQ8ImHcxU1Gs8TwGUu+BAQtDvMQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J/nRGHvF24FNH0nyUZOxbytVZpXfkKCJwWqAfPhVr2nauQxymiX7Uc986iOngY7rd
         9y/bHhRiRbVzBR418K/odVqYzZ+yeWkNlZOWeMwcoLzhP9TbTpzPcMjcSr+Zrz5NxX
         lzCPEyXgI2H6RQafUkjedxFxgB+8STe2Eg9mV3cpq8J1QQpazLMExLpqMwpJ9l9QGF
         anlnQYpDyz7QOLsusxNNMMsweNdxxtGjub7ne47NgftXVhYxxQ0O7idr82Pa31YCUc
         VKLZqOa4Lrer8vKQWTIdiFUVtf8jc+CvelaGZSkRpc1pm+kj22Nv619XvtFwLXQ/Af
         8g0WcJSaSRpHg==
Date:   Thu, 25 Nov 2021 07:57:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Assmann <sassmann@redhat.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 06/12] iavf: Add trace while removing device
Message-ID: <20211125075701.7b67ae7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125154349.ozf6jfq5kmzoou4j@x230>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
        <20211124171652.831184-7-anthony.l.nguyen@intel.com>
        <20211124154811.6d9c48cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211125065049.hwubag5eherksrle@x230>
        <20211125071316.69c3319a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211125154349.ozf6jfq5kmzoou4j@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 16:43:49 +0100 Stefan Assmann wrote:
> On 2021-11-25 07:13, Jakub Kicinski wrote:
> > On Thu, 25 Nov 2021 07:50:49 +0100 Stefan Assmann wrote:  
> > > From personal experience I'd say this piece of information has value,
> > > especially when debugging it can be interesting to know exactly when
> > > the driver was removed.  
> > 
> > But there isn't anything specific to iavf here, right? If it really 
> > is important then core should be doing the printing for all drivers.
> > 
> > Actually, I can't come up with any uses for this print on the spot.
> > What debugging scenarios do you have in mind?  
> 
> There was a lot of trouble with iavf in terms of device reset, device
> unbinding (DPDK), stress testing of driver load/unload issues. When
> looking through the crash logs it was not always easy to determine if
> the driver was still loaded.
> Especially on problems that weren't easy to reproduce.

That's a slippery slope, historically we were always pushing for
avoiding informational prints. Otherwise every driver reconfig would
result in a line in the logs.

> So for iavf having that information would have been valuable. Not sure
> if that justifies a PCI core message or if others might find that too
> verbose.

So what you're saying is from your experience iavf is of significantly
poorer quality than other vendors' drivers?
