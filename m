Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CA739F187
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFHJBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 05:01:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFHJBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 05:01:22 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1588ttPe092876;
        Tue, 8 Jun 2021 04:59:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zncH8Y9Ig0Sn9Z3dBCqA5uZhMuCKXbQPTA0d+6pwXOo=;
 b=Se6/j3C2gQwm99LOmRd4SZODrfND5eLXc4af3CFsBFRpQnVRztp8X8mfQ6xYi9ULA8bQ
 Mf25UOu0OVtRGlQvwVMjhyiXq85M8z1TRxn31xIhvqnhrhdukfcH6PopbMcvSferxHQU
 Z7HCrOgsYl69d60snbYKVQ38Oo32NUAK3yYscjurSlo+nT7IBqHV4dUmCn2PcOs2n8us
 dCQkMrqdF30SsbE8HmCRBWnMKczUSY5UC2ZyL5FJet5Y8xHGGgbjvccjEDQE7vOXK55e
 XPn3fU9IyM+5PGF9/4wKjj5P5wUMbZMUNk+o6B2UioI2eGsYyBELE/MEd1APJTwNgbj/ sg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3925fj01e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 04:59:27 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1588vaL9032077;
        Tue, 8 Jun 2021 08:59:27 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3900w9b6qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 08:59:27 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1588xPxs22741264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 08:59:25 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82CA278068;
        Tue,  8 Jun 2021 08:59:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B48E7805C;
        Tue,  8 Jun 2021 08:59:24 +0000 (GMT)
Received: from [9.171.25.104] (unknown [9.171.25.104])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Tue,  8 Jun 2021 08:59:24 +0000 (GMT)
Subject: Re: [PATCH net-next 0/4] net/smc: Add SMC statistic support
To:     David Miller <davem@davemloft.net>, kgraul@linux.ibm.com
Cc:     kuba@kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org
References: <20210607182014.3384922-1-kgraul@linux.ibm.com>
 <20210607.133346.155691512247470187.davem@davemloft.net>
From:   Guvenc Gulce <guvenc@linux.ibm.com>
Message-ID: <1df10dbb-a3bd-9b8f-6fb9-8a8fe98ae175@linux.ibm.com>
Date:   Tue, 8 Jun 2021 10:59:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210607.133346.155691512247470187.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8RMZyZaSZ0X8X33-1jINQtzzJmIPiTlN
X-Proofpoint-GUID: 8RMZyZaSZ0X8X33-1jINQtzzJmIPiTlN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_05:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 adultscore=0 clxscore=1011 phishscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,
Thank you for looking into this. SMC is a protocol interacting with PCI devices (like RoCE Cards) and
runs on top of TCP protocol. As SMC is a network protocol and not an ethernet device driver, we
decided to use the generic netlink interface. There is already an established internal generic netlink
interface mechanism in SMC which is used to collect SMC Protocol internal information. This patchset
extends that existing mechanism.
Ethtool's predefined netlink interfaces are specifically tailored for the ethernet device internals and needs
and these netlink interfaces wouldn't really fit to the use cases of the SMC protocol.

Other protocols (like tipc, ncsi, ieee802154, tcp metrics) under the net subsystem use also similar generic
netlink mechanism for collecting and transporting protocol specific information to userspace. This also
encouraged us to make the generic netlink decision for exposing the gathered SMC protocol statistics
and internal information to the userspace.

Regards,

Guvenc Gulce

On 07/06/2021 22:33, David Miller wrote:
> From: Karsten Graul <kgraul@linux.ibm.com>
> Date: Mon,  7 Jun 2021 20:20:10 +0200
>
>> Please apply the following patch series for smc to netdev's net-next tree.
>>
>> The patchset adds statistic support to the SMC protocol. Per-cpu
>> variables are used to collect the statistic information for better
>> performance and for reducing concurrency pitfalls. The code that is
>> collecting statistic data is implemented in macros to increase code
>> reuse and readability.
>> The generic netlink mechanism in SMC is extended to provide the
>> collected statistics to userspace.
>> Network namespace awareness is also part of the statistics
>> implementation.
> Why not use ethtool stats?
>
> Thank you.

