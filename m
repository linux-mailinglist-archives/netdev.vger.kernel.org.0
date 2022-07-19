Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CCE578F2F
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 02:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbiGSATq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 20:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236485AbiGSATp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 20:19:45 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A88357E2
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 17:19:43 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v16so3509939wrr.6
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 17:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A/tfmTl8rXDFpYRGXN4+L+UsANM+7IsYT4VqGSMDHfM=;
        b=YsSa6GugGINKY6fPTPL9pliswrcB1UYTnSQSyvHufKXAKsnNqjgbZf/MrzBAVFkpkV
         3efUWwnPZNgyam4zbFiZvkF6DwmWKFdS4gCpQebSh57I/6VOBjSSfsjowVXVPiw71gNH
         de+i+jDRoJXPnuWcTFjPOCu7w5EYVFWAUjK8xRxu3vg0KbHaPYzSIuS0CLG8vyC+lneJ
         h4Ng6A/IL8PySfzmZtqDJZ+vkSLiZB+gEobBhwgUXPRZxEZxNCQ3mkTA+krKy7w5UpLY
         vLso/ZSSkedxwIUPkoCsvkpFvozIoqB8yMpsstKN1pibqE18Si1uau6Mu0kK3kRsror3
         2GFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A/tfmTl8rXDFpYRGXN4+L+UsANM+7IsYT4VqGSMDHfM=;
        b=Kf814Vje64mbeKKyxIdbTFWvJGKBTThvFA97YxlaU+KE9MdCbPsP2sG01LenWcE1T+
         02oUnWrifoPmhPVH6lK1x9mC/nFB4I8jerMMMQMr8bKOwQAlQxf7NaOxd+q9ooDrRiLe
         dy9NpPtC4abzsmetBd0LNUj13vl6pTN4VhZ487A3WPGBeQCr4ean6371O4zc+3fTRJ+p
         WJ/XabdegZrwkF2eJLMfDmWroXwEbfm/+jt6k9b9IDPQkVugfdbayfmZkAED1GmSkZac
         vim2iesfnTQERubwrvu/vefuDpcf5hb6MyENuSEUcpJpAHQD1uoUs45fAqXn1XVg3EHd
         D6Fg==
X-Gm-Message-State: AJIora/FXaEOzizXA0apJAy46wgdBuL+cA0bPiBvzCFn1/tdetd0ccgd
        ncOXP9lGmYvNZ1uhUQkv/36SJcUaLLVIb8xc2sa+tw==
X-Google-Smtp-Source: AGRyM1u7d1r2Bbb6nhCQBRvfKeZJGVEGRNOp/QpyZlEJg/hAAoSmdJGRxsGTEeAkJzI4ZjA4LDyHE6jEsWuJDXBvTtM=
X-Received: by 2002:a5d:64a3:0:b0:21d:adaa:ce4c with SMTP id
 m3-20020a5d64a3000000b0021dadaace4cmr24585254wrp.161.1658189982235; Mon, 18
 Jul 2022 17:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-9-yosryahmed@google.com> <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
 <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com> <CAJD7tkZUfNqD8z6Cv7vi1TxpwKTXhDn_yweDHnRr++9iJs+=ew@mail.gmail.com>
 <CAJD7tkb8-scb1sstre0LRhY3dgfUJhGvSR=DgEqfwcVtBwb+5w@mail.gmail.com>
In-Reply-To: <CAJD7tkb8-scb1sstre0LRhY3dgfUJhGvSR=DgEqfwcVtBwb+5w@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Mon, 18 Jul 2022 17:19:30 -0700
Message-ID: <CA+khW7i_SCDoMgtVWw=E5RkJBmSvqo+KFjVp3_X+LZ9wyfqO7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:34 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
[...]
>
> I think I figured this one out (the CI failure). I set max_entries for
> the maps in the test to 10, because I have 1 entry per-cgroup, and I
> have less than 10 cgroups. When I run the test with other tests I
> *think* there are other cgroups that are being created, so the number
> exceeds 10, and some of the entries for the test cgroups cannot be
> created.

Using hashmap to store per-cgroup data is only a short-term solution.
We should work on extending cgroup-local storage to tracing programs.
Maybe as a follow-up change once cgroup_iter is merged.

> in the bpf trace produced by my test, and the error turned out to be
> -E2BIG. I increased max_entries to 100 and it seems to be consistently
> passing when run with all the other tests, using both test_progs and
> test_progs-no_alu32.
>
> Please find a diff attached fixing this problem and a few other nits:
> - Return meaningful exit codes from the reclaimer() child process and
> check them in induce_vmscan().
> - Make buf and path variables static in get_cgroup_vmscan_delay()
> - Print error code in bpf trace when we fail to create a bpf map entry.
> - Print 0 instead of -1 when we can't find a map entry, to avoid
> underflowing the unsigned counters in the test.
>
> Let me know if this diff works or not, and if I need to send a new
> version with the diff or not. Also let me know if this fixes the
> failures that you have been seeing locally (which looked different
> from the CI failures).
>

Yosry, I also need to address Yonghong's comments in the cgroup_iter
patch, so we need to send v4 anyway.

Hao

> Thanks!
>
[...]
