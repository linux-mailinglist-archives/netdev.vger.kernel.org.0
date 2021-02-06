Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6429A311F67
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 19:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhBFSqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 13:46:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbhBFSqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 13:46:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A09864E64;
        Sat,  6 Feb 2021 18:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612637133;
        bh=akvs+qjVYbCP78VWqfiJJtRsqOoS38cfLeYRTgA8VF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i7r6Z+ILeIqdOHkBVAQan/Kpgv9paCudqq1/iJaFDRt2rkA5IqjzvtNehyMi1nnSF
         YCSdVQqyqMKU9cLnhGUCoQ/GlRRjNHfFFpIb9TBQnPVTFumMmIWrOPR4gJAJf4QMZo
         TLhtYS4+31OTKhG58ENex09+Pao2D+VzyUUBxPsHMv9IHvAZR5pPM+js9vq8Cyf7sp
         Uk/ksJV63dAgVverCZSx7ITnaLQSku4B+hBERnuEQptmICqA82zSxYL4z5MIYErCuY
         xDFhebEfkgVjNYnAViPCobuXYMMdYG3S2dTh7ck5EeOWDS/J9IO8ki1saSVShVxYzo
         QOhMRFZKCDwkA==
Date:   Sat, 6 Feb 2021 10:45:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com
Subject: Re: [PATCH v2 2/2] ibmvnic: fix race with multiple open/close
Message-ID: <20210206104524.06f6ed99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203205652.GA700270@us.ibm.com>
References: <20210203050650.680656-1-sukadev@linux.ibm.com>
        <20210203050650.680656-2-sukadev@linux.ibm.com>
        <CA+FuTSdRci4=fAza+L_-kUf9VkZnfUhWZ49-XHY8DiRuroSv3Q@mail.gmail.com>
        <20210203205652.GA700270@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 12:56:52 -0800 Sukadev Bhattiprolu wrote:
> Willem de Bruijn [willemdebruijn.kernel@gmail.com] wrote:
> > On Wed, Feb 3, 2021 at 12:10 AM Sukadev Bhattiprolu
> > <sukadev@linux.ibm.com> wrote:  
> > >
> > > If two or more instances of 'ip link set' commands race and first one
> > > already brings the interface up (or down), the subsequent instances
> > > can simply return without redoing the up/down operation.
> > >
> > > Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> > > Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
> > > Tested-by: Abdul Haleem <abdhalee@in.ibm.com>
> > > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> > >
> > > ---
> > > Changelog[v2] For consistency with ibmvnic_open() use "goto out" and return
> > >               from end of function.  
> > 
> > Did you find the code path that triggers this?  
> 
> Not yet. I need to find time on the system to repro/debug that
> > 
> > In v1 we discussed how the usual ip link path should not call the
> > driver twice based on IFF_UP.  
> 
> Yes, we can hold this patch for now if necessary. Hopefully Patch 1/2 is
> ok.

Patch 1 does not apply to net as is. Please rebase and fix up the
comments the way I fixed them for

 "ibmvnic: Clear failover_pending if unable to schedule"

Thanks!
