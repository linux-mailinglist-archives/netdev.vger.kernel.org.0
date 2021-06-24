Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5170B3B289B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 09:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhFXHa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 03:30:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39184 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231434AbhFXHa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 03:30:56 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O7EN8O072764
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 03:28:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=f+zRFzm0n0FkTmahuxLiQ7nPCJipRR3iOSluTiELmus=;
 b=TsAdzxTfM+ff31pV/a8xlo6Eyc8tqaUPaYS/m1UAWl22hrrWoOuaETJe1cyK3NCbUmNy
 YVUAVufmUUGisnXUV03zc9u6xEnlPlV6eKSURr8oLUg8fhnn66PydsfosWNwVSEpd5Dp
 oxjaTVH2fPSDk3KVr2Z/qHT00avkeEucK5YhSA+ltMKOWXOxJX9n2GCDMZKOTDpxHxm1
 ZG+vKgYB5VtwpWxHXK/yiFGu1ibrNSvKrCHHp463Txro/aX3yDYLCVFtyVMxl0jgaPJW
 O/w4DvdfjbSPG48iZxZ2dvDatLSOru+AmAHmh+4JeO1XoKoeRSSet8y++aggYkMdHZ+o DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cnftrfmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 03:28:37 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15O7EudK074564
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 03:28:37 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cnftrfmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 03:28:37 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O7QjnQ016609;
        Thu, 24 Jun 2021 07:28:36 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 39987a8bj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 07:28:36 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O7SYfZ37552548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 07:28:34 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A3AAAE05C;
        Thu, 24 Jun 2021 07:28:34 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA1E6AE060;
        Thu, 24 Jun 2021 07:28:32 +0000 (GMT)
Received: from [9.160.66.172] (unknown [9.160.66.172])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 07:28:32 +0000 (GMT)
Subject: Re: [PATCH net 2/7] Revert "ibmvnic: remove duplicate napi_schedule
 call in open function"
To:     Johaan Smith <johaansmith74@gmail.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Abdul Haleem <abdhalee@in.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
 <20210624041316.567622-3-sukadev@linux.ibm.com>
 <CAJAjEthEoZk8LLWhhwMaTy0nrh5qaeY6ouUu--Uv2D_Zr+1pug@mail.gmail.com>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
Message-ID: <fcabc0b3-8b1f-3690-37ca-047ea34101e2@linux.vnet.ibm.com>
Date:   Thu, 24 Jun 2021 00:28:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAJAjEthEoZk8LLWhhwMaTy0nrh5qaeY6ouUu--Uv2D_Zr+1pug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: P_dfriUIN2NknV5hahtomHToWziVyAQX
X-Proofpoint-GUID: COQuKHH5_Zkam5Id7gzDQbW7PBPzRiy2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_06:2021-06-23,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 mlxscore=0 malwarescore=0 clxscore=1015 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240039
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/21 12:02 AM, Johaan Smith wrote:
> On Wed, Jun 23, 2021 at 11:17 PM Sukadev Bhattiprolu

> Sometimes git bisect may lead us to the false positives. Full investigation is
> always the best solution if it is not too hard.

I'd be happy to view evidence that points at another patch, if someone has some.
But the original patch did not address any observed problem:

      "So there is no need for do_reset to call napi_schedule again
       at the end of the function though napi_schedule will neglect
       the request if napi is already scheduled."

Given that it fixed no problem but appears to have introduced one, the efficient
action is to revert it for now.

