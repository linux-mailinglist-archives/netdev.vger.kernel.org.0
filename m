Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB9243CDCB
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242816AbhJ0PlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:41:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1982 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238780AbhJ0PlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:41:02 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19REVCGE006006;
        Wed, 27 Oct 2021 15:38:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zwjumnhiCNnYD1iRDGJQBDIL1+dWtfR4Wm7p+o2YtZs=;
 b=sP63yPmr+Wg2h40DStvJggfICRnDdCuLZhZQ/TFX3AYkhpxaj8qDgnhTioJSqm36RbEe
 JkIVvyGxakPr6L796Mk5q3T4ysFdItlBCHkjB/OWZf6UqFtnyMOKsi5tNIMuyr/BADFV
 eubi27NtOSBEwBrFrVqtmndmSooVjPax7wfDizJ6exmLk9+CAO+bxtAMu09I5xHd1CKg
 wHU34KnITFg/gS/bI5ZDV39WUojZ7hjWhLhK9oHAQXzb6Djldm+X3zEhXcPimkxYgolR
 tiel5m7DHt0niSg4Y+Bn30sXTl/yi9EhNG1z0x73zZmCftw+rPyIUBQRXtpWP8ISSJhm sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3by75km22g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 15:38:33 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19REq6Fe006996;
        Wed, 27 Oct 2021 15:38:32 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3by75km223-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 15:38:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19RFcVna007894;
        Wed, 27 Oct 2021 15:38:31 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3bx4et8qw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 15:38:30 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19RFWIgQ61604178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 15:32:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EDDE52057;
        Wed, 27 Oct 2021 15:38:28 +0000 (GMT)
Received: from [9.145.41.29] (unknown [9.145.41.29])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E85535205A;
        Wed, 27 Oct 2021 15:38:27 +0000 (GMT)
Message-ID: <06ae0731-0b9b-a70d-6479-de6fe691e25d@linux.ibm.com>
Date:   Wed, 27 Oct 2021 17:38:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer space
 when data was already sent"
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-2-tonylu@linux.alibaba.com>
 <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
 <20211027080813.238b82ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211027080813.238b82ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: X1eAlZz9YBIrxxMYjWn8eFhPvqspvdZ0
X-Proofpoint-GUID: bMF6sbtXM8zmruJfPHheUVjSfleTAvR9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_04,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110270093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/10/2021 17:08, Jakub Kicinski wrote:
> On Wed, 27 Oct 2021 12:21:32 +0200 Karsten Graul wrote:
>> On 27/10/2021 10:52, Tony Lu wrote:
>>> From: Tony Lu <tony.ly@linux.alibaba.com>
>>>
>>> This reverts commit 6889b36da78a21a312d8b462c1fa25a03c2ff192.
>>>
>>> When using SMC to replace TCP, some userspace applications like netperf
>>> don't check the return code of send syscall correctly, which means how
>>> many bytes are sent. If rc of send() is smaller than expected, it should
>>> try to send again, instead of exit directly. It is difficult to change
>>> the uncorrect behaviors of userspace applications, so choose to revert it.  
>>
>> Your change would restore the old behavior to handle all sockets like they 
>> are blocking sockets, trying forever to send the provided data bytes.
>> This is not how it should work.
> 
> Isn't the application supposed to make the socket non-blocking or
> pass MSG_DONTWAIT if it doesn't want to sleep? It's unclear why 
> the fix was needed in the first place.
  
You are right, all of this non-blocking handling is already done in smc_tx_wait().
So this fix was for blocking sockets. The commit message explains the original
intention:

    net/smc: don't wait for send buffer space when data was already sent

    When there is no more send buffer space and at least 1 byte was already
    sent then return to user space. The wait is only done when no data was
    sent by the sendmsg() call.
    This fixes smc_tx_sendmsg() which tried to always send all user data and
    started to wait for free send buffer space when needed. During this wait
    the user space program was blocked in the sendmsg() call and hence not
    able to receive incoming data. When both sides were in such a situation
    then the connection stalled forever.

What we found out was that applications called sendmsg() with large data
buffers using blocking sockets. This led to the described situation, were the
solution was to early return to user space even if not all data were sent yet.
Userspace applications should not have a problem with the fact that sendmsg()
returns a smaller byte count than requested.

Reverting this patch would bring back the stalled connection problem.

>> We encountered the same issue with netperf, but this is the only 'broken'
>> application that we know of so far which does not implement the socket API
>> correctly.
> 

-- 
Karsten
