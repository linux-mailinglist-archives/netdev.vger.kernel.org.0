Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA2E53D282
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 21:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346642AbiFCTxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 15:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346266AbiFCTxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 15:53:07 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D731AD83
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 12:53:05 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id f23-20020a7bcc17000000b003972dda143eso6864609wmh.3
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 12:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=75r9OCRaKxDbstDb8Q6rmHNx4VG7/Ol3FIsxmmQpCKE=;
        b=OFS10OD5jepWzQUQgDwqO+/YoB6ZmGdD0wKjnuqRWMntCfyc/zl6FJU7+8IfeQ28pE
         xXfqBHZknnzrk9L1ttKK0MWceb5jWsOOQGLBa0wl39d8rGlcGwBUk2ZanvmgXNAtJyZr
         60Sf9V22ufhliS6cH9dvm+s6oX7B+irq5RWBwlaMWJ4Xko5YT9bz2OEzwuwSJ7i+fw0Z
         HR7HtVHJFw3Nj/n/X/vSCH6u1nQYW0Y81pb2f61wqTFPRYwQMCGNLv7vUeDBbRKT3Ig5
         +QjBWVhxJyQFtQQtDtDUdoy97HliJNHK5A1yPoWyiD/mzBH/EmKmZkHNRagT44RS6jjS
         ZZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=75r9OCRaKxDbstDb8Q6rmHNx4VG7/Ol3FIsxmmQpCKE=;
        b=cbyd9vDL/1nF/Qo9mhuY/XD+bnPQNdy9zj8aEerPDjqGrNfwE/6LsLYaoYBeHrnPL7
         Xb5N3Q63IQfs56O8Onga/21ZR+Apsy/5cKJATm5VZWNLmOetINR3DJ0e6Jyw03zAHl+m
         XlDLxQTAPbP1I1C2TYX63+yi3P1RlnMQclbNopyVPGE0ZaxKDKEzkb9eIo5WXAumjhrz
         1mvlEBgq/PgUnRHtxXXWmgkislmfpP+qEtJ9bXpdSfW0flQP1B/WFTa6Ih64mlp8gIvb
         v31VAh4sIxqmsewuYEHlUJofjCT6PLfQIZ2GKDqm8QoHnGmPWbjyvTLuo0AGV130zH7h
         n3rw==
X-Gm-Message-State: AOAM531tc8GB4lBHzyJUtfL4EE/NXetZZQunZKbP+tfVSR37AlE8Qvbc
        apUHJdsl1wL3syg+w+msdOCT+xkEmilLPwVCofrMGw==
X-Google-Smtp-Source: ABdhPJwuIVg8jNRLLKtimZoxTZU6/bvcyWF6n4woePM0h8xaQiqgd73SV9wNp6ELv1Q5jfaQTtZvszkc2RZLgXb8uqY=
X-Received: by 2002:a05:600c:3788:b0:39c:3a20:a50e with SMTP id
 o8-20020a05600c378800b0039c3a20a50emr6019549wmr.196.1654285983632; Fri, 03
 Jun 2022 12:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com> <20220603162339.GA25043@blackbody.suse.cz>
In-Reply-To: <20220603162339.GA25043@blackbody.suse.cz>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 3 Jun 2022 12:52:27 -0700
Message-ID: <CAJD7tkYwU5dW9Oof+pC81R9Bi-F=-EuiXpTn+HDeqbhTOTCcuw@mail.gmail.com>
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

Thanks for taking a look at this!

On Fri, Jun 3, 2022 at 9:23 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> On Fri, May 20, 2022 at 01:21:33AM +0000, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > +#define CGROUP_PATH(p, n) {.name =3D #n, .path =3D #p"/"#n}
> > +
> > +static struct {
> > +     const char *name, *path;
>
> Please unify the order of path and name with the macro (slightly
> confusing ;-).

Totally agree, will do.

>
> > +SEC("tp_btf/mm_vmscan_memcg_reclaim_end")
> > +int BPF_PROG(vmscan_end, struct lruvec *lruvec, struct scan_control *s=
c)
> > +{
> > [...]
> > +     struct cgroup *cgrp =3D task_memcg(current);
> > [...]
> > +     /* cgrp may not have memory controller enabled */
> > +     if (!cgrp)
> > +             return 0;
>
> Yes, the controller may not be enabled (for a cgroup).
> Just noting that the task_memcg() implementation will fall back to
> root_mem_cgroup in such a case (or nearest ancestor), you may want to
> use cgroup_ss_mask() for proper detection.

Good catch. I get confused between cgrp->subsys and
task->cgroups->subsys sometimes because of different fallback
behavior. IIUC cgrp->subsys should have NULL if the memory controller
is not enabled (no nearest ancestor fallback), and hence I can use
memory_subsys_enabled() that I defined just above task_memcg() to test
for this (I have no idea why I am not already using it here). Is my
understanding correct?

>
> Regards,
> Michal
