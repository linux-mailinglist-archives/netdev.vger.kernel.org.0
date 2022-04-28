Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D7F512D7F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343571AbiD1H7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343552AbiD1H7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:59:07 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718E020BCE;
        Thu, 28 Apr 2022 00:55:53 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id y76so7596046ybe.1;
        Thu, 28 Apr 2022 00:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=20Ih2IlUb6bJo8fqptV5Ls545wi0cHRNM9PIwsCTWig=;
        b=HW2WjBML2b6D8ENGrcYgynP0ORmNMbLedyIT2JE4zm4/+D7h7E8R15S6tCKjCgxE5F
         HPDClpLA5HDi8EXbKMl8wLKRkewvh4k8OALErPK2TSkqVGmV0S0R1UN750hYUKmrx1pY
         Gg/BQCtVK3dRfXOuO+yrJQsRiiV8j6aYc8eEYeGRcPEc9u/auRQG9WQvOlR7RD4kOWOL
         ml2awR1e2WiKRzk1ovs7MiviE0vjXZ8MbN/PqeA12PqQHrE7MynRZ7okyCzSQjKfKaUW
         Qj0r98qcCEme3ScPAH2ofJyQ9rh+cwToO8BU/o9ERuHNc3HES3R/W8YpF6hoXuU+kA6R
         h8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=20Ih2IlUb6bJo8fqptV5Ls545wi0cHRNM9PIwsCTWig=;
        b=NhU5tWlX0+SNOFmTnmYZtw1VHcjO52o7C+eOXlOySzp797j0f2L65AezSwulSCCnHh
         2+++wbs8csNpwbmhEGmcCIT97kuLBhbcr97qFsh/LldghKasBMV6TZsQxAsuXzEWEw2d
         DZ2aSIclnGLKP7Yx3f5jw5GKfWUI8tCDUfi/r1V82iWspqMQWp3qpCzDA6NVLQrpLjMb
         xDU/W6v988sNx/mbfr0uHrHCeTBjcoLXCRhvj9PQWCxdRCR/RPye4Q3onbGuF/pEvL+p
         70FNXDFqtKVb/9/thlSvw+/NQIiKZBkJGNkQsBgq0KPL4dcs3w7HF3gRkCiWgbpmhiwp
         ceyg==
X-Gm-Message-State: AOAM5320ZGHtspQZhnjvGnDRUcJJzv1xkm0NvC4HsPemXQPbqwea9GGQ
        QVUB8bE5PBqof0tT4KKWjY9BPU5ZhlrffjbuCBg=
X-Google-Smtp-Source: ABdhPJw8pf7dHDJGDk4MLm1MPOPR7xtPtgmoUI+cAYaw4tMFKuYcyPOqVButzGZ1veH2KFcVReaJdxuPRSjv15oQplw=
X-Received: by 2002:a25:9845:0:b0:628:99a6:55ed with SMTP id
 k5-20020a259845000000b0062899a655edmr29064779ybo.221.1651132552546; Thu, 28
 Apr 2022 00:55:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220424165309.241796-1-eyal.birger@gmail.com>
 <CAHsH6Gtpu-+79r2wrs1U=X=wMjVh2MfNxdgDtsL7yOfsKzKXDA@mail.gmail.com> <CAEf4BzZ3vDvLDQ+Wsj1z2=-exZO-t510JdWXA-1bao-shO4PJg@mail.gmail.com>
In-Reply-To: <CAEf4BzZ3vDvLDQ+Wsj1z2=-exZO-t510JdWXA-1bao-shO4PJg@mail.gmail.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 28 Apr 2022 10:55:41 +0300
Message-ID: <CAHsH6GujcJP=NXXetUBcCC_qAHfXCzEbid64jRwTTgnjd7oUOw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: test setting tunnel key from lwt xmit
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, posk@google.com,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 10:41 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Apr 24, 2022 at 10:23 AM Eyal Birger <eyal.birger@gmail.com> wrote:
> >
> > On Sun, Apr 24, 2022 at 7:53 PM Eyal Birger <eyal.birger@gmail.com> wrote:
> > >
> > > This commit adds test_egress_md() tests which perform a similar flow as
> > > test_egress() only that they use gre devices in collect_md mode and set
> > > the tunnel key from lwt bpf xmit.
> > >
> > > VRF scenarios are not checked since it is currently not possible to set
> > > the underlying device or vrf from bpf_set_tunnel_key().
> > >
> > > This introduces minor changes to the existing setup for consistency with
> > > the new tests:
> > >
> > > - GRE key must exist as bpf_set_tunnel_key() explicitly sets the
> > >   TUNNEL_KEY flag
> > >
> > > - Source address for GRE traffic is set to IPv*_5 instead of IPv*_1 since
> > >   GRE traffic is sent via veth5 so its address is selected when using
> > >   bpf_set_tunnel_key()
> > >
> > > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> > > ---
> > >  .../selftests/bpf/progs/test_lwt_ip_encap.c   | 51 ++++++++++-
> > >  .../selftests/bpf/test_lwt_ip_encap.sh        | 85 ++++++++++++++++++-
> > >  2 files changed, 128 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c b/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c
> > > index d6cb986e7533..39c6bd5402ae 100644
> > > --- a/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c
> > > +++ b/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c
> >
> > Thinking about this some more, I'm not sure if these tests fit better here
> > or in test_tunnel.sh.
> >
> > If the latter is preferred, please drop this patch and I'll submit one for
> > test_tunnel.sh.
>
> general preference is to put test into test_progs as those are
> regularly and extensively exercised, while test_tunnel.sh is not

Thanks. Will move the logic there then.
>
> >
> > Eyal.
