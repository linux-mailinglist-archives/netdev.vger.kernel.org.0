Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA3D482FF3
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 11:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiACKhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 05:37:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54644 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232613AbiACKhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 05:37:08 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2039Z9eB010679;
        Mon, 3 Jan 2022 10:37:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=L6gnBtTa29lp+SbM5nXGEwrNiEALsBmqklynGdNwDww=;
 b=R3O7XXFDP7jsJs7pomAgY452GJ0NTeldxG2JondCzWEklFVzN6T511BsPYCY/CGWR4cp
 ryDP1ao9+o4ZlcdgqS3H5IQxMCQtLBErZ1mPlwygU5VFEV1Y4QVVwue4QFPsGfK+LV59
 8HiCUFECkVWQ050t7X5HLG3QsH876ty8SG3z5SPF1glFKoewYcryvSys1P/NdUJR8G3a
 BbsOBOYnYdxR6N+FYzjIigMavYk7IJAmDhzl0Mbii9uNUoMiJuJuD5/qyNbiS84HgeKE
 fnk0Q/Cd4D6mGNvtj6k0L/cr60uroAFPeDwPWLBWCDxuhZH1O+i/Av6DAroccqAnGlve lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dbu8hcq9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:37:04 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 203AFPEe017414;
        Mon, 3 Jan 2022 10:37:03 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dbu8hcq90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:37:03 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 203AZqv4007437;
        Mon, 3 Jan 2022 10:37:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3dae7j98w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:37:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 203AaxQY42926368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jan 2022 10:36:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7448111C04C;
        Mon,  3 Jan 2022 10:36:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06D6811C054;
        Mon,  3 Jan 2022 10:36:59 +0000 (GMT)
Received: from [9.145.23.206] (unknown [9.145.23.206])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jan 2022 10:36:58 +0000 (GMT)
Message-ID: <4df6c3c1-7d52-6bfa-9b0d-365de5332c06@linux.ibm.com>
Date:   Mon, 3 Jan 2022 11:36:58 +0100
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
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <0a972bf8-1d7b-a211-2c11-50e86c87700e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: X0VNqdVrecSq5SHgwfoMQhqhHdlwllQF
X-Proofpoint-GUID: CV3RVH7PFAxp8IYO_7ZAj3vcc_3hYzc1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-03_03,2022-01-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201030068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/12/2021 10:44, Wen Gu wrote:
> On 2021/12/29 8:56 pm, Karsten Graul wrote:
>> On 28/12/2021 16:13, Wen Gu wrote:
>>> We encountered some crashes caused by the race between the access
>>> and the termination of link groups.
> What do you think about it?
> 

Hi Wen,

thank you, and I also wish you and your family a happy New Year!

Thanks for your detailed explanation, you convinced me of your idea to use
a reference counting! I think its a good solution for the various problems you describe.

I am still thinking that even if you saw no problems when conn->lgr is not NULL when the lgr
is already terminated there should be more attention on the places where conn->lgr is checked.
For example, in smc_cdc_get_slot_and_msg_send() there is a check for !conn->lgr with the intention
to avoid working with a terminated link group.
Should all checks for !conn->lgr be now replaced by the check for conn->freed ?? Does this make sense?
