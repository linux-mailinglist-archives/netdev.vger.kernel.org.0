Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228C364AD98
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbiLMC0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiLMC0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:26:21 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF75625E;
        Mon, 12 Dec 2022 18:26:20 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gt4so1882171pjb.1;
        Mon, 12 Dec 2022 18:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWLAHlaacUeR4U3imT5Jn5UVOaxNTjElTnRgxyZnEM4=;
        b=DBmWrEliJz5TUxbKwl6VFRRxVHXmYJV5zdjVOvfI3mfDYyOqZRCYUYdXUDZPe09a5d
         VzdgXIau7RVv5+RXT5OWq60aq14TRyZMiJrd1AfbvdPscYZXnK9bbOtsvaSp8Hm0T4ir
         UsXpdmwuwnH5BZXiMVMy9PnesoNTVSfRO2Zprpincxxy0grafHdiaeT+K6GtfDPUzsS/
         DwPHSVeFxGY3YVcqL2wLNQTE3bw/J3BYGoaYvhLJJxGlVts/j2SNnwAk710EzFJ56HJb
         XFAyEjh5laWHRdN5ek207fPjGHyElLfxVOPHxdDeuFpiNR+T/zOnJ554pdmzUxtisYeA
         UZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mWLAHlaacUeR4U3imT5Jn5UVOaxNTjElTnRgxyZnEM4=;
        b=aAs0W9P6rEGh35GI0L/HeF1l33leHe8YbnN1ikX2ZvTrWpGo+ft8HWlSeT1qJCL1K0
         Q7B2eYFSAC8Vc0sK1OQ+M1Re8aAIwibccGFYA0/9xQYwbcQieTxZTAyxE1e8f+LGtsha
         aJEiS9Ztapd51TS7W9+r86Z7RE8ll7Bldc4MCuvn5jRrYIOH8PVedAi+oVGuapHBvQsP
         5HOaOwkEm5pyKZplmrSlK+kaLRQw0aDGa0/2sLpwZkZ2YBsrRr2KrcW7XGGWTYpUxplO
         JCnZ+ZwB5iSL05XeIDEAe1nWO4y9UD9owfzs36Hxyn8SWwSdUabDnvfbFv9AziUtbXEk
         tX7Q==
X-Gm-Message-State: ANoB5pl7g3VGrm7J0vYZ+nL9ff+hGBR+r2aiBqn2JX4s3oHUYgUy/xxg
        RS7ZCHj9PVkSkyzIuFfxDg==
X-Google-Smtp-Source: AA0mqf5t5DXABoJRK3+UIHLX0G5uv+bR5iZaOdnkA+v3z7cKVQlxLuutN6GDN5LtY6IFrbuN+HwGCw==
X-Received: by 2002:a17:903:1d0:b0:188:f5de:891f with SMTP id e16-20020a17090301d000b00188f5de891fmr24276903plh.11.1670898379806;
        Mon, 12 Dec 2022 18:26:19 -0800 (PST)
Received: from smtpclient.apple ([144.214.0.6])
        by smtp.gmail.com with ESMTPSA id l7-20020a170903120700b00189f2fdbdd0sm7090302plh.234.2022.12.12.18.26.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Dec 2022 18:26:19 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
From:   Hao Sun <sunhao.th@gmail.com>
In-Reply-To: <Y5dDArARol3gfVNf@krava>
Date:   Tue, 13 Dec 2022 10:26:13 +0800
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0B62D35A-E695-4B7A-A0D4-774767544C1A@gmail.com>
References: <Y5NSStSi7h9Vdo/j@krava>
 <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com> <Y5OuQNmkoIvcV6IL@krava>
 <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net> <Y5O/yxcjQLq5oDAv@krava>
 <96b0d9d8-02a7-ce70-de1e-b275a01f5ff3@iogearbox.net>
 <20221209153445.22182ca5@kernel.org> <Y5PNeFYJrC6D4P9p@krava>
 <CAADnVQKr9NYektHFq2sUKMxxXJVFHcMPWh=pKa08b-yM9cgAAQ@mail.gmail.com>
 <Y5SFho7ZYXr9ifRn@krava> <Y5dDArARol3gfVNf@krava>
