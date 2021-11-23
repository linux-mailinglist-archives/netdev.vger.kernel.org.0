Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DE8459E39
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhKWIji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:39:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47710 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230176AbhKWIjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:39:37 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN5xL4i013984;
        Tue, 23 Nov 2021 08:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=shRKH7UBv5R2UJfmy9nEN9ZlK7i4FnqT3gDYSUL/730=;
 b=CJAuv7xU2grgVlWqCVQ6kaFHpjfxIPisouLcOUMlGP0yHFdGAh7kcoOtwvE/rwejf5OD
 ZX8W0TeiPsGY7Zcr4vgeDFF4IeFoCVsTSIk7o5tAUMZ90WU4blwr2ysnPdkvXi/BibVV
 D0N/5bYUUS8p/o3lU2p+eYZeaClkUtEcof4gU1sjykMxrMLFYykMkT4GzTsjtLKQD4ff
 zTIW2O7a8CgZwHtDtn4UgrJEpFpTfAgZQmWhCYZjbNfsPFKsYEr/sOethsJAzlNJliph
 xj9m7voH533U4GpiSxWpEKwglAJPejGutBzyao67wQp4RZl5/bkbMpNSOUugPiyMbJNE Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgqccwghk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 08:36:27 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AN8XPO5033856;
        Tue, 23 Nov 2021 08:36:26 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgqccwgh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 08:36:26 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AN8SHpT028861;
        Tue, 23 Nov 2021 08:36:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3cern9mfrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 08:36:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AN8TDCn52494764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 08:29:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF6D0A4064;
        Tue, 23 Nov 2021 08:36:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E6FEA4067;
        Tue, 23 Nov 2021 08:36:21 +0000 (GMT)
Received: from [9.145.60.43] (unknown [9.145.60.43])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 08:36:21 +0000 (GMT)
Message-ID: <dfab4238-3d76-822c-feee-8463054232aa@linux.ibm.com>
Date:   Tue, 23 Nov 2021 09:36:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net 2/2] net/smc: Ensure the active closing peer first
 closes clcsock
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20211123082515.65956-1-tonylu@linux.alibaba.com>
 <20211123082515.65956-3-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211123082515.65956-3-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XZUAuHg0DfJ1OQEzSQJJ9rysnmvPhLka
X-Proofpoint-ORIG-GUID: b3Whlt_VSDlqV95wo0t4uUFXPcvQxNyZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_02,2021-11-22_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2021 09:25, Tony Lu wrote:
> The side that actively closed socket, it's clcsock doesn't enter
> TIME_WAIT state, but the passive side does it. It should show the same
> behavior as TCP sockets.
> 
> Consider this, when client actively closes the socket, the clcsock in
> server enters TIME_WAIT state, which means the address is occupied and
> won't be reused before TIME_WAIT dismissing. If we restarted server, the
> service would be unavailable for a long time.
> 
> To solve this issue, shutdown the clcsock in [A], perform the TCP active
> close progress first, before the passive closed side closing it. So that
> the actively closed side enters TIME_WAIT, not the passive one.
> 

Thank you, I will pick this up for our next submission to the net tree.

