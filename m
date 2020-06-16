Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F931FA678
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 04:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgFPCfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 22:35:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60192 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgFPCfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 22:35:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G2XO3o113632;
        Tue, 16 Jun 2020 02:35:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aTxlffeYbsav4TKF61JSLE79Yzdwqgu+FksLc1C2joA=;
 b=mVk/6UZnYuwxUS8C89UzmYgP5FGltWyV/NW6Aguh2Mzo3FNzrAqQ6GDit0PyKmM5jI/O
 MEU6a1rUq/Or9m2qZIFmOEPjB2NqAbXX8yv18bW29I6Ovo04x6NrmaEyUbaezbF3pbJT
 CyiI724rGkrNxlQwT2tEGcr8xSXq6CzA5OYYchR/gdpzUZVZQT/TiknC6kWqjOoNgj0b
 6xkidFsPr/OSTvm6G8s0MEDKGpTQWFK1xC8skzGRoCRTHmBUm35i2DNKO0R4cSbY7CV1
 NZnpD/Z23Ks0jTgCR2iXb8WDAXAuwWU3oHnjHpkRzcNuGHvSp8jmJiaOzRtIySyges/t fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31p6e7v5x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 02:35:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G2T2ps024585;
        Tue, 16 Jun 2020 02:33:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31p6s6fbxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 02:33:29 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05G2XRJG005968;
        Tue, 16 Jun 2020 02:33:28 GMT
Received: from [10.74.110.250] (/10.74.110.250)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 19:33:27 -0700
Subject: Re: [PATCH v3 03/13] RDMA/rds: Remove FMR support for memory
 registration
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        aron.silverton@oracle.com, Max Gurtovoy <maxg@mellanox.com>,
        oren@mellanox.com, shlomin@mellanox.com, vladimirk@mellanox.com
References: <3-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
 <27824c0c-06ba-40dd-34c2-2888fe8db5c8@oracle.com>
 <20200529191248.GB21651@ziepe.ca>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <18e8c383-ceaa-a860-4a1c-2c92cfdd3c5a@oracle.com>
Date:   Mon, 15 Jun 2020 19:33:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200529191248.GB21651@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 clxscore=1011 malwarescore=0 suspectscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 cotscore=-2147483648 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160016
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/20 12:12 PM, Jason Gunthorpe wrote:
> On Thu, May 28, 2020 at 01:21:33PM -0700, santosh.shilimkar@oracle.com wrote:
>> On 5/28/20 12:45 PM, Jason Gunthorpe wrote:
>>> From: Max Gurtovoy <maxg@mellanox.com>
>>>
>>> Use FRWR method for memory registration by default and remove the ancient
>>> and unsafe FMR method.
>>>
>>> Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
>>> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
>>
>>>    net/rds/Makefile  |   2 +-
>>>    net/rds/ib.c      |  20 ++--
>>>    net/rds/ib.h      |   2 -
>>>    net/rds/ib_cm.c   |   4 +-
>>>    net/rds/ib_fmr.c  | 269 ----------------------------------------------
>>>    net/rds/ib_frmr.c |   4 +-
>>>    net/rds/ib_mr.h   |  14 +--
>>>    net/rds/ib_rdma.c |  28 ++---
>>>    8 files changed, 21 insertions(+), 322 deletions(-)
>>>    delete mode 100644 net/rds/ib_fmr.c
>>>
>> Patch looks accurate to me Jason/Max. I wanted to get few regression
>> tests run with it before providing the ack. Will send a note once
>> its tested ok.
> 
> Okay, since we are at the merge window I'm going to put it in
> linux-next to look for build regressions with the idea to send it on
> Thursday
> 
I know you sent this to net-next already but just to close the loop, 
regression testing went ok.

Regards,
Santosh
