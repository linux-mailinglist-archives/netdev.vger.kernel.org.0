Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CEC25B845
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 03:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgICBZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 21:25:48 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51204 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727037AbgICBZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 21:25:48 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9F863FB4BAF801B71375;
        Thu,  3 Sep 2020 09:25:46 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 3 Sep 2020
 09:25:40 +0800
Subject: Re: [RFC net-next] udp: add a GSO type for UDPv6
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jakub Kicinski <kuba@kernel.org>
References: <1599048911-7923-1-git-send-email-tanhuazhong@huawei.com>
 <CA+FuTSc_KOZRTdh34Vw3gTCzGMmi5XvDZKjpWMOXw7aby53wqw@mail.gmail.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <b4bf766c-4d56-cf6b-9018-468ebcd3e147@huawei.com>
Date:   Thu, 3 Sep 2020 09:25:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTSc_KOZRTdh34Vw3gTCzGMmi5XvDZKjpWMOXw7aby53wqw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/9/2 22:33, Willem de Bruijn wrote:
> On Wed, Sep 2, 2020 at 2:18 PM Huazhong Tan <tanhuazhong@huawei.com> wrote:
>>
>> In some cases, for UDP GSO, UDPv4 and UDPv6 need to be handled
>> separately, for example, checksum offload, so add new GSO type
>> SKB_GSO_UDPV6_L4 for UDPv6, and the old SKB_GSO_UDP_L4 stands
>> for UDPv4.
> 
> This is in preparation for hardware you have that actually cares about
> this distinction, I guess?
> 

it is mainly for separating checksum offload of IPv4 and IPv6 right now.
with this patch, the user can switch checksum offload of IPv4 and not
affect IPv6's, vice versa.

> 
>> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
>> index 2cc3cf8..b7c1a76 100644
>> --- a/include/linux/netdev_features.h
>> +++ b/include/linux/netdev_features.h
>> @@ -54,6 +54,7 @@ enum {
>>          NETIF_F_GSO_UDP_BIT,            /* ... UFO, deprecated except tuntap */
>>          NETIF_F_GSO_UDP_L4_BIT,         /* ... UDP payload GSO (not UFO) */
>>          NETIF_F_GSO_FRAGLIST_BIT,               /* ... Fraglist GSO */
>> +       NETIF_F_GSO_UDPV6_L4_BIT,       /* ... UDPv6 payload GSO (not UFO) */
>>          /**/NETIF_F_GSO_LAST =          /* last bit, see GSO_MASK */
>>                  NETIF_F_GSO_FRAGLIST_BIT,
> 
> Need to update NETIF_F_GSO_LAST then, too.

ok, thanks.

> 
> 

