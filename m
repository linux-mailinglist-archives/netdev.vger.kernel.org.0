Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21457117E30
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 04:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLJDd1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Dec 2019 22:33:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:36612 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbfLJDd0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 22:33:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 19:33:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,298,1571727600"; 
   d="scan'208";a="264436382"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Dec 2019 19:33:26 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 9 Dec 2019 19:33:26 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 19:33:25 -0800
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 9 Dec 2019 19:33:25 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.19]) with mapi id 14.03.0439.000;
 Tue, 10 Dec 2019 11:33:23 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Parav Pandit <parav@mellanox.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: RE: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Topic: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Index: AQHViikbbkH6FUlQ7kukEPc4R6T+S6d/vAGAgADEB4CAKXgtAIAA0ZQAgADYDgCAANsiAIAAnz8AgAXdxLA=
Date:   Tue, 10 Dec 2019 03:33:23 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D636944@SHSMSX104.ccr.corp.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
 <AM0PR05MB4866CA9B70A8BEC1868AF8C8D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108081925.GH4196@zhen-hp.sh.intel.com>
 <AM0PR05MB4866757033043CC007B5C9CBD15D0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191205060618.GD4196@zhen-hp.sh.intel.com>
 <AM0PR05MB4866C265B6C9D521A201609DD15C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191206080354.GA15502@zhen-hp.sh.intel.com>
 <79d0ca87-c6c7-18d5-6429-bb20041646ff@mellanox.com>
