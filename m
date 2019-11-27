Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E95F10AE55
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 11:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfK0K7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 05:59:17 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23537 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726267AbfK0K7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 05:59:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574852356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d3vy1tSD+75AOc1W4isJ3oQZhdb0GEOYttsw31Fy3lA=;
        b=RMbs3T333G/s+w6x8Atqn1Tg0m2DCI7rZi1nxScDjV6EKqSI3fbbqzbQso5iCCVe3pOnhg
        p63+pwctKLGwKgYqnRgRhWHOame0m6WsIADGdr4Y7MUnvX675O9l58Mn1ogd3xhdxzmX6+
        +6a5jg1NggPyofca6yqNj0JcCrWu/6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-UcxD0TuwMESSHJcJUhxLxQ-1; Wed, 27 Nov 2019 05:59:13 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B29A18A8C8B;
        Wed, 27 Nov 2019 10:59:11 +0000 (UTC)
Received: from [10.72.12.78] (ovpn-12-78.pek2.redhat.com [10.72.12.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B8FA608AC;
        Wed, 27 Nov 2019 10:59:00 +0000 (UTC)
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
 <22dd6ae3-03f4-1432-2935-8df5e9a449de@redhat.com>
 <AM0PR05MB48660C6FDCC2397045A03139D1490@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <e8ab3603-59e1-6e1c-67c2-e1a252ba0ac1@solarflare.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0b845456-54b2-564a-0979-ba55bcf3269c@redhat.com>
Date:   Wed, 27 Nov 2019 18:58:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e8ab3603-59e1-6e1c-67c2-e1a252ba0ac1@solarflare.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: UcxD0TuwMESSHJcJUhxLxQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/26 =E4=B8=8B=E5=8D=888:26, Martin Habets wrote:
> On 22/11/2019 16:19, Parav Pandit wrote:
>>
>>> From: Jason Wang <jasowang@redhat.com>
>>> Sent: Friday, November 22, 2019 3:14 AM
>>>
>>> On 2019/11/21 =E4=B8=8B=E5=8D=8811:10, Martin Habets wrote:
>>>> On 19/11/2019 04:08, Jason Wang wrote:
>>>>> On 2019/11/16 =E4=B8=8A=E5=8D=887:25, Parav Pandit wrote:
>>>>>> Hi Jeff,
>>>>>>
>>>>>>> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>>>>>>> Sent: Friday, November 15, 2019 4:34 PM
>>>>>>>
>>>>>>> From: Dave Ertman <david.m.ertman@intel.com>
>>>>>>>
>>>>>>> This is the initial implementation of the Virtual Bus,
>>>>>>> virtbus_device and virtbus_driver.=C2=A0 The virtual bus is a softw=
are
>>>>>>> based bus intended to support lightweight devices and drivers and
>>>>>>> provide matching between them and probing of the registered drivers=
.
>>>>>>>
>>>>>>> The primary purpose of the virual bus is to provide matching
>>>>>>> services and to pass the data pointer contained in the
>>>>>>> virtbus_device to the virtbus_driver during its probe call.=C2=A0 T=
his
>>>>>>> will allow two separate kernel objects to match up and start
>>> communication.
>>>>>> It is fundamental to know that rdma device created by virtbus_driver=
 will
>>> be anchored to which bus for an non abusive use.
>>>>>> virtbus or parent pci bus?
>>>>>> I asked this question in v1 version of this patch.
>>>>>>
>>>>>> Also since it says - 'to support lightweight devices', documenting t=
hat
>>> information is critical to avoid ambiguity.
>>>>>> Since for a while I am working on the subbus/subdev_bus/xbus/mdev [1=
]
>>> whatever we want to call it, it overlaps with your comment about 'to su=
pport
>>> lightweight devices'.
>>>>>> Hence let's make things crystal clear weather the purpose is 'only
>>> matching service' or also 'lightweight devices'.
>>>>>> If this is only matching service, lets please remove lightweight dev=
ices
>>> part..
>>>>> Yes, if it's matching + lightweight device, its function is almost a =
duplication
>>> of mdev. And I'm working on extending mdev[1] to be a generic module to
>>> support any types of virtual devices a while. The advantage of mdev is:
>>>>> 1) ready for the userspace driver (VFIO based)
>>>>> 2) have a sysfs/GUID based management interface
>>>> In my view this virtual-bus is more generic and more flexible than mde=
v.
>>>
>>> Even after the series [1] here?
> I have been following that series. It does make mdev more flexible, and a=
lmost turns it into a real bus.
> Even with those improvements to mdev the virtual-bus is in my view still =
more generic and more flexible,
> and hence more future-proof.


