Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F10E1B6058
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 18:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgDWQHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 12:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729445AbgDWQHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 12:07:19 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEEDC09B040;
        Thu, 23 Apr 2020 09:07:19 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id n6so6753774ljg.12;
        Thu, 23 Apr 2020 09:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RDSCrwCJp6yV1aNxYeUky66qtSq/MJskkt7kK1B6xKQ=;
        b=Uf1KruvlAoJs+fAgo3ksUW3OW8MVaTPDBQgvnx+nc1mv+WI9yFalis4DezbVd32Zhn
         xJ9+TwEfaUDfP+ikXz/LTQoMq0hERb6o2o4YDQh2/KO25NYvYHwb2SJDscjO5B6Iytob
         Wy2Q+K6KdrNZPIVStFcZDuKLPDv2sGgxkNNft6y0ZnK+DXOYUsHuDwQs2JXP8Wnavavz
         Zop46z8it+bmF6F1h5JXYdhFI1mMlY+mgNW2pna1NjWBm5oyv91Y8RHf1U+NxGRqASq4
         vWlrcwtl4nE2pfJUYkwzgH3S4RUdpbn16xpMPV9/569nAX/xSUt+cRCIPMMuAk+9RrXt
         8kDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RDSCrwCJp6yV1aNxYeUky66qtSq/MJskkt7kK1B6xKQ=;
        b=b718X2qBGmm6CGz3N9Y8BOZGdxVr0vckxU0RLO+l+fWi35vxkcxWSkWYr5vaeY3Pjg
         lKrOdp9v/5q0hO+8zk4Ha1q303SuT6N9ngplF7bT1Q1gRbc8WI9OQRlCtudptVex78o3
         7cdXxhMvC0X1ngLrLP51pzEZLH3zSoZeprNdLROoPWz9MDfl0eN174Sz8+QZzvMMrcoP
         Ls1gxTSPqGmwB91WzQQCfFLS74+joN8gkRruOvgrzu6wIVAS1O9HiuUh7oBxf6zJmsu/
         BnV8DSe37j2b0YHbjfAhLaNcxwBQgSerfkYfuHTAEWMZj5AWdbgXY3whd9DmKwv3L0aT
         dWwA==
X-Gm-Message-State: AGi0Pua/A2RtuRjSlQt3AF3mejX7HQRRaxb3h0Q5CW7UnVFbI8EHbuev
        sPKM/HfFLNaDD71cxsNxCRwAXn/L/k02H2FatjQ=
X-Google-Smtp-Source: APiQypJAc7TZGWxpJrsl1LC1eNpmKa7WdnRVXX4YOULM8uo6TgMb9wma3PwDbfEnX7LIESTrts/E/0tuT1lK+Z4oSXs=
X-Received: by 2002:a2e:b80b:: with SMTP id u11mr2854291ljo.212.1587658037752;
 Thu, 23 Apr 2020 09:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200422093329.GI2659@kadam> <20200423033314.49205-1-maowenan@huawei.com>
 <20200423033314.49205-2-maowenan@huawei.com> <CAADnVQLfqLBzsjK0KddZM7WTL3unzWw+v18L0pw8HQnWsEVUzA@mail.gmail.com>
 <bd36c161-8831-1f61-1531-063723a8d8c2@huawei.com>
In-Reply-To: <bd36c161-8831-1f61-1531-063723a8d8c2@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 23 Apr 2020 09:07:05 -0700
Message-ID: <CAADnVQK_wWkLFyzZ5eXGvTQmBj=wOXNFL6vRZkNNBHLUYn5w6Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Change error code when ops is NULL
To:     maowenan <maowenan@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 11:25 PM maowenan <maowenan@huawei.com> wrote:
>
> On 2020/4/23 13:43, Alexei Starovoitov wrote:
> > On Wed, Apr 22, 2020 at 8:31 PM Mao Wenan <maowenan@huawei.com> wrote:
> >>
> >> There is one error printed when use BPF_MAP_TYPE_SOCKMAP to create map:
> >> libbpf: failed to create map (name: 'sock_map'): Invalid argument(-22)
> >>
> >> This is because CONFIG_BPF_STREAM_PARSER is not set, and
> >> bpf_map_types[type] return invalid ops. It is not clear to show the
> >> cause of config missing with return code -EINVAL, so add pr_warn() and
> >> change error code to describe the reason.
> >>
> >> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> >> ---
> >>  kernel/bpf/syscall.c | 7 ++++---
> >>  1 file changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> >> index d85f37239540..7686778457c7 100644
> >> --- a/kernel/bpf/syscall.c
> >> +++ b/kernel/bpf/syscall.c
> >> @@ -112,9 +112,10 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
> >>                 return ERR_PTR(-EINVAL);
> >>         type = array_index_nospec(type, ARRAY_SIZE(bpf_map_types));
> >>         ops = bpf_map_types[type];
> >> -       if (!ops)
> >> -               return ERR_PTR(-EINVAL);
> >> -
> >> +       if (!ops) {
> >> +               pr_warn("map type %d not supported or kernel config not opened\n", type);
> >> +               return ERR_PTR(-EOPNOTSUPP);
> >> +       }
> >
> > I don't think users will like it when kernel spams dmesg.
> > If you need this level of verbosity please teach consumer of libbpf to
> > print them.
> > It's not a job of libbpf either.
> thanks for reviw, so is it better to delete redundant pr_warn()?

which one?
