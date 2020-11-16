Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C372B536D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbgKPVGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729667AbgKPVGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 16:06:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30F5E20829;
        Mon, 16 Nov 2020 21:06:53 +0000 (UTC)
Date:   Mon, 16 Nov 2020 16:06:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     paulmck <paulmck@kernel.org>, Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
Message-ID: <20201116160651.0e2d9b63@gandalf.local.home>
In-Reply-To: <20201116160218.3b705345@gandalf.local.home>
References: <00000000000004500b05b31e68ce@google.com>
        <20201115055256.65625-1-mmullins@mmlx.us>
        <20201116121929.1a7aeb16@gandalf.local.home>
        <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com>
        <20201116154437.254a8b97@gandalf.local.home>
        <20201116160218.3b705345@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 16:02:18 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> +		if (new) {
> +			for (i = 0; old[i].func; i++)
> +				if (old[i].func != tp_func->func
> +				    || old[i].data != tp_func->data)
> +					new[j++] = old[i];

Oops, need to check for old[i].func != tp_stub_func here too.

-- Steve

> +			new[nr_probes - nr_del].func = NULL;
> +		} else {
