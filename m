Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8282D37B392
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 03:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhELBeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 21:34:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhELBea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 21:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620783203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5DG4/tk483cnbSJ3ONzjX6O6bMM+E3eYFHY3G4cqhSY=;
        b=BmleRHTLGBrT08h6C35MHn1tgswT6FVDdACFESK2QtB/pKhA5pM0SHaMf9dmH1LBMGPYPZ
        D++ndrH6fyGIwXqWLEoDmGd7/BHRCzW0hGyFdYvUEHsml1+Z4zTJnrpPAIdvh63fiUt5fq
        swl88ZD9RAhMAhAlQj1hbj6DycjbR9E=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-HB10ftC1M3a6RU67EAPfjQ-1; Tue, 11 May 2021 21:33:21 -0400
X-MC-Unique: HB10ftC1M3a6RU67EAPfjQ-1
Received: by mail-pg1-f199.google.com with SMTP id i8-20020a6548480000b02901fb8ebd5714so13359452pgs.12
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 18:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5DG4/tk483cnbSJ3ONzjX6O6bMM+E3eYFHY3G4cqhSY=;
        b=VTG/ZMvchv/U98qkri6j7tciCFYHBFjJzO/UErxdnWYpf+uXznTpy9luml8E66aaIE
         /w+BJhybxAEqoiX6oR/FGyzLqa9nD9TY9IZdOp6vNvXxnH90nc38DJKg11XIvPfzaoBO
         JyMtThEdGT7ysoh37iMdOzm7MYmKnLWQryDwBslEteug7x5+VpDfLF0tHOZOy/2gJZxJ
         QE20ciM+Ha7fj2RzPYSPS/iUVllcKQnCQCSpQV6h72gPm+egWBxk0OOn+npmC82zQ+ch
         gaMCyFEJnhGBDaTIeiJomaAdQe+tgPVLZdEM2EGCnZoBlfIF45ERktGlpn9xT41w+DnZ
         vncw==
X-Gm-Message-State: AOAM532wD2/Uu4vVIvgx1SeNKOp3q3RLjCVrhrClfG380AyUZdeHnUVK
        3LuvuJK8mNl5FOW0sVZVLk9UKUTil+9IA6pzep56e+ndj/dzNcLnE/d0t8CxYU5Ql4R6uiQa2BL
        /Qk1pgTXujNiVUPd1
X-Received: by 2002:a17:902:7847:b029:ef:4421:6a2e with SMTP id e7-20020a1709027847b02900ef44216a2emr9969694pln.44.1620783200672;
        Tue, 11 May 2021 18:33:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnOWQX4Mk3jCxH5ECtdPMzPH8hqjnoRf3edC55nxhKlgPAZIcSRNEJvASEQmVclxALyMDBHQ==
X-Received: by 2002:a17:902:7847:b029:ef:4421:6a2e with SMTP id e7-20020a1709027847b02900ef44216a2emr9969662pln.44.1620783200008;
        Tue, 11 May 2021 18:33:20 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m14sm15181976pff.17.2021.05.11.18.33.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 18:33:19 -0700 (PDT)
Subject: Re: [PATCH 4/4] tun: indicate support for USO feature
To:     Yuri Benditovich <yuri.benditovich@daynix.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Yan Vugenfirer <yan@daynix.com>
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-5-yuri.benditovich@daynix.com>
 <eb8c4984-f0cc-74ee-537f-fc60deaaaa73@redhat.com>
 <CAOEp5OdrCDPx4ijLcEOm=Wxma6hc=nyqw4Xm6bggBxvgtR0tbg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <89759261-3a72-df6c-7a81-b7a48abfad44@redhat.com>
Date:   Wed, 12 May 2021 09:33:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOEp5OdrCDPx4ijLcEOm=Wxma6hc=nyqw4Xm6bggBxvgtR0tbg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/11 下午4:33, Yuri Benditovich 写道:
> On Tue, May 11, 2021 at 9:50 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/5/11 下午12:42, Yuri Benditovich 写道:
>>> Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
>>> ---
>>>    drivers/net/tun.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>> index 84f832806313..a35054f9d941 100644
>>> --- a/drivers/net/tun.c
>>> +++ b/drivers/net/tun.c
>>> @@ -2812,7 +2812,7 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
>>>                        arg &= ~(TUN_F_TSO4|TUN_F_TSO6);
>>>                }
>>>
>>> -             arg &= ~TUN_F_UFO;
>>> +             arg &= ~(TUN_F_UFO|TUN_F_USO);
>>
>> It looks to me kernel doesn't use "USO", so TUN_F_UDP_GSO_L4 is a better
>> name for this
> No problem, I can change it in v2
>
>   and I guess we should toggle NETIF_F_UDP_GSO_l4 here?
>
> No, we do not, because this indicates only the fact that the guest can
> send large UDP packets and have them splitted to UDP segments.


Actually the reverse. The set_offload() controls the tuntap TX path 
(guest RX path).

When VIRTIO_NET_F_GUEST_XXX was not negotiated, the corresponding netdev 
features needs to be disabled. When host tries to send those packets to 
guest, it needs to do software segmentation.

See virtio_net_apply_guest_offloads().

There's currently no way (or not need) to prevent tuntap from receiving 
GSO packets.

Thanks


>
>> And how about macvtap?
> We will check how to do that for macvtap. We will send a separate
> patch for macvtap or ask for advice.
>
>> Thanks
>>
>>
>>>        }
>>>
>>>        /* This gives the user a way to test for new features in future by

