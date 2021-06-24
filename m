Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326293B3584
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhFXSWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:22:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230450AbhFXSWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:22:21 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OI4Tg7177476
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 14:20:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=LZSrBu5uD3Dxvq65pmvEgaciBTXRidTEBQHKudKCEok=;
 b=T+KXTZiccSQF7RAnXzT2viQLajzx5Tv+AqBKn66FDJLmOV7KmHqyLmlhPCp39gyBbsw7
 0Rj9nrAxW8EGxIGMDBvEV2mmSLgkiZ0dLqtXd/5CMTxbfgWDJUJI/DogOh75sU8oCHsf
 XCvdPAaf98XCznUmPyA7awpY8kTvF/4pM97EtXmPtPT+i92g91vDCUoaBXf0TrgyBhMZ
 FyCpFbgRVDFQ75E3/pKb65t0WC4xCdXrx6ikpB2tS4mfdVh+puBb2T31n3OZAc4XRH9t
 Mo1SEs8YTlgIQHfNBrszHbZr/WOU481N8tlXd/nH7JK9iR3Ita5s0B7uyBDbXWc9sHEL bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39csk3dh5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 14:20:01 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15OI4ca7178410
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 14:20:01 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39csk3dh5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 14:20:01 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15OIGkb3010761;
        Thu, 24 Jun 2021 18:20:01 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 399879txtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 18:20:01 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15OIIvvE21758364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 18:18:57 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B9386A04F;
        Thu, 24 Jun 2021 18:18:57 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C09876A051;
        Thu, 24 Jun 2021 18:18:56 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 18:18:56 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Jun 2021 11:18:56 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Rick Lindsley <ricklind@linux.vnet.ibm.com>,
        Johaan Smith <johaansmith74@gmail.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Networking <netdev@vger.kernel.org>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Abdul Haleem <abdhalee@in.ibm.com>
Subject: Re: [PATCH net 2/7] Revert "ibmvnic: remove duplicate napi_schedule
 call in open function"
In-Reply-To: <CAOhMmr5M9HD=io2pDYtWasePcvh_RD0K7-PrQj2M=MqCbX5D5Q@mail.gmail.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
 <20210624041316.567622-3-sukadev@linux.ibm.com>
 <CAJAjEthEoZk8LLWhhwMaTy0nrh5qaeY6ouUu--Uv2D_Zr+1pug@mail.gmail.com>
 <fcabc0b3-8b1f-3690-37ca-047ea34101e2@linux.vnet.ibm.com>
 <CAOhMmr5M9HD=io2pDYtWasePcvh_RD0K7-PrQj2M=MqCbX5D5Q@mail.gmail.com>
Message-ID: <34b5d395531d0e1bee47c87961ccbc1e@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ssfkiGQ5PINycvyQLFrc7q96Tu5B6vAw
X-Proofpoint-ORIG-GUID: J0g-LVeLckYEj7dSwCgLuFHdqUtieIox
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_12:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=997 clxscore=1015
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106240099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-24 10:05, Lijun Pan wrote:
> On Thu, Jun 24, 2021 at 2:29 AM Rick Lindsley
> <ricklind@linux.vnet.ibm.com> wrote:
>> 
>> On 6/24/21 12:02 AM, Johaan Smith wrote:
>> > On Wed, Jun 23, 2021 at 11:17 PM Sukadev Bhattiprolu
>> 
>> > Sometimes git bisect may lead us to the false positives. Full investigation is
>> > always the best solution if it is not too hard.
>> 
>> I'd be happy to view evidence that points at another patch, if someone 
>> has some.
>> But the original patch did not address any observed problem:
>> 
>>       "So there is no need for do_reset to call napi_schedule again
>>        at the end of the function though napi_schedule will neglect
>>        the request if napi is already scheduled."
>> 
>> Given that it fixed no problem but appears to have introduced one, the 
>> efficient
>> action is to revert it for now.
>> 
> 
> With this reverted patch, there are lots of errors after bringing
> device down then up, e.g.,
> "ibmvnic 30000003 env3: rx buffer returned with rc 6".
> That seems something wrong with the handling of set_link_state
> DOWN/UP. It is either the communication protocol or the VIOS itself.

Did the driver bring the link back up with the patch is reverted? When 
link is down, vnic server returns rx buffers back to the client. This 
error message is printed when debug is turned on, driver's way to log 
what happened.
