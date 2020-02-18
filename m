Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C0216269D
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 14:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgBRNAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 08:00:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56272 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726486AbgBRNAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 08:00:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582030847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UmWZ+c2Jajp9/z1/2SLQOTwzQI2ybbL7KOrLvLb+C30=;
        b=gK91XYz6jxoG48acGcQguWK8CoJNBw2hlvQ76+VjOtYijSngPt0FIKI5kDSHq0Un46I0oO
        e3ULkctcCOry2mJdNQPiB/PqqtOAF04FmazQ77A3dxQ2tjxD1K0mtWLILA3D6+GK4pSN0n
        h47FLPaIDXX1ovi249SgeoMGYhW9wVw=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-5z2YgQTuMSeH_pWy0Fb8OQ-1; Tue, 18 Feb 2020 08:00:45 -0500
X-MC-Unique: 5z2YgQTuMSeH_pWy0Fb8OQ-1
Received: by mail-lj1-f197.google.com with SMTP id m1so7104119lji.5
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 05:00:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=UmWZ+c2Jajp9/z1/2SLQOTwzQI2ybbL7KOrLvLb+C30=;
        b=JjGaq2tcHc1ZGOxh96SmUGPDLv0CuqoQTXX10OKudhg7nHRMcZdhzDpKfMVB5Qyo+Z
         LWkzNmJkwd/6VJdTtnwhP+xt1V+8kDTI+BhiE/KjL1IwFe4kGouIzUpjTIhRUnCKnkn6
         eRZV12j8kFOhffMJukjylHHETTRwa2lMCACS7P6xJUyA8Qs/1B5SaNoxEz4nW7akzJku
         wQeMQVJJK7xNaczixk/3/UUSISe/vzxeMiv+Q2ApDbPulScSLieSokgwW4zp5ylx68MA
         BiAv8pA1iwNT542t4ASz3KwhLL+bJowRlrXiWi7s4yj8rd32gmC8QMz8Cs2rKLyatrem
         YvBg==
X-Gm-Message-State: APjAAAVZh2RAgm4zM+LuUL5jNbbCJd8weOTWuSraLtmi2ts9FrdW/aNB
        Y3ASfalny09ppGFxvlOqq37mi78JVGh9yiCpv5mxtohQe47Be/xd6he3zrSrXUMvXxOW2UcyTLz
        QeyOq90qB4vxXlgwQ
X-Received: by 2002:a19:6509:: with SMTP id z9mr10279639lfb.97.1582030844284;
        Tue, 18 Feb 2020 05:00:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqzgFwjCsczvCnkRutE3lWz7OSft3Pu1I+Ot5JGPYhp+e2spMyvIn8InH/xlm1qejPlJ+QRQPw==
X-Received: by 2002:a19:6509:: with SMTP id z9mr10279622lfb.97.1582030843965;
        Tue, 18 Feb 2020 05:00:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v12sm2482174ljc.94.2020.02.18.05.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 05:00:43 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2251C180365; Tue, 18 Feb 2020 14:00:42 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Quentin Monnet <quentin@isovalent.com>, daniel@iogearbox.net,
        ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf] uapi/bpf: Remove text about bpf_redirect_map() giving higher performance
In-Reply-To: <485aa804-0235-51dc-d3e2-02d71ae17266@isovalent.com>
References: <20200218074621.25391-1-toke@redhat.com> <485aa804-0235-51dc-d3e2-02d71ae17266@isovalent.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 18 Feb 2020 14:00:42 +0100
Message-ID: <8736b8yrr9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Monnet <quentin@isovalent.com> writes:

> 2020-02-18 08:46 UTC+0100 ~ Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com>
>> The performance of bpf_redirect() is now roughly the same as that of
>> bpf_redirect_map(). However, David Ahern pointed out that the header file
>> has not been updated to reflect this, and still says that a significant
>> performance increase is possible when using bpf_redirect_map(). Remove t=
his
>> text from the bpf_redirect_map() description, and reword the description=
 in
>> bpf_redirect() slightly.
>>=20
>> Fixes: 1d233886dd90 ("xdp: Use bulking for non-map XDP_REDIRECT and cons=
olidate code paths")
>> Suggested-by: David Ahern <dsahern@gmail.com>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>   include/uapi/linux/bpf.h | 12 +++---------
>>   1 file changed, 3 insertions(+), 9 deletions(-)
>>=20
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index f1d74a2bd234..7a526d917fb3 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -1045,9 +1045,9 @@ union bpf_attr {
>>    * 		supports redirection to the egress interface, and accepts no
>>    * 		flag at all.
>>    *
>> - * 		The same effect can be attained with the more generic
>> - * 		**bpf_redirect_map**\ (), which requires specific maps to be
>> - * 		used but offers better performance.
>> + * 		The same effect can also be attained with the more generic
>> + * 		**bpf_redirect_map**\ (), which uses a BPF map to store the
>> + * 		redirect target instead of providing it directly to the helper.
>>    * 	Return
>>    * 		For XDP, the helper returns **XDP_REDIRECT** on success or
>>    * 		**XDP_ABORTED** on error. For other program types, the values
>> @@ -1610,12 +1610,6 @@ union bpf_attr {
>>    * 		one of the XDP program return codes up to XDP_TX, as chosen by
>>    * 		the caller. Any higher bits in the *flags* argument must be
>>    * 		unset.
>> - *
>> - * 		When used to redirect packets to net devices, this helper
>> - * 		provides a high performance increase over **bpf_redirect**\ ().
>> - * 		This is due to various implementation details of the underlying
>> - * 		mechanisms, one of which is the fact that **bpf_redirect_map**\
>> - * 		() tries to send packet as a "bulk" to the device.
>>    * 	Return
>>    * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
>>    *
>>=20
>
> We could maybe leave something like =E2=80=9CSee also bpf_redirect()" in =
the=20
> description of "bpf_redirect_map()"?

Sure, why not? I see that I also forgot to fix up the 'Return' part of
bpf_redirect_map(), so I'll send a v2.

> Either way,
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks!

-Toke

