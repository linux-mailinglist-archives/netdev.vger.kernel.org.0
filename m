Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077882F5696
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbhANBtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729823AbhANAaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:30:15 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A8FC061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 16:18:02 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id e18so5638596ejt.12
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 16:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WZSdrCGVsEdSCw1K+EbIBbSiTAg3uz0kl/s5fUdz1fc=;
        b=grWlQPxHqrcsZI4UHkhe9hdh47Mr4X/7tQW99tJ4sOBSmFI/dqCiyE6mzz0Bkpb3u6
         YPgqywqgSmQzFRWRz5DvQ8cxIP7qd0SbyqrQvQJzeL3H6MZDZP1j241GGp1VqHkCmpO5
         EU7uAypX+FpFgw/jeZyrkTF4Te3aMv/U4fyX2COLFeaZ7UuejlTJiIo+Rrk8FejUyRsy
         88ZtGudAfBQtteaWFEW9qP2/QvvnpTaLbHiPVyWI4VoGXpCWunMCJENiEJzJzcCcGO1Q
         vIee2PPJXm+yKeYNZSyUqeUMyTauwR5CZyjBZgbe5sTrU6DEtQIKY7uphhaFBPajjiRH
         +1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WZSdrCGVsEdSCw1K+EbIBbSiTAg3uz0kl/s5fUdz1fc=;
        b=qxZVP41Mr8UYuHyqcuKBsgaLf1cNagp3bibKjuLn7PkVr/eSUQGIIBPJIZmHPebgrc
         HOOmu7swKEk0jd/Gmw0bpBT6DIHVK9evpfZ9R9RmB2SSJr4wYsSPmeU81U1B4NHMCIbN
         36D2dx242X4ABC1ArsoEZirC4DbnElVNQxPqG2hHAp6RppYM8BYYZL5kWd70jKH9ClrZ
         KrQtFDG/fj8v86ghD2EGa0rKlOXGm+0hxTGAhxC0/34ezSnknRF772YjgalZMPhrptrD
         WSTs67VgumKH7kTT8Ta/3p/fMwnKqO9TVnaAN1GTCWcCO5cfy4sY4kmpNYB7H5HsN9yh
         c3ow==
X-Gm-Message-State: AOAM531fJNz0qtQ13WW8YosuNLYYCDacOsEPIuhfLTVWLLuBN9uu2XGO
        4zcZG1IjJVqwmz9EG+H/3YZVuHaJ+No=
X-Google-Smtp-Source: ABdhPJx6HabUrPOAGm0+MkberyrsatMBCQYenvS9wr4g981YAWzheraOE0juHbqK8O1nD/aV3KznXg==
X-Received: by 2002:a17:907:700c:: with SMTP id wr12mr3342760ejb.398.1610583481249;
        Wed, 13 Jan 2021 16:18:01 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id o10sm1313234eju.89.2021.01.13.16.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 16:18:00 -0800 (PST)
Date:   Thu, 14 Jan 2021 02:17:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: allow setting port-based QoS
 priority using tc matchall skbedit
Message-ID: <20210114001759.atz5vehkdrire6p7@skbuf>
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-2-olteanv@gmail.com>
 <X/+FKCRgkqOtoWbo@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/+FKCRgkqOtoWbo@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 12:41:28AM +0100, Andrew Lunn wrote:
> On Wed, Jan 13, 2021 at 05:41:38PM +0200, Vladimir Oltean wrote:
> > +	int	(*port_priority_set)(struct dsa_switch *ds, int port,
> > +				     struct dsa_mall_skbedit_tc_entry *skbedit);
> 
> The fact we can turn this on/off suggests there should be a way to
> disable this in the hardware, when the matchall is removed. I don't
> see any such remove support in this patch.

I don't understand this comment, sorry. When the matchall filter
containing the skbedit action gets removed, DSA calls the driver's
.port_priority_set callback again, this time with a priority of 0.
There's nothing to "remove" about a port priority. I made an assumption
(which I still consider perfectly reasonable) that no port-based
prioritization means that all traffic gets classified to traffic class 0.
