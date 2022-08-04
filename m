Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA10589986
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 10:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbiHDIxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 04:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiHDIxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 04:53:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18FB28D;
        Thu,  4 Aug 2022 01:53:49 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2748p6pO024554;
        Thu, 4 Aug 2022 08:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=D3RScZ2Gz+x6y+5VrVCyPitDchg0u4b2/eIGVjzJ54E=;
 b=rKa5yw1Suu464/aG7HVIDx1erWVE4SqTR5pNA8s8x7QYmIQ3d74vNO58FL4xFFmnhkZY
 iUoXzEVp8W+uNLfIISto4EjCy5mpQTB7xgbfoOt0mBsL8Baw8fGhg9dnxIIbUZoZIwPq
 zbK+w76CA9MyCteFuhnGjNnVvTixWwm58HHxKaOINqDhoG1uOX5876up2BWNvRnT7XEo
 px5zaA085O9eOqGtwEfy8EqjVBRPSXlpIFdvQbiZddHxJqizqE7LwmplrrajxOLYoFSN
 19k+tlS08/c3fDMzs2IRmGONl5gfJ0MEDWmsydDP0hsfGssPRuid4Ozm/OXRy4QvrhgS /A== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hraycg1b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 08:53:39 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2748pjNp000353;
        Thu, 4 Aug 2022 08:53:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3hmv98wt2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 08:53:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2748rYtQ29426136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Aug 2022 08:53:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 748CD4C046;
        Thu,  4 Aug 2022 08:53:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33C944C044;
        Thu,  4 Aug 2022 08:53:34 +0000 (GMT)
Received: from [9.152.224.235] (unknown [9.152.224.235])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Aug 2022 08:53:34 +0000 (GMT)
Message-ID: <dae87dee-67b0-30ce-91c0-a81eae8ec66f@linux.ibm.com>
Date:   Thu, 4 Aug 2022 10:53:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net 1/2] s390/qeth: update cached link_info for ethtool
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
References: <20220803144015.52946-1-wintera@linux.ibm.com>
 <20220803144015.52946-2-wintera@linux.ibm.com> <YuqR8HGEe2vWsxNz@lunn.ch>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <YuqR8HGEe2vWsxNz@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0oCgcR0ZRd-ZjGrKp844gD_t3J5B25Po
X-Proofpoint-ORIG-GUID: 0oCgcR0ZRd-ZjGrKp844gD_t3J5B25Po
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 impostorscore=0 clxscore=1015 spamscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2208040036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03.08.22 17:19, Andrew Lunn wrote:
> On Wed, Aug 03, 2022 at 04:40:14PM +0200, Alexandra Winter wrote:
>> Speed, duplex, port type and link mode can change, after the physical link
>> goes down (STOPLAN) or the card goes offline
> 
> If the link is down, speed, and duplex are meaningless. They should be
> set to DUPLEX_UNKNOWN, SPEED_UNKNOWN. There is no PORT_UNKNOWN, but
> generally, it does not change on link up, so you could set this
> depending on the hardware type.
> 
> 	Andrew

Thank you Andrew for the review. I fully understand your point.
I would like to propose that I put that on my ToDo list and fix
that in a follow-on patch to net-next.

The fields in the link_info control blocks are used today to generate
other values (e.g. supported speed) which will not work with *_UNKNOWN,
so the follow-on patch will be more than just 2 lines.
These 2 patches under review are required to solve a recovery problem, 
so I would like them to go to net asap.

Would that be ok for you?
