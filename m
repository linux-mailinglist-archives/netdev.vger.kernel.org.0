Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF16179339
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 16:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgCDPWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 10:22:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45530 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgCDPWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 10:22:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UyMvM79iauhceuVsf/7VOzkdJuDf7faxM5TW5vHpExc=; b=G9Qr+PqdcR110pPlf+TBBU31rc
        le+1MxE1TO/nfqB8NvG3oNdqxrKyWfs0Dng+R4UG5KZqyBJs4BzPZVBfB+uvrxpYcPiudGrlShGRY
        1D9gPESL/DfMU2xGTuT6GgILCf4wfKRpmPYpkhs5UAvXAB3S7sslrSBV50jV+rspFLAw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9VrF-0006Zn-Aw; Wed, 04 Mar 2020 16:22:49 +0100
Date:   Wed, 4 Mar 2020 16:22:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org
Subject: Re: [PATCH net-next 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200304152249.GD3553@lunn.ch>
References: <20200304035501.628139-1-kuba@kernel.org>
 <20200304035501.628139-2-kuba@kernel.org>
 <20200304145439.GC3553@lunn.ch>
 <20200304151958.GI4264@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304151958.GI4264@unicorn.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 04:19:58PM +0100, Michal Kubecek wrote:
> On Wed, Mar 04, 2020 at 03:54:39PM +0100, Andrew Lunn wrote:
> > On Tue, Mar 03, 2020 at 07:54:50PM -0800, Jakub Kicinski wrote:
> > > @@ -2336,6 +2394,11 @@ ethtool_set_per_queue_coalesce(struct net_device *dev,
> > >  			goto roll_back;
> > >  		}
> > >  
> > > +		if (!ethtool_set_coalesce_supported(dev, &coalesce)) {
> > > +			ret = -EINVAL;
> > > +			goto roll_back;
> > > +		}
> > 
> > Hi Jakub
> > 
> > EOPNOTSUPP? 
> 
> Out of the 11 drivers patched in the rest of the series, 4 used
> EOPNOTSUPP, 3 EINVAL and 4 just ignored unsupported parameters so there
> doesn't seem to be a clear consensus. Personally I find EOPNOTSUPP more
> appropriate but it's quite common that drivers return EINVAL for
> parameters they don't understand or support.

Hi Michel

Yes, as i looked through the later patches, it became clear there is
no consensus. I personally prefer EOPNOTSUPP, but don't care too much.

   Andrew
