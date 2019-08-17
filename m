Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A0291352
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfHQVbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:31:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:57222 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfHQVbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:31:24 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6IA-0001jI-5Z; Sat, 17 Aug 2019 23:31:18 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6IA-000Xhf-0F; Sat, 17 Aug 2019 23:31:18 +0200
Subject: Re: [bpf-next,v2] selftests/bpf: fix race in test_tcp_rtt test
To:     Petar Penkov <ppenkov.kernel@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
References: <20190816170825.22500-1-ppenkov.kernel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dc516c52-814c-1e14-fec3-9a3aeb562386@iogearbox.net>
Date:   Sat, 17 Aug 2019 23:31:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190816170825.22500-1-ppenkov.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25544/Sat Aug 17 10:24:01 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/19 7:08 PM, Petar Penkov wrote:
> From: Petar Penkov <ppenkov@google.com>
> 
> There is a race in this test between receiving the ACK for the
> single-byte packet sent in the test, and reading the values from the
> map.
> 
> This patch fixes this by having the client wait until there are no more
> unacknowledged packets.
> 
> Before:
> for i in {1..1000}; do ../net/in_netns.sh ./test_tcp_rtt; \
> done | grep -c PASSED
> < trimmed error messages >
> 993
> 
> After:
> for i in {1..10000}; do ../net/in_netns.sh ./test_tcp_rtt; \
> done | grep -c PASSED
> 10000
> 
> Fixes: b55873984dab ("selftests/bpf: test BPF_SOCK_OPS_RTT_CB")
> Signed-off-by: Petar Penkov <ppenkov@google.com>

Applied, thanks!
