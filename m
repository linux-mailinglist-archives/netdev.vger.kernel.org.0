Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3975D1B585C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 11:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgDWJjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 05:39:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47520 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726661AbgDWJjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 05:39:53 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03N93UvH025760
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 05:39:52 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30k3xu858u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 05:39:51 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Thu, 23 Apr 2020 10:39:01 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 Apr 2020 10:38:56 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03N9ca9J64356722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 09:38:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08E76A405B;
        Thu, 23 Apr 2020 09:39:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88239A4060;
        Thu, 23 Apr 2020 09:39:43 +0000 (GMT)
Received: from oc5311105230.ibm.com (unknown [9.145.18.72])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Apr 2020 09:39:43 +0000 (GMT)
Subject: Re: [PATCH rdma-next] RDMA: Allow ib_client's to fail when add() is
 called
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org,
        Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
        rds-devel@oss.oracle.com,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        target-devel@vger.kernel.org
References: <20200421172440.387069-1-leon@kernel.org>
From:   Ursula Braun <ubraun@linux.ibm.com>
Date:   Thu, 23 Apr 2020 11:39:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421172440.387069-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042309-0016-0000-0000-00000309C8DA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042309-0017-0000-0000-0000336DE989
Message-Id: <8ee742d7-952b-b521-d05c-17de601f6e32@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_06:2020-04-22,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1011
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/20 7:24 PM, Leon Romanovsky wrote:
> From: Jason Gunthorpe <jgg@mellanox.com>
> 
> When a client is added it isn't allowed to fail, but all the client's have
> various failure paths within their add routines.
> 
> This creates the very fringe condition where the client was added, failed
> during add and didn't set the client_data. The core code will then still
> call other client_data centric ops like remove(), rename(), get_nl_info(),
> and get_net_dev_by_params() with NULL client_data - which is confusing and
> unexpected.
> 
> If the add() callback fails, then do not call any more client ops for the
> device, even remove.
> 
> Remove all the now redundant checks for NULL client_data in ops callbacks.
> 
> Update all the add() callbacks to return error codes
> appropriately. EOPNOTSUPP is used for cases where the ULP does not support
> the ib_device - eg because it only works with IB.
> 
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/core/cm.c                  | 24 ++++++++++--------
>  drivers/infiniband/core/cma.c                 | 23 +++++++++--------
>  drivers/infiniband/core/device.c              | 16 ++++++++++--
>  drivers/infiniband/core/mad.c                 | 17 ++++++++++---
>  drivers/infiniband/core/multicast.c           | 12 ++++-----
>  drivers/infiniband/core/sa_query.c            | 22 ++++++++--------
>  drivers/infiniband/core/user_mad.c            | 22 ++++++++--------
>  drivers/infiniband/core/uverbs_main.c         | 24 +++++++++---------
>  drivers/infiniband/ulp/ipoib/ipoib_main.c     | 15 ++++-------
>  .../infiniband/ulp/opa_vnic/opa_vnic_vema.c   | 12 ++++-----
>  drivers/infiniband/ulp/srp/ib_srp.c           | 21 ++++++++--------
>  drivers/infiniband/ulp/srpt/ib_srpt.c         | 25 ++++++++-----------
>  include/rdma/ib_verbs.h                       |  2 +-
>  net/rds/ib.c                                  | 21 ++++++++++------
>  net/smc/smc_ib.c                              | 10 +++-----
>  15 files changed, 142 insertions(+), 124 deletions(-)
> 

For the net/smc part:
Acked-by: Ursula Braun <ubraun@linux.ibm.com>

