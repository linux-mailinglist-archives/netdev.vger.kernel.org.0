Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DA139480A
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhE1UpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:45:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:37180 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhE1UpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 16:45:19 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmizB-000G7u-UB; Fri, 28 May 2021 22:21:38 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmizB-000WbL-Kt; Fri, 28 May 2021 22:21:37 +0200
Subject: Re: [PATCH][next] bpf: devmap: remove redundant assignment of
 variable drops
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Colin King <colin.king@canonical.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210527143637.795393-1-colin.king@canonical.com>
 <20210527145549.GA7570@ranger.igk.intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <70c6e7d3-7faf-c4e7-3ae5-78f9a8e4c2b3@iogearbox.net>
Date:   Fri, 28 May 2021 22:21:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210527145549.GA7570@ranger.igk.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26184/Fri May 28 13:05:50 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/21 4:55 PM, Maciej Fijalkowski wrote:
> On Thu, May 27, 2021 at 03:36:37PM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The variable drops is being assigned a value that is never
>> read, it is being updated later on. The assignment is redundant and
>> can be removed.
> 
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> Would help if you would have CCed me given the fact that hour ago I
> confirmed that it could be removed :p but no big deal.

Thanks guys, fyi, took in this one for bpf-next [0], since more unneeded
code removed.

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=e8e0f0f484780d7b90a63ea50020ac4bb027178d

>> Addresses-Coverity: ("Unused value")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>   kernel/bpf/devmap.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index f9148daab0e3..fe3873b5d13d 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -388,8 +388,6 @@ static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>>   		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
>>   		if (!to_send)
>>   			goto out;
>> -
>> -		drops = cnt - to_send;
>>   	}
>>   
>>   	sent = dev->netdev_ops->ndo_xdp_xmit(dev, to_send, bq->q, flags);
>> -- 
>> 2.31.1
>>

