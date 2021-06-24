Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44AC3B39C5
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 01:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhFXXgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 19:36:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47736 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229521AbhFXXgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 19:36:17 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15ONWi10077015
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 19:33:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3tEh2g6jL5viEuIoi0WraHJRSJFC2aiq9O6Vk0xsaGE=;
 b=JSrmOVXNgxiZ6pS8FvutByFXUCuBCf024iDHv4ICchw3pfj0X7i/Pm0Wdl42fVet5DvD
 8swrjoD6SMY+rdQ4jk1mZAAfwIjPO2o+IAwvnpxX1kSwxbthIoIyY6hu+YvkaCcxfwvU
 y8vOER39s18AGnIk2PLAUDjCIoU6zQmmpk34FzANTYtlImF/RLa0QaKRmU2uFIelVFy3
 zdeqTlhbkMkkUWrNiWXVWVlY0/Qw9tPZbmLoUzc332P+ax9HZpHUwqlJroGXFx/6yA6L
 TlgWdGnPdZeQLUd92BwrjuuMKnbg3FDw6zjc918MZvb1UgPyIxe+QeXgWOW0W1VO78gh OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39d23qjuxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 19:33:57 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15ONXRdE078564
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 19:33:56 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39d23qjuxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 19:33:56 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15ONSIlE018234;
        Thu, 24 Jun 2021 23:33:56 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 399wjh0ehk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 23:33:56 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15ONXshV10027784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 23:33:54 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E1302805C;
        Thu, 24 Jun 2021 23:33:54 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF2382805A;
        Thu, 24 Jun 2021 23:33:52 +0000 (GMT)
Received: from [9.160.66.172] (unknown [9.160.66.172])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 23:33:52 +0000 (GMT)
Subject: Re: [PATCH net 2/7] Revert "ibmvnic: remove duplicate napi_schedule
 call in open function"
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Johaan Smith <johaansmith74@gmail.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Networking <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Abdul Haleem <abdhalee@in.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
 <20210624041316.567622-3-sukadev@linux.ibm.com>
 <CAJAjEthEoZk8LLWhhwMaTy0nrh5qaeY6ouUu--Uv2D_Zr+1pug@mail.gmail.com>
 <fcabc0b3-8b1f-3690-37ca-047ea34101e2@linux.vnet.ibm.com>
 <CAOhMmr5M9HD=io2pDYtWasePcvh_RD0K7-PrQj2M=MqCbX5D5Q@mail.gmail.com>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
Message-ID: <716aa2f6-9d2f-1892-f0b9-0bd8999036e4@linux.vnet.ibm.com>
Date:   Thu, 24 Jun 2021 16:33:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAOhMmr5M9HD=io2pDYtWasePcvh_RD0K7-PrQj2M=MqCbX5D5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Snj5Vqa3CA1PLJjTs3dKyL9XwC6TURgh
X-Proofpoint-GUID: 62Jw9Dmm-RqfH8Nowd0ZM_tFLVeKW0r_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_17:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/21 10:05 AM, Lijun Pan wrote:

> With this reverted patch, there are lots of errors after bringing
> device down then up, e.g.,
> "ibmvnic 30000003 env3: rx buffer returned with rc 6".

Ok, thanks.  Can you provide some more details about your test?  When you
ran this test, did you include the rest of the patches in this series,
only some, or no others at all?  I assume it was based on the contents
of net from 6/23 or 6/24 - is that correct? Can you also describe the
hardware you ran your test on?  And lastly, would you briefly describe
the nature of your test?

The message you quoted is only seen with debug turned on, and as Dany
remarked, can be expected and normal in some recovery situations. It's
always possible you've found a case undetected by our testing, so the
above information can help us better understand what you saw.


