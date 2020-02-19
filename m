Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34EAF164C08
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 18:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgBSRgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 12:36:15 -0500
Received: from www62.your-server.de ([213.133.104.62]:52472 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgBSRgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 12:36:14 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4TGe-0000ez-Re; Wed, 19 Feb 2020 18:36:12 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4TGe-000BvG-Hi; Wed, 19 Feb 2020 18:36:12 +0100
Subject: Re: [PATCH bpf-next 0/3] sockmap/ktls: Simplify how we restore
 sk_prot callbacks
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
References: <20200217121530.754315-1-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7d998c5a-18cb-bbe7-cc85-460efb32e9de@iogearbox.net>
Date:   Wed, 19 Feb 2020 18:36:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200217121530.754315-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25728/Wed Feb 19 15:06:20 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/20 1:15 PM, Jakub Sitnicki wrote:
> This series has been split out from "Extend SOCKMAP to store listening
> sockets" [0]. I think it stands on its own, and makes the latter series
> smaller, which will make the review easier, hopefully.
> 
> The essence is that we don't need to do a complicated dance in
> sk_psock_restore_proto, if we agree that the contract with tcp_update_ulp
> is to restore callbacks even when the socket doesn't use ULP. This is what
> tcp_update_ulp currently does, and we just make use of it.
> 
> Series is accompanied by a test for a particularly tricky case of restoring
> callbacks when we have both sockmap and tls callbacks configured in
> sk->sk_prot.
> 
> [0] https://lore.kernel.org/bpf/20200127131057.150941-1-jakub@cloudflare.com/
> 
> 
> Jakub Sitnicki (3):
>    bpf, sk_msg: Let ULP restore sk_proto and write_space callback
>    bpf, sk_msg: Don't clear saved sock proto on restore
>    selftests/bpf: Test unhashing kTLS socket after removing from map
> 
>   include/linux/skmsg.h                         |  17 +--
>   .../selftests/bpf/prog_tests/sockmap_ktls.c   | 123 ++++++++++++++++++
>   2 files changed, 124 insertions(+), 16 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
> 

Applied, thanks!
