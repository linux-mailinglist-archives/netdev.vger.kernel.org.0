Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D3E2355A7
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 08:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgHBGVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 02:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgHBGVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 02:21:00 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C94DC06174A;
        Sat,  1 Aug 2020 23:21:00 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id i10so1658701ljn.2;
        Sat, 01 Aug 2020 23:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q41oWj/NNDB/My6ZAs0oE9w9CAemUhz1PzVtEZiL3vo=;
        b=vQx8hA0iYPA2O7ZCwFGiqCRHk1dpiYUJ+PVBNWwOUucKHmGvwZEc/woc/e6qDJ8F9g
         oBOezeN2UhHwk5DzHblYDV24zAU30TrZmdVjY2QWqeQY58AiOVV9edTQsVJ7TuxqMzvj
         djmR/cqm/VYCs/srq3eHaOE2W/pkAGazxJza//z9Zh56jF/MuOuBIftflNJ1xv/NvAfA
         fyjINbYjhOp5rH+090efYYY5m7UDAw8czCfrxh2/z4acvgsWbp8FXw5E2XNjohpNO/RM
         u/mxFJlZBPkEQ1WvFE2zZYkPFqrg1ntD+wk4dzb4QT7UVGo3Eo7+smWxXqS9r9wJuMdN
         pE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q41oWj/NNDB/My6ZAs0oE9w9CAemUhz1PzVtEZiL3vo=;
        b=nslhcArY2jLCpPC9qQcjz1jMgXWJpBS38w+MekebZT58PGeBCaQ3nyk728G/KVZOu0
         9M4I1HKIU2FaFQoXbYryGIjwM2rP04/dFzml68B53h/eiyUpuR0wnykL6pWpe3d/IyWN
         kg/QKEYP/EcMFpnCdYMEtukRKgGdxqnKPUCC4N/T4malGArHDrS7PPY7IBPrQoa2pejF
         fS/QZPgoVu7X5MkZfZ8WsNb3CleUWEYhPUgQ+nnwNTM/0cmgk0cR7mzvY+thgWIcLUy3
         iOUxnDgOKih3gXaQWOWVVkm6UqWmWIaKa+BsOlNQBG9yXjYPfryEqIL0LuLwPFhCbaRx
         vJww==
X-Gm-Message-State: AOAM531Q5hLmqXhRhLlwsQgHbVGfCvENweNgFO80sgtxR4pDz335QmGF
        HIMCHlzRY7dMRwYRNhP1KKxxP3W04/3KcEYvWmU=
X-Google-Smtp-Source: ABdhPJwhByjSOjX1Y9OMV8Pg632LX2U3zQjI0HKbR8VikFSmTJL3mcaK3kk31B2c2S0m5BnGKWkVVmDVWNIG9QyINbc=
X-Received: by 2002:a2e:b6cd:: with SMTP id m13mr5282165ljo.91.1596349258777;
 Sat, 01 Aug 2020 23:20:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200731204957.2047119-1-andriin@fb.com> <5f2493377c396_54fa2b1d9fe285b478@john-XPS-13-9370.notmuch>
In-Reply-To: <5f2493377c396_54fa2b1d9fe285b478@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 1 Aug 2020 23:20:47 -0700
Message-ID: <CAADnVQ+t6GD5vd4gwPaiTntsH_cSAYux03FEDwKYso_Va7uHRg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix spurious test failures in
 core_retro selftest
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 2:55 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > core_retro selftest uses BPF program that's triggered on sys_enter
> > system-wide, but has no protection from some unrelated process doing syscall
> > while selftest is running. This leads to occasional test failures with
> > unexpected PIDs being returned. Fix that by filtering out all processes that
> > are not test_progs process.
> >
> > Fixes: fcda189a5133 ("selftests/bpf: Add test relying only on CO-RE and no recent kernel features")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied. Thanks
