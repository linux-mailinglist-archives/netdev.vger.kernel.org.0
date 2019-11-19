Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F63101A60
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfKSHhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:37:22 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30052 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725869AbfKSHhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:37:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574149040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V4HOW26B6UmWNYImZWcy25gysr0KYKZ6rlD1xLyvoHg=;
        b=ae9a0vO+w+0XjW1A4v5TDd7aC1BXz/BkN2/hjU+0HysyIpHQRK/YpaV4MU+2o644OKkti8
        pimiJT1S2RZhrcyzl5jhJjpTRyYGenwi8fKOmXEoRlraeDneJmcH7FvhvSz5CBjmRKjIfv
        cLVsNn41au3Ljcgd/1s9E3jfs5sScm4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-aEN0Kg2qOs6uEDeYJ11VJg-1; Tue, 19 Nov 2019 02:37:17 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 580D6477;
        Tue, 19 Nov 2019 07:37:15 +0000 (UTC)
Received: from [10.72.12.74] (ovpn-12-74.pek2.redhat.com [10.72.12.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BC992B1CB;
        Tue, 19 Nov 2019 07:37:04 +0000 (UTC)
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
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
Date:   Tue, 19 Nov 2019 15:37:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: aEN0Kg2qOs6uEDeYJ11VJg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/19 =E4=B8=8B=E5=8D=883:13, Parav Pandit wrote:
>> From: Jason Wang <jasowang@redhat.com>
>> Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bu=
s
>>
>>
> [..]
>
>> Probably, for virtio mdev we need more than just matching: life cycle
>> management, cooperation with VFIO and we also want to be prepared for
>> the device slicing (like sub functions).
> Well I am revising my patches to life cycle sub functions via devlink int=
erface for few reasons, as
>
> (a) avoid mdev bus abuse (still named as mdev in your v13 series, though =
it is actually for vfio-mdev)


Yes, but it could be simply renamed to "vfio-mdev".


> (b) support iommu


That is already supported by mdev.


> (c) manage and have coupling with devlink eswitch framework, which is ver=
y rich in several aspects


Good point.


> (d) get rid of limited sysfs interface for mdev creation, as netlink is s=
tandard and flexible to add params etc.


Standard but net specific.


>
> If you want to get a glimpse of old RFC work of my revised series, please=
 refer to [1].


Will do.


>
> Jiri, Jason, me think that even virtio accelerated devices will need eswi=
tch support. And hence, life cycling virtio accelerated devices via devlink=
 makes a lot of sense to us.
> This way user has single tool to choose what type of device he want to us=
e (similar to ip link add link type).
> So sub function flavour will be something like (virtio or sf).


Networking is only one of the types that is supported in virtio-mdev.=20
The codes are generic enough to support any kind of virtio device=20
(block, scsi, crypto etc). Sysfs is less flexible but type independent.=20
I agree that devlink is standard and feature richer but still network=20
specific. It's probably hard to add devlink to other type of physical=20
drivers. I'm thinking whether it's possible to combine syfs and devlink:=20
e.g the mdev is available only after the sub fuction is created and=20
fully configured by devlink.

Thanks


>
> So I am reviving my old RFC [1] back now in few days as actual patches ba=
sed on series [2].
>
> [1] https://lkml.org/lkml/2019/3/1/19
> [2] https://lore.kernel.org/linux-rdma/20191107160448.20962-1-parav@mella=
nox.com/
>