To:     Jiri Olsa <olsajiri@gmail.com>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 12 Dec 2022, at 11:04 PM, Jiri Olsa <olsajiri@gmail.com> wrote:
>=20
> On Sat, Dec 10, 2022 at 02:11:34PM +0100, Jiri Olsa wrote:
>> On Fri, Dec 09, 2022 at 05:12:03PM -0800, Alexei Starovoitov wrote:
>>> On Fri, Dec 9, 2022 at 4:06 PM Jiri Olsa <olsajiri@gmail.com> wrote:
>>>>=20
>>>> On Fri, Dec 09, 2022 at 03:34:45PM -0800, Jakub Kicinski wrote:
>>>>> On Sat, 10 Dec 2022 00:32:07 +0100 Daniel Borkmann wrote:
>>>>>> fwiw, these should not be necessary, =
Documentation/RCU/checklist.rst :
>>>>>>=20
>>>>>>   [...] One example of non-obvious pairing is the XDP feature in =
networking,
>>>>>>   which calls BPF programs from network-driver NAPI (softirq) =
context. BPF
>>>>>>   relies heavily on RCU protection for its data structures, but =
because the
>>>>>>   BPF program invocation happens entirely within a single =
local_bh_disable()
>>>>>>   section in a NAPI poll cycle, this usage is safe. The reason =
that this usage
>>>>>>   is safe is that readers can use anything that disables BH when =
updaters use
>>>>>>   call_rcu() or synchronize_rcu(). [...]
>>>>>=20
>>>>> FWIW I sent a link to the thread to Paul and he confirmed
>>>>> the RCU will wait for just the BH.
>>>>=20
>>>> so IIUC we can omit the rcu_read_lock/unlock on bpf_prog_run_xdp =
side
>>>>=20
>>>> Paul,
>>>> any thoughts on what we can use in here to synchronize =
bpf_dispatcher_change_prog
>>>> with bpf_prog_run_xdp callers?
>>>>=20
>>>> with synchronize_rcu_tasks I'm getting splats like:
>>>>  =
https://lore.kernel.org/bpf/20221209153445.22182ca5@kernel.org/T/#m0a869f9=
3404a2744884d922bc96d497ffe8f579f
>>>>=20
>>>> synchronize_rcu_tasks_rude seems to work (patch below), but it also =
sounds special ;-)
>>>=20
>>> Jiri,
>>>=20
>>> I haven't tried to repro this yet, but I feel you're on
>>> the wrong path here. The splat has this:
>>> ? bpf_prog_run_xdp include/linux/filter.h:775 [inline]
>>> ? bpf_test_run+0x2ce/0x990 net/bpf/test_run.c:400
>>> that test_run logic takes rcu_read_lock.
>>> See bpf_test_timer_enter.
>>> I suspect the addition of synchronize_rcu_tasks_rude
>>> only slows down the race.
>>> The synchronize_rcu_tasks_trace also behaves like synchronize_rcu.
>>> See our new and fancy rcu_trace_implies_rcu_gp(),
>>> but I'm not sure it applies to synchronize_rcu_tasks_rude.
>>> Have you tried with just synchronize_rcu() ?
>>> If your theory about the race is correct then
>>> the vanila sync_rcu should help.
>>> If not, the issue is some place else.
>>=20
>> synchronize_rcu seems to work as well, I'll keep the test
>> running for some time
>=20
> looks good, Hao Sun, could you please test change below?

Hi,

Tested on a latest bpf-next build. The reproducer would trigger
the Oops in 5 mins without the patch. After applying the patch,
the reproducer cannot trigger any issue for more than 15 mins.
Seems working, tested on:

HEAD commit: ef3911a3e4d6 docs/bpf: Reword docs for =
BPF_MAP_TYPE_SK_STORAGE
git tree: bpf-next
kernel config: https://pastebin.com/raw/rZdWLcgK
C reproducer: https://pastebin.com/raw/GFfDn2Gk

>=20
> ---
> diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> index c19719f48ce0..4b0fa5b98137 100644
> --- a/kernel/bpf/dispatcher.c
> +++ b/kernel/bpf/dispatcher.c
> @@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct =
bpf_dispatcher *d, int prev_num_progs)
> }
>=20
> __BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
> + synchronize_rcu();
>=20
> if (new)
> d->image_off =3D noff;


