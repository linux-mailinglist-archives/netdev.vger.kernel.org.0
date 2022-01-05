Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12781485234
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 13:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239912AbiAEMEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 07:04:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28948 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235789AbiAEMEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 07:04:04 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205AQudV030985;
        Wed, 5 Jan 2022 12:03:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8ekGavIugjPa6LYUHy8qYzOXKFsHcVAlcT8IHbGLTZI=;
 b=mbiQPuOcBQU4nNdeRNe417TqF6eJ0B33XOvblI7HoFo2KAFtebAbbGg0JeiQ44F5xI2x
 XvkC+66AirdvZZC8ccKS0gt1oq1XmKnVZTqDQQpfjqUAAFBQeYO0/dLOOqiNuX1xszrx
 f8BWYbXbNSdHDq9LbuXQRjU6voM2ZobiWNQwQyfS+3F5nr+AiXokS6wpLQjkkPNPGcAA
 8s20WwVntqjHuGcoeTZfjdiMEUhuNxORbIVhCEWoAu6p0ZiGn+7f4+9qlpAm6Zh2R/cZ
 4lHrW24AT8Wx8Fq6YwW/ySRmcxW5pQmFF3V7eTotHgeD0WRnToGuO7qQb9Iac5McrPcB xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dcp2qx33w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 12:03:54 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 205BQlXQ026771;
        Wed, 5 Jan 2022 12:03:53 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dcp2qx32j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 12:03:53 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 205Bwfnm018500;
        Wed, 5 Jan 2022 12:03:51 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3daek9fxud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 12:03:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 205C3kXP48169430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jan 2022 12:03:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB9AC42042;
        Wed,  5 Jan 2022 12:03:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DD3E42041;
        Wed,  5 Jan 2022 12:03:45 +0000 (GMT)
Received: from [9.145.181.244] (unknown [9.145.181.244])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Jan 2022 12:03:45 +0000 (GMT)
Message-ID: <1cf77005-1825-0d34-6d34-e1b513c28113@linux.ibm.com>
Date:   Wed, 5 Jan 2022 13:03:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH net v2 1/2] net/smc: Resolve the race between link
 group access and termination
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
References: <1640704432-76825-1-git-send-email-guwen@linux.alibaba.com>
 <1640704432-76825-2-git-send-email-guwen@linux.alibaba.com>
 <4ec6e460-96d1-fedc-96ff-79a98fd38de8@linux.ibm.com>
 <0a972bf8-1d7b-a211-2c11-50e86c87700e@linux.alibaba.com>
 <4df6c3c1-7d52-6bfa-9b0d-365de5332c06@linux.ibm.com>
 <095c6e45-dd9e-1809-ae51-224679783241@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <095c6e45-dd9e-1809-ae51-224679783241@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gp85XTqucEud2GfaglwFtDO1nq0FEe96
X-Proofpoint-ORIG-GUID: 1zt-4_04UcxLrnN6tHohQWK5E1CQWzV7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_03,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201050081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/01/2022 09:27, Wen Gu wrote:
> On 2022/1/3 6:36 pm, Karsten Graul wrote:
>> On 31/12/2021 10:44, Wen Gu wrote:
>>> On 2021/12/29 8:56 pm, Karsten Graul wrote:
>>>> On 28/12/2021 16:13, Wen Gu wrote:
>>>>> We encountered some crashes caused by the race between the access
>>>>> and the termination of link groups.
> So I think checking conn->alert_token_local has the same effect with checking conn->lgr to
> identify whether the link group pointed by conn->lgr is still healthy and able to be used.

Yeah that sounds like a good solution for that! So is it now guaranteed that conn->lgr is always
set and this check can really be removed completely, or should there be a new helper that checks
conn->lgr and the alert_token, like smc_lgr_valid() ?
