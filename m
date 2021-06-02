Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C39E398298
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhFBHH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:07:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231419AbhFBHHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 03:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622617542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7AFjn1kAaIwJ7yXpW9H7ltpl4fJk13y2xBWVC0JT2Y=;
        b=XQqwCCK83td8iyoCHwRbkrQJfEEViyskBWWP/l5JN3SqssOiB3yMB6dPzjfcNOqMzOXr7p
        1Yic3raL4w0t0qJ72DkimFZ4cHj0N3l/QYpNNi0jcikfqsOrFkW9RvfryA21GQu1F05/ES
        rDTkd9i6rTk4v9S+SkUbq3CxcRukN0A=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-LoEZVq1APhaCTXvTKa8W9w-1; Wed, 02 Jun 2021 03:05:41 -0400
X-MC-Unique: LoEZVq1APhaCTXvTKa8W9w-1
Received: by mail-pj1-f71.google.com with SMTP id t10-20020a17090a5d8ab029015f9a066bc3so1106278pji.2
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 00:05:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=N7AFjn1kAaIwJ7yXpW9H7ltpl4fJk13y2xBWVC0JT2Y=;
        b=SueIGTX7rJQgC20uVCVlUGm/NVJGw/bEiV6t5vsZcDQcKbV8G3mqfBoNScF1VOSCd9
         Qo+D4Uaq1NuyLrXcUqP4TX6QD4dVwLg90LOxwrVKbGp/CbzsemLcFV4VNx5xVVkzBnPF
         auPbL9fN0tWXWJSVaWhndL7+mNS+96sDt437FfQvdW7RciTqm+ZRHpxkbiF1qqSV7Ui3
         a/mzQ9UZc4o+0E5+sAqCRzXUvDpa36v61FaGUcgtycOkWvjCweUDOXr/Ux1LqQ5V8hrF
         zBwnlPn+ISG20oB1KSGTR6tRTBy29qPLbdlDtg8SyDh9eAD2xOJSIg8h/uyTayprpcyz
         xmCA==
X-Gm-Message-State: AOAM531UaSmU3UwnJbqVvhPYsRvYjRSktEfyBr0x0LOxB0CJ7JZxA73Y
        LXGqNOPqW6xski3ABVncPzRPaVCGB2vvEL4zntJm/Dc5hF7NIGqqd0vAYv9nnwrTa5eZ5ZPeNCk
        tkXSP/+z6p8t6dHLW
X-Received: by 2002:a63:d908:: with SMTP id r8mr17698726pgg.414.1622617540707;
        Wed, 02 Jun 2021 00:05:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxi1fo5eUxqSSq1jhRLtWR5oM/z3BQO8r5DzrHXf+icFTZlIa8TZoB63MRifCqrns7bI6/5cA==
X-Received: by 2002:a63:d908:: with SMTP id r8mr17698704pgg.414.1622617540453;
        Wed, 02 Jun 2021 00:05:40 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x19sm15554961pgj.66.2021.06.02.00.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 00:05:40 -0700 (PDT)
Subject: Re: [PATCH V2 3/4] vp_vdpa: allow set vq state to initial state after
 reset
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, eli@mellanox.com
References: <20210602021043.39201-1-jasowang@redhat.com>
 <20210602021043.39201-4-jasowang@redhat.com>
 <20210602061324.GA8662@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <091dc6d0-8754-7b2a-64ec-985ef9db6329@redhat.com>
Date:   Wed, 2 Jun 2021 15:05:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210602061324.GA8662@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/2 ÏÂÎç2:13, Eli Cohen Ð´µÀ:
> On Wed, Jun 02, 2021 at 10:10:42AM +0800, Jason Wang wrote:
>> We used to fail the set_vq_state() since it was not supported yet by
>> the virtio spec. But if the bus tries to set the state which is equal
>> to the device initial state after reset, we can let it go.
>>
>> This is a must for virtio_vdpa() to set vq state during probe which is
>> required for some vDPA parents.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vdpa/virtio_pci/vp_vdpa.c | 42 ++++++++++++++++++++++++++++---
>>   1 file changed, 39 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
>> index c76ebb531212..18bf4a422772 100644
>> --- a/drivers/vdpa/virtio_pci/vp_vdpa.c
>> +++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
>> @@ -210,13 +210,49 @@ static int vp_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 qid,
>>   	return -EOPNOTSUPP;
>>   }
>>   
>> +static int vp_vdpa_set_vq_state_split(struct vdpa_device *vdpa,
>> +				      const struct vdpa_vq_state *state)
>> +{
>> +	const struct vdpa_vq_state_split *split = &state->split;
>> +
>> +	if (split->avail_index == 0)
>> +		return 0;
>> +
>> +	return -EOPNOTSUPP;
>> +}
>> +
>> +static int vp_vdpa_set_vq_state_packed(struct vdpa_device *vdpa,
>> +				       const struct vdpa_vq_state *state)
>> +{
>> +	const struct vdpa_vq_state_packed *packed = &state->packed;
>> +
>> +	if (packed->last_avail_counter == 1 &&
> Can you elaborate on the requirement on last_avail_counter and
> last_used_counter?


This is required by the virtio spec:

"
2.7.1 Driver and Device Ring Wrap Counters
Each of the driver and the device are expected to maintain, internally, 
a single-bit ring wrap counter initialized to 1.
"

For virtio-pci device, since there's no way to assign the value of those 
counters, the counters will be reset to 1 after reset, otherwise the 
driver can't work.

Thanks


>
>> +	    packed->last_avail_idx == 0 &&
>> +	    packed->last_used_counter == 1 &&
>> +	    packed->last_used_idx == 0)
>> +		return 0;
>> +
>> +	return -EOPNOTSUPP;
>> +}
>> +
>>   static int vp_vdpa_set_vq_state(struct vdpa_device *vdpa, u16 qid,
>>   				const struct vdpa_vq_state *state)
>>   {
>> -	/* Note that this is not supported by virtio specification, so
>> -	 * we return -ENOPOTSUPP here. This means we can't support live
>> -	 * migration, vhost device start/stop.
>> +	struct virtio_pci_modern_device *mdev = vdpa_to_mdev(vdpa);
>> +
>> +	/* Note that this is not supported by virtio specification.
>> +	 * But if the state is by chance equal to the device initial
>> +	 * state, we can let it go.
>>   	 */
>> +	if ((vp_modern_get_status(mdev) & VIRTIO_CONFIG_S_FEATURES_OK) &&
>> +	    !vp_modern_get_queue_enable(mdev, qid)) {
>> +		if (vp_modern_get_driver_features(mdev) &
>> +		    BIT_ULL(VIRTIO_F_RING_PACKED))
>> +			return vp_vdpa_set_vq_state_packed(vdpa, state);
>> +		else
>> +			return vp_vdpa_set_vq_state_split(vdpa,	state);
>> +	}
>> +
>>   	return -EOPNOTSUPP;
>>   }
>>   
>> -- 
>> 2.25.1
>>

