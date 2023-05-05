Return-Path: <netdev+bounces-615-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F7596F88EF
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:48:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D97A21C21949
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 18:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7759AC8DE;
	Fri,  5 May 2023 18:48:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A23F156EF;
	Fri,  5 May 2023 18:48:54 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0A018FD3;
	Fri,  5 May 2023 11:48:52 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2ac8ee9cf7aso3465031fa.2;
        Fri, 05 May 2023 11:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683312530; x=1685904530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEImjqo4Dp5/B90VuSOXELs+WXxVvm2HyH+HGBF0hQ4=;
        b=jjFYaFDYSeUzx3kAeBOpfqAqx6gQ1SaXr4s9REGSLNefWd6wqSeMnfAEGy2qu0f76u
         OESnuRcyj/o4EHm6f/OTlLTQ40tmR0nAT7ogeCIlUFA9AfMn+RTOICptlXuELEQRTwCi
         kopVOWGXYsfuSOqpW37VAZWSoOdyYmU6OQ9hko9x/vxwFQG2w9S5vUdkQHoVcWzmJhPg
         20Q4V4e9dAwF136sqXxlO3WJZiyY/VeDoPcFseHKHajSkgiedStXjcxr+JEW4GJwyajT
         VjpGtn3//fA87LEQPhIoiAQRabr/77dGtEv5Aa9rBipWSfuV9VVoP2I65ezAzsFXth62
         K8vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683312530; x=1685904530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GEImjqo4Dp5/B90VuSOXELs+WXxVvm2HyH+HGBF0hQ4=;
        b=iuMl7jahLdm4DXOdQTSgNS6oohvq5IuRk1rCYX3M0DU/QyODmMdPMyGduVDiHD1kQd
         NF9HQJ6ZLlwgRWMkPvN5uNhrCTn7ivBR9RGWrCZA/0TBsiG5onuCBiNJANfFOlgaBx/N
         riQZIc/5+MOcmwJCCCVPNXdTCdDJBiT1iVDMA9QU2Q6hHTj//qeI3LDO7MkTMbsK7uME
         Zl1NtWRyzzHEZHjozVH+4VOZ4/iIi+D4KC4q6uuTbv7aMhrFHqGdu8Eaup3xPLTDZd90
         J46uiyK4KQmKxjgArXMqOPqjLhX7M+VALcxDhVLsWh9vfvm1TbMeXzlGAVnOjLqXhCGo
         xNpA==
X-Gm-Message-State: AC+VfDyGJCXkHq770/TUTqNPZSAl15j9t3NqlWaqm4URz7KZFtWrpmKQ
	8LfayZlEtTbxb+cxJGsO4/85VItnnX9TWbE3Q+E=
X-Google-Smtp-Source: ACHHUZ4tkxwoPn5CYMSOFSo2OJQvV6jfvySX/tLfWO/wRAV0L/jK3+nZymOI0ISCL+3Y+u52aPRbmuhqkok7qBaPiME=
X-Received: by 2002:a2e:9d17:0:b0:2ac:7958:ed34 with SMTP id
 t23-20020a2e9d17000000b002ac7958ed34mr639661lji.45.1683312530155; Fri, 05 May
 2023 11:48:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230505060818.60037-1-zhoufeng.zf@bytedance.com>
 <20230505060818.60037-2-zhoufeng.zf@bytedance.com> <CA+khW7g_gq1N=cNHC-5WG2nZ8a-wHSpwg_fc5=dQpkweGvROqA@mail.gmail.com>
 <f7a85b88-aa8c-a26a-8ccb-a20c62a76faa@bytedance.com> <b592dba0-685b-942f-3e0a-88f656733eae@meta.com>
In-Reply-To: <b592dba0-685b-942f-3e0a-88f656733eae@meta.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 5 May 2023 11:48:38 -0700
Message-ID: <CAADnVQLS+6WQx7ZTk8O+Q3YAHm7bv+viTik+Xy-mQbK2YRf+Xg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/2] bpf: Add bpf_task_under_cgroup() kfunc
To: Yonghong Song <yhs@meta.com>
Cc: Feng Zhou <zhoufeng.zf@bytedance.com>, Hao Luo <haoluo@google.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Song Liu <song@kernel.org>, 
	Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Stanislav Fomichev <sdf@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Mykola Lysenko <mykolal@fb.com>, 
	Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, yangzhenze@bytedance.com, 
	Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 5, 2023 at 11:44=E2=80=AFAM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 5/5/23 12:18 AM, Feng Zhou wrote:
