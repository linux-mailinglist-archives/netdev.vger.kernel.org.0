Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EFF3CFDEE
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240390AbhGTOgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:36:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234579AbhGTORU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 10:17:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626793034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JYeEMxZkqQmanUk3SXevDIn341JznEMVqJ/f4SJD7Ok=;
        b=cSf5h4CsgPizW25XCKrFYMsXs22id2WrEaXyb1KytHXrYDTBFkle3J11Tvu5DVxiugl+54
        qBPtc9UDu2xB6xRBlAeh1yUQnqRDXQurZZOp+kWKKei9j+VjTA5EA9pcxSeo2+Tv1g2jID
        Fc/jTm9ols9+CxPKGMmvZSfyrw6NzFo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-UQ0Iqv-uM-69v0QKNrjdAw-1; Tue, 20 Jul 2021 10:57:12 -0400
X-MC-Unique: UQ0Iqv-uM-69v0QKNrjdAw-1
Received: by mail-ej1-f71.google.com with SMTP id y3-20020a17090614c3b0290551ea218ea2so2439096ejc.5
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 07:57:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JYeEMxZkqQmanUk3SXevDIn341JznEMVqJ/f4SJD7Ok=;
        b=cQGkr4mLxgKazvWNVaOcWGO1stIQ/buhdi/EtnOYZgmP79aEH2CYgrcDp3xDIlKMTo
         CQhxL7Fz/rvpNTalYS5+BO1iB+PdiHz31iT7Pf9Hn6ui2RgOX0SF4IQAJetYZxLy0mLL
         qgQ+vITNpt8qvfC3rpBS9cmZS+AYSGGpeMWnD6FEPQXeKRYHWdmUUm3OoIZqtAHxiSSI
         1Ugct2nl/Zy6WrlWjks+NX+GUyiIV3+e0I/OxYF9OEYwuDOHxGRbJ3eoyKTNaKGgRFxO
         CSksgQmRtbpRqgaSa0L9lHw9gzEiqoc/BC7YQ03JgxRz6pRxl1pGytdEUdEfT+ADUfjg
         HnMw==
X-Gm-Message-State: AOAM531/nvB8Z0gdGCl1tXIgnOGoc59KO4TyZ6so1AXNwoTFvRCXe3VE
        qREjtblXCeCeGOA1F+3HrKDK82vPQ3ESkxpR+bFNjJDmRONj8hpTYn1yMO3UBbtnfBoWZb5j6mN
        g/6IGK44w0e/GTLXT
X-Received: by 2002:a17:907:264e:: with SMTP id ar14mr33337149ejc.134.1626793031599;
        Tue, 20 Jul 2021 07:57:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDRp0wSPGh04ZIsh3ykqs5PMxabHS1Vc0+4aUbwzWbk1J39PLB5QrktN8iIcYORB5fmseh/A==
X-Received: by 2002:a17:907:264e:: with SMTP id ar14mr33337129ejc.134.1626793031420;
        Tue, 20 Jul 2021 07:57:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id i6sm7832882edt.28.2021.07.20.07.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 07:57:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 58AD718060A; Tue, 20 Jul 2021 16:50:08 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "luwei (O)" <luwei32@huawei.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Ahern <dahern@digitalocean.com>
Subject: Re: Ask for help about bpf map
In-Reply-To: <beb37418-4518-100a-5b1b-e036be6f71b6@huawei.com>
References: <5aebe6f4-ca0d-4f64-8ee6-b68c58675271@huawei.com>
 <CAEf4BzZpSo8Kqz8mgPdbWTTVLqJ1AgE429_KHTiXgEVpbT97Yw@mail.gmail.com>
 <8735sidtwe.fsf@toke.dk> <d1f47a24-6328-5121-3a1f-5a102444e50c@huawei.com>
 <26db412c-a8b7-6d37-844f-7909a0c5744b@huawei.com>
 <189e4437-bb2c-2573-be96-0d6776feb5dd@huawei.com>
 <CAADnVQJYhtpEcvvYfozxiPdUJqcZiJxbmT2KuOC6uQdC1VWZVw@mail.gmail.com>
 <6b659192-5133-981e-0c43-7ca1120edd9c@huawei.com> <87wnpmtr5j.fsf@toke.dk>
 <beb37418-4518-100a-5b1b-e036be6f71b6@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 20 Jul 2021 16:50:08 +0200
Message-ID: <87a6mh82fz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"luwei (O)" <luwei32@huawei.com> writes:

> It's very strange, in my virtual host, it is:
>
> $ ip -V
>
> ip utility, iproute2-5.11.0
>
>
> but in my physical host:
>
> $ ip -V
> ip utility, iproute2-5.11.0, libbpf 0.5.0
>
>
> I compiled iproute2 in the same way as I mentioned previously, and the 
> kernel versions are both 5.13 (in fact the same code) .

When compiling, the configure script should tell you whether it can find
libbpf. If not, it's probably because you don't have the right header
files installed...

-Toke

