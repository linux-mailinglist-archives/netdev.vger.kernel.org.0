Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3D513F06
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfEELEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:04:35 -0400
Received: from foss.arm.com ([217.140.101.70]:56028 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727404AbfEELEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 07:04:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C9F8374;
        Sun,  5 May 2019 04:04:30 -0700 (PDT)
Received: from e107158-lin.cambridge.arm.com (e107158-lin.cambridge.arm.com [10.1.194.71])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBC4D3F238;
        Sun,  5 May 2019 04:04:26 -0700 (PDT)
Date:   Sun, 5 May 2019 12:04:24 +0100
From:   Qais Yousef <qais.yousef@arm.com>
To:     Joel Fernandes <joel@joelfernandes.org>
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
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] bpf: Add support for reading user pointers
Message-ID: <20190505110423.u7g3f2viovvgzbtn@e107158-lin.cambridge.arm.com>
References: <20190502204958.7868-1-joel@joelfernandes.org>
 <20190503121234.6don256zuvfjtdg6@e107158-lin.cambridge.arm.com>
 <20190503134935.GA253329@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190503134935.GA253329@google.com>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/03/19 09:49, Joel Fernandes wrote:
> On Fri, May 03, 2019 at 01:12:34PM +0100, Qais Yousef wrote:
> > Hi Joel
> > 
> > On 05/02/19 16:49, Joel Fernandes (Google) wrote:
> > > The eBPF based opensnoop tool fails to read the file path string passed
> > > to the do_sys_open function. This is because it is a pointer to
> > > userspace address and causes an -EFAULT when read with
> > > probe_kernel_read. This is not an issue when running the tool on x86 but
> > > is an issue on arm64. This patch adds a new bpf function call based
> > 
> > I just did an experiment and if I use Android 4.9 kernel I indeed fail to see
> > PATH info when running opensnoop. But if I run on 5.1-rc7 opensnoop behaves
> > correctly on arm64.
> > 
> > My guess either a limitation that was fixed on later kernel versions or Android
> > kernel has some strict option/modifications that make this fail?
> 
> Thanks a lot for checking, yes I was testing 4.9 kernel with this patch (pixel 3).
> 
> I am not sure what has changed since then, but I still think it is a good
> idea to make the code more robust against such future issues anyway. In
> particular, we learnt with extensive discussions that user/kernel pointers
> are not necessarily distinguishable purely based on their address.

Yes I wasn't arguing against that. But the commit message is misleading or
needs more explanation at least. I tried 4.9.y stable and arm64 worked on that
too. Why do you think it's an arm64 problem?

--
Qais Yousef
