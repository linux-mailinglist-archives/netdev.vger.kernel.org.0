Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2BE42D263
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 08:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhJNG0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 02:26:35 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:25135 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhJNG0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 02:26:15 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HVK7n5qdYz1DHYG;
        Thu, 14 Oct 2021 14:22:29 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 14:24:08 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 14 Oct
 2021 14:24:06 +0800
Subject: Re: [PATCH V3 net-next 3/6] ethtool: add support to set/get rx buf
 len via ethtool
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <chris.snook@gmail.com>, <ulli.kroll@googlemail.com>,
        <linus.walleij@linaro.org>, <jeroendb@google.com>,
        <csully@google.com>, <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
References: <20211012134127.11761-1-huangguangbin2@huawei.com>
 <20211012134127.11761-4-huangguangbin2@huawei.com>
 <20211012112624.641ed3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <a2d3a1b7-5574-208a-e62e-24b378f258b7@huawei.com>
Date:   Thu, 14 Oct 2021 14:24:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20211012112624.641ed3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/13 2:26, Jakub Kicinski wrote:
> On Tue, 12 Oct 2021 21:41:24 +0800 Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> Add support to set rx buf len via ethtool -G parameter and get
>> rx buf len via ethtool -g parameter.
>>
>> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> 
>> +  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
>>     ====================================  ======  ==========================
> 
> Does the documentation build without warnings?
> 
Hi Jakub, there is no warning when we build documentation. It seems that the third
column needs more '=' symbol, we add it in next version.

>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>> index 266e95e4fb33..83544186cbb5 100644
>> --- a/include/uapi/linux/ethtool.h
>> +++ b/include/uapi/linux/ethtool.h
>> @@ -535,6 +535,14 @@ struct ethtool_ringparam {
>>   	__u32	tx_pending;
>>   };
>>   
>> +/**
>> + * struct ethtool_ringparam_ext - RX/TX ring configuration
>> + * @rx_buf_len: Current length of buffers on the rx ring.
>> + */
>> +struct ethtool_ringparam_ext {
>> +	__u32	rx_buf_len;
>> +};
> 
> This can be moved to include/linux/ethtool.h, user space does not need
> to know about this structure.
> 
Ok.

>> +	if (ringparam_ext.rx_buf_len != 0 &&
>> +	    !(ops->supported_ring_params & ETHTOOL_RING_USE_RX_BUF_LEN)) {
>> +		ret = -EOPNOTSUPP;
>> +		NL_SET_ERR_MSG_ATTR(info->extack,
>> +				    tb[ETHTOOL_A_RINGS_RX_BUF_LEN],
>> +				    "setting not supported rx buf len");
> 
> "setting rx buf len not supported" sounds better
> 
Ok.

>> +		goto out_ops;
>> +	}
>> +
>>   	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
>>   	if (ret < 0)
>>   		goto out_ops;
> 
> .
> 
