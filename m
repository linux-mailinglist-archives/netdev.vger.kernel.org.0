Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC0C4375C0
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 12:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhJVK5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 06:57:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49175 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232592AbhJVK5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 06:57:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634900089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=okT+nghV6LZUh40pM7SbRBQZZKy9WPEhwzp7K4ZbI3k=;
        b=eKZUP5B4WE5ErtB9nOyPDf4buqMntp5wTNbt9CgAc2WYDpV4YQj4sIx+j6H0w9KjkdSX1K
        8n7qO8bVKP5Gu0cKXUcKUgIkVslCyaDUWqx3ObtBbRW4+mmd6PxEN1JjjVQR3m/UwxoILY
        LUGf3BMvCd0TwyAkkfjul32hexkP0Bc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-T4nmNZcTPOicVFlZJD7ZuA-1; Fri, 22 Oct 2021 06:54:48 -0400
X-MC-Unique: T4nmNZcTPOicVFlZJD7ZuA-1
Received: by mail-ed1-f70.google.com with SMTP id b17-20020a056402351100b003dd23c083b1so1452256edd.0
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 03:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=okT+nghV6LZUh40pM7SbRBQZZKy9WPEhwzp7K4ZbI3k=;
        b=36hiwr9uyBONfNWtn7VDVqxZ9HO29ToHEtnmCUGy5Vf/0Ij4Yo63iGZYRT6yIp1MLr
         95zB2vydZ/uw9mS45MrafxdBDRYyhGeRg6cLH7UFxlEmCdEIHklV90B6dSpTe4sOHeiV
         MeMQDKGNcS8POg1UIxVvRtPuw45sve3jKWXzR1qqttiIq3/4H9mD44Eo7VjMNJ3BCRWK
         Fsr4E83vzK89K48YXNg3zxQjTZeyguJ9E2fE/6RyYh0foO2673QTj9mFXsrttjz1haNi
         vwqtGQnhLCyWCMz9P5RE38Xzn/KKbqhppPFTJi+h3NP3AJYnoPJRUcc6S+TGLIdolukp
         6j+g==
X-Gm-Message-State: AOAM5303Xyal3ifole/Z+/hGORcoqYC0n90P310pLG8JhQdKb36wnBLD
        46YS3tkIz7k1DZOJkbFfl0esH25E8JN5EJodaRyHsWORAhK/SsMsTvyf3AA8COCdU9jhACFso+r
        eR+U9DVLCVJEEGKPp
X-Received: by 2002:a17:906:2346:: with SMTP id m6mr14311687eja.512.1634900086928;
        Fri, 22 Oct 2021 03:54:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwl0QdgFcH76HS5dJ0OuQUBWbPNyca2xQaZHIy7y9K34vvpDDOWGwI/TgP7QJNAEOPVQ7fnYw==
X-Received: by 2002:a17:906:2346:: with SMTP id m6mr14311650eja.512.1634900086587;
        Fri, 22 Oct 2021 03:54:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q9sm3647708ejf.70.2021.10.22.03.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 03:54:46 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7F2E6180262; Fri, 22 Oct 2021 12:54:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH bpf] bpf: fix potential race in tail call compatibility
 check
In-Reply-To: <CAADnVQLPBLc0T32nqM7Q_LBEGWiJRp3JvGaY2Lsmf9yqJW+Yfw@mail.gmail.com>
References: <20211021183951.169905-1-toke@redhat.com>
 <CAADnVQLPBLc0T32nqM7Q_LBEGWiJRp3JvGaY2Lsmf9yqJW+Yfw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 22 Oct 2021 12:54:45 +0200
Message-ID: <87mtn1cosq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Oct 21, 2021 at 11:40 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>> +       map_type =3D READ_ONCE(array->aux->type);
>> +       if (!map_type) {
>> +               /* There's no owner yet where we could check for compati=
bility.
>> +                * Do an atomic swap to prevent racing with another invo=
cation
>> +                * of this branch (via simultaneous map_update syscalls).
>>                  */
>> -               array->aux->type  =3D fp->type;
>> -               array->aux->jited =3D fp->jited;
>> +               if (cmpxchg(&array->aux->type, 0, prog_type))
>> +                       return false;
>
> Other fields might be used in the compatibility check in the future.
> This hack is too fragile.
> Just use a spin_lock.

Well, yeah, we're adding another field for xdp_mb. I was just going to
eat more bits of the 'type' field, but OK, can switch to a spinlock
instead :)

-Toke

