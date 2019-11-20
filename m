Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC5C10326F
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 05:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfKTEI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 23:08:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57047 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727378AbfKTEI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 23:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574222936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eKMsh0I0427Hc47ZGW8U4JW4E9uwhWhpTorO0a8P+g4=;
        b=ODuXaynLGIzXPNxCEkXq356X22q8gyAiwhclsFpPXNMrM894uphPHM5kHNQ5cOpy4hSs+Q
        fpUc5EPz7bGV0xiO44y5DGPUqEyzTrgx+CbV+dSphlD9wIJB/ZFyIRAR/eJG28jubqnixV
        zRjW7yEDGGLxyLHZE82Qw2VatWDpnPQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-S5qix1UzPDm6KZ0sYsMppA-1; Tue, 19 Nov 2019 23:08:53 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC27D801FA1;
        Wed, 20 Nov 2019 04:08:50 +0000 (UTC)
Received: from [10.72.12.82] (ovpn-12-82.pek2.redhat.com [10.72.12.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C783C6063A;
        Wed, 20 Nov 2019 04:08:02 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <AM0PR05MB486605742430D120769F6C45D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <743601510.35622214.1574219728585.JavaMail.zimbra@redhat.com>
 <AM0PR05MB48664221FB6B1C14BDF6C74AD14F0@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <21106743-57b2-2ca7-258c-e37a0880c70f@redhat.com>
Date:   Wed, 20 Nov 2019 12:07:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB48664221FB6B1C14BDF6C74AD14F0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: S5qix1UzPDm6KZ0sYsMppA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/20 =E4=B8=8A=E5=8D=8811:38, Parav Pandit wrote:
>
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Tuesday, November 19, 2019 9:15 PM
>>
>> ----- Original Message -----
>>>
>>>> From: Jason Wang <jasowang@redhat.com>
>>>> Sent: Tuesday, November 19, 2019 1:37 AM
>>>>
>>> Nop. Devlink is NOT net specific. It works at the bus/device level.
>>> Any block/scsi/crypto can register devlink instance and implement the
>>> necessary ops as long as device has bus.
>>>
>> Well, uapi/linux/devlink.h told me:
>>
>> "
>>   * include/uapi/linux/devlink.h - Network physical device Netlink inter=
face "
>>
>> And the userspace tool was packaged into iproute2, the command was named
>> as "TC", "PORT", "ESWITCH". All of those were strong hints that it was n=
etwork
>> specific. Even for networking, only few vendors choose to implement this=
.
>>
> It is under iproute2 tool but it is not limited to networking.
> Though today most users are networking drivers.
>
> I do not know how ovs offloads are done without devlink by other vendors =
doing in-kernel drivers.
>
>> So technically it could be extended but how hard it can be achieved in r=
eality?
>>
> What are the missing things?
> I am extending it for subfunctions lifecycle. I see virtio as yet another=
 flavour/type of subfunction.


Just to make sure we're on the same page. Sub function is only one of=20
the possible cases for virtio. As I replied in another thread, we had=20
already had NIC that does virtio at PF or VF level. For reality, I mean=20
the effort spent on convincing all vendors to use devlink.


>
>> I still don't see why devlink is conflicted with GUID/sysfs, you can hoo=
k sysfs
> It is not conflicting. If you look at what all devlink infrastructure pro=
vides, you will end up replicating all of it via sysfs..


To clarify, I'm not saying duplicating all stuffs through sysfs. I meant=20
whether we can:

1) create sub fucntion and do must to have pre configuration through=20
devlink
2) only after sub function is created one more available instance was=20
added and shown through sysfs
3) user can choose to create and use that mdev instance as it did for=20
other type of device like vGPU
4) devlink can still use to report other stuffs


> It got syscaller support too, which is great for validation.
> I have posted subfunction series with mdev and used devlink for all rest =
of the esw and mgmt. interface to utilize it.
>
> sriov via sysfs and devlink sriov/esw handling has some severe locking is=
sues, mainly because they are from two different interfaces.
>
>> events to devlink or do post or pre configuration through devlink. This =
is much
>> more easier than forcing all vendors to use devlink.
>>
> It is not about forcing. It is about leveraging existing kernel framework=
 available without reinventing the wheel.
> I am 100% sure, implementing health, dumps, traces, reporters, syscaller,=
 monitors, interrupt configs, extending params via sysfs will be no-go.
> sysfs is not meant for such things anymore. Any modern device management =
will need all of it.


I'm not familiar with other type of devices, but they should have their=20
own vendor specific way to do that. That the real problems.

Thanks


