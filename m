Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C907E12656B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfLSPH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:07:29 -0500
Received: from www62.your-server.de ([213.133.104.62]:41214 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfLSPH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 10:07:29 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihxOh-000547-JE; Thu, 19 Dec 2019 16:07:27 +0100
Date:   Thu, 19 Dec 2019 16:07:26 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 0/9] riscv: BPF JIT fix, optimizations and
 far jumps support
Message-ID: <20191219150726.GA23959@pc-9.home>
References: <20191216091343.23260-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216091343.23260-1-bjorn.topel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 10:13:34AM +0100, Björn Töpel wrote:
> 
> This series contain one non-critical fix, support for far jumps. and
> some optimizations for the BPF JIT.
> 
> Previously, the JIT only supported 12b branch targets for conditional
> branches, and 21b for unconditional branches. Starting with this
> series, 32b branching is supported.
> 
> As part of supporting far jumps, branch relaxation was introduced. The
> idea is to start with a pessimistic jump (e.g. auipc/jalr) and for
> each pass the JIT will have an opportunity to pick a better
> instruction (e.g. jal) and shrink the image. Instead of two passes,
> the JIT requires more passes. It typically converges after 3 passes.
> 
> The optimizations mentioned in the subject are for calls and tail
> calls. In the tail call generation we can save one instruction by
> using the offset in jalr. Calls are optimized by doing (auipc)/jal(r)
> relative jumps instead of loading the entire absolute address and
> doing jalr. This required that the JIT image allocator was made RISC-V
> specific, so we can ensure that the JIT image and the kernel text are
> in range (32b).
> 
> The last two patches of the series is not critical to the series, but
> are two UAPI build issues for BPF events. A closer look from the
> RV-folks would be much appreciated.
> 
> The test_bpf.ko module, selftests/bpf/test_verifier and
> selftests/seccomp/seccomp_bpf pass all tests.
> 
> RISC-V is still missing proper kprobe and tracepoint support, so a lot
> of BPF selftests cannot be run.

Applied, thanks!
