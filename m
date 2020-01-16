Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDE013F99A
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgAPTed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:34:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60636 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729044AbgAPTed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 14:34:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GJSBGr087196;
        Thu, 16 Jan 2020 19:34:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=zaq5bjuDVHK2Ip36lrM60zZCTffAzRWmgtbay4+XA88=;
 b=HKRa7mchghmwxpuV+69AGdy4CNUG6bbPJ7Ql3ILDDQwshG/eALUJan7bYeILky4V/hDx
 TblN1buwNREcgIhCqifpwWoWF9MksdJfgElO5eSkyRif+6ZorpzesBWd5OVjVu6GcMGR
 /I2ikBtR0rxVOzUFJPGfT0s/k7z5PmZzki6qkb/lb4P1DSG04t8dFzdWM/GqILLz9wRn
 7Bjh+79G9mJY1MfYOvg9F/NTwN54uWuJe/2WTVbl41J6OhKAKp2uBpc5RfFSjJbSZ52l
 CXvN5NzqPM0xu/1NvkNCWiV3LWrW6PnTNDGU3RQj9aE8sL1Uk4hnoQvlRYPMkaYsUiVL LQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73u4jvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 19:34:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GJTbHb029781;
        Thu, 16 Jan 2020 19:34:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xj1ax9f9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 19:34:21 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00GJYKAm017531;
        Thu, 16 Jan 2020 19:34:20 GMT
Received: from [10.159.236.118] (/10.159.236.118)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 11:34:20 -0800
Subject: Re: [PATCH mlx5-next 00/10] Use ODP MRs for kernel ULPs
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
 <20200116065926.GD76932@unreal> <20200116135701.GG20978@mellanox.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <6ef540ae-233f-50cd-d096-3eeae31410cc@oracle.com>
Date:   Thu, 16 Jan 2020 11:34:18 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200116135701.GG20978@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 5:57 AM, Jason Gunthorpe wrote:
> On Thu, Jan 16, 2020 at 06:59:29AM +0000, Leon Romanovsky wrote:
>>>   45 files changed, 559 insertions(+), 256 deletions(-)
>>
>> Thanks Santosh for your review.
>>
>> David,
>> Is it ok to route those patches through RDMA tree given the fact that
>> we are touching a lot of files in drivers/infiniband/* ?
>>
>> There is no conflict between netdev and RDMA versions of RDS, but to be
>> on safe side, I'll put all this code to mlx5-next tree.
> 
> Er, lets not contaminate the mlx5-next with this..
> 
> It looks like it applies clean to -rc6 so if it has to be in both
> trees a clean PR against -rc5/6 is the way to do it.
> 
> Santos, do you anticipate more RDS patches this cycle?
> 

Not for upcoming merge window afaik.
