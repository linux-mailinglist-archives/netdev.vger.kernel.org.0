Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E423F6C42
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 01:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhHXXcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:32:39 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44586 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHXXcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 19:32:36 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BDE1E1FDD2;
        Tue, 24 Aug 2021 23:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629847910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z9rIqmYC7KNVP7RMaR756BWFFV/qtN/abPIOMZ9BZsI=;
        b=v4Hvkgpr0EVXXPn2XF7apywDNN4AKiNXV9CE+ophp3erypN8Tf6NBYLKBEw8gEbSaavS28
        1VRHZyyjP73L/nGjsVT9ePzdcWTdmafSZhpJHjUU7bN4m13Xcr3Ds7iz2KUVKpWL1v87F9
        k/wS6wIUyFRZRSuSAxeYO8MY753mw9Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629847910;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z9rIqmYC7KNVP7RMaR756BWFFV/qtN/abPIOMZ9BZsI=;
        b=Cu+tL1g/oCmf1GIz17oADk11WKicnkdPwQAKBuFvjoXJakwI0jPYMbwwiKBBAjel6f4s1P
        sPtn8uU416msu4AA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A850CA3B89;
        Tue, 24 Aug 2021 23:31:50 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 57DEB603F6; Wed, 25 Aug 2021 01:31:47 +0200 (CEST)
Date:   Wed, 25 Aug 2021 01:31:47 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "pali@kernel.org" <pali@kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <20210824233147.3ppmq4xk2n3n7afz@lion.mk-sys.cz>
References: <20210824130344.1828076-1-idosch@idosch.org>
 <20210824130344.1828076-2-idosch@idosch.org>
 <20210824161231.5e281f1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CO1PR11MB5089F1466B2072C6AD8614F1D6C59@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB5089F1466B2072C6AD8614F1D6C59@CO1PR11MB5089.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 11:18:56PM +0000, Keller, Jacob E wrote:
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, August 24, 2021 4:13 PM
> > To: Ido Schimmel <idosch@idosch.org>
> > Cc: netdev@vger.kernel.org; davem@davemloft.net; andrew@lunn.ch;
> > mkubecek@suse.cz; pali@kernel.org; Keller, Jacob E <jacob.e.keller@intel.com>;
> > jiri@nvidia.com; vadimp@nvidia.com; mlxsw@nvidia.com; Ido Schimmel
> > <idosch@nvidia.com>
> > Subject: Re: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
> > transceiver modules' power mode
> > 
> > On Tue, 24 Aug 2021 16:03:39 +0300 Ido Schimmel wrote:
[...]
> > > +/**
> > > + * struct ethtool_module_power_mode_params - module power mode
> > parameters
> > > + * @policy: The power mode policy enforced by the host for the plug-in
> > module.
> > > + * @mode: The operational power mode of the plug-in module. Should be
> > filled by
> > > + * device drivers on get operations.
> > 
> > Indent continuation lines by one tab.
> > 
> > > + * @mode_valid: Indicates the validity of the @mode field. Should be set by
> > > + * device drivers on get operations when a module is plugged-in.
> > 
> > Should we make a firm decision on whether we want to use these kind of
> > valid bits or choose invalid defaults? As you may guess my preference
> > is the latter since that's what I usually do, that way drivers don't
> > have to write two fields.
> > 
> > Actually I think this may be the first "valid" in ethtool, I thought we
> > already had one but I don't see it now..
> > 
> 
> 
> coalesce settings have a valid mode don't they? Or at least an
> "accepted modes"?

That's different, IIUC. In coalesce settings, the driver declares which
parameters are allowed in "set" requests so that this part of request
checks can be done in the general ethtool code rather than in each
driver separately. Here the "valid" field says whether mode field holds
a meaningful value or should be ignored.

Michal
