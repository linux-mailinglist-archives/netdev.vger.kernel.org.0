Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0CA4EAB13
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 08:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfJaHmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 03:42:22 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37361 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJaHmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 03:42:21 -0400
Received: by mail-lf1-f68.google.com with SMTP id b20so3785891lfp.4;
        Thu, 31 Oct 2019 00:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A9hJv4nqid7JxIZHhixcSeeagf7GXYfXIFUT0XG91wk=;
        b=VfgwRQClq8a/k41mHyTkzsSHpIhqf5bvkBLRIoAnAokMIKNaS+9qRU8bi46hjRpIn3
         cOLiLiZvh2a0fOvMU1vL2wS7+ljNaz0kCPvZx/VQARhYtLl7Arv1MSi1c/AAioCyDKRf
         T3zw5n/Zmo+khkyzLPtAqVVrWT7AscFds8h2vGM8q5ZdFsrrJFBNRf0qAl4kToErvDlC
         nakx5rqZY5eAC2IgtL+n5IYgVWUEZwdE+P0R4pKguK6Fr81u5r/aFwgHOefDvktYyhAm
         Dcm6rFLBXP9h7KBKzv3BHgWs1inJDHw8fXdAwWcbDPjSlddd+UyQgLtufTo0miY1LepG
         Z6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A9hJv4nqid7JxIZHhixcSeeagf7GXYfXIFUT0XG91wk=;
        b=LPBX4ewxZEJ3svP6Vh1JVVo0FSE7DJv4W1eUe0c6Nhmo26xkBBYkyPK7aJt9W0QFTN
         SS2So34jouZcOau9Unl2JVVzJLhyX1pniOjegkBf278dfdXsoktit2XV0T8sQsFp19y4
         gks5+oI+VmrDlvhBY76JEKgdSraGh6tfQF6h/3/CtrbeePX0TkuwlgijeV/ZWIQaOtha
         JaZIw5H5hB1nx72PVyLdqphWD/rPFNDHUyF/IoDc0sI1Uhxdr+SMcIu/L01/SpsBXY7g
         rUr0rF9wtkCBbaOuWyGf0M1VO/QlFlGezPCYsYbL8rzmxs9O/1Zjdxr1/55eqiZjr0HK
         g+Hg==
X-Gm-Message-State: APjAAAVYPtYHksLqk+sLuE72h8BO6jAZ7AWvuKv6a0GtGq+OH+OFKJ4d
        ae6ZJUA8hzd5Pgpy4eBWl5FuYdD53lcnd0yRQw4=
X-Google-Smtp-Source: APXvYqzPtzaP+14gi8Hkuo8pVwf2y/AhuX9DfzXZm4tRMGcgj4F2h8t2RuFhCXvtnHzdpNSZpxpw2fUHWZim2v2tOuQ=
X-Received: by 2002:a19:2356:: with SMTP id j83mr2237665lfj.103.1572507738370;
 Thu, 31 Oct 2019 00:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190927051320.GA1767635@kroah.com> <2B0E3F215D1AB84DA946C8BEE234CCC97B2B1A28@ORSMSX101.amr.corp.intel.com>
 <20191023174448.GP23952@ziepe.ca> <2B0E3F215D1AB84DA946C8BEE234CCC97B2E0C84@ORSMSX101.amr.corp.intel.com>
 <20191023180108.GQ23952@ziepe.ca> <20191024185659.GE260560@kroah.com>
 <20191024191037.GC23952@ziepe.ca> <2B0E3F215D1AB84DA946C8BEE234CCC97B2E1D29@ORSMSX101.amr.corp.intel.com>
 <20191025013048.GB265361@kroah.com> <2B0E3F215D1AB84DA946C8BEE234CCC97B2E2FE6@ORSMSX101.amr.corp.intel.com>
 <20191026185338.GA804892@kroah.com>
