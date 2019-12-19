Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B959E1265EF
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfLSPll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:41:41 -0500
Received: from www62.your-server.de ([213.133.104.62]:48802 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfLSPlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 10:41:40 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihxvm-0008Re-07; Thu, 19 Dec 2019 16:41:38 +0100
Date:   Thu, 19 Dec 2019 16:41:37 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 2/3] libbpf/tools: add runqslower tool to libbpf
Message-ID: <20191219154137.GB4198@linux-9.fritz.box>
References: <20191219070659.424273-1-andriin@fb.com>
 <20191219070659.424273-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219070659.424273-3-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 11:06:57PM -0800, Andrii Nakryiko wrote:
> Convert one of BCC tools (runqslower [0]) to BPF CO-RE + libbpf. It matches
> its BCC-based counterpart 1-to-1, supporting all the same parameters and
> functionality.
> 
> runqslower tool utilizes BPF skeleton, auto-generated from BPF object file,
> as well as memory-mapped interface to global (read-only, in this case) data.
> Its makefile also ensures auto-generation of "relocatable" vmlinux.h, which is
> necessary for BTF-typed raw tracepoints with direct memory access.
> 
>   [0] https://github.com/iovisor/bcc/blob/11bf5d02c895df9646c117c713082eb192825293/tools/runqslower.py
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/tools/runqslower/.gitignore     |   2 +
>  tools/lib/bpf/tools/runqslower/Makefile       |  60 ++++++
>  .../lib/bpf/tools/runqslower/runqslower.bpf.c | 101 ++++++++++
>  tools/lib/bpf/tools/runqslower/runqslower.c   | 187 ++++++++++++++++++
>  tools/lib/bpf/tools/runqslower/runqslower.h   |  13 ++

tools/lib/bpf/tools/ is rather weird, please add to tools/bpf/ which is the
more appropriate place we have for small tools. Could also live directly in
there, e.g. tools/bpf/runqslower.{c,h,bpf.c} and then built/run from selftests,
but under libbpf directly is too odd.

Thanks,
Daniel
