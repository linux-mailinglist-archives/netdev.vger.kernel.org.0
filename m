Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679274291FB
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238012AbhJKOgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237737AbhJKOgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 10:36:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64276023F;
        Mon, 11 Oct 2021 14:34:44 +0000 (UTC)
Date:   Mon, 11 Oct 2021 10:34:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Hou Tao <houtao1@huawei.com>
Cc:     Hou Tao <hotforest@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Ingo Molnar <mingo@redhat.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v5 0/3] add support for writable bare
 tracepoint
Message-ID: <20211011103442.2ce9fab7@gandalf.local.home>
In-Reply-To: <0147c4ea-773a-5fe9-dea5-edd16ad1db12@huawei.com>
References: <20211004094857.30868-1-hotforest@gmail.com>
        <20211004104629.668cadeb@gandalf.local.home>
        <0147c4ea-773a-5fe9-dea5-edd16ad1db12@huawei.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Oct 2021 20:07:10 +0800
Hou Tao <houtao1@huawei.com> wrote:

> Not tried yet, but considering that VFS maintainer refused to have tracepoint in
> VFS layer, I'm not sure it is worth trying.

The reason they refuse to is because it shows data that can become an API.
But if that data is just a pointer, then it's not possible to become an API
no more than a RAW tracepoint that BPF can hook to.

Try asking.

> >
> > That is, it only gives you a pointer to what is passed in, but does not
> > give you anything else to form any API against it.
> > This way, not only does BPF have access to this information, so do the
> > other tracers, through the new eprobe interface:  
> Or in a opposite way can eprobe add support for bare tracepoint ?

If there's a way to expose the parameters of a bare tracepoint, then it
should not be difficult to do so. Heck, we can just have "bare tracepoints"
be events, that do nothing but repeat their pointer parameters, as that's
basically all they do anyway. There's nothing fundamentally different
between a "bare tracepoint" and a trace event that just defines the fields
as the same as the parameters to a tracepoint, except now you have another
way to know what the parameters are.

-- Steve
