Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE31484074
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbiADLDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:03:51 -0500
Received: from www62.your-server.de ([213.133.104.62]:51184 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiADLDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 06:03:51 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n4hbX-0003S5-IG; Tue, 04 Jan 2022 12:03:47 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1n4hbX-0004eX-7e; Tue, 04 Jan 2022 12:03:47 +0100
Subject: Re: [PATCH net] Revert "xsk: Do not sleep in poll() when need_wakeup
 set"
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org
References: <20220104095701.10661-1-xuanzhuo@linux.alibaba.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e935822c-b2f6-8c62-8af7-4ce6e32ed4c3@iogearbox.net>
Date:   Tue, 4 Jan 2022 12:03:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220104095701.10661-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26412/Tue Jan  4 10:29:43 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xuan,

On 1/4/22 10:57 AM, Xuan Zhuo wrote:
> This reverts commit bd0687c18e635b63233dc87f38058cd728802ab4.
> 
> When working with epoll, if the application encounters tx full, the
> application will enter epoll_wait and wait for tx to be awakened when
> there is room.
> 
> In the current situation, when tx is full pool->cached_need_wakeup may
> not be 0 (regardless of whether the driver supports wakeup, or whether
> the user uses XDP_USE_NEED_WAKEUP). The result is that if the user
> enters epoll_wait, because soock_poll_wait is not called, causing the
> user process to not be awakened.
> 
> Fixes: bd0687c18e63 ("xsk: Do not sleep in poll() when need_wakeup set")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

This is already reverted in net tree:

   https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=0706a78f31c4217ca144f630063ec9561a21548d

Thanks,
Daniel
