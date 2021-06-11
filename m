Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A3B3A3F0D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhFKJaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:30:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3710 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230460AbhFKJaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:30:22 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B93RlF159911;
        Fri, 11 Jun 2021 05:28:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=h18rkByN+srPmFu11YTDLVjsXF5/Wia051rwQ7X3oyg=;
 b=iVbmf+VLGx6QW+qZAKzH/Wj6B7yJWOJX7GpkkIjNTcDFemwoOAx+cWYbh8hw9MefkfYY
 sbc9xy5wsmAg9H5xHNJ8FHleVER7jezkPQPBJQ56c68A0VcbEPYqJOngTrBhIFNoUav3
 NQyabu+nOHqskqP/yyPm2uzZQ/TYrvBlnfdiRg91SCidFkdFCNvJQGrL5bVhYkhve/Jx
 aw/tNdzwEufKA2EdA9wG9P9oQRwsyb/DrYxuy5vJCa68gnsuLRcTC0jZID6clMP2rnHP
 vZyZJ/avVJOIBE0VAHvtLcrphsK/bL8UG0H9sRFbA3SHxoMch/PAVeWQ/Ij9BcfY8rZK eQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39447tsrdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 05:28:20 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B9JT8q028949;
        Fri, 11 Jun 2021 09:28:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3900w8kb3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 09:28:18 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B9RKew36831630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 09:27:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E35442047;
        Fri, 11 Jun 2021 09:28:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F9154203F;
        Fri, 11 Jun 2021 09:28:09 +0000 (GMT)
Received: from [9.171.82.75] (unknown [9.171.82.75])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 09:28:09 +0000 (GMT)
Subject: Re: [PATCH net-next 0/4] net/smc: Add SMC statistic support
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Guvenc Gulce <guvenc@linux.ibm.com>
References: <20210607182014.3384922-1-kgraul@linux.ibm.com>
 <20210607.133346.155691512247470187.davem@davemloft.net>
 <1df10dbb-a3bd-9b8f-6fb9-8a8fe98ae175@linux.ibm.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <b169ffb2-13e1-de0a-49ee-2035d74c45af@linux.ibm.com>
Date:   Fri, 11 Jun 2021 11:28:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1df10dbb-a3bd-9b8f-6fb9-8a8fe98ae175@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eX4QdvcD6jlllRZCd61aOHxFk_Nee-wv
X-Proofpoint-ORIG-GUID: eX4QdvcD6jlllRZCd61aOHxFk_Nee-wv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_02:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106110057
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 07/06/2021 22:33, David Miller wrote:
>> From: Karsten Graul <kgraul@linux.ibm.com>
>> Date: Mon,  7 Jun 2021 20:20:10 +0200
>>
>>> Please apply the following patch series for smc to netdev's net-next tree.
>>>
>>> The patchset adds statistic support to the SMC protocol. Per-cpu
>>> variables are used to collect the statistic information for better
>>> performance and for reducing concurrency pitfalls. The code that is
>>> collecting statistic data is implemented in macros to increase code
>>> reuse and readability.
>>> The generic netlink mechanism in SMC is extended to provide the
>>> collected statistics to userspace.
>>> Network namespace awareness is also part of the statistics
>>> implementation.
>> Why not use ethtool stats?
>>
>> Thank you.

On 08/06/2021 10:59, Guvenc Gulce wrote:
> Hi Dave,
> Thank you for looking into this. SMC is a protocol interacting with PCI devices (like RoCE Cards) and
> runs on top of TCP protocol. As SMC is a network protocol and not an ethernet device driver, we
> decided to use the generic netlink interface. There is already an established internal generic netlink
> interface mechanism in SMC which is used to collect SMC Protocol internal information. This patchset
> extends that existing mechanism.
> Ethtool's predefined netlink interfaces are specifically tailored for the ethernet device internals and needs
> and these netlink interfaces wouldn't really fit to the use cases of the SMC protocol.
> 
> Other protocols (like tipc, ncsi, ieee802154, tcp metrics) under the net subsystem use also similar generic
> netlink mechanism for collecting and transporting protocol specific information to userspace. This also
> encouraged us to make the generic netlink decision for exposing the gathered SMC protocol statistics
> and internal information to the userspace.
> 
> Regards,
> 
> Guvenc Gulce
> 

I just wanted to touch base with you regarding Guvenc's response where he explained our ideas about the statistics interface. We would be happy to hear your thoughts on how to proceed.

--
Karsten
