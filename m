Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBEA3B3F17
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 10:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFYI1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 04:27:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229764AbhFYI1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 04:27:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624609531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xZT1eWwSl2gWm9TJxiG1euPIAbDLGMNVs+rDy05LtXI=;
        b=iusEJTsq5UwuE4CaR9juQ7333rmR42BVFT384OI8v6vXF482adArsmrFkAR90ALkZ/cX73
        a4SRcXg7caoWzc1CvorUhTRpGegVhgyWesWaHFl0+txE0jSZgxJo7pPl01Qb2pkzRJgGVL
        8tgInjCbE0NjFep9dqANADmqyFbF3dI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-KlEsRUIKO6qpLeBGs8aVwg-1; Fri, 25 Jun 2021 04:25:29 -0400
X-MC-Unique: KlEsRUIKO6qpLeBGs8aVwg-1
Received: by mail-ej1-f70.google.com with SMTP id j26-20020a170906411ab02904774cb499f8so2831289ejk.6
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 01:25:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xZT1eWwSl2gWm9TJxiG1euPIAbDLGMNVs+rDy05LtXI=;
        b=ICZ8lfwfrltU13lxas5OwGxVUuBIAhGACEdIn8ZvKGUg9N8KaVwKW4EMVYiQWFKhp7
         2JXxMu+0YaG+rSJkHwT5PBOwa3hsT2m4QYC8HwpUcMaS5jLDPakLXqn/KJagr5wMMHPC
         DgiC57SHfHSUm5Gq5XS/12HDLBZW+1rr1chU8nHg6jjO19Oo6nsu7O8bZWJIa6I37K9G
         A0ZrNJjkfow3GGapAn9P1VYKIoqcdOsUljuaq26SIStNHlyiQCwwOKlwxz2l9lbo1k/5
         zANWe3gC12WwhF56ffsU4eJIzl7/X8bs8jrZiFh4M5x2WypYbmRZlWFNrO67XJTU1EpS
         niCw==
X-Gm-Message-State: AOAM5304KkbTTJ0iO6krPU6j8aidkxMDrMrvtymVWQ00VKyXvNuYjzFI
        jlmZhEWBJFx+Lg0/h/eip9Gb394O39yEoqAd9RrCi/hni6HV6uLUyxk2v/6Jm7zKiU/kd9hqC7t
        PD1Jh4pEGNMB6pCEB
X-Received: by 2002:a05:6402:1d55:: with SMTP id dz21mr12590916edb.338.1624609528803;
        Fri, 25 Jun 2021 01:25:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkE4jDXXqx+GNZrlBP6kzqYdNu1Tdl/P85WqCxWgwwC6C3D91FQ4pxMxW0Osxnkv94oiyv4g==
X-Received: by 2002:a05:6402:1d55:: with SMTP id dz21mr12590895edb.338.1624609528620;
        Fri, 25 Jun 2021 01:25:28 -0700 (PDT)
Received: from [10.36.113.16] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id x17sm3539734edr.88.2021.06.25.01.25.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jun 2021 01:25:28 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v9 bpf-next 10/14] bpf: add multi-buffer support to xdp copy helpers
Date:   Fri, 25 Jun 2021 10:25:26 +0200
X-Mailer: MailMate (1.14r5816)
Message-ID: <911124FA-EE96-495C-AFC3-578B2D38247E@redhat.com>
In-Reply-To: <60d49690a87ae_2e84a2082c@john-XPS-13-9370.notmuch>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <4d2a74f7389eb51e2b43c63df76d9cd76f57384c.1623674025.git.lorenzo@kernel.org>
 <60d27716b5a5a_1342e208d5@john-XPS-13-9370.notmuch>
 <34E2BF41-03E0-4DEC-ABF3-72C8FF7B4E4A@redhat.com>
 <60d49690a87ae_2e84a2082c@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24 Jun 2021, at 16:28, John Fastabend wrote:

> Eelco Chaudron wrote:
>>
>>
>> On 23 Jun 2021, at 1:49, John Fastabend wrote:
>>
>>> Lorenzo Bianconi wrote:
>>>> From: Eelco Chaudron <echaudro@redhat.com>
>>>>
>>>> This patch adds support for multi-buffer for the following helpers:
>>>>   - bpf_xdp_output()
>>>>   - bpf_perf_event_output()
>>>>
>>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>>> ---
>>>
>>> Ah ok so at least xdp_output will work with all bytes. But this is
>>> getting close to having access into the frags so I think doing
>>> the last bit shouldn't be too hard?
>>
>>
>> Guess you are talking about multi-buffer access in the XDP program?
>>
>> I did suggest an API a while back, https://lore.kernel.org/bpf/FD3E6E0=
8-DE78-4FBA-96F6-646C93E88631@redhat.com/ but I had/have not time to work=
 on it. Guess the difficult part is to convince the verifier to allow the=
 data to be accessed.
>
> Ah great I think we had the same idea I called it xdp_pull_data()
> though.
>
> Whats the complication though it looks like it can be done by simply
> moving the data and data_end pointers around then marking them
> invalidated. This way the verifier knows the program needs to
> rewrite them. I can probably look more into next week.
>
> From my first glance it looks relatively straight forward to do
> now. I really would like to avoid yet another iteration of
> programs features I have to discover and somehow work around
> if we can get the helper into this series. If you really don't
> have time I can probably take a look early next week on an
> RFC for something like above helper.

I=E2=80=99m on a small side project for the next 2 to 3 weeks, and after =
that, I have some PTO, so if you have time for an RFC, that will speed up=
 this patchset.

Thanks,

Eelco


> .John

