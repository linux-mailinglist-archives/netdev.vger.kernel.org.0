Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0651F2A2326
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 03:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgKBCni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 21:43:38 -0500
Received: from mga04.intel.com ([192.55.52.120]:51322 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727450AbgKBCni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 21:43:38 -0500
IronPort-SDR: bYx3XcfmK0ZNstbAk5hL2ukxJxHGGu/jUeGns9VBHceeZowr3D97XsFgO65Z/vjUJm63qhouPW
 uFW/Qi5ySrAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9792"; a="166236334"
X-IronPort-AV: E=Sophos;i="5.77,443,1596524400"; 
   d="scan'208";a="166236334"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2020 18:43:38 -0800
IronPort-SDR: ULPce4o1gTVqveAMyWhF84RLXE1LKUTUd9JBJfaPvsKciCjS4GlK1I6inejs+27DXk/Jqow3nA
 PGiJZ4EhiD6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,443,1596524400"; 
   d="scan'208";a="526535655"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.141])
  by fmsmga006.fm.intel.com with ESMTP; 01 Nov 2020 18:43:35 -0800
Date:   Mon, 2 Nov 2020 10:38:09 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com,
        yilun.xu@intel.com
Subject: Re: [RFC PATCH 1/6] docs: networking: add the document for DFL Ether
  Group driver
Message-ID: <20201102023809.GA10673@yilunxu-OptiPlex-7050>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
 <20201023153731.GC718124@lunn.ch>
 <20201026085246.GC25281@yilunxu-OptiPlex-7050>
 <20201026130001.GC836546@lunn.ch>
 <20201026173803.GA10743@yilunxu-OptiPlex-7050>
 <20201026191400.GO752111@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026191400.GO752111@lunn.ch>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew:

On Mon, Oct 26, 2020 at 08:14:00PM +0100, Andrew Lunn wrote:
> > > > > Do you really mean PHY? I actually expect it is PCS? 
> > > > 
> > > > For this implementation, yes.
> > > 
> > > Yes, you have a PHY? Or Yes, it is PCS?
> > 
> > Sorry, I mean I have a PHY.
> > 
> > > 
> > > To me, the phylib maintainer, having a PHY means you have a base-T
> > > interface, 25Gbase-T, 40Gbase-T?  That would be an odd and expensive
> > > architecture when you should be able to just connect SERDES interfaces
> > > together.
> 
> You really have 25Gbase-T, 40Gbase-T? Between the FPGA & XL710?
> What copper PHYs are using? 
> 
> > I see your concerns about the SERDES interface between FPGA & XL710.
> 
> I have no concerns about direct SERDES connections. That is the normal
> way of doing this. It keeps it a lot simpler, since you don't have to
> worry about driving the PHYs.
>

I did some investigation and now I have some details.
The term 'PHY' described in Ether Group Spec should be the PCS + PMA, a figure
below for one configuration:

 +------------------------+          +-----------------+
 | Host Side Ether Group  |          |      XL710      |
 |                        |          |                 |
 | +--------------------+ |          |                 |
 | | 40G Ether IP       | |          |                 |
 | |                    | |          |                 |
 | |       +---------+  | |  XLAUI   |                 |
 | | MAC - |PCS - PMA|  | |----------| PMA - PCS - MAC |
 | |       +---------+  | |          |                 |
 +-+--------------------+-+          +-----------------+

Thanks,
Yilun
