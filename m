Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8CB47C7DB
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhLUT5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:57:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37658 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhLUT5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 14:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=M6GQQSoou9wx1PLwO/7iYkiggtnIuAYSud1JJu0+GsA=; b=X4ho5LUGKtw2pTjciUNpUDHLP8
        m3DpNTrkyhGrwwx3fMppalh0RIRvCOJE1dCmPLWjjjch9owGc0EfROBQvVAE6pySHk2rS0wao2BFc
        uVSiuhVgIpjiLeYvnalLJ+k/7g/Jl2oLjE6QoBGzBAEchV1hwlFsOvbKTRcMlgBS9Ed8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzlGS-00HACg-23; Tue, 21 Dec 2021 20:57:36 +0100
Date:   Tue, 21 Dec 2021 20:57:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "Chen, Mike Ximing" <mike.ximing.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
Message-ID: <YcIxsCi/SNDp73dj@lunn.ch>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <YcF9rRTVzrbCyOtq@kroah.com>
 <CO1PR11MB51700037C8A23B19C0DCF5CAD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <YcHlQH0gXTHh4cjV@kroah.com>
 <CAPcyv4hoo=qBLC9d_VYHwCErE5ngsONgQPa45-K4c-GVfFJhsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hoo=qBLC9d_VYHwCErE5ngsONgQPa45-K4c-GVfFJhsw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hey Greg,
> 
> This is my fault.
> 
> To date Mike has been patiently and diligently following my review
> feedback to continue to make the driver smaller and more Linux
> idiomatic. Primarily this has been ripping and replacing a pile of
> object configuration ioctls with configfs. While my confidence in that
> review feedback was high, my confidence in the current round of deeper
> architecture reworks is lower and they seemed to raise questions that
> are likely FAQs with using configfs. Specifically the observation that
> configfs, like sysfs, lacks an "atomically update multiple attributes"
> capability. To my knowledge that's just the expected tradeoff with
> pseudo-fs based configuration and it is up to userspace to coordinate
> multiple configuration writers.

Hi Dan

If this is considered a network accelerator, it probably should use
the same configuration mechanisms all of networking uses, netlink. I'm
not aware of anything network related using configfs, but it could
exist. netlink messages should also solve your atomisity problem.

But it does not really help with cleanup when the userspace user goes
away. Is there anything from GPU drivers which can be reused? They
must have some sort of cleanup when the user space DRM driver exits.

     Andrew
