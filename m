Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F5D337F25
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhCKUhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:37:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:45264 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230047AbhCKUhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:37:23 -0500
IronPort-SDR: mMjj2mC3vECt38FFjIotj2y+czYJ1H0c9+y5sC0kEwkMTOonfnhhavsGcFgEF5bWRBTHBY+mar
 wcaxgV6is1VA==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="185381734"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="185381734"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 12:37:22 -0800
IronPort-SDR: BqbB2zz3Nv8GXxVLf0B9QzES99iqYIWgAir+PXBwqkW1pZ5nwvYRNmsg3TfhVFh8P1NsI8fPTk
 ruF4nSkEwDDw==
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="438278581"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.251.18.194])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 12:37:21 -0800
Date:   Thu, 11 Mar 2021 12:37:21 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "netanel@amazon.com" <netanel@amazon.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "saeedb@amazon.com" <saeedb@amazon.com>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "skalluru@marvell.com" <skalluru@marvell.com>,
        "rmody@marvell.com" <rmody@marvell.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "doshir@vmware.com" <doshir@vmware.com>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>
Subject: Re: [RFC PATCH 01/10] ethtool: Add common function for filling out
 strings
Message-ID: <20210311123721.00005913@intel.com>
In-Reply-To: <20210310180807.5fb1752d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
        <161542651749.13546.3959589547085613076.stgit@localhost.localdomain>
        <20210310180807.5fb1752d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:

> On Wed, 10 Mar 2021 17:35:17 -0800 Alexander Duyck wrote:
> > From: Alexander Duyck <alexanderduyck@fb.com>
> > +/**
> > + * ethtool_gsprintf - Write formatted string to ethtool string data
> > + * @data: Pointer to start of string to update
> > + * @fmt: Format of string to write
> > + *
> > + * Write formatted string to data. Update data to point at start of
> > + * next string.
> > + */
> > +extern __printf(2, 3) void ethtool_gsprintf(u8 **data, const char *fmt, ...);
> 
> I'd drop the 'g' TBH, it seems to have made its way from the ethtool
> command ('gstrings') to various places but without the 'string' after
> it - it becomes less and less meaningful. Just ethtool_sprintf() would
> be fine IMHO.
> 
> Other than that there is a minor rev xmas tree violation in patch 2 :)


I agree with Jakub, and I really like this series, it's a good clean up.

I'll be glad to add a reviewed by tag to v2.

