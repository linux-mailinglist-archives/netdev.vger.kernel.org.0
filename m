Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C05119052
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfLJTH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:07:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56361 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727617AbfLJTH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:07:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576004876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BfuDWTxO12oAtz92xJyq0vf10hUjhgEKJh0jZ2uLJqc=;
        b=Bs+WRmPRb7AnYPmxXOUOj1CeOr+nmCNclI68wf31R4PauzNlMyYs/J9oWJOrma6xtQ4bLB
        LPjHnk9bQPwVYUAsGQC/2I6LmCwt9FDGr472oecxq+t/rnAJ1CSCqoaHoCqmWAc6UBfnYm
        tVNkDNvXOL6klwjSuT23lvAOfuQOKhs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-3SqaN9miMMG9ZqNsI4aYtg-1; Tue, 10 Dec 2019 14:07:52 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0843F107ACC4;
        Tue, 10 Dec 2019 19:07:51 +0000 (UTC)
Received: from x1.home (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06AB85C1B0;
        Tue, 10 Dec 2019 19:07:47 +0000 (UTC)
Date:   Tue, 10 Dec 2019 12:07:47 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Parav Pandit <parav@mellanox.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/6] VFIO mdev aggregated resources handling
Message-ID: <20191210120747.4530f046@x1.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D636944@SHSMSX104.ccr.corp.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
        <AM0PR05MB4866CA9B70A8BEC1868AF8C8D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108081925.GH4196@zhen-hp.sh.intel.com>
        <AM0PR05MB4866757033043CC007B5C9CBD15D0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191205060618.GD4196@zhen-hp.sh.intel.com>
        <AM0PR05MB4866C265B6C9D521A201609DD15C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191206080354.GA15502@zhen-hp.sh.intel.com>
        <79d0ca87-c6c7-18d5-6429-bb20041646ff@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D636944@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 3SqaN9miMMG9ZqNsI4aYtg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 03:33:23 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Parav Pandit <parav@mellanox.com>
> > Sent: Saturday, December 7, 2019 1:34 AM
> > 
> > On 12/6/2019 2:03 AM, Zhenyu Wang wrote:  
> > > On 2019.12.05 18:59:36 +0000, Parav Pandit wrote:  
> > >>>>  
> > >>>>> On 2019.11.07 20:37:49 +0000, Parav Pandit wrote:  
> > >>>>>> Hi,
> > >>>>>>  
> > >>>>>>> -----Original Message-----
> > >>>>>>> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org>  
> > On  
> > >>>>>>> Behalf Of Zhenyu Wang
> > >>>>>>> Sent: Thursday, October 24, 2019 12:08 AM
> > >>>>>>> To: kvm@vger.kernel.org
> > >>>>>>> Cc: alex.williamson@redhat.com; kwankhede@nvidia.com;
> > >>>>>>> kevin.tian@intel.com; cohuck@redhat.com
> > >>>>>>> Subject: [PATCH 0/6] VFIO mdev aggregated resources handling
> > >>>>>>>
> > >>>>>>> Hi,
> > >>>>>>>
> > >>>>>>> This is a refresh for previous send of this series. I got
> > >>>>>>> impression that some SIOV drivers would still deploy their own
> > >>>>>>> create and config method so stopped effort on this. But seems
> > >>>>>>> this would still be useful for some other SIOV driver which may
> > >>>>>>> simply want capability to aggregate resources. So here's refreshed  
> > >>> series.  
> > >>>>>>>
> > >>>>>>> Current mdev device create interface depends on fixed mdev type,
> > >>>>>>> which get uuid from user to create instance of mdev device. If
> > >>>>>>> user wants to use customized number of resource for mdev device,
> > >>>>>>> then only can create new  
> > >>>>>> Can you please give an example of 'resource'?
> > >>>>>> When I grep [1], [2] and [3], I couldn't find anything related to '  
> > >>> aggregate'.  
> > >>>>>
> > >>>>> The resource is vendor device specific, in SIOV spec there's ADI
> > >>>>> (Assignable Device Interface) definition which could be e.g queue
> > >>>>> for net device, context for gpu, etc. I just named this interface as  
> > >>> 'aggregate'  
> > >>>>> for aggregation purpose, it's not used in spec doc.
> > >>>>>  
> > >>>>
> > >>>> Some 'unknown/undefined' vendor specific resource just doesn't work.
> > >>>> Orchestration tool doesn't know which resource and what/how to  
> > configure  
> > >>> for which vendor.  
> > >>>> It has to be well defined.
> > >>>>
> > >>>> You can also find such discussion in recent lgpu DRM cgroup patches  
> > series  
> > >>> v4.  
> > >>>>
> > >>>> Exposing networking resource configuration in non-net namespace  
> > aware  
> > >>> mdev sysfs at PCI device level is no-go.  
> > >>>> Adding per file NET_ADMIN or other checks is not the approach we  
> > follow in  
> > >>> kernel.  
> > >>>>
> > >>>> devlink has been a subsystem though under net, that has very rich  
> > interface  
> > >>> for syscaller, device health, resource management and many more.  
> > >>>> Even though it is used by net driver today, its written for generic device  
> > >>> management at bus/device level.  
> > >>>>
> > >>>> Yuval has posted patches to manage PCI sub-devices [1] and updated  
> > version  
> > >>> will be posted soon which addresses comments.  

