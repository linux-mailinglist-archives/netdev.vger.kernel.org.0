Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAFF53A150
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 11:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344447AbiFAJyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 05:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiFAJyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 05:54:05 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAD15DE53;
        Wed,  1 Jun 2022 02:54:04 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id c2so1423798edf.5;
        Wed, 01 Jun 2022 02:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gggQbo5NJjrb3yk8zVJBSg+Moiv4wNE6luuvF26Nva4=;
        b=TGlMkx+WG1bgv466kwIPZfg1n0hlEuKZgWDt4a1taruNgqjxK8YALEO8qiTZN8XkB8
         TnEN4QHj3/K0uyZOICKdLIcOt8d2OL1OsuR4KRISnuznWznm0XqHZf2T6TUVCGzFnYrQ
         WQaGG7eXza6vvNOirULo0TASE2rK48ol18dnMt46pu2Z5gxWlj3sqgwQkEu5xEtnJj6M
         BugXLYzu+DdPYN/ExCS/nllxxb3dh0LLxT+6dYeqibxO3Ckqaf6zsiM46KbEEVD7VM+P
         rgKQc/02G6L8CLoq+hHHT0qYCnHEEHdbAK5S6UPnUUd9s1m/5Go9TZ2XR6irBoJ5/IJO
         C2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gggQbo5NJjrb3yk8zVJBSg+Moiv4wNE6luuvF26Nva4=;
        b=WV2APRRYYhKmAre/HsrartySmrUXReWYGLg46H0MLXoq1+ITDqF8NChikl3fZVNbR4
         6AEJLYSs11ca0zfHejiWj4pQIwyXQs510uzvnhGPmV6FURwGmOIIyb1h7rvsXIqEzutk
         0wvpLO+n6sJZ1+ax6J5//tt7OIIVB8DIC4a0hpT61hgfb0uVSGwKz2AEyjXKSiMy4ofI
         PsVFAtQaB1EPvqu2WMHm4FAcoR9j4H/bF2gpzaRjEGA2wz6LnVL8yNmzGUTPLlQYpgs5
         kaWw6nNo11AcMd//CdyFdivqmpPkyfv7Y+/ZoQ0YZFzkBCmRycpSDSfPCwkVr/3PRoqc
         6Gpg==
X-Gm-Message-State: AOAM531klMLLYFQHTFWlLunnJx6pQz/vjfNiFHj0VIrlsHWnpn0txkSx
        kqmjGSbznxJFC09sCGVW4zyrBcf8lbbYafmuXo4=
X-Google-Smtp-Source: ABdhPJycqxyS7kvzk9df31CqOiiAw96/FVQYFlPWsiZQuudaymqtVENI+aCjsojVKdUtd5nHww95Tu8DVgYC06Yjar4=
X-Received: by 2002:a05:6402:11ca:b0:42b:d282:4932 with SMTP id
 j10-20020a05640211ca00b0042bd2824932mr35251322edw.421.1654077243089; Wed, 01
 Jun 2022 02:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220601084149.13097-1-zhoufeng.zf@bytedance.com> <20220601084149.13097-3-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220601084149.13097-3-zhoufeng.zf@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Jun 2022 11:53:51 +0200
Message-ID: <CAADnVQ+qmvYK_Ttsjgo49Ga7paghicFg_O3=1sYZKbdps4877Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] selftest/bpf/benchs: Add bpf_map benchmark
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
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

On Wed, Jun 1, 2022 at 10:42 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
> +struct {
> +       __uint(type, BPF_MAP_TYPE_HASH);
> +       __type(key, u32);
> +       __type(value, u64);
> +       __uint(max_entries, MAX_ENTRIES);
> +} hash_map_bench SEC(".maps");
> +
> +u64 __attribute__((__aligned__(256))) percpu_time[256];

aligned 256 ?
What is the point?

> +u64 nr_loops;
> +
> +static int loop_update_callback(__u32 index, u32 *key)
> +{
> +       u64 init_val = 1;
> +
> +       bpf_map_update_elem(&hash_map_bench, key, &init_val, BPF_ANY);
> +       return 0;
> +}
> +
> +SEC("fentry/" SYS_PREFIX "sys_getpgid")
> +int benchmark(void *ctx)
> +{
> +       u32 key = bpf_get_prandom_u32() % MAX_ENTRIES + MAX_ENTRIES;

What is the point of random ?
just key = MAX_ENTRIES would be the same, no?
or key = -1 ?

> +       u32 cpu = bpf_get_smp_processor_id();
> +       u64 start_time = bpf_ktime_get_ns();
> +
> +       bpf_loop(nr_loops, loop_update_callback, &key, 0);
> +       percpu_time[cpu & 255] = bpf_ktime_get_ns() - start_time;
> +       return 0;
> +}
> --
> 2.20.1
>
