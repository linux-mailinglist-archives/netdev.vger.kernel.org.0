Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406DE385CA
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 09:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfFGHzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 03:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfFGHzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 03:55:36 -0400
Received: from oasis.local.home (unknown [95.87.249.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FA63208C0;
        Fri,  7 Jun 2019 07:55:33 +0000 (UTC)
Date:   Fri, 7 Jun 2019 03:55:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Matt Mullins <mmullins@fb.com>, hall@fb.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf] bpf: fix nested bpf tracepoints with per-cpu data
Message-ID: <20190607035528.43c0423d@oasis.local.home>
In-Reply-To: <CAEf4BzYdRGfJgQ6-Hb8NkCgUqFRVs304KE0KMfAy9vbbTOMp5g@mail.gmail.com>
References: <a6a31da39debb8bde6ca5085b0f4e43a96a88ea5.camel@fb.com>
        <20190606185427.7558-1-mmullins@fb.com>
        <CAEf4BzYdRGfJgQ6-Hb8NkCgUqFRVs304KE0KMfAy9vbbTOMp5g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 19:59:18 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Thu, Jun 6, 2019 at 1:17 PM Matt Mullins <mmullins@fb.com> wrote:
> >
> > BPF_PROG_TYPE_RAW_TRACEPOINTs can be executed nested on the same CPU, as
> > they do not increment bpf_prog_active while executing.
> >
> > This enables three levels of nesting, to support
> >   - a kprobe or raw tp or perf event,
> >   - another one of the above that irq context happens to call, and
> >   - another one in nmi context  
> 
> Can NMIs be nested?

No, otherwise several things in the kernel will break.

-- Steve
