Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A59C6033B3
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 22:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJRUB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 16:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJRUBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 16:01:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A2F54CA8
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 13:01:24 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IJhEgU003396;
        Tue, 18 Oct 2022 20:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=x+FnEvrkKJxfYASXMmNWZDXrT40Mpa21Vskcm/i9GGw=;
 b=a+6zUxFi94sxEhZB8wQE67VmNAiamvYMtPh+yH5LyMIEoO7/xBquN43zI0ZMgv4Yqle8
 KDsJsPJGLEFx0WlDfvNqZkfvHIsDEZlzNsNLO7NjyHCisTFslCQMt2nQlgdudJA2NWaN
 HRmF4LBIxmCVnwUOBbrDQiyN1u9LC0X8kTHojJndsh8BEKm/RtRd1A4xPC1aeoT86g9T
 9WGDgeeMCA/0J8vxtD8CeFVNpXgHdHBNuL8so1jXRkhnKBR0SgfcqtjlwT1DLarNgktq
 7uzHvq1Wg2UhJpYHG9arT8Q8QJXUyj5Nmh4xxq1t4ZwHJ0aTB95e+x9GBfPm7affl4VR SQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ka2hy0eqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 20:01:18 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29IJpOdN020960;
        Tue, 18 Oct 2022 20:01:17 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 3k7mgb3umb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 20:01:17 +0000
Received: from smtpav01.dal12v.mail.ibm.com ([9.208.128.133])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29IK1Cgx45416924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 20:01:13 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A840458063;
        Tue, 18 Oct 2022 20:01:14 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 215995806B;
        Tue, 18 Oct 2022 20:01:14 +0000 (GMT)
Received: from [9.160.6.192] (unknown [9.160.6.192])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Oct 2022 20:01:14 +0000 (GMT)
Message-ID: <0665e241-fd76-8f2b-55d2-ab2df478962d@linux.ibm.com>
Date:   Tue, 18 Oct 2022 15:01:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH net-next] ibmvnic: Free rwi on reset success
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com,
        Rick Lindsley <ricklind@us.ibm.com>, haren@linux.ibm.com
References: <20221017151516.45430-1-nnac123@linux.ibm.com>
 <20221018114502.1d976043@kernel.org>
From:   Nick Child <nnac123@linux.ibm.com>
In-Reply-To: <20221018114502.1d976043@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8eu1dqF51TG9PXt8MZkHJiex-u00PFtS
X-Proofpoint-GUID: 8eu1dqF51TG9PXt8MZkHJiex-u00PFtS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 mlxscore=0 spamscore=0 phishscore=0 mlxlogscore=856 adultscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

Thanks for the review.

On 10/18/22 13:45, Jakub Kicinski wrote:
> On Mon, 17 Oct 2022 10:15:16 -0500 Nick Child wrote:
>> Subject: [PATCH net-next] ibmvnic: Free rwi on reset success
> 
> Why net-next? it's a fix, right? it should go to Linus in the current
> release cycle, i.e. the next -rc release.

Apologies, I must have misunderstood when to use net vs net-next.
The bug has been around since v5.14 so I did not want to clutter
net inbox with things not directly relevant to v6.1.
Would you like me to resend with the `net` tag?

> Please make sure to CC the authors of the change under Fixes, and
> the maintainers of the driver. ./scripts/get_maintainer is your friend.

The ibmvnic list of maintainers is due for an update. I have added the 
current team to the CC list. We will have a patch out soon to update 
MAINTAINERS.

Thanks again. Apologies for any confusion,
Nick Child
