Return-Path: <netdev+bounces-7361-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DF171FE2A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:45:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA08F1C20C9F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46E8717AD8;
	Fri,  2 Jun 2023 09:45:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDD817AA2;
	Fri,  2 Jun 2023 09:45:09 +0000 (UTC)
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DE4134;
	Fri,  2 Jun 2023 02:45:08 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 3f1490d57ef6-bacf5b89da7so1993280276.2;
        Fri, 02 Jun 2023 02:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685699108; x=1688291108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sO9CYKq3zsyFP6OrznRGehjIWLTIrAXykOQSpEJEjfc=;
        b=c6IdsA3jP2haZ6HorJDy1WTeD7Ii7Z2qg/GiS0h1mQjOI3zcuhZvcZ78Gjmvgeir3o
         FvpdyAt1cx8GTHk3QFDFIRe3jq0AaJnFDVUtfmoH0LbI8uKuSrKo+MKiDBotn1trb2tR
         tgGYnNihC3nr/sgM6EyaKSdD6pzJkt7Ttx4nIYf0o5pavjZzRrYwLgeAtysz62QHhVLm
         6H94i+p4AE0eSwHnY/abShLK6E3JeGf+rOQHOBG7g/WFtro49tzCtsKmZ1ocmIcAGm3d
         K5U12MsezDSY5rVrdbv5ppdhccK6Yyj5PKUByZpeM/6LtfP3ssFvTRKgGU638nI3Xytb
         +Tog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685699108; x=1688291108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sO9CYKq3zsyFP6OrznRGehjIWLTIrAXykOQSpEJEjfc=;
        b=Vyj/ahWEkr22k+ptLgKQi/8pmC3y8PVZvQZLKYl42NG1GKz3hEpnKfEQkKmdw3fpEx
         x3JaRWhQ4uIqmN2rKYRPhOuQV6VG9hFh8cLJrgKJZbP7rkN2WKIaDIesJoRti5yQs3M0
         +c15+jdQN4GBUhHR6LerTjX5W/Lie01Ko+qI8k0sLHl26p+lKA+l2AOPbtpp/S3zvspK
         d1rBw6LCQHPqXAf31dQ9jOnnY4+6zHUFtNwkaOYSAy8h/jNHCLsmbqzFunedNDr28vpX
         MySZCjsdw3oAmGfcDRa9Keb4DCWxkhz3T5ZtgsomSC9M0XP/zYPixHS3/LiS7iCUCUl2
         emPA==
X-Gm-Message-State: AC+VfDzF/1VtAV5VElnDgDwmjWRMLl1PjkXzeAhVW4jvBPQABP32FP1V
	cPHPZ1zCZTylu8Eq0jWNJroIU5qBG+V9fWXVO/E=
X-Google-Smtp-Source: ACHHUZ7K2EOgjVq4WoCi44uJ9i/tvSnqHqw52MlY2vtO1cg3EMJxhBOLXPIBd6eWR9XrxZj65pTK1oOmh5KREk2hdV4=
X-Received: by 2002:a25:9d89:0:b0:ba8:620b:38a7 with SMTP id
 v9-20020a259d89000000b00ba8620b38a7mr2334349ybp.53.1685699107625; Fri, 02 Jun
 2023 02:45:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602065958.2869555-1-imagedong@tencent.com> <20230602065958.2869555-5-imagedong@tencent.com>
In-Reply-To: <20230602065958.2869555-5-imagedong@tencent.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Fri, 2 Jun 2023 17:44:56 +0800
Message-ID: <CADxym3ZTEvh2nrdY2PXhuApuU8=6MjNF71R_VSd4VDxp3URe8g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/5] selftests/bpf: rename bpf_fentry_test{7,8,9}
 to bpf_fentry_test_ptr*
To: olsajiri@gmail.com
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@google.com, haoluo@google.com, jolsa@kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	mykolal@fb.com, shuah@kernel.org, benbjiang@tencent.com, iii@linux.ibm.com, 
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

On Fri, Jun 2, 2023 at 3:03=E2=80=AFPM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> To make it more clear, let's make the N in bpf_fentry_testN as the count
> of target function arguments. Therefore, let's rename
> bpf_fentry_test{7,8,9} to bpf_fentry_test_ptr{1,2,3}.
>
> Meanwhile, to stop the checkpatch complaining, move the "noinline" ahead
> of "int".
>
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  net/bpf/test_run.c                            | 12 +++++-----
>  .../selftests/bpf/prog_tests/bpf_cookie.c     | 24 +++++++++----------
>  .../bpf/prog_tests/kprobe_multi_test.c        | 16 ++++++-------
>  .../testing/selftests/bpf/progs/fentry_test.c | 16 ++++++-------
>  .../testing/selftests/bpf/progs/fexit_test.c  | 16 ++++++-------
>  .../selftests/bpf/progs/get_func_ip_test.c    |  2 +-
>  .../selftests/bpf/progs/kprobe_multi.c        | 12 +++++-----
>  .../bpf/progs/verifier_btf_ctx_access.c       |  2 +-
>  .../selftests/bpf/verifier/atomic_fetch_add.c |  4 ++--
>  9 files changed, 52 insertions(+), 52 deletions(-)
>

Sadly, this patch breaks the "bpf_fentry_test?" pattern in
kprobe_multi.c and kprobe_multi_test.c.

I'm considering changing the "bpf_fentry_test?" to
"bpf_fentry_test*" to solve this problem.

Another option, we can remove kretprobe_test7_result
and kretprobe_test8_result and only check
bpf_fentry_test1~6 in kprobe_multi_check.

Or......maybe I shouldn't rename them?

