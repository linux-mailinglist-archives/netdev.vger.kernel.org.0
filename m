Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE9D2FD37E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390086AbhATPAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:00:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30536 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390189AbhATO63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:58:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611154623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fwvMFPt1WboLcOoH23UIfhd2xo9KC7W2tNFuZGnH5tg=;
        b=LuAN7x0ZV57AWkU+pMrVnXFbb8SjIbUZJvxr1rATfEJ+0q1bB42C3l5P9b7UqObHbuo0wg
        yXkqxX7xow/cKvAXaNRl12gr4zMMpyfkRHaf8hVcoxCS8thkVM78ezlXKSQ95/M7Nr75a2
        Nuk/krXbHiMpvMup1Le62uFSqqJNqmA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-UXz-kkMyOjyv8M43K_Ovxw-1; Wed, 20 Jan 2021 09:56:59 -0500
X-MC-Unique: UXz-kkMyOjyv8M43K_Ovxw-1
Received: by mail-ej1-f72.google.com with SMTP id dc21so5882001ejb.19
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:56:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=fwvMFPt1WboLcOoH23UIfhd2xo9KC7W2tNFuZGnH5tg=;
        b=sG5N5eTz4vJONoxuBK3GiEc4GrFKLbW3Y7yhkl5LtUsaXKPoVb4Wx+HHM0Eym6Gtxz
         jJYx1Q3N1M66ROmhx4w3d9zHBtboGGXzjjTlN3QOORsEORFEWXc4kjnjOIbqpWfT+tSz
         zHb2slkwvStzfuELyV0c32XP0DMXGI37y0dVjyl37r7Q8B6s3u0g9iOVcneLfcao6kf/
         a4gSJAsukzI6hfhnRutrtCpd2cozmHN8RVnG4SDafkP0Z/IuQKlgswucjI+iOzNjcUDI
         fr68SVlZh3cSdY7J+3DNm07t9diwZyxy09ZcXZaPpJ2A0jHyaepJui748ev1ZjvRYxLp
         VUIA==
X-Gm-Message-State: AOAM532Hvho7k5HhecOWG7zPLj67ldQ2TI8hrO3GN9p27TDcC0VnzkFQ
        uzk07HXEQp4S6Pv4PQdyCZz+vLLyc55bC0dxaHG1VM2ignjb5u8Z4pABrwGY4tb3PU3c1J4S1Pl
        tQBdouR+Kbmod0oFN
X-Received: by 2002:aa7:d2d4:: with SMTP id k20mr7518632edr.361.1611154618201;
        Wed, 20 Jan 2021 06:56:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy99WUOs30PTEEP3IzAalAndtcfLMV0Alj0wITXpTucPw6kGqbpjitK+lVUsQrpGBXLVfgbTg==
X-Received: by 2002:aa7:d2d4:: with SMTP id k20mr7518623edr.361.1611154617989;
        Wed, 20 Jan 2021 06:56:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w16sm1313993edv.4.2021.01.20.06.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:56:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 378D5180331; Wed, 20 Jan 2021 15:56:57 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        Marek Majtyka <alardam@gmail.com>
Subject: Re: [PATCH bpf-next v2 5/8] libbpf, xsk: select AF_XDP BPF program
 based on kernel version
In-Reply-To: <6c7da700-700d-c7f6-fe0a-c42e55e81c8a@intel.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-6-bjorn.topel@gmail.com> <875z3repng.fsf@toke.dk>
 <6c7da700-700d-c7f6-fe0a-c42e55e81c8a@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Jan 2021 15:56:57 +0100
Message-ID: <87h7nb4pxi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:

> On 2021-01-20 13:52, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>=20
>>> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>>>
>>> Add detection for kernel version, and adapt the BPF program based on
>>> kernel support. This way, users will get the best possible performance
>>> from the BPF program.
>>=20
>> Please do explicit feature detection instead of relying on the kernel
>> version number; some distro kernels are known to have a creative notion
>> of their own version, which is not really related to the features they
>> actually support (I'm sure you know which one I'm referring to ;)).
>>
>
> Right. For a *new* helper, like bpf_redirect_xsk, we rely on rejection
> from the verifier to detect support. What about "bpf_redirect_map() now
> supports passing return value as flags"? Any ideas how to do that in a
> robust, non-version number-based scheme?

Well, having a BPF program pass in a flag of '1' with an invalid lookup
and checking if it returns 1 or 0. But how to do that from libbpf, hmm,
good question. BPF_PROG_RUN()?

An alternative could be to default to a program that will handle both
cases in the BPF code, and make it opt-in to use the optimised versions
if the user knows their kernel supports it?

-Toke

