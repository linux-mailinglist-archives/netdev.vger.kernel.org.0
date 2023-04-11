Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4A36DDEC1
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjDKPC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjDKPCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:02:22 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6DA59FC
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:02:12 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PwprC0nwYznb2B;
        Tue, 11 Apr 2023 22:58:35 +0800 (CST)
Received: from [10.174.178.165] (10.174.178.165) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 23:02:07 +0800
Message-ID: <de2f9d41-1793-ab3a-eaa4-5a01c8100672@huawei.com>
Date:   Tue, 11 Apr 2023 23:02:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next] net: davicom: Make davicom drivers not depends
 on DM9000
To:     Paolo Abeni <pabeni@redhat.com>,
        Wei Yongjun <weiyongjun@huaweicloud.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Joseph CHAMG <josright123@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nathan Huckleberry <nhuck@google.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
        Wells Lu <wellslutw@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230407094930.2633137-1-weiyongjun@huaweicloud.com>
 <5ca60e3606aa710ef3b98b759572fdd7bfd20c74.camel@redhat.com>
From:   Wei Yongjun <weiyongjun1@huawei.com>
In-Reply-To: <5ca60e3606aa710ef3b98b759572fdd7bfd20c74.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/4/11 21:26, Paolo Abeni wrote:
> On Fri, 2023-04-07 at 09:49 +0000, Wei Yongjun wrote:
>> From: Wei Yongjun <weiyongjun1@huawei.com>
>>
>> All davicom drivers build need CONFIG_DM9000 is set, but this dependence
>> is not correctly since dm9051 can be build as module without dm9000, switch
>> to using CONFIG_NET_VENDOR_DAVICOM instead.
>>
>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>> ---
>>  drivers/net/ethernet/Makefile | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
>> index 0d872d4efcd1..ee640885964e 100644
>> --- a/drivers/net/ethernet/Makefile
>> +++ b/drivers/net/ethernet/Makefile
>> @@ -32,7 +32,7 @@ obj-$(CONFIG_NET_VENDOR_CIRRUS) += cirrus/
>>  obj-$(CONFIG_NET_VENDOR_CISCO) += cisco/
>>  obj-$(CONFIG_NET_VENDOR_CORTINA) += cortina/
>>  obj-$(CONFIG_CX_ECAT) += ec_bhf.o
>> -obj-$(CONFIG_DM9000) += davicom/
>> +obj-$(CONFIG_NET_VENDOR_DAVICOM) += davicom/
>>  obj-$(CONFIG_DNET) += dnet.o
>>  obj-$(CONFIG_NET_VENDOR_DEC) += dec/
>>  obj-$(CONFIG_NET_VENDOR_DLINK) += dlink/
> 
> Can you repost this for -net, including a suitable Fixes tag, as
> suggested by Simon?
> 

Sure, will repost after testing base on net tree.

Regards,
Wei Yongjun

