Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F61D3FD0A8
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241531AbhIABWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:22:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50546 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234036AbhIABWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:22:33 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18114OCQ130077
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=D0X68q7O+BwDnCuxvPKlI0nM0qYXGkdiQtNeaGwjt3s=;
 b=B3wH7Q8Kb/VGFj4mFpy+a5Gv0apWhXcotZkajrtjiivW5a7k+T9ySk9r+m5yvhzJcSuw
 kVV/KXsHc703BVhSE8U2sPK76FBkB7OMHyh3E5CoxyanP/uWv+Dnle4wK3Q08zygnUh6
 w3lu4wBbUo4w7l9g3h8Qh+ZQfg2hB7IdFR5RrurD+2J81E4iGFsWu9nbbQ0pi3pLcSbW
 RUYAG95AAu1rjLEHN8C1pw1sYa8+J5kSyujEk2W+TCZlewT6Tc5SHF6+LRR5pM0Zp3D/
 g2GNkBRoYfqBY3KLAlhVh2sAJ1Nu0x9fIUVrcEsVePNwIiVfT/XWllpmwebDmjXfPjSe NA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asxjwseqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:21:37 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1811CbUj028142
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 01:21:36 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 3aqcsdkd6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:21:36 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1811LZnE25559344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 01:21:35 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 125B5AC062;
        Wed,  1 Sep 2021 01:21:35 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00D3DAC05F;
        Wed,  1 Sep 2021 01:21:33 +0000 (GMT)
Received: from [9.160.191.242] (unknown [9.160.191.242])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 01:21:33 +0000 (GMT)
Subject: Re: [PATCH net-next 0/9] ibmvnic: Reuse ltb, rx, tx pools
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>, netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
Message-ID: <19897bfd-e13e-a32a-fd14-b4f0f7e47db1@linux.vnet.ibm.com>
Date:   Tue, 31 Aug 2021 18:21:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901000812.120968-1-sukadev@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Hj9C2zVOV1FQHFe_euet6_q3dJkL6maa
X-Proofpoint-GUID: Hj9C2zVOV1FQHFe_euet6_q3dJkL6maa
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010005
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/21 5:08 PM, Sukadev Bhattiprolu wrote:
> It can take a long time to free and reallocate rx and tx pools and long
> term buffer (LTB) during each reset of the VNIC. This is specially true
> when the partition (LPAR) is heavily loaded and going through a Logical
> Partition Migration (LPM). The long drawn reset causes the LPAR to lose
> connectivity for extended periods of time and results in "RMC connection"
> errors and the LPM failing.
> 
> What is worse is that during the LPM we could get a failover because
> of the lost connectivity. At that point, the vnic driver releases
> even the resources it has already allocated and starts over.
> 
> As long as the resources we have already allocated are valid/applicable,
> we might as well hold on to them while trying to allocate the remaining
> resources. This patch set attempts to reuse the resources previously
> allocated as long as they are valid. It seems to vastly improve the
> time taken for the vnic reset. We have also not seen any RMC connection
> issues during our testing with this patch set.
> 
> If the backing devices for a vnic adapter are not "matched" (see "pool
> parameters" in patches 8 and 9) it is possible that we will still free
> all the resources and allocate them. If that becomes a common problem,
> we have to address it separately.

We have spent a good amount of time going over this. Thans for all the work.

Reviewed-by:  Rick Lindsley <ricklind@linux.vnet.ibm.com>
