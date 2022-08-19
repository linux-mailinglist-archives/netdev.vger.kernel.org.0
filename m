Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DFC59924F
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 03:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbiHSBKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 21:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239326AbiHSBKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 21:10:04 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32442DDA8F;
        Thu, 18 Aug 2022 18:10:03 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id n125so3152049vsc.5;
        Thu, 18 Aug 2022 18:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=a+4YJ1LhJSNyK/sLr7JdvqPtNEtaZ4Z5AzpDGJs51kw=;
        b=h+9pelx8eiiyd0IkVd1BlXhfKkkVTdikoxVEKKTeMkhxIYLKe9yfAYzjs4f1ZmtKrU
         AoIO1SoacdD8rFz8JbEeRcVXK+nyPNnmo9MuTYvBPQi0wq1e2UIUwVL+wNpCpTvqPBvw
         6HiikZi3QWNvcmRMnTEuua2YNoKu0s2gQqiqh+E/IH+HSL8s7GbQtAnN9kQPx1uZxF/n
         g/1vQg5vuVOfW/XT0wbQtQ148FtewpbQ3dV/NKwl+wU0yzni5gqS2EpN1SuhoQAUNx6v
         sBY81kKYi4HXys1m7OQpV6+gybAhuqRD1NmMJZ9kgHuwLGW/vdVmmBGbEw4Wk5QYRd6p
         uoMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=a+4YJ1LhJSNyK/sLr7JdvqPtNEtaZ4Z5AzpDGJs51kw=;
        b=I9ge8oYRZlZ0qgG94BKpgr51OozXje6bmeMY3gEzvBjy0gMk6g4mZXoqBSALnaX0lo
         IAh1v8jyK4gdmgGdzoORqLhX7rltJC4wj8KE56iBY5QALrLj6wR4ZfkL9BRaHUK17WQr
         wMd0YbdEiMYyw15TulAg5EKIhv9FcNtHdI6kLQLcSyCO4pZWCIKDGphJvjFKX1U/kR9l
         X+yNvTGCi6S484gjI3K6yc5h0ziKQWkSqRaUwNe1HpKibuhKEDkxnQV8jBfHJ+dfeW5g
         6iw2qXScHl/QVk1F9twrtTHee7RHTxbUbWawt/cycm8mt6TmneDU+RIGJRrmyEYr5JCA
         IQeA==
X-Gm-Message-State: ACgBeo1X5C6hIcMcWV0VUrPwpPkkVVbE340Vcjp2L1iTmOPMOYcZO3om
        9Yl05+V8Me/8WoO1mPsvP7Zjqtq5LEKesP5xpA8=
X-Google-Smtp-Source: AA6agR61Oz/IzjKiBVm75sJ2/yHFLftaP8V01ijTbHM1H9PG+RiBdgq0LsaeUAx4kcfnWkXvkcm6noi2/eLvHbtBRiM=
X-Received: by 2002:a67:d50c:0:b0:38a:c107:25e0 with SMTP id
 l12-20020a67d50c000000b0038ac10725e0mr2073409vsj.11.1660871402196; Thu, 18
 Aug 2022 18:10:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220818143118.17733-1-laoar.shao@gmail.com> <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
In-Reply-To: <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 19 Aug 2022 09:09:25 +0800
Message-ID: <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for bpf map
To:     Tejun Heo <tj@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lizefan.x@bytedance.com, Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 6:33 AM Tejun Heo <tj@kernel.org> wrote:
>
> On Thu, Aug 18, 2022 at 12:20:33PM -1000, Tejun Heo wrote:
> > We have the exact same problem for any resources which span multiple
> > instances of a service including page cache, tmpfs instances and any other
> > thing which can persist longer than procss life time. My current opinion is
>
> To expand a bit more on this point, once we start including page cache and
> tmpfs, we now get entangled with memory reclaim which then brings in IO and
> not-yet-but-eventually CPU usage.

Introduce-a-new-layer vs introduce-a-new-cgroup, which one is more overhead?

> Once you start splitting the tree like
> you're suggesting here, all those will break down and now we have to worry
> about how to split resource accounting and control for the same entities
> across two split branches of the tree, which doesn't really make any sense.
>

The k8s has already been broken thanks to the memcg accounting on  bpf memory.
If you ignored it, I paste it below.
[0]"1. The memory usage is not consistent between the first generation and
new generations."

This issue will persist even if you introduce a new layer.

> So, we *really* don't wanna paint ourselves into that kind of a corner. This
> is a dead-end. Please ditch it.
>

It makes non-sensen to ditch it.
Because, the hierarchy I described in the commit log is *one* use case
of the selectable memcg, but not *the only one* use case of it. If you
dislike that hierarchy, I will remove it to avoid misleading you.

Even if you introduce a new layer, you still need the selectable memcg.
For example, to avoid the issue I described in [0],  you still need to
charge to the parent cgroup instead of the current cgroup.

That's why I described in the commit log that the selectable memcg is flexible.

-- 
Regards
Yafang
