Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210C5492B0A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 17:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbiARQTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 11:19:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244348AbiARQSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 11:18:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642522685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ILcJ4qL/uWT4PowdfPjtQ0Qex5Vhpd6jaPfQ4SZkE+U=;
        b=jQliMj1WMyqNIQXNqRqxeUT+etC0J/qvZfa6sFSTy80KrhrOuJvbDoTQQZ5yRcdfiQyET2
        7xlLIdjwQFdfNWl7wnH6xsandIc52TZQCNZ6UYBtKSvV6+Bv1WkJrEs08moy4T+t0HcJ9A
        vtx+sR490qY19tGeLINyuelWICHJ6eg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-KaOfPDrCO_CqVyCxx9Dr_Q-1; Tue, 18 Jan 2022 11:18:01 -0500
X-MC-Unique: KaOfPDrCO_CqVyCxx9Dr_Q-1
Received: by mail-ed1-f72.google.com with SMTP id h21-20020aa7c955000000b0040390b2bfc5so1829523edt.15
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 08:17:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ILcJ4qL/uWT4PowdfPjtQ0Qex5Vhpd6jaPfQ4SZkE+U=;
        b=qTzknIJaoomjDSpiIEpP4t33c9nzDVV+sawzfYpQ0ES9X24qySBihrvyq2wYtFVWDe
         ZgTP0AvVBFrdOapqnScoU3bh1qvof5HpijK83nY84OXNB/AqnBMq2qHh/14lT92JBADU
         rkkEO8CgBIdW8oicN8oyqNJ3AiPLoPQWKAFT6wur0PCY244PT0+Fzt1RTXwJNijxIxSV
         FEIuxZZEu9dPef2X8O7mGaHz5ptcZCpYb+Hx6CI1Kxb+BWQxt3A4cWmk5ME70KMzj5Jv
         3OwSadwKL8q2JRB44Ex0AqgSF5mSPjMOYNwUO6hkaOdThtQngVRKCGklLECmIGqHNSMU
         4Dmw==
X-Gm-Message-State: AOAM531q6ondlcAiYo8z0essY+Ar1QC8e/JGo4lOwNpbrwmLmJU3VRGG
        n4OxKnSsLxNLcQAo2yOITtJLeCl2yg0y2hXKLEpnZrQaUbGR7K/6MAWlliD451x+jqi5om05uZw
        glnkcy1smRo7rUkZS
X-Received: by 2002:a17:907:6eac:: with SMTP id sh44mr22149166ejc.179.1642522678174;
        Tue, 18 Jan 2022 08:17:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmBDSd7zHZAwsysU6zQVKYKbM8uqKeqQsYa+nNfSrUnmINvlE2UhCCPlJxSQhXYuFQpzO9oA==
X-Received: by 2002:a17:907:6eac:: with SMTP id sh44mr22149132ejc.179.1642522677712;
        Tue, 18 Jan 2022 08:17:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j4sm69940edk.64.2022.01.18.08.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 08:17:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4D5261804EC; Tue, 18 Jan 2022 17:17:56 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf] libbpf: define BTF_KIND_* constants in btf.h to
 avoid compilation errors
In-Reply-To: <YebeQKsIDDaBMtpW@kernel.org>
References: <20220118141327.34231-1-toke@redhat.com>
 <YebeQKsIDDaBMtpW@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 18 Jan 2022 17:17:56 +0100
Message-ID: <87k0ex81cb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnaldo Carvalho de Melo <acme@kernel.org> writes:

> Em Tue, Jan 18, 2022 at 03:13:27PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n escreveu:
>> The btf.h header included with libbpf contains inline helper functions to
>> check for various BTF kinds. These helpers directly reference the
>> BTF_KIND_* constants defined in the kernel header, and because the header
>> file is included in user applications, this happens in the user applicat=
ion
>> compile units.
>>=20
>> This presents a problem if a user application is compiled on a system wi=
th
>> older kernel headers because the constants are not available. To avoid
>> this, add #defines of the constants directly in btf.h before using them.
>>=20
>> Since the kernel header moved to an enum for BTF_KIND_*, the #defines can
>> shadow the enum values without any errors, so we only need #ifndef guards
>> for the constants that predates the conversion to enum. We group these so
>> there's only one guard for groups of values that were added together.
>>=20
>>   [0] Closes: https://github.com/libbpf/libbpf/issues/436
>
> The coexistence of enums with the defines (in turn #ifndef guarded) as
> something I hadn't considered, clever.

Me neither - that bit was Andrii's idea :)

> Should fix lots of build errors in my test containers :-)
>
> FWIW:
>
> Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Thanks!

-Toke

