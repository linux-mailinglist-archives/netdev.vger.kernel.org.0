Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188C54468B8
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 19:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhKETAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 15:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhKETAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 15:00:50 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0630C061714;
        Fri,  5 Nov 2021 11:58:10 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id c26-20020a9d615a000000b0055bf6efab46so6199382otk.6;
        Fri, 05 Nov 2021 11:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=eD5ugfB+vSrRzEKkXUuZRmMMIxi+ka7PwX8hq4MYkdA=;
        b=mP3kTZy8rqA1u7CsFuynDZSDSspNAoIOVDkp3RGsZm3jBRV8IN7iwKuH69Kpu71hUO
         LJfi7cP5BNzpy8num4g3gLdiT1z9htH1veV4ObwwB8x4x52EllrZlBY3zufpu8iNiBho
         3sk41LVYWFqULqipJMGDPN22+/4CRj3MFNG+cvgqFStwD6S2px/JY56jWkO6DLcsv5en
         y9AqiGtKJQomT75naH5vwNMUujRdKxVjn0xSwPOhDO+7OHXn1XnEtZ9EGsGd6fWWTQ8a
         v7AU6HV0Q85x3jZQDjRKsWZy4sV6xCNrIuAe8jKIu5J/zQyoTKk0CWWQgwLj5EGAkz5A
         6M8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=eD5ugfB+vSrRzEKkXUuZRmMMIxi+ka7PwX8hq4MYkdA=;
        b=1648D/jXBwXcYqjaeJH7Mc5mY50NHbF455ystBwfFDlDBUH5AK8gPiJovOdkA0X2WG
         GDdfnKSExxoVLcpYd9svS+ueTpcVrNhicFLKqSg+/vPzzstHxLfgVyR37fAMrrNWKPnP
         8OSBm7z+csvPQk//6ubMC9v8HNXeFQL/yGzRCmkvoCZITHpY79r6VEKTqyUI+XfSRol8
         3oLBvOXToQndQ7hoGKG+iS+96FOqvLyQ1Bw0B11VtbJWTaSowPDYpz4vjXGPNgCtxfVN
         qsEAmaSJ8W26Y4QclqTBLqVEdDsgcug7liKM114AiGmt4tytYYXrQaDERY43kMN2k/0R
         mE9g==
X-Gm-Message-State: AOAM533o93Bpa+UsHwv25tij4ivYhKnn41qf9TmDPlTlZjPRLPRaS4ik
        0b1LLfMPzeenkXA45rUf7pw=
X-Google-Smtp-Source: ABdhPJy+4wpAK+OzwJ0n4pPT41Fa7ZZzNkSw1qUTYnwOoV2BngPD0tthASKEuZr7Dpx8lU1blDlldQ==
X-Received: by 2002:a9d:764c:: with SMTP id o12mr46696924otl.129.1636138690129;
        Fri, 05 Nov 2021 11:58:10 -0700 (PDT)
Received: from [127.0.0.1] ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id w12sm2622224oop.19.2021.11.05.11.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 11:58:09 -0700 (PDT)
Date:   Fri, 05 Nov 2021 15:57:29 -0300
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_bpf-next=5D_perf_build=3A_Insta?= =?US-ASCII?Q?ll_libbpf_headers_locally_when_building?=
User-Agent: K-9 Mail for Android
In-Reply-To: <CAEf4Bza_-vvOXPRZaJzi4YpU5Bfb=werLUFG=Au9DtaanbuArg@mail.gmail.com>
References: <20211105020244.6869-1-quentin@isovalent.com> <CAEf4Bza_-vvOXPRZaJzi4YpU5Bfb=werLUFG=Au9DtaanbuArg@mail.gmail.com>
Message-ID: <C113D239-3117-4046-AA91-DD3AAA5741B1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On November 5, 2021 3:38:50 PM GMT-03:00, Andrii Nakryiko <andrii=2Enakryi=
ko@gmail=2Ecom> wrote:
>On Thu, Nov 4, 2021 at 7:02 PM Quentin Monnet <quentin@isovalent=2Ecom> w=
rote:
>>
>> API headers from libbpf should not be accessed directly from the
>> library's source directory=2E Instead, they should be exported with "ma=
ke
>> install_headers"=2E Let's adjust perf's Makefile to install those heade=
rs
>> locally when building libbpf=2E
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent=2Ecom>
>> ---
>> Note: Sending to bpf-next because it's directly related to libbpf, and
>> to similar patches merged through bpf-next, but maybe Arnaldo prefers t=
o
>> take it?
>
>Arnaldo would know better how to thoroughly test it, so I'd prefer to
>route this through perf tree=2E Any objections, Arnaldo?


Sure, I'll review and test it=2E

