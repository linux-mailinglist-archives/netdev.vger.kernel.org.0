Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C30E3AFB1D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 04:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhFVCkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 22:40:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230045AbhFVCj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 22:39:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624329463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+6lEKuTpUZAqGKNGCK7fOpQQ6ukKT4PFrnQet1vlmFk=;
        b=ReimVINSzhaOYuiXhXmTx8BYT5XY+o5Ak7+kGDONeoPFqey9fMqA9I5VCe7FQAbs3lK/Y/
        psF6SWETACxkJ4cJBPVX233uOLqNolXUybXGBc4txfHCrCjAZCWgyZegTyDwnfqniSQn2n
        mlLyqoAKMA3Rjlr7DiqvJ1wQ58xDwCs=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-oHnzNoRNN9aak3rUI27DuA-1; Mon, 21 Jun 2021 22:37:41 -0400
X-MC-Unique: oHnzNoRNN9aak3rUI27DuA-1
Received: by mail-pg1-f197.google.com with SMTP id k14-20020a63d84e0000b029022216b0ebf2so6627691pgj.15
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 19:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+6lEKuTpUZAqGKNGCK7fOpQQ6ukKT4PFrnQet1vlmFk=;
        b=VPtoBAaAJtHgi59h5erGAEmi7l6LqAivjmKtcm25fii0AMNujdO/3CgQUO81gf9h57
         4heJrX1WBkBCxI7ym1VnRGav7mBJ4p1AnHd4j4BVqGbX5/exNBYYxDoppsyGA+eBpMXA
         0amgo/N46MofxOioh1wRsbvhh8h280QAik7SCvwqr9MPYZLhAoHQXzhz8MZOe/dBt5+j
         xubBIqCmFQ8D23dcvuqt5Bw4hbyIQ8qTWVOTLbwSHJFZS2PJrQyQLZ0nBBDw0ul/4Cdm
         qvfiEqNovoUAthgx9zpvddDrJ3HjR3Hd/3DLO68vITvZEPcQ7lBqq4x9rLOxHZ0Ii6HX
         s+Mw==
X-Gm-Message-State: AOAM533LpttcFmGdjMYuwUXDloMvhm9xabsMonJwYwhjnwdRCFPe2mrg
        64/rZBlJZ439Sw0G/caDuVQ3ubokH0MwINIuycsZbJL/fS/n8lFcqVokx2MLIfwY369QZ24Lsbo
        R1qITQtFXrLCKUxUL
X-Received: by 2002:a63:4522:: with SMTP id s34mr1494983pga.251.1624329460730;
        Mon, 21 Jun 2021 19:37:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQyHTkmjJXsiXIT8UB4Np7LOvX/hXGIcFka90BqZgMMD+o09krmXbq6Zf1PX7sH4Np88WLWg==
X-Received: by 2002:a63:4522:: with SMTP id s34mr1494953pga.251.1624329460324;
        Mon, 21 Jun 2021 19:37:40 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x22sm481781pjp.37.2021.06.21.19.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 19:37:39 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Tanner Love <tannerlove.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Tanner Love <tannerlove@google.com>
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
 <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com>
 <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
 <2fd24801-bf77-02e3-03f5-b5e8fac595b6@redhat.com>
 <CA+FuTSeuq4K=nA_JPomyZv4SkQY0cGWdEf1jftx_1Znd+=tOZw@mail.gmail.com>
 <8f2fd333-1cc6-6bcc-3e7d-144bbd5e35a3@redhat.com>
 <CA+FuTSdhL+BsqzRJGJD9XH2CATK5-yDE1Uts8gk8Rf_WTsQAGw@mail.gmail.com>
 <4c80aacf-d61b-823f-71fe-68634a88eaa6@redhat.com>
 <CA+FuTSffghgcN5Prmas395eH+PAeKiHu0N6EKv5GwvSLZ+Jm8Q@mail.gmail.com>
 <d7e2feeb-b169-8ad6-56c5-f290cdc5b312@redhat.com>
 <CAF=yD-J7kcXSqrXM1AcctpdBPznWeORd=z+bge+cP9KO_f=_yQ@mail.gmail.com>
 <7a63ca2a-7814-5dce-ce8b-4954326bb661@redhat.com>
 <CA+FuTScJtyzx4nhoSp1fb2UZ3hPj6Ac_OeV4_4Tjfp8WvUpB1g@mail.gmail.com>
 <58202b1c-945d-fc9e-3f24-2f6314d86eaa@redhat.com>
 <CA+FuTSekbW9PG_QbA2T6tG6Go2-CGRn9gYyJWUY38Nqz6EqaoA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <67aa8472-bb3d-8186-35f1-ec6682fa8602@redhat.com>
Date:   Tue, 22 Jun 2021 10:37:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSekbW9PG_QbA2T6tG6Go2-CGRn9gYyJWUY38Nqz6EqaoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/21 下午9:18, Willem de Bruijn 写道:
>>>> 2) use some general fields instead of virtio-net specific fields, e.g
>>>> using device header instead of vnet header in the flow keys strcuture
>>> Can you give an example of what would be in the device header?
>>>
>>> Specific for GSO, we have two sets of constants: VIRTIO_NET_HDR_GSO_..
>>> and SKB_GSO_.. Is the suggestion to replace the current use of the
>>> first in field flow_keys->virtio_net_hdr.gso_type with the second in
>>> flow_keys->gso_type?
>>
>> No, I meant using a general fields like flow_keys->device_hdr. And use
>> bpf helpers to access the field.
> What would be in this device_hdr field, and what would the bpf helpers
> access? I don't fully follow what this is if not vnet_hdr.


For virtio-net, it should be just vnet_hdr. Maybe "device_hdr" is not 
accurate, "packet_hdr" should be better.

This allows the field to be reused by other type of userspace injected 
packet, like tun packet info.

Bpf helpers could be used to access the packet header in this case.

Thanks


>

