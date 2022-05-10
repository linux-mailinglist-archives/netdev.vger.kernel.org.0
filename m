Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A5B520A41
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiEJAi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbiEJAi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:38:26 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114F42AC6FD;
        Mon,  9 May 2022 17:34:31 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id b5so10413034ile.0;
        Mon, 09 May 2022 17:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4karCgB0MC1BnR8W1B+6xeveKW1nLUhu/KIW4e11r7E=;
        b=gPV/WNtmjhKATU3NOJJ2pJw0iSift/HVTYr5YFJsS1JUov3T3P2sugNCw4ICoi2aNI
         DN+uDBJG7kkKevRYgmg0JQ/nZIy3pnAhVVdsTOD9BWnVU1xH5Ixx4fwIM61GxmRKmKjL
         nBTx2psO/Mytl/Lx70vvQozaObWeysSydsSWlDGnlF6X4mw4JLrZvYcIRrBk0PvzQ5Lz
         pp7oNz4kWk1X6Lvyl9yPJBIE6Pzussr/T8e/CgwZFGRVcrEgBbK01QRaAN336Wkhr3Vv
         gRSZV3tAx8vrptWz++Iwlyv1KsvlnpmCtj31YZ3N+YYP0dAvAlZ+IXRbWWKBGW7WnHNF
         +jQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4karCgB0MC1BnR8W1B+6xeveKW1nLUhu/KIW4e11r7E=;
        b=NPbxDXGMJEO7lrhPJGmy/qU4XF5IPwxMKXb3Fwk3zZPtjaEPcnnxm7hBGRVWAM5wwZ
         fe4lhQDBf/ID7gWuAdOKxbby8jqKynS4xj8yBPtYTIqDTtTgP3FqmUuOTaIXPCLw56Po
         2KMlA/lQRuX/9GYrSo1uP7fzz5z6NTdtpNpYYKIfoKcHiLkNDm40cdnbAU2pnrUGyCFv
         TmXAo6g/tmdKEqwyU9ZzTJb/RPQJoZGPGM0keD7GBax+6Ks0QBDSRX+scXV7UwJwK6DT
         36VUADX7DW7DNzGYuQHWIoAB3bMQIG38aeamW8xhMWJw4997ue604Eut+mZ2aPWLTZ/u
         x80Q==
X-Gm-Message-State: AOAM533SLKYZznHDdQKyS7sFWtgQc8I+E49sbDgxLr9eIwkMn5Dh7roo
        L+hIKwutuhAgG12CGNgq0trfBdveah+voK94wD0=
X-Google-Smtp-Source: ABdhPJyXKMB/dcO/qmS2dmo6ODOVuO8sotAH8x77Z6eURlzacTOTt1pw+DNbYYdrMF9bz0dTDEjhqn+xEl0aV8YssTk=
X-Received: by 2002:a05:6e02:1d8d:b0:2cf:2112:2267 with SMTP id
 h13-20020a056e021d8d00b002cf21122267mr7869217ila.239.1652142870407; Mon, 09
 May 2022 17:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220507024840.42662-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220507024840.42662-1-zhoufeng.zf@bytedance.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 9 May 2022 17:34:19 -0700
Message-ID: <CAEf4BzZD5q2j229_gL_nDFse2v=k2Ea0nfguH+sOA2O1Nm5sQw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add bpf_map_lookup_percpu_elem for percpu map
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        zhouchengming@bytedance.com
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

On Fri, May 6, 2022 at 7:49 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> Trace some functions, such as enqueue_task_fair, need to access the
> corresponding cpu, not the current cpu, and bpf_map_lookup_elem percpu map
> cannot do it. So add bpf_map_lookup_percpu_elem to accomplish it for
> percpu_array_map, percpu_hash_map, lru_percpu_hash_map.
>
> The implementation method is relatively simple, refer to the implementation
> method of map_lookup_elem of percpu map, increase the parameters of cpu, and
> obtain it according to the specified cpu.
>

I don't think it's safe in general to access per-cpu data from another
CPU. I'd suggest just having either a ARRAY_OF_MAPS or adding CPU ID
as part of the key, if you need such a custom access pattern.

> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---
>  include/linux/bpf.h            |  2 ++
>  include/uapi/linux/bpf.h       |  9 +++++++++
>  kernel/bpf/arraymap.c          | 15 +++++++++++++++
>  kernel/bpf/core.c              |  1 +
>  kernel/bpf/hashtab.c           | 32 ++++++++++++++++++++++++++++++++
>  kernel/bpf/helpers.c           | 18 ++++++++++++++++++
>  kernel/bpf/verifier.c          | 17 +++++++++++++++--
>  kernel/trace/bpf_trace.c       |  2 ++
>  tools/include/uapi/linux/bpf.h |  9 +++++++++
>  9 files changed, 103 insertions(+), 2 deletions(-)
>

[...]
