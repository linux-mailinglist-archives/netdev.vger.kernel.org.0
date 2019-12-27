Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4FC212B47C
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 13:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfL0MVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 07:21:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:38860 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfL0MVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 07:21:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A7DE2B285;
        Fri, 27 Dec 2019 12:21:48 +0000 (UTC)
From:   Michal Rostecki <mrostecki@suse.de>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Rostecki <mrostecki@suse.de>
Subject: [PATCH bpf-next 0/2] bpftool/libbpf: Add probe for large INSN limit
Date:   Fri, 27 Dec 2019 12:06:03 +0100
Message-Id: <20191227110605.1757-1-mrostecki@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements a new BPF feature probe which checks for the
commit c04c0d2b968a ("bpf: increase complexity limit and maximum program
size"), which increases the maximum program size to 1M. It's based on
the similar check in Cilium, althogh Cilium is already aiming to use
bpftool checks and eventually drop all its custom checks.

Examples of outputs:

# bpftool feature probe
[...]
Scanning miscellaneous eBPF features...
Large complexity limit and maximum program size (1M) is available

# bpftool feature probe macros
[...]
/*** eBPF misc features ***/
#define HAVE_HAVE_LARGE_INSN_LIMIT

# bpftool feature probe -j | jq '.["misc"]'
{
  "have_large_insn_limit": true
}

Michal Rostecki (2):
  libbpf: Add probe for large INSN limit
  bpftool: Add misc secion and probe for large INSN limit

 tools/bpf/bpftool/feature.c   | 18 ++++++++++++++++++
 tools/lib/bpf/libbpf.h        |  1 +
 tools/lib/bpf/libbpf.map      |  1 +
 tools/lib/bpf/libbpf_probes.c | 23 +++++++++++++++++++++++
 4 files changed, 43 insertions(+)

-- 
2.16.4

