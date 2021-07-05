Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CB13BBB49
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 12:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhGEKfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 06:35:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230521AbhGEKft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 06:35:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625481192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kAkedCnhjEK0sIJXrBd38PA3bwhHRpR3SisBIAqIAs=;
        b=d570qjfXDIfgG00Qf8U+pMSVhZ/sGSLgzQNo2/e0Bfvn+BYLoo63rawyJ2m6dIF/s/P5zg
        jBJJSmv9l3Io+tjnf9W63R8iZmgnBahAUL8IUTAsYHFLu0NBGLNDgbow1kft41IrAMporl
        2DPs/t8X40n4xgliRAh17Lzkci/1/1s=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-4jdum2-rMKidEJWYvrjR7A-1; Mon, 05 Jul 2021 06:33:11 -0400
X-MC-Unique: 4jdum2-rMKidEJWYvrjR7A-1
Received: by mail-ed1-f72.google.com with SMTP id i8-20020a50fc080000b02903989feb4920so3393646edr.1
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 03:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=9kAkedCnhjEK0sIJXrBd38PA3bwhHRpR3SisBIAqIAs=;
        b=VzbaIY8K1mqTgy7dY93V8TGRTCUco491LJ0Ye2aZhO8QAo4aWb4FlLXzfwxo7tBHWi
         6405yHwTLNJAYLjl1gwDs1w58yQXVvVYbcH3uAXTH9vETDC3qGwnvVrhIAfn0VuTBzQD
         KBDEPC082FYlXwz+GOoCiNRUqIxDjlMiR+Sqv3DJOXyM/zPtJzanqU8vSBNv2N1AhMVu
         MWCZxVldy5FmswucoBd5/8Z/V7fGkwqBFy6YYPTYnUKu1oMFAE2T8c/1pw2Nnq2CgTpZ
         IqG/qhchGazLNVCjeBP+c1oBesM8x9tc+EUv6fW9RsghthA3ttgIhBK7VMRekPkPGi1x
         Vf0A==
X-Gm-Message-State: AOAM531D5ul189AAefjREbVycAW7ky2HxWiX33srDTwOpnpE52XKQXjj
        HFK1utwzAEjgAyH9P65+4ID+vWnCVDbtNgHvhsiKnw/wGy8nBTwRNNVla1tSGEPfRAY/TYfTDsE
        QRmStVYHgGnzcHaEy
X-Received: by 2002:a05:6402:1d25:: with SMTP id dh5mr15616014edb.355.1625481190565;
        Mon, 05 Jul 2021 03:33:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw477+XlnSb8fOKkMYmWXPMweRQkIMjIXsFTPyNgKj7RYTdDaNExdGmvb358k+9Eo+BIngwdQ==
X-Received: by 2002:a05:6402:1d25:: with SMTP id dh5mr15615999edb.355.1625481190426;
        Mon, 05 Jul 2021 03:33:10 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id zn21sm4183686ejb.78.2021.07.05.03.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 03:33:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4394118072E; Mon,  5 Jul 2021 12:33:09 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next] libbpf: ignore .eh_frame sections when parsing
 elf files
In-Reply-To: <ac14ef3c-ccd5-5f74-dda5-1d9366883813@iogearbox.net>
References: <20210629110923.580029-1-toke@redhat.com>
 <ac14ef3c-ccd5-5f74-dda5-1d9366883813@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 05 Jul 2021 12:33:09 +0200
Message-ID: <87czrxyrru.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 6/29/21 1:09 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> The .eh_frame and .rel.eh_frame sections will be present in BPF object
>> files when compiled using a multi-stage compile pipe like in samples/bpf.
>> This produces errors when loading such a file with libbpf. While the err=
ors
>> are technically harmless, they look odd and confuse users. So add .eh_fr=
ame
>> sections to is_sec_name_dwarf() so they will also be ignored by libbpf
>> processing. This gets rid of output like this from samples/bpf:
>>=20
>> libbpf: elf: skipping unrecognized data section(32) .eh_frame
>> libbpf: elf: skipping relo section(33) .rel.eh_frame for section(32) .eh=
_frame
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> For the samples/bpf case, could we instead just add a -fno-asynchronous-u=
nwind-tables
> to clang as cflags to avoid .eh_frame generation in the first place?

Ah, great suggestion! Was trying, but failed, to figure out how to do
that. Just tested it, and yeah, that does fix samples; will send a
separate patch to add that.

I still think filtering this section name in libbpf is worthwhile,
though, as the error message is really just noise... WDYT?

-Toke

