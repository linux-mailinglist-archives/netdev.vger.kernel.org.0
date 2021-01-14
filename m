Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7DA2F59E1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbhANETd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:19:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726110AbhANETd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 23:19:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610597887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eRMqhJYEIzS7qqs8p7MdIVwG7fzXeZHJWGj3Ki4v9wE=;
        b=cswNaV2KUE1FwJ6VP5LdBSVXI6t3r02QeTh5GqxLDbtz/f8A7922aYJ69Ju1ea1c7zysNQ
        nbKACOk0X5VU8pfJIwNQPSktoHzuUEXU+2uqWa8lIT7r0lvabqP92UtYob+x9K3CGNlOOF
        OBbRlxTDLIZ8uXF/+jSgORfAeVFMe88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-ci9WnyBDP6-D8H5oYr2dIw-1; Wed, 13 Jan 2021 23:18:03 -0500
X-MC-Unique: ci9WnyBDP6-D8H5oYr2dIw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CED44107ACF7;
        Thu, 14 Jan 2021 04:18:01 +0000 (UTC)
Received: from [10.72.12.100] (ovpn-12-100.pek2.redhat.com [10.72.12.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34F64614FA;
        Thu, 14 Jan 2021 04:17:54 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <66dc44ac-52da-eaba-3f5e-69254e42d75b@redhat.com>
Date:   Thu, 14 Jan 2021 12:17:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB4322EC8D0AD648063C607E17DCAF0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/7 上午11:48, Parav Pandit wrote:
>
>> From: Michael S. Tsirkin <mst@redhat.com>
>> Sent: Tuesday, January 5, 2021 6:53 PM
>>
>> On Tue, Jan 05, 2021 at 12:30:15PM +0000, Parav Pandit wrote:
>>>
>>>> From: Michael S. Tsirkin <mst@redhat.com>
>>>> Sent: Tuesday, January 5, 2021 5:45 PM
>>>>
>>>> On Tue, Jan 05, 2021 at 12:02:33PM +0000, Parav Pandit wrote:
>>>>>
>>>>>> From: Michael S. Tsirkin <mst@redhat.com>
>>>>>> Sent: Tuesday, January 5, 2021 5:19 PM
>>>>>>
>>>>>> On Tue, Jan 05, 2021 at 12:32:03PM +0200, Parav Pandit wrote:
>>>>>>> Enable user to create vdpasim net simulate devices.
>>>>>>>
>>>>>>>
>>>>>>> $ vdpa dev add mgmtdev vdpasim_net name foo2
>>>>>>>
>>>>>>> Show the newly created vdpa device by its name:
>>>>>>> $ vdpa dev show foo2
>>>>>>> foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2
>>>>>>> max_vq_size 256
>>>>>>>
>>>>>>> $ vdpa dev show foo2 -jp
>>>>>>> {
>>>>>>>      "dev": {
>>>>>>>          "foo2": {
>>>>>>>              "type": "network",
>>>>>>>              "mgmtdev": "vdpasim_net",
>>>>>>>              "vendor_id": 0,
>>>>>>>              "max_vqs": 2,
>>>>>>>              "max_vq_size": 256
>>>>>>>          }
>>>>>>>      }
>>>>>>> }
>>>>>>
>>>>>> I'd like an example of how do device specific (e.g. net
>>>>>> specific) interfaces tie in to this.
>>>>> Not sure I follow your question.
>>>>> Do you mean how to set mac address or mtu of this vdpa device of
>>>>> type
>>>> net?
>>>>> If so, dev add command will be extended shortly in subsequent
>>>>> series to
>>>> set this net specific attributes.
>>>>> (I did mention in the next steps in cover letter).
>>>>>
>>>>>>> +static int __init vdpasim_net_init(void) {
>>>>>>> +	int ret;
>>>>>>> +
>>>>>>> +	if (macaddr) {
>>>>>>> +		mac_pton(macaddr, macaddr_buf);
>>>>>>> +		if (!is_valid_ether_addr(macaddr_buf))
>>>>>>> +			return -EADDRNOTAVAIL;
>>>>>>> +	} else {
>>>>>>> +		eth_random_addr(macaddr_buf);
>>>>>>>   	}
>>>>>> Hmm so all devices start out with the same MAC until changed?
>>>>>> And how is the change effected?
>>>>> Post this patchset and post we have iproute2 vdpa in the tree,
>>>>> will add the
>>>> mac address as the input attribute during "vdpa dev add" command.
>>>>> So that each different vdpa device can have user specified
>>>>> (different) mac
>>>> address.
>>>>
>>>> For now maybe just avoid VIRTIO_NET_F_MAC then for new devices
>> then?
>>> That would require book keeping existing net vdpa_sim devices created to
>> avoid setting VIRTIO_NET_F_MAC.
>>> Such book keeping code will be short lived anyway.
>>> Not sure if its worth it.
>>> Until now only one device was created. So not sure two vdpa devices with
>> same mac address will be a real issue.
>>> When we add mac address attribute in add command, at that point also
>> remove the module parameter macaddr.
>>
>> Will that be mandatory? I'm not to happy with a UAPI we intend to break
>> straight away ...
> No. Specifying mac address shouldn't be mandatory. UAPI wont' be broken.


If it's not mandatory. Does it mean the vDPA parent need to use its own 
logic to generate a validate mac? I'm not sure this is what management 
(libvirt want).

Thanks


>