- Arnaldo
>
>> ---
>>  tools/perf/Makefile=2Eperf | 24 +++++++++++++-----------
>>  1 file changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/tools/perf/Makefile=2Eperf b/tools/perf/Makefile=2Eperf
>> index b856afa6eb52=2E=2E3a81b6c712a9 100644
>> --- a/tools/perf/Makefile=2Eperf
>> +++ b/tools/perf/Makefile=2Eperf
>> @@ -241,7 +241,7 @@ else # force_fixdep
>>
>>  LIB_DIR         =3D $(srctree)/tools/lib/api/
>>  TRACE_EVENT_DIR =3D $(srctree)/tools/lib/traceevent/
>> -BPF_DIR         =3D $(srctree)/tools/lib/bpf/
>> +LIBBPF_DIR      =3D $(srctree)/tools/lib/bpf/
>>  SUBCMD_DIR      =3D $(srctree)/tools/lib/subcmd/
>>  LIBPERF_DIR     =3D $(srctree)/tools/lib/perf/
>>  DOC_DIR         =3D $(srctree)/tools/perf/Documentation/
>> @@ -293,7 +293,6 @@ strip-libs =3D $(filter-out -l%,$(1))
>>  ifneq ($(OUTPUT),)
>>    TE_PATH=3D$(OUTPUT)
>>    PLUGINS_PATH=3D$(OUTPUT)
>> -  BPF_PATH=3D$(OUTPUT)
>>    SUBCMD_PATH=3D$(OUTPUT)
>>    LIBPERF_PATH=3D$(OUTPUT)
>>  ifneq ($(subdir),)
>> @@ -305,7 +304,6 @@ else
>>    TE_PATH=3D$(TRACE_EVENT_DIR)
>>    PLUGINS_PATH=3D$(TRACE_EVENT_DIR)plugins/
>>    API_PATH=3D$(LIB_DIR)
>> -  BPF_PATH=3D$(BPF_DIR)
>>    SUBCMD_PATH=3D$(SUBCMD_DIR)
>>    LIBPERF_PATH=3D$(LIBPERF_DIR)
>>  endif
>> @@ -324,7 +322,10 @@ LIBTRACEEVENT_DYNAMIC_LIST_LDFLAGS =3D $(if $(find=
string -static,$(LDFLAGS)),,$(DY
>>  LIBAPI =3D $(API_PATH)libapi=2Ea
>>  export LIBAPI
>>
>> -LIBBPF =3D $(BPF_PATH)libbpf=2Ea
>> +LIBBPF_OUTPUT =3D $(OUTPUT)libbpf
>> +LIBBPF_DESTDIR =3D $(LIBBPF_OUTPUT)
>> +LIBBPF_INCLUDE =3D $(LIBBPF_DESTDIR)/include
>> +LIBBPF =3D $(LIBBPF_OUTPUT)/libbpf=2Ea
>>
>>  LIBSUBCMD =3D $(SUBCMD_PATH)libsubcmd=2Ea
>>
>> @@ -829,12 +830,14 @@ $(LIBAPI)-clean:
>>         $(call QUIET_CLEAN, libapi)
>>         $(Q)$(MAKE) -C $(LIB_DIR) O=3D$(OUTPUT) clean >/dev/null
>>
>> -$(LIBBPF): FORCE
>> -       $(Q)$(MAKE) -C $(BPF_DIR) O=3D$(OUTPUT) $(OUTPUT)libbpf=2Ea FEA=
TURES_DUMP=3D$(FEATURE_DUMP_EXPORT)
>> +$(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
>> +       $(Q)$(MAKE) -C $(LIBBPF_DIR) FEATURES_DUMP=3D$(FEATURE_DUMP_EXP=
ORT) \
>> +               O=3D OUTPUT=3D$(LIBBPF_OUTPUT)/ DESTDIR=3D$(LIBBPF_DEST=
DIR) prefix=3D \
>> +               $@ install_headers
>>
>>  $(LIBBPF)-clean:
>>         $(call QUIET_CLEAN, libbpf)
>> -       $(Q)$(MAKE) -C $(BPF_DIR) O=3D$(OUTPUT) clean >/dev/null
>> +       $(Q)$(RM) -r -- $(LIBBPF_OUTPUT)
>>
>>  $(LIBPERF): FORCE
>>         $(Q)$(MAKE) -C $(LIBPERF_DIR) EXTRA_CFLAGS=3D"$(LIBPERF_CFLAGS)=
" O=3D$(OUTPUT) $(OUTPUT)libperf=2Ea
>> @@ -1036,14 +1039,13 @@ SKELETONS +=3D $(SKEL_OUT)/bperf_cgroup=2Eskel=
=2Eh
>>
>>  ifdef BUILD_BPF_SKEL
>>  BPFTOOL :=3D $(SKEL_TMP_OUT)/bootstrap/bpftool
>> -LIBBPF_SRC :=3D $(abspath =2E=2E/lib/bpf)
>> -BPF_INCLUDE :=3D -I$(SKEL_TMP_OUT)/=2E=2E -I$(BPF_PATH) -I$(LIBBPF_SRC=
)/=2E=2E
>> +BPF_INCLUDE :=3D -I$(SKEL_TMP_OUT)/=2E=2E -I$(LIBBPF_INCLUDE)
>>
>> -$(SKEL_TMP_OUT):
>> +$(SKEL_TMP_OUT) $(LIBBPF_OUTPUT):
>>         $(Q)$(MKDIR) -p $@
>>
>>  $(BPFTOOL): | $(SKEL_TMP_OUT)
>> -       CFLAGS=3D $(MAKE) -C =2E=2E/bpf/bpftool \
>> +       $(Q)CFLAGS=3D $(MAKE) -C =2E=2E/bpf/bpftool \
>>                 OUTPUT=3D$(SKEL_TMP_OUT)/ bootstrap
>>
>>  VMLINUX_BTF_PATHS ?=3D $(if $(O),$(O)/vmlinux)                        =
   \
>> --
>> 2=2E32=2E0
>>
