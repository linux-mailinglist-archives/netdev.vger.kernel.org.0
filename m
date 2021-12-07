Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFA346C213
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 18:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbhLGRua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 12:50:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32077 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235418AbhLGRu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 12:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638899219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nc7TBIyvl0E52gatV94RLe7VkQplS01YlcBXFvUb8pY=;
        b=hqRWEYnRQ1vAgiEqajNJHOTwix4VVCiZvsqzBYu/MFkKRh8rdkEt39uHNpXSqumCcxOsmY
        RPcNxzGzE0GTRh3ilywUmuCcAJdMs6jiiHEgmeiUoVigXsgf+yo2CnxwkWV0J6kihTmfeU
        22+unYyHCQl0Q4N3E0YwPodf3V0IvW0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-UhQnrwSyMqWd4FDUQhRhNw-1; Tue, 07 Dec 2021 12:46:57 -0500
X-MC-Unique: UhQnrwSyMqWd4FDUQhRhNw-1
Received: by mail-ed1-f72.google.com with SMTP id k7-20020aa7c387000000b003e7ed87fb31so12212659edq.3
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 09:46:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Nc7TBIyvl0E52gatV94RLe7VkQplS01YlcBXFvUb8pY=;
        b=rN4Vdp2DLM3VoPidAhLy5TRsEMBgep55nIewZiF1A/DFG32s4+p2k/pwOw8prGYus5
         O32lELgLoEQQnBDXhPhPNkBqEIzXVdgBVYUOfJaZDcRvHrNqBUll63Bq2Vi9oWSnC1yc
         1oH6jty7emOWY/dlD3dMKUKSyWOZT/dK1u2afukJE72eTfgvaz4Pn9LaHCF0dZiLIp0B
         4vsXv5mS+m3cOp+qMIzP05y3euPGQnOhxgW1bRQ0rdPAE/Ok8/tbBylrsGIr/gYWykju
         RBeYFfeAhTbUURJLMuMmS9BbXhpRf6m4ndcPkiOnoKLXf01usub8ygeegNIpO2rZYbre
         i1CQ==
X-Gm-Message-State: AOAM533TQ3CgPsg3AomlRaxl97qYx3jnq/n+h6sY/J93t9diynEJFx7w
        4PVfJ7L+GKd7AVKkxEmgvu47NH+/1DBnK3/JL6uKvep38f2m5P8jEED7RKVjCrQJe150V5KZe7W
        tadYOlyNoXczFmSwL
X-Received: by 2002:a05:6402:2792:: with SMTP id b18mr11116251ede.329.1638899216202;
        Tue, 07 Dec 2021 09:46:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZ2ZBeERXcKFGiVR8nFXYcIVoorrdcRFYqZq0nwabrOQN8RK1Ih1HtrfB3Tr2MMMsEhI6AaA==
X-Received: by 2002:a05:6402:2792:: with SMTP id b18mr11116206ede.329.1638899215852;
        Tue, 07 Dec 2021 09:46:55 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id sh30sm122171ejc.117.2021.12.07.09.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 09:46:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 157C5180441; Tue,  7 Dec 2021 18:46:54 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] tc: Add support for
 ce_threshold_value/mask in fq_codel
In-Reply-To: <74649aca-b760-2e8d-2a9c-6cdf937592a5@gmail.com>
References: <20211123201327.86219-1-toke@redhat.com>
 <765eb3d8-7dfa-2b28-e276-fac88453bc72@gmail.com> <87bl1u4sl9.fsf@toke.dk>
 <74649aca-b760-2e8d-2a9c-6cdf937592a5@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 07 Dec 2021 18:46:54 +0100
Message-ID: <871r2oz4s1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> [ vger seems to be having problems; just received this ]
>
> On 12/5/21 3:03 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> David Ahern <dsahern@gmail.com> writes:
>>=20
>>> On 11/23/21 1:13 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for su=
bset
>>>> of traffic") added support in fq_codel for setting a value and mask th=
at
>>>> will be applied to the diffserv/ECN byte to turn on the ce_threshold
>>>> feature for a subset of traffic.
>>>>
>>>> This adds support to tc for setting these values. The parameter is
>>>> called ce_threshold_selector and takes a value followed by a
>>>> slash-separated mask. Some examples:
>>>>
>>>>  # apply ce_threshold to ECT(1) traffic
>>>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold=
_selector 0x1/0x3
>>>>
>>>>  # apply ce_threshold to ECN-capable traffic marked as diffserv AF22
>>>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold=
_selector 0x50/0xfc
>>>>
>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>> ---
>>>>  tc/q_fq_codel.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 40 insertions(+)
>>>
>>> please re-send with an update to
>>=20
>> With an update to? :)
>>=20
>
> ... man page.

Ah yes, of course; will do!

-Toke

