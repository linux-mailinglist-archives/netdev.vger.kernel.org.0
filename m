Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61445496319
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349736AbiAUQsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:48:43 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:33739 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349221AbiAUQsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:48:40 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V2SWIhF_1642783712;
Received: from 30.39.181.79(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0V2SWIhF_1642783712)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 22 Jan 2022 00:48:33 +0800
Message-ID: <0b73df73-d5e8-32a8-1495-63596b256392@linux.alibaba.com>
Date:   Sat, 22 Jan 2022 00:48:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
 <YelwGOBhjBFsVPxA@TonyMac-Alibaba>
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
In-Reply-To: <YelwGOBhjBFsVPxA@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/1/20 22:22, Tony Lu wrote:>>  #include "smc_ib.h"
>>  
>> -#define SMC_RMBS_PER_LGR_MAX	255	/* max. # of RMBs per link group */
>> +#define SMC_RMBS_PER_LGR_MAX	32	/* max. # of RMBs per link group. Correspondingly,
>> +					 * SMC_WR_BUF_CNT should not be less than 2 *
>> +					 * SMC_RMBS_PER_LGR_MAX, since every connection at
>> +					 * least has two rq/sq credits in average, otherwise
>> +					 * may result in waiting for credits in sending process.
>> +					 */
> 
> This gives a fixed limit for per link group connections. Using tunable
> knobs to control this for different workload would be better. It also
> reduce the completion of free slots in the same link group and link.
> 

It is a good idea, but I find a patch (https://lore.kernel.org/linux-s390/20220114054852.38058-7-tonylu@linux.alibaba.com/) where you have already done this idea.
