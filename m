Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FA6206276
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389671AbgFWVCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:02:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:44484 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392030AbgFWUjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:39:15 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnphK-0000bs-1x; Tue, 23 Jun 2020 22:39:14 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnphJ-000UCZ-Ph; Tue, 23 Jun 2020 22:39:13 +0200
Subject: Re: [PATCH v3 bpf-next 2/3] selftests/bpf: add variable-length data
 concatenation pattern test
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, john.fastabend@gmail.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200623032224.4020118-1-andriin@fb.com>
 <20200623032224.4020118-2-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7ed6ada5-2539-3090-0db7-0f65b67e4699@iogearbox.net>
Date:   Tue, 23 Jun 2020 22:39:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200623032224.4020118-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25852/Tue Jun 23 15:09:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Andrii,

On 6/23/20 5:22 AM, Andrii Nakryiko wrote:
> Add selftest that validates variable-length data reading and concatentation
> with one big shared data array. This is a common pattern in production use for
> monitoring and tracing applications, that potentially can read a lot of data,
> but overall read much less. Such pattern allows to determine precisely what
> amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Currently getting the below errors on these tests. My last clang/llvm git build
is on 4676cf444ea2 ("[Clang] Skip adding begin source location for PragmaLoopHint'd
loop when[...]"):

# ./test_progs -t varlen
test_varlen:PASS:skel_open 0 nsec
test_varlen:PASS:skel_attach 0 nsec
test_varlen:FAIL:check got 0 != exp 8
test_varlen:FAIL:check got 0 != exp 7
test_varlen:FAIL:check got 0 != exp 15
test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
test_varlen:FAIL:check got 0 != exp 7
test_varlen:FAIL:check got 0 != exp 15
test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
test_varlen:FAIL:check got 0 != exp 7
test_varlen:FAIL:check got 0 != exp 15
test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
test_varlen:FAIL:check got 0 != exp 7
test_varlen:FAIL:check got 0 != exp 15
test_varlen:FAIL:content_check doesn't match!
#87 varlen:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

# ./test_progs-no_alu32 -t varlen
Switching to flavor 'no_alu32' subdirectory...
test_varlen:PASS:skel_open 0 nsec
test_varlen:PASS:skel_attach 0 nsec
test_varlen:FAIL:check got 0 != exp 8
test_varlen:FAIL:check got 0 != exp 7
test_varlen:FAIL:check got 0 != exp 15
test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
test_varlen:FAIL:check got 0 != exp 7
test_varlen:FAIL:check got 0 != exp 15
test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
test_varlen:FAIL:check got 0 != exp 7
test_varlen:FAIL:check got 0 != exp 15
test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
test_varlen:FAIL:check got 0 != exp 7
test_varlen:FAIL:check got 0 != exp 15
test_varlen:FAIL:content_check doesn't match!
#87 varlen:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

Thanks,
Daniel
