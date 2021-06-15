Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DD03A79AB
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 10:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhFOI7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 04:59:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231152AbhFOI73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 04:59:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623747445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tqLWrDlWhDn1DkHinR/qoEfE83Hw/kZV1e5ZCV5vfv8=;
        b=hLaLxOqT3VOptksZFvTQ932zD4ZePvossKrwa2wG3U6tD6259yZuXywsHLPdkivar8zDFH
        JfK5sVYdCigkVqFBIOTcz0vXvrVng+to/kwsSMXyXv57rHW33sr5AXWBjwh2BYJRO+Xm16
        P2mD+Jk/MkpqW5tnU65OX7vWu5/ZybU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-PQ2phSHDOkyuS78Pv837vA-1; Tue, 15 Jun 2021 04:57:23 -0400
X-MC-Unique: PQ2phSHDOkyuS78Pv837vA-1
Received: by mail-pf1-f200.google.com with SMTP id o11-20020a62f90b0000b02902db3045f898so9872682pfh.23
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 01:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tqLWrDlWhDn1DkHinR/qoEfE83Hw/kZV1e5ZCV5vfv8=;
        b=Qms44QqNYZPyy3WM5R3deWyTpkRDwQ7qy3eiObugDjIuR/JkRffvtaEXTmwzD0/Fel
         7cnCq/BM9DBg/mYXk5lxFvowaygXfzoMc5nphvz9c0yWW0qj0FeGnvny6k5ZPZIBzXzy
         W/xelbEmNoq7w8A/I+KnpcOq7eeJ5vNLB213ydcGDHJQ/seEs6QIaGbmVtztw9DNudl6
         jjCHFrE57Xo0REriqos1P5GrHRvZ3nDXDuB3RT5cEfkId716unpUQFIwaCSX1cZPJ621
         SLaPceGpTIwBI+VVBdvDBt/pBzrfvtGKHqzQL39QiOJxs6h6p82po/KyCOTy5C7Lxowj
         EIdg==
X-Gm-Message-State: AOAM533f0o51/8HQ5tLQ6Z8hqsFXckPdhT9S5dhrUXFI9W1cHg3IDHqa
        ICbpVPqnJEI7E5xakt6wDvSY3SYAG177y9gCD52jTXf6VPKfZFzZnjVotC3VQAGzI4lz7r0/aFF
        EhpgdOYZxvHfvOUUE
X-Received: by 2002:a62:2bc6:0:b029:2cc:242f:ab69 with SMTP id r189-20020a622bc60000b02902cc242fab69mr3417520pfr.16.1623747442045;
        Tue, 15 Jun 2021 01:57:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEv3FuQ/eIS0qeT5nCGMdnoNixrxL9mW3w1FbRl3dFkC7PQBvI406OXEcp9fWFBFZofssfaQ==
X-Received: by 2002:a62:2bc6:0:b029:2cc:242f:ab69 with SMTP id r189-20020a622bc60000b02902cc242fab69mr3417509pfr.16.1623747441871;
        Tue, 15 Jun 2021 01:57:21 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z9sm10314769pfa.2.2021.06.15.01.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 01:57:21 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Tanner Love <tannerlove.kernel@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
 <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com>
 <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
 <2fd24801-bf77-02e3-03f5-b5e8fac595b6@redhat.com>
 <CA+FuTSeuq4K=nA_JPomyZv4SkQY0cGWdEf1jftx_1Znd+=tOZw@mail.gmail.com>
 <8f2fd333-1cc6-6bcc-3e7d-144bbd5e35a3@redhat.com>
 <CA+FuTSdhL+BsqzRJGJD9XH2CATK5-yDE1Uts8gk8Rf_WTsQAGw@mail.gmail.com>
 <4c80aacf-d61b-823f-71fe-68634a88eaa6@redhat.com>
 <CA+FuTSffghgcN5Prmas395eH+PAeKiHu0N6EKv5GwvSLZ+Jm8Q@mail.gmail.com>
 <CAHrNZNjfNU-XPHk+XHoXQ78PZeFNA3dZAg1kfFexgcH522j=jQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ff8097bd-9f34-07d4-69e9-9bb6e075aaf8@redhat.com>
Date:   Tue, 15 Jun 2021 16:57:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHrNZNjfNU-XPHk+XHoXQ78PZeFNA3dZAg1kfFexgcH522j=jQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/15 上午4:41, Tanner Love 写道:
>>>> The only metadata that can be passed with tuntap, pf_packet et al is
>>>> virtio_net_hdr.
>>>>
>>>> I quite don't understand where xen-netfront et al come in.
>>> The problem is, what kind of issue you want to solve. If you want to
>>> solve virtio specific issue, why do you need to do that in the general
>>> flow dissector?
> Suppose we determine that it would indeed also be good to add
> support for xen-netfront, netvsc validation in this way. Is your
> suggestion that these would need to be added all in the same patch
> series?


No.


> Could we not implement just virtio-net first, and add the
> others subsequently, if we can demonstrate a feasible plan for
> doing so? Thanks


Yes, as replied in another thread. I want to make sure whether doing 
this via flow dissector is the best way.

Thanks


>

