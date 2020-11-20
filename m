Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E729B2BA478
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 09:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgKTISu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 03:18:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15286 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbgKTISu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 03:18:50 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK8H4AY022468;
        Fri, 20 Nov 2020 00:18:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=K3n18mL71ilBreCCLoL9Nh5fWDK4rNxsZbokbG76gas=;
 b=C88gb+9wzLDiyzZY/a178sIbFd7YpBAdBWagZJMbyyCQFCztt7pRA+59mAZtnNY+zj3U
 4eZY37BL81J0VKvfeOtopkTmqd99454q3IY6Rvzr26yJAIllehnObdH4J0n9pzqpeaQH
 cuvAmMiYEZEu60SBDRj5crGq8ogf7EqlDKlJ0pER3apan+mIij1hMjFD6X7lhOA0m9TK
 pekvuYRSUsaScIfcQ4aAeCWxe0I4RjLxpAq7hSLYSzlw58QCi8G/64rCVTGp1E4BMXyh
 CieNYFdWkZlkwU8cVd+4sN42JlIT1qFTLernKnWu6HxB4me7RlHOcnKpd0wd3sA+6K7w IQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34w7ncyb1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 00:18:38 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Nov
 2020 00:18:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 20 Nov 2020 00:18:37 -0800
Received: from [10.193.39.169] (NN-LT0019.marvell.com [10.193.39.169])
        by maili.marvell.com (Postfix) with ESMTP id 519003F703F;
        Fri, 20 Nov 2020 00:18:35 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH v3] aquantia: Remove the build_skb path
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
CC:     Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "Dmitry Bogdanov [C]" <dbogdanov@marvell.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
 <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119221510.GI15137@breakpoint.cc>
 <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119222800.GJ15137@breakpoint.cc>
 <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119224916.GA24569@ranger.igk.intel.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <2fbb195a-a1b5-cec0-1ba1-bf45efc0ad24@marvell.com>
Date:   Fri, 20 Nov 2020 11:18:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101
 Thunderbird/83.0
MIME-Version: 1.0
In-Reply-To: <20201119224916.GA24569@ranger.igk.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_03:2020-11-19,2020-11-20 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/11/2020 1:49 am, Maciej Fijalkowski wrote:
> External Email
> 
> ----------------------------------------------------------------------
> On Thu, Nov 19, 2020 at 10:34:48PM +0000, Ramsay, Lincoln wrote:
>> When performing IPv6 forwarding, there is an expectation that SKBs
>> will have some headroom. When forwarding a packet from the aquantia
>> driver, this does not always happen, triggering a kernel warning.
>>
>> The build_skb path fails to allow for an SKB header, but the hardware
>> buffer it is built around won't allow for this anyway. Just always use
> the
>> slower codepath that copies memory into an allocated SKB.
>>
>> Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>
>> ---
> 
> (Next time please include in the subject the tree that you're targetting
> the patch)
> 
> I feel like it's only a workaround, not a real solution. On previous
> thread Igor says:
> 
> "The limitation here is we can't tell HW on granularity less than 1K."
> 
> Are you saying that the minimum headroom that we could provide is 1k?

We can tell HW to place packets with 4 bytes granularity addresses, but the
problem is the length granularity of this buffer - 1K.

This means we can do as Ramsay initially suggested - just offset the packet
placement. But then we have to guarantee that 1K after this offset is
available to HW.

Since normal layout is 1400 packets - we do use 2K (half page) for each packet.
This way we reuse each allocated page for at least two packets (and putting
skb_shared into the remaining 512b).

Obviously we may allocate 4K page for a single packet, and tell HW that it can
use 3K for data. This'll give 1K headroom. Quite an overload - assuming IMIX
is of 0.5K - 1.4K..

Of course that depends on a usecase. If you know all your traffic is 16K
jumbos - putting 1K headroom is very small overhead on memory usage.

> Maybe put more pressure on memory side and pull in order-1 pages, provide
> this big headroom and tailroom for skb_shared_info and use build_skb by
> default? With standard 1500 byte MTU.
I know many customers do consider AQC chips in near embedded environments
(routers, etc). They really do care about memories. So that could be risky.

> This issue would pop up again if this driver would like to support XDP
> where 256 byte headroom will have to be provided.

Actually it already popped. Thats one of the reasons I'm delaying with xdp
patch series for this driver.

I think the best tradeoff here would be allocating order 1 or 2 pages (i.e. 8K
or 16K), and reuse the page for multiple placements of 2K XDP packets:

(256+2048)*3 = 6912 (1K overhead for each 3 packets)

(256+2048)*7 = 16128 (200b overhead over 7 packets)

Regards,
  Igor



