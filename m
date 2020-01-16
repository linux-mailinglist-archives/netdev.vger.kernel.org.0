Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A94C13D4E7
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 08:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgAPHW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 02:22:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38836 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgAPHW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 02:22:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G7EFP2064860;
        Thu, 16 Jan 2020 07:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ztPML10tVKhr4G3sZtMznvxCB8SCNkabYW6q7cNW/cE=;
 b=kNzT1aBzo2uJuvKeWRAVGSDZHnnQnbnoJCSD3eks2rWAoj75ix+13g7/c8UArqzfPdGW
 h8GdZ+cQTsXMQLrDdaD+sEvEYOrAi/L4Q3ERgrH+mZuHlNE2ehH4989IZfk551CH+4t1
 hpreZ/JTqM+4Zlf488i2UAKxRT6VPx20qbMtAE7zQ3xtEw+08th8G1cw3k4i5vRS2H/G
 IcyHWLP9VOP/SSp0UFM9K3iQsLvnVILuwpGoxkUjPWue4yLzBiBkWjx7DZZTFoDzQQqB
 qjEM8KDIYiZ3b7U3SUtCMXCUe5O5D6jomNVY3M+CWjvPPLfa2ABYt432mQq+G8IE5bPC XA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73yrpdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 07:22:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G7ECGD054105;
        Thu, 16 Jan 2020 07:22:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1atum3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 07:22:38 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G7MbYX024575;
        Thu, 16 Jan 2020 07:22:37 GMT
Received: from [192.168.86.20] (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 23:22:36 -0800
Subject: Re: [PATCH mlx5-next 09/10] net/rds: Handle ODP mr
 registration/unregistration
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
 <20200115124340.79108-10-leon@kernel.org>
 <3c479d8a-f98a-a4c9-bd85-6332e919bf35@oracle.com>
 <20200116071110.GE76932@unreal>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <f11e3c44-3e14-b840-6277-1820bba38952@oracle.com>
Date:   Wed, 15 Jan 2020 23:22:35 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200116071110.GE76932@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160060
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 11:11 PM, Leon Romanovsky wrote:
> On Wed, Jan 15, 2020 at 01:51:23PM -0800, santosh.shilimkar@oracle.com wrote:
>> On 1/15/20 4:43 AM, Leon Romanovsky wrote:
>>> From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>>>
>>> On-Demand-Paging MRs are registered using ib_reg_user_mr and
>>> unregistered with ib_dereg_mr.
>>>
>>> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>>> ---
>>
>> Have already reviewed this patchset on internal list. Couple of
>> minor nits below o.w patch looks good to me.
>>
>> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> 
> Thanks Santosh, Once, I'll figure the apply path for this series,
> I will add extra lines while applying the patches.
> 
Sure. Thanks for picking it up !!

Regards,
Santosh
