Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEDA400F2B
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 12:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237731AbhIEKs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 06:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhIEKs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 06:48:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 601A060E8B;
        Sun,  5 Sep 2021 10:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630838876;
        bh=dPh//MDy1gMbbCZMmK2mOsOQ/2NM60CZJW7LuwdOGi4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QsWHjVvffXnsMitdn0A/uMAYOAhL7erWlBLukkP59UWCRvoK2SECmNToEJQIRa44e
         NidgheUHOBiqs4wQIUjnKhHo5MX8FR/TgKNXlfeOdXB3WWcmmnX7Jo1dTq4JV8aH3/
         yorPNnbVD4lnqdLc+Ayx72xQPlgvk6IYq/gL5RVJHCvGbiDn0uxqMFkGtUo3S11xVE
         ZhJV/j+kIm0P3jOSVx5blcbf+k5IgPBQP3LHH+JfptCI1Yv5uzHoD46whY3bE0/ON3
         ZmzdfSd1r6CK5Y3VsEpiiODqqXycVe2ra+vmzOm7Fe/je2MQryhDDzBV/bNtMHA93T
         VrfdR4PW4+CNQ==
Date:   Sun, 5 Sep 2021 13:47:51 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <YTSgVw7BNK1e4YWY@unreal>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
 <YTRswWukNB0zDRIc@unreal>
 <20210905084518.emlagw76qmo44rpw@skbuf>
 <YTSa/3XHe9qVz9t7@unreal>
 <20210905103125.2ulxt2l65frw7bwu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210905103125.2ulxt2l65frw7bwu@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 01:31:25PM +0300, Vladimir Oltean wrote:
> On Sun, Sep 05, 2021 at 01:25:03PM +0300, Leon Romanovsky wrote:
> > On Sun, Sep 05, 2021 at 11:45:18AM +0300, Vladimir Oltean wrote:
> > > On Sun, Sep 05, 2021 at 10:07:45AM +0300, Leon Romanovsky wrote:
> > > > On Fri, Sep 03, 2021 at 02:17:38AM +0300, Vladimir Oltean wrote:

<...>

> > That sentence means that your change is OK and you did it right by not
> > changing devlink port to hold not-working ports.
> 
> You're with me so far.
> 
> There is a second part. The ports with 'status = "disabled"' in the
> device tree still get devlink ports registered, but with the
> DEVLINK_PORT_FLAVOUR_UNUSED flavour and no netdev. These devlink ports
> still have things like port regions exported.
> 
> What we do for ports that have failed to probe is to reinit their
> devlink ports as DEVLINK_PORT_FLAVOUR_UNUSED, and their port regions, so
> they effectively behave as though they were disabled in the device tree.

Yes, and this part require DSA knowledge that I don't have, because you
suggest fallback for any error during devlink port register, which can
fail for reasons that require proper unwind instead of reinit.

Thanks
