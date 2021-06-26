Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28413B508C
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 01:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhFZXiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 19:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229630AbhFZXiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 19:38:05 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95F9561C45;
        Sat, 26 Jun 2021 23:35:41 +0000 (UTC)
Date:   Sat, 26 Jun 2021 19:35:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Robert Richter <rric@kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Subject: Re: [PATCH] tracepoint: Do not warn on EEXIST or ENOENT
Message-ID: <20210626193540.706da950@rorschach.local.home>
In-Reply-To: <1252314758.18555.1624732969232.JavaMail.zimbra@efficios.com>
References: <20210626135845.4080-1-penguin-kernel@I-love.SAKURA.ne.jp>
        <20210626101834.55b4ecf1@rorschach.local.home>
        <7297f336-70e5-82d3-f8d3-27f08c7d1548@i-love.sakura.ne.jp>
        <20210626114157.765d9371@rorschach.local.home>
        <20210626142213.6dee5c60@rorschach.local.home>
        <1252314758.18555.1624732969232.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Jun 2021 14:42:49 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > If BPF is OK with registering the same probe more than once if user
> > space expects it, we can add this patch, which allows the caller (in
> > this case BPF) to not warn if the probe being registered is already
> > registered, and keeps the idea that a probe registered twice is a bug
> > for all other use cases.  
> 
> How can removal of the duplicates be non buggy then ? The first removal will match both probes.

The registering of the first duplicate would fail with an error, but
will not warn. There would be no unregistering needed.

-- Steve
