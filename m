Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC7A2D6BF2
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390562AbgLJXbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:31:46 -0500
Received: from www62.your-server.de ([213.133.104.62]:34666 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728530AbgLJXb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:31:26 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1knVOP-0004ne-6Q; Fri, 11 Dec 2020 00:30:37 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1knVOO-000W7D-D8; Fri, 11 Dec 2020 00:30:37 +0100
Subject: Re: [PATCH bpf-next v2] samples/bpf: fix possible hang in xdpsock
 with multiple threads
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com
References: <20201210163407.22066-1-magnus.karlsson@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d476d856-6d42-ca7b-54da-cd2219952854@iogearbox.net>
Date:   Fri, 11 Dec 2020 00:30:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201210163407.22066-1-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26014/Thu Dec 10 15:21:42 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/20 5:34 PM, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a possible hang in xdpsock that can occur when using multiple
> threads. In this case, one or more of the threads might get stuck in
> the while-loop in tx_only after the user has signaled the main thread
> to stop execution. In this case, no more Tx packets will be sent, so a
> thread might get stuck in the aforementioned while-loop. Fix this by
> introducing a test inside the while-loop to check if the benchmark has
> been terminated. If so, return from the function.
> 
> Fixes: cd9e72b6f210 ("samples/bpf: xdpsock: Add option to specify batch size")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Applied, thanks!
