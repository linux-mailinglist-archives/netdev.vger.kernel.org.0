Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C38F3B2792
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhFXGpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:45:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbhFXGpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 02:45:20 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O6Y3mQ117639
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 02:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2eqQhSa4AlxWNHGRfHogtpOVPL+GF9xHeg7gM1a9PAU=;
 b=QGf7JaV8VdcT4qkrIJHp6ueWIzgaS88jYNYTFCTmRXSN2wXi/66xwja2OnVHtSDzltS8
 pyvmves/GEcOCYAV3eKWoEG3El4Fgg2utaKAR7Erqyd0Pw3vjT0lEQU2iSkbbU2ta4qi
 kSVbm145bmZjPED3DOoG3jQDLyebtzpiS7L3n9JIHwRkkLQ+aSJu6W3psrOkloNLQO21
 r5qJjJ93eGc6pB1H9uwDapBicptvRYzcJ22GblgZ+cx53sWKiRY+mnI0kM4hrG/OcDPQ
 Plpu2YMFObvmUUjJ9z44LC5vp2jMi6FjHcw3g1wcpLz9GGlw0v1c3YjHHTW4HuqzF17i bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cmkygutq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 02:43:01 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15O6YEdK118610
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 02:43:01 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cmkygutd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 02:43:01 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O6anAx016913;
        Thu, 24 Jun 2021 06:43:00 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 39987a80g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 06:43:00 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O6gwvw27394436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 06:42:58 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75912112064;
        Thu, 24 Jun 2021 06:42:58 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B0CA112063;
        Thu, 24 Jun 2021 06:42:57 +0000 (GMT)
Received: from [9.160.66.172] (unknown [9.160.66.172])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 06:42:57 +0000 (GMT)
Subject: Re: [PATCH net 2/7] Revert "ibmvnic: remove duplicate napi_schedule
 call in open function"
To:     Lijun Pan <lijunp213@gmail.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Abdul Haleem <abdhalee@in.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
 <20210624041316.567622-3-sukadev@linux.ibm.com>
 <CAOhMmr6USoB-yw1HduSWc1h2AGdS7U3+Ze9nBRh51pM=V2P8Kw@mail.gmail.com>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
Message-ID: <d46aba13-017a-fd08-e07d-06f526289f34@linux.vnet.ibm.com>
Date:   Wed, 23 Jun 2021 23:42:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAOhMmr6USoB-yw1HduSWc1h2AGdS7U3+Ze9nBRh51pM=V2P8Kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LeDvoqmzuV_5FWWA6yRfQMMOXDyloOyt
X-Proofpoint-ORIG-GUID: rh0-IZpbmYPZPy6v2YRyirSaJpcfbV-e
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_06:2021-06-23,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1011 priorityscore=1501 lowpriorityscore=0 mlxlogscore=833
 impostorscore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/21 11:20 PM, Lijun Pan wrote:
> On Wed, Jun 23, 2021 at 11:16 PM Sukadev Bhattiprolu

> It is very likely VIOS does not forward the rx packets so that the rx interrupt
> isn't raised.

On what do you base this position? Do you have some concrete data that indicates this?

As noted, bisect led us here.  With the previous patch applied, bug occurs.  With the previous patch removed, it does not.  As the description says, we are reverting the patch until it can be determined whether the problem is the patch itself or that the patch better magnifies some other problem.

Rick
