Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932B452E878
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 11:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347598AbiETJNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 05:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbiETJNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 05:13:42 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254B2FD371
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 02:13:41 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k30so10618526wrd.5
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 02:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jKOS1vGID3J/FbD4HTDSZ/zk/t5PNErFudLDsYqbEjw=;
        b=eDW10/xIZg8sKzudeh/BQlWYLaGFZPTtoK3i1FcF+DsZPu/Efolmt5EniRfWlxNt0U
         1E5gvYAaXaVKbbbLyyZb2ZO39bU4ZOxFU3e2Ym62AKSjgXikXJhtQhGwqCVuFX44ejAd
         J4UmnsgvvSAb7eGxKalw2dogjSyRPfi6njZRCzVXqWmzyEB6jXIs94KOiRVbBqj4aLEk
         0MiGWxbyjTLm5IQQ6Y0UeFAN1GaH6hBiKI6NxT3uwI8kst31koBe3moFLywILByhvGqB
         8oED5ZAcd0gKNKtzQw4OvyR4foQ+7pqiTGoq0HEA/+WCZ+AwzGkTtA08XRS7ALuhVWrP
         LaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jKOS1vGID3J/FbD4HTDSZ/zk/t5PNErFudLDsYqbEjw=;
        b=2kjEPV+T4ti3MZRdpMCWlOixqIuS1iVsrk+Cmg//r6wW2fC9P2o4N/OB67YEO5zAm9
         1k5uGAnkajDnGD2DfNA3kcXnCmKY8exeuXM5mAjrt426VvgcbSkaihX3uIVJenmPNDl0
         acUPw+QARm4YD6Py55uD1c+eeHdZTALuWa7XdtednmRfCE8gUCm9G2OTN7Mt3pVvxiU0
         +Jm9obT9y78r9Yp6mSmwXMT8gwk/I3tG2yFbfvXZQS/Rus+NDp3hVmewSBeMUDQtcpYF
         COY0bblYvMb54h9/cVebhfpRKg3PfhQQ0teZXEH9ESUT2w4BvAkPtPkfi4XMI5C6P2wy
         gc1w==
X-Gm-Message-State: AOAM532dVOeVWj8mFe7XTYou1NbvQQwO9eHUt+LrF5mGmmEBauqQdeVT
        wmuVFE3PVSpSO526eJEDTP5dQ+F/nD1g22H6YsBNKw==
X-Google-Smtp-Source: ABdhPJzdNGEuWx52c5Mk4SfyNjiWYfScv37uAvT7HSY3sSxV4Mt41Wnou8aoh2If9uZxTmRc8VCgOe5De+zqkROkN/Y=
X-Received: by 2002:a05:6000:154a:b0:20c:7e65:c79e with SMTP id
 10-20020a056000154a00b0020c7e65c79emr7567562wry.582.1653038019513; Fri, 20
 May 2022 02:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com> <YodCPWqZodr7Shnj@slm.duckdns.org>
In-Reply-To: <YodCPWqZodr7Shnj@slm.duckdns.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 20 May 2022 02:13:03 -0700
Message-ID: <CAJD7tkYDLc9irHLFROcYSg1shwCw+Stt5HTS08FW3ceQ5b8vqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
To:     Tejun Heo <tj@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 12:24 AM Tejun Heo <tj@kernel.org> wrote:
>
> On Fri, May 20, 2022 at 01:21:30AM +0000, Yosry Ahmed wrote:
> > Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
> > tracing programs. bpf programs that make use of rstat can use these
> > functions to inform rstat when they update stats for a cgroup, and when
> > they need to flush the stats.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>
> Do patch 1 and 2 need to be separate? Also, can you explain and comment why
> it's __weak?

I will squash them in the next version.

As for the declaration, I took the __weak annotation from Alexei's
reply to the previous version. I thought it had something to do with
how fentry progs attach to functions with BTF and all.
When I try the same code with a static noinline declaration instead,
fentry attachment fails to find the BTF type ID of bpf_rstat_flush.
When I try it with just noinline (without __weak), the fentry program
attaches, but is never invoked. I tried looking at the attach code but
I couldn't figure out why this happens.

In retrospect, I should have given this more thought. It would be
great if Alexei could shed some light on this.

>
> Thanks.


>
> --
> tejun
