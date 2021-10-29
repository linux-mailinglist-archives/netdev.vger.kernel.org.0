Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E689F43FA12
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 11:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhJ2Jmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 05:42:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46428 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229927AbhJ2Jmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 05:42:52 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19T8NWlL019754;
        Fri, 29 Oct 2021 09:40:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CT9m138E2l4ITQbND8Qn0r0n7mFV+LEpfA2oGT+3OAk=;
 b=oBShqAsdOPDO0ZQ/+vzcmenLC0Cs31n2inTfMf5x6XtgU811LrUgSQXxbQZfqWwTauRE
 sflSQs/c/plzo6q8Lb7HaDj+fmZ0j/MtyiGZRr/7VYG9ioxAirzE6DGLre+Paym8hh2H
 rwTDVmeGXwuyGkn//iQhwgk6b0YnGLQEzPsgoy9UUZdZAJ5Q4Iiq4DjtxJKS+nOxO9KG
 J41BlWEitDP+/q/Idi5RRc/wTlKTo5hL4hIvpEmeDyOaHM63F+xtWwiUZB8FhpSX6wzc
 +7MdvF25CU6LAq7j1ExihOloUiQCRRyIZIPSi7fH63RdBuSCANDqiZK2DqwuZliX9VDU Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c0dde9g16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 09:40:19 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19T8SB7j000976;
        Fri, 29 Oct 2021 09:40:19 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c0dde9g0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 09:40:19 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19T9SkTB005383;
        Fri, 29 Oct 2021 09:40:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3bx4etspx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 09:40:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19T9eEXl63373630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 09:40:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA49452052;
        Fri, 29 Oct 2021 09:40:14 +0000 (GMT)
Received: from [9.145.4.84] (unknown [9.145.4.84])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5A3AD52050;
        Fri, 29 Oct 2021 09:40:14 +0000 (GMT)
Message-ID: <acaf3d5a-219b-3eec-3a65-91d3fdfb21e9@linux.ibm.com>
Date:   Fri, 29 Oct 2021 11:40:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH net 4/4] net/smc: Fix wq mismatch issue caused by smc
 fallback
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org, ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-5-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211027085208.16048-5-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m0qdDClYVbWfw4jOn_P25n3XQPuOU1ur
X-Proofpoint-ORIG-GUID: TT2rlq-r_YtCjSLHN3Oq4LWQruKF8xIy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_02,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 adultscore=0 suspectscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110290053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 10:52, Tony Lu wrote:
> From: Wen Gu <guwen@linux.alibaba.com>
> 
> A socket_wq mismatch issue may occur because of fallback.
> 
> When use SMC to replace TCP, applications add an epoll entry into SMC
> socket's wq, but kernel uses clcsock's wq instead of SMC socket's wq
> once fallback occurs, which means the application's epoll fd dosen't
> work anymore.

I am not sure if I understand this fix completely, please explain your intentions
for the changes in more detail.

What I see so far:
- smc_create() swaps the sk->sk_wq of the clcsocket and the new SMC socket
  - sets clcsocket sk->sk_wq to smcsocket->wq (why?)
  - sets smcsocket sk->sk_wq to clcsocket->wq (why?)
- smc_switch_to_fallback() resets the clcsock sk->sk_wq to clcsocket->wq
- smc_accept() sets smcsocket sk->sk_wq to clcsocket->wq when it is NOT fallback
  - but this was already done before in smc_create() ??
- smc_poll() now always uses clcsocket->wq for the call to sock_poll_wait()

In smc_poll() the comment says that now clcsocket->wq is used for poll, whats
the relation between socket->wq and socket->sk->sk_wq here?
