Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92599B3ED
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 17:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436582AbfHWPwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 11:52:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbfHWPwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 11:52:33 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C8A4106E288;
        Fri, 23 Aug 2019 15:52:32 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C48F1001938;
        Fri, 23 Aug 2019 15:52:31 +0000 (UTC)
Date:   Fri, 23 Aug 2019 09:52:29 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190823095229.210e1e84@x1.home>
In-Reply-To: <AM0PR05MB4866867150DAABA422F25FF8D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190820225722.237a57d2@x1.home>
        <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190820232622.164962d3@x1.home>
        <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822092903.GA2276@nanopsycho.orion>
        <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822095823.GB2276@nanopsycho.orion>
        <AM0PR05MB4866144FD76C302D04DA04B9D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822121936.GC2276@nanopsycho.orion>
        <AM0PR05MB4866F9650CF73FC671972127D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823081221.GG2276@nanopsycho.orion>
        <AM0PR05MB4866DED407D6F1C653D5D560D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823082820.605deb07@x1.home>
        <AM0PR05MB4866867150DAABA422F25FF8D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Fri, 23 Aug 2019 15:52:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Aug 2019 14:53:06 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, August 23, 2019 7:58 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko <jiri@mellanox.com>; David S . Miller
> > <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>; Cornelia
> > Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > 
> > On Fri, 23 Aug 2019 08:14:39 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > Hi Alex,
> > >
> > >  
> > > > -----Original Message-----
> > > > From: Jiri Pirko <jiri@resnulli.us>
> > > > Sent: Friday, August 23, 2019 1:42 PM
> > > > To: Parav Pandit <parav@mellanox.com>
> > > > Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
> > > > <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>; Kirti
> > > > Wankhede <kwankhede@nvidia.com>; Cornelia Huck  
> > <cohuck@redhat.com>;  
> > > > kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > > <cjia@nvidia.com>; netdev@vger.kernel.org
> > > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > >
> > > > Thu, Aug 22, 2019 at 03:33:30PM CEST, parav@mellanox.com wrote:  
> > > > >
> > > > >  
> > > > >> -----Original Message-----
> > > > >> From: Jiri Pirko <jiri@resnulli.us>
> > > > >> Sent: Thursday, August 22, 2019 5:50 PM
> > > > >> To: Parav Pandit <parav@mellanox.com>
> > > > >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
> > > > >> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>;
> > > > >> Kirti Wankhede <kwankhede@nvidia.com>; Cornelia Huck  
> > > > <cohuck@redhat.com>;  
> > > > >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > > >> <cjia@nvidia.com>; netdev@vger.kernel.org
> > > > >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > > >>
> > > > >> Thu, Aug 22, 2019 at 12:04:02PM CEST, parav@mellanox.com wrote:  
> > > > >> >
> > > > >> >  
> > > > >> >> -----Original Message-----
> > > > >> >> From: Jiri Pirko <jiri@resnulli.us>
> > > > >> >> Sent: Thursday, August 22, 2019 3:28 PM
> > > > >> >> To: Parav Pandit <parav@mellanox.com>
> > > > >> >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
> > > > >> >> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>;
> > > > >> >> Kirti Wankhede <kwankhede@nvidia.com>; Cornelia Huck  
> > > > >> <cohuck@redhat.com>;  
> > > > >> >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > > >> >> <cjia@nvidia.com>; netdev@vger.kernel.org
> > > > >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > > >> >>
> > > > >> >> Thu, Aug 22, 2019 at 11:42:13AM CEST, parav@mellanox.com wrote:  
> > > > >> >> >
> > > > >> >> >  
> > > > >> >> >> -----Original Message-----
> > > > >> >> >> From: Jiri Pirko <jiri@resnulli.us>
> > > > >> >> >> Sent: Thursday, August 22, 2019 2:59 PM
> > > > >> >> >> To: Parav Pandit <parav@mellanox.com>
> > > > >> >> >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri
> > > > >> >> >> Pirko <jiri@mellanox.com>; David S . Miller
> > > > >> >> >> <davem@davemloft.net>; Kirti Wankhede
> > > > >> >> >> <kwankhede@nvidia.com>; Cornelia Huck  
> > > > >> >> <cohuck@redhat.com>;  
> > > > >> >> >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > > >> >> >> <cjia@nvidia.com>; netdev@vger.kernel.org
> > > > >> >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev
> > > > >> >> >> core
> > > > >> >> >>
> > > > >> >> >> Wed, Aug 21, 2019 at 08:23:17AM CEST, parav@mellanox.com  
> > wrote:  
> > > > >> >> >> >
> > > > >> >> >> >  
> > > > >> >> >> >> -----Original Message-----
> > > > >> >> >> >> From: Alex Williamson <alex.williamson@redhat.com>
> > > > >> >> >> >> Sent: Wednesday, August 21, 2019 10:56 AM
> > > > >> >> >> >> To: Parav Pandit <parav@mellanox.com>
> > > > >> >> >> >> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller
> > > > >> >> >> >> <davem@davemloft.net>; Kirti Wankhede
> > > > >> >> >> >> <kwankhede@nvidia.com>; Cornelia Huck
> > > > >> >> >> >> <cohuck@redhat.com>; kvm@vger.kernel.org;
> > > > >> >> >> >> linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
> > > > >> >> >> >> netdev@vger.kernel.org
> > > > >> >> >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and
> > > > >> >> >> >> mdev core
> > > > >> >> >> >>  
> > > > >> >> >> >> > > > > Just an example of the alias, not proposing how it's set.
> > > > >> >> >> >> > > > > In fact, proposing that the user does not set
> > > > >> >> >> >> > > > > it, mdev-core provides one  
> > > > >> >> >> >> > > automatically.  
> > > > >> >> >> >> > > > >  
> > > > >> >> >> >> > > > > > > Since there seems to be some prefix
> > > > >> >> >> >> > > > > > > overhead, as I ask about above in how many
> > > > >> >> >> >> > > > > > > characters we actually have to work with in
> > > > >> >> >> >> > > > > > > IFNAMESZ, maybe we start with
> > > > >> >> >> >> > > > > > > 8 characters (matching your "index"
> > > > >> >> >> >> > > > > > > namespace) and expand as necessary for  
> > > > >> >> >> disambiguation.  
> > > > >> >> >> >> > > > > > > If we can eliminate overhead in IFNAMESZ,
> > > > >> >> >> >> > > > > > > let's start with  
> > > > >> 12.  
> > > > >> >> >> >> > > > > > > Thanks,
> > > > >> >> >> >> > > > > > >  
> > > > >> >> >> >> > > > > > If user is going to choose the alias, why does
> > > > >> >> >> >> > > > > > it have to be limited to  
> > > > >> >> >> >> sha1?  
> > > > >> >> >> >> > > > > > Or you just told it as an example?
> > > > >> >> >> >> > > > > >
> > > > >> >> >> >> > > > > > It can be an alpha-numeric string.  
> > > > >> >> >> >> > > > >
> > > > >> >> >> >> > > > > No, I'm proposing a different solution where
> > > > >> >> >> >> > > > > mdev-core creates an alias based on an
> > > > >> >> >> >> > > > > abbreviated sha1.  The user does not provide the  
> > > > >> >> >> >> alias.  
> > > > >> >> >> >> > > > >  
> > > > >> >> >> >> > > > > > Instead of mdev imposing number of characters
> > > > >> >> >> >> > > > > > on the alias, it should be best  
> > > > >> >> >> >> > > > > left to the user.  
> > > > >> >> >> >> > > > > > Because in future if netdev improves on the
> > > > >> >> >> >> > > > > > naming scheme, mdev will be  
> > > > >> >> >> >> > > > > limiting it, which is not right.  
> > > > >> >> >> >> > > > > > So not restricting alias size seems right to me.
> > > > >> >> >> >> > > > > > User configuring mdev for networking devices
> > > > >> >> >> >> > > > > > in a given kernel knows what  
> > > > >> >> >> >> > > > > user is doing.  
> > > > >> >> >> >> > > > > > So user can choose alias name size as it finds suitable.  
> > > > >> >> >> >> > > > >
> > > > >> >> >> >> > > > > That's not what I'm proposing, please read again.
> > > > >> >> >> >> > > > > Thanks,  
> > > > >> >> >> >> > > >
> > > > >> >> >> >> > > > I understood your point. But mdev doesn't know how
> > > > >> >> >> >> > > > user is going to use  
> > > > >> >> >> >> > > udev/systemd to name the netdev.  
> > > > >> >> >> >> > > > So even if mdev chose to pick 12 characters, it
> > > > >> >> >> >> > > > could result in  
> > > > >> >> collision.  
> > > > >> >> >> >> > > > Hence the proposal to provide the alias by the
> > > > >> >> >> >> > > > user, as user know the best  
> > > > >> >> >> >> > > policy for its use case in the environment its using.  
> > > > >> >> >> >> > > > So 12 character sha1 method will still work by user.  
> > > > >> >> >> >> > >
> > > > >> >> >> >> > > Haven't you already provided examples where certain
> > > > >> >> >> >> > > drivers or subsystems have unique netdev prefixes?
> > > > >> >> >> >> > > If mdev provides a unique alias within the
> > > > >> >> >> >> > > subsystem, couldn't we simply define a netdev prefix
> > > > >> >> >> >> > > for the mdev subsystem and avoid all other
> > > > >> >> >> >> > > collisions?  I'm not in favor of the user providing
> > > > >> >> >> >> > > both a uuid and an alias/instance.  Thanks,
> > > > >> >> >> >> > >  
> > > > >> >> >> >> > For a given prefix, say ens2f0, can two UUID->sha1
> > > > >> >> >> >> > first 9 characters have  
> > > > >> >> >> >> collision?
> > > > >> >> >> >>
> > > > >> >> >> >> I think it would be a mistake to waste so many chars on
> > > > >> >> >> >> a prefix, but
> > > > >> >> >> >> 9 characters of sha1 likely wouldn't have a collision
> > > > >> >> >> >> before we have 10s of thousands of devices.  Thanks,
> > > > >> >> >> >>
> > > > >> >> >> >> Alex  
> > > > >> >> >> >
> > > > >> >> >> >Jiri, Dave,
> > > > >> >> >> >Are you ok with it for devlink/netdev part?
> > > > >> >> >> >Mdev core will create an alias from a UUID.
> > > > >> >> >> >
> > > > >> >> >> >This will be supplied during devlink port attr set such
> > > > >> >> >> >as,
> > > > >> >> >> >
> > > > >> >> >> >devlink_port_attrs_mdev_set(struct devlink_port *port,
> > > > >> >> >> >const char *mdev_alias);
> > > > >> >> >> >
> > > > >> >> >> >This alias is used to generate representor netdev's  
> > phys_port_name.  
> > > > >> >> >> >This alias from the mdev device's sysfs will be used by
> > > > >> >> >> >the udev/systemd to  
> > > > >> >> >> generate predicable netdev's name.  
> > > > >> >> >> >Example: enm<mdev_alias_first_12_chars>  
> > > > >> >> >>
> > > > >> >> >> What happens in unlikely case of 2 UUIDs collide?
> > > > >> >> >>  
> > > > >> >> >Since users sees two devices with same phys_port_name, user
> > > > >> >> >should destroy  
> > > > >> >> recently created mdev and recreate mdev with different UUID?
> > > > >> >>
> > > > >> >> Driver should make sure phys port name wont collide,  
> > > > >> >So when mdev creation is initiated, mdev core calculates the
> > > > >> >alias and if there  
> > > > >> is any other mdev with same alias exist, it returns -EEXIST error
> > > > >> before progressing further.  
> > > > >> >This way user will get to know upfront in event of collision
> > > > >> >before the mdev  
> > > > >> device gets created.  
> > > > >> >How about that?  
> > > > >>
> > > > >> Sounds fine to me. Now the question is how many chars do we want to  
> > have.  
> > > > >>  
> > > > >12 characters from Alex's suggestion similar to git?  
> > > >
> > > > Ok.
> > > >  
> > >
> > > Can you please confirm this scheme looks good now? I like to get patches  
> > started.
> > 
> > My only concern is your comment that in the event of an abbreviated
> > sha1 collision (as exceptionally rare as that might be at 12-chars), we'd fail the
> > device create, while my original suggestion was that vfio-core would add an
> > extra character to the alias.  For non-networking devices, the sha1 is
> > unnecessary, so the extension behavior seems preferred.  The user is only
> > responsible to provide a unique uuid.  Perhaps the failure behavior could be
> > applied based on the mdev device_api.  A module option on mdev to specify the
> > default number of alias chars would also be useful for testing so that we can set
> > it low enough to validate the collision behavior.  Thanks,
> >   
> 
> Idea is to have mdev alias as optional.
> Each mdev_parent says whether it wants mdev_core to generate an alias
> or not. So only networking device drivers would set it to true.
> For rest, alias won't be generated, and won't be compared either
> during creation time. User continue to provide only uuid.

