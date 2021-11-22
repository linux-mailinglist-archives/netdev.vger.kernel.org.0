Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F4B45935F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240411AbhKVQu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:50:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238381AbhKVQu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:50:59 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMEvCCB007354;
        Mon, 22 Nov 2021 16:47:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WlRIheCBP1xnezxGy0qETHi39Xs1+SgAOWRbAxGU4X4=;
 b=DRTsfK3ieaf5SLTyin5/OP74k+qDp4XgYtaxo0AqG4opcbRfMJhmri5i/DDeWh8ZKehV
 dlwpLVyrTbM/RL/b9neEnli1qNn5K9jbOqfDeAhFZdEke/IZTBAoEj8GRHbQjfnskLHh
 ey1Vmjg2R0gOkOb+DTm4WpvbrSxZzPQ2TWkoS66UhaCYGXvMcDN82LEA0npGygzOUBCn
 JVNoZ2HTnZAOAi+0tdtlHZxZQzQ/28E9X85FUrVN092gXTIoa+LtiV9G2itmw+aFF2Nt
 DZ9wwJ+N1Rnb6HodtEgv9QC8+ZZc0dYdIBN87pAFt0bsH5osyG3d2oZnBHD9S5+tUx4e zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgcc84grj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Nov 2021 16:47:49 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AMGRaRu021094;
        Mon, 22 Nov 2021 16:47:48 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgcc84gr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Nov 2021 16:47:48 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AMGgCQK020930;
        Mon, 22 Nov 2021 16:47:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3cern9fqas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Nov 2021 16:47:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AMGliGu32244176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 16:47:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A824042049;
        Mon, 22 Nov 2021 16:47:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E88A4203F;
        Mon, 22 Nov 2021 16:47:44 +0000 (GMT)
Received: from [9.145.56.120] (unknown [9.145.56.120])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Nov 2021 16:47:44 +0000 (GMT)
Message-ID: <12d0d06b-8337-401e-fb87-e9c4e423cc11@linux.ibm.com>
Date:   Mon, 22 Nov 2021 17:47:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH RFC net] net/smc: Ensure the active closing peer first
 closes clcsock
Content-Language: en-US
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20211116033011.16658-1-tonylu@linux.alibaba.com>
 <9af1f859-0299-d1d7-d5ce-af46cf102025@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <9af1f859-0299-d1d7-d5ce-af46cf102025@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0TDTzXSvd3wR-VAU_8LaqnY3rx2sSrA2
X-Proofpoint-GUID: oe566AgnXUD1EcdSLYlGZ70ng--0mPFH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-22_08,2021-11-22_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/11/2021 17:19, Karsten Graul wrote:
> On 16/11/2021 04:30, Tony Lu wrote:
>> We found an issue when replacing TCP with SMC. When the actively closed
>> peer called close() in userspace, the clcsock of peer doesn't enter TCP
>> active close progress, but the passive closed peer close it first, and
>> enters TIME_WAIT state. It means the behavior doesn't match what we
>> expected. After reading RFC7609, there is no clear description of the
>> order in which we close clcsock during close progress.
> 
> Thanks for your detailed description, it helped me to understand the problem.
> Your point is that SMC sockets should show the same behavior as TCP sockets
> in this situation: the side that actively closed the socket should get into
> TIME_WAIT state, and not the passive side. I agree with this.
> Your idea to fix it looks like a good solution for me. But I need to do more
> testing to make sure that other SMC implementations (not Linux) work as
> expected with this change. For example, Linux does not actively monitor the 
> clcsocket state, but if another implementation would do this it could happen
> that the SMC socket is closed already when the clcsocket shutdown arrives, and
> pending data transfers are aborted.
> 
> I will respond to your RFC when I finished my testing.
> 
> Thank you.
> 

Testing and discussions are finished, the patch looks good.
Can you please send your change as a patch to the mailing list?
