Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF211076A9
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfKVRo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:44:27 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46503 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVRo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:44:26 -0500
Received: by mail-pf1-f193.google.com with SMTP id 193so3788166pfc.13
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 09:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3uMOiL137OQ6F0KYX4sy2BsXW/ktBFx3dq2Tvwu2W+U=;
        b=PFJFBqroVejMDZfvPypbJS3o3+9TETleM+wZtHh9V3FjX3xJvOAPOQjZKwT+P+7l6A
         k/2U18aLtnCRqzmE1WrmYsnkDufnH2qPMS4C6ZqFugiXxUqkqZBBNchjqGlYFUpwAPeE
         b+yu94RY0Fnfwl2uguhDMOUs13ZHkmEnv2W+qpQcpG8P3kSXflVy4RvmOuXhREvKmRh/
         GGkatSkTXbfwEUwdSeJPWbnpymc70swIxkDWweQwlGSU45iGAQiEUuKo248aZsJ600La
         ei7wCCpv8JavVpk04BuCIiN5Rs4fhSs0QuaNhyUuvttiIp8ZJm+58/SlrHVyjga1PrjJ
         jSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3uMOiL137OQ6F0KYX4sy2BsXW/ktBFx3dq2Tvwu2W+U=;
        b=msGHMlKzL+up35neZ/v3zc7kx7ia4/5sSxQRtzFzhSiORHLM6Pl/x377np9oDGbRQE
         JT3DPNa0nSqbp2qbhnD8ssa3KKnVHL/v+eGAG/pFENbCfCuPEY6eZg0Tb73Lr3IjEdSA
         hIznUmVcEHzMGOSGyrqwj+Fkl1NyEM+kgaIz4xhB+27YB08i0Yhczz5jTUp6VOXCpXxr
         lb1pF1sQ3Exf4WTibbuMxzgJhQJ5iVIOXxO+SS40KNqB8Rep8YUjQuMJ+ucyf0qUCFQL
         /wQ/Y/m3z6wmT+Msx24oB5cRF69VKRFj/G/1B1Lk9PGuaCQg0MqYQmJVE4IPUz2xargN
         zmUQ==
X-Gm-Message-State: APjAAAUcyo4kMuARmGj9i7aS7Yx7pKThYJ8TGROtvzpp7aZHvHyhLcWM
        q86glOdkQ1g1DcZJCtLUBwNhGQ==
X-Google-Smtp-Source: APXvYqyEC3oPwAPdzYbRQRUcvpvIU3J0ouyx7yqqAlF4eB8mejGDqzZPCbqOtjgIVGDwey4HMq6/EQ==
X-Received: by 2002:a63:a0b:: with SMTP id 11mr17465505pgk.114.1574444665654;
        Fri, 22 Nov 2019 09:44:25 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id x203sm7597374pgx.61.2019.11.22.09.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 09:44:25 -0800 (PST)
Date:   Fri, 22 Nov 2019 09:44:21 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Henry Tieman <henry.w.tieman@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 13/15] ice: Implement ethtool ops for channels
Message-ID: <20191122094421.51d54517@cakuba.netronome.com>
In-Reply-To: <2abb44f7a40b3e80a2f869205cf981b975cc3bd7.camel@intel.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
        <20191121074612.3055661-14-jeffrey.t.kirsher@intel.com>
        <20191121144246.04adde1a@cakuba.netronome.com>
        <2abb44f7a40b3e80a2f869205cf981b975cc3bd7.camel@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Nov 2019 23:09:06 -0800, Jeff Kirsher wrote:
> On Thu, 2019-11-21 at 14:42 -0800, Jakub Kicinski wrote:
> > On Wed, 20 Nov 2019 23:46:10 -0800, Jeff Kirsher wrote:  
> > > +	curr_combined = ice_get_combined_cnt(vsi);
> > > +
> > > +	/* these checks are for cases where user didn't specify a
> > > particular
> > > +	 * value on cmd line but we get non-zero value anyway via
> > > +	 * get_channels(); look at ethtool.c in ethtool repository (the
> > > user
> > > +	 * space part), particularly, do_schannels() routine
> > > +	 */
> > > +	if (ch->rx_count == vsi->num_rxq - curr_combined)
> > > +		ch->rx_count = 0;
> > > +	if (ch->tx_count == vsi->num_txq - curr_combined)
> > > +		ch->tx_count = 0;
> > > +	if (ch->combined_count == curr_combined)
> > > +		ch->combined_count = 0;
> > > +
> > > +	if (!(ch->combined_count || (ch->rx_count && ch->tx_count))) {
> > > +		netdev_err(dev, "Please specify at least 1 Rx and 1 Tx
> > > channel\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	new_rx = ch->combined_count + ch->rx_count;
> > > +	new_tx = ch->combined_count + ch->tx_count;  
> > 
> > The combined vs individual count logic looks correct to me which is not
> > common, so nice to see that!
> >   
> > > +	if (new_rx > ice_get_max_rxq(pf)) {
> > > +		netdev_err(dev, "Maximum allowed Rx channels is %d\n",
> > > +			   ice_get_max_rxq(pf));
> > > +		return -EINVAL;
> > > +	}
> > > +	if (new_tx > ice_get_max_txq(pf)) {
> > > +		netdev_err(dev, "Maximum allowed Tx channels is %d\n",
> > > +			   ice_get_max_txq(pf));
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
> > > +
> > > +	if (new_rx)
> > > +		return ice_vsi_set_dflt_rss_lut(vsi, new_rx);  
> > 
> > But I don't see you doing a netif_is_rxfh_configured() check, which is
> > supposed to prevent reconfiguring the RSS indirection table if it was
> > set up manually by the user.  
> 
> Talking with Henry it appears Jake's kernel changes were done in parallel
> or after the work that was done in the driver.  

Really?

commit d4ab4286276fcd6c155bafdf4422b712068d2516
Author: Keller, Jacob E <jacob.e.keller@intel.com>
Date:   Mon Feb 8 16:05:03 2016 -0800
            ^^^^^          ^^^^
    ethtool: correctly ensure {GS}CHANNELS doesn't conflict with GS{RXFH}

> There appears to be more
> code that just adding a simple check, is this a *required* change for
> acceptance.  We are currently looking into making this fix, but due to the
> upcoming holidays, not sure if we can make the desired change before the
> merge window closes.  So I see the following options:
> 
> - accept patch as is, and expect a fix in the next patch submission
> - drop this patch since the fix will not be available before the merge
> window closes for net-next
> 
> While I prefer the first option because we are also submitting the "new"
> virtio_bus patches, which depend heavily on these changes upstream, I think
> we can drop this patch (if necessary) and be fine to submit the other
> patches with little thrash.
> 
> Which option is preferred or acceptable to you Dave and Jakub?

I don't feel very strongly about this, but what if 5.5 gets picked 
by some distro and users actually start depending on the incorrect
behaviour? :(

I'm a little worried that the fix is not trivial, I think it should be.
Is the effort in validation?

I'd think best way forward would be to drop this patch, get the rest of
the series in, and since this one patch was initially posted before the
merge window started maybe you could persuade Dave to merge it after
net-next closes (but before -rc1).

Also, perhaps some Central Europeans can help out if it's Thanksgiving
getting in the way? Not sure that'd work for your processes..

