Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7A412BA7C
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfL0STP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:19:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:41764 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727393AbfL0SO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:14:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 11550ABEA;
        Fri, 27 Dec 2019 18:14:54 +0000 (UTC)
Date:   Fri, 27 Dec 2019 18:14:48 +0000
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     mrostecki@opensuse.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/2] bpftool/libbpf: Add probe for large INSN
 limit
Message-ID: <20191227181448.GA452@wotan.suse.de>
References: <20191227105346.867-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227105346.867-1-mrostecki@opensuse.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 11:53:44AM +0100, mrostecki@opensuse.org wrote:
> From: Michal Rostecki <mrostecki@opensuse.org>
> 
> This series implements a new BPF feature probe which checks for the
> commit c04c0d2b968a ("bpf: increase complexity limit and maximum program
> size"), which increases the maximum program size to 1M. It's based on
> the similar check in Cilium, althogh Cilium is already aiming to use
> bpftool checks and eventually drop all its custom checks.
> 
> Examples of outputs:
> 
> # bpftool feature probe
> [...]
> Scanning miscellaneous eBPF features...
> Large complexity limit and maximum program size (1M) is available
> 
> # bpftool feature probe macros
> [...]
> /*** eBPF misc features ***/
> #define HAVE_HAVE_LARGE_INSN_LIMIT
> 
> # bpftool feature probe -j | jq '.["misc"]'
> {
>   "have_large_insn_limit": true
> }
> 
> Michal Rostecki (2):
>   libbpf: Add probe for large INSN limit
>   bpftool: Add misc secion and probe for large INSN limit
> 
>  tools/bpf/bpftool/feature.c   | 18 ++++++++++++++++++
>  tools/lib/bpf/libbpf.h        |  1 +
>  tools/lib/bpf/libbpf.map      |  1 +
>  tools/lib/bpf/libbpf_probes.c | 23 +++++++++++++++++++++++
>  4 files changed, 43 insertions(+)
> 
> -- 
> 2.16.4
> 

Sorry for sending this twice! I didn't see the thread immediately after
sending the first time, so I though there is some problem with my
@opensuse.org alias or SMTP server not accepting it. Please review this
series, since I'm using @opensuse.org alias for upstream development
more frequently than @suse.de.
