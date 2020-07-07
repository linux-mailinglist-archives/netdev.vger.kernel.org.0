Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9B3216970
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 11:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgGGJra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 05:47:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36753 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727090AbgGGJr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 05:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594115245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HhregYdN+P/IVgyp6XA/13UYgTUXcNUVAnQLSL5XbIE=;
        b=eoWPZABcgmpV/UxaX0FO10cHo3LrplvbcFaIJ18rWgOAk7q9m3tKo10RUA39C2Zgc5815t
        pD2sjYdNtGAbn5EF1YKHGFK1bk7YHozdzo4lUdZBpMJo9z/7RWYWDFT7t9J5eM5aM2P7pR
        MHBInaElewAdXL3H62fHVa/nFBXxN10=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-02kPJQWKO3-yvLnR-dabfg-1; Tue, 07 Jul 2020 05:47:20 -0400
X-MC-Unique: 02kPJQWKO3-yvLnR-dabfg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE3B9800406;
        Tue,  7 Jul 2020 09:47:17 +0000 (UTC)
Received: from [10.72.13.254] (ovpn-13-254.pek2.redhat.com [10.72.13.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F6AD5C1BB;
        Tue,  7 Jul 2020 09:47:05 +0000 (UTC)
Subject: Re: [RFC PATCH 00/22] Enhance VHOST to enable SoC-to-SoC
 communication
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200702082143.25259-1-kishon@ti.com>
 <20200702055026-mutt-send-email-mst@kernel.org>
 <603970f5-3289-cd53-82a9-aa62b292c552@redhat.com>
 <14c6cad7-9361-7fa4-e1c6-715ccc7e5f6b@ti.com>
 <59fd6a0b-8566-44b7-3dae-bb52b468219b@redhat.com>
 <ce9eb6a5-cd3a-a390-5684-525827b30f64@ti.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <da2b671c-b05d-a57f-7bdf-8b1043a41240@redhat.com>
Date:   Tue, 7 Jul 2020 17:47:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ce9eb6a5-cd3a-a390-5684-525827b30f64@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/6 下午5:32, Kishon Vijay Abraham I wrote:
> Hi Jason,
>
> On 7/3/2020 12:46 PM, Jason Wang wrote:
>> On 2020/7/2 下午9:35, Kishon Vijay Abraham I wrote:
>>> Hi Jason,
>>>
>>> On 7/2/2020 3:40 PM, Jason Wang wrote:
>>>> On 2020/7/2 下午5:51, Michael S. Tsirkin wrote:
>>>>> On Thu, Jul 02, 2020 at 01:51:21PM +0530, Kishon Vijay Abraham I wrote:
>>>>>> This series enhances Linux Vhost support to enable SoC-to-SoC
>>>>>> communication over MMIO. This series enables rpmsg communication between
>>>>>> two SoCs using both PCIe RC<->EP and HOST1-NTB-HOST2
>>>>>>
>>>>>> 1) Modify vhost to use standard Linux driver model
>>>>>> 2) Add support in vring to access virtqueue over MMIO
>>>>>> 3) Add vhost client driver for rpmsg
>>>>>> 4) Add PCIe RC driver (uses virtio) and PCIe EP driver (uses vhost) for
>>>>>>       rpmsg communication between two SoCs connected to each other
>>>>>> 5) Add NTB Virtio driver and NTB Vhost driver for rpmsg communication
>>>>>>       between two SoCs connected via NTB
>>>>>> 6) Add configfs to configure the components
>>>>>>
>>>>>> UseCase1 :
>>>>>>
>>>>>>     VHOST RPMSG                     VIRTIO RPMSG
>>>>>>          +                               +
>>>>>>          |                               |
>>>>>>          |                               |
>>>>>>          |                               |
>>>>>>          |                               |
>>>>>> +-----v------+                 +------v-------+
>>>>>> |   Linux    |                 |     Linux    |
>>>>>> |  Endpoint  |                 | Root Complex |
>>>>>> |            <----------------->              |
>>>>>> |            |                 |              |
>>>>>> |    SOC1    |                 |     SOC2     |
>>>>>> +------------+                 +--------------+
>>>>>>
>>>>>> UseCase 2:
>>>>>>
>>>>>>         VHOST RPMSG                                      VIRTIO RPMSG
>>>>>>              +                                                 +
>>>>>>              |                                                 |
>>>>>>              |                                                 |
>>>>>>              |                                                 |
>>>>>>              |                                                 |
>>>>>>       +------v------+                                   +------v------+
>>>>>>       |             |                                   |             |
>>>>>>       |    HOST1    |                                   |    HOST2    |
>>>>>>       |             |                                   |             |
>>>>>>       +------^------+                                   +------^------+
>>>>>>              |                                                 |
>>>>>>              |                                                 |
>>>>>> +---------------------------------------------------------------------+
>>>>>> |  +------v------+                                   +------v------+  |
>>>>>> |  |             |                                   |             |  |
>>>>>> |  |     EP      |                                   |     EP      |  |
>>>>>> |  | CONTROLLER1 |                                   | CONTROLLER2 |  |
>>>>>> |  |             <----------------------------------->             |  |
>>>>>> |  |             |                                   |             |  |
>>>>>> |  |             |                                   |             |  |
>>>>>> |  |             |  SoC With Multiple EP Instances   |             |  |
>>>>>> |  |             |  (Configured using NTB Function)  |             |  |
>>>>>> |  +-------------+                                   +-------------+  |
>>>>>> +---------------------------------------------------------------------+
>>>>>>
>>>>>> Software Layering:
>>>>>>
>>>>>> The high-level SW layering should look something like below. This series
>>>>>> adds support only for RPMSG VHOST, however something similar should be
>>>>>> done for net and scsi. With that any vhost device (PCI, NTB, Platform
>>>>>> device, user) can use any of the vhost client driver.
>>>>>>
>>>>>>
>>>>>>        +----------------+  +-----------+  +------------+  +----------+
>>>>>>        |  RPMSG VHOST   |  | NET VHOST |  | SCSI VHOST |  |    X     |
>>>>>>        +-------^--------+  +-----^-----+  +-----^------+  +----^-----+
>>>>>>                |                 |              |              |
>>>>>>                |                 |              |              |
>>>>>>                |                 |              |              |
>>>>>> +-----------v-----------------v--------------v--------------v----------+
>>>>>> |                            VHOST CORE                                |
>>>>>> +--------^---------------^--------------------^------------------^-----+
>>>>>>             |               |                    |                  |
>>>>>>             |               |                    |                  |
>>>>>>             |               |                    |                  |
>>>>>> +--------v-------+  +----v------+  +----------v----------+  +----v-----+
>>>>>> |  PCI EPF VHOST |  | NTB VHOST |  |PLATFORM DEVICE VHOST|  |    X     |
>>>>>> +----------------+  +-----------+  +---------------------+  +----------+
>>>>>>
>>>>>> This was initially proposed here [1]
>>>>>>
>>>>>> [1] -> https://lore.kernel.org/r/2cf00ec4-1ed6-f66e-6897-006d1a5b6390@ti.com
>>>>> I find this very interesting. A huge patchset so will take a bit
>>>>> to review, but I certainly plan to do that. Thanks!
>>>> Yes, it would be better if there's a git branch for us to have a look.
>>> I've pushed the branch
>>> https://github.com/kishon/linux-wip.git vhost_rpmsg_pci_ntb_rfc
>>
>> Thanks
>>
>>
>>>> Btw, I'm not sure I get the big picture, but I vaguely feel some of the work is
>>>> duplicated with vDPA (e.g the epf transport or vhost bus).
>>> This is about connecting two different HW systems both running Linux and
>>> doesn't necessarily involve virtualization.
>>
>> Right, this is something similar to VOP
>> (Documentation/misc-devices/mic/mic_overview.rst). The different is the
>> hardware I guess and VOP use userspace application to implement the device.
> I'd also like to point out, this series tries to have communication between two
> SoCs in vendor agnostic way. Since this series solves for 2 usecases (PCIe
> RC<->EP and NTB), for the NTB case it directly plugs into NTB framework and any
> of the HW in NTB below should be able to use a virtio-vhost communication
>
> #ls drivers/ntb/hw/
> amd  epf  idt  intel  mscc
>
> And similarly for the PCIe RC<->EP communication, this adds a generic endpoint
> function driver and hence any SoC that supports configurable PCIe endpoint can
> use virtio-vhost communication
>
> # ls drivers/pci/controller/dwc/*ep*
> drivers/pci/controller/dwc/pcie-designware-ep.c
> drivers/pci/controller/dwc/pcie-uniphier-ep.c
> drivers/pci/controller/dwc/pci-layerscape-ep.c


