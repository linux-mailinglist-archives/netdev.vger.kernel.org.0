Return-Path: <netdev+bounces-504-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA1A6F7D94
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 09:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18E97280F77
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 07:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D116B4C77;
	Fri,  5 May 2023 07:14:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA171C11
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 07:14:09 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C93A17DEB
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 00:14:05 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1aaf91ae451so13011615ad.1
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 00:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683270844; x=1685862844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1mNEbGlZsNmcj3zz4B24G7nWdw/7GrG+eSs3WE5Ht7g=;
        b=Djca4/jcZdXyVNOCiR3lHBGkqxrf6r6FZrbI1rzZUUzfuG4goQu9A487VEEGl8/8kL
         c9TuW7rrDkw9+2JAFfa21/HFaFmNhlyJgaNLwSmTsHnnIPrmt2Mj6EASbdEXaEUK8cLt
         Xc45jFn0jcdKFDjyk6vOTZb83Yh/FcpDbwStq4oJvac5Bh8jRwFJaFKwWZXxD/IA7Sdn
         AIU7N8i2ENl5xNPITe3dbWNn8MD5J/rwH1UylUCOEfqXTopGEVEKafFWHdHz8PICQdkw
         Y0g6gDE2bTjI3NlmzqCBxnljNZXw3NadvIvmaMHKKDqo0gToeMV9UIfs2PjhaFiZEIt6
         w7Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683270844; x=1685862844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1mNEbGlZsNmcj3zz4B24G7nWdw/7GrG+eSs3WE5Ht7g=;
        b=QN9jRaVAN9g9jcD9IWvzeowqFWYf2YnZVDEOB8epc1Ma5mgOsWFizPF+DjKj/mriJT
         9wXLkwBldSzRu81NToPFTGfMSvULPxF9InfA5qt2YChPdPUWlCmCktAsVGNuGogfIRMk
         Q4lvRVjNglrbvr6sLdr/rFIFPJdBZJNxZOVnCP7vCrOURP4aD9kvLTL0r39eKk7v3A3d
         XzQ30VZgdc62mfTE2+DKPFvFI8IByFMIEefNj6omna6tT8Gk3WokMTi7obiGuFjk9+RD
         0J4RMbsdWVqOUbGVZbfbDWBPo/Jwd31A4/lpSQxdXdb1em5426fbPQVbjTt1uYcaPjwR
         t20g==
X-Gm-Message-State: AC+VfDwTmgR5MmZRATvUoA5U/U85+Pg8LvG0xAM7YeDoSZFLr2RufQRy
	Q3LakHj7LYpUS9RAYirJwryhxq5Up9Eo06lfyqiaJw==
X-Google-Smtp-Source: ACHHUZ7KLiz6rEDepEsMuriA67NNfkZBVLuFZXyAps0WAHbixYyYYXux6Ma6R5HzUIMJnSqYUU0Akd9hTL7XXA9Ri0Y=
X-Received: by 2002:a17:902:d483:b0:1ab:2a89:ed9d with SMTP id
 c3-20020a170902d48300b001ab2a89ed9dmr549944plg.10.1683270844385; Fri, 05 May
 2023 00:14:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230505060818.60037-1-zhoufeng.zf@bytedance.com> <20230505060818.60037-3-zhoufeng.zf@bytedance.com>
In-Reply-To: <20230505060818.60037-3-zhoufeng.zf@bytedance.com>
From: Hao Luo <haoluo@google.com>
Date: Fri, 5 May 2023 00:13:52 -0700
Message-ID: <CA+khW7hZb6EJcoXUzkvrHKztsQ_J4cN+RRQjF-a73A8zE8S_NA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 2/2] selftests/bpf: Add testcase for bpf_task_under_cgroup
To: Feng zhou <zhoufeng.zf@bytedance.com>
Cc: martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, 
	kpsingh@kernel.org, sdf@google.com, jolsa@kernel.org, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com, 
	shuah@kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	yangzhenze@bytedance.com, wangdongdong.6@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 4, 2023 at 11:08=E2=80=AFPM Feng zhou <zhoufeng.zf@bytedance.co=
m> wrote:
>
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> test_progs:
> Tests new kfunc bpf_task_under_cgroup().
>
> The bpf program saves the new task's pid within a given cgroup to
> the remote_pid, which is convenient for the user-mode program to
> verify the test correctness.
>
> The user-mode program creates its own mount namespace, and mounts the
> cgroupsv2 hierarchy in there, call the fork syscall, then check if
> remote_pid and local_pid are unequal.
>
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> ---

Hi Feng,

I have a comment about the methodology of the test, but the patch
looks ok to me. Why do we have to test via a tracing program? I think
what we need is just a task and a cgroup. Since we have the kfunc
bpf_task_from_pid() and bpf_cgroup_from_id(), we can write a syscall
program which takes a pid and a cgroup id as input and get the task
and cgroup objects directly in the program.

I like testing via a syscall program because it doesn't depend on the
newtask tracepoint and it should be simpler. But I'm ok with the
current version of the patch, just have some thoughts.

Hao

