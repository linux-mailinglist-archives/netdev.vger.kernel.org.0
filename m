Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B171985FE
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgC3VFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:05:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:41952 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728317AbgC3VFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:05:09 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jJ1ai-0000Qu-T2; Mon, 30 Mar 2020 23:05:04 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jJ1ai-0002yF-MF; Mon, 30 Mar 2020 23:05:04 +0200
Subject: Re: [PATCH net-next] bpf: tcp: Fix unused-function warnings
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>
References: <20200330074909.174753-1-saeedm@mellanox.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <78e91a32-a329-122d-1fcf-25d2a026180d@iogearbox.net>
Date:   Mon, 30 Mar 2020 23:05:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200330074909.174753-1-saeedm@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25767/Mon Mar 30 15:08:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/20 9:49 AM, Saeed Mahameed wrote:
> tcp_bpf_sendpage, tcp_bpf_sendmsg, tcp_bpf_send_verdict and
> tcp_bpf_stream_read are only used when CONFIG_BPF_STREAM_PARSER is ON,
> make sure they are defined under this flag as well.
> 
> Fixed compiler warnings:
> 
> net/ipv4/tcp_bpf.c:483:12:
> warning: ‘tcp_bpf_sendpage’ defined but not used [-Wunused-function]
>   static int tcp_bpf_sendpage(struct sock *sk, struct page *page, ...
>              ^~~~~~~~~~~~~~~~
> net/ipv4/tcp_bpf.c:395:12:
> warning: ‘tcp_bpf_sendmsg’ defined but not used [-Wunused-function]
>   static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr, ...
>              ^~~~~~~~~~~~~~~
> net/ipv4/tcp_bpf.c:13:13:
> warning: ‘tcp_bpf_stream_read’ defined but not used [-Wunused-function]
>   static bool tcp_bpf_stream_read(const struct sock *sk)
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Already fixed here, PR for bpf-next will go out today:

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=a26527981af2988ae0f17f6d633848c019929e38

Thanks,
Daniel
