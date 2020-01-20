Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0772014348B
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 00:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgATXvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 18:51:44 -0500
Received: from www62.your-server.de ([213.133.104.62]:39224 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgATXvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 18:51:44 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1itgSH-0007F0-5u; Tue, 21 Jan 2020 00:27:37 +0100
Received: from [178.197.248.27] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1itgSG-000IpE-R6; Tue, 21 Jan 2020 00:27:36 +0100
Subject: Re: [PATCH bpf-next] xsk: update rings for load-acquire/store-release
 semantics
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20200120092149.13775-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <28b2b6ba-7f43-6cab-9b3a-174fc71d5a62@iogearbox.net>
Date:   Tue, 21 Jan 2020 00:27:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200120092149.13775-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25701/Mon Jan 20 12:41:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/20 10:21 AM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Currently, the AF_XDP rings uses fences for the kernel-side
> produce/consume functions. By updating rings for
> load-acquire/store-release semantics, the full barrier (smp_mb()) on
> the consumer side can be replaced.
> 
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

If I'm not missing something from the ring update scheme, don't you also need
to adapt to STORE.rel ->producer with matching barrier in tools/lib/bpf/xsk.h ?

Btw, alternative model could also be 09d62154f613 ("tools, perf: add and use
optimized ring_buffer_{read_head, write_tail} helpers") for the kernel side
in order to get rid of the smp_mb() on x86.

Thanks,
Daniel
