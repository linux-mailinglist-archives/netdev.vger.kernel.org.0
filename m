Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B03119B7D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfLJWIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:08:39 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20912 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729057AbfLJWIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:08:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576015715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kY3BO5aFYrGkSGGBQRkUuW9yofnr10ys5NZJbMnM5fE=;
        b=XoONUhyzURnoCiHateOJuPvgQ0isVU4ZenkPToAZeK758wJH2vsjcM/Mbz2fudV5k+pgU0
        hfakSYHZb4f/zngLkIVAsaQPPRUOC/7TRchLqI9Zh/q/zfq12yO15Pr71V0wN4dZVnu8go
        TY/vOVhYqj+xhl5heBYNslOZUV4X11I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-YoiQpxrPOlGCVDNV8ybz_w-1; Tue, 10 Dec 2019 17:08:32 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A35B1005514;
        Tue, 10 Dec 2019 22:08:30 +0000 (UTC)
Received: from x1.home (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 258D919C6A;
        Tue, 10 Dec 2019 22:08:27 +0000 (UTC)
Date:   Tue, 10 Dec 2019 15:08:26 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/6] VFIO mdev aggregated resources handling
Message-ID: <20191210150826.4783496c@x1.home>
In-Reply-To: <bb995805-eb50-83e4-883f-c8907a53af16@mellanox.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
        <AM0PR05MB4866CA9B70A8BEC1868AF8C8D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108081925.GH4196@zhen-hp.sh.intel.com>
        <AM0PR05MB4866757033043CC007B5C9CBD15D0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191205060618.GD4196@zhen-hp.sh.intel.com>
        <AM0PR05MB4866C265B6C9D521A201609DD15C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191206080354.GA15502@zhen-hp.sh.intel.com>
        <79d0ca87-c6c7-18d5-6429-bb20041646ff@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D636944@SHSMSX104.ccr.corp.intel.com>
        <20191210120747.4530f046@x1.home>
        <bb995805-eb50-83e4-883f-c8907a53af16@mellanox.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: YoiQpxrPOlGCVDNV8ybz_w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 21:08:29 +0000
Parav Pandit <parav@mellanox.com> wrote:

> On 12/10/2019 1:07 PM, Alex Williamson wrote:
> > On Tue, 10 Dec 2019 03:33:23 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> >>> From: Parav Pandit <parav@mellanox.com>
> >>> Sent: Saturday, December 7, 2019 1:34 AM
> >>>
> >>> On 12/6/2019 2:03 AM, Zhenyu Wang wrote:    
> >>>> On 2019.12.05 18:59:36 +0000, Parav Pandit wrote:    
> >>>>>>>    
> >>>>>>>> On 2019.11.07 20:37:49 +0000, Parav Pandit wrote:    
> >>>>>>>>> Hi,
> >>>>>>>>>    
> >>>>>>>>>> -----Original Message-----
> >>>>>>>>>> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org>    
> >>> On    
> >>>>>>>>>> Behalf Of Zhenyu Wang
> >>>>>>>>>> Sent: Thursday, October 24, 2019 12:08 AM
> >>>>>>>>>> To: kvm@vger.kernel.org
> >>>>>>>>>> Cc: alex.williamson@redhat.com; kwankhede@nvidia.com;
> >>>>>>>>>> kevin.tian@intel.com; cohuck@redhat.com
> >>>>>>>>>> Subject: [PATCH 0/6] VFIO mdev aggregated resources handling
> >>>>>>>>>>
> >>>>>>>>>> Hi,
> >>>>>>>>>>
> >>>>>>>>>> This is a refresh for previous send of this series. I got
> >>>>>>>>>> impression that some SIOV drivers would still deploy their own
> >>>>>>>>>> create and config method so stopped effort on this. But seems
> >>>>>>>>>> this would still be useful for some other SIOV driver which may
> >>>>>>>>>> simply want capability to aggregate resources. So here's refreshed    
> >>>>>> series.    
> >>>>>>>>>>
> >>>>>>>>>> Current mdev device create interface depends on fixed mdev type,
> >>>>>>>>>> which get uuid from user to create instance of mdev device. If
> >>>>>>>>>> user wants to use customized number of resource for mdev device,
> >>>>>>>>>> then only can create new    
> >>>>>>>>> Can you please give an example of 'resource'?
> >>>>>>>>> When I grep [1], [2] and [3], I couldn't find anything related to '    
> >>>>>> aggregate'.    
> >>>>>>>>
> >>>>>>>> The resource is vendor device specific, in SIOV spec there's ADI
> >>>>>>>> (Assignable Device Interface) definition which could be e.g queue
> >>>>>>>> for net device, context for gpu, etc. I just named this interface as    
> >>>>>> 'aggregate'    
> >>>>>>>> for aggregation purpose, it's not used in spec doc.
> >>>>>>>>    
> >>>>>>>
> >>>>>>> Some 'unknown/undefined' vendor specific resource just doesn't work.
> >>>>>>> Orchestration tool doesn't know which resource and what/how to    
> >>> configure    
> >>>>>> for which vendor.    
> >>>>>>> It has to be well defined.
> >>>>>>>
> >>>>>>> You can also find such discussion in recent lgpu DRM cgroup patches    
> >>> series    
> >>>>>> v4.    
> >>>>>>>
> >>>>>>> Exposing networking resource configuration in non-net namespace    
> >>> aware    
> >>>>>> mdev sysfs at PCI device level is no-go.    
> >>>>>>> Adding per file NET_ADMIN or other checks is not the approach we    
> >>> follow in    
> >>>>>> kernel.    
> >>>>>>>
> >>>>>>> devlink has been a subsystem though under net, that has very rich    
> >>> interface    
> >>>>>> for syscaller, device health, resource management and many more.    
> >>>>>>> Even though it is used by net driver today, its written for generic device    
> >>>>>> management at bus/device level.    
> >>>>>>>
> >>>>>>> Yuval has posted patches to manage PCI sub-devices [1] and updated    
> >>> version    
> >>>>>> will be posted soon which addresses comments.    
> > 
> > Always good to see tools that intend to manage arbitrary devices posted
> > only to the netdev list :-\
> >   
> >>>>>>>
> >>>>>>> For any device slice resource management of mdev, sub-function etc,    
> >>> we    
> >>>>>> should be using single kernel interface as devlink [2], [3].    
> > 
> > This seems impractical, mdevs and SR-IOV are both enumerated,
> > inspected, created, and removed in sysfs,   
> Both enumerated via sysfs, but VFs are not configured via sysfs.
> 
> > where do we define what
> > features are manipulated vis sysfs versus devlink?  
> 
> VFs are configured via well defined, vendor neutral tool
> iproute2/ip link set <pf_netdev> vf <vf_index> <attribute> <value>
> 
> This falls short lately for few cases and non-networking or generic VF
> property configuration, are proposed to be handled by similar 'VF'
> object using devlink, because they are either pure 'pci vf' property or
> more device class type VF property such as MAC address or
> number_of_queues etc.
> 
> More advance mode of networking VFs, are controlled using netdev
> representors again in vendor neutral way for last few years.
> 
> It may be fair to say that mdev subsystem wants to invent new sysfs
> files for configuration.

