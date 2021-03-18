Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FFA33FC87
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 02:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhCRBDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 21:03:10 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5094 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhCRBC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 21:02:57 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4F17xy2GjqzYLKC;
        Thu, 18 Mar 2021 09:01:10 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 18 Mar 2021 09:02:54 +0800
Received: from [127.0.0.1] (10.69.26.252) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Thu, 18 Mar
 2021 09:02:55 +0800
Subject: Re: [PATCH net-next 8/9] net: hns3: add support for queue bonding
 mode of flow director
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
 <1615811031-55209-9-git-send-email-tanhuazhong@huawei.com>
 <20210315130448.2582a0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <b7b23988-ecba-1ce4-6226-291938c92c08@huawei.com>
Date:   Thu, 18 Mar 2021 09:02:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210315130448.2582a0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/16 4:04, Jakub Kicinski wrote:
> On Mon, 15 Mar 2021 20:23:50 +0800 Huazhong Tan wrote:
>> From: Jian Shen <shenjian15@huawei.com>
>>
>> For device version V3, it supports queue bonding, which can
>> identify the tuple information of TCP stream, and create flow
>> director rules automatically, in order to keep the tx and rx
>> packets are in the same queue pair. The driver set FD_ADD
>> field of TX BD for TCP SYN packet, and set FD_DEL filed for
>> TCP FIN or RST packet. The hardware create or remove a fd rule
>> according to the TX BD, and it also support to age-out a rule
>> if not hit for a long time.
>>
>> The queue bonding mode is default to be disabled, and can be
>> enabled/disabled with ethtool priv-flags command.
> This seems like fairly well defined behavior, IMHO we should have a full
> device feature for it, rather than a private flag.


Should we add a NETIF_F_NTUPLE_HW feature for it?


> Does the device need to be able to parse the frame fully for this
> mechanism to work? Will it work even if the TCP segment is encapsulated
> in a custom tunnel?


no, custom tunnel is not supported.



