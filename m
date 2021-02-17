Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59D431E174
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhBQVer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhBQVeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 16:34:31 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1E7C061574;
        Wed, 17 Feb 2021 13:33:51 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id f6so2159723iop.11;
        Wed, 17 Feb 2021 13:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=nL4HYnGjONDXKQ51tM0lMmG8I39shd1VRmw7Uv8Si0c=;
        b=IHICk4CxG+4ulTaddDa8xdQVJKoY+R/yJQiusQV3zKvIO2Ep/eHFiD/DSUAun+DYta
         cZd1Wk3kc13WqHt/K7Goz9CIR1OjUTRC0Dy1x10qnqnxZvyrZA4jgnqlZGT/rAWw9VfK
         55/TTAJfZ92vMKs/LNsg6UkRucRgqN8TcktlfJrwALuHunV4Hkkx+o1hWJ+kjC8SlLhJ
         fs182QVhZw61ODF+H6Q7uJBTNEsoSid7CKUHUZ5+AfORBfdWeaDHmpIO6oGIVTcaO8k+
         NaQ72RKLQAOVzU8ftSCF+qP7rpXp5sXpk0Xyi9VRUJiybCu3m12DIT9g4YSDEF0SmgHU
         ss1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=nL4HYnGjONDXKQ51tM0lMmG8I39shd1VRmw7Uv8Si0c=;
        b=tSaxFdKgTJ7v5y4F8QpKg+PQZaxdjPRxD8X7XMHs3lMINRzdTgylmDRerX/Lvj+362
         m+wgMt+Q8FVNKHXcwm5yd+lBXZtc9iJt8zqJuILOCmdNl2eMbkJ7VfoPx8M7mT55z1+7
         z2XNd7gqEAG94jgm2zjqyLCtXmcap18TWPQZioM1gvwUOk7yb45hnuX/EUwx0yRPLVLL
         2N267xQfhaagNswFksOGKspLGyTC4+8zSKyQA8YclxnQIEYIVM3w0aavCoXcBvL9HLZ9
         MfJN0WvkIm44y8HbVqS1PRP35OuFdLIk748xOe16kCmrb/KuDRTUpFKyzUrcjj/TBH33
         KGwg==
X-Gm-Message-State: AOAM533KmTQkpaEScv5U8R3rY8klGRrPhkCCdpby+4s2kkQdUJjXjnap
        CmNkw7ukJY/z05yxHe0PIdA=
X-Google-Smtp-Source: ABdhPJwlPh6RUUGh1uhNa2wINWo+tk93eANljBYrDf7LUpNrjNkxUGwh5+z5o5GEq2Cf9+8KCVIHew==
X-Received: by 2002:a05:6602:26cb:: with SMTP id g11mr848121ioo.180.1613597631003;
        Wed, 17 Feb 2021 13:33:51 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id d2sm1943769ilr.66.2021.02.17.13.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 13:33:50 -0800 (PST)
Date:   Wed, 17 Feb 2021 13:33:44 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>
Message-ID: <602d8bb8bfd98_fc5420880@john-XPS-13-9370.notmuch>
In-Reply-To: <20210217035844.53746-1-xiyou.wangcong@gmail.com>
References: <20210217035844.53746-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next] bpf: clear per_cpu pointers in
 bpf_prog_clone_create()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> =

> Pretty much similar to commit 1336c662474e
> ("bpf: Clear per_cpu pointers during bpf_prog_realloc") we also need to=

> clear these two percpu pointers in bpf_prog_clone_create(), otherwise
> would get a double free:
> =

>  BUG: kernel NULL pointer dereference, address: 0000000000000000
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: 0000 [#1] SMP PTI
>  CPU: 13 PID: 8140 Comm: kworker/13:247 Kdump: loaded Tainted: G=E2=80=86=
 =E2=80=86 =E2=80=86 =E2=80=86 =E2=80=86 =E2=80=86 =E2=80=86 =E2=80=86 W=E2=
=80=86 =E2=80=86 OE
> =E2=80=86 5.11.0-rc4.bm.1-amd64+ #1
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 0=
4/01/2014
>  test_bpf: #1 TXA
>  Workqueue: events bpf_prog_free_deferred
>  RIP: 0010:percpu_ref_get_many.constprop.97+0x42/0xf0
>  Code: [...]
>  RSP: 0018:ffffa6bce1f9bda0 EFLAGS: 00010002
>  RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000021dfc7b
>  RDX: ffffffffae2eeb90 RSI: 867f92637e338da5 RDI: 0000000000000046
>  RBP: ffffa6bce1f9bda8 R08: 0000000000000000 R09: 0000000000000001
>  R10: 0000000000000046 R11: 0000000000000000 R12: 0000000000000280
>  R13: 0000000000000000 R14: 0000000000000000 R15: ffff9b5f3ffdedc0
>  FS:=E2=80=86 =E2=80=86 0000000000000000(0000) GS:ffff9b5f2fb40000(0000=
) knlGS:0000000000000000
>  CS:=E2=80=86 =E2=80=86 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000000 CR3: 000000027c36c002 CR4: 00000000003706e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Call Trace:
> =E2=80=86 =E2=80=86 refill_obj_stock+0x5e/0xd0
> =E2=80=86 =E2=80=86 free_percpu+0xee/0x550
> =E2=80=86 =E2=80=86 __bpf_prog_free+0x4d/0x60
> =E2=80=86 =E2=80=86 process_one_work+0x26a/0x590
> =E2=80=86 =E2=80=86 worker_thread+0x3c/0x390
> =E2=80=86 =E2=80=86 ? process_one_work+0x590/0x590
> =E2=80=86 =E2=80=86 kthread+0x130/0x150
> =E2=80=86 =E2=80=86 ? kthread_park+0x80/0x80
> =E2=80=86 =E2=80=86 ret_from_fork+0x1f/0x30
> =

> This bug is 100% reproducible with test_kmod.sh.
> =

> Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> Fixes: 700d4796ef59 ("bpf: Optimize program stats")
> Fixes: ca06f55b9002 ("bpf: Add per-program recursion prevention mechani=
sm")
> Cc: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>=
