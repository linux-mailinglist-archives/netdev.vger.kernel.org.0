Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EBE495E23
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 12:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380058AbiAULHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 06:07:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43606 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344558AbiAULHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 06:07:03 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LA5p8N030614;
        Fri, 21 Jan 2022 11:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ks4ncqRySB/JGzd5zHbo+zAMFTclqG/9wt0qoo5JnBk=;
 b=luCnd+1QJLzfXj2ox6JEXbZXIpD7o/t9XpAB74aJv8TYk7MDZM4YdbgdUFDv1dLVOCiB
 NaeNUh8VEI59e1o+0X/xWf2WazYA0tG0jkyfkjSuaqB6ruiqxkN8x3CqneOLS36IYJUu
 HuwKF5j4gwKnIsrEcSRFSAhhMSPxgWd6A/kqYnNt8fFdIVPdnYp9hocs9X+zh789UaLu
 kZVVGTkWQvelJS/A/0CI6uNk8Cba1fsQaAXEhyUlUpvsiIc1he6e8i0hWKd2bNmaVSq3
 If+wj+FX0O1kDgg+mGJ/8j3aYQXjMZp8ak6aa/wlFypNjSP8CwGYrTQol25KjIzY6Wwr SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqt27sx2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 11:07:00 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LAvmgs004395;
        Fri, 21 Jan 2022 11:07:00 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqt27sx23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 11:07:00 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LB2Fcj019856;
        Fri, 21 Jan 2022 11:06:58 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3dqjdpktqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 11:06:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LB6tqL36700540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 11:06:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1CA7AE068;
        Fri, 21 Jan 2022 11:06:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75793AE07D;
        Fri, 21 Jan 2022 11:06:55 +0000 (GMT)
Received: from [9.145.9.162] (unknown [9.145.9.162])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 11:06:55 +0000 (GMT)
Message-ID: <c5873d85-d791-319b-e3a1-86abda204b45@linux.ibm.com>
Date:   Fri, 21 Jan 2022 12:06:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net/smc: Use kvzalloc for allocating
 smc_link_group
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220120140928.7137-1-tonylu@linux.alibaba.com>
 <4c600724-3306-0f0e-36dc-52f4f23825bc@linux.ibm.com>
 <YeoncJZoa3ELWyxM@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <YeoncJZoa3ELWyxM@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iQWPqHYMyXAg6hP4AX8UYTXHXE33yz2B
X-Proofpoint-GUID: SpDjJkr3RTUQY7Zb3cpjsIHuuZ2pVxTs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210075
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/01/2022 04:24, Tony Lu wrote:
> On Thu, Jan 20, 2022 at 03:50:26PM +0100, Karsten Graul wrote:
>> On 20/01/2022 15:09, Tony Lu wrote:
>>> When analyzed memory usage of SMC, we found that the size of struct
>>> smc_link_group is 16048 bytes, which is too big for a busy machine to
>>> allocate contiguous memory. Using kvzalloc instead that falls back to
>>> vmalloc if there has not enough contiguous memory.
>>
>> I am wondering where the needed contiguous memory for the required RMB buffers should come from when 
>> you don't even get enough storage for the initial link group?
> 
> Yes, this is what I want to talking about. The RMB buffers size inherits
> from TCP, we cannot assume that RMB is always larger than 16k bytes, the
> tcp_mem can be changed on the fly, and it can be tuned to very small for
> saving memory. Also, If we freed existed link group or somewhere else,
> we can allocate enough contiguous memory for the new link group.

The lowest size for an RMB is 16kb, smaller inherited tcp sizes do not apply here.
> 
>> The idea is that when the system is so low on contiguous memory then a link group creation should fail 
>> early, because most of the later buffer allocations will also fail then later.
> 
> IMHO, it is not a "pre-checker" for allocating buffer, it is a reminder
> for us to save contiguous memory, this is a precious resource, and a
> possible way to do this. This patch is not the best approach to solve
> this problem, but the simplest one. A possible approach to allocate
> link array in link group with a pointer to another memory. Glad to hear
> your advice.

I am still not fully convinced of this change. It does not harm and the overhead of
a vmalloc() is acceptable because a link group is not created so often. But since
kvzmalloc() will first try to use normal kmalloc() and if that fails switch to the
(more expensive) vmalloc() this will not _save_ any contiguous memory.
And for the subsequent required allocations of at least one RMB we need another 16KB.

Did this change had any measurable advantages in your tests?
