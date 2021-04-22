Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3DE367A8E
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 09:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhDVHG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 03:06:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234965AbhDVHGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 03:06:55 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M72oaK001418;
        Thu, 22 Apr 2021 03:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jgx6h0ae9zoQ7N5bBYsdcAYTRtjADEfHi6BOzPEF2uo=;
 b=cwA4Hhmmcn1CQ0q+z6wvCZmAzgYqw4etX5V5/wdwI2nKZxrYwaZGromwngE/cioAfXu6
 hwVFtLlP8xGtUKYRPxjbyG+0gtmumKODv1CiPbmOHCnDYgx4EvPFeLxa8ihitAiewnwI
 T260IQ3hPPi1og9ynI9EofXhGY+Y9TkPITl+hY0b8QetRCvesnNF5AJl5kW+HNQ+LW66
 h/TJYcnnryEQ63PXI02uaua1/btNSKz78VvRZaw/9NcdUBYCVxwBfiHDl/bOKxnRLiB1
 nwFfhjg8/dn7G0doqJOBYPTVw5aimxrRthAjT73th9uLU4R4O9PCtJ5EJNmlkEhEoLpD cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382yaapyjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 03:06:08 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13M72xUf002462;
        Thu, 22 Apr 2021 03:06:07 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382yaapydv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 03:06:07 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13M6vgM0011550;
        Thu, 22 Apr 2021 07:05:59 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 37yqaasygn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 07:05:59 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13M75wWm35324264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 07:05:58 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B3A6AE068;
        Thu, 22 Apr 2021 07:05:58 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1DEFAE05C;
        Thu, 22 Apr 2021 07:05:56 +0000 (GMT)
Received: from [9.160.109.21] (unknown [9.160.109.21])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 22 Apr 2021 07:05:56 +0000 (GMT)
Subject: Re: [PATCH V2 net] ibmvnic: Continue with reset if set link down
 failed
To:     Lijun Pan <lijunp213@gmail.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Lijun Pan <ljp@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
References: <20210420213517.24171-1-drt@linux.ibm.com>
 <60C99F56-617D-455B-9ACF-8CE1EED64D92@linux.vnet.ibm.com>
 <20210421064527.GA2648262@us.ibm.com>
 <CAOhMmr4ckVFTZtSeHFHNgGPUA12xYO8WcUoakx7WdwQfSKBJhA@mail.gmail.com>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
Message-ID: <376383c3-3fbd-25bf-8fb3-6cd54c218e34@linux.vnet.ibm.com>
Date:   Thu, 22 Apr 2021 00:05:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAOhMmr4ckVFTZtSeHFHNgGPUA12xYO8WcUoakx7WdwQfSKBJhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UKj3PdAtvpU9SNzMs46BjZtxaWT2YN9v
X-Proofpoint-ORIG-GUID: tbN13I2qbP5U4AgiF5AgwX_V0eMZnNv_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_01:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 clxscore=1015 malwarescore=0 spamscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/21 10:06 PM, Lijun Pan wrote:
> No real customer runs the system under that heavy load created by
> HTX stress test, which can tear down any working system.

So, are you saying the bugs that HTX uncovers are not worth fixing?

There's a fair number of individuals and teams out there that
utilize HTX in the absence of such a workload, and not just for vnic.
What workload would you suggest to better serve "real customers"?

> I think such optimizations are catered for passing HTX tests.

Well, yes.  If the bugs are found with HTX, the fixes are verified
against HTX.  If they were found with a "real customer workload" they'd
be verified against a "real customer workload."
