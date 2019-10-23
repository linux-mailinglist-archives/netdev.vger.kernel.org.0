Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C84E1246
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 08:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388034AbfJWGjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 02:39:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49360 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729666AbfJWGjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 02:39:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571812776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JPoAZ12wvzk0gM/LMQmdcsjRqyc3hj/9X0DxYyB3fTs=;
        b=hVvgTKdc/bNeH9Wd6Ff8dmsch9XkS8ftV+OW2xaNYTq+d09Og0l3N50DSCJVWDrmDOfwrG
        ZDu+gOyOaaUT/QkX4Ek0TL3OcwcevVsaegTwgK8nvzuwiJi8LbilbMrkxUO/Cg5ATJjpnw
        YmfytHTxO9F5TQ30W1xO33jHs4CQA2g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-pxA18oaXO4G0FL33orpGpw-1; Wed, 23 Oct 2019 02:39:33 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A9AE801E52;
        Wed, 23 Oct 2019 06:39:31 +0000 (UTC)
Received: from [10.72.12.161] (ovpn-12-161.pek2.redhat.com [10.72.12.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BB4A19C70;
        Wed, 23 Oct 2019 06:39:16 +0000 (UTC)
Subject: Re: [RFC 2/2] vhost: IFC VF vdpa layer
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Zhu Lingshan <lingshan.zhu@linux.intel.com>, mst@redhat.com,
        alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016013050.3918-1-lingshan.zhu@intel.com>
 <20191016013050.3918-3-lingshan.zhu@intel.com>
 <9495331d-3c65-6f49-dcd9-bfdb17054cf0@redhat.com>
 <f65358e9-6728-8260-74f7-176d7511e989@intel.com>
 <1cae60b6-938d-e2df-2dca-fbf545f06853@redhat.com>
 <ddf412c6-69e2-b3ca-d0c8-75de1db78ed9@linux.intel.com>
 <b2adaab0-bbc3-b7f0-77da-e1e3cab93b76@redhat.com>
 <6588d9f4-f357-ec78-16a4-ccaf0e3768e7@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <02d44f0a-687f-ed87-518b-7a4d3e83c5d3@redhat.com>
Date:   Wed, 23 Oct 2019 14:39:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6588d9f4-f357-ec78-16a4-ccaf0e3768e7@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: pxA18oaXO4G0FL33orpGpw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/23 =E4=B8=8B=E5=8D=882:19, Zhu, Lingshan wrote:
>
> On 10/22/2019 9:05 PM, Jason Wang wrote:
>>
>> On 2019/10/22 =E4=B8=8B=E5=8D=882:53, Zhu Lingshan wrote:
>>>
>>> On 10/21/2019 6:19 PM, Jason Wang wrote:
>>>>
>>>> On 2019/10/21 =E4=B8=8B=E5=8D=885:53, Zhu, Lingshan wrote:
>>>>>
>>>>> On 10/16/2019 6:19 PM, Jason Wang wrote:
>>>>>>
>>>>>> On 2019/10/16 =E4=B8=8A=E5=8D=889:30, Zhu Lingshan wrote:
>>>>>>> This commit introduced IFC VF operations for vdpa, which complys to
>>>>>>> vhost_mdev interfaces, handles IFC VF initialization,
>>>>>>> configuration and removal.
>>>>>>>
>>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>>> ---
>>
>>
>> [...]
>>
>>
>>>>
>>>>
>>>>>
>>>>>>
>>>>>>
>>>>>>> +}
>>>>>>> +
>>>>>>> +static int ifcvf_mdev_set_features(struct mdev_device *mdev,=20
>>>>>>> u64 features)
>>>>>>> +{
>>>>>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvd=
ata(mdev);
>>>>>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapt=
er);
>>>>>>> +
>>>>>>> +=C2=A0=C2=A0=C2=A0 vf->req_features =3D features;
>>>>>>> +
>>>>>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static u64 ifcvf_mdev_get_vq_state(struct mdev_device *mdev,=20
>>>>>>> u16 qid)
>>>>>>> +{
>>>>>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *adapter =3D mdev_get_drvd=
ata(mdev);
>>>>>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_hw *vf =3D IFC_PRIVATE_TO_VF(adapt=
er);
>>>>>>> +
>>>>>>> +=C2=A0=C2=A0=C2=A0 return vf->vring[qid].last_avail_idx;
>>>>>>
>>>>>>
>>>>>> Does this really work? I'd expect it should be fetched from hw=20
>>>>>> since it's an internal state.
>>>>> for now, it's working, we intend to support LM in next version=20
>>>>> drivers.
>>>>
>>>>
>>>> I'm not sure I understand here, I don't see any synchronization=20
>>>> between the hardware and last_avail_idx, so last_avail_idx should=20
>>>> not change.
>>>>
>>>> Btw, what did "LM" mean :) ?
>>>
>>> I can add bar IO operations here, LM =3D live migration, sorry for the=
=20
>>> abbreviation.
>>
>>
>> Just make sure I understand here, I believe you mean reading=20
>> last_avail_idx through IO bar here?
>>
>> Thanks
>
> Hi Jason,
>
> Yes, I mean last_avail_idx. is that correct?
>
> THanks


Yes.

Thanks


>
>>
>>

