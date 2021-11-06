Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421B1446DF1
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 13:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhKFMsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 08:48:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35302 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232900AbhKFMs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 08:48:29 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A69MMRo033455;
        Sat, 6 Nov 2021 12:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QP1ehqk8w2ElEGkdv2KPKItCkiDJa+NrePQ5P8xyX2U=;
 b=ajYrTwFaMcLoCqTer6Lw1PRFUqXqs48F8DbUcmD757uNp4eSyLr3Wu9c1e2DehBAYjVF
 wzpZmK9ysNkAudBgMLSq0jNZv6VYfUVsnLcC4w2NclGwKMCNORN+jJouZBQc/uhI5yRx
 9eof6m5wyJ2zJ3sN2i2opIFhUW0YCCA8cwYYTEqpB9dAesDFTsqKYXnkDj+6sW8h1r0E
 zy1tff4POMPTdxLatoVcYCweStE07EA8NCPGJo0e3keyc6IhJt9nc7y0NDhCFL5Mqj0E
 xonIRs8Kcbo2bxze/NpidbXNpKN2NTpp/huXwzNOOAwRocKeAlBDkRsl70suN8CkEF/v FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c5q11acjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Nov 2021 12:45:44 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A6CenHX029423;
        Sat, 6 Nov 2021 12:45:44 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c5q11acjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Nov 2021 12:45:44 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A6ChSoa026786;
        Sat, 6 Nov 2021 12:45:42 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3c5hb8svgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Nov 2021 12:45:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A6CjeS348234962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 6 Nov 2021 12:45:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAEBDA4051;
        Sat,  6 Nov 2021 12:45:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FB07A404D;
        Sat,  6 Nov 2021 12:45:39 +0000 (GMT)
Received: from [9.145.174.141] (unknown [9.145.174.141])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  6 Nov 2021 12:45:39 +0000 (GMT)
Message-ID: <8445f69e-54e6-0c54-a2de-0560cbf0e6ce@linux.ibm.com>
Date:   Sat, 6 Nov 2021 13:46:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer space
 when data was already sent"
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-2-tonylu@linux.alibaba.com>
 <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
 <20211027080813.238b82ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <06ae0731-0b9b-a70d-6479-de6fe691e25d@linux.ibm.com>
 <20211027084710.1f4a4ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c6396899-cf99-e695-fc90-3e21e95245ed@linux.ibm.com>
 <20211028073827.421a68d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YX+RaKfBVzFokQON@TonyMac-Alibaba>
 <ca2a567b-915e-c4e1-96cf-2c03ff74aad5@linux.ibm.com>
 <YYH8npT0+ww57Gg1@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <YYH8npT0+ww57Gg1@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ikKJlSI1m7-smd4oBKs2w62RZ0OsrB1h
X-Proofpoint-GUID: LIgrbCnPsI5ThBkVrkktc0mqnAn0UyAQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-06_02,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111060077
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/11/2021 04:06, Tony Lu wrote:
> 
> I agree with you. I am curious about this deadlock scene. If it was
> convenient, could you provide a reproducible test case? We are also
> setting up a SMC CI/CD system to find the compatible and performance
> fallback problems. Maybe we could do something to make it better.

Run an echo server that uses blocking sockets. First call recv() with an 1MB buffer
and when recv() returns then send all received bytes back to the client, no matter
how many bytes where received. Run this in a loop (recv / send).
On the client side also use only blocking sockets and a send / recv loop. Use
an 1MB data buffer and call send() with the whole 1MB of data.
Now run that with both scenarios (send() returns lesser bytes than requested vs. not).
