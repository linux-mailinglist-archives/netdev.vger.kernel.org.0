Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08C5389AC4
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 03:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhETBK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 21:10:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4754 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhETBK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 21:10:28 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fls3z4BpszpfTK;
        Thu, 20 May 2021 09:05:35 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 09:09:05 +0800
Received: from [127.0.0.1] (10.174.177.72) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 20 May
 2021 09:09:05 +0800
Subject: Re: [PATCH 1/1] mISDN: Mark local variable 'incomplete' as
 __maybe_unused in dsp_pipeline_build()
To:     Leon Romanovsky <leon@kernel.org>
CC:     Karsten Keil <isdn@linux-pingi.de>, netdev <netdev@vger.kernel.org>
References: <20210519125352.7991-1-thunder.leizhen@huawei.com>
 <YKUyqhva+2UQ44Ly@unreal>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <7f462ad9-93b5-9597-664f-d52d252eed01@huawei.com>
Date:   Thu, 20 May 2021 09:09:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YKUyqhva+2UQ44Ly@unreal>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/5/19 23:45, Leon Romanovsky wrote:
> On Wed, May 19, 2021 at 08:53:52PM +0800, Zhen Lei wrote:
>> GCC reports the following warning with W=1:
>>
>> drivers/isdn/mISDN/dsp_pipeline.c:221:6: warning:
>>  variable 'incomplete' set but not used [-Wunused-but-set-variable]
>>   221 |  int incomplete = 0, found = 0;
>>       |      ^~~~~~~~~~
>>
>> This variable is used only when macro PIPELINE_DEBUG is defined.
> 
> That define is commented 13 years ago and can be seen as a dead code
> that should be removed.

OK, I will remove it in V2. Actually, every time incomplete=1, a KERN_ERR message
is printed in advance. The only new information is the 'cfg'.

> 
> Thanks
> 
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>> ---
>>  drivers/isdn/mISDN/dsp_pipeline.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
>> index 40588692cec7..6a31f6879da8 100644
>> --- a/drivers/isdn/mISDN/dsp_pipeline.c
>> +++ b/drivers/isdn/mISDN/dsp_pipeline.c
>> @@ -218,7 +218,7 @@ void dsp_pipeline_destroy(struct dsp_pipeline *pipeline)
>>  
>>  int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
>>  {
>> -	int incomplete = 0, found = 0;
>> +	int __maybe_unused incomplete = 0, found = 0;
>>  	char *dup, *tok, *name, *args;
>>  	struct dsp_element_entry *entry, *n;
>>  	struct dsp_pipeline_entry *pipeline_entry;
>> -- 
>> 2.25.1
>>
>>
> 
> .
> 

