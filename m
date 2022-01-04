Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646F84842BD
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbiADNpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:45:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30948 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232396AbiADNpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:45:46 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 204CeTFu009508;
        Tue, 4 Jan 2022 13:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O1J7ilvI+Xw/0plZ7qyoCYOvQXWULalJ+6BqTYE3Za8=;
 b=eoKynxD1uxgCkjy757mQKr+35qnwGo0bWnCqqdxNjR9MeXeLFJjCst2/QamCmrP+QT0l
 p0RT+BkloaWuTsZI2dn8Nc5nLlliEgw4Y6sHxVKNPcgwnE9Tw6Prc94HNbqqVMkiMrZs
 UmIGtmCv+T6xS7pUvNgDC+c5ZLgOa0oB7yFKgF2Gd1az+p2z5Nt8f4vmQj6ojS0Q2Ixl
 ZhYA45/3dxeM6yJla1qTu0PVO6NoINCAw9Jy7CKSDcvG0Uu85YiYkz6fBox9dowIPgfv
 8rN2gc3e8pGX2vSWrLrFUTNjWBxC0+Px+0etF+LEX5pHHUteyfWFuYC2XaNMB5Ujtjk2 NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dckgnvj5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 13:45:41 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 204DFhu3026552;
        Tue, 4 Jan 2022 13:45:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dckgnvj4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 13:45:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 204Di4Ui016045;
        Tue, 4 Jan 2022 13:45:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3daek9j8hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 13:45:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 204DjaZi35848454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jan 2022 13:45:36 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EAF6AE045;
        Tue,  4 Jan 2022 13:45:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBFC2AE04D;
        Tue,  4 Jan 2022 13:45:35 +0000 (GMT)
Received: from [9.145.168.225] (unknown [9.145.168.225])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Jan 2022 13:45:35 +0000 (GMT)
Message-ID: <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
Date:   Tue, 4 Jan 2022 14:45:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: geiw6FHoTOkNHfJ7_HyILPIAA4yjjgJD
X-Proofpoint-ORIG-GUID: q_s7poA5AXgtU40jYmyT1cHHeVdF-UgC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_05,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201040089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/01/2022 14:12, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> In nginx/wrk multithread and 10K connections benchmark, the
> backend TCP connection established very slowly, and lots of TCP
> connections stay in SYN_SENT state.

I see what you are trying to solve here.
So what happens with your patch now is that we are accepting way more connections
in advance and queue them up for the SMC connection handshake worker.
The connection handshake worker itself will not run faster with this change, so overall
it should be the same time that is needed to establish all connections.
What you solve is that when 10k connections are started at the same time, some of them
will be dropped due to tcp 3-way handshake timeouts. Your patch avoids that but one can now flood
the stack with an ~infinite amount of dangling sockets waiting for the SMC handshake, maybe even 
causing oom conditions.

What should be respected with such a change would be the backlog parameter for the listen socket,
i.e. how many backlog connections are requested by the user space application?
There is no such handling of backlog right now, and due to the 'braking' workers we avoided
to flood the kernel with too many dangling connections. With your change there should be a way to limit
this ind of connections in some way.

