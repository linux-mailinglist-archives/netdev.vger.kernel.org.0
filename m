Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05237B5874
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 01:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfIQXTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 19:19:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726201AbfIQXTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 19:19:11 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8HNIIse102734;
        Tue, 17 Sep 2019 19:19:04 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v37uca8ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 19:19:04 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8HNASKR031253;
        Tue, 17 Sep 2019 23:19:04 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 2v37jvgpps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 23:19:04 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8HNJ39932833842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 23:19:03 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35F66B2070;
        Tue, 17 Sep 2019 23:19:03 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE350B205F;
        Tue, 17 Sep 2019 23:19:02 +0000 (GMT)
Received: from juliets-mbp.austin.ibm.com (unknown [9.41.174.202])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 17 Sep 2019 23:19:02 +0000 (GMT)
Subject: Re: [PATCH v2 0/2] net/ibmvnic: serialization fixes
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
References: <20190917145249.15334-1-julietk@linux.vnet.ibm.com>
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
Message-ID: <c554bd78-2229-3c1c-3e12-071ad99ebcbb@linux.vnet.ibm.com>
Date:   Tue, 17 Sep 2019 18:19:02 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190917145249.15334-1-julietk@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-17_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909170218
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I sent v3.  Please disregard v2.

On 9/17/19 9:52 AM, Juliet Kim wrote:
> This series includes two fixes. The first improves reset code to allow 
> linkwatch_event to proceed during reset. The second ensures that no more
> than one thread runs in reset at a time. 
>
> v2: 
> - Separate change param reset from do_reset()
> - Return IBMVNIC_OPEN_FAILED if __ibmvnic_open fails 
> - Remove setting wait_for_reset to false from __ibmvnic_reset(), this 
>   is done in wait_for_reset()
> - Move the check for force_reset_recovery from patch 1 to patch 2
>
> Juliet Kim (2):
>   net/ibmvnic: unlock rtnl_lock in reset so linkwatch_event can run
>   net/ibmvnic: prevent more than one thread from running in reset
>
>  drivers/net/ethernet/ibm/ibmvnic.c | 244 ++++++++++++++++++++++++++-----------
>  drivers/net/ethernet/ibm/ibmvnic.h |   4 +
>  2 files changed, 180 insertions(+), 68 deletions(-)
>