Ok

> I am tempted to have alias collision detection only within children
> mdevs of the same parent, but doing so will always mandate to prefix
> in netdev name. And currently we are left with only 3 characters to
> prefix it, so that may not be good either. Hence, I think mdev core
> wide alias is better with 12 characters.

I suppose it depends on the API, if the vendor driver can ask the mdev
core for an alias as part of the device creation process, then it could
manage the netdev namespace for all its devices, choosing how many
characters to use, and fail the creation if it can't meet a uniqueness
requirement.  IOW, mdev-core would always provide a full sha1 and
therefore gets itself out of the uniqueness/collision aspects.

> I do not understand how an extra character reduces collision, if
> that's what you meant.

If the default were for example 3-chars, we might already have device
'abc'.  A collision would expose one more char of the new device, so we
might add device with alias 'abcd'.  I mentioned previously that this
leaves an issue for userspace that we can't change the alias of device
abc, so without additional information, userspace can only determine via
elimination the mapping of alias to device, but userspace has more
information available to it in the form of sysfs links.

> Module options are almost not encouraged
> anymore with other subsystems/drivers.

We don't live in a world of absolutes.  I agree that the defaults
should work in the vast majority of cases.  Requiring a user to twiddle
module options to make things work is undesirable, verging on a bug.  A
module option to enable some specific feature, unsafe condition, or test
that is outside of the typical use case is reasonable, imo.

> For testing collision rate, a sample user space script and sample
> mtty is easy and get us collision count too. We shouldn't put that
> using module option in production kernel. I practically have the code
> ready to play with; Changing 12 to smaller value is easy with module
> reload.
> 
> #define MDEV_ALIAS_LEN 12

If it can't be tested with a shipping binary, it probably won't be
tested.  Thanks,

Alex