Thanks for those backgrounds.


>
>>
>>>    So there is no guest or host as in
>>> virtualization but two entirely different systems connected via PCIe cable, one
>>> acting as guest and one as host. So one system will provide virtio
>>> functionality reserving memory for virtqueues and the other provides vhost
>>> functionality providing a way to access the virtqueues in virtio memory. One is
>>> source and the other is sink and there is no intermediate entity. (vhost was
>>> probably intermediate entity in virtualization?)
>>
>> (Not a native English speaker) but "vhost" could introduce some confusion for
>> me since it was use for implementing virtio backend for userspace drivers. I
>> guess "vringh" could be better.
> Initially I had named this vringh but later decided to choose vhost instead of
> vringh. vhost is still a virtio backend (not necessarily userspace) though it
> now resides in an entirely different system. Whatever virtio is for a frontend
> system, vhost can be that for a backend system. vring can be for accessing
> virtqueue and can be used either in frontend or backend.


Ok.


>>
>>>> Have you considered to implement these through vDPA?
>>> IIUC vDPA only provides an interface to userspace and an in-kernel rpmsg driver
>>> or vhost net driver is not provided.
>>>
>>> The HW connection looks something like https://pasteboard.co/JfMVVHC.jpg
>>> (usecase2 above),
>>
>> I see.
>>
>>
>>>    all the boards run Linux. The middle board provides NTB
>>> functionality and board on either side provides virtio/vhost functionality and
>>> transfer data using rpmsg.
>>
>> So I wonder whether it's worthwhile for a new bus. Can we use the existed
>> virtio-bus/drivers? It might work as, except for the epf transport, we can
>> introduce a epf "vhost" transport driver.
> IMHO we'll need two buses one for frontend and other for backend because the
> two components can then co-operate/interact with each other to provide a
> functionality. Though both will seemingly provide similar callbacks, they are
> both provide symmetrical or complimentary funcitonality and need not be same or
> identical.
>
> Having the same bus can also create sequencing issues.
>
> If you look at virtio_dev_probe() of virtio_bus
>
> device_features = dev->config->get_features(dev);
>
> Now if we use same bus for both front-end and back-end, both will try to
> get_features when there has been no set_features. Ideally vhost device should
> be initialized first with the set of features it supports. Vhost and virtio
> should use "status" and "features" complimentarily and not identically.