Always good to see tools that intend to manage arbitrary devices posted
only to the netdev list :-\

> > >>>>
> > >>>> For any device slice resource management of mdev, sub-function etc,  
> > we  
> > >>> should be using single kernel interface as devlink [2], [3].  

This seems impractical, mdevs and SR-IOV are both enumerated,
inspected, created, and removed in sysfs, where do we define what
features are manipulated vis sysfs versus devlink?  mdevs, by
definition, are vendor defined "chunks" of a thing.  We allow vendor
drivers to define different types, representing different
configurations of these chunks.  Often these different types are
incrementally bigger or smaller chunks of these things, but defining
what bigger and smaller means generically across vendors is an
impossible task.  Orchestration tools already need to know vendor
specific information in terms of what type of mdev device they want to
create and make use of.  The aggregation seems to simply augment that
vendor information, ie. 'type' and 'scale' are separate rather than
combined only behind just 'type'.

> > >>>>
> > >>>> [1]
> > >>>> https://lore.kernel.org/netdev/1573229926-30040-1-git-send-email-  
> > yuval  
> > >>>> av@mellanox.com/ [2]
> > >>>> http://man7.org/linux/man-pages/man8/devlink-dev.8.html
> > >>>> [3] http://man7.org/linux/man-pages/man8/devlink-resource.8.html
> > >>>>
> > >>>> Most modern device configuration that I am aware of is usually done  
> > via well  
> > >>> defined ioctl() of the subsystem (vhost, virtio, vfio, rdma, nvme and  
> > more) or  
> > >>> via netlink commands (net, devlink, rdma and more) not via sysfs.  
> > >>>>  
> > >>>
> > >>> Current vfio/mdev configuration is via documented sysfs ABI instead of  
> > other  
> > >>> ways. So this adhere to that way to introduce more configurable method  
> > on  
> > >>> mdev device for standard, it's optional and not actually vendor specific  
> > e.g vfio-  
> > >>> ap.
> > >>>  
> > >> Some unknown/undefined resource as 'aggregate' is just not an ABI.
> > >> It has to be well defined, as 'hardware_address', 'num_netdev_sqs' or  
> > something similar appropriate to that mdev device class.  
> > >> If user wants to set a parameter for a mdev regardless of vendor, they  
> > must have single way to do so.

Aggregation augments type, which is by definition vendor specific.
  
> > >
> > > The idea is not specific for some device class, but for each mdev
> > > type's resource, and be optional for each vendor. If more device class
> > > specific way is preferred, then we might have very different ways for
> > > different vendors. Better to avoid that, so here means to aggregate
> > > number of mdev type's resources for target instance, instead of defining
> > > kinds of mdev types for those number of resources.
> > >  
> > Parameter or attribute certainly can be optional.
> > But the way to aggregate them should not be vendor specific.
> > Look for some excellent existing examples across subsystems, for example
> > how you create aggregated netdev or block device is not depend on vendor
> > or underlying device type.  
> 
> I'd like to hear Alex's opinion on this. Today VFIO mdev supports two styles
> of "types" imo: fixed resource definition (most cases) and dynamic resource 
> definition (vfio-ap). In fixed style, a type has fixed association to a set of 
> vendor specific resources (resourceX=M, resourceY=N, ...). In dynamic case, 
> the user is allowed to specify actual resource X/Y/... backing the mdev 
> instance post its creation. In either case, the way to identify such association 
> or configurable knobs is vendor specific, maybe contained in optional 
> attributes (name and description) plus additional info in vendor documents.
> 
> Then the user is assumed to clearly understand the implication of the resource
> allocation under a given type, when creating a new mdev under this type.
> 
> If this assumption holds true, the aggregated attribute simply provides an
> extension in the same direction of fixed-style types but allowing for more 
> flexible linearly-increasing resource allocation. e.g. when using aggregate=2, 
> it means creating a instance with resourceX=2M, resourceY=2N, ... under 
> the specified type. Along this direction I didn't see the need of well-defined 
> vendor specific attributes here. When those are actually required, I suppose 
> the dynamic style would better fit. Or if the vendor driver thinks implementing 
> such aggregate feature will confuse its type definition, it's optional to not 
> doing so anyway.

Yep, though I don't think we can even define that aggregate=2 indicates
that every resources is doubled, it's going to have vendor specific
meaning.  Maybe this is what Parav is rejecting, but I don't see an
alternative.  For example, an mdev vGPU might have high level resources
like the number of execution units, graphics memory, display heads,
maximum resolution, etc.  Aggregation could affect one or all of these.
Orchestration tools already need to know the vendor specific type of
device they want to create, so it doesn't seem unreasonable that if
they use aggregation that they choose a type that aggregates the
resource(s) they need, but that aggregation is going to be specific to
the type.  Potentially as we think about adding "defined" sysfs
attributes for devices we could start with
$SYSFS_DEV_PATH/mdev/aggregation/type, where value written to type is a
vendor specific aggregation of that mdev type.  This allows us the
option that we might someday agree on specific resources that might be
aggregated in a common way (ex. ./aggregation/graphics_memory), but I'm
somewhat doubtful those would ever be pursued.  Thanks,

Alex

