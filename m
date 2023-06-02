Return-Path: <netdev+bounces-7341-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B882D71FC72
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:48:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73D942816F9
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98166AD27;
	Fri,  2 Jun 2023 08:48:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B18846C;
	Fri,  2 Jun 2023 08:48:09 +0000 (UTC)
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C29E46;
	Fri,  2 Jun 2023 01:48:06 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 3f1490d57ef6-bacf685150cso1947533276.3;
        Fri, 02 Jun 2023 01:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685695686; x=1688287686;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eheHZP8cKp+sdwSIjhX5j/WsObGvLb/DF1UbUOwIt7I=;
        b=jOmsxqUo2frjiadNp+Wq4gGj+0bwTjeG5B38UXc9OlNsCz+2Nhy31EABVLzGc0TbZ8
         tkezj9qxu1Uy7z5NjqByZX4upmIJIwM5SVGyK/+MMa2bWUQCDUy9/FRFSxpt5tXS2wah
         DtDSMoVidwF1Pja7vO5yAtCvoaPj908lByJhyMd/op4/OJ2YqwkF+P2qkJhGGZu/s+5x
         ie2PT2qndP7C/l2XSmT/Y1T2tWVZQ5qS0iVW//Qj45Y08blaK9tzVuU6WI/KGgY0rTSI
         OCzsJ6eJfd0MePPs8HTHFY9wTVYyNZmQzZNPw766JB86tshr1Dz1wYkL27Q8aMonPptA
         UNmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685695686; x=1688287686;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eheHZP8cKp+sdwSIjhX5j/WsObGvLb/DF1UbUOwIt7I=;
        b=XzK3uYRgixAlcKDiPs3ch+HCKnC+v2xz8jHdFVltkN6UaS9b83ZWqmMf9pP8b5VA9l
         G6A8T5IwUMaAZYeZhL1R1TXQw6pkhznmkFEp3oKrAZVTH7FERoSAAcskh6tW5s0DgA3X
         jVG/wmwen2q8SfEGlalAqBxybcEUTIZMXcwG2v9BF+0i9bSLlKECxG1Ts4Q5o3xJnKPK
         COHY5BhTB0X63B5WMCFSxFBTN1KaLUXJOYnull6KTqeO2x+HiB2xZFP9kfYukdjTZyXq
         4nqQCZ/dgzlp4xwIvBnuaDqBp0FSShsekB766F/3yWZygrhewwKc9Qr9AyNyAI+DJg1S
         +Njw==
X-Gm-Message-State: AC+VfDw1JPRLoC+1P0tUj4Daz862Rp4Qo5/1BuGKz23H4/i/UUQhEASN
	OwalWTCWTPWDqFZnb4JIOzuxpbpRtdOmYmWcM4XzPr0nnM6m+A==
X-Google-Smtp-Source: ACHHUZ5ZRiZ3evxYl3PDPH5kOW8kA9DTwBFIDbz1j/ffQgg/vdI3dYl9C0mP0XRvVy3PWFK8xxHYGbDTbc/CHDn9TSI=
X-Received: by 2002:a0d:ea05:0:b0:568:f2c:ee43 with SMTP id
 t5-20020a0dea05000000b005680f2cee43mr13449240ywe.2.1685695685750; Fri, 02 Jun
 2023 01:48:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602065958.2869555-1-imagedong@tencent.com>
 <20230602065958.2869555-6-imagedong@tencent.com> <69103b6f490309c381432cae5fdabf02d80a4397.camel@linux.ibm.com>
In-Reply-To: <69103b6f490309c381432cae5fdabf02d80a4397.camel@linux.ibm.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Fri, 2 Jun 2023 16:47:54 +0800
Message-ID: <CADxym3bc-jY=My6iHivuani1PH838yHjdVejAcXwWk0N5Qomkg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/5] selftests/bpf: add testcase for
 FENTRY/FEXIT with 6+ arguments
To: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: olsajiri@gmail.com, davem@davemloft.net, dsahern@kernel.org, 
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@google.com, haoluo@google.com, jolsa@kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	mykolal@fb.com, shuah@kernel.org, benbjiang@tencent.com, 
	imagedong@tencent.com, xukuohai@huawei.com, chantr4@gmail.com, 
	zwisler@google.com, eddyz87@gmail.com, netdev@vger.kernel.org, 
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 4:24=E2=80=AFPM Ilya Leoshkevich <iii@linux.ibm.com>=
 wrote:
>
> On Fri, 2023-06-02 at 14:59 +0800, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Add test7/test12/test14 in fexit_test.c and fentry_test.c to test the
> > fentry and fexit whose target function have 7/12/14 arguments.
> >
> > And the testcases passed:
> >
> > ./test_progs -t fexit
> > $71      fentry_fexit:OK
> > $73/1    fexit_bpf2bpf/target_no_callees:OK
> > $73/2    fexit_bpf2bpf/target_yes_callees:OK
> > $73/3    fexit_bpf2bpf/func_replace:OK
> > $73/4    fexit_bpf2bpf/func_replace_verify:OK
> > $73/5    fexit_bpf2bpf/func_sockmap_update:OK
> > $73/6    fexit_bpf2bpf/func_replace_return_code:OK
> > $73/7    fexit_bpf2bpf/func_map_prog_compatibility:OK
> > $73/8    fexit_bpf2bpf/func_replace_multi:OK
> > $73/9    fexit_bpf2bpf/fmod_ret_freplace:OK
> > $73/10   fexit_bpf2bpf/func_replace_global_func:OK
> > $73/11   fexit_bpf2bpf/fentry_to_cgroup_bpf:OK
> > $73/12   fexit_bpf2bpf/func_replace_progmap:OK
> > $73      fexit_bpf2bpf:OK
> > $74      fexit_sleep:OK
> > $75      fexit_stress:OK
> > $76      fexit_test:OK
> > Summary: 5/12 PASSED, 0 SKIPPED, 0 FAILED
> >
> > ./test_progs -t fentry
> > $71      fentry_fexit:OK
> > $72      fentry_test:OK
> > $140     module_fentry_shadow:OK
> > Summary: 3/0 PASSED, 0 SKIPPED, 0 FAILED
> >
> > Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  net/bpf/test_run.c                            | 30 +++++++++++++++-
> >  .../testing/selftests/bpf/progs/fentry_test.c | 34
> > ++++++++++++++++++
> >  .../testing/selftests/bpf/progs/fexit_test.c  | 35
> > +++++++++++++++++++
> >  3 files changed, 98 insertions(+), 1 deletion(-)
>
> Don't you also need
>
> --- a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
> @@ -34,7 +34,7 @@ void test_fentry_fexit(void)
>         fentry_res =3D (__u64 *)fentry_skel->bss;
>         fexit_res =3D (__u64 *)fexit_skel->bss;
>         printf("%lld\n", fentry_skel->bss->test1_result);
> -       for (i =3D 0; i < 8; i++) {
> +       for (i =3D 0; i < 11; i++) {
>                 ASSERT_EQ(fentry_res[i], 1, "fentry result");
>                 ASSERT_EQ(fexit_res[i], 1, "fexit result");
>         }
>
> to verify the results of the new tests?

Oops, I missed this part......Thank you for reminding,
and I'll fix it in V3.

Thanks!
Menglong Dong

