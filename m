Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0833A23F4
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 07:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFJFZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 01:25:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230255AbhFJFZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 01:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623302639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cQAWV6+xELYFimr4307JFkGjR0Djgx1k9GWHA/hI38=;
        b=I/Cujullrf3wF2IJJlM/hlNDnRDKuD82mTEP9IOVpyRRyUGdNobG2zaCXAp/uH+D3F8m9w
        BW2X7t13fyM5gCjLR+i3oYQNpXL+2ul++uPKOoPF0iNgeWXH3lWmA8nDhbOKC51O7Q3dwQ
        M5g0Iu8JzZFvGOdPj3Sf0kBMgZPh9rk=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-e9-pB0ftOc60HPlZZqlbAw-1; Thu, 10 Jun 2021 01:23:55 -0400
X-MC-Unique: e9-pB0ftOc60HPlZZqlbAw-1
Received: by mail-pf1-f197.google.com with SMTP id k22-20020aa788d60000b02902ec984951ffso580674pff.11
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 22:23:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=1cQAWV6+xELYFimr4307JFkGjR0Djgx1k9GWHA/hI38=;
        b=Oybk9FGONEpxaKMyAVEL1eLL8WJPK6Qgydh3k9Kfolly9cmU6rwuZVwxkCj0Gx3ier
         pTcoyTTkdL+abGk2ofgu2oPTwMeDe5Yy78PwnIt/Xnt+3vxRdqln+KNlwuPfgSMD80iX
         JFRUsWemTjy4q6Om/MEowG8k07h8gZXVReW33YDSbluy/LpHWmvtMBbILUiRRQ+4OdAG
         npcsLSbXWbyYGobKe7JtD9b6W2aWrQzqzbuOPdThPdyfZ+YGlZrVLryLoB9A0HI4bYj6
         37hLPbbhxu+SreRFfL2/rtDap6Fh1lP7TcS3HjFNsUb8o4TVYcld6LGj8QDZdx+BxumQ
         xENQ==
X-Gm-Message-State: AOAM5318R1j4UFiTy4NhvymTvaakgY+ReDszu90uODPorZiv7emrND3m
        BRZlGok5lZ4EPJjF8cSieA7VbofSJaBn7hJfjBqcZjwqwCz/1lRNyKzdBlPZE6+2sQ3rVqATHm+
        rxqSMI/JYpTgqeqGg
X-Received: by 2002:a63:7f0f:: with SMTP id a15mr3248144pgd.380.1623302634137;
        Wed, 09 Jun 2021 22:23:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxp9v7qBB1T+Ig7Gtki4tX6BOR7rqTrBDR5jOPTczyAGAFQ2b7KszeKE76FYh4QiwRdig3nFg==
X-Received: by 2002:a63:7f0f:: with SMTP id a15mr3248125pgd.380.1623302633912;
        Wed, 09 Jun 2021 22:23:53 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f28sm1313417pgb.12.2021.06.09.22.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 22:23:53 -0700 (PDT)
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
 <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com>
 <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2fd24801-bf77-02e3-03f5-b5e8fac595b6@redhat.com>
Date:   Thu, 10 Jun 2021 13:23:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/10 下午12:19, Alexei Starovoitov 写道:
> On Wed, Jun 9, 2021 at 9:13 PM Jason Wang <jasowang@redhat.com> wrote:
>> So I wonder why not simply use helpers to access the vnet header like
>> how tcp-bpf access the tcp header?
> Short answer - speed.
> tcp-bpf accesses all uapi and non-uapi structs directly.
>

Ok, this makes sense. But instead of coupling device specific stuffs 
like vnet header and neediness into general flow_keys as a context.

It would be better to introduce a vnet header context which contains

1) vnet header
2) flow keys
3) other contexts like endian and virtio-net features

So we preserve the performance and decouple the virtio-net stuffs from 
general structures like flow_keys or __sk_buff.

Thanks

