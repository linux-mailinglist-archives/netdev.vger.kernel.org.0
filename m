Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337F61068AF
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 10:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfKVJOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 04:14:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46600 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726526AbfKVJOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 04:14:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574414068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iWuR/xiXoJz8XNdtmPyrzUwrAACjqWWaKc7K3C9SBjw=;
        b=QlcZToBA0hMWew0V/naJ3lnf4b652NcUmHbxE/xHxsLAVGi66JG2ru9wqOM/TBtI6DW0vw
        oziJg9yeFAH9CiGiFtLUHLkKwNZzPCQjcK36LV+qjZe9KwneLEKnmYKgG0hafcrCPCBkJg
        xWUNCNT6ONeTOrr9W0mMinLrVDrPPEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-U4pLxVscM8eEdnkBROBTpw-1; Fri, 22 Nov 2019 04:14:25 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3E5D107ACC4;
        Fri, 22 Nov 2019 09:14:22 +0000 (UTC)
Received: from [10.72.13.3] (ovpn-13-3.pek2.redhat.com [10.72.13.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D743326FC4;
        Fri, 22 Nov 2019 09:13:59 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Martin Habets <mhabets@solarflare.com>,
        Parav Pandit <parav@mellanox.com>,
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
 <30b968cf-0e11-a2c6-5b9f-5518df11dfb7@solarflare.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <22dd6ae3-03f4-1432-2935-8df5e9a449de@redhat.com>
Date:   Fri, 22 Nov 2019 17:13:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <30b968cf-0e11-a2c6-5b9f-5518df11dfb7@solarflare.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: U4pLxVscM8eEdnkBROBTpw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/21 =E4=B8=8B=E5=8D=8811:10, Martin Habets wrote:
> On 19/11/2019 04:08, Jason Wang wrote:
>> On 2019/11/16 =E4=B8=8A=E5=8D=887:25, Parav Pandit wrote:
>>> Hi Jeff,
>>>
>>>> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>>>> Sent: Friday, November 15, 2019 4:34 PM
>>>>
>>>> From: Dave Ertman <david.m.ertman@intel.com>
>>>>
>>>> This is the initial implementation of the Virtual Bus, virtbus_device =
and
>>>> virtbus_driver.=C2=A0 The virtual bus is a software based bus intended=
 to support
>>>> lightweight devices and drivers and provide matching between them and
>>>> probing of the registered drivers.
>>>>
>>>> The primary purpose of the virual bus is to provide matching services =
and to
>>>> pass the data pointer contained in the virtbus_device to the virtbus_d=
river
>>>> during its probe call.=C2=A0 This will allow two separate kernel objec=
ts to match up
>>>> and start communication.
>>>>
>>> It is fundamental to know that rdma device created by virtbus_driver wi=
ll be anchored to which bus for an non abusive use.
>>> virtbus or parent pci bus?
>>> I asked this question in v1 version of this patch.
>>>
>>> Also since it says - 'to support lightweight devices', documenting that=
 information is critical to avoid ambiguity.
>>>
>>> Since for a while I am working on the subbus/subdev_bus/xbus/mdev [1] w=
hatever we want to call it, it overlaps with your comment about 'to support=
 lightweight devices'.
>>> Hence let's make things crystal clear weather the purpose is 'only matc=
hing service' or also 'lightweight devices'.
>>> If this is only matching service, lets please remove lightweight device=
s part..
>>
>> Yes, if it's matching + lightweight device, its function is almost a dup=
lication of mdev. And I'm working on extending mdev[1] to be a generic modu=
le to support any types of virtual devices a while. The advantage of mdev i=
s:
>>
>> 1) ready for the userspace driver (VFIO based)
>> 2) have a sysfs/GUID based management interface
> In my view this virtual-bus is more generic and more flexible than mdev.


Even after the series [1] here?


> What for you are the advantages of mdev to me are some of it's disadvanta=
ges.
>
> The way I see it we can provide rdma support in the driver using virtual-=
bus.


Yes, but since it does matching only, you can do everything you want.=20
But it looks to me Greg does not want a bus to be an API multiplexer. So=20
if a dedicated bus is desired, it won't be much of code to have a bus on=20
your own.


> At the moment we would need separate mdev support in the driver for vdpa,=
 but I hope at some point mdev
> would become a layer on top of virtual-bus.
> Besides these users we also support internal tools for our hardware facto=
ry provisioning, and for testing/debugging.
> I could easily imagine such tools using a virtual-bus device. With mdev t=
hose interfaces would be more convoluted.


Can you give me an example?


>
>> So for 1, it's not clear that how userspace driver would be supported he=
re, or it's completely not being accounted in this series? For 2, it looks =
to me that this series leave it to the implementation, this means managemen=
t to learn several vendor specific interfaces which seems a burden.
>>
>> Note, technically Virtual Bus could be implemented on top of [1] with th=
e full lifecycle API.
> Seems easier to me to do that the other way around: mdev could be impleme=
nted on top of virtual-bus.


Probably, without the part of parent_ops, they are almost equal.

Thanks


>
> Best regards,
> Martin
>
>> [1] https://lkml.org/lkml/2019/11/18/261
>>
>>
>>> You additionally need modpost support for id table integration to modif=
o, modprobe and other tools.
>>> A small patch similar to this one [2] is needed.
>>> Please include in the series.
>>>
>>> [..]
>>
>> And probably a uevent method. But rethinking of this, matching through a=
 single virtual bus seems not good. What if driver want to do some specific=
 matching? E.g for virtio, we may want a vhost-net driver that only match n=
etworking device. With a single bus, it probably means you need another bus=
 on top and provide the virtio specific matching there. This looks not stra=
ightforward as allowing multiple type of buses.
>>
>> Thanks
>>

