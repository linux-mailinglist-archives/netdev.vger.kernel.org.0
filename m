Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E8C454AD0
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 17:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbhKQQW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 11:22:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231442AbhKQQWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 11:22:25 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AHFglAj009919;
        Wed, 17 Nov 2021 16:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JDSOciCKi9kYus1di58N9I2uipqpTf3VudY/d3s9OtQ=;
 b=Xjcj1/s6vjpLVmc4oyfHsDQEgAPjrB90gZAHv7/4vFJiJMzGXo6J0NWKVUV9lh+q9vV0
 8WJya2vTap2mj4s9s+TqhiLBPM2AHD5S9FSVaHguz3MCT7wABPdmAoS2+abT+wMBIXA/
 AhmjSgUAxirRMWe2J6vlT7N07aGdZx02WDiJpkEmomLbcpcQ6gnS1ZfTKZItzybCzoCB
 msc02i4bIGOV9in+Se0cpE1MS560b2dsS7qwTPYFSknVz5wgCbCsT3PtERtkOAbxG23W
 EgeD5Tpe1vPwcJ2WxRXwIv0j6wG3y2ZLbs8nV6NOFB8Yz5i+aTI9x524xqRQn+CWihW6 Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cd4mc0var-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 16:19:24 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AHG0LTS015031;
        Wed, 17 Nov 2021 16:19:23 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cd4mc0va8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 16:19:23 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AHG3F52027811;
        Wed, 17 Nov 2021 16:19:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3ca50ac48u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 16:19:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AHGCNep60817730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 16:12:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23DE342045;
        Wed, 17 Nov 2021 16:19:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AED1B42042;
        Wed, 17 Nov 2021 16:19:18 +0000 (GMT)
Received: from [9.145.71.52] (unknown [9.145.71.52])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Nov 2021 16:19:18 +0000 (GMT)
Message-ID: <9af1f859-0299-d1d7-d5ce-af46cf102025@linux.ibm.com>
Date:   Wed, 17 Nov 2021 17:19:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH RFC net] net/smc: Ensure the active closing peer first
 closes clcsock
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20211116033011.16658-1-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211116033011.16658-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fMiKJa79We4Fuad8c0I_1sCNIS0LyMe1
X-Proofpoint-GUID: n7pQ8aSp7_gXjoAwwbLfuQb114SFCF_j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-17_05,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1011
 mlxlogscore=999 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111170076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/11/2021 04:30, Tony Lu wrote:
> We found an issue when replacing TCP with SMC. When the actively closed
> peer called close() in userspace, the clcsock of peer doesn't enter TCP
> active close progress, but the passive closed peer close it first, and
> enters TIME_WAIT state. It means the behavior doesn't match what we
> expected. After reading RFC7609, there is no clear description of the
> order in which we close clcsock during close progress.

Thanks for your detailed description, it helped me to understand the problem.
Your point is that SMC sockets should show the same behavior as TCP sockets
in this situation: the side that actively closed the socket should get into
TIME_WAIT state, and not the passive side. I agree with this.
Your idea to fix it looks like a good solution for me. But I need to do more
testing to make sure that other SMC implementations (not Linux) work as
expected with this change. For example, Linux does not actively monitor the 
clcsocket state, but if another implementation would do this it could happen
that the SMC socket is closed already when the clcsocket shutdown arrives, and
pending data transfers are aborted.

I will respond to your RFC when I finished my testing.

Thank you.
