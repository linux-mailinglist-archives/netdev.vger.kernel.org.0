Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A0F48B130
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343588AbiAKPqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:46:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4452 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349554AbiAKPqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 10:46:45 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BEr320009999;
        Tue, 11 Jan 2022 15:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bmZkRCTW56iytS7KkqBciUVdH1HMRyfkjpT+RB5LSys=;
 b=r22l5XAwWnGwxbgSA5pXgJhXrwHCEnMI4uqSqakWWOSOo0K8QBOnjMv+NJbUtHLJR8mn
 xDwLgSSLFLj8nhbgw2ozip3jRTDKfB2Y4Cl3ZZfCe98+ZT2YqQg5DkbP1Gd+wwE42Ba6
 dryZcx9xBqQkFggPLtj6PFL6mu2+12Vst6YHckFd8Yv1kelkhbBa+6Fe+wxPdUYZ9xmc
 A3e8q1o+ILfe76WPkhrTDqFbXBIC5lSzM5RRblXqJTfFrJEWxInHpjgO8Q6kEuuIghYP
 RmlfmKod1sqoEFWAfkP0kOS0Tgm/8hxTyby4fOC9i62bIW+qPeNlZpXA75WY7sko9gyf pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfmjf11v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 15:46:41 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BFVfCT016609;
        Tue, 11 Jan 2022 15:46:41 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfmjf11ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 15:46:41 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BFkXlY018403;
        Tue, 11 Jan 2022 15:46:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3df289ff4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 15:46:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BFkbdv32506140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 15:46:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E94E84C05C;
        Tue, 11 Jan 2022 15:46:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F0A54C040;
        Tue, 11 Jan 2022 15:46:36 +0000 (GMT)
Received: from [9.145.30.70] (unknown [9.145.30.70])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 15:46:36 +0000 (GMT)
Message-ID: <3897d6e8-1191-b42b-9553-c2720f3a92eb@linux.ibm.com>
Date:   Tue, 11 Jan 2022 16:46:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net 1/3] net/smc: Resolve the race between link group
 access and termination
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641806784-93141-1-git-send-email-guwen@linux.alibaba.com>
 <1641806784-93141-2-git-send-email-guwen@linux.alibaba.com>
 <8b720956-c8fe-0fe2-b019-70518d5c60c8@linux.ibm.com>
 <ee973642-6bae-e748-cea9-ed18bca461f0@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <ee973642-6bae-e748-cea9-ed18bca461f0@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JREUA0uLOstrKskTKdjQ3kIwUHuU2IGT
X-Proofpoint-ORIG-GUID: xnT08N1T5Hlf1OLuWNN8Dcmjva-mJ1GW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201110090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2022 16:36, Wen Gu wrote:
> Thanks for your review.
> 
> On 2022/1/11 4:23 pm, Karsten Graul wrote:
>> On 10/01/2022 10:26, Wen Gu wrote:
>>> We encountered some crashes caused by the race between the access
>>> and the termination of link groups.
>>>
>>
>> These waiters (seaparate ones for smcd and smcr) are used to wait for all lgrs
>> to be deleted when a module unload or reboot was triggered, so it must only be
>> woken up when the lgr is actually freed.
> 
> Thanks for your reminding, I will move the wake-up code to __smc_lgr_free().
> 
> And maybe the vlan put and device put of smcd are also need to be moved
> to __smc_lgr_free()?, because it also seems to be more suitable to put these
> resources when lgr is actually freed. What do you think?

Keep the calls to smc_ism_put_vlan() and put_device() in smc_lgr_free(),
thats okay for SMC-D.
