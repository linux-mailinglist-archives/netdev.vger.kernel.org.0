Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4115F48B42C
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344071AbiAKRms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:42:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242080AbiAKRmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:42:46 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BGSdPl017935;
        Tue, 11 Jan 2022 17:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=U9DKN7yJOm6yWmgJE4uAJHZUxcEBhqMocB7Ph9SjtzY=;
 b=og64v9yN27fgaLDxBvViJnOr1+559p2oy3W+hKFy5OrfwU/hgCOqWAvjmsxlVw84EF+W
 Qlch2iv6WgZBSGO+ADBtYpP+reAO06M+BCbuTWgI8Wd2H+QADBgbLyOTbdbOtLZ1afmE
 Kvt5DeT7OmsgavdyCuV9QZ5DpccZmTxHHbq01D5ubRlDHNJbhahnSDLVw7qtw7q4O6hQ
 5ro1BQaFcOmXNL7w4yYfNSbuZeWR4heZ01Ls/6eD9Fswmzwgluh5Pi+WLBAWlPnGtcmY
 lrMVwKzcM2NsiunVM3dwaciMBppjDce2j7wm4SHY9gTovoTWXGz7kZ+xIdCMf3/EvCIG rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhdeut2dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 17:42:42 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BHYoag031285;
        Tue, 11 Jan 2022 17:42:42 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhdeut2dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 17:42:42 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BHfsth019424;
        Tue, 11 Jan 2022 17:42:40 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3df289jepx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 17:42:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BHgcFb45154638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 17:42:38 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07BAA4C062;
        Tue, 11 Jan 2022 17:42:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92BE34C04A;
        Tue, 11 Jan 2022 17:42:37 +0000 (GMT)
Received: from [9.145.30.70] (unknown [9.145.30.70])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 17:42:37 +0000 (GMT)
Message-ID: <e0282429-49b3-c22c-fa02-81d2e1aee8d8@linux.ibm.com>
Date:   Tue, 11 Jan 2022 18:42:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net 3/3] net/smc: Resolve the race between SMC-R link
 access and clear
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641806784-93141-1-git-send-email-guwen@linux.alibaba.com>
 <1641806784-93141-4-git-send-email-guwen@linux.alibaba.com>
 <8f13aa62-6360-8038-3041-86fd51b40a3e@linux.ibm.com>
 <fa057e34-7626-2b19-2c2e-acd4999e7fe5@linux.alibaba.com>
 <b1882268-d8bb-eee9-8238-e30962928034@linux.ibm.com>
 <eecadb47-92f3-c4cc-64d2-3954474e3c5f@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <eecadb47-92f3-c4cc-64d2-3954474e3c5f@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: G5WsMFeNbOUszKYjsl24twe_5-sbAiWZ
X-Proofpoint-ORIG-GUID: mJVC8O5uzExzCsp5B8ZHb8w03Qkf2smh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 bulkscore=0 mlxscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2022 17:44, Wen Gu wrote:
> 
> 
> On 2022/1/12 00:02, Karsten Graul wrote:
>> On 11/01/2022 16:49, Wen Gu wrote:
>>>
>>> OK, I will correct this as well.
>>>
>>> And similarly I want to move smc_ibdev_cnt_dec() and put_device() to
>>> __smcr_link_clear() as well to ensure that put link related resources
>>> only when link is actually cleared. What do you think?
>>
>> I think that's a good idea, yes.
> 
> Thank you.
> 
> Not in a hurry, just want to ask should I send a v2 with these changes
> or continue to wait for subsequent review of v1?
> 

Yeah I think its time for a v2, thank you!

