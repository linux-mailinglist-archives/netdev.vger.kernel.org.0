Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1762D46C04D
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239079AbhLGQLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:11:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232598AbhLGQLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 11:11:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638893249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=huINbxy/VyyRC77aZ5Qk70EARHWv+glekyLxvhH4OHU=;
        b=RIQmSUOPAnysfhz/wJ/qqm3+YrsY9Va7dto0fM1AIl3rvobNK0yAL8oYiWrswYdkYEFRoO
        lkpvT3GfBRnqOx/4ZZOFZSYPsJVu5ENNzaR9mTEb+r4K1DkJgxyFUYRZcAuzo/5zXVfy+6
        ej+h1hTAOOVDZYiPZ0bIE7035XwmKo8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-dFa6WBAiPYer3eRX194EXQ-1; Tue, 07 Dec 2021 11:07:27 -0500
X-MC-Unique: dFa6WBAiPYer3eRX194EXQ-1
Received: by mail-ed1-f69.google.com with SMTP id m17-20020aa7d351000000b003e7c0bc8523so11882143edr.1
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 08:07:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=huINbxy/VyyRC77aZ5Qk70EARHWv+glekyLxvhH4OHU=;
        b=WLWa9e+6a96IVOmg8Qnxi3FMw7MBU5teZDfjiiN5E7mOjGX6nT9p+dczCbHt3pxbPn
         1XgiXvvVugQQpzn9kOk9AIinNlM+i8I/SZKPU25avacYv6DeAzFT8hgYeg6SCmUMFxZf
         i9ctUlagf6CctN5zuJ0ugDIgMexukG1ejhixwJtpJ7jkd7qT/sqDOFv3SzkIViE6FDUb
         sgM8QpSMm5OY6CB3BNNRxOjy5hzef87Cw83v8AZCzyViSpRGOachgfzglVJzUV/tcaPv
         XVOucW+K3zJDOTzGXInyeGHIond3MxgSc48J0mChQUMcllXJWkuCYCn4b7OX5UtkTEOF
         UoPg==
X-Gm-Message-State: AOAM533vE8nRkAR6Ui+7+LeXeCm+DRE4CmDgHnyR++4tojKF0AnlhEWU
        xKbChTQw4c/JxEyd2R1AvV3MoBD4XPQLzPFHqzrLbLCf7kO8dB2yBCWeqPZh03iQnb4HgeRt+bs
        Of9GcooFk57xOxbJm
X-Received: by 2002:a05:6402:4301:: with SMTP id m1mr10580198edc.54.1638893245447;
        Tue, 07 Dec 2021 08:07:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZ+6BUtXWlcGpNsrQyWOn+s3QDSaVluvrXF3zeQcjXTpeqFkdeuKpw3fWaiMEW/r3ittSnrw==
X-Received: by 2002:a05:6402:4301:: with SMTP id m1mr10580043edc.54.1638893244367;
        Tue, 07 Dec 2021 08:07:24 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ch28sm77289edb.72.2021.12.07.08.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 08:07:23 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A150E1802BB; Sun,  5 Dec 2021 23:03:46 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] tc: Add support for
 ce_threshold_value/mask in fq_codel
In-Reply-To: <765eb3d8-7dfa-2b28-e276-fac88453bc72@gmail.com>
References: <20211123201327.86219-1-toke@redhat.com>
 <765eb3d8-7dfa-2b28-e276-fac88453bc72@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 05 Dec 2021 23:03:46 +0100
Message-ID: <87bl1u4sl9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 11/23/21 1:13 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for subs=
et
>> of traffic") added support in fq_codel for setting a value and mask that
>> will be applied to the diffserv/ECN byte to turn on the ce_threshold
>> feature for a subset of traffic.
>>=20
>> This adds support to tc for setting these values. The parameter is
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
>>  tc/q_fq_codel.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 40 insertions(+)
>
> please re-send with an update to

With an update to? :)

-Toke

