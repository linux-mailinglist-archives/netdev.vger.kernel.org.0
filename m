Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA41E17D6
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389480AbgEYWTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:19:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:51914 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388085AbgEYWTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 18:19:34 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdLRS-0002KU-6Y; Tue, 26 May 2020 00:19:30 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdLRR-0009Lt-Sl; Tue, 26 May 2020 00:19:29 +0200
Subject: Re: [PATCH bpf] xsk: add overflow check for u64 division, stored into
 u32
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com,
        =?UTF-8?Q?Minh_B=c3=b9i_Quang?= <minhquangbui99@gmail.com>
References: <20200525080400.13195-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c7c1f29e-f245-ac91-1325-1ed2faa7e3ef@iogearbox.net>
Date:   Tue, 26 May 2020 00:19:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200525080400.13195-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25823/Mon May 25 14:23:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/25/20 10:03 AM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The npgs member of struct xdp_umem is an u32 entity, and stores the
> number of pages the UMEM consumes. The calculation of npgs
> 
>    npgs = size / PAGE_SIZE
> 
> can overflow.
> 
> To avoid overflow scenarios, the division is now first stored in a
> u64, and the result is verified to fit into 32b.
> 
> An alternative would be storing the npgs as a u64, however, this
> wastes memory and is an unrealisticly large packet area.
> 
> Link: https://lore.kernel.org/bpf/CACtPs=GGvV-_Yj6rbpzTVnopgi5nhMoCcTkSkYrJHGQHJWFZMQ@mail.gmail.com/
> Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
> Reported-by: "Minh Bùi Quang" <minhquangbui99@gmail.com>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Applied, thanks!