So the only difference so far is after that series is:

1) mdev has sysfs support
2) mdev has support from vfio

For 1) we can decouple that part to be more flexible, for 2) I think you=20
would still need that part other than inventing a new VFIO driver (e.g=20
vfio-virtual-bus)?


>
>>>> What for you are the advantages of mdev to me are some of it's
>>> disadvantages.
>>>> The way I see it we can provide rdma support in the driver using virtu=
al-bus.
>> This is fine, because it is only used for matching service.
>>
>>> Yes, but since it does matching only, you can do everything you want.
>>> But it looks to me Greg does not want a bus to be an API multiplexer. S=
o if a
>>> dedicated bus is desired, it won't be much of code to have a bus on you=
r own.
> I did not intend for it to be a multiplexer. And I very much prefer a gen=
eric bus over a any driver specific bus.
>
>> Right. virtbus shouldn't be a multiplexer.
>> Otherwise mdev can be improved (abused) exactly the way virtbus might. W=
here 'mdev m stands for multiplexer too'. :-)
>> No, we shouldn=E2=80=99t do that.
>>
>> Listening to Greg and Jason G, I agree that virtbus shouldn't be a multi=
plexer.
>> There are few basic differences between subfunctions and matching servic=
e device object.
>> Subfunctions over period of time will have several attributes, few that =
I think of right away are:
>> 1. BAR resource info, write combine info
>> 2. irq vectors details
>> 3. unique id assigned by user (while virtbus will not assign such user i=
d as they are auto created for matching service for PF/VF)
>> 4. rdma device created by matched driver resides on pci bus or parent de=
vice
>> While rdma and netdev created on over subfunctions are linked to their o=
wn 'struct device'.
> This is more aligned with my thinking as well, although I do not call the=
se items subfunctions.
> There can be different devices for different users, where multiple can be=
 active at the same time (with some constraints).
>
> One important thing to note is that there may not not be a netdev device.=
 What we traditionally call
> a "network driver" will then only manage the virtualised devices.
>
>> Due to that sysfs view for these two different types of devices is bit d=
ifferent.
>> Putting both on same bus just doesn't appear right with above fundamenta=
l differences of core layer.
> Can you explain which code layer you mean?
>
>>>> At the moment we would need separate mdev support in the driver for
>>>> vdpa, but I hope at some point mdev would become a layer on top of vir=
tual-
>>> bus.
>> How is it optimal to create multiple 'struct device' for single purpose?
>> Especially when one wants to create hundreds of such devices to begin wi=
th.
>> User facing tool should be able to select device type and place the devi=
ce on right bus.
> At this point I think it is not possible to create a solution that is opt=
imal right now for all use cases.


Probably yes.


> With the virtual bus we do have a solid foundation going forward, for the=
 users we know now and for
> future ones.


If I understand correctly, if multiplexer is not preferred. It would be=20
hard to have a bus on your own code, there's no much code could be reused.

Thanks


>   Optimisation is something that needs to happen over time, without break=
ing existing users.
>
> As for the user facing tool, the only one I know of that always works is =
"echo" into a sysfs file.
>
> Best regards,
> Martin
>

