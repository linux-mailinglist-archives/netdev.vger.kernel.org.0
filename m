Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36501019CA
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 07:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfKSGvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 01:51:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53430 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728033AbfKSGvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 01:51:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574146306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hX/zeLvZ53085kniihStb7+sdQx7Tne25n9PV2JR6Kk=;
        b=GNg5srdL5VWXuP/8bPeKe6RWp9BUtayV68T55cXk114s7tilqkpu28PWISOpLI2cy8jHS5
        Lhwt+klp7nmJxQYhCGETfVCG8EkqZSKWWMXg9SY8sOj9bdV+NB76RNjIcaZoTUzrsRcPBK
        +EE5XyAa93/PSZ9N/iA50Tnng0Gd+cA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-zDJqApmwN7KP60fKXZq5hA-1; Tue, 19 Nov 2019 01:51:43 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55F431005509;
        Tue, 19 Nov 2019 06:51:41 +0000 (UTC)
Received: from [10.72.12.74] (ovpn-12-74.pek2.redhat.com [10.72.12.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6059E614F2;
        Tue, 19 Nov 2019 06:51:31 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
Date:   Tue, 19 Nov 2019 14:51:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: zDJqApmwN7KP60fKXZq5hA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/19 =E4=B8=8B=E5=8D=8812:36, Parav Pandit wrote:
> Hi Jason Wang,
>
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Monday, November 18, 2019 10:08 PM
>>
>> On 2019/11/16 =E4=B8=8A=E5=8D=887:25, Parav Pandit wrote:
>>> Hi Jeff,
>>>
>>>> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>>>> Sent: Friday, November 15, 2019 4:34 PM
>>>>
>>>> From: Dave Ertman <david.m.ertman@intel.com>
>>>>
>>>> This is the initial implementation of the Virtual Bus, virtbus_device
>>>> and virtbus_driver.  The virtual bus is a software based bus intended
>>>> to support lightweight devices and drivers and provide matching
>>>> between them and probing of the registered drivers.
>>>>
>>>> The primary purpose of the virual bus is to provide matching services
>>>> and to pass the data pointer contained in the virtbus_device to the
>>>> virtbus_driver during its probe call.  This will allow two separate
>>>> kernel objects to match up and start communication.
>>>>
>>> It is fundamental to know that rdma device created by virtbus_driver wi=
ll be
>> anchored to which bus for an non abusive use.
>>> virtbus or parent pci bus?
>>> I asked this question in v1 version of this patch.
>>>
>>> Also since it says - 'to support lightweight devices', documenting that
>> information is critical to avoid ambiguity.
>>> Since for a while I am working on the subbus/subdev_bus/xbus/mdev [1]
>> whatever we want to call it, it overlaps with your comment about 'to sup=
port
>> lightweight devices'.
>>> Hence let's make things crystal clear weather the purpose is 'only matc=
hing
>> service' or also 'lightweight devices'.
>>> If this is only matching service, lets please remove lightweight device=
s part..
>>
>> Yes, if it's matching + lightweight device, its function is almost a dup=
lication of
>> mdev. And I'm working on extending mdev[1] to be a generic module to
>> support any types of virtual devices a while. The advantage of mdev is:
>>
>> 1) ready for the userspace driver (VFIO based)
>> 2) have a sysfs/GUID based management interface
>>
>> So for 1, it's not clear that how userspace driver would be supported he=
re, or
>> it's completely not being accounted in this series? For 2, it looks to m=
e that this
>> series leave it to the implementation, this means management to learn se=
veral
>> vendor specific interfaces which seems a burden.
>>
>> Note, technically Virtual Bus could be implemented on top of [1] with th=
e full
>> lifecycle API.
>>
>> [1] https://lkml.org/lkml/2019/11/18/261
>>
>>
>>> You additionally need modpost support for id table integration to modif=
o,
>> modprobe and other tools.
>>> A small patch similar to this one [2] is needed.
>>> Please include in the series.
>>>
>>> [..]
>>
>> And probably a uevent method. But rethinking of this, matching through a
>> single virtual bus seems not good. What if driver want to do some specif=
ic
>> matching? E.g for virtio, we may want a vhost-net driver that only match
>> networking device. With a single bus, it probably means you need another=
 bus
>> on top and provide the virtio specific matching there.
>> This looks not straightforward as allowing multiple type of buses.
>>
> The purpose of the bus is to attach two drivers,


Right, I just start to think whether it was generic to support the case=20
as virtio or mdev to avoid function duplications.


>   mlx5_core (creator of netdevices) and mlx5_ib (create of rdma devices) =
on single PCI function.
> Meaning 'multiple classes of devices' are created on top of single underl=
ying parent device.


This is not what I read, the doc said:

"
+One use case example is an rdma driver needing to connect with several
+different types of PCI LAN devices to be able to request resources from
+them (queue sets).=C2=A0 Each LAN driver that supports rdma will register =
a
+virtbus_device on the virtual bus for each physical function. The rdma
+driver will register as a virtbus_driver on the virtual bus to be
+matched up with multiple virtbus_devices and receive a pointer to a
+struct containing the callbacks that the PCI LAN drivers support for
+registering with them.

"

So it means to connect a single rdma driver with several RDMA capable=20
LAN drivers on top of several PCI functions. If this is true, I'm not=20
quite sure the advantage of using a bus since it's more like aggregation=20
as what bond/team did.


>
> So bus is just the 'matching service' and nothing more. It is not meant t=
o address virtio, mdev, sub functions usecases.


Probably, for virtio mdev we need more than just matching: life cycle=20
management, cooperation with VFIO and we also want to be prepared for=20
the device slicing (like sub functions).

Thanks

