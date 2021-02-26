Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097DD3262B1
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 13:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhBZM1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 07:27:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229835AbhBZM1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 07:27:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614342387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+HuZK9YuHtlamJ9bRf+S7put/fbfFDgLeI0Ia3hdfE=;
        b=P62NjlhXAyEctsMRx8j1hI/5Ut31gOgHra1G5WOkdYqwu8ItWPeWYcKxcmxg1ZTTDqqVLM
        pZEjrwG6NYgADmwXtf0rbTGyQ3aGwPG5EOoPjyk8/EJSbMP1TT1UCs48PcMKfPegJ7EnHS
        E+TgBkshW8aIElYL7dMC4sBPWKH5iyA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-nyApRVrMNmmhLmU2UE5pOQ-1; Fri, 26 Feb 2021 07:26:25 -0500
X-MC-Unique: nyApRVrMNmmhLmU2UE5pOQ-1
Received: by mail-ej1-f71.google.com with SMTP id v10so4137893ejh.15
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 04:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=S+HuZK9YuHtlamJ9bRf+S7put/fbfFDgLeI0Ia3hdfE=;
        b=rOS13nCdOLWcoTDEGVtHSJvFkKh7fmMyJywhJyRNUUe1Q+KwwjIaCnjmIgnwkiIyrl
         E6TWhuOce0gmveXz/MhxDRXpZZ7Q5Y7SWVDxW5epimTNE2kRqgIV2km2C01qKZKnmmU2
         wgum+N4aotcr6gUYjcwIB14PRicSgnoIV6HGWt8wkvTUNka7hjfMqbifu6obYM/Rl8Qq
         ZV/Dzh8s1Mumu4kJ8Xxa1KIylwVipN5sLAkA22v67a15Nnkj4bFEN3Uq8ypD8+PZvtUw
         HX7IFZu3Km/yvXzEOM61T6rtiwHXK9H/3EGfN7J++X2gQyFV2t9YPC/3VdlL9lZI5wKh
         Au1w==
X-Gm-Message-State: AOAM533E+8PnCWeUQHdm3787mqPe6bgvLOgBv6IciIaGOXavC4cyRI94
        T3GK2UR5vYuPs2zQEbbp6QyWDftQj4OXF9Owkvuku5+m100350bwJONwhJ5h/LoIQOlqCAZTI5V
        BDcrq/aifxhflZEtU
X-Received: by 2002:a17:906:27c7:: with SMTP id k7mr3123816ejc.13.1614342384607;
        Fri, 26 Feb 2021 04:26:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDnyLfpO4T5MsmhrTsPwwhPtU/Xk4tZfLzQHd4PS5Ff9w0zJYOy2fyIw3j6Z/fVgdfMoYfIw==
X-Received: by 2002:a17:906:27c7:: with SMTP id k7mr3123790ejc.13.1614342384251;
        Fri, 26 Feb 2021 04:26:24 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id bz25sm5342641ejc.97.2021.02.26.04.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 04:26:23 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 94B23180094; Fri, 26 Feb 2021 13:26:22 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     maciej.fijalkowski@intel.com, hawk@kernel.org,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next v4 1/2] bpf, xdp: make bpf_redirect_map() a map
 operation
In-Reply-To: <d4910425-82ae-b1ce-68c3-fb5542f598a5@intel.com>
References: <20210226112322.144927-1-bjorn.topel@gmail.com>
 <20210226112322.144927-2-bjorn.topel@gmail.com> <87sg5jys8r.fsf@toke.dk>
 <694101a1-c8e2-538c-fdd5-c23f8e2605bb@intel.com>
 <d4910425-82ae-b1ce-68c3-fb5542f598a5@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Feb 2021 13:26:22 +0100
Message-ID: <87h7lzypzl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:

> On 2021-02-26 12:40, Bj=C3=B6rn T=C3=B6pel wrote:
>> On 2021-02-26 12:37, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
> [...]
>
>>>
>>> (That last paragraph above is why I asked if you updated the performance
>>> numbers in the cover letter; removing an additional function call should
>>> affect those, right?)
>>>
>>=20
>> Yeah, it should. Let me spend some more time benchmarking on the DEVMAP
>> scenario.
>>
>
> I did a re-measure using samples/xdp_redirect_map.
>
> The setup is 64B packets blasted to an i40e. As a baseline,
>
>    # xdp_rxq_info --dev ens801f1 --action XDP_DROP
>
> gives 24.8 Mpps.
>
>
> Now, xdp_redirect_map. Same NIC, two ports, receive from port A,
> redirect to port B:
>
> baseline:    14.3 Mpps
> this series: 15.4 Mpps
>
> which is almost 8%!

Or 5 ns difference:

10**9/(14.3*10**6) - 10**9/(15.4*10**6)
4.995004995005004

Nice :)

-Toke

