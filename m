Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F67DD34A4
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfJJXvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:51:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:39054 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfJJXvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:51:03 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iIiCz-0001j6-HD; Fri, 11 Oct 2019 01:51:01 +0200
Date:   Fri, 11 Oct 2019 01:51:01 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 0/2] Track read-only map contents as known
 scalars in BPF verifiers
Message-ID: <20191010235101.GB20202@pc-63.home>
References: <20191009201458.2679171-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009201458.2679171-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25598/Thu Oct 10 10:50:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 01:14:56PM -0700, Andrii Nakryiko wrote:
> With BPF maps supporting direct map access (currently, array_map w/ single
> element, used for global data) that are read-only both from system call and
> BPF side, it's possible for BPF verifier to track its contents as known
> constants.
> 
> Now it's possible for user-space control app to pre-initialize read-only map
> (e.g., for .rodata section) with user-provided flags and parameters and rely
> on BPF verifier to detect and eliminate dead code resulting from specific
> combination of input parameters.
> 
> v1->v2:
> - BPF_F_RDONLY means nothing, stick to just map->frozen (Daniel);
> - stick to passing just offset into map_direct_value_addr (Martin).
> 
> Andrii Nakryiko (2):
>   bpf: track contents of read-only maps as scalars
>   selftests/bpf: add read-only map values propagation tests
> 
>  kernel/bpf/verifier.c                         | 57 ++++++++++-
>  .../selftests/bpf/prog_tests/rdonly_maps.c    | 99 +++++++++++++++++++
>  .../selftests/bpf/progs/test_rdonly_maps.c    | 83 ++++++++++++++++
>  3 files changed, 237 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_rdonly_maps.c

Applied, thanks!
