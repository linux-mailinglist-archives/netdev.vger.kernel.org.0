Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A158863B488
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 22:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbiK1VzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 16:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiK1VzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 16:55:17 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7150A2C646
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 13:55:16 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o5-20020a17090a678500b00218cd5a21c9so11459890pjj.4
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 13:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nFnq7S59RvAf9bn6VMcv33Zg5Tx9QlFPyh/eu90+/lE=;
        b=a0aJ8qvXTborh1V67PE27J3eNNxykmZPHSYjLt3kdwyaSwKGzMeoTlPGEwM9CIRroF
         J3MsznxRKvSapsKnCUDV8qLM17mGjmDYevjMS1uWKuvrA3pdKOJQCYsA8aDGb3/8n4Tz
         REJWEOSvJ+9j9w9yiyaLdnJEQg3xIborW3+wfnq39cGy78TNlzPAjRfD3V9oUttctwRs
         xso6EnH0zmX9CBPQue+ppJ6Ap8yIgWGFNjvCCiP8bTPI99BlvyXqemyN2lSb8ah+DskT
         jH+gFSIqwwNLXfz8bQGsThktSxI2R43O9UMOyxqmvvi/tS27fkQ9Ced9mAQM+etjP+Wg
         gJXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nFnq7S59RvAf9bn6VMcv33Zg5Tx9QlFPyh/eu90+/lE=;
        b=i9lg62aAs0hh4jtzZKbL1Linj/b4600pm03svWeLO6R90uRucYTjvAQsQDZGvgJyE4
         hkJ2OizWvuKPTC4YFjg76oKLfGeiIVrwx39UPUDS7C2rVMM8OYb9YBFwE13nG33W/59v
         IorWY1pCsl5r8I4tgPATBt3Ab5HDJbIPexx5+dIckZnkJbfhyy3aAIYphMm6a2PXPAlT
         MgI6RC3XMsPorB3QxD/5o75Y8zorMaM7C4zvhj2YnL01OX4hfhzRLS+gHLI/mZ4H9Zws
         KsP9dDxenNZ6txrOoQxfBZH/2HLqQq/Y+ItsVPZHsyxwO8J4+zj/jfOoiybaJw+edG7v
         lLWw==
X-Gm-Message-State: ANoB5pkrEL6GpmbGDWiLAU20iYDWAmn5K44CnFnBtjyJmrQCd6Zc2h3U
        K7VDayOcCKbR1VvmDEW4UdBKf8wKdRL0ckyi2BO63A==
X-Google-Smtp-Source: AA0mqf7uGzelzNgC1aauEvGPyqbPQTw7kQZX1IqZnMh2ssjInwBuX1wbBhjOUUrfkM+Pp1RSw6rMnSR79BoWvQuoqqY=
X-Received: by 2002:a17:902:ef44:b0:189:6793:644f with SMTP id
 e4-20020a170902ef4400b001896793644fmr17984656plx.38.1669672515651; Mon, 28
 Nov 2022 13:55:15 -0800 (PST)
MIME-Version: 1.0
References: <20221121100521.56601-1-xiangxia.m.yue@gmail.com>
 <20221121100521.56601-2-xiangxia.m.yue@gmail.com> <7ed2f531-79a3-61fe-f1c2-b004b752c3f7@huawei.com>
 <CAMDZJNUiPOcnpNg8tM4xCoJABJz_3=AaXLTm5ofQg64mGDkB_A@mail.gmail.com>
 <9278cf3f-dfb6-78eb-8862-553545dac7ed@huawei.com> <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com> <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
In-Reply-To: <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Mon, 28 Nov 2022 13:55:04 -0800
Message-ID: <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Hou Tao <houtao1@huawei.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 7:15 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>

Hi Tonghao,

With a quick look at the htab_lock_bucket() and your problem
statement, I agree with Hou Tao that using hash &
min(HASHTAB_MAP_LOCK_MASK, n_bucket - 1) to index in map_locked seems
to fix the potential deadlock. Can you actually send your changes as
v2 so we can take a look and better help you? Also, can you explain
your solution in your commit message? Right now, your commit message
has only a problem statement and is not very clear. Please include
more details on what you do to fix the issue.

Hao

> Hi
> only a warning from lockdep.
> 1. the kernel .config
> #
> # Debug Oops, Lockups and Hangs
> #
> CONFIG_PANIC_ON_OOPS=y
> CONFIG_PANIC_ON_OOPS_VALUE=1
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_SOFTLOCKUP_DETECTOR=y
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_HARDLOCKUP_DETECTOR_PERF=y
> CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> # CONFIG_WQ_WATCHDOG is not set
> # CONFIG_TEST_LOCKUP is not set
> # end of Debug Oops, Lockups and Hangs
>
> 2. bpf.c, the map size is 2.
> struct {
> __uint(type, BPF_MAP_TYPE_HASH);
> __uint(max_entries, 2);
> __uint(key_size, sizeof(unsigned int));
> __uint(value_size, sizeof(unsigned int));
> } map1 SEC(".maps");
>
> static int bpf_update_data()
> {
> unsigned int val = 1, key = 0;
>
> return bpf_map_update_elem(&map1, &key, &val, BPF_ANY);
> }
>
> SEC("kprobe/ip_rcv")
> int bpf_prog1(struct pt_regs *regs)
> {
> bpf_update_data();
> return 0;
> }
>
> SEC("tracepoint/nmi/nmi_handler")
> int bpf_prog2(struct pt_regs *regs)
> {
> bpf_update_data();
> return 0;
> }
>
> char _license[] SEC("license") = "GPL";
> unsigned int _version SEC("version") = LINUX_VERSION_CODE;
>
> 3. bpf loader.
> #include "kprobe-example.skel.h"
>
> #include <unistd.h>
> #include <errno.h>
>
> #include <bpf/bpf.h>
>
> int main()
> {
> struct kprobe_example *skel;
> int map_fd, prog_fd;
> int i;
> int err = 0;
>
> skel = kprobe_example__open_and_load();
> if (!skel)
> return -1;
>
> err = kprobe_example__attach(skel);
> if (err)
> goto cleanup;
>
> /* all libbpf APIs are usable */
> prog_fd = bpf_program__fd(skel->progs.bpf_prog1);
> map_fd = bpf_map__fd(skel->maps.map1);
>
> printf("map_fd: %d\n", map_fd);
>
> unsigned int val = 0, key = 0;
>
> while (1) {
> bpf_map_delete_elem(map_fd, &key);
> bpf_map_update_elem(map_fd, &key, &val, BPF_ANY);
> }
>
> cleanup:
> kprobe_example__destroy(skel);
> return err;
> }
>
> 4. run the bpf loader and perf record for nmi interrupts.  the warming occurs
>
> --
> Best regards, Tonghao
