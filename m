Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0492B56C3D0
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239267AbiGHXEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239113AbiGHXEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:04:50 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107053C147;
        Fri,  8 Jul 2022 16:04:50 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id e15so241822edj.2;
        Fri, 08 Jul 2022 16:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mj2Ee6BNVC0lRz8SFhG2FrxB6VbtTeRJYQIs2AbTu0s=;
        b=M1nNIpWyo7U3mGICfv2akVhXxl+3tlXtuNaLk6idAg2RXGNMVybBKK3Q+Bg4pDkS0q
         r9Hj58KMmNwvUYlRAqBzbzFjgxqONxb3pvmw6h89HpVlrI0NFEQel8s13SOip7etSboT
         WcZx2l6StZLxGBQ9q7XyWgReTGUXJWmkvnjhvXS/LRcbgHqi8geusFKo2qBGMcO7VdoR
         R0gYmUgH2BvVKTNJ/pLStZ4tiT6c7Tvn2ECQUVal7GOrdFLnhFfJ6c8Du7DU9NmkEUW/
         lrKpGpxy1pDgKx6G4I9gvVccYZD8KipwpS3b9MR5Nnh3CtqCgmJ2nK78N8PWcLvwOQyf
         nQ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mj2Ee6BNVC0lRz8SFhG2FrxB6VbtTeRJYQIs2AbTu0s=;
        b=qS8VGoUp9esEXkGN6BI5dYzTBCuvIRVsbgnkQivCU7IjbXdLG4o5Nrqrbzt4R8OyJX
         BepxsjGRAqarHRTXY8FPETgR0P8hnD9WbSqvw6pD+LkNwwHFUR0hIf61jTQySin8Kjya
         7Eh9Ace2brB0VvBE0DhWVEwONB9gNqX8bCb+6gBVGb2/s9bxbu9nCeCYF2Lpl7WjuEGv
         jv7lkpy0bcAoZtVtwEpka5iD76b7Bpt1vL13MDYaa3OALdW7nUjH5LAazUuflTSTZVzR
         tXG+834qT7TwBGjoHq6ana7gIeEU55E8BXDZjNjgGE5HY9cqZ74yDpMGnWQN/a+fhT8X
         1NMg==
X-Gm-Message-State: AJIora/vPxm1ofEFNgWM/qldLzQ7sAGPPdyXwSKpyWAP038vCkZ7Jpob
        wAicX3lfnD/DqMN4JnxaY+lFapBpPP/JrqQ8ODk=
X-Google-Smtp-Source: AGRyM1sWBkuMD8jN4uB24QxHNnydV9PwsJNcmyTAZKY13PMRmzcHMNZsGdizzP7u+qgaSMR+nhxr/gHOUR0Q/qpheEw=
X-Received: by 2002:a05:6402:50d2:b0:43a:8487:8a09 with SMTP id
 h18-20020a05640250d200b0043a84878a09mr7932866edb.232.1657321488508; Fri, 08
 Jul 2022 16:04:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220708130319.1016294-1-maximmi@nvidia.com> <CAPhsuW5oGiXy27wyYXkzXCgYo+PD50paOvT1qKDwNjGsxGuWzQ@mail.gmail.com>
In-Reply-To: <CAPhsuW5oGiXy27wyYXkzXCgYo+PD50paOvT1qKDwNjGsxGuWzQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Jul 2022 16:04:37 -0700
Message-ID: <CAEf4BzZ4ep4gBpccuji4THxT92FqvjQBZ0iXhHtQx+ncYMkfYw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: Fix xdp_synproxy build failure if CONFIG_NF_CONNTRACK=m/n
To:     Song Liu <song@kernel.org>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
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

On Fri, Jul 8, 2022 at 9:49 AM Song Liu <song@kernel.org> wrote:
>
> On Fri, Jul 8, 2022 at 6:03 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> >
> > When CONFIG_NF_CONNTRACK=m, struct bpf_ct_opts and enum member
> > BPF_F_CURRENT_NETNS are not exposed. This commit allows building the
> > xdp_synproxy selftest in such cases. Note that nf_conntrack must be
> > loaded before running the test if it's compiled as a module.
> >
> > This commit also allows this selftest to be successfully compiled when
> > CONFIG_NF_CONNTRACK is disabled.
> >
> > One unused local variable of type struct bpf_ct_opts is also removed.
> >
> > Reported-by: Yauheni Kaliuta <ykaliuta@redhat.com>
> > Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> > Fixes: fb5cd0ce70d4 ("selftests/bpf: Add selftests for raw syncookie helpers")
>
> Given tools/testing/selftests/bpf/config specifies CONFIG_NF_CONNTRACK=y,
> I don't think this is really necessary.
>

We do redefine some of the kernel structs (e.g., bpf_iter.h), though,
to simplify build systems if it doesn't cost much maintenance burden.
Which seems to be the case here. So I've applied this to bpf-next
tree.


> Thanks,
> Song
>
>

[...]
