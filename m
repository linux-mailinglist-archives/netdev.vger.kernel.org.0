Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D461BEC7B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 01:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgD2XOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 19:14:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:59308 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgD2XOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 19:14:49 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTvuf-0006px-NU; Thu, 30 Apr 2020 01:14:45 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTvuf-000XIk-Cq; Thu, 30 Apr 2020 01:14:45 +0200
Subject: Re: [PATCH bpf-next 0/3] Enable socket lookup in SOCKMAP/SOCKHASH
 from BPF
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Joe Stringer <joe@wand.net.nz>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200429181154.479310-1-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f7ba5ff9-59a2-b79f-a004-35ce3c12ba8b@iogearbox.net>
Date:   Thu, 30 Apr 2020 01:14:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200429181154.479310-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25797/Wed Apr 29 14:06:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 8:11 PM, Jakub Sitnicki wrote:
> This series enables BPF programs to fetch sockets from SOCKMAP/SOCKHASH by
> doing a map lookup, as proposed during virtual BPF conference.
> 
> Patch 1 description covers changes on verifier side needed to make it work.
> 
> Fetched socket can be inspected or passed to helpers such as bpf_sk_assign,
> which is demonstrated by the test updated in patch 3.
> 
> Thanks,
> Jakub
> 
> Jakub Sitnicki (3):
>    bpf: Allow bpf_map_lookup_elem for SOCKMAP and SOCKHASH
>    selftests/bpf: Test that lookup on SOCKMAP/SOCKHASH is allowed
>    selftests/bpf: Use SOCKMAP for server sockets in bpf_sk_assign test
> 
>   kernel/bpf/verifier.c                         | 45 +++++++---
>   net/core/filter.c                             |  4 +
>   net/core/sock_map.c                           | 18 +++-
>   tools/testing/selftests/bpf/Makefile          |  2 +-
>   .../selftests/bpf/prog_tests/sk_assign.c      | 21 ++++-
>   .../selftests/bpf/progs/test_sk_assign.c      | 82 ++++++++-----------
>   .../bpf/verifier/prevent_map_lookup.c         | 30 -------
>   tools/testing/selftests/bpf/verifier/sock.c   | 70 ++++++++++++++++
>   8 files changed, 178 insertions(+), 94 deletions(-)
> 

Applied, thanks!
