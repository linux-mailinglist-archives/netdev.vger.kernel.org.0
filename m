Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B41F2F7257
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 06:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733067AbhAOFkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 00:40:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727654AbhAOFkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 00:40:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610689131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xm+u8FPGbJ3hwDDdc/PpE8k86jKpY39ODWHrF9Rtkm4=;
        b=Z+59mucsZUy9tP9ywk2bRvFsGAkIA4KU8FXUJbV7gX/lgq04j5Mm2StT81/6duJUBklKRQ
        nHe7M3nshwW/rTcXoUkNCIofcPveGh0vcxSgBMYXdJLULzO3QEC/KEcAVwZi1aBzhWdP2L
        9rkGz5dA9dcGty1oHydn6udD7HxHfgE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-Ch0gzu0FOuW4-niBFcx5AQ-1; Fri, 15 Jan 2021 00:38:49 -0500
X-MC-Unique: Ch0gzu0FOuW4-niBFcx5AQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 228151005D4C;
        Fri, 15 Jan 2021 05:38:48 +0000 (UTC)
Received: from [10.72.13.19] (ovpn-13-19.pek2.redhat.com [10.72.13.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF96C1349A;
        Fri, 15 Jan 2021 05:38:42 +0000 (UTC)
Subject: Re: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
To:     Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
 <20210105103203.82508-7-parav@nvidia.com>
 <20210105064707-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322E5E7CA71CB2EE0577706DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105071101-mutt-send-email-mst@kernel.org>
 <BY5PR12MB432235169D805760EC0CF7CEDCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105082243-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322EC8D0AD648063C607E17DCAF0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <66dc44ac-52da-eaba-3f5e-69254e42d75b@redhat.com>
 <BY5PR12MB43225D83EA46004E3AF50D3ADCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <01213588-d4af-820a-bcf8-c28b8a80c346@redhat.com>
Date:   Fri, 15 Jan 2021 13:38:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43225D83EA46004E3AF50D3ADCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/14 下午3:58, Parav Pandit wrote:
>
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Thursday, January 14, 2021 9:48 AM
>>
>> On 2021/1/7 上午11:48, Parav Pandit wrote:
>>>> From: Michael S. Tsirkin <mst@redhat.com>
>>>> Sent: Tuesday, January 5, 2021 6:53 PM
>>>>
>>>> On Tue, Jan 05, 2021 at 12:30:15PM +0000, Parav Pandit wrote:
>>>>>> From: Michael S. Tsirkin <mst@redhat.com>
>>>>>> Sent: Tuesday, January 5, 2021 5:45 PM
>>>>>>
>>>>>> On Tue, Jan 05, 2021 at 12:02:33PM +0000, Parav Pandit wrote:
>>>>>>>> From: Michael S. Tsirkin <mst@redhat.com>
>>>>>>>> Sent: Tuesday, January 5, 2021 5:19 PM
>>>>>>>>
>>>>>>>> On Tue, Jan 05, 2021 at 12:32:03PM +0200, Parav Pandit wrote:
>>>>>>>>> Enable user to create vdpasim net simulate devices.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> $ vdpa dev add mgmtdev vdpasim_net name foo2
>>>>>>>>>
>>>>>>>>> Show the newly created vdpa device by its name:
>>>>>>>>> $ vdpa dev show foo2
>>>>>>>>> foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2
>>>>>>>>> max_vq_size 256
>>>>>>>>>
>>>>>>>>> $ vdpa dev show foo2 -jp
>>>>>>>>> {
>>>>>>>>>       "dev": {
>>>>>>>>>           "foo2": {
>>>>>>>>>               "type": "network",
>>>>>>>>>               "mgmtdev": "vdpasim_net",
>>>>>>>>>               "vendor_id": 0,
>>>>>>>>>               "max_vqs": 2,
>>>>>>>>>               "max_vq_size": 256
>>>>>>>>>           }
>>>>>>>>>       }
>>>>>>>>> }
>>>>>>>> I'd like an example of how do device specific (e.g. net
>>>>>>>> specific) interfaces tie in to this.
>>>>>>> Not sure I follow your question.
>>>>>>> Do you mean how to set mac address or mtu of this vdpa device of
>>>>>>> type
>>>>>> net?
>>>>>>> If so, dev add command will be extended shortly in subsequent
>>>>>>> series to
>>>>>> set this net specific attributes.
>>>>>>> (I did mention in the next steps in cover letter).
>>>>>>>
>>>>>>>>> +static int __init vdpasim_net_init(void) {
>>>>>>>>> +	int ret;
>>>>>>>>> +
>>>>>>>>> +	if (macaddr) {
>>>>>>>>> +		mac_pton(macaddr, macaddr_buf);
>>>>>>>>> +		if (!is_valid_ether_addr(macaddr_buf))
>>>>>>>>> +			return -EADDRNOTAVAIL;
>>>>>>>>> +	} else {
>>>>>>>>> +		eth_random_addr(macaddr_buf);
>>>>>>>>>    	}
>>>>>>>> Hmm so all devices start out with the same MAC until changed?
>>>>>>>> And how is the change effected?
>>>>>>> Post this patchset and post we have iproute2 vdpa in the tree,
>>>>>>> will add the
>>>>>> mac address as the input attribute during "vdpa dev add" command.
>>>>>>> So that each different vdpa device can have user specified
>>>>>>> (different) mac
>>>>>> address.
>>>>>>
>>>>>> For now maybe just avoid VIRTIO_NET_F_MAC then for new devices
>>>> then?
>>>>> That would require book keeping existing net vdpa_sim devices
>>>>> created to
>>>> avoid setting VIRTIO_NET_F_MAC.
>>>>> Such book keeping code will be short lived anyway.
>>>>> Not sure if its worth it.
>>>>> Until now only one device was created. So not sure two vdpa devices
>>>>> with
>>>> same mac address will be a real issue.
>>>>> When we add mac address attribute in add command, at that point also
>>>> remove the module parameter macaddr.
>>>>
>>>> Will that be mandatory? I'm not to happy with a UAPI we intend to
>>>> break straight away ...
>>> No. Specifying mac address shouldn't be mandatory. UAPI wont' be
>> broken.
>>
>>
>> If it's not mandatory. Does it mean the vDPA parent need to use its own logic
>> to generate a validate mac? I'm not sure this is what management (libvirt
>> want).
>>
> There are few use cases that I see with PFs, VFs and SFs supporting vdpa devices.
>
> 1. User wants to use the VF only for vdpa purpose. Here user got the VF which was pre-setup by the sysadmin.
> In this case whatever MAC assigned to the VF can be used by its vdpa device.
> Here, user doesn't need to pass the mac address during vdpa device creation time.
> This is done as the same MAC has been setup in the ACL rules on the switch side.
> Non VDPA users of a VF typically use the VF this way for Netdev and rdma functionality.
> They might continue same way for vdpa application as well.
> Here VF mac is either set using
> (a) devlink port function set hw_addr command or using
> (b) ip link set vf mac
> So vdpa tool didn't pass the mac. (optional).
> Though VIRTIO_NET_F_MAC is still valid.
>
> 2. User may want to create one or more vdpa device out of the mgmt. device.
> Here user wants to more/full control of all features, overriding what sysadmin has setup as MAC of the VF/SF.
> In this case user will specify the MAC via mgmt tool.
> (a) This is also used by those vdpa devices which doesn't have eswitch offloads.
> (b) This will work with eswitch offloads as well who does source learning.
> (c) User chose to use the vdpa device of a VF while VF Netdev and rdma device are used by hypervisor for something else as well.
> VIRTIO_NET_F_MAC remains valid in all 2.{a,b,c}.
>
> 3. A  vendor mgmt. device always expects it user to provide mac for its vdpa devices.
> So when it is not provided, it can fail with error message string in extack or clear the VIRTIO_NET_F_MAC and let it work using virtio spec's 5.1.5 point 5 to proceed.
>
> As common denominator of all above cases, if QEMU or user pass the MAC during creation, it will almost always work.
> Advance user and QEMU with switchdev mode support who has done 1.a/1.b, will omit it.
> I do not know how deep integration of QEMU exist with the switchdev mode support.
>
> With that mac, mtu as optional input fields provide the necessary flexibility for different stacks to take appropriate shape as they desire.


Thanks for the clarification. I think we'd better document the above in 
the patch that introduces the mac setting from management API.


>

