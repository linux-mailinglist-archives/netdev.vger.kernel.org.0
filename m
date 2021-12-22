Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C5947CDC9
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 09:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243165AbhLVIBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 03:01:06 -0500
Received: from verein.lst.de ([213.95.11.211]:49536 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243161AbhLVIBF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 03:01:05 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id EE38368AFE; Wed, 22 Dec 2021 09:01:01 +0100 (CET)
Date:   Wed, 22 Dec 2021 09:01:01 +0100
From:   Christoph Hellwig <hch@lst.de>
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
Message-ID: <20211222080101.GA21077@lst.de>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com> <YcF9rRTVzrbCyOtq@kroah.com> <CO1PR11MB51700037C8A23B19C0DCF5CAD97C9@CO1PR11MB5170.namprd11.prod.outlook.com> <YcHlQH0gXTHh4cjV@kroah.com> <CAPcyv4hoo=qBLC9d_VYHwCErE5ngsONgQPa45-K4c-GVfFJhsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hoo=qBLC9d_VYHwCErE5ngsONgQPa45-K4c-GVfFJhsw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 10:44:11AM -0800, Dan Williams wrote:
> are likely FAQs with using configfs. Specifically the observation that
> configfs, like sysfs, lacks an "atomically update multiple attributes"
> capability. To my knowledge that's just the expected tradeoff with
> pseudo-fs based configuration and it is up to userspace to coordinate
> multiple configuration writers.

Yes.  For the SCSI and nvme targets we do a required attributes must
be set before something can be enabled, but that might not work
everywhere.

> The other question is the use of anon_inode_getfd(). To me that
> mechanism is reserved for syscall and ioctl based architectures, and

It is.

> in this case it was only being used as a mechanism to get an automatic
> teardown action at process exit. Again, my inclination is that configs
> requires userspace to clean up anything it created. If "tear down on
> last close" behavior is needed that would either need to come from a
> userspace daemon to watch clients, or another character device that
> clients could open to represent the active users of the configuration.
> My preference is for the former.

This really sounds like configfs is the wrong interface.  But I'd have
to find time to see what dlb actually is before commenting on what might
be a better interface.