> > =E5=9C=A8 2023/5/5 14:58, Hao Luo =E5=86=99=E9=81=93:
> >> On Thu, May 4, 2023 at 11:08=E2=80=AFPM Feng zhou <zhoufeng.zf@bytedan=
ce.com>
> >> wrote:
> >>>
> >> <...>
> >>> ---
> >>>   kernel/bpf/helpers.c | 20 ++++++++++++++++++++
> >>>   1 file changed, 20 insertions(+)
> >>>
> >>> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> >>> index bb6b4637ebf2..453cbd312366 100644
> >>> --- a/kernel/bpf/helpers.c
> >>> +++ b/kernel/bpf/helpers.c
> >>> @@ -2149,6 +2149,25 @@ __bpf_kfunc struct cgroup
> >>> *bpf_cgroup_from_id(u64 cgid)
> >>>                  return NULL;
> >>>          return cgrp;
> >>>   }
> >>> +
> >>> +/**
> >>> + * bpf_task_under_cgroup - wrap task_under_cgroup_hierarchy() as a
> >>> kfunc, test
> >>> + * task's membership of cgroup ancestry.
> >>> + * @task: the task to be tested
> >>> + * @ancestor: possible ancestor of @task's cgroup
> >>> + *
> >>> + * Tests whether @task's default cgroup hierarchy is a descendant of
> >>> @ancestor.
> >>> + * It follows all the same rules as cgroup_is_descendant, and only
> >>> applies
> >>> + * to the default hierarchy.
> >>> + */
> >>> +__bpf_kfunc long bpf_task_under_cgroup(struct task_struct *task,
> >>> +                                      struct cgroup *ancestor)
> >>> +{
> >>> +       if (unlikely(!ancestor || !task))
> >>> +               return -EINVAL;
> >>> +
> >>> +       return task_under_cgroup_hierarchy(task, ancestor);
> >>> +}
> >>>   #endif /* CONFIG_CGROUPS */
> >>>
> >>
> >> I wonder in what situation a null 'task' or 'ancestor' can be passed.
> >> Please call out in the comment that the returned value can be a
> >> negative error, so that writing if(bpf_task_under_cgroup()) may cause
> >> surprising results.
> >>
> >> Hao
> >
> > Hmm, you are right. As kfunc, the NULL value of the parameter is judged=
,
> > and bpf verify will prompt the developer to add it. There is really no
> > need to add this part of the judgment. See other people's opinions.
>
> Thanks for pointing out Hou.
>
> Currently, bpf_task_under_cgroup() is marked as KF_RCU.
>
> Per documentation:
> 2.4.7 KF_RCU flag
> -----------------
>
> The KF_RCU flag is a weaker version of KF_TRUSTED_ARGS. The kfuncs
> marked with
> KF_RCU expect either PTR_TRUSTED or MEM_RCU arguments. The verifier
> guarantees
> that the objects are valid and there is no use-after-free. The pointers
> are not
> NULL, but the object's refcount could have reached zero. The kfuncs need =
to
> consider doing refcnt !=3D 0 check, especially when returning a KF_ACQUIR=
E
> pointer. Note as well that a KF_ACQUIRE kfunc that is KF_RCU should very
> likely
> also be KF_RET_NULL.
>
>
> The pointer cannot be NULL, so the following line of code can be removed:
>  >>> +       if (unlikely(!ancestor || !task))
>  >>> +               return -EINVAL;

Right. With KF_RCU the verifier guarantees !=3D NULL.
Let's get rid of this check.
This will make the return value clean.

> I think we do not need to check refcnt !=3D 0 case since ancestor and
> task won't go away.

correct.

> In the example of second patch, both arguments are TRUSTED arguments
> which is stronger than RCU, so the test itself is okay.
> I am considering whether we should enforce arguments of the kfunc
> to be KF_TRUSTED_ARGS, but I think esp. in some cases, cgroup
> might be RCU protected e.g., task->cgroup->dfl_cgrp. So leaving argument
> requirement as KF_RCU should be better.

+1

