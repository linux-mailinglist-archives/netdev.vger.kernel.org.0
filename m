Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFFD30E9D2
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbhBDCCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:02:19 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:4605 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbhBDCCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 21:02:18 -0500
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4DWMFh3x8BzY5Hj;
        Thu,  4 Feb 2021 10:00:24 +0800 (CST)
Received: from [127.0.0.1] (10.69.26.252) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Thu, 4 Feb
 2021 10:01:35 +0800
Subject: Re: [PATCH net-next 4/7] net: hns3: add support for obtaining the
 maximum frame length
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Yufeng Mo <moyufeng@huawei.com>
References: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
 <1612269593-18691-5-git-send-email-tanhuazhong@huawei.com>
 <20210203165652.25000212@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <a3f8a43c-f4bf-1906-9bf3-bda23e921753@huawei.com>
Date:   Thu, 4 Feb 2021 10:01:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210203165652.25000212@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme715-chm.china.huawei.com (10.1.199.111) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/4 8:56, Jakub Kicinski wrote:
> On Tue, 2 Feb 2021 20:39:50 +0800 Huazhong Tan wrote:
>> From: Yufeng Mo <moyufeng@huawei.com>
>>
>> Since the newer hardware may supports different frame size,
>> so add support to obtain the capability from the firmware
>> instead of the fixed value.
>>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> @@ -9659,7 +9663,7 @@ int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu)
>>   	/* HW supprt 2 layer vlan */
>>   	max_frm_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN;
>>   	if (max_frm_size < HCLGE_MAC_MIN_FRAME ||
>> -	    max_frm_size > HCLGE_MAC_MAX_FRAME)
>> +	    max_frm_size > hdev->ae_dev->dev_specs.max_pkt_len)
>>   		return -EINVAL;
>>   
>>   	max_frm_size = max(max_frm_size, HCLGE_MAC_DEFAULT_FRAME);
> Don't you have to adjust netdev->max_mtu as well when device specifies
> max_pkt_len different than HCLGE_MAC_MAX_FRAME?

netdev->max_mtu should be adjusted as well, will fix it.

thanks.

> .