In-Reply-To: <79d0ca87-c6c7-18d5-6429-bb20041646ff@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOGE5NDBkNjUtODZmMC00OWU5LThlMjMtYTY4MDY0NWE0NWRjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNXNnKzB2eU8waGZ1UnRERk1ocktSeGtXUDNJMW00TXdzS0RuQU9FRzBXWlFFWTArcUd0Y0s4ZHNmSXdoS3I1ZSJ9
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Parav Pandit <parav@mellanox.com>
> Sent: Saturday, December 7, 2019 1:34 AM
> 
> On 12/6/2019 2:03 AM, Zhenyu Wang wrote:
> > On 2019.12.05 18:59:36 +0000, Parav Pandit wrote:
> >>>>
> >>>>> On 2019.11.07 20:37:49 +0000, Parav Pandit wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>>> -----Original Message-----
> >>>>>>> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org>
> On
> >>>>>>> Behalf Of Zhenyu Wang
> >>>>>>> Sent: Thursday, October 24, 2019 12:08 AM
> >>>>>>> To: kvm@vger.kernel.org
> >>>>>>> Cc: alex.williamson@redhat.com; kwankhede@nvidia.com;
> >>>>>>> kevin.tian@intel.com; cohuck@redhat.com
> >>>>>>> Subject: [PATCH 0/6] VFIO mdev aggregated resources handling
> >>>>>>>
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> This is a refresh for previous send of this series. I got
> >>>>>>> impression that some SIOV drivers would still deploy their own
> >>>>>>> create and config method so stopped effort on this. But seems
> >>>>>>> this would still be useful for some other SIOV driver which may
> >>>>>>> simply want capability to aggregate resources. So here's refreshed
> >>> series.
> >>>>>>>
> >>>>>>> Current mdev device create interface depends on fixed mdev type,
> >>>>>>> which get uuid from user to create instance of mdev device. If
> >>>>>>> user wants to use customized number of resource for mdev device,
> >>>>>>> then only can create new
> >>>>>> Can you please give an example of 'resource'?
> >>>>>> When I grep [1], [2] and [3], I couldn't find anything related to '
> >>> aggregate'.
> >>>>>
> >>>>> The resource is vendor device specific, in SIOV spec there's ADI
> >>>>> (Assignable Device Interface) definition which could be e.g queue
> >>>>> for net device, context for gpu, etc. I just named this interface as
> >>> 'aggregate'
> >>>>> for aggregation purpose, it's not used in spec doc.
> >>>>>
> >>>>
> >>>> Some 'unknown/undefined' vendor specific resource just doesn't work.
> >>>> Orchestration tool doesn't know which resource and what/how to
> configure
> >>> for which vendor.
> >>>> It has to be well defined.
> >>>>
> >>>> You can also find such discussion in recent lgpu DRM cgroup patches
> series
> >>> v4.
> >>>>
> >>>> Exposing networking resource configuration in non-net namespace
> aware
> >>> mdev sysfs at PCI device level is no-go.
> >>>> Adding per file NET_ADMIN or other checks is not the approach we
> follow in
> >>> kernel.
> >>>>
> >>>> devlink has been a subsystem though under net, that has very rich
> interface
> >>> for syscaller, device health, resource management and many more.
> >>>> Even though it is used by net driver today, its written for generic device
> >>> management at bus/device level.
> >>>>
> >>>> Yuval has posted patches to manage PCI sub-devices [1] and updated
> version
> >>> will be posted soon which addresses comments.
> >>>>
> >>>> For any device slice resource management of mdev, sub-function etc,
> we
> >>> should be using single kernel interface as devlink [2], [3].
> >>>>
> >>>> [1]
> >>>> https://lore.kernel.org/netdev/1573229926-30040-1-git-send-email-
> yuval
> >>>> av@mellanox.com/ [2]
> >>>> http://man7.org/linux/man-pages/man8/devlink-dev.8.html
> >>>> [3] http://man7.org/linux/man-pages/man8/devlink-resource.8.html
> >>>>
> >>>> Most modern device configuration that I am aware of is usually done
> via well
> >>> defined ioctl() of the subsystem (vhost, virtio, vfio, rdma, nvme and
> more) or
> >>> via netlink commands (net, devlink, rdma and more) not via sysfs.
> >>>>
> >>>
> >>> Current vfio/mdev configuration is via documented sysfs ABI instead of
> other
> >>> ways. So this adhere to that way to introduce more configurable method
> on
> >>> mdev device for standard, it's optional and not actually vendor specific
> e.g vfio-
> >>> ap.
> >>>
> >> Some unknown/undefined resource as 'aggregate' is just not an ABI.
> >> It has to be well defined, as 'hardware_address', 'num_netdev_sqs' or
> something similar appropriate to that mdev device class.
> >> If user wants to set a parameter for a mdev regardless of vendor, they
> must have single way to do so.
> >
> > The idea is not specific for some device class, but for each mdev
> > type's resource, and be optional for each vendor. If more device class
> > specific way is preferred, then we might have very different ways for
> > different vendors. Better to avoid that, so here means to aggregate
> > number of mdev type's resources for target instance, instead of defining
> > kinds of mdev types for those number of resources.
> >
> Parameter or attribute certainly can be optional.
> But the way to aggregate them should not be vendor specific.
> Look for some excellent existing examples across subsystems, for example
> how you create aggregated netdev or block device is not depend on vendor
> or underlying device type.

I'd like to hear Alex's opinion on this. Today VFIO mdev supports two styles
of "types" imo: fixed resource definition (most cases) and dynamic resource 
definition (vfio-ap). In fixed style, a type has fixed association to a set of 
vendor specific resources (resourceX=M, resourceY=N, ...). In dynamic case, 
the user is allowed to specify actual resource X/Y/... backing the mdev 
instance post its creation. In either case, the way to identify such association 
or configurable knobs is vendor specific, maybe contained in optional 
attributes (name and description) plus additional info in vendor documents.

Then the user is assumed to clearly understand the implication of the resource
allocation under a given type, when creating a new mdev under this type.

If this assumption holds true, the aggregated attribute simply provides an
extension in the same direction of fixed-style types but allowing for more 
flexible linearly-increasing resource allocation. e.g. when using aggregate=2, 
it means creating a instance with resourceX=2M, resourceY=2N, ... under 
the specified type. Along this direction I didn't see the need of well-defined 
vendor specific attributes here. When those are actually required, I suppose 
the dynamic style would better fit. Or if the vendor driver thinks implementing 
such aggregate feature will confuse its type definition, it's optional to not 
doing so anyway.

Thanks
Kevin
