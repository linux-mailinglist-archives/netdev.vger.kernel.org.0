Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23FF3BB7DC
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 09:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhGEHcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 03:32:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30280 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229981AbhGEHce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 03:32:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625470197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrSBmzvOS6/PS/ey8rda3qmHumcD6j+TIXTeJ0gyPEk=;
        b=dNeLpPVKONoKQkz+74wkIHiJRgWaM31Y2ie1435U8FaIdq8FCnTu2p5vT8gyinvNukmlAs
        zMQ7I+Zq7Njugo+sNRAH1wyBjLrTfGvnZLAj2tJ02fDObL5EhTGno+ccXePDFhdhMqf2tS
        1qc2aoif7u2hALY4VbmbAK+BNdrBkSI=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-jwPQ6NFgM0S-2GEHOlJA-A-1; Mon, 05 Jul 2021 03:29:56 -0400
X-MC-Unique: jwPQ6NFgM0S-2GEHOlJA-A-1
Received: by mail-pf1-f197.google.com with SMTP id g17-20020a6252110000b029030423e1ef64so11422352pfb.18
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 00:29:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TrSBmzvOS6/PS/ey8rda3qmHumcD6j+TIXTeJ0gyPEk=;
        b=DfOQNLudJazZCQYivTIAxyLZNUt92vrLbLMQEzqWvJnbfAhybxZDQRPm780moz8sSb
         YqINP7aFNq6lIZ7y/R6kJY8GBfqmEhUJcUhV51X46DeV/oCALd3QlbYzXSiMqUMHvpJb
         F3d1+V1Er5vSljD16EW33BtCc38rjtmhdTW8ooKiUUFpxmwZHK+PhaZFAUwV/6I4z04D
         CNre+RJWNiTEMVQeC+jEv9cqFOznE4A+I8goz4QVAbM7I2+yD+WQqQDRA/Grwc8jVX0r
         QMLYCgqg2eQoAENgyfL9BEDe/aJPEqCjbEOh1eGyWkKrSZpvIlqbVpMKpQTxU6tSRnhC
         2cTQ==
X-Gm-Message-State: AOAM531ktMfff4mWS16HUkq82DNyj8RvEOM1EhXF43W3HfFkzgBXzScy
        bnBZTRCGdzA4qBrbhkZCyCutqiF7GqNweDQrZ9hXg8TiZDstsfuRAapixayw9BMKpuNxMrXJvkD
        UpBmyOv5Echm/LfRd
X-Received: by 2002:a62:e40c:0:b029:317:3367:c5db with SMTP id r12-20020a62e40c0000b02903173367c5dbmr13828157pfh.62.1625470195673;
        Mon, 05 Jul 2021 00:29:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyPuvIjsJjbwagcjsnQti/B3SFzhjFQwJhjth684dqQCP2e9nWAUj+nOHvnbWfsYhmocWiLA==
X-Received: by 2002:a62:e40c:0:b029:317:3367:c5db with SMTP id r12-20020a62e40c0000b02903173367c5dbmr13828142pfh.62.1625470195452;
        Mon, 05 Jul 2021 00:29:55 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z76sm11997064pfc.173.2021.07.05.00.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 00:29:54 -0700 (PDT)
Subject: Re: [PATCH 2/2] vdpa: vp_vdpa: don't use hard-coded maximum virtqueue
 size
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com
References: <20210705071910.31965-1-jasowang@redhat.com>
 <20210705071910.31965-2-jasowang@redhat.com>
 <20210705032602-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <02139c5f-92c5-eda6-8d2d-8e1b6ac70f3e@redhat.com>
Date:   Mon, 5 Jul 2021 15:29:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210705032602-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/5 ÏÂÎç3:26, Michael S. Tsirkin Ð´µÀ:
> On Mon, Jul 05, 2021 at 03:19:10PM +0800, Jason Wang wrote:
>> This patch switch to read virtqueue size from the capability instead
>> of depending on the hardcoded value. This allows the per virtqueue
>> size could be advertised.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> So let's add an ioctl for this? It's really a bug we don't..


As explained in patch 1. Qemu doesn't use VHOST_VDPA_GET_VRING_NUM 
actually. Instead it checks the result VHOST_VDPA_SET_VRING_NUM.

So I change VHOST_VDPA_GET_VRING_NUM to return the minimal size of all 
the virtqueues.

If you wish we can add a VHOST_VDPA_GET_VRING_NUM2, but I'm not sure it 
will have a user or not.

Thanks


>
>> ---
>>   drivers/vdpa/virtio_pci/vp_vdpa.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
>> index 2926641fb586..198f7076e4d9 100644
>> --- a/drivers/vdpa/virtio_pci/vp_vdpa.c
>> +++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
>> @@ -18,7 +18,6 @@
>>   #include <linux/virtio_pci.h>
>>   #include <linux/virtio_pci_modern.h>
>>   
>> -#define VP_VDPA_QUEUE_MAX 256
>>   #define VP_VDPA_DRIVER_NAME "vp_vdpa"
>>   #define VP_VDPA_NAME_SIZE 256
>>   
>> @@ -197,7 +196,10 @@ static void vp_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
>>   
>>   static u16 vp_vdpa_get_vq_num_max(struct vdpa_device *vdpa, u16 qid)
>>   {
>> -	return VP_VDPA_QUEUE_MAX;
>> +	struct vp_vdpa *vp_vdpa = vdpa_to_vp(vdpa);
>> +	struct virtio_pci_modern_device *mdev = &vp_vdpa->mdev;
>> +
>> +	return vp_modern_get_queue_size(mdev, qid);
>>   }
>>   
>>   static int vp_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 qid,
>> -- 
>> 2.25.1

