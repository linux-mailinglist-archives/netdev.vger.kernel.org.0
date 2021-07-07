Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0FD3BF23B
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 00:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhGGWsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 18:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230266AbhGGWsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 18:48:03 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA9B861CAC;
        Wed,  7 Jul 2021 22:45:21 +0000 (UTC)
Date:   Wed, 7 Jul 2021 18:45:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        syzbot+721aa903751db87aa244@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] tracepoint: Add tracepoint_probe_register_may_exist()
 for BPF tracing
Message-ID: <20210707184518.618ae497@rorschach.local.home>
In-Reply-To: <CAEf4BzZPb=cPf9V1Bz+USiq+b5opUTNkj4+CRjXdHcmExW3jVg@mail.gmail.com>
References: <20210629095543.391ac606@oasis.local.home>
        <CAEf4BzZPb=cPf9V1Bz+USiq+b5opUTNkj4+CRjXdHcmExW3jVg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Jul 2021 15:12:28 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> There doesn't seem to be anything conceptually wrong with attaching
> the same BPF program twice to the same tracepoint. Is it a hard
> requirement to have a unique tp+callback combination, or was it done
> mostly to detect an API misuse? How hard is it to support such use
> cases?
> 
> I was surprised to discover this is not supported (though I never had
> a use for this, had to construct a test to see the warning).

The callback is identified by the function and its data combination. If
there's two callbacks calling the same function with the same data on
the same tracepoint, one question is, why? And the second is how do you
differentiate the two?

-- Steve
