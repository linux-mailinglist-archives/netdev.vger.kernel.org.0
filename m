Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0785E58742C
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 01:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbiHAXAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 19:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiHAXAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 19:00:07 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22892FFFE
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 16:00:05 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id v28so9498127qkg.13
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 16:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OxoisoQrWhay6j5BeHUyCyZC1z5Zrwne8z9v746EFLw=;
        b=Td76G3pnsEYGodHWDyS8pYp3VYOSNNolQqHodrjcKrfGuCz09VlTpgXFTBJ88tTB5f
         ooUAyTdMrZP0qqPKFs23MUPcBr/KK9rAy+yax8oE/jpzxL3HVqO4PUqEQMAp9Ef0U1ii
         eysLCB+yXBbieXnwtHXatx31+diSavqEdO79TY3G+dzuIDL3YA8z5CLCt07mBy4AuMYh
         G+yUHSggy2s8+1Z09ocdEQyAAuS/nZQCjPa2WRf8OJtCtiXr3uQH18iaUPtBHwuAJ/U6
         1CopX5v6ID0F4wsjpl5MfehLuOjiW67kbhz3V1frJGh4jduTU6ARRbr12hIqyWPSm5jH
         fizw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OxoisoQrWhay6j5BeHUyCyZC1z5Zrwne8z9v746EFLw=;
        b=pYAmOgphlml0wkL8Bnvh8z5ClTUEXi/Uoxpl5cZ8JEMV1rgk4EdIMRjSTs9k5g4XNR
         6kMf2l7/GLaAxD1vnhaSJ359j4uzJT0cUqT0ZpZVK6R6dgwC91IPhtD/PJlx21oSuu3N
         NP4rg2+4edRkgoqIilXNpiHdRvPu8wf77DXRDaSHAXsoP48UHdt27hT8X7DWRmPoF4QH
         zFWD2HClbo3k5Qa1Y/pzyS0JJoY4dOyUXpcREQPOcjgFOEQhkjDn59o3K7USpH7Ai/Wd
         c3igYBJYmjSXV6la75fTimg4GIFeca8hWsBpP73EwdFV0RguGg2rvmONxSZYm2/dPHVf
         Wl2A==
X-Gm-Message-State: AJIora/J8ql80zv19rx+ECW//eBj0wKCH7N9I2MIaHdPsEt/4Cwy1wSr
        4lcK4KFntjpN0n2NoSgDTiVQpxn5JX/3M/E+17m7lg==
X-Google-Smtp-Source: AGRyM1t+1ZUxzKRxT13ygiAgkfs/P8HsXxLsVBttZ+GEHBI63/MsNU0EG66EW+Ys82VZgEJ9cw3nCIE6gryEGey2i9w=
X-Received: by 2002:a05:620a:f0e:b0:6b5:48f6:91da with SMTP id
 v14-20020a05620a0f0e00b006b548f691damr13315101qkl.446.1659394804965; Mon, 01
 Aug 2022 16:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220801175407.2647869-1-haoluo@google.com> <20220801175407.2647869-9-haoluo@google.com>
 <CAEf4Bza0BzW1urrDghOw2oynftOQ6jP7_k4VvEq-UgyBHp6D8g@mail.gmail.com>
In-Reply-To: <CAEf4Bza0BzW1urrDghOw2oynftOQ6jP7_k4VvEq-UgyBHp6D8g@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Mon, 1 Aug 2022 15:59:54 -0700
Message-ID: <CA+khW7iQiK0nqtpyc4CRjLkoaL5-w_mPqJ19mn6+7tHDMz4gew@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 8/8] selftests/bpf: add a selftest for cgroup
 hierarchical stats collection
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 3:00 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Aug 1, 2022 at 10:54 AM Hao Luo <haoluo@google.com> wrote:
> >
[...]
> > ---
> >  .../prog_tests/cgroup_hierarchical_stats.c    | 358 ++++++++++++++++++
> >  .../bpf/progs/cgroup_hierarchical_stats.c     | 218 +++++++++++
> >  2 files changed, 576 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> >
>
> [...]
>
> > +extern void cgroup_rstat_updated(struct cgroup *cgrp, int cpu) __ksym;
> > +extern void cgroup_rstat_flush(struct cgroup *cgrp) __ksym;
> > +
> > +static struct cgroup *task_memcg(struct task_struct *task)
> > +{
> > +       return task->cgroups->subsys[memory_cgrp_id]->cgroup;
>
> memory_cgrp_id is kernel-defined internal enum which actually can
> change based on kernel configuration (i.e., which cgroup subsystems
> are enabled or not), is that right?
>
> In practice you wouldn't hard-code it, it's better to use
> bpf_core_enum_value() to capture enum's value in CO-RE-relocatable
> way.
>
> So it might be a good idea to demonstrate that here.
>

Makes sense. Will use bpf_core_enum_value. Thanks!

> > +}
> > +
> > +static uint64_t cgroup_id(struct cgroup *cgrp)
> > +{
> > +       return cgrp->kn->id;
> > +}
> > +
>
> [...]
