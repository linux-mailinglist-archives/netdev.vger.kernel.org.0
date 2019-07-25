Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4DF74357
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 04:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389200AbfGYCfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 22:35:06 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34154 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387933AbfGYCfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 22:35:06 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CA8F5D2401BEF7826A64;
        Thu, 25 Jul 2019 10:35:03 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 25 Jul 2019
 10:34:55 +0800
Subject: Re: [PATCH net-next 06/11] net: hns3: modify firmware version display
 format
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
 <1563938327-9865-7-git-send-email-tanhuazhong@huawei.com>
 <4c4ce27c9a9372340c0e2b0f654b3fb9cd85b3e4.camel@mellanox.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <95783289-9b3b-f085-876b-49815b07d595@huawei.com>
Date:   Thu, 25 Jul 2019 10:34:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <4c4ce27c9a9372340c0e2b0f654b3fb9cd85b3e4.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/25 2:34, Saeed Mahameed wrote:
> On Wed, 2019-07-24 at 11:18 +0800, Huazhong Tan wrote:
>> From: Yufeng Mo <moyufeng@huawei.com>
>>
>> This patch modifies firmware version display format in
>> hclge(vf)_cmd_init() and hns3_get_drvinfo(). Also, adds
>> some optimizations for firmware version display format.
>>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> Signed-off-by: Peng Li <lipeng321@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns3/hnae3.h              |  9
>> +++++++++
>>   drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c       | 15
>> +++++++++++++--
>>   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c   | 10
>> +++++++++-
>>   drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 11
>> +++++++++--
>>   4 files changed, 40 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> index 48c7b70..a4624db 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> @@ -179,6 +179,15 @@ struct hnae3_vector_info {
>>   #define HNAE3_RING_GL_RX 0
>>   #define HNAE3_RING_GL_TX 1
>>   
>> +#define HNAE3_FW_VERSION_BYTE3_SHIFT	24
>> +#define HNAE3_FW_VERSION_BYTE3_MASK	GENMASK(31, 24)
>> +#define HNAE3_FW_VERSION_BYTE2_SHIFT	16
>> +#define HNAE3_FW_VERSION_BYTE2_MASK	GENMASK(23, 16)
>> +#define HNAE3_FW_VERSION_BYTE1_SHIFT	8
>> +#define HNAE3_FW_VERSION_BYTE1_MASK	GENMASK(15, 8)
>> +#define HNAE3_FW_VERSION_BYTE0_SHIFT	0
>> +#define HNAE3_FW_VERSION_BYTE0_MASK	GENMASK(7, 0)
>> +
>>   struct hnae3_ring_chain_node {
>>   	struct hnae3_ring_chain_node *next;
>>   	u32 tqp_index;
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> index 5bff98a..e71c92b 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> @@ -527,6 +527,7 @@ static void hns3_get_drvinfo(struct net_device
>> *netdev,
>>   {
>>   	struct hns3_nic_priv *priv = netdev_priv(netdev);
>>   	struct hnae3_handle *h = priv->ae_handle;
>> +	u32 fw_version;
>>   
>>   	if (!h->ae_algo->ops->get_fw_version) {
>>   		netdev_err(netdev, "could not get fw version!\n");
>> @@ -545,8 +546,18 @@ static void hns3_get_drvinfo(struct net_device
>> *netdev,
>>   		sizeof(drvinfo->bus_info));
>>   	drvinfo->bus_info[ETHTOOL_BUSINFO_LEN - 1] = '\0';
>>   
>> -	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
>> "0x%08x",
>> -		 priv->ae_handle->ae_algo->ops->get_fw_version(h));
>> +	fw_version = priv->ae_handle->ae_algo->ops->get_fw_version(h);
>> +
>> +	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
>> +		 "%lu.%lu.%lu.%lu",
>> +		 hnae3_get_field(fw_version,
>> HNAE3_FW_VERSION_BYTE3_MASK,
>> +				 HNAE3_FW_VERSION_BYTE3_SHIFT),
>> +		 hnae3_get_field(fw_version,
>> HNAE3_FW_VERSION_BYTE2_MASK,
>> +				 HNAE3_FW_VERSION_BYTE2_SHIFT),
>> +		 hnae3_get_field(fw_version,
>> HNAE3_FW_VERSION_BYTE1_MASK,
>> +				 HNAE3_FW_VERSION_BYTE1_SHIFT),
>> +		 hnae3_get_field(fw_version,
>> HNAE3_FW_VERSION_BYTE0_MASK,
>> +				 HNAE3_FW_VERSION_BYTE0_SHIFT));
>>   }
>>   
>>   static u32 hns3_get_link(struct net_device *netdev)
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
>> b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
>> index 22f6acd..c2320bf 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
>> @@ -419,7 +419,15 @@ int hclge_cmd_init(struct hclge_dev *hdev)
>>   	}
>>   	hdev->fw_version = version;
>>   
>> -	dev_info(&hdev->pdev->dev, "The firmware version is %08x\n",
>> version);
>> +	pr_info_once("The firmware version is %lu.%lu.%lu.%lu\n",
>> +		     hnae3_get_field(version,
>> HNAE3_FW_VERSION_BYTE3_MASK,
>> +				     HNAE3_FW_VERSION_BYTE3_SHIFT),
>> +		     hnae3_get_field(version,
>> HNAE3_FW_VERSION_BYTE2_MASK,
>> +				     HNAE3_FW_VERSION_BYTE2_SHIFT),
>> +		     hnae3_get_field(version,
>> HNAE3_FW_VERSION_BYTE1_MASK,
>> +				     HNAE3_FW_VERSION_BYTE1_SHIFT),
>> +		     hnae3_get_field(version,
>> HNAE3_FW_VERSION_BYTE0_MASK,
>> +				     HNAE3_FW_VERSION_BYTE0_SHIFT));
>>   
> 
> Device name/string will not be printed now, what happens if i have
> multiple devices ? at least print the device name as it was before
>
Since on each board we only have one firmware, the firmware
version is same per device, and will not change when running.
So pr_info_once() looks good for this case.

BTW, maybe we should change below print in the end of
hclge_init_ae_dev(), use dev_info() instead of pr_info(),
then we can know that which device has already initialized.
I will send other patch to do that, is it acceptable for you?

"pr_info("%s driver initialization finished.\n", HCLGE_DRIVER_NAME);"

Thanks.

>>   	return 0;
>>   
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
>> b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
>> index 652b796..004125b 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
>> @@ -405,8 +405,15 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
>>   	}
>>   	hdev->fw_version = version;
>>   
>> -	dev_info(&hdev->pdev->dev, "The firmware version is %08x\n",
>> version);
>> -
>> +	pr_info_once("The firmware version is %lu.%lu.%lu.%lu\n",
>> +		     hnae3_get_field(version,
>> HNAE3_FW_VERSION_BYTE3_MASK,
>> +				     HNAE3_FW_VERSION_BYTE3_SHIFT),
>> +		     hnae3_get_field(version,
>> HNAE3_FW_VERSION_BYTE2_MASK,
>> +				     HNAE3_FW_VERSION_BYTE2_SHIFT),
>> +		     hnae3_get_field(version,
>> HNAE3_FW_VERSION_BYTE1_MASK,
>> +				     HNAE3_FW_VERSION_BYTE1_SHIFT),
>> +		     hnae3_get_field(version,
>> HNAE3_FW_VERSION_BYTE0_MASK,
>> +				     HNAE3_FW_VERSION_BYTE0_SHIFT));
>>   	return 0;
>>   
> 
> Same.
> 

Same
:)

