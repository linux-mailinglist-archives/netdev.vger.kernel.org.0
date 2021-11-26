Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C833B45F0C7
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 16:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378133AbhKZPiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 10:38:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377921AbhKZPgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 10:36:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637940772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t1+6lLBKzRsOvvoLZavbDMeX/0SVAxdl2+X6EFyhRfA=;
        b=Z0D2cbgl1d/O52LG6dk6OhwcvgBEDbsVFKAOObngv/X2zeiGKdy5f2zt/vic1SK8jADdY7
        CmMg+GlmxFS/KD7TRZBc5r7FKTKDX0T5UEmQ27EBfiDdEwtYrGK8LvodP2GyaAimwXYIDU
        VPvmao3r3M4o3nuUwv8j77hSTumG5Ws=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-598-A6JILXKBON2Bggy4XzakeQ-1; Fri, 26 Nov 2021 10:32:51 -0500
X-MC-Unique: A6JILXKBON2Bggy4XzakeQ-1
Received: by mail-wm1-f70.google.com with SMTP id g80-20020a1c2053000000b003331a764709so7062647wmg.2
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 07:32:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=t1+6lLBKzRsOvvoLZavbDMeX/0SVAxdl2+X6EFyhRfA=;
        b=ws2UjhLXtO5tZ4VPtTa2vEdmUX1/zAZQkXoF/61aKMUS347vGFzLq83cXVSZuwrlBr
         mhrL/RHdwOJhyzVjtVbSZ8ndQDQS+06ESuuaZ6rUQ+fMTtAXcO2MtzndIHvzwNOo8Rrn
         tbJvegUlwwVu2vR+g/bXx+BP1MWRD6rHVrS+7wMDRhfuJCvpBwvcqBpLC94agui7qxeA
         fChsaxN4bLN5M5TzK2u+PYGrcIUXgGKmNDUmzBuvs80Is3YPwV+tMxEpwAE+3rDZLeYd
         1imBcE+tSazbn7WlCVu0rnCC1Eq1DEJV2t1zaIMLv2+kNqRDjilaSWZmZg2VNgK3/tBw
         S4yw==
X-Gm-Message-State: AOAM532DtiAP8YleOx8k9+0HCz61TtGWOFcf63xK9+1SgW7v/EIl0h2a
        vTW6vIT9JdwSJtn4jowOywnCkGbIzwc5lPn+0+lMwGX2QaUJWz1eSKBOdBQPq/uX7OcB/aP7Tlb
        MiZBu9HYV46msSEuZ
X-Received: by 2002:adf:fb09:: with SMTP id c9mr14519910wrr.223.1637940769682;
        Fri, 26 Nov 2021 07:32:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgfSH4rBkDxJpw/E0R3JU0oHbTtNz0X3Ozh45JI/JWmFIsykZ0b2AySxDMJwQ9RLbXRKFf9Q==
X-Received: by 2002:adf:fb09:: with SMTP id c9mr14519899wrr.223.1637940769532;
        Fri, 26 Nov 2021 07:32:49 -0800 (PST)
Received: from [192.168.2.13] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id h17sm11479193wmb.44.2021.11.26.07.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 07:32:49 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <66f62ef7-f4c6-08df-a8e1-dbbe34b9b125@redhat.com>
Date:   Fri, 26 Nov 2021 16:32:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bjorn@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, magnus.karlsson@intel.com
Subject: Re: [Intel-wired-lan] [PATCH net-next 1/2] igc: AF_XDP zero-copy
 metadata adjust breaks SKBs on XDP_PASS
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
References: <163700856423.565980.10162564921347693758.stgit@firesoul>
 <163700858579.565980.15265721798644582439.stgit@firesoul>
 <YaD8UHOxHasBkqEW@boxer>
In-Reply-To: <YaD8UHOxHasBkqEW@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/11/2021 16.25, Maciej Fijalkowski wrote:
> On Mon, Nov 15, 2021 at 09:36:25PM +0100, Jesper Dangaard Brouer wrote:
>> Driver already implicitly supports XDP metadata access in AF_XDP
>> zero-copy mode, as xsk_buff_pool's xp_alloc() naturally set xdp_buff
>> data_meta equal data.
>>
>> This works fine for XDP and AF_XDP, but if a BPF-prog adjust via
>> bpf_xdp_adjust_meta() and choose to call XDP_PASS, then igc function
>> igc_construct_skb_zc() will construct an invalid SKB packet. The
>> function correctly include the xdp->data_meta area in the memcpy, but
>> forgot to pull header to take metasize into account.
>>
>> Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
>> Signed-off-by: Jesper Dangaard Brouer<brouer@redhat.com>
> Acked-by: Maciej Fijalkowski<maciej.fijalkowski@intel.com>
> 
> Great catch. Will take a look at other ZC enabled Intel drivers if they
> are affected as well.

Thanks a lot for taking this task!!! :-)
--Jesper

