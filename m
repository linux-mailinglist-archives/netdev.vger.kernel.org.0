Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217775A7AA
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfF1Xdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:33:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:34294 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfF1Xdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:33:44 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hh0NC-0001aQ-MF; Sat, 29 Jun 2019 01:33:42 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hh0NC-0007wq-9v; Sat, 29 Jun 2019 01:33:42 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: fix -Wstrict-aliasing in
 test_sockopt_sk.c
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org
References: <20190628011233.63680-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e676fc63-ec68-d6ed-8d66-5662b9abde49@iogearbox.net>
Date:   Sat, 29 Jun 2019 01:33:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190628011233.63680-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25494/Fri Jun 28 10:03:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/28/2019 03:12 AM, Stanislav Fomichev wrote:
> Let's use union with u8[4] and u32 members for sockopt buffer,
> that should fix any possible aliasing issues.
> 
> test_sockopt_sk.c: In function ‘getsetsockopt’:
> test_sockopt_sk.c:115:2: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
>   if (*(__u32 *)buf != 0x55AA*2) {
>   ^~
> test_sockopt_sk.c:116:3: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
>    log_err("Unexpected getsockopt(SO_SNDBUF) 0x%x != 0x55AA*2",
>    ^~~~~~~
> 
> Fixes: 8a027dc0d8f5 ("selftests/bpf: add sockopt test that exercises sk helpers")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied, thanks!
