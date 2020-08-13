Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FF8243F7F
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 21:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHMTw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 15:52:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbgHMTw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 15:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597348346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+0ZAv3XuYoyluR+uscshG57rONyU2cJTmbD4q6O/Rek=;
        b=EME2oeCx5higCEF2qjavBTPjmVnn8QwN44gFSqvDE81ZTfCBTpFUrdimRGpWQg3bsM8Is4
        X7ss9Fk30+e8K842sxxIRuoWEXR2Pdj2UPvRtZ6D1Zb2gnqeooKpaSqhooJVCrFZnRtELn
        DZA9QTyT3nNpsCqxALQdyhBfhydg9/o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-7Vq5ziR3MAyS8jJCI5TWDg-1; Thu, 13 Aug 2020 15:52:23 -0400
X-MC-Unique: 7Vq5ziR3MAyS8jJCI5TWDg-1
Received: by mail-wm1-f72.google.com with SMTP id a5so2538841wmj.5
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 12:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=+0ZAv3XuYoyluR+uscshG57rONyU2cJTmbD4q6O/Rek=;
        b=CHEevcywze9sv30YbUYzUbAYiGvPpiiMeKU9amhLR6BX8mgGwXkDJcMrblZHI2hfVl
         Bc7ErCdUi4dHocLRPZqrhGwh+rJ9lW7idcsWmKtjAWfa0CXJNAtY8Ig2NDJE878x3ah4
         eDBxC6iPFuAGaBjv3yKY+n1N/ZSqlPmLdThUt5C//kohUllgCde5Xeh0XAaq+u+FIbvj
         d6/953SruL9C2U5amRVYATCkouCHOtLuNIJothnNyhCHVw4KDbHjS9j6tWiOAXyeYpvQ
         w7df+7phUcOyVZffnAQM0P7V68KSyRejVNPz94bO3yX8uzmSyyBz7XKe1oefim0S1XwZ
         8LAg==
X-Gm-Message-State: AOAM531MuR9x1aH6xA4oK6f2qs8VHeXrGK3zaXAzMciofDV0dv/4QN6E
        J0mDSNy164iRGsb54GSDtR9g6f8jr6fMpRuhXCEwPj/zcmui0jpY8ACwnCYG1DNjbGhZL98OG1d
        kFbM4KUzYZSMPHLbN
X-Received: by 2002:adf:f511:: with SMTP id q17mr5373242wro.414.1597348342255;
        Thu, 13 Aug 2020 12:52:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxN5HajSKsOOOzKlujHCQaa2QDxD3w6BBkcSbO3LjEsYYdrN+6zMV+etDXeCTPHkzYEyNJlg==
X-Received: by 2002:adf:f511:: with SMTP id q17mr5373226wro.414.1597348341992;
        Thu, 13 Aug 2020 12:52:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m14sm11211191wrx.76.2020.08.13.12.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 12:52:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BF658180493; Thu, 13 Aug 2020 21:52:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] libbpf: Prevent overriding errno when logging errors
In-Reply-To: <CAEf4BzZ6yM_QWu0x4b51NAVzN6-EAoQN4ff4BNiof5CJ5ukhpg@mail.gmail.com>
References: <20200813142905.160381-1-toke@redhat.com>
 <CAEf4BzZ6yM_QWu0x4b51NAVzN6-EAoQN4ff4BNiof5CJ5ukhpg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Aug 2020 21:52:20 +0200
Message-ID: <87d03u1fyj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Aug 13, 2020 at 7:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Turns out there were a few more instances where libbpf didn't save the
>> errno before writing an error message, causing errno to be overridden by
>> the printf() return and the error disappearing if logging is enabled.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
>>  tools/lib/bpf/libbpf.c | 12 +++++++-----
>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 0a06124f7999..fd256440e233 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -3478,10 +3478,11 @@ bpf_object__probe_global_data(struct bpf_object =
*obj)
>>
>>         map =3D bpf_create_map_xattr(&map_attr);
>>         if (map < 0) {
>> -               cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
>> +               ret =3D -errno;
>> +               cp =3D libbpf_strerror_r(-ret, errmsg, sizeof(errmsg));
>
> fyi, libbpf_strerror_r() is smart enough to work with both negative
> and positive error numbers (it basically takes abs(err)), so no need
> to ensure it's positive here and below.

Noted. Although that also means it doesn't hurt either, I suppose; so
not going to bother respinning this unless someone insists :)

-Toke

