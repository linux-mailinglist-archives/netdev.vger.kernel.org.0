Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B0B155FF
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 00:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfEFWY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 18:24:27 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:34658 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfEFWY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 18:24:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 578BC80D;
        Mon,  6 May 2019 15:24:26 -0700 (PDT)
Received: from e107158-lin.cambridge.arm.com (e107158-lin.cambridge.arm.com [10.1.194.71])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B28E3F575;
        Mon,  6 May 2019 15:24:22 -0700 (PDT)
Date:   Mon, 6 May 2019 23:24:19 +0100
From:   Qais Yousef <qais.yousef@arm.com>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Michal Gregorczyk <michalgr@live.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Mohammad Husain <russoue@gmail.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        duyuchao <yuchao.du@unisoc.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 1/4] bpf: Add support for reading user pointers
Message-ID: <20190506222419.mmysckxrkewkfl3t@e107158-lin.cambridge.arm.com>
References: <20190506183116.33014-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190506183116.33014-1-joel@joelfernandes.org>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/06/19 14:31, Joel Fernandes (Google) wrote:
> The eBPF based opensnoop tool fails to read the file path string passed
> to the do_sys_open function. This is because it is a pointer to
> userspace address and causes an -EFAULT when read with
> probe_kernel_read. This is not an issue when running the tool on x86 but
> is an issue on arm64. This patch adds a new bpf function call based
> which calls the recently proposed probe_user_read function [1].
> Using this function call from opensnoop fixes the issue on arm64.

You haven't updated the commit message as agreed. Please add more explanation
on how arm64 fails or drop the reference. Anyone reads this as-is would
think it always fails on arm64 but it does under some circumstances which
should be explained properly.

I tried opensnoop on 5.1-rc7 and 4.9.173 stable on juno-r2 using the in-tree
defconfig and opensnoop returned the correct results on both cases.

Thanks

--
Qais Yousef
