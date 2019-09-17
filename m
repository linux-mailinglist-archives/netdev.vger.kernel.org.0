Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E573B45D1
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 05:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403931AbfIQDIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 23:08:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2277 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727097AbfIQDID (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 23:08:03 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E698E82D8048DD8737DE;
        Tue, 17 Sep 2019 11:08:01 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 17 Sep 2019
 11:07:58 +0800
Message-ID: <5D804E0D.2070707@huawei.com>
Date:   Tue, 17 Sep 2019 11:07:57 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <davem@davemloft.net>, <kvalo@codeaurora.org>,
        <pkshih@realtek.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] nfp: Drop unnecessary continue in nfp_net_pf_alloc_vnics
References: <1567568784-9669-1-git-send-email-zhongjiang@huawei.com> <1567568784-9669-3-git-send-email-zhongjiang@huawei.com> <20190916194502.0c014667@cakuba.netronome.com>
In-Reply-To: <20190916194502.0c014667@cakuba.netronome.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/17 10:45, Jakub Kicinski wrote:
> On Wed, 4 Sep 2019 11:46:23 +0800, zhong jiang wrote:
>> Continue is not needed at the bottom of a loop.
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>> ---
>>  drivers/net/ethernet/netronome/nfp/nfp_net_main.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
>> index 986464d..68db47d 100644
>> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
>> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
>> @@ -205,10 +205,8 @@ static void nfp_net_pf_free_vnics(struct nfp_pf *pf)
>>  		ctrl_bar += NFP_PF_CSR_SLICE_SIZE;
>>  
>>  		/* Kill the vNIC if app init marked it as invalid */
>> -		if (nn->port && nn->port->type == NFP_PORT_INVALID) {
>> +		if (nn->port && nn->port->type == NFP_PORT_INVALID)
>>  			nfp_net_pf_free_vnic(pf, nn);
>> -			continue;
>> -		}
> Ugh, I already nack at least one patch like this, this continue makes
> the _intent_ of the code more clear, the compiler will ignore it anyway.
Thanks,   I miss that information you object to above modification.  

Sincerely,
zhong jiang
> I guess there's no use in fighting the bots..
>
>>  	}
>>  
>>  	if (list_empty(&pf->vnics))
>
> .
>


