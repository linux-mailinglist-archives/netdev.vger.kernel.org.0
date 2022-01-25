Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3421949B0CE
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbiAYJtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:49:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234335AbiAYJmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:42:20 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20P9g7Um018272;
        Tue, 25 Jan 2022 09:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3otL+4z0kpAg/JI3RysnLW9r0L/YYZ3G6sqBrPUos1o=;
 b=bm9nlYIpfKzdf9wJo+Ris3IgoYJjp82vbk/TmRiPgeutCZD1MC87ROc+nrohznmWS153
 a6kjFP6xE/hs4AO0wdbFoPenzg3HmwyF+9yJaycSjuvrWXjJqfVYiWcIhVi1RzeGm8/S
 lecnCtQTP2FDTvyLlZR0Qbj1lF8UvxmIiBfzV+6jHZNsQCG+tKEIHplKajY+CHu1fc42
 Gv7buXIlZ/MVKkYdkzCgTIsuu+S5KqKXvsPTmLOv2J8xKlKAWoosEiArMKJ5MfQnd9mC
 OK/TvfjsJmOcaDb1yyVGaJ8KiqKyy3RQY3WN+qduqAXN1pZLq8yxdNCK/p6pjW7MFfPc ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dtet1r020-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 09:42:11 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20P9gBid018335;
        Tue, 25 Jan 2022 09:42:11 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dtet1r01g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 09:42:11 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20P9dt9A021927;
        Tue, 25 Jan 2022 09:42:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3dr9j9b1xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 09:42:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20P9g6jb36045144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 09:42:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84C8B4C04A;
        Tue, 25 Jan 2022 09:42:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41BB54C058;
        Tue, 25 Jan 2022 09:42:06 +0000 (GMT)
Received: from [9.171.94.78] (unknown [9.171.94.78])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 09:42:06 +0000 (GMT)
Message-ID: <1f13f001-e4d7-fdcd-6575-caa1be1526e1@linux.ibm.com>
Date:   Tue, 25 Jan 2022 10:42:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Content-Language: en-US
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
In-Reply-To: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qwhbVy3rG3bYBb61MKH5uEk6M6GBXzIS
X-Proofpoint-ORIG-GUID: P4u1KMhNSr5YUk26tLwFBpUocj4uMVHf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_02,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 phishscore=0 suspectscore=0 spamscore=0 impostorscore=0 malwarescore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/22 07:51, Guangguan Wang wrote:
> This implement rq flow control in smc-r link layer. QPs
> communicating without rq flow control, in the previous
> version, may result in RNR (reveive not ready) error, which
> means when sq sends a message to the remote qp, but the
> remote qp's rq has no valid rq entities to receive the message.
> In RNR condition, the rdma transport layer may retransmit
> the messages again and again until the rq has any entities,
> which may lower the performance, especially in heavy traffic.
> Using credits to do rq flow control can avoid the occurrence
> of RNR.

That's some truly substantial improvements!
But we need to be careful with protocol-level changes: There are other operating 
systems like z/OS and AIX which have compatible implementations of SMC, too. 
Changes like a reduction of connections per link group or usage of reserved 
fields would need to be coordinated, and likely would have unwanted side-effects 
even when used with older Linux kernel versions.
Changing the protocol is "expensive" insofar as it requires time to thoroughly 
discuss the changes, perform compatibility tests, and so on.
So I would like to urge you to investigate alternative ways that do not require 
protocol-level changes to address this scenario, e.g. by modifying the number of 
completion queue elements, to see if this could yield similar results.

Thx!





