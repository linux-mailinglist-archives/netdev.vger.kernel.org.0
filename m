Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE67535EF69
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 10:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349833AbhDNIS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 04:18:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231223AbhDNISy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 04:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618388311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=drGuROoG7lj2vDETDU9JDvj19d1vG70cVaZLfEDasfQ=;
        b=eng9jP2F8WIvEVqjIHcrtypbkDa0bReMJI2sovQ9ju6aGAoJhVd2xavUMFgQRObkGPK1TA
        zG20mQeSxpQ28JcLiYKL6XcsdA+M80AdNX7W0Bh+0qyOiWtruxL13xmouwavbQFAg67nAn
        4/y1crStaHgijUC1goWLNQJGuTg4NEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-BEpTz7kFPZK4thdSD3eoIQ-1; Wed, 14 Apr 2021 04:18:28 -0400
X-MC-Unique: BEpTz7kFPZK4thdSD3eoIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74FE91883527;
        Wed, 14 Apr 2021 08:18:26 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-33.pek2.redhat.com [10.72.13.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B882B16ED7;
        Wed, 14 Apr 2021 08:18:13 +0000 (UTC)
Subject: Re: [PATCH v6 09/10] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-10-xieyongji@bytedance.com>
 <c817178a-2ac8-bf93-1ed3-528579c657a3@redhat.com>
 <CACycT3v_KFQXoxRbEj8c0Ve6iKn9RbibtBDgBFs=rf0ZOmTBBQ@mail.gmail.com>
 <091dde74-449b-385c-0ec9-11e4847c6c4c@redhat.com>
 <CACycT3vwATp4+Ao0fjuyeeLQN+xHH=dXF+JUyuitkn4k8hELnA@mail.gmail.com>
 <dc9a90dd-4f86-988c-c1b5-ac606ce5e14b@redhat.com>
 <CACycT3vxO21Yt6+px2c2Q8DONNUNehdo2Vez_RKQCKe76CM2TA@mail.gmail.com>
 <0f386dfe-45c9-5609-55f7-b8ab2a4abf5e@redhat.com>
 <CACycT3vbDhUKM0OX-zo02go09gh2+EEdyZ_YQuz8PXzo3EngXw@mail.gmail.com>
 <a85c0a66-ad7f-a344-f8ed-363355f5e283@redhat.com>
 <CACycT3tHxtfgQhQgv0VyF_U523qASEv1Ydc4XuX43MFRzGVbfw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <51cd2e3a-5b76-a6f5-da59-b118a7e13923@redhat.com>
Date:   Wed, 14 Apr 2021 16:18:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CACycT3tHxtfgQhQgv0VyF_U523qASEv1Ydc4XuX43MFRzGVbfw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/13 下午12:28, Yongji Xie 写道:
> On Tue, Apr 13, 2021 at 11:35 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/4/12 下午5:59, Yongji Xie 写道:
>>> On Mon, Apr 12, 2021 at 5:37 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/4/12 下午4:02, Yongji Xie 写道:
>>>>> On Mon, Apr 12, 2021 at 3:16 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> 在 2021/4/9 下午4:02, Yongji Xie 写道:
>>>>>>>>>>> +};
>>>>>>>>>>> +
>>>>>>>>>>> +struct vduse_dev_config_data {
>>>>>>>>>>> +     __u32 offset; /* offset from the beginning of config space */
>>>>>>>>>>> +     __u32 len; /* the length to read/write */
>>>>>>>>>>> +     __u8 data[VDUSE_CONFIG_DATA_LEN]; /* data buffer used to read/write */
>>>>>>>>>> Note that since VDUSE_CONFIG_DATA_LEN is part of uAPI it means we can
>>>>>>>>>> not change it in the future.
>>>>>>>>>>
>>>>>>>>>> So this might suffcient for future features or all type of virtio devices.
>>>>>>>>>>
>>>>>>>>> Do you mean 256 is no enough here？
>>>>>>>> Yes.
>>>>>>>>
>>>>>>> But this request will be submitted multiple times if config lengh is
>>>>>>> larger than 256. So do you think whether we need to extent the size to
>>>>>>> 512 or larger?
>>>>>> So I think you'd better either:
>>>>>>
>>>>>> 1) document the limitation (256) in somewhere, (better both uapi and doc)
>>>>>>
>>>>> But the VDUSE_CONFIG_DATA_LEN doesn't mean the limitation of
>>>>> configuration space. It only means the maximum size of one data
>>>>> transfer for configuration space. Do you mean document this?
>>>> Yes, and another thing is that since you're using
>>>> data[VDUSE_CONFIG_DATA_LEN] in the uapi, it implies the length is always
>>>> 256 which seems not good and not what the code is wrote.
>>>>
>>> How about renaming VDUSE_CONFIG_DATA_LEN to VDUSE_MAX_TRANSFER_LEN?
>>>
>>> Thanks,
>>> Yongji
>>
>> So a question is the reason to have a limitation of this in the uAPI?
>> Note that in vhost-vdpa we don't have such:
>>
>> struct vhost_vdpa_config {
>>           __u32 off;
>>           __u32 len;
>>           __u8 buf[0];
>> };
>>
> If so, we need to call read()/write() multiple times each time
> receiving/sending one request or response in userspace and kernel. For
> example,
>
> 1. read and check request/response type
> 2. read and check config length if type is VDUSE_SET_CONFIG or VDUSE_GET_CONFIG
> 3. read the payload
>
> Not sure if it's worth it.
>
> Thanks,
> Yongji


Right, I see.

So I'm fine with current approach.

Thanks



>

