Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8874E3680
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbiCVCRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235395AbiCVCRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:17:36 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4431FA74;
        Mon, 21 Mar 2022 19:15:08 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1647915306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jYNLCxTmIoThWrGCuegM5gDTHrucNh1xrWSH6I5PEO0=;
        b=fXdQwjSAoV9xZV35ZvSbWJs3jpn2qSq2PfgdJQcu2TasdcwY3RuP5CanKxtsNCrtRJAESD
        49FfRjVPltdpY/yuBC6za22uugHxL5tCWHlWhKW/zWb3A0aW1oY6dLWeBcccVG4tCOoHpA
        uyV9baq9EFq+BQAAObUL1F3mmaP0X7I=
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: Re: [PATCH] bpf: selftests: cleanup RLIMIT_MEMLOCK
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
In-Reply-To: <CAEf4BzbpoYbPzYRA8bW=f48=wX0jJPuWX=Jr_uNnC_Jq80Bz3Q@mail.gmail.com>
Date:   Mon, 21 Mar 2022 19:15:03 -0700
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-Id: <F7652433-EED5-4F56-A062-06AFE4B08576@linux.dev>
References: <CAEf4BzbpoYbPzYRA8bW=f48=wX0jJPuWX=Jr_uNnC_Jq80Bz3Q@mail.gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Mar 21, 2022, at 5:13 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> =EF=BB=BFOn Sun, Mar 20, 2022 at 9:58 AM Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
>>=20
>>=20
>>>> On Mar 19, 2022, at 11:08 PM, Yafang Shao <laoar.shao@gmail.com> wrote:=

>>>=20
>>> =EF=BB=BFSince we have alread switched to memcg-based memory accouting a=
nd control,
>>> we don't need RLIMIT_MEMLOCK any more.
>>>=20
>>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>>> Cc: Roman Gushchin <roman.gushchin@linux.dev>
>>>=20
>>> ---
>>> RLIMIT_MEMLOCK is still used in bpftool and libbpf, but it may be useful=

>>> for backward compatibility, so I don't cleanup them.
>>=20
>> Hi Yafang!
>>=20
>> As I remember, we haven=E2=80=99t cleaned selftests up with the same logi=
c: it=E2=80=99s nice to be able to run the same version of tests on older ke=
rnels.
>>=20
>=20
> It should be fine, at least for test_progs and test_progs-no_alu32.
> Libbpf now does this automatically if running in "libbpf 1.0" mode.

Didn=E2=80=99t know this, thanks! Do we link all tests with it?

>=20
> Yafang, please make sure that all the test binaries you are cleaning
> up have libbpf_set_strict_mode(LIBBPF_STRICT_ALL) (test_progs does
> already). You might need to clean up some SEC() definitions, in case
> we still missed some non-conforming ones, though.

If so, no objections to the patch from my side.

Thank you!=
