Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242A92FD746
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbhATRgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:36:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388872AbhATRbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 12:31:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611163811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9zPeBw80SHt7q4biUm2LSQ7QrUu1dwImeOlSniheLbs=;
        b=cuMZ+YAJMy9T25pVaRY/xPzRMgo8L0s2/gLkbJZObT8Ekpv06lBauEHVtlfe5X5+6pXaA9
        +4+bmqfKJWm0w8Eomq8KmrEWdoB2IKcoR22Ek1LPt/bZ0+EykecpwxB/HXhfei1njYF6uK
        06Uqq1cQzBgKt2NJWycJSrTAlyzvWU8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-lsTPTm1mNwqcUlUo7PSVjA-1; Wed, 20 Jan 2021 12:30:08 -0500
X-MC-Unique: lsTPTm1mNwqcUlUo7PSVjA-1
Received: by mail-ej1-f71.google.com with SMTP id p1so7746052ejo.4
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 09:30:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=9zPeBw80SHt7q4biUm2LSQ7QrUu1dwImeOlSniheLbs=;
        b=cIYU6BwPOSlrZd75WGWtAvhYWuc2kFUIzM5Nxp0cxzCpehN7cSDOO597arPXZINGUz
         v6OS57WTi0oLW4eM2zCDiWfeyvpznY3kG+8kq6MQyA3JbfC4VjnnJvVkQ/o8WTvNNrrz
         DzRMb9HY8Kz81ZJ8Cjlr5YvOLL1ghmlSxbjm5XBGleyKeJuqqsqxrXmT3nazYMPOWtV8
         SH1iLG3p/S9EomHIadvwtoL8jycV9QmXTVUdPowUAboA4I4bzzPi9Sxj3o5/Ia4wZ4Gv
         yUV7NSoeULirScrwEh0yLli5BaId9CFAfaP2DomSwp2bUGHZlkvoUCRiU2Rn0qvXQXPo
         4h2Q==
X-Gm-Message-State: AOAM531zpxg9ksQVr8vClGEbXqSW3U2Jr6hgT8kH9iCp+Mcjm7le3970
        aYBtL8jMP/vscCf50Bcjz0AjkIO3Kv0kSoiHEVlSifv/3tYX6szSO41qQiUgkPSkO3kyexWjmn2
        IydFM4IPvLPvKslHM
X-Received: by 2002:a17:907:7292:: with SMTP id dt18mr7111154ejc.317.1611163806839;
        Wed, 20 Jan 2021 09:30:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/1fWd3K+SeEdkP1vTv/hq46u+b9ciilfJDdMagMxkdkuUh0lDLfca28TblCcctUioc7ZnoQ==
X-Received: by 2002:a17:907:7292:: with SMTP id dt18mr7111141ejc.317.1611163806619;
        Wed, 20 Jan 2021 09:30:06 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id dj25sm1419317edb.5.2021.01.20.09.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 09:30:06 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C0E86180331; Wed, 20 Jan 2021 18:30:05 +0100 (CET)
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
In-Reply-To: <2751bcd9-b3af-0366-32ee-a52d5919246c@intel.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-6-bjorn.topel@gmail.com> <875z3repng.fsf@toke.dk>
 <6c7da700-700d-c7f6-fe0a-c42e55e81c8a@intel.com>
 <6cda7383-663e-ed92-45dd-bbf87ca45eef@intel.com> <87eeif4p96.fsf@toke.dk>
 <2751bcd9-b3af-0366-32ee-a52d5919246c@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Jan 2021 18:30:05 +0100
Message-ID: <87zh13349u.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:

> On 2021-01-20 16:11, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:
>>=20
>>> On 2021-01-20 14:25, Bj=C3=B6rn T=C3=B6pel wrote:
>>>> On 2021-01-20 13:52, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>>>>
>>>>>> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>>>>>>
>>>>>> Add detection for kernel version, and adapt the BPF program based on
>>>>>> kernel support. This way, users will get the best possible performan=
ce
>>>>>> from the BPF program.
>>>>>
>>>>> Please do explicit feature detection instead of relying on the kernel
>>>>> version number; some distro kernels are known to have a creative noti=
on
>>>>> of their own version, which is not really related to the features they
>>>>> actually support (I'm sure you know which one I'm referring to ;)).
>>>>>
>>>>
>>>> Right. For a *new* helper, like bpf_redirect_xsk, we rely on rejection
>>>> from the verifier to detect support. What about "bpf_redirect_map() now
>>>> supports passing return value as flags"? Any ideas how to do that in a
>>>> robust, non-version number-based scheme?
>>>>
>>>
>>> Just so that I understand this correctly. Red^WSome distro vendors
>>> backport the world, and call that franken kernel, say, 3.10. Is that
>>> interpretation correct? My hope was that wasn't the case. :-(
>>=20
>> Yup, indeed. All kernels shipped for the entire lifetime of RHEL8 think
>> they are v4.18.0... :/
>>=20
>> I don't think we're the only ones doing it (there are examples in the
>> embedded world as well, for instance, and not sure about the other
>> enterprise distros), but RHEL is probably the most extreme example.
>>=20
>> We could patch the version check in the distro-supplied version of
>> libbpf, of course, but that doesn't help anyone using upstream versions,
>> and given the prevalence of vendoring libbpf, I fear that going with the
>> version check will just result in a bad user experience...
>>
>
> Ok! Thanks for clearing that out!
>
>>> Would it make sense with some kind of BPF-specific "supported
>>> features" mechanism? Something else with a bigger scope (whole
>>> kernel)?
>>=20
>> Heh, in my opinion, yeah. Seems like we'll finally get it for XDP, but
>> for BPF in general the approach has always been probing AFAICT.
>>=20
>> For the particular case of arguments to helpers, I suppose the verifier
>> could technically validate value ranges for flags arguments, say. That
>> would be nice as an early reject anyway, but I'm not sure if it is
>> possible to add after-the-fact without breaking existing programs
>> because the verifier can't prove the argument is within the valid range.
>> And of course it doesn't help you with compatibility with
>> already-released kernels.
>>
>
> Hmm, think I have a way forward. I'll use BPF_PROG_TEST_RUN.
>
> If the load fail for the new helper, fallback to bpf_redirect_map(). Use
> BPF_PROG_TEST_RUN to make sure that "action via flags" passes.
>
> That should work for you guys as well, right? I'll take a stab at it.

Yup, think so - SGTM! :)

-Toke

