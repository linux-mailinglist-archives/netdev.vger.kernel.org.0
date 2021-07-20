Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E743CF506
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 09:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242409AbhGTGZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 02:25:08 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:49988 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236706AbhGTGZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 02:25:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UgOhihj_1626764737;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0UgOhihj_1626764737)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Jul 2021 15:05:37 +0800
Subject: Re: [PATCH] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
To:     Jason Wang <jasowang@redhat.com>,
        Xianting Tian <tianxianting.txt@linux.alibaba.com>,
        stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210720034255.1408-1-tianxianting.txt@linux.alibaba.com>
 <73d486dd-17d9-a3b3-c1e9-39a1138c0084@redhat.com>
From:   tianxianting <xianting.tian@linux.alibaba.com>
Message-ID: <ef3f559f-7093-aae7-1fa7-d58bf9ac87c9@linux.alibaba.com>
Date:   Tue, 20 Jul 2021 15:05:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <73d486dd-17d9-a3b3-c1e9-39a1138c0084@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thanks ,

I will sent V2 patch.

在 2021/7/20 下午2:28, Jason Wang 写道:
>
> 在 2021/7/20 上午11:42, Xianting Tian 写道:
>> From: Xianting Tian <xianting.tian@linux.alibaba.com>
>>
>> Add the missed virtio_device_ready() to set vsock frontend ready.
>>
>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>> ---
>>   net/vmw_vsock/virtio_transport.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/vmw_vsock/virtio_transport.c 
>> b/net/vmw_vsock/virtio_transport.c
>> index e0c2c992a..eb4c607c4 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -637,6 +637,8 @@ static int virtio_vsock_probe(struct 
>> virtio_device *vdev)
>>       vdev->priv = vsock;
>>       rcu_assign_pointer(the_virtio_vsock, vsock);
>>   +    virtio_device_ready(vdev);
>> +
>>       mutex_unlock(&the_virtio_vsock_mutex);
>
>
> It's better to do this after the mutex_lock().
>
> Thanks
>
>
>>         return 0;