Yes, but there's no need for doing status/features passthrough in epf 
vhost drivers.b


>
> virtio device (or frontend) cannot be initialized before vhost device (or
> backend) gets initialized with data such as features. Similarly vhost (backend)
> cannot access virqueues or buffers before virtio (frontend) sets
> VIRTIO_CONFIG_S_DRIVER_OK whereas that requirement is not there for virtio as
> the physical memory for virtqueues are created by virtio (frontend).


epf vhost drivers need to implement two devices: vhost(vringh) device 
and virtio device (which is a mediated device). The vhost(vringh) device 
is doing feature negotiation with the virtio device via RC/EP or NTB. 
The virtio device is doing feature negotiation with local virtio 
drivers. If there're feature mismatch, epf vhost drivers and do 
mediation between them.


>
>> It will have virtqueues but only used for the communication between itself and
>> uppter virtio driver. And it will have vringh queues which will be probe by
>> virtio epf transport drivers. And it needs to do datacopy between virtqueue and
>> vringh queues.
>>
>> It works like:
>>
>> virtio drivers <- virtqueue/virtio-bus -> epf vhost drivers <- vringh queue/epf>
>>
>> The advantages is that there's no need for writing new buses and drivers.
> I think this will work however there is an addtional copy between vringh queue
> and virtqueue,