In-Reply-To: <20191026185338.GA804892@kroah.com>
From:   Tomas Winkler <tomasw@gmail.com>
Date:   Thu, 31 Oct 2019 08:42:06 +0100
Message-ID: <CA+i0qc4pcxT6L9G-RGL6VYGDTYXZ4PSyw=sDgq8_+=jbs1E83A@mail.gmail.com>
Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device to
 provide RDMA
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >
> > > On Thu, Oct 24, 2019 at 10:25:36PM +0000, Ertman, David M wrote:
> > > > The direct access of the platform bus was unacceptable, and the MFD
> > > > sub-system was suggested by Greg as the solution.  The MFD sub-system
> > > > uses the platform bus in the background as a base to perform its
> > > > functions, since it is a purely software construct that is handy and
> > > > fulfills its needs.  The question then is:  If the MFD sub- system is
> > > > using the platform bus for all of its background functionality, is the platform
> > > bus really only for platform devices?
> > >
> > > Yes, how many times do I have to keep saying this?
> > >
> > > The platform bus should ONLY be used for devices that are actually platform
> > > devices and can not be discovered any other way and are not on any other type
> > > of bus.
> > >
> > > If you try to add platform devices for a PCI device, I am going to continue to
> > > complain.  I keep saying this and am getting tired.
> > >
> > > Now yes, MFD does do "fun" things here, and that should probably be fixed up
> > > one of these days.  But I still don't see why a real bus would not work for you.
> > >
> > > greg "platform devices are dead, long live the platform device" k-h
> >
> > > -----Original Message-----
> > > From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> > > Sent: Thursday, October 24, 2019 6:31 PM
> > > To: Ertman, David M <david.m.ertman@intel.com>
> > > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Nguyen, Anthony L
> > > <anthony.l.nguyen@intel.com>; Kirsher, Jeffrey T
> > > <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org; linux-
> > > rdma@vger.kernel.org; dledford@redhat.com; Ismail, Mustafa
> > > <mustafa.ismail@intel.com>; Patil, Kiran <kiran.patil@intel.com>;
> > > lee.jones@linaro.org
> > > Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device to
> > > provide RDMA
> > >
> > > On Thu, Oct 24, 2019 at 10:25:36PM +0000, Ertman, David M wrote:
> > > > The direct access of the platform bus was unacceptable, and the MFD
> > > > sub-system was suggested by Greg as the solution.  The MFD sub-system
> > > > uses the platform bus in the background as a base to perform its
> > > > functions, since it is a purely software construct that is handy and
> > > > fulfills its needs.  The question then is:  If the MFD sub- system is
> > > > using the platform bus for all of its background functionality, is the platform
> > > bus really only for platform devices?
> > >
> > > Yes, how many times do I have to keep saying this?
> > >
> > > The platform bus should ONLY be used for devices that are actually platform
> > > devices and can not be discovered any other way and are not on any other type
> > > of bus.
> > >
> > > If you try to add platform devices for a PCI device, I am going to continue to
> > > complain.  I keep saying this and am getting tired.
> > >
> > > Now yes, MFD does do "fun" things here, and that should probably be fixed up
> > > one of these days.  But I still don't see why a real bus would not work for you.
> > >
> > > greg "platform devices are dead, long live the platform device" k-h
> >
> > I'm sorry, the last thing I want to do is to annoy you! I just need to
> > figure out where to go from here.  Please, don't take anything I say as
> > argumentative.
> >
> > I don't understand what you mean by "a real bus".  The irdma driver does
> > not have access to any physical bus.  It utilizes resources provided by
> > the PCI LAN drivers, but to receive those resources it needs a mechanism
> > to "hook up" with the PCI drivers.  The only way it has to locate them
> > is to register a driver function with a software based bus of some kind
> > and have the bus match it up to a compatible entity to achieve that hook up.
> >
> > The PCI LAN driver has a function that controls the PCI hardware, and then
> > we want to present an entity for the RDMA driver to connect to.
> >
> > To move forward, we are thinking of the following design proposal:
> >
> > We could add a new module to the kernel named generic_bus.ko.  This would
> > create a new generic software bus and a set of APIs that would allow for
> > adding and removing simple generic virtual devices and drivers, not as
> > a MFD cell or a platform device. The power management events would also
> > be handled by the generic_bus infrastructure (suspend, resume, shutdown).
> > We would use this for matching up by having the irdma driver register
> > with this generic bus and hook to virtual devices that were added from
> > different PCI LAN drivers.
> >
> > Pros:
> > 1) This would avoid us attaching anything to the platform bus
> > 2) Avoid having each PCI LAN driver creating its own software bus
> > 3) Provide a common matching ground for generic devices and drivers that
> > eliminates problems caused by load order (all dependent on generic_bus.ko)
> > 4) Usable by any other entity that wants a lightweight matching system
> > or information exchange mechanism
> >
> > Cons:
> > 1) Duplicates part of the platform bus functionality
> > 2) Adds a new software bus to the kernel architecture
> >
> > Is this path forward acceptable?
>
> Yes, that is much better.  But how about calling it a "virtual bus"?
> It's not really virtualization, but we already have virtual devices
> today when you look in sysfs for devices that are created that are not
> associated with any specific bus.  So this could take those over quite
> nicely!  Look at how /sys/devices/virtual/ works for specifics, you
> could create a new virtual bus of a specific "name" and then add devices
> to that bus directly.
>
> thanks,
If I'm not mistaken,  currently the virtual devices do not have a parent and
may not  have a bus so there is no enumeration and hence binding to a driver.
This is not a case here, as the parent is the PCI device, and we need
to bind to a driver.
Code-wise the platform bus contains all the functionality needed by
such virtual bus, for example helpers for the adding of resources that
are inherited
from its parent PCI device,
 MMIO and IRQ,  the issue is just the name of the bus and associated sysfs?
In that case the  platform bus will be a special case of the virtual bus?
Thanks
Tomas
