Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743D14741A4
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 12:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhLNLlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 06:41:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229554AbhLNLlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 06:41:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639482101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XZj2MhZjdEsTUuKnWvOEWXI1Fc5mq/oqfJFXH7BXKQI=;
        b=PllNZSWOu3Ve0AnOFk/l1J6SJciVRnPix76jLKPbRaO9K8Mf+/rjuUyqIhvxAkFcaG0FPr
        CZu8/MXF3jHGaAJ8apf63lE0LYeIuP0JESfBKhNtU0yo5yUg7ruksEmbL9XEVRegPUYzFn
        uigU1kYw07oE22GIfA8A0P5jIG8V7EE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-1tr8VgORNgWVOHi1YDQ-XA-1; Tue, 14 Dec 2021 06:41:40 -0500
X-MC-Unique: 1tr8VgORNgWVOHi1YDQ-XA-1
Received: by mail-ed1-f69.google.com with SMTP id i19-20020a05640242d300b003e7d13ebeedso16771056edc.7
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 03:41:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XZj2MhZjdEsTUuKnWvOEWXI1Fc5mq/oqfJFXH7BXKQI=;
        b=OtNf8rVmr5+5RkfEgf92D7dT/swhuVlptXxNaUB0aJqfMoCf9eOGqW7lNz9Syy3mG9
         RDhmI1RwIO+069GqhfmMiBSlqlchhnr180cJjMBPyuU/TrN2AUrGzwUcTv8pJwapC0Yi
         TpS4UCb1P+SSqFFa/gSo6S5w5SQ+6hrLE8KZIUVZV2aADiCUDKze+Y3iZ2tISQp8AJ6b
         nwxeLo3io6UOP8Zk4CKlLfyeMsfXEH0yjUbwC7s72nKnQQLLF6A4Phlg0wltdzXB4t0+
         xoB+gKTy2BuLqJQWX5SD3Cd1fm6VCXVTT7gMZ68YiTATZSQtYJUgvPuzPEgF7gkOMNRZ
         k3RA==
X-Gm-Message-State: AOAM532orrQUKsZa9MPPkruXJEcOMTgjIbD/rhs7WuyRsTaH2wVR8Y1o
        SVF/0pcPaKZKWNhhtdCDxWUa9/ORnXk4lNbmQ4owx2mDusK8IGy2CtSdA9byt4I0Egs3zz6Fvmh
        PXy/mgAN/pz3FjbNp
X-Received: by 2002:a50:be87:: with SMTP id b7mr7072319edk.199.1639482099176;
        Tue, 14 Dec 2021 03:41:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKo5MKxqXevi/NrBZdbA5Ie7EyJaacqI9bsMWwGLGPQSSXFr+X14xx8OPPfT9WtiaMyMFEYw==
X-Received: by 2002:a50:be87:: with SMTP id b7mr7072267edk.199.1639482098761;
        Tue, 14 Dec 2021 03:41:38 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ch28sm7586619edb.72.2021.12.14.03.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 03:41:38 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A127F183566; Tue, 14 Dec 2021 12:41:37 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next v2] tc: Add support for
 ce_threshold_value/mask in fq_codel
In-Reply-To: <d7ba6b69-4a17-8d43-b2f1-58b8033684df@gmail.com>
References: <20211208124517.10687-1-toke@redhat.com>
 <d7ba6b69-4a17-8d43-b2f1-58b8033684df@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Dec 2021 12:41:37 +0100
Message-ID: <877dc7za4u.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 12/8/21 5:45 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for subs=
et
>> of traffic") added support in fq_codel for setting a value and mask that
>> will be applied to the diffserv/ECN byte to turn on the ce_threshold
>> feature for a subset of traffic.
>>=20
>> This adds support to iproute for setting these values. The parameter is
>> called ce_threshold_selector and takes a value followed by a
>> slash-separated mask. Some examples:
>>=20
>>  # apply ce_threshold to ECT(1) traffic
>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_s=
elector 0x1/0x3
>>=20
>>  # apply ce_threshold to ECN-capable traffic marked as diffserv AF22
>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_s=
elector 0x50/0xfc
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>> v2:
>> - Also update man page
>>=20
>>  man/man8/tc-fq_codel.8 | 11 +++++++++++
>>  tc/q_fq_codel.c        | 40 ++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 51 insertions(+)
>>=20
>
> please remember to cc Stephen and I on iproute2 patches. Otherwise you
> are at the mercy of vger - from wild delays in delivery time to
> unsubscribing accounts in which case I would never get it.

Right, will do, sorry about that! :)

-Toke

