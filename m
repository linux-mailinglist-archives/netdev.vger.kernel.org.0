Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1396C69EFF
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 00:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbfGOWhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 18:37:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:36690 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731014AbfGOWhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 18:37:21 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9MB-0001y7-CZ; Tue, 16 Jul 2019 00:22:03 +0200
Received: from [99.0.85.34] (helo=localhost.localdomain)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9MB-00025f-0Y; Tue, 16 Jul 2019 00:22:03 +0200
Subject: Re: [PATCH bpf 0/5] bpf: allow wide (u64) aligned loads for some
 fields of bpf_sock_addr
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, Yonghong Song <yhs@fb.com>
References: <20190715163956.204061-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a027661f-462b-51c0-a71f-a937eecf4317@iogearbox.net>
Date:   Tue, 16 Jul 2019 00:21:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190715163956.204061-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25511/Mon Jul 15 10:10:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/19 6:39 PM, Stanislav Fomichev wrote:
> When fixing selftests by adding support for wide stores, Yonghong
> reported that he had seen some examples where clang generates
> single u64 loads for two adjacent u32s as well:
> http://lore.kernel.org/netdev/a66c937f-94c0-eaf8-5b37-8587d66c0c62@fb.com
> 
> Let's support aligned u64 reads for some bpf_sock_addr fields
> as well.
> 
> (This can probably wait for bpf-next, I'll defer to Younhong and the
> maintainers.)
> 
> Cc: Yonghong Song <yhs@fb.com>
> 
> Stanislav Fomichev (5):
>   bpf: rename bpf_ctx_wide_store_ok to bpf_ctx_wide_access_ok
>   bpf: allow wide aligned loads for bpf_sock_addr user_ip6 and
>     msg_src_ip6
>   selftests/bpf: rename verifier/wide_store.c to verifier/wide_access.c
>   selftests/bpf: add selftests for wide loads
>   bpf: sync bpf.h to tools/
> 
>  include/linux/filter.h                        |  2 +-
>  include/uapi/linux/bpf.h                      |  4 +-
>  net/core/filter.c                             | 24 ++++--
>  tools/include/uapi/linux/bpf.h                |  4 +-
>  .../selftests/bpf/verifier/wide_access.c      | 73 +++++++++++++++++++
>  .../selftests/bpf/verifier/wide_store.c       | 36 ---------
>  6 files changed, 95 insertions(+), 48 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/wide_access.c
>  delete mode 100644 tools/testing/selftests/bpf/verifier/wide_store.c
> 

Applied, thanks!
