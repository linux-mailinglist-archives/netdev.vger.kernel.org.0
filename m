Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA8B5AF8A9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 01:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiIFXw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 19:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiIFXw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 19:52:58 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DA68FD77
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 16:52:57 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id o123so13309206vsc.3
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 16:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=wRqVMxE5asRCyONtZXiNI4jt/r6hRzvWQplbpGU0eXU=;
        b=iBEKoN+5PHSHQaklEt5yc8ZTqcs3FS7aCAAvsTAIqmqWCIn6H1Oc88TdQahuDXhO11
         akRxQzPQzdPypQbL52Sj658FBqXDUeGpqfV3a0BNHhqNZPJ5TFljqr967wK678bRQqVy
         Mvm3Q6IZAzMmUxKzq1Md5wiLZsLhV2NS1XhRq6G5Uj8YfKk6o7b43xuh/rKmJNOy+p+B
         rEcQD7uKrB8rLWgNZNpqPPM895XNNEq831hHGXA7Z/2ZX7A5HpuQxwnCPt7qW8MxYiHC
         J6iwqD76eYBZzGtiyHVWoj/fpziO3Ubqd4FRpaMwtm70YMuMJZcezxtD/JDYOFS4jHu8
         a6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=wRqVMxE5asRCyONtZXiNI4jt/r6hRzvWQplbpGU0eXU=;
        b=IQU41R2Duz1O+ut5UW0Mc+pVP3lShxbgJme8eyJ+VErmlXaS3P9VmuZt5UJKA2sxbe
         5tmi3aI0gCA71f9tzEfl4R1v1soKslQ+VnB8HngZ6L5NBHHA9kdB5auyVq5b8HAQr1oq
         8sQUCEKjf5iQLhtF4PFleWTuKROSxIDCwkVQ+qVU0QOovLmeLgzL8VYLVWMZrG90Ix/7
         9qW+KMUA9QaB8kbfltDgpA1NHnfeDbiQjoF5AP6W7j6pV743FNMufdQOp9RP1+4B7Asz
         6xOoHSR/hf0K96maOQVpRaxaqoYTX1OdEpQ/uUDfmrAvb0EM+lo9Tgc7hSjEhMswpzu+
         zSUw==
X-Gm-Message-State: ACgBeo3JXwnN3TUJqF17mt1qHPJqGXotbq2zN0Pa8ThzcTbTWxGLmpKe
        q1Js3BxMWvPOwwkZLLC0cMYeqVZ46cCKhgyehwK9ww==
X-Google-Smtp-Source: AA6agR7gvFBQdbWfxioPwJQyEnJlXWYnnmNz1N8I8V908sZ8m7Yb9wr6Es9jtLSfj0nb1/goIP00h+ifs0N9VEwd8Sc=
X-Received: by 2002:a67:60c7:0:b0:392:b27d:33b4 with SMTP id
 u190-20020a6760c7000000b00392b27d33b4mr315878vsb.46.1662508376368; Tue, 06
 Sep 2022 16:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662058674.git.zhuyifei@google.com> <345fbce9b67e4f287a771c497e8bd1bccff50b58.1662058674.git.zhuyifei@google.com>
 <20220902055527.knlkzkrwnczpx6xh@kafai-mbp.dhcp.thefacebook.com> <CAA-VZPnMxN7ppWrjOr4oBo6veUVmuPXCj3P3GJdd_v+otSn8Qw@mail.gmail.com>
In-Reply-To: <CAA-VZPnMxN7ppWrjOr4oBo6veUVmuPXCj3P3GJdd_v+otSn8Qw@mail.gmail.com>
From:   YiFei Zhu <zhuyifei@google.com>
Date:   Tue, 6 Sep 2022 16:52:45 -0700
Message-ID: <CAA-VZPmqqW6xSsMiZbO1YkKhri-nKU49x3tqiT8a-KqGYhmpcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Ensure cgroup/connect{4,6}
 programs can bind unpriv ICMP ping
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 2, 2022 at 4:52 PM YiFei Zhu <zhuyifei@google.com> wrote:
>
> On Thu, Sep 1, 2022 at 10:55 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Sep 01, 2022 at 07:15:10PM +0000, YiFei Zhu wrote:
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/connect_ping.c b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
> > > new file mode 100644
> > > index 0000000000000..99b1a2f0c4921
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
> > > @@ -0,0 +1,318 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +
> > > +/*
> > > + * Copyright 2022 Google LLC.
> > > + */
> > > +
> > > +#define _GNU_SOURCE
> > > +#include <sys/mount.h>
> > > +
> > > +#include <test_progs.h>
> > > +#include <cgroup_helpers.h>
> > > +#include <network_helpers.h>
> > > +
> > > +#include "connect_ping.skel.h"
> > > +
> > > +/* 2001:db8::1 */
> > > +#define BINDADDR_V6 { { { 0x20,0x01,0x0d,0xb8,0,0,0,0,0,0,0,0,0,0,0,1 } } }
> > > +const struct in6_addr bindaddr_v6 = BINDADDR_V6;
> > static
>
> ack.
>
> > > +
> > > +static bool write_sysctl(const char *sysctl, const char *value)
> > This has been copied >2 times now which probably shows it will
> > also be useful in the future.
> > Take this chance to move it to testing_helpers.{h,c}.
>
> ack.

I changed it to test_progs.c because this helper uses CHECK which is
provided by test_progs.h, and testing_helpers.c seems to be used
elsewhere (non-test_progs) too. Lmk if this is not a good alternative.
