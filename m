Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9111A0FA
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 18:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfEJQIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 12:08:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56996 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbfEJQIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 12:08:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4AG8kGx027980;
        Fri, 10 May 2019 16:08:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=f9Iu5BW74cNrQC2968eienCBoLJX6Gai3wPhwPz7qFs=;
 b=atIWyzJuTUtRcA7gQrl7ckL8KpB9XBvqfY+XpYpSWe42WgDum9NA6zcPIz7SDGXnvF+n
 d6RAetcnNNGC5gQ833OnGDwN3lZhLkkq/bz0Zs1LSiuabaWS95DdAmCge509kCO9O3DS
 2aB3p1brgBgXpmZ9Rn5wCAH3+YJxrtRIpT8MPekkNGaLMkAzn4XQkweJtzQe6yaAGcwG
 jWEwMBQl6SA3GtXMjdeCmmtZ4Jc3v9YlEZyqB9T0mu/G3gpOGA16Po7yPCaG4Zv92O98
 h9oTu+DFDWsfxZ48mKVlS3w5mo9Hz7FSlB4Ak7vbl+eothVZ3DkDXeKlDFKlITjEGUOC mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2s94bgj4ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 16:08:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4AG8NuR117777;
        Fri, 10 May 2019 16:08:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2s94ahf6tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 16:08:45 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4AG8ili017499;
        Fri, 10 May 2019 16:08:45 GMT
Received: from [10.209.243.127] (/10.209.243.127)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 May 2019 09:08:44 -0700
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
 <20190510125431.GA15434@ziepe.ca>
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <8b00b41c-bbc5-7584-e5cf-519b0d9100c5@oracle.com>
Date:   Fri, 10 May 2019 09:11:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190510125431.GA15434@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905100110
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905100110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/2019 5:54 AM, Jason Gunthorpe wrote:
> On Mon, Apr 29, 2019 at 04:37:19PM -0700, Santosh Shilimkar wrote:
>> From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>>
>> RDS doesn't support RDMA on memory apertures that require On Demand
>> Paging (ODP), such as FS DAX memory. User applications can try to use
>> RDS to perform RDMA over such memories and since it doesn't report any
>> failure, it can lead to unexpected issues like memory corruption when
>> a couple of out of sync file system operations like ftruncate etc. are
>> performed.
> 
> This comment doesn't make any sense..
>
>> The patch adds a check so that such an attempt to RDMA to/from memory
>> apertures requiring ODP will fail.
>>
>> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
>> Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>>   net/rds/rdma.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/rds/rdma.c b/net/rds/rdma.c
>> index 182ab84..e0a6b72 100644
>> +++ b/net/rds/rdma.c
>> @@ -158,8 +158,9 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
>>   {
>>   	int ret;
>>   
>> -	ret = get_user_pages_fast(user_addr, nr_pages, write, pages);
>> -
>> +	/* get_user_pages return -EOPNOTSUPP for fs_dax memory */
>> +	ret = get_user_pages_longterm(user_addr, nr_pages,
>> +				      write, pages, NULL);
> 
> GUP is supposed to fully work on DAX filesystems.
>
Above comment has typo. Should have been
get_user_pages_longterm return -EOPNOTSUPP.

> You only need to switch to the long term version if the duration of
> the GUP is under control of user space - ie it may last forever.
>
> Short duration pins in the kernel do not need long term.
>
Thats true but the intention here is to use the long term version
which does check for the FS DAX memory. Instead of calling direct
accessor to check DAX memory region, longterm version of the API
is used

> At a minimum the commit message needs re-writing to properly explain
> the motivation here.
> 
Commit is actually trying to describe the motivation describing more of 
issues of not making the call fail. The code comment typo was
misleading.

Regards,
Santosh
