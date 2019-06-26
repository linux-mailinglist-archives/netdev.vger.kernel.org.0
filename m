Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294A056BF5
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfFZOap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:30:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:44192 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbfFZOap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:30:45 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8wV-0000Sf-5y; Wed, 26 Jun 2019 16:30:35 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8wU-000Rp6-U7; Wed, 26 Jun 2019 16:30:34 +0200
Subject: Re: [PATCH] xsk: Properly terminate assignment in
 xskq_produce_flush_desc
To:     Nathan Chancellor <natechancellor@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Huckleberry <nhuck@google.com>
References: <20190625182352.13918-1-natechancellor@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <253f2fcd-f62d-90e1-2963-c8e5cdda4726@iogearbox.net>
Date:   Wed, 26 Jun 2019 16:30:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190625182352.13918-1-natechancellor@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25492/Wed Jun 26 10:00:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/25/2019 08:23 PM, Nathan Chancellor wrote:
> Clang warns:
> 
> In file included from net/xdp/xsk_queue.c:10:
> net/xdp/xsk_queue.h:292:2: warning: expression result unused
> [-Wunused-value]
>         WRITE_ONCE(q->ring->producer, q->prod_tail);
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/compiler.h:284:6: note: expanded from macro 'WRITE_ONCE'
>         __u.__val;                                      \
>         ~~~ ^~~~~
> 1 warning generated.
> 
> The q->prod_tail assignment has a comma at the end, not a semi-colon.
> Fix that so clang no longer warns and everything works as expected.
> 
> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/544
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thanks!
