Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DD74A489C
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379139AbiAaNtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:49:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379136AbiAaNtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 08:49:13 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VDcnUU015318;
        Mon, 31 Jan 2022 13:49:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Sxh7o1iAKLCMsfWCRBQwf9so06hyTCNc37KOGh7foHY=;
 b=BV2eW+3pPWeCxJOxN/Lju5kUqd+snBvwcevFdo0dC5sOe248x/l55zGafWZn5dKwxnOu
 6wvFJAmnJI5eMApq8y3hw9TWiWFDCPs76vKENt4API9+7TaCTncSGLD6XrZonLaIT3+E
 JbamMhjUwsY2NiwIk4vA6ler0FPloUhYaayUNxWzAR+mUFz8by3D1xLtM03FQrD5+2f2
 +nTc5bA7cEK99WvZe5SmJB6+RAoNw0tU3WYL8zKLViFAWnRDd22NhtbbTF28s9EBbXoQ
 P9e1copgLsRawR0ZaSQaoNhFGCKwIh+oxqTvjAvkLrKDvMk4X9QVnGipS6QB9TD4LgnE FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dx66bb7qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 13:49:03 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20VDeg4t025665;
        Mon, 31 Jan 2022 13:49:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dx66bb7p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 13:49:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VDmBbp007404;
        Mon, 31 Jan 2022 13:49:00 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3dvw79byc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 13:49:00 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VDmwGM12517878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 13:48:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 915A511C050;
        Mon, 31 Jan 2022 13:48:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EDDC11C052;
        Mon, 31 Jan 2022 13:48:58 +0000 (GMT)
Received: from [9.145.79.147] (unknown [9.145.79.147])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 13:48:58 +0000 (GMT)
Message-ID: <521e3f2a-8b00-43d4-b296-1253c351a3d2@linux.ibm.com>
Date:   Mon, 31 Jan 2022 14:49:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/4] net/smc: Add netlink net namespace support
Content-Language: en-US
To:     "Dmitry V. Levin" <ldv@altlinux.org>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-api@vger.kernel.org
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
 <20211228130611.19124-3-tonylu@linux.alibaba.com>
 <20220131002453.GA7599@altlinux.org>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220131002453.GA7599@altlinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Q4L5XAycyIYWTBb2iAa0tMTYqsCrYQyi
X-Proofpoint-ORIG-GUID: 0hntWQwo8aXJg7QmSotzx_D0sS_ptxr4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_05,2022-01-31_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 impostorscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201310088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/01/2022 01:24, Dmitry V. Levin wrote:
> On Tue, Dec 28, 2021 at 09:06:10PM +0800, Tony Lu wrote:
>> This adds net namespace ID to diag of linkgroup, helps us to distinguish
>> different namespaces, and net_cookie is unique in the whole system.
>>
> 
> I'm sorry but this is an ABI regression.
> 
> Since struct smc_diag_lgrinfo contains an object of type "struct smc_diag_linkinfo",
> offset of all subsequent members of struct smc_diag_lgrinfo is changed by
> this patch.
> 
> As result, applications compiled with the old version of struct smc_diag_linkinfo
> will receive garbage in struct smc_diag_lgrinfo.role if the kernel implements
> this new version of struct smc_diag_linkinfo.
> 

Good catch! This patch adds 2 ways to provide the net_cookie to user space, one is over the new
netlink interface, and the other is using the old smc_diag way. 
Imho to use the new netlink interface is good enough, there is no need to touch the smc_diag ABI.
We already started adding new fields to the netlink interface only, this flexibility is 
the reason why we added this interface initially.

So a patch that removes
	__aligned_u64	net_cookie;
and
	.lnk[0].net_cookie = net->net_cookie,
should solve the issue. 

Thoughts?