I think not? E.g in use case 1), if we stick to virtio bus, we will have:

virtio-rpmsg (EP) <- virtio ring(1) -> epf vhost driver (EP) <- virtio 
ring(2) -> virtio pci (RC) <-> virtio rpmsg (RC)

What epf vhost driver did is to read from virtio ring(1) about the 
buffer len and addr and them DMA to Linux(RC)?


> in some cases adds latency because of forwarding interrupts
> between vhost and virtio driver, vhost drivers providing features (which means
> it has to be aware of which virtio driver will be connected).
> virtio drivers (front end) generally access the buffers from it's local memory
> but when in backend it can access over MMIO (like PCI EPF or NTB) or userspace.
>> Does this make sense?
> Two copies in my opinion is an issue but lets get others opinions as well.


Sure.


>
> Thanks for your suggestions!


You're welcome.

Thanks


>
> Regards
> Kishon
>
>> Thanks
>>
>>
>>> Thanks
>>> Kishon
>>>
>>>> Thanks
>>>>
>>>>
>>>>>> Kishon Vijay Abraham I (22):
>>>>>>      vhost: Make _feature_ bits a property of vhost device
>>>>>>      vhost: Introduce standard Linux driver model in VHOST
>>>>>>      vhost: Add ops for the VHOST driver to configure VHOST device
>>>>>>      vringh: Add helpers to access vring in MMIO
>>>>>>      vhost: Add MMIO helpers for operations on vhost virtqueue
>>>>>>      vhost: Introduce configfs entry for configuring VHOST
>>>>>>      virtio_pci: Use request_threaded_irq() instead of request_irq()
>>>>>>      rpmsg: virtio_rpmsg_bus: Disable receive virtqueue callback when
>>>>>>        reading messages
>>>>>>      rpmsg: Introduce configfs entry for configuring rpmsg
>>>>>>      rpmsg: virtio_rpmsg_bus: Add Address Service Notification support
>>>>>>      rpmsg: virtio_rpmsg_bus: Move generic rpmsg structure to
>>>>>>        rpmsg_internal.h
>>>>>>      virtio: Add ops to allocate and free buffer
>>>>>>      rpmsg: virtio_rpmsg_bus: Use virtio_alloc_buffer() and
>>>>>>        virtio_free_buffer()
>>>>>>      rpmsg: Add VHOST based remote processor messaging bus
>>>>>>      samples/rpmsg: Setup delayed work to send message
>>>>>>      samples/rpmsg: Wait for address to be bound to rpdev for sending
>>>>>>        message
>>>>>>      rpmsg.txt: Add Documentation to configure rpmsg using configfs
>>>>>>      virtio_pci: Add VIRTIO driver for VHOST on Configurable PCIe Endpoint
>>>>>>        device
>>>>>>      PCI: endpoint: Add EP function driver to provide VHOST interface
>>>>>>      NTB: Add a new NTB client driver to implement VIRTIO functionality
>>>>>>      NTB: Add a new NTB client driver to implement VHOST functionality
>>>>>>      NTB: Describe the ntb_virtio and ntb_vhost client in the documentation
>>>>>>
>>>>>>     Documentation/driver-api/ntb.rst              |   11 +
>>>>>>     Documentation/rpmsg.txt                       |   56 +
>>>>>>     drivers/ntb/Kconfig                           |   18 +
>>>>>>     drivers/ntb/Makefile                          |    2 +
>>>>>>     drivers/ntb/ntb_vhost.c                       |  776 +++++++++++
>>>>>>     drivers/ntb/ntb_virtio.c                      |  853 ++++++++++++
>>>>>>     drivers/ntb/ntb_virtio.h                      |   56 +
>>>>>>     drivers/pci/endpoint/functions/Kconfig        |   11 +
>>>>>>     drivers/pci/endpoint/functions/Makefile       |    1 +
>>>>>>     .../pci/endpoint/functions/pci-epf-vhost.c    | 1144 ++++++++++++++++
>>>>>>     drivers/rpmsg/Kconfig                         |   10 +
>>>>>>     drivers/rpmsg/Makefile                        |    3 +-
>>>>>>     drivers/rpmsg/rpmsg_cfs.c                     |  394 ++++++
>>>>>>     drivers/rpmsg/rpmsg_core.c                    |    7 +
>>>>>>     drivers/rpmsg/rpmsg_internal.h                |  136 ++
>>>>>>     drivers/rpmsg/vhost_rpmsg_bus.c               | 1151 +++++++++++++++++
>>>>>>     drivers/rpmsg/virtio_rpmsg_bus.c              |  184 ++-
>>>>>>     drivers/vhost/Kconfig                         |    1 +
>>>>>>     drivers/vhost/Makefile                        |    2 +-
>>>>>>     drivers/vhost/net.c                           |   10 +-
>>>>>>     drivers/vhost/scsi.c                          |   24 +-
>>>>>>     drivers/vhost/test.c                          |   17 +-
>>>>>>     drivers/vhost/vdpa.c                          |    2 +-
>>>>>>     drivers/vhost/vhost.c                         |  730 ++++++++++-
>>>>>>     drivers/vhost/vhost_cfs.c                     |  341 +++++
>>>>>>     drivers/vhost/vringh.c                        |  332 +++++
>>>>>>     drivers/vhost/vsock.c                         |   20 +-
>>>>>>     drivers/virtio/Kconfig                        |    9 +
>>>>>>     drivers/virtio/Makefile                       |    1 +
>>>>>>     drivers/virtio/virtio_pci_common.c            |   25 +-
>>>>>>     drivers/virtio/virtio_pci_epf.c               |  670 ++++++++++
>>>>>>     include/linux/mod_devicetable.h               |    6 +
>>>>>>     include/linux/rpmsg.h                         |    6 +
>>>>>>     {drivers/vhost => include/linux}/vhost.h      |  132 +-
>>>>>>     include/linux/virtio.h                        |    3 +
>>>>>>     include/linux/virtio_config.h                 |   42 +
>>>>>>     include/linux/vringh.h                        |   46 +
>>>>>>     samples/rpmsg/rpmsg_client_sample.c           |   32 +-
>>>>>>     tools/virtio/virtio_test.c                    |    2 +-
>>>>>>     39 files changed, 7083 insertions(+), 183 deletions(-)
>>>>>>     create mode 100644 drivers/ntb/ntb_vhost.c
>>>>>>     create mode 100644 drivers/ntb/ntb_virtio.c
>>>>>>     create mode 100644 drivers/ntb/ntb_virtio.h
>>>>>>     create mode 100644 drivers/pci/endpoint/functions/pci-epf-vhost.c
>>>>>>     create mode 100644 drivers/rpmsg/rpmsg_cfs.c
>>>>>>     create mode 100644 drivers/rpmsg/vhost_rpmsg_bus.c
>>>>>>     create mode 100644 drivers/vhost/vhost_cfs.c
>>>>>>     create mode 100644 drivers/virtio/virtio_pci_epf.c
>>>>>>     rename {drivers/vhost => include/linux}/vhost.h (66%)
>>>>>>
>>>>>> -- 
>>>>>> 2.17.1
>>>>>>

