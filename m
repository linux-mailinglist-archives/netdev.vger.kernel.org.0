Return-Path: <netdev+bounces-9227-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F243A72815F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA2C71C20EDE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B2F12B73;
	Thu,  8 Jun 2023 13:30:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1165947B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:30:10 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED043E4A;
	Thu,  8 Jun 2023 06:30:07 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QcQ3n4m2VzLqRV;
	Thu,  8 Jun 2023 21:27:01 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 8 Jun
 2023 21:30:04 +0800
Subject: Re: [PATCH net v2] net: renesas: rswitch: Fix timestamp feature after
 all descriptors are used
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>, "s.shtylyov@omp.ru"
	<s.shtylyov@omp.ru>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
References: <20230607070141.1795982-1-yoshihiro.shimoda.uh@renesas.com>
 <1df24847-6523-12df-2cba-f51412463347@huawei.com>
 <TYBPR01MB5341D374AC1DE6CFEE237647D850A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <TYBPR01MB53412B2656A2B4756258042BD850A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>,
	Phong Hoang <phong.hoang.wz@renesas.com>
From: Hao Lan <lanhao@huawei.com>
Message-ID: <08006a4c-0627-9779-2260-a7e10dda454e@huawei.com>
Date: Thu, 8 Jun 2023 21:30:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <TYBPR01MB53412B2656A2B4756258042BD850A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/8 8:57, Yoshihiro Shimoda wrote:
> Hi again,
> 
>> From: Yoshihiro Shimoda, Sent: Thursday, June 8, 2023 9:21 AM
>>
>> Hi Hao,
>>
>>> From: Hao Lan, Sent: Wednesday, June 7, 2023 8:28 PM
>>> Hello Yoshihiro Shimoda，
>>>
>>> Does your function set the last descriptor to hardware on initialization, but not at other times?
>>
>> The last descriptor initialization is needed at the first time. So, after the initialization,
>> the last setting will not run anymore.
>>
>>> I think rswitch_gwca_ts_queue_fill should be implemented in a separate function,
>>> not use the 'last' distinguish the last descriptor.
>>
>> I got it. I'll modify this patch on v3.
>>
>>> But if it should be setting every cycle, I think rswitch_gwca_queue_ext_ts_fill should
>>> check if the descriptor is the last in the queue and set the LINKFIX flag.
>>
>> Thank you for the comment. The last descriptor should not be setting every cycle.
>> To implement the code for consistency, I think that I should add rswitch_tsdesc_init()
>> rswitch_gwca_queue_format() like rswitch_txdmac_init() and rswitch_gwca_queue_format()
> 
> About ts_queue, it is similar with linkfix, not txdmac. So, now I'm thinking that modifying
> the rswitch_gwca_ts_queue_alloc() is suitable.
> 
> Best regards,
> Yoshihiro Shimoda
> 

Reviewed-by: Hao Lan <lanhao@huawei.com>

