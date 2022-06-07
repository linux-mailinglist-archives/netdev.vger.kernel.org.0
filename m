Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BEB54094A
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 20:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349498AbiFGSHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 14:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351330AbiFGSB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 14:01:57 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA1E12E80D
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:44:14 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h5so25214670wrb.0
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Avvoh8CnIiqiG7pt5w+f0B0Z6X7OPhtWirg6KypOnRk=;
        b=VJgCpuVqKSXl0XX58PrPxmWGKDkQdIE6BEthpBh1qGGSHXZS3+YISNnwTYkYarnho9
         MvxMYs2TMqZiGshTbPZ0zIzK1VVVXZpVgaziJrABATtPimx965adbeB6GqOUlTuNnyhz
         NPWJKmZexcPAKl4rzq3JtNd9/PXX0JeVvORheEEpbcyms/Ra+vjsuG5Kqeil6AQzy6/V
         KHCGQPlibPQzrK3H2wed7BEJ3UlHPtrRePVo21DyyddSbOjiJ+ttt3X/L876GbyiyvAw
         UJZAGIQaLuw88L2APyzR3tLX+5EFi65VfUbyfbBKfXfwkl++cELNNBZ8yhYU7i7NZ9fd
         954g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Avvoh8CnIiqiG7pt5w+f0B0Z6X7OPhtWirg6KypOnRk=;
        b=kXcYddCsVLBv8aEbu0fIRKAQNHU4N8OpWIFc1LIP4J8aeB5JZeQg4YtZLnBKsI6S6b
         2IRuJ2x3+oGlydRH8btAjzxtZDccKNTPZmA3JkUV3h2/jFYsMlbzDmGiU9uL7V+7iuG0
         2wOKORho9z+dnbPO+Eh47pTU+otsif6dYHah1itCKoNThd+3hm+S2eUazRpMIYb2Z9Jl
         P5RdCzr2CpDWBizfrAba6Si0gpo9cqB6qOp3P1QJE8fv40o2Ljwkh4VqfaAhjcNT6SdH
         8TXZgx5YoCYrdqZde4TwGs+u90KTSXkHtrLwjhsW0Sklnwtq8pApA8lbTF6YCRX9iTp9
         UD6g==
X-Gm-Message-State: AOAM533Vl8SBPQht94lO/67ixyZRj2FaUbVrfPmtXc1lYsFZoa1jETAX
        ddIIxKV7d2sRMp1QKE+/LHDHpPR+OaoTB6gsunhcYg==
X-Google-Smtp-Source: ABdhPJyFuoW87JmCWjoEcQfJUeb0WIaes2z5fAnqfq4EfroINBdg/KTV/oyVRDvIVcWJxGZ+BbW1f/v1QcNJHtOHOBw=
X-Received: by 2002:adf:eeca:0:b0:217:56ae:c657 with SMTP id
 a10-20020adfeeca000000b0021756aec657mr15290057wrp.210.1654623852628; Tue, 07
 Jun 2022 10:44:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com> <20220603162339.GA25043@blackbody.suse.cz>
 <CAJD7tkYwU5dW9Oof+pC81R9Bi-F=-EuiXpTn+HDeqbhTOTCcuw@mail.gmail.com>
 <20220606123222.GA4377@blackbody.suse.cz> <CAJD7tkbi7Gnnf4NiUt-J61G7185NsRcySvP6qOQsFKMou7qZJg@mail.gmail.com>
 <20220607121237.GC31717@blackbody.suse.cz>
In-Reply-To: <20220607121237.GC31717@blackbody.suse.cz>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 7 Jun 2022 10:43:35 -0700
Message-ID: <CAJD7tkYa3u52c77cnRxZ6D_4u5fkDG545r5a9SdK3Ys9Uuorig@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
 hierarchical stats collection
To:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
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
Content-Transfer-Encoding: quoted-printable
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

On Tue, Jun 7, 2022 at 5:12 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> On Mon, Jun 06, 2022 at 12:41:06PM -0700, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > I don't know if there is a standard way to handle this, but I think
> > you should know the configs of your kernel when you are loading a bpf
> > program?
>
> Isn't this one of purposes of BTF? (I don't know, I'm genuinely asking.)
>
> > If the CONFIG_CGROUPS=3D1 but CONFIG_MEMCG=3D0 I think everything will
> > work normally except that task_memcg() will always return NULL so no
> > stats will be collected, which makes sense.
>
> I was not able to track down what is the include chain to
> tools/testing/selftests/bpf/progs/cgroup_vmscan.c, i.e. how is the enum
> value memory_cgrp_id defined.

memory_cgrp_id is defined in "vmlinux.h" (generated from BTF) which is
included through "bpf_iter.h". If the kernel is not compiled with
CONFIG_MEMCG then this enum value will not be defined and the bpf prog
should not compile.

>
> (A custom kernel module build requires target kernel's header files, I
> could understand that compiling a BPF program requires them likewise and
> that's how this could work.
> Although, it goes against my undestanding of the CO-RE principle.)
>
> > There will be some overhead to running bpf programs that will always
> > do nothing, but I would argue that it's the userspace's fault here for
> > loading bpf programs on a non-compatible kernel.
>
> Yeah, running an empty program is non-issue in my eyes, I was rather
> considering whether the program uses proper offsets.
>
> Michal
>
