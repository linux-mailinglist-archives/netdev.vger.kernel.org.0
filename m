Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA23549E2BC
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 13:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiA0Mmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 07:42:38 -0500
Received: from foss.arm.com ([217.140.110.172]:59462 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241308AbiA0Mmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 07:42:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D54661063;
        Thu, 27 Jan 2022 04:42:37 -0800 (PST)
Received: from [10.57.68.47] (unknown [10.57.68.47])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA5D93F7D8;
        Thu, 27 Jan 2022 04:42:36 -0800 (PST)
Message-ID: <3f6df255-0a04-e630-e8cb-8407a704acb3@arm.com>
Date:   Thu, 27 Jan 2022 12:42:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next] nfp: nsp: Simplify array allocation
Content-Language: en-GB
To:     Simon Horman <simon.horman@corigine.com>
Cc:     kuba@kernel.org, davem@davemloft.net, oss-drivers@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <af578bd3eb471b9613bcba7f714cca7e297a4620.1643214385.git.robin.murphy@arm.com>
 <20220127090636.GA21279@corigine.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220127090636.GA21279@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-27 09:06, Simon Horman wrote:
> On Wed, Jan 26, 2022 at 04:30:33PM +0000, Robin Murphy wrote:
>> Prefer kcalloc() to kzalloc(array_size()) for allocating an array.
>>
>> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> 
> Hi Robin,
> 
> thanks for the cleanup.
> 
> One minor nit: I think "nfp: " would be a slightly more normal prefix
> than "nfp: nsp: ".

Ah, OK - from the git history it seemed about 50/50 one way or the 
other, so I guessed at the one that looked more specific to this 
particular file. I ran into this little anti-pattern in code I was 
working on, and this was the only other instance that a quick grep 
turned up so I figured I may as well fix it too.

> That notwithstanding,
> 
> Acked-by: Simon Horman <simon.horman@corigine.com>

Thanks!
Robin.

>> ---
>>   drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
>> index 10e7d8b21c46..730fea214b8a 100644
>> --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
>> +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
>> @@ -513,7 +513,7 @@ nfp_nsp_command_buf_dma_sg(struct nfp_nsp *nsp,
>>   	dma_size = BIT_ULL(dma_order);
>>   	nseg = DIV_ROUND_UP(max_size, chunk_size);
>>   
>> -	chunks = kzalloc(array_size(sizeof(*chunks), nseg), GFP_KERNEL);
>> +	chunks = kcalloc(nseg, sizeof(*chunks), GFP_KERNEL);
>>   	if (!chunks)
>>   		return -ENOMEM;
>>   
>> -- 
>> 2.28.0.dirty
>>
