Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E3F9E6ED
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfH0LlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:41:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65064 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfH0LlV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 07:41:21 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AB59461D25;
        Tue, 27 Aug 2019 11:41:20 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2EEB600D1;
        Tue, 27 Aug 2019 11:41:16 +0000 (UTC)
Date:   Tue, 27 Aug 2019 13:41:14 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Message-ID: <20190827134114.01ddd049.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB4866CC932630ADD9BDA51371D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-2-parav@mellanox.com>
        <20190827122428.37442fe1.cohuck@redhat.com>
        <AM0PR05MB4866B68C9E60E42359BE1F4DD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190827132404.483a74ad.cohuck@redhat.com>
        <AM0PR05MB4866CC932630ADD9BDA51371D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 27 Aug 2019 11:41:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 11:33:54 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Tuesday, August 27, 2019 4:54 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org
> > Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
> > 
> > On Tue, 27 Aug 2019 11:12:23 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > > -----Original Message-----
> > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > Sent: Tuesday, August 27, 2019 3:54 PM
> > > > To: Parav Pandit <parav@mellanox.com>
> > > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > > Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
> > > >

> > > > What about:
> > > >
> > > > * @get_alias_length: optional callback to specify length of the alias to  
> > create  
> > > > *                    Returns unsigned integer: length of the alias to be created,
> > > > *                                              0 to not create an alias
> > > >  
> > > Ack.
> > >  
> > > > I also think it might be beneficial to add a device parameter here
> > > > now (rather than later); that seems to be something that makes sense.
> > > >  
> > > Without showing the use, it shouldn't be added.  
> > 
> > It just feels like an omission: Why should the vendor driver only be able to
> > return one value here, without knowing which device it is for?
> > If a driver supports different devices, it may have different requirements for
> > them.
> >   
> Sure. Lets first have this requirement to add it.
> I am against adding this length field itself without an actual vendor use case, which is adding some complexity in code today.
> But it was ok to have length field instead of bool.
> 
> Lets not further add "no-requirement futuristic knobs" which hasn't shown its need yet.
> When a vendor driver needs it, there is nothing prevents such addition.

Frankly, I do not see how it adds complexity; the other callbacks have
device arguments already, and the vendor driver is free to ignore it if
it does not have a use for it. I'd rather add the argument before a
possible future user tries weird hacks to allow multiple values, but
I'll leave the decision to the maintainers.