It seems you're trying to apply rules for classes of devices where
configuration features are well defined to an environment where we
don't even have classes of devices, let alone agreed features.
 
>  mdevs, by
> > definition, are vendor defined "chunks" of a thing.  We allow vendor
> > drivers to define different types, representing different
> > configurations of these chunks.  Often these different types are
> > incrementally bigger or smaller chunks of these things, but defining
> > what bigger and smaller means generically across vendors is an
> > impossible task.  Orchestration tools already need to know vendor
> > specific information in terms of what type of mdev device they want to
> > create and make use of.  The aggregation seems to simply augment that
> > vendor information, ie. 'type' and 'scale' are separate rather than
> > combined only behind just 'type'.
> >   
> >>>>>>>
> >>>>>>> [1]
> >>>>>>> https://lore.kernel.org/netdev/1573229926-30040-1-git-send-email-    
> >>> yuval    
> >>>>>>> av@mellanox.com/ [2]
> >>>>>>> http://man7.org/linux/man-pages/man8/devlink-dev.8.html
> >>>>>>> [3] http://man7.org/linux/man-pages/man8/devlink-resource.8.html
> >>>>>>>
> >>>>>>> Most modern device configuration that I am aware of is usually done    
> >>> via well    
> >>>>>> defined ioctl() of the subsystem (vhost, virtio, vfio, rdma, nvme and    
> >>> more) or    
> >>>>>> via netlink commands (net, devlink, rdma and more) not via sysfs.    
> >>>>>>>    
> >>>>>>
> >>>>>> Current vfio/mdev configuration is via documented sysfs ABI instead of    
> >>> other    
> >>>>>> ways. So this adhere to that way to introduce more configurable method    
> >>> on    
> >>>>>> mdev device for standard, it's optional and not actually vendor specific    
> >>> e.g vfio-    
> >>>>>> ap.
> >>>>>>    
> >>>>> Some unknown/undefined resource as 'aggregate' is just not an ABI.
> >>>>> It has to be well defined, as 'hardware_address', 'num_netdev_sqs' or    
> >>> something similar appropriate to that mdev device class.    
> >>>>> If user wants to set a parameter for a mdev regardless of vendor, they    
> >>> must have single way to do so.  
> > 
> > Aggregation augments type, which is by definition vendor specific.
> >     
> >>>>
> >>>> The idea is not specific for some device class, but for each mdev
> >>>> type's resource, and be optional for each vendor. If more device class
> >>>> specific way is preferred, then we might have very different ways for
> >>>> different vendors. Better to avoid that, so here means to aggregate
> >>>> number of mdev type's resources for target instance, instead of defining
> >>>> kinds of mdev types for those number of resources.
> >>>>    
> >>> Parameter or attribute certainly can be optional.
> >>> But the way to aggregate them should not be vendor specific.
> >>> Look for some excellent existing examples across subsystems, for example
> >>> how you create aggregated netdev or block device is not depend on vendor
> >>> or underlying device type.    
> >>
> >> I'd like to hear Alex's opinion on this. Today VFIO mdev supports two styles
> >> of "types" imo: fixed resource definition (most cases) and dynamic resource 
> >> definition (vfio-ap). In fixed style, a type has fixed association to a set of 
> >> vendor specific resources (resourceX=M, resourceY=N, ...). In dynamic case, 
> >> the user is allowed to specify actual resource X/Y/... backing the mdev 
> >> instance post its creation. In either case, the way to identify such association 
> >> or configurable knobs is vendor specific, maybe contained in optional 
> >> attributes (name and description) plus additional info in vendor documents.
> >>
> >> Then the user is assumed to clearly understand the implication of the resource
> >> allocation under a given type, when creating a new mdev under this type.
> >>
> >> If this assumption holds true, the aggregated attribute simply provides an
> >> extension in the same direction of fixed-style types but allowing for more 
> >> flexible linearly-increasing resource allocation. e.g. when using aggregate=2, 
> >> it means creating a instance with resourceX=2M, resourceY=2N, ... under 
> >> the specified type. Along this direction I didn't see the need of well-defined 
> >> vendor specific attributes here. When those are actually required, I suppose 
> >> the dynamic style would better fit. Or if the vendor driver thinks implementing 
> >> such aggregate feature will confuse its type definition, it's optional to not 
> >> doing so anyway.  
> > 
> > Yep, though I don't think we can even define that aggregate=2 indicates
> > that every resources is doubled, it's going to have vendor specific
> > meaning.  Maybe this is what Parav is rejecting, but I don't see an
> > alternative.  For example, an mdev vGPU might have high level resources
> > like the number of execution units, graphics memory, display heads,
> > maximum resolution, etc.  Aggregation could affect one or all of these.
> > Orchestration tools already need to know the vendor specific type of
> > device they want to create, so it doesn't seem unreasonable that if
> > they use aggregation that they choose a type that aggregates the
> > resource(s) they need, but that aggregation is going to be specific to
> > the type.  Potentially as we think about adding "defined" sysfs
> > attributes for devices we could start with
> > $SYSFS_DEV_PATH/mdev/aggregation/type, where value written to type is a
> > vendor specific aggregation of that mdev type.  This allows us the
> > option that we might someday agree on specific resources that might be
> > aggregated in a common way (ex. ./aggregation/graphics_memory), but I'm
> > somewhat doubtful those would ever be pursued.  Thanks,
> >   
> 
> My point is, from Zhenyu Wang's example it is certainly incorrect to
> define mdev sysfs files, as,
> 
> vendor_foo_mdev.netdev_mac_addr=X
> vendor_bar_mdev.resource_addr=Y
> 
> vendor_foo_mdev.netdev_queues=4
> vendor_bar_mdev.aggregate=8
> 
> Unless this is a miscellaneous (not well defined) parameter of a vendor
> device.

