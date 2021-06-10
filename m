Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D673A231D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 06:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFJEP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 00:15:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229484AbhFJEPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 00:15:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623298439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IXStafO39ShCtFpSdoned+tL2sBufwLUMd16dxxYX90=;
        b=Rg4H+2Je1TVfHHb9hIhkf7BsIwHgGujUjwJT+o8cQUxMf7N22B5WIU6jj/j4PngmOasr/c
        0evlpWzrGD/l73yMSoJRn4EEOYd4dQsMk96owJ4GbcDYKx7a+TYQHmXPTQdNNjIxrHsuPZ
        zHOqIPhvVtEmh9bWHP5dwlwR98wH+xQ=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-EvMXSb9tNe6mB8L5zqweag-1; Thu, 10 Jun 2021 00:13:57 -0400
X-MC-Unique: EvMXSb9tNe6mB8L5zqweag-1
Received: by mail-pg1-f200.google.com with SMTP id m7-20020a6545c70000b029020f6af21c77so15662423pgr.6
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 21:13:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IXStafO39ShCtFpSdoned+tL2sBufwLUMd16dxxYX90=;
        b=nZTcTmasNiIRrOWIka4zVgJnvlMUVosSDX8ZCy9qRMJYaeqEfhDDFbn2tO/IG9aRe9
         zBx6Mriqx+imwQOrQP+y+EMzb8x5PQYlLFD0UW4XziJqjsDzAHOIzCofDPKfm/dzt6Xz
         D9F6T4k7d1YRMuFrUL2tTx5UjAuTLPAkSqVg73a8iL/7eYqjD6GC/34RReIR0GdK7jat
         84CZXX61K9325LFYqtAGOX4k5ximZLVT1WnKTkQlzvs8sogGhfn+zxiHPX2wRY0wwaAq
         Mc6VcutnsJDC2CdVA+iYXB521tMDZZS5HAure3GLvsy4MnjrZEcasAa048oBo/mhyqU6
         d67w==
X-Gm-Message-State: AOAM530uetZu9eCuzXdCnvR+OCYySGDktkct8/Kf1TDmo+JxUx6vhChl
        i7JVkbcxv8UWwZghmO10RY3dRYtHqVxx0WDP9HSvwHnl1q+R61wgigdH7mK5ziIq1BvtjXvsUrk
        TKZOihkPN0lFdMS+Y
X-Received: by 2002:a17:90a:5883:: with SMTP id j3mr1257835pji.89.1623298435909;
        Wed, 09 Jun 2021 21:13:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIIAyYQ3i5OP6XQayrnoGI/ZfiiBhU4mYBsmwS8XDtcLyd3gQ4kz1suHYz+H8aZ0qLBGOFDA==
X-Received: by 2002:a17:90a:5883:: with SMTP id j3mr1257814pji.89.1623298435724;
        Wed, 09 Jun 2021 21:13:55 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q91sm1018210pja.50.2021.06.09.21.13.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 21:13:55 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
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
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com>
 <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
 <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
 <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com>
 <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com>
Date:   Thu, 10 Jun 2021 12:13:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/10 下午12:05, Alexei Starovoitov 写道:
> On Wed, Jun 9, 2021 at 8:53 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> It works but it couples virtio with bpf.
> Jason,
>
> I think your main concern is that it makes virtio_net_hdr into uapi?


Actually not. Note that, vnet header is already a part of uAPI 
(include/uapi/linux/virtio_net.h).

The concern is that is may confuse the userspace since we will have two 
sets of vnet header uapi (and they are already out of sync).


> That's not the case. __sk_buff is uapi, but pointers to sockets
> and other kernel data structures are not.
> Yes. It's a bit weird that uapi struct has a pointer to kernel internal,
> but I don't see it as a deal breaker.


Yes, but looking at the existing fields of __sk_buff. All are pretty 
generic fields that are device agnostic. This patch breaks this.


> Tracing progs have plenty of such cases.
> In networking there is tcp-bpf where everything is kernel internal and non-uapi.
> So after this patch virtio_net_hdr is free to change without worrying about bpf
> progs reading it.


So I wonder why not simply use helpers to access the vnet header like 
how tcp-bpf access the tcp header?

Thanks

