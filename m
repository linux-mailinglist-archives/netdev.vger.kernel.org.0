Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0702C1EA2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbgKXHF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:05:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729240AbgKXHF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 02:05:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606201527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WEgwUJSaOxz7pcOpJ2XFy/ZHeqAA+vTTW1hHUGmZz18=;
        b=ZrCz5cenaA1qCk5780G+DE967s1aa/NjoHpa7FWV7QVigN5OLrFdGoMCRtH2PH9OTPxAnu
        DDOZVDK+zydJnYoplGX5DzYj/sEu3MM4rXvI8P3j5kPD1mqmk77IMDvKCP8xSiEh1tZ3fa
        oHeJduWcBorlxY30k4nceELOXQp1Hss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-DIkgPY3pNbCKMDZT0c6VXQ-1; Tue, 24 Nov 2020 02:05:23 -0500
X-MC-Unique: DIkgPY3pNbCKMDZT0c6VXQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 266933E756;
        Tue, 24 Nov 2020 07:05:21 +0000 (UTC)
Received: from [10.72.13.223] (ovpn-13-223.pek2.redhat.com [10.72.13.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D00B75D9CC;
        Tue, 24 Nov 2020 07:05:16 +0000 (UTC)
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
From:   Jason Wang <jasowang@redhat.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
 <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201117184954.GV917484@nvidia.com>
 <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <96e59cf0-1423-64af-1da9-bd740b393fa8@gmail.com>
 <20201119172930.11ab9e68@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAKgT0Uf4i9hrq6Z4dx03sv_ubVpZwKm5Tiz+-UwJp38cTyZg+g@mail.gmail.com>
 <102d20e1-c78f-09cb-fabb-efdc59f61eb8@intel.com>
 <1e7773b1-0954-257f-7355-c17b15ab6b8b@redhat.com>
Message-ID: <fe0a31e2-6384-f14f-87c9-dcf0f7f9fdcb@redhat.com>
Date:   Tue, 24 Nov 2020 15:05:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1e7773b1-0954-257f-7355-c17b15ab6b8b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/24 下午3:01, Jason Wang wrote:
>
> On 2020/11/21 上午3:04, Samudrala, Sridhar wrote:
>>
>>
>> On 11/20/2020 9:58 AM, Alexander Duyck wrote:
>>> On Thu, Nov 19, 2020 at 5:29 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>
>>>> On Wed, 18 Nov 2020 21:35:29 -0700 David Ahern wrote:
>>>>> On 11/18/20 7:14 PM, Jakub Kicinski wrote:
>>>>>> On Tue, 17 Nov 2020 14:49:54 -0400 Jason Gunthorpe wrote:
>>>>>>> On Tue, Nov 17, 2020 at 09:11:20AM -0800, Jakub Kicinski wrote:
>>>>>>>
>>>>>>>>> Just to refresh all our memory, we discussed and settled on 
>>>>>>>>> the flow
>>>>>>>>> in [2]; RFC [1] followed this discussion.
>>>>>>>>>
>>>>>>>>> vdpa tool of [3] can add one or more vdpa device(s) on top of 
>>>>>>>>> already
>>>>>>>>> spawned PF, VF, SF device.
>>>>>>>>
>>>>>>>> Nack for the networking part of that. It'd basically be VMDq.
>>>>>>>
>>>>>>> What are you NAK'ing?
>>>>>>
>>>>>> Spawning multiple netdevs from one device by slicing up its queues.
>>>>>
>>>>> Why do you object to that? Slicing up h/w resources for virtual what
>>>>> ever has been common practice for a long time.
>>>>
>>>> My memory of the VMDq debate is hazy, let me rope in Alex into this.
>>>> I believe the argument was that we should offload software constructs,
>>>> not create HW-specific APIs which depend on HW availability and
>>>> implementation. So the path we took was offloading macvlan.
>>>
>>> I think it somewhat depends on the type of interface we are talking
>>> about. What we were wanting to avoid was drivers spawning their own
>>> unique VMDq netdevs and each having a different way of doing it. The
>>> approach Intel went with was to use a MACVLAN offload to approach it.
>>> Although I would imagine many would argue the approach is somewhat
>>> dated and limiting since you cannot do many offloads on a MACVLAN
>>> interface.
>>
>> Yes. We talked about this at netdev 0x14 and the limitations of 
>> macvlan based offloads.
>> https://netdevconf.info/0x14/session.html?talk-hardware-acceleration-of-container-networking-interfaces 
>>
>>
>> Subfunction seems to be a good model to expose VMDq VSI or SIOV ADI 
>> as a netdev for kernel containers. AF_XDP ZC in a container is one of 
>> the usecase this would address. Today we have to pass the entire 
>> PF/VF to a container to do AF_XDP.
>>
>> Looks like the current model is to create a subfunction of a specific 
>> type on auxiliary bus, do some configuration to assign resources and 
>> then activate the subfunction.
>>
>>>
>>> With the VDPA case I believe there is a set of predefined virtio
>>> devices that are being emulated and presented so it isn't as if they
>>> are creating a totally new interface for this.
>
>
> vDPA doesn't have any limitation of how the devices is created or 
> implemented. It could be predefined or created dynamically. vDPA 
> leaves all of those to the parent device with the help of a unified 
> management API[1]. E.g It could be a PCI device (PF or VF), 
> sub-function or  software emulated devices.


Miss the link, https://www.spinics.net/lists/netdev/msg699374.html.

Thanks


>
>
>>>
>>> What I would be interested in seeing is if there are any other vendors
>>> that have reviewed this and sign off on this approach.
>
>
> For "this approach" do you mean vDPA subfucntion? My understanding is 
> that it's totally vendor specific, vDPA subsystem don't want to be 
> limited by a specific type of device.
>
>
>>> What we don't
>>> want to see is Nivida/Mellanox do this one way, then Broadcom or Intel
>>> come along later and have yet another way of doing this. We need an
>>> interface and feature set that will work for everyone in terms of how
>>> this will look going forward.
>
> For feature set,  it would be hard to force (we can have a 
> recommendation set of features) vendors to implement a common set of 
> features consider they can be negotiated. So the management interface 
> is expected to implement features like cpu clusters in order to make 
> sure the migration compatibility, or qemu can assist for the missing 
> feature with performance lose.
>
> Thanks
>
>

