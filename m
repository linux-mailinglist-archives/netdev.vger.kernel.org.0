Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4852E1923EB
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgCYJVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:21:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3626 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbgCYJVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:21:02 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02P94Hje097770
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 05:21:01 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywf3g3t6u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 05:21:00 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 25 Mar 2020 09:20:55 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 25 Mar 2020 09:20:52 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02P9Ks7M50987034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 09:20:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 946F14C04A;
        Wed, 25 Mar 2020 09:20:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56B9C4C044;
        Wed, 25 Mar 2020 09:20:54 +0000 (GMT)
Received: from [9.145.13.124] (unknown [9.145.13.124])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Mar 2020 09:20:54 +0000 (GMT)
Subject: Re: [PATCH net-next 01/11] s390/qeth: simplify RX buffer tracking
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
References: <20200324182448.95362-1-jwi@linux.ibm.com>
 <20200324182448.95362-2-jwi@linux.ibm.com>
 <20200324.164326.639594724461733845.davem@davemloft.net>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Date:   Wed, 25 Mar 2020 10:20:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324.164326.639594724461733845.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20032509-4275-0000-0000-000003B2A562
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032509-4276-0000-0000-000038C7E2D0
Message-Id: <30d06ab8-ee58-0c58-aab2-f68254d9a232@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_01:2020-03-23,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=987 impostorscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.03.20 00:43, David Miller wrote:
> From: Julian Wiedmann <jwi@linux.ibm.com>
> Date: Tue, 24 Mar 2020 19:24:38 +0100
> 
>> +#define QDIO_ELEMENT_NO(buf, element)	(element - &buf->element[0])
> 
> Maybe this works, but I would strongly suggest against using a CPP
> macro argument that is the same name for the singleton element on
> the left branch of the expression as the struct member name on
> the right side of the element.

Right you are, this would look a lot less fragile with some underscores.

> 
> Furthermore, as far as I can tell this is only used in one location
> in the code, and for such a simple expression that is excessive.
> 

This I flat out disagree with, but it's hardly worth arguing about.
So let me fold that macro back in, and send you a v2.

