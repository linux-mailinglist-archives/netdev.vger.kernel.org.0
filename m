Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41A02929A2
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 16:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgJSOke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 10:40:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:34034 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728877AbgJSOkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 10:40:33 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUWKr-00070m-CY; Mon, 19 Oct 2020 16:40:29 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUWKr-000BCD-6q; Mon, 19 Oct 2020 16:40:29 +0200
Subject: Re: [PATCH RFC bpf-next 2/2] selftests: Update test_tc_neigh to use
 the modified bpf_redirect_neigh()
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160277680746.157904.8726318184090980429.stgit@toke.dk>
 <160277680973.157904.15451524562795164056.stgit@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <684a0bd5-b131-c620-ed5e-d1ea7d151ae1@iogearbox.net>
Date:   Mon, 19 Oct 2020 16:40:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160277680973.157904.15451524562795164056.stgit@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25962/Mon Oct 19 15:57:02 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/20 5:46 PM, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> This updates the test_tc_neigh selftest to use the new syntax of
> bpf_redirect_neigh(). To exercise the helper both with and without the
> optional parameter, one forwarding direction is changed to do a
> bpf_fib_lookup() followed by a call to bpf_redirect_neigh(), while the
> other direction is using the map-based ifindex lookup letting the redirect
> helper resolve the nexthop from the FIB.
> 
> This also fixes the test_tc_redirect.sh script to work on systems that have
> a consolidated dual-stack 'ping' binary instead of separate ping/ping6
> versions.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

I would prefer if you could not mix the two tests, meaning, one complete test
case is only with bpf_redirect_neigh(get_dev_ifindex(xxx), NULL, 0, 0) for both
directions, and another self-contained one is with fib lookup + bpf_redirect_neigh
with params, even if it means we duplicate test_tc_neigh.c slighly, but I think
that's fine for sake of test coverage.

Thanks,
Daniel