I certainly think it's wrong to associate a "netdev" property with
something that the kernel only knows as an opaque device.  But that's
really the issue, mdevs are opaque devices as far as the host kernel is
concerned.  Since we seem to have landed on mdev being used exclusively
for vfio, the only thing we really know about an mdev generically is
which vfio bus driver API the device uses.  Any association of an mdev
to a GPU, NIC, HBA, or other accelerator or I/O interface is strictly
known by the user/admin's interpretation of the vendor specific type.
 
> I am 100% sure that consumers of network devices where a PCI PF is
> sliced into multiple smaller devices, wants to configure these devices
> in unified way regardless of vendor type.
> That may not be the case with vGPU mdevs.

I don't know about devlink, but iirc the ip command operates on a
netdev PF in order to, for example, assign MAC addresses to the VFs.
We have no guarantee with mdevs that there's a parent netdev device for
such an interface.  The parent device might be an FPGA where one type
it's able to expose looks like a NIC.  How do you envision devlink/ip
interacting with something like that?  Using common tools to set
networking properties on a device that the host kernel fundamentally
does not know is a networking device is... difficult.

> If Zhenyu Wang proposed to use networking class of mdev device,
> attributes should have well defined meaning, as it is well known class
> in linux kernel.
> mdev should be providing an API to define such mdev config object and
> all sysfs for such mdev to be created by the mdev core, not by vendor
> driver.

But of course there is no "networking class of mdev device".  Instead
there are mdev devices that might be NICs, but that's for the admin and
user to care about.  If you have an interface in mind for how devlink
is going to learn about mdev device and set properties, please share.
It's not clear to me if we need to design something to be compatible
with devlink or devlink needs to learn how to do certain things on mdev
devices (does devlink want to become a vfio userspace device driver in
order to probe the type of an mdev device?  That'll be hard given some
of the backdoor userspace dependencies of existing vGPU mdevs).  Thanks,

Alex

