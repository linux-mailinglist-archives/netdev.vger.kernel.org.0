Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB7910CC1A
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 16:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfK1Pw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 10:52:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33254 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726446AbfK1Pw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 10:52:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574956346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b3fDLclsp32DrX7lHGecyNEsumQtWNMyutGYTGa++y0=;
        b=Z/v7UmIpkRoqfB0Xsl4Oukr9mHpWCJSahPSQjpvnIGvz7WiBPwzL96PbMdTOMhof1WXjwB
        5zscF7qbHfonNdq2E6StHb3TAv/XeDn6ecJ2RTvu0DvQX90mB+Y/Eo/u0FIIlNKnLmp2oR
        0+RUWfGaR1L57ZhzPdLknfFbbnIvqPg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-4UdpY7plOl-IsUn7qCNmIA-1; Thu, 28 Nov 2019 10:52:23 -0500
Received: by mail-lf1-f69.google.com with SMTP id k4so1903104lfo.7
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 07:52:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=oTYDHNQIqswqEUFec83Wq4PCKAJTly7z4dAKA/xDHuk=;
        b=RoIRiDJt/v4YguDak64waP2T08ry3FV2jQZ97BJ+rH24lUY+oisxFtV+EGBx+H+HZT
         taA1r3FDAQyooqwE2M56pZ1OoEwB7txWNAY4W+Fmo4hjQvrrZSnrbt+2+gAZt34Q2WLz
         kyKp/vusruJa0WwPFzsANTouNkO3x4LraqeR7MYgmwNmKUo6rSuRREwMRpSgYAqkJug3
         yr2H0QYP7qW6kJ5zl7dZY6xgyo70CZmUVo/QgG4EWlgyXtz3qpmEl92ziRgmkP+bWVRI
         Be3ROpdcbv9eGAPsxAZqlTy19mJRbJuk05jYtxYuLaRf11oqeNhqDUG3QLSd7z0DoFPp
         IvIA==
X-Gm-Message-State: APjAAAXwJ3cpmT7AqSFwz7iZ+jMsX3G9sLaBITKBtdx/t7QFXOgkosYR
        oh8klUcIykFJrVXxn9PIFsHU8rZ65zKGAKNn3iMbBlkD6AVM/cyA77RUPHumr5Y5Wb9zHcR+wfJ
        vqTzM/719vYYcB2he
X-Received: by 2002:ac2:41d8:: with SMTP id d24mr17468763lfi.98.1574956342424;
        Thu, 28 Nov 2019 07:52:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqxaMutvc3D5hmGxAEkL9f+k3ILi2Bmxqm33wKbriT6cekL0COYBq15Gk0c8D3HzjYBnmO+pwA==
X-Received: by 2002:ac2:41d8:: with SMTP id d24mr17468737lfi.98.1574956342155;
        Thu, 28 Nov 2019 07:52:22 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o26sm8597809lfi.57.2019.11.28.07.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 07:52:21 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A69DA180339; Thu, 28 Nov 2019 16:52:20 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH bpf v2] bpftool: Allow to link libbpf dynamically
In-Reply-To: <497b4151-9aad-f3a9-3aff-78d665e5f750@netronome.com>
References: <20191128145316.1044912-1-toke@redhat.com> <497b4151-9aad-f3a9-3aff-78d665e5f750@netronome.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 28 Nov 2019 16:52:20 +0100
Message-ID: <871rtsvw0b.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 4UdpY7plOl-IsUn7qCNmIA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Monnet <quentin.monnet@netronome.com> writes:

> 2019-11-28 15:53 UTC+0100 ~ Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com>
>> From: Jiri Olsa <jolsa@kernel.org>
>>=20
>> Currently we support only static linking with kernel's libbpf
>> (tools/lib/bpf). This patch adds LIBBPF_DYNAMIC compile variable
>> that triggers libbpf detection and bpf dynamic linking:
>>=20
>>   $ make -C tools/bpf/bpftool make LIBBPF_DYNAMIC=3D1
>>=20
>> If libbpf is not installed, build (with LIBBPF_DYNAMIC=3D1) stops with:
>>=20
>>   $ make -C tools/bpf/bpftool LIBBPF_DYNAMIC=3D1
>>     Auto-detecting system features:
>>     ...                        libbfd: [ on  ]
>>     ...        disassembler-four-args: [ on  ]
>>     ...                          zlib: [ on  ]
>>     ...                        libbpf: [ OFF ]
>>=20
>>   Makefile:102: *** Error: No libbpf devel library found, please install=
-devel or libbpf-dev.
>>=20
>> Adding LIBBPF_DIR compile variable to allow linking with
>> libbpf installed into specific directory:
>>=20
>>   $ make -C tools/lib/bpf/ prefix=3D/tmp/libbpf/ install_lib install_hea=
ders
>>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/tmp/libb=
pf/
>>=20
>> It might be needed to clean build tree first because features
>> framework does not detect the change properly:
>>=20
>>   $ make -C tools/build/feature clean
>>   $ make -C tools/bpf/bpftool/ clean
>>=20
>> Since bpftool uses bits of libbpf that are not exported as public API in
>> the .so version, we also pass in libbpf.a to the linker, which allows it=
 to
>> pick up the private functions from the static library without having to
>> expose them as ABI.
>>=20
>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>> v2:
>>   - Pass .a file to linker when dynamically linking, so bpftool can use
>>     private functions from libbpf without exposing them as API.
>>    =20
>>  tools/bpf/bpftool/Makefile | 38 +++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 37 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
>> index 39bc6f0f4f0b..397051ed9e41 100644
>> --- a/tools/bpf/bpftool/Makefile
>> +++ b/tools/bpf/bpftool/Makefile
>> @@ -1,6 +1,15 @@
>>  # SPDX-License-Identifier: GPL-2.0-only
>> +# LIBBPF_DYNAMIC to enable libbpf dynamic linking.
>> +
>>  include ../../scripts/Makefile.include
>>  include ../../scripts/utilities.mak
>> +include ../../scripts/Makefile.arch
>> +
>> +ifeq ($(LP64), 1)
>> +  libdir_relative =3D lib64
>> +else
>> +  libdir_relative =3D lib
>> +endif
>> =20
>>  ifeq ($(srctree),)
>>  srctree :=3D $(patsubst %/,%,$(dir $(CURDIR)))
>> @@ -55,7 +64,7 @@ ifneq ($(EXTRA_LDFLAGS),)
>>  LDFLAGS +=3D $(EXTRA_LDFLAGS)
>>  endif
>> =20
>> -LIBS =3D $(LIBBPF) -lelf -lz
>> +LIBS =3D -lelf -lz
>
> Hi Toke,
>
> You don't need to remove $(LIBBPF) here, because you add it in both
> cases below (whether $(LIBBPF_DYNAMIC) is defined or not).

Oh, right, good point; will fix :)

