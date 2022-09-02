Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495625ABB69
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 01:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiIBXxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 19:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiIBXxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 19:53:07 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA3310A9D5
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 16:53:06 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id f185so3560390vsc.4
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 16:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=aHIFCC3kpFp3YQLJk4FTqurxt/d3n4WszYmmvBZwDhY=;
        b=Qk5KaaKBAO4FtlWeCvLqDHIoVbdneWYsOYmRfpmTO6X7VLyIXMQAlLig9X35oVWJ+n
         N4NQhF3qF6xNYNZasuqRhow6YBGYRlM7ouTmx/+cVrFn28A7qmpH0EsFNytgHxjNkcOB
         upXWP0wmwWPKzdpqB3VMSIuYCKyptl0ZdIaHW6uy5fKMSL5rFSSF7F2NauAlliSB7uDj
         gVfWJDHauTgpV2M3wRYZ73xzKysXkz7QgN3XlsqU5Re4vm0m/nSagaM2quvNWCf/2Pat
         QwR3iO6DnghwtDMQ9stTgPpndG/bhktXPkMGM+jbRqajGl6nyqYduXVjkkrefz8p2LEi
         E6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=aHIFCC3kpFp3YQLJk4FTqurxt/d3n4WszYmmvBZwDhY=;
        b=W+4aA0XoWquEgPUIAg4jofBBxkHnIzL1RJGCHiwIb9f64FP209NKyg52vtsPV4wXe1
         SWrfVS7VQ0a952nmdhnfsaX32VbPoDrw46VtZQ2oqKHHyKtwQOMXRmmmk9C6sLvq0CnY
         6ZTcGSr3GxQjztiUmhrkKUWmUUtniTVc85AoxcMpDmXJ/bE+++axHGz0h3A1cC0bdnML
         +HKv9M67MudrotgwVmf64WZ+G+3pEDsvV9FNif2sCVd3Dj75OX9/EBNPdMXObVJ5o61y
         Cs7nyo9nTO316l4aQ8ubp5ql3/nmxWqCIC0YWNdyUxf1R3bLXErL5MShibxDEf1U2M68
         uFiw==
X-Gm-Message-State: ACgBeo0BDVjMJcg4+N31RYodZclqFknQULumZ0CE4wqlk3zduvjgC0iB
        IytU7EwAep371FCtYsjfDqsxqfcqupmnceNuLkgIhA==
X-Google-Smtp-Source: AA6agR5FbNsBuBXDuCXJxP0TEIu0NIWLcXkJn/tbLMyVrQI8NWGwX27AUu8EFFlMdmgWQkdvQHCJGsV6JiISXaZ9nKc=
X-Received: by 2002:a05:6102:3f13:b0:390:c6e0:7cad with SMTP id
 k19-20020a0561023f1300b00390c6e07cadmr10400070vsv.74.1662162785746; Fri, 02
 Sep 2022 16:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662058674.git.zhuyifei@google.com> <345fbce9b67e4f287a771c497e8bd1bccff50b58.1662058674.git.zhuyifei@google.com>
 <20220902055527.knlkzkrwnczpx6xh@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220902055527.knlkzkrwnczpx6xh@kafai-mbp.dhcp.thefacebook.com>
From:   YiFei Zhu <zhuyifei@google.com>
Date:   Fri, 2 Sep 2022 16:52:54 -0700
Message-ID: <CAA-VZPnMxN7ppWrjOr4oBo6veUVmuPXCj3P3GJdd_v+otSn8Qw@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 1, 2022 at 10:55 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Sep 01, 2022 at 07:15:10PM +0000, YiFei Zhu wrote:
> > diff --git a/tools/testing/selftests/bpf/prog_tests/connect_ping.c b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
> > new file mode 100644
> > index 0000000000000..99b1a2f0c4921
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
> > @@ -0,0 +1,318 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +/*
> > + * Copyright 2022 Google LLC.
> > + */
> > +
> > +#define _GNU_SOURCE
> > +#include <sys/mount.h>
> > +
> > +#include <test_progs.h>
> > +#include <cgroup_helpers.h>
> > +#include <network_helpers.h>
> > +
> > +#include "connect_ping.skel.h"
> > +
> > +/* 2001:db8::1 */
> > +#define BINDADDR_V6 { { { 0x20,0x01,0x0d,0xb8,0,0,0,0,0,0,0,0,0,0,0,1 } } }
> > +const struct in6_addr bindaddr_v6 = BINDADDR_V6;
> static

ack.

> > +
> > +static bool write_sysctl(const char *sysctl, const char *value)
> This has been copied >2 times now which probably shows it will
> also be useful in the future.
> Take this chance to move it to testing_helpers.{h,c}.

ack.

> > +{
> > +     int fd, err, len;
> > +
> > +     fd = open(sysctl, O_WRONLY);
> > +     if (!ASSERT_GE(fd, 0, "open-sysctl"))
> > +             return false;
> > +
> > +     len = strlen(value);
> > +     err = write(fd, value, len);
> > +     close(fd);
> > +     if (!ASSERT_EQ(err, len, "write-sysctl"))
> > +             return false;
> > +
> > +     return true;
> > +}
> > +
> > +static void test_ipv4(int cgroup_fd)
> > +{
> > +     struct sockaddr_in sa = {
> > +             .sin_family = AF_INET,
> > +             .sin_addr.s_addr = htonl(INADDR_LOOPBACK),
> > +     };
> > +     socklen_t sa_len = sizeof(sa);
> > +     struct connect_ping *obj;
> > +     int sock_fd;
> > +
> > +     sock_fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP);
> > +     if (!ASSERT_GE(sock_fd, 0, "sock-create"))
> > +             return;
> > +
> > +     obj = connect_ping__open_and_load();
> > +     if (!ASSERT_OK_PTR(obj, "skel-load"))
> > +             goto close_sock;
> > +
> > +     obj->bss->do_bind = 0;
> > +
> > +     /* Attach connect v4 and connect v6 progs, connect a v4 ping socket to
> > +      * localhost, assert that only v4 is called, and called exactly once,
> > +      * and that the socket's bound address is original loopback address.
> > +      */
> > +     obj->links.connect_v4_prog =
> > +             bpf_program__attach_cgroup(obj->progs.connect_v4_prog, cgroup_fd);
> > +     if (!ASSERT_OK_PTR(obj->links.connect_v4_prog, "cg-attach-v4"))
> > +             goto close_bpf_object;
> > +     obj->links.connect_v6_prog =
> > +             bpf_program__attach_cgroup(obj->progs.connect_v6_prog, cgroup_fd);
> > +     if (!ASSERT_OK_PTR(obj->links.connect_v6_prog, "cg-attach-v6"))
> > +             goto close_bpf_object;
> Overall, it seems like a lot of dup code can be saved
> between test_ipv4, test_ipv6, and their _bind() version.
>
> eg. The skel setup can be done once and the bss variables can be reset
> at the beginning of each test by memset(skel->bss, 0, sizeof(*skel->bss)).
> The result checking part is essentially checking the expected bss values
> and the getsockname result also.

ack.

> btw, does it make sense to do it as a subtest in
> connect_force_port.c or they are very different?

I could try, but they are structured differently; that checks the
ports whereas this checks the bound IPs. That test also doesn't use
skels or sets up netns whereas this test does. I think I would prefer
to have two tests since tests are cheap, but I can try to restructure
connect_force_port.c in a way that is compatible with both if you
insist.
