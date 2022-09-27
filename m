Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403555EB89B
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiI0DWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiI0DVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:21:20 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666B48C44A;
        Mon, 26 Sep 2022 20:21:15 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mc4Y719FGz1P6sy;
        Tue, 27 Sep 2022 11:16:59 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 11:21:13 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 11:21:12 +0800
Subject: Re: [PATCH net-next 00/14] redefine some macros of feature abilities
 judgement
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <lanhao@huawei.com>
References: <20220924023024.14219-1-huangguangbin2@huawei.com>
 <Yy7pjTX8VLLIiA0G@unreal> <77050062-93b5-7488-a427-815f4c631b32@huawei.com>
 <20220926101135.26382c0c@kernel.org>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <f3fedfe4-da32-8f56-000a-7f441a303ea0@huawei.com>
Date:   Tue, 27 Sep 2022 11:21:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20220926101135.26382c0c@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/27 1:11, Jakub Kicinski wrote:
> On Mon, 26 Sep 2022 20:56:26 +0800 huangguangbin (A) wrote:
>> On 2022/9/24 19:27, Leon Romanovsky wrote:
>>> On Sat, Sep 24, 2022 at 10:30:10AM +0800, Guangbin Huang wrote:
>>>> The macros hnae3_dev_XXX_supported just can be used in hclge layer, but
>>>> hns3_enet layer may need to use, so this serial redefine these macros.
>>>
>>> IMHO, you shouldn't add new obfuscated code, but delete it.
>>>
>>> Jakub,
>>>
>>> The more drivers authors will obfuscate in-kernel primitives and reinvent
>>> their own names, macros e.t.c, the less external reviewers you will be able
>>> to attract.
>>>
>>> IMHO, netdev should have more active position do not allow obfuscated code.
>>>
>>> Thanks
>>>    
>>
>> Hi, Leon
>> I'm sorry, I can not get your point. Can you explain in more detail?
>> Do you mean the name "macro" should not be used?
> 
> He is saying that you should try to remove those macros rather than
> touch them up. The macros may seem obvious to people working on the
> driver but to upstream reviewers any local conventions obfuscate the
> code and require looking up definitions.
> 
> For example the first patch is better off as:
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> index 0179fc288f5f..449d496b824b 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> @@ -107,9 +107,6 @@ enum HNAE3_DEV_CAP_BITS {
>   #define hnae3_ae_dev_gro_supported(ae_dev) \
>   		test_bit(HNAE3_DEV_SUPPORT_GRO_B, (ae_dev)->caps)
>   
> -#define hnae3_dev_fec_supported(hdev) \
> -	test_bit(HNAE3_DEV_SUPPORT_FEC_B, (hdev)->ae_dev->caps)
> -
>   #define hnae3_dev_udp_gso_supported(hdev) \
>   	test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, (hdev)->ae_dev->caps)
>   
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> index 6962a9d69cf8..ded92f7dbd79 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> @@ -1179,7 +1179,7 @@ static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
>   	hclge_convert_setting_sr(speed_ability, mac->supported);
>   	hclge_convert_setting_lr(speed_ability, mac->supported);
>   	hclge_convert_setting_cr(speed_ability, mac->supported);
> -	if (hnae3_dev_fec_supported(hdev))
> +	if (test_bit(HNAE3_DEV_SUPPORT_FEC_B, hdev->caps))
>   		hclge_convert_setting_fec(mac);
>   
>   	if (hnae3_dev_pause_supported(hdev))
> @@ -1195,7 +1195,7 @@ static void hclge_parse_backplane_link_mode(struct hclge_dev *hdev,
>   	struct hclge_mac *mac = &hdev->hw.mac;
>   
>   	hclge_convert_setting_kr(speed_ability, mac->supported);
> -	if (hnae3_dev_fec_supported(hdev))
> +	if (test_bit(HNAE3_DEV_SUPPORT_FEC_B, hdev->caps))
>   		hclge_convert_setting_fec(mac);
>   
>   	if (hnae3_dev_pause_supported(hdev))
> @@ -3232,7 +3232,7 @@ static void hclge_update_advertising(struct hclge_dev *hdev)
>   static void hclge_update_port_capability(struct hclge_dev *hdev,
>   					 struct hclge_mac *mac)
>   {
> -	if (hnae3_dev_fec_supported(hdev))
> +	if (test_bit(HNAE3_DEV_SUPPORT_FEC_B, hdev->caps))
>   		hclge_convert_setting_fec(mac);
>   
>   	/* firmware can not identify back plane type, the media type
> .
> 
Ok, I see, thanks!
