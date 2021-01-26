Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE52304D8D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732401AbhAZXKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391098AbhAZTFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 14:05:13 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA42C0613ED
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 11:04:33 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id n14so3612338qvg.5
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 11:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EATfXH05C7sO+ZiGSX2ih/2OURxpGjNZTr8CV//C8pA=;
        b=WGiuU9h+dSL1bOgmqLHWVvZQNBUVbQpz0xe2BbH4z+/KFpbwFgJJFCjvfT4vEQhZaI
         UN8FFGHF40F2BAG41Bvru1eRnbHlAIIqEozr7O+qQFf/odEMU6wa3Qh1L69rulgCn4xy
         ZODemIbp6i/TVHxHj9P02I8/yitM3FwFxb75Me6gsPdyFX2wqTVQ8Ki2E92KQItpFTgh
         o9Q+kW/mEx7cjpweVaJtA7HIR52c8AFTR2CH0Eg3/BzZsQjh0o2m5GnTlQlXyTWRa8x/
         I+EyT08fRFmYoQWWjuo9+SRxaPFFuO2IGZBNnXsbbEMQpbcHsAaB+X62NMpRfWZRF236
         oodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EATfXH05C7sO+ZiGSX2ih/2OURxpGjNZTr8CV//C8pA=;
        b=i+cwm5nnrckQ7NMUGu2bEc1mqoQnK52WZ0fxFyFbh7wvPelk7EmMEVgsog6Tg77+ll
         dJsHHw9AJqP/ZXyCo2ShZVpp+ujyjVdraUsQAdfweqEYMkbx1143Gi4TPRmaD6BvRfDQ
         oMFPqoyRG8wjOD++ShFJsjNwnH4EO5Ip5wzqSbD2r87Ohc0SgG35tHP00IeiNLhz/l/d
         cFBbB15Y9m7RG99muhisjZQoRvyxFXv8P5lFnnAGNPTvZHyCPHEyrGN6WgvDrl8MJioe
         C+xjUX9aZD18292r78axoqcMKGAqL1UUL9MjsTvATsRcq7pxbvml0AuxxuIvXug5K7Gt
         BBDg==
X-Gm-Message-State: AOAM530cTSKjWJInpSfpp/dvajmHHT9EDV1yE1n4NkG7QKgs7R1R2xj1
        5CboNFbQzXXAdsQM2vV61dyx+fBcsNqRD6hHeX0BFw==
X-Google-Smtp-Source: ABdhPJyWAoz0BWYelq6NjD3/2jNnSBNgzWZ6DUyqZskA3X9UZ9oWIbk9IPK7c6s/dsmBpgG30Hz4YuKAKcrerdxVRVQ=
X-Received: by 2002:a0c:a692:: with SMTP id t18mr7012974qva.18.1611687872226;
 Tue, 26 Jan 2021 11:04:32 -0800 (PST)
MIME-Version: 1.0
References: <20210126165104.891536-1-sdf@google.com> <20210126165104.891536-2-sdf@google.com>
 <20210126181838.boof6nddaazjrfng@kafai-mbp>
In-Reply-To: <20210126181838.boof6nddaazjrfng@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 26 Jan 2021 11:04:20 -0800
Message-ID: <CAKH8qBsbHGgcVYhHf14gk13gxVc4VxzLhEbur7L_Z6uGbHzYHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/2] selftests/bpf: verify that rebinding to
 port < 1024 from BPF works
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 10:18 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Jan 26, 2021 at 08:51:04AM -0800, Stanislav Fomichev wrote:
> > Return 3 to indicate that permission check for port 111
> > should be skipped.
> >
>
> [ ... ]
>
> > +void cap_net_bind_service(cap_flag_value_t flag)
> > +{
> > +     const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
> > +     cap_t caps;
> > +
> > +     caps = cap_get_proc();
> > +     if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
> > +             goto free_caps;
> > +
> > +     if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> > +                            flag),
> > +               "cap_set_flag", "errno %d", errno))
> > +             goto free_caps;
> > +
> > +     if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d", errno))
> > +             goto free_caps;
> > +
> > +free_caps:
> > +     if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> > +             goto free_caps;
> Also mentioned in v2, there is a loop.
Oops, missed that one, sorry.

> > +}
> > +
> > +void test_bind_perm(void)
> > +{
> > +     struct bind_perm *skel;
> > +     int cgroup_fd;
> > +
> > +     cgroup_fd = test__join_cgroup("/bind_perm");
> > +     if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> > +             return;
> > +
> > +     skel = bind_perm__open_and_load();
> > +     if (!ASSERT_OK_PTR(skel, "skel"))
> > +             goto close_cgroup_fd;
> > +
> > +     skel->links.bind_v4_prog = bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> > +     if (!ASSERT_OK_PTR(skel, "bind_v4_prog"))
> > +             goto close_skeleton;
> > +
> > +     cap_net_bind_service(CAP_CLEAR);
> > +     try_bind(110, EACCES);
> > +     try_bind(111, 0);
> > +     cap_net_bind_service(CAP_SET);
> Instead of always CAP_SET at the end of the test,
> it is better to do a cap_get_flag() to save the original value
> at the beginning of the test and restore it at the end
> of the test.
It might be easier to change cap_net_bind_service() to return a bool
which indicates that the flag was originally set.
If it wasn't, we can bypass cap_net_bind_service(CAP_SET).
Let me know if you strongly disagree, I'll try to play with this idea
and will send a v4 if it plays out nicely.
