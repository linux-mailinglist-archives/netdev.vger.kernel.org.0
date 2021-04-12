Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4A535BAAE
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhDLHQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:16:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236679AbhDLHQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:16:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618211784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+6nhImlR+qM3GuM+TRySf0myMMv0WJfLOSpNifcSyi0=;
        b=feROvmb/+z0jlIF88yWtE585cXzlOHsL7j0EAfPCW4OeAVsdD+NHjqjof5htEBjAvQAPC3
        cV0vLpdsg+ls3w6Za7msI9q0m3kvfXJVco3Qj/vNOvWtHkPPUp7YAsf54IXV4Xwvm+YWBK
        7T5M/K6nmU/het5A02bDw0FyVSTT4Jw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-NEo5XLLuME-EhrKf6vyxYQ-1; Mon, 12 Apr 2021 03:16:23 -0400
X-MC-Unique: NEo5XLLuME-EhrKf6vyxYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C679802B4F;
        Mon, 12 Apr 2021 07:16:21 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-232.pek2.redhat.com [10.72.13.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66F2E13488;
        Mon, 12 Apr 2021 07:16:15 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <dc9a90dd-4f86-988c-c1b5-ac606ce5e14b@redhat.com>
Date:   Mon, 12 Apr 2021 15:16:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CACycT3vwATp4+Ao0fjuyeeLQN+xHH=dXF+JUyuitkn4k8hELnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/9 下午4:02, Yongji Xie 写道:
>>>>> +};
>>>>> +
>>>>> +struct vduse_dev_config_data {
>>>>> +     __u32 offset; /* offset from the beginning of config space */
>>>>> +     __u32 len; /* the length to read/write */
>>>>> +     __u8 data[VDUSE_CONFIG_DATA_LEN]; /* data buffer used to read/write */
>>>> Note that since VDUSE_CONFIG_DATA_LEN is part of uAPI it means we can
>>>> not change it in the future.
>>>>
>>>> So this might suffcient for future features or all type of virtio devices.
>>>>
>>> Do you mean 256 is no enough here？
>> Yes.
>>
> But this request will be submitted multiple times if config lengh is
> larger than 256. So do you think whether we need to extent the size to
> 512 or larger?


So I think you'd better either:

1) document the limitation (256) in somewhere, (better both uapi and doc)

or

2) make it variable

Thanks


>

