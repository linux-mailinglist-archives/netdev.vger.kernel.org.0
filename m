Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5493E4B418E
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 07:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiBNGHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 01:07:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiBNGHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 01:07:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FD0350E15
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644818828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7n9z/pi2pD7RkPblqXPuf7GbrEr8Si+Jug1cBrEud3Y=;
        b=HY+lgsD963sXxdv27qlZ9giK9dE6wosQnpXOpCAdN33QnK8zFs4M05rt3AsW29xy7VTFwp
        BwUXhKQNiQG/pSSyblGbuPGvUDeZlBqYLjsOBjZyh2xOgzO73F0RPIujXv/kw+wwjps47K
        LKInVs0SOkKZVlvrR5UQHQJTDEt1qnE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-Hc85znQ6P3axbW6ZkXJ9SA-1; Mon, 14 Feb 2022 01:07:07 -0500
X-MC-Unique: Hc85znQ6P3axbW6ZkXJ9SA-1
Received: by mail-pf1-f200.google.com with SMTP id d5-20020a623605000000b004e01ccd08abso11011363pfa.10
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:07:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7n9z/pi2pD7RkPblqXPuf7GbrEr8Si+Jug1cBrEud3Y=;
        b=wAC8fsJ6JwxykXq5ZAvjj2loeYsA13dV4Z4U1vwggTQ6gKhMWEyZQ+iKBgO5rSKv7U
         im2YOb+uM+5p+XDLFTlFt51wLOfAAdp9ZrRcmQyCYH0WYdhqntAJyZ15SdL0bTCFOuaa
         zXLkT+sTMscyR64iLk4rRntTSXuiANs1Z5GFNUu90Rlh0+DbqfM/LjBidE3hFR3zECOm
         X/RGp/2OPO9TcACezZ5CLp1hLv8YkFL9TSlml145TTSCZMBmGsUn5dPa0XS9gkzf9ete
         lW0MUqr2SrT4IPmnmc0Qi/9nMrOJ0XL8hJALmv/EDn+yoGfwBaJAdL9EWEYlZQIhesB6
         4UXg==
X-Gm-Message-State: AOAM530xD6PcO0JFJxn7Ng+FHoEGkKCZ/QTIFTn/L4NxzHmr5Ra2bs5q
        85W4AJfZYWDXct+CSBOSKRGlQMBksIUZoRgGocnhRTmidSz5T6ooYpD3TFR9dV4fpVfn7U5Unl8
        x+hhi+dW1iSnIa8Kk
X-Received: by 2002:a17:902:e88b:: with SMTP id w11mr12657550plg.161.1644818826027;
        Sun, 13 Feb 2022 22:07:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+3OkThbAifxEu3BYWBLbWr38ZB12qOW+uzA1VE/JIOmxlR4Ye+0HWQM88QxGnf0R5G50AVQ==
X-Received: by 2002:a17:902:e88b:: with SMTP id w11mr12657519plg.161.1644818825565;
        Sun, 13 Feb 2022 22:07:05 -0800 (PST)
Received: from [10.72.12.239] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t1sm35848444pfj.115.2022.02.13.22.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Feb 2022 22:07:04 -0800 (PST)
Message-ID: <185b96bb-68bd-9aef-b473-1f312194b42b@redhat.com>
Date:   Mon, 14 Feb 2022 14:06:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH 2/3] virtio: Define bit numbers for device independent
 features
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>
References: <20220207125537.174619-1-elic@nvidia.com>
 <20220207125537.174619-3-elic@nvidia.com>
 <CACGkMEvF7opCo35QLz4p3u7=T1+H-p=isFm4+yh4uNzKiAxr1A@mail.gmail.com>
 <20220210083050.GA224722@mtl-vdi-166.wap.labs.mlnx>
 <CACGkMEtBq_q_NQZgs4LobSRkA-4eOafBPLXZJ7ny9f8XJygSzw@mail.gmail.com>
 <20220210092718.GA226512@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220210092718.GA226512@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/10 下午5:27, Eli Cohen 写道:
> On Thu, Feb 10, 2022 at 04:35:28PM +0800, Jason Wang wrote:
>> On Thu, Feb 10, 2022 at 4:31 PM Eli Cohen <elic@nvidia.com> wrote:
>>> On Thu, Feb 10, 2022 at 03:54:57PM +0800, Jason Wang wrote:
>>>> On Mon, Feb 7, 2022 at 8:56 PM Eli Cohen <elic@nvidia.com> wrote:
>>>>> Define bit fields for device independent feature bits. We need them in a
>>>>> follow up patch.
>>>>>
>>>>> Also, define macros for start and end of these feature bits.
>>>>>
>>>>> Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
>>>>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>>>>> ---
>>>>>   include/uapi/linux/virtio_config.h | 16 ++++++++--------
>>>>>   1 file changed, 8 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
>>>>> index 3bf6c8bf8477..6d92cc31a8d3 100644
>>>>> --- a/include/uapi/linux/virtio_config.h
>>>>> +++ b/include/uapi/linux/virtio_config.h
>>>>> @@ -45,14 +45,14 @@
>>>>>   /* We've given up on this device. */
>>>>>   #define VIRTIO_CONFIG_S_FAILED         0x80
>>>>>
>>>>> -/*
>>>>> - * Virtio feature bits VIRTIO_TRANSPORT_F_START through
>>>>> - * VIRTIO_TRANSPORT_F_END are reserved for the transport
>>>>> - * being used (e.g. virtio_ring, virtio_pci etc.), the
>>>>> - * rest are per-device feature bits.
>>>>> - */
>>>>> -#define VIRTIO_TRANSPORT_F_START       28
>>>>> -#define VIRTIO_TRANSPORT_F_END         38
>>>>> +/* Device independent features per virtio spec 1.1 range from 28 to 38 */
>>>>> +#define VIRTIO_DEV_INDEPENDENT_F_START 28
>>>>> +#define VIRTIO_DEV_INDEPENDENT_F_END   38
>>>> Haven't gone through patch 3 but I think it's probably better not
>>>> touch uapi stuff. Or we can define those macros in other place?
>>>>
>>> I can put it in vdpa.c
>>>
>>>>> +
>>>>> +#define VIRTIO_F_RING_INDIRECT_DESC 28
>>>>> +#define VIRTIO_F_RING_EVENT_IDX 29
>>>>> +#define VIRTIO_F_IN_ORDER 35
>>>>> +#define VIRTIO_F_NOTIFICATION_DATA 38
>>>> This part belongs to the virtio_ring.h any reason not pull that file
>>>> instead of squashing those into virtio_config.h?
>>>>
>>> Not sure what you mean here. I can't find virtio_ring.h in my tree.
>> I meant just copy the virtio_ring.h in the linux tree. It seems cleaner.
> I will still miss VIRTIO_F_ORDER_PLATFORM and VIRTIO_F_NOTIFICATION_DATA
> which are only defined in drivers/net/ethernet/sfc/mcdi_pcol.h for block
> devices only.
>
> What would you suggest to do with them? Maybe define them in vdpa.c?


I meant maybe we need a full synchronization from the current Linux uapi 
headers for virtio_config.h and and add virtio_ring.h here.

Thanks


>
>> Thanks
>>
>>>> Thanks
>>>>
>>>>>   #ifndef VIRTIO_CONFIG_NO_LEGACY
>>>>>   /* Do we get callbacks when the ring is completely used, even if we've
>>>>> --
>>>>> 2.34.1
>>>>>

