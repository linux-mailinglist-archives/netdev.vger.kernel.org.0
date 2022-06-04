Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE1753D653
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 11:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbiFDJx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 05:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbiFDJx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 05:53:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4AF251D306
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 02:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654336436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WitxTTRJKQQeep5v0O4sGcbg++ZOKQssTY3SnOKVWH8=;
        b=RBTqZ1VNnU4f5BZAwBeDKi2gAPAoxvvbP4EGo6ECREynZgDsvvl15/9J65PgzVrJ5qNYuA
        OkR68wK03otcSULxAugg9rJbyElT6B3JGRVVTVk0juGDwmi6s2Vt3ZHNbBgFz4BRROv0z8
        TtvZJWpfiUrP7hSL8BXL+PJkE0iCmqM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-GghidauuP_CwxrBE6oa7MA-1; Sat, 04 Jun 2022 05:53:54 -0400
X-MC-Unique: GghidauuP_CwxrBE6oa7MA-1
Received: by mail-ed1-f71.google.com with SMTP id o17-20020a50fd91000000b0042dbded81deso7056356edt.0
        for <netdev@vger.kernel.org>; Sat, 04 Jun 2022 02:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=WitxTTRJKQQeep5v0O4sGcbg++ZOKQssTY3SnOKVWH8=;
        b=LxilheF6qVgP3I/zorjZvKIRjGREJmkMwDddd0LEaQ4L2TArL4opwzWv/lIVAd1Yix
         mL9GPyc6WlVryQD07BZwqlir9e8r91gUiBpmjigt4+8Q8FFfIz+wp/A5bd3CyDObbfV9
         fxA2tu2Ri0D5SOkRCBWT3w+q0TROMgeAZKAjUj5DCjQu63XRc9NUvbok+NdWbRFkHEhW
         1VXC7LTCQryBkv0OLvLuwWotzEw/UzCECpLSaSzSyMa045dRDfu7A6RQ1JQBk8ejPfWY
         3t77zeHrmrpAltWcUgNcFhEsvde6PdKoweBE/cgAj36fqczUSfbIyxWviu3JEyiz1yc1
         RxzQ==
X-Gm-Message-State: AOAM532mne+qbs91oD7bU3NzSs8r+/Gajf7cbv6xnH5kixFqT1mnSeBd
        qot71cGQ5mYQoXr2U8FcdYSucPTrtHsUtIw5xXtyehAVcugLi9OD/8OhSsGhSAa+gtaNPIfoprl
        YKrKxfZTEiAo4TnTJ
X-Received: by 2002:a50:9f88:0:b0:42d:f7d2:1b7b with SMTP id c8-20020a509f88000000b0042df7d21b7bmr15649924edf.139.1654336433432;
        Sat, 04 Jun 2022 02:53:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCZRcI6jik4o3djWxzlQebVaphzByVYU1Jp+OI2BNam7cEgK0mjrlSZDEptB906PQuPIANXQ==
X-Received: by 2002:a50:9f88:0:b0:42d:f7d2:1b7b with SMTP id c8-20020a509f88000000b0042df7d21b7bmr15649898edf.139.1654336433018;
        Sat, 04 Jun 2022 02:53:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o2-20020aa7dd42000000b0042dc460bda6sm5229786edw.18.2022.06.04.02.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 02:53:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 74BF940541D; Sat,  4 Jun 2022 11:53:50 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: Add selftest for calling global
 functions from freplace
In-Reply-To: <CAEf4Bzak82RbCYethEN7u05UKkmY=DqCiX=oHAFnHocb4fEG6w@mail.gmail.com>
References: <20220603154028.24904-1-toke@redhat.com>
 <20220603154028.24904-2-toke@redhat.com>
 <CAEf4Bzak82RbCYethEN7u05UKkmY=DqCiX=oHAFnHocb4fEG6w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 04 Jun 2022 11:53:50 +0200
Message-ID: <8735gkwy8h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Jun 3, 2022 at 8:42 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Add a selftest that calls a global function with a context object parame=
ter
>> from an freplace function to check that the program context type is
>> correctly converted to the freplace target when fetching the context type
>> from the kernel BTF.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 13 ++++++++++
>>  .../bpf/progs/freplace_global_func.c          | 24 +++++++++++++++++++
>>  2 files changed, 37 insertions(+)
>>  create mode 100644 tools/testing/selftests/bpf/progs/freplace_global_fu=
nc.c
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/to=
ols/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
>> index d9aad15e0d24..6e86a1d92e97 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
>> @@ -395,6 +395,17 @@ static void test_func_map_prog_compatibility(void)
>>                                      "./test_attach_probe.o");
>>  }
>>
>> +static void test_func_replace_global_func(void)
>> +{
>> +       const char *prog_name[] =3D {
>> +               "freplace/test_pkt_access",
>> +       };
>
> empty line between variables and statements
>
>> +       test_fexit_bpf2bpf_common("./freplace_global_func.o",
>> +                                 "./test_pkt_access.o",
>> +                                 ARRAY_SIZE(prog_name),
>> +                                 prog_name, false, NULL);
>> +}
>> +
>>  /* NOTE: affect other tests, must run in serial mode */
>>  void serial_test_fexit_bpf2bpf(void)
>>  {
>> @@ -416,4 +427,6 @@ void serial_test_fexit_bpf2bpf(void)
>>                 test_func_replace_multi();
>>         if (test__start_subtest("fmod_ret_freplace"))
>>                 test_fmod_ret_freplace();
>> +       if (test__start_subtest("func_replace_global_func"))
>> +               test_func_replace_global_func();
>>  }
>> diff --git a/tools/testing/selftests/bpf/progs/freplace_global_func.c b/=
tools/testing/selftests/bpf/progs/freplace_global_func.c
>> new file mode 100644
>> index 000000000000..d9f8276229cc
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/freplace_global_func.c
>> @@ -0,0 +1,24 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2019 Facebook */
>> +#include <linux/stddef.h>
>> +#include <linux/bpf.h>
>> +#include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_endian.h>
>> +#include <bpf/bpf_tracing.h>
>> +
>> +__attribute__ ((noinline))
>
> __noinline
>
>> +int test_ctx_global_func(struct __sk_buff *skb)
>> +{
>> +       volatile int retval =3D 1;
>> +       return retval;
>
> just curious, why volatile instead of direct `return 1;`? Also, empty
> line between variable and return.

To prevent the compiler from optimising away the whole thing. I was
actually under the impression that it shouldn't do that for global
functions, but, well, it does and the 'volatile' keeps it from doing
so...

Will fix the other nits and resubmit.

-Toke

